---
title: "Self-Documenting Code Concept 3: Abstract functions and code patterns"
excerpt_separator: <!--more-->
tags: self-documenting-code
---

To reiterate, what do we want: to not read the docs, but still know everything the docs say.

Python is not strong on complex class structure with abstract properties and interfaces and singletons and such. Even so, we can still leverage the functionalities it does have to shape some straightforward code patterns. 

Code patterns are documentation, they are the boilerplate. They let you concentrate on the essence of your code change. The context has already been built, everybody is just waiting for you to implement the one main function (or two).

![Abstracts or generics](/assets/docs/abstract-or-generic.png)

<!--more-->

## Previous chapter
⏮️ [Self-Documenting Code Idea 2: Error msgs with calls to action]({% post_url 2025-05-05-self-documented-code-part-II %})


## 💡 Concept 3: Use abstract functions, interfaces, enforce code patterns

The Python community puts a heavy emphasis on simplicity. **You should use the simplest tool for every job.** 

Code patterns are not the simplest tool. So, you might deduce that code patterns are frowned upon. 

But they aren't. It _is_ wise to use the simplest tool for any job, but in a bigger codebase, **your job is also to share knowledge, to document**, to make your code maintainable (even after you inevitably leave the company). **And in this regard, code patterns _are_ one of the simplest tools to document your thoughts and intentions.**

**However, they do backfire sporadically, so that's something you should keep in mind.** It is a bit tricky to get them right. It is usually the cruel, fickle world that throws a wrench in your carefully laid-out code-pattern plans. You set everything up neatly, and 3 months later the requirements change in a destructive way. But, don't give up; practice makes perfect, just build your code patterns with a healthy dose of humility. 


## Example 1: Follow the steps, the road has been paved

Our scenario: we are fetching PR data from GitHub, all is going well. Now, we want to also support Bitbucket and GitLab. We basically have to copy-paste the GitHub code, because the other 2 APIs are essentially the same, we just need to modify a few lines of code. But then, we will need to maintain 3 copies of the same code, that seems silly. 

Solution: we create an abstract `BaseRestClient` class. In it we define the basic steps all providers have to follow to do HTTP requests and then just implement a bit of custom code in every subclass: `GitHubRestClient`, `BitbucketRestClient` and `GitLabRestClient`.

This approach is also called the "template design pattern".

Here's a code example, the pattern is in `BaseRestClient::make_request()` and works like so:

![BaseRestClient patter](/assets/docs/pattern-docs.png)

```py
from abc import ABC, abstractmethod
import requests
import dataclasses
from enum import StrEnum
from urllib.parse import urlencode

ResponseJSON = dict | list

@dataclasses.dataclass
class RestResponse:
    response: requests.Response
    response_data: ResponseJSON
    
@dataclasses.dataclass
class ProviderAccessData:
    rest_url: str  # url to the RESTful API
    ...

class HttpMethod(StrEnum):
    GET = "GET"
    ...
    

class BaseRestClient(ABC):

    def __init__(self, access_data: ProviderAccessData):
        # access_tokens is some sort of object that holds the tokens or whatever  else
        # that is needed so that we can actually make requests to GitHub, Bitbucket and GitLab
        self.access_data: ProviderAccessData = access_data
    
    def make_request(
        self,
        url_path: str,
        method: HttpMethod = HttpMethod.GET,
        *,
        query_params: dict | None = None,
        data: dict | None = None,
        json: dict | None = None,
    ) -> RestResponse:
        """
        ↓ Our magic pattern:
        
        Making a request has been broken into steps.
        Some steps are calling *abstract* methods, those steps
        NEED to be implemented differently for every provider.
        
        Other steps are made into functions just so, that the provider
        sub-classes are able to change then, if they need to.
        """
        full_url: str = self._build_full_url(url_path, query_params)
        session: requests.Session = self._get_session()

        response: requests.Response
        response_data: ResponseJSON
        # make_json_request() is a helper func that does the actual HTTP request
        # something like `session.request(method=method...)`, but with some 
        # extra functionality, like parsing the response into dict or list, etc.
        response, response_data = make_json_request(
            session,
            method.name,
            full_url,
            data=data,
            json=json,
        )
        response_data = self._process_response(response_data, response)
        return RestResponse(response=response, response_data=response_data)
    
    @abstractmethod
    def _get_session(self) -> requests.Session:
        """
        Return a session object with all the right credentials to make successful requests.
        """
        
    def _build_full_url(self, url_path: str, query_parameters: dict | None) -> str:
        """This is a hook for child classes to process the response data."""
        query_str = f"?{urlencode(query_parameters)}" if query_parameters else ""
        ...
        return f"{self.access_data.rest_url}{url_path}{query_str}"

    def _process_response(self, resp_data: dict | list, resp: requests.Response) -> ResponseJSON:
        """This is a hook for child classes to process the response data."""
        return resp_data
```

Now every provider has to just implement the functions where it is different from the general pattern. And this is very little code.

```py
import requests
from requests_oauthlib import OAuth1Session
import BaseRestClient


class GitHubRestClient(BaseRestClient):
    def _get_session(self) -> requests.Session:
        session = requests.Session()
        api_token: str = ...
        session.headers.update(dict(
            Accept="application/vnd.github.moondragon+json",
            Authorization=f"Bearer {api_token}",
        ))
        ...
        return session


class BitbucketRestClient(BaseRestClient):
    def _get_session(self) -> requests.Session:
        session = OAuth1Session(...)
        ...
        return session 

class GitLabRestClient(BaseRestClient):
    def _get_session(self) -> requests.Session:
        session = requests.Session()
        api_token: str = ...
        extra_headers: dict = ... # different for every customer
        session.headers.update(
            {**extra_headers, "PRIVATE-TOKEN": api_token},
        )
        ...
        return session
````

This gives us 2 delightful benefits:
- When a new provider needs to be supported, the dev instantly knows: "Ah, I just need to plug in my own `_get_session()` - easy peasy."
- when a bug is fixed, it gets auto-magically zapped across all providers. No more scavenger hunts to find and fix the same code lurking in three different places!

## Example 2: Require some functionality

Our scenario: we want every provider to handle the "Rate limit has been exceeded" error. This is a thing devs usually forget to do, as they concentrate on the happy path. 

Solution: add an abstract method to our `BaseRestClient` class that every provider has to implement. This method will be called in the `make_request` method, right after the request is made.

![Rate limiting](/assets/docs/pattern-rate-limit-docs.png)

Code:

```py
from abc import ABC, abstractmethod
import requests
from typing import Literal
from datetime import timedelta

RateLimitHit = tuple[Literal[True], timedelta]
NoRateLimitDetected = tuple[Literal[False], None]

class BaseRestClient(ABC):
    ...
    @staticmethod
    @abstractmethod
    def check_for_rate_limit(
        response: requests.Response
    ) -> RateLimitHit | NoRateLimitDetected:
        """Check whether we've run into a rate limit (usually 429 status code).

        This method is triggered on every HTTP request.
        
        By default, the `make_json_request()` looks for the Retry-After header
        to detect rate limiting.
        However, most providers don’t bother with the standard and instead 
        have their own quirky ways of signaling a rate limit.
        
        If a rate limit has been hit, return a tuple(True, timedelta). 
        The timedelta tells us how long to wait before we try again.
        """

    def make_request(self, ...):
        ...
        response, response_data = make_json_request(...)
        rate_limit_was_hit, retry_after = self.check_for_rate_limit(response)
        if rate_limit_was_hit is True:
            raise RateLimitHitError(
                f"Rate limit hit, retry possible after {retry_after}",
                rate_limit_timeout=retry_after,
                headers=response.headers,
            )
        ...
```

Now every provider must implement this method. This way no developer ever again can forget to handle the rate limit error. 

```py
class GitHubRestClient(BaseRestClient):
    @staticmethod
    def check_for_rate_limit(
        response: requests.Response
    ) -> RateLimitHit | NoRateLimitDetected:
        """DOCS: https://docs.github.com/en/rest/using-the-rest-api/rate-limits-for-the-rest-api
        
        GH sends the headers x-ratelimit-remaining and x-ratelimit-reset
        So, check both and figure out how long we need to wait, 
        if we have been rate limited.
        """
        default_timeout = timedelta(seconds=60)  # GH says to wait for 1min if x-ratelimit-reset is not present
        ...
        return ...
    
```

Whatever we think every provider should implement, we can define as an abstract method. And thus every provider will be forced to implement it.

If we make the pattern logical enough, then people also won't feel the need to go around it, but will follow its spirit.


## Example 3: I'm `Generic`, but my subclasses are specific

Our scenario: each provider needs tokens in a different form, so we want to pass in a different class to every `__init__`-func, we want to pass in `GitHubAccessData` for GitHub, `BitbucketAccessData` for Bitbucket ... and then use this same class in `_get_session()`. Can this be done?

Solution: we can use `Generic` and connect the class to a specific `AccessData`-class.

Code:

```py
from abc import ABC
from typing import Generic, TypeVar
import dataclasses
import requests

@dataclasses.dataclass
class BaseAccessData:
    pass

AnyAccessData = TypeVar("AnyAccessData", bound=BaseAccessData)

# 
# Our magic step 1:
#
# We have to define that our class is based on some AnyAccessData-class type.
# Every subclass will specify a concrete class, but the base class is generic.
# We do this with Generic[].
# Step 2 happens in sub-classes.
#
class BaseRestClient(ABC, Generic[AnyAccessData]):
    
    def __init__(self, access_data: AnyAccessData):
        self.access_data: AnyAccessData = access_data

#
# ------- GitHub example: -----------------
#

# 
# Our magic step 2:
# 
# Here we say that GitHubAccessData's access_data will always be of type TokenAccessData.
# So, when we instantiate GitHubAccessData() it will require us to 
# pass in a TokenAccessData object.
# And it also means the _get_session() method can safely assume 
# self.access_data is of type TokenAccessData.
#

@dataclasses.dataclass
class TokenAccessData:
    token: str
    
class GitHubAccessData(BaseRestClient[TokenAccessData]):
    
    def _get_session(self) -> requests.Session:
        session = requests.Session()
        # Here: self.access_data can only be of type TokenAccessData
        api_token: str = self.access_data.token
        session.headers.update(dict(
            Accept="application/vnd.github.moondragon+json",
            Authorization=f"Bearer {api_token}",
        ))
        return session

#
# ------- GitLab example: -----------------
#

# GitLab's access_data is of type GitLabAccessData, which has
# a token and extra_headers. This can then be used in _get_session().

@dataclasses.dataclass
class GitLabAccessData:
    token: str
    extra_headers: dict[str, str]

class GitLabRestClient(BaseRestClient[GitLabAccessData]):
    
    def _get_session(self) -> requests.Session:
        session = requests.Session()
        # Here we know that self.access_data is of type GitLabAccessData
        # and can call .token and .extra_headers
        api_token: str = self.access_data.token
        extra_headers: dict = self.access_data.extra_headers
        session.headers.update(
            {**extra_headers, "PRIVATE-TOKEN": api_token},
        )
        return session
```


## Conclusion

As you can see we are still able to concoct quite intricate rules for how things are meant to fit together. These patterns can serve us greatly as documentation that doesn't need to be read. The main difficulty of this approach is in making the patterns **future proof**. If the patterns are too stiff or too complex, then future devs won't follow and the patterns will quickly unravel. 

In my experience, a good guideline for building code patterns is to keep them shallow. **Shallow code is easier to adjust and thus has a higher chance of surviving longer and serving us longer.** As we know the future is fikle and chances are tomorrow will reveal something that would make us want to rewrite today's code.


## Next
⏮️ To be continued...
