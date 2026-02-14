---
series: API Resilience Patterns
title: "If the API Says Wait 60 Seconds, Actually Wait 60 Seconds"
tags: ["API Resilience Patterns", "Code Patterns"]
excerpt_separator: <!--more-->
biblio:
  - title: "HTTP 429 Too Many Requests"
    link: https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Status/429
  - title: "Retry-After header"
    link: https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Retry-After
---

This might come as a surprise, but **sooner or later you call to some external API will get rate-limited**. 

It will probably happen sneakily. There will be a script that never had any problems fetching data from _that_ API? Until, suddenly, error start being logged. Usually lots of them. And then, a few minutes later, the flow of errors will stop and the data will flow again and the script will chug along as it did before, blissfully unaware that rate-limiting exists.

It's kinda hard to write code for handling a Rate-limit. The first problem is that we **often fail to even remember that most APIs _do have_ a limit**. At the very least the following 2 matters mess with us:
- **_We, personally,_ never experience being rate limited when testing the API**. Because _we, personally_ generally test APIs manually. We build 1 API call at a time and then we intentively check the response before doing another API call. Thus, we might be averaging at less than 50 calls per hour...waaaaay below most rate limits. 
- **The code can't be tested.** Even if we do build some rate-limit-handling code, this code just sits in production... for months, waiting for its opportunity. Does code that was never run really work? Technically, we could manufacture the rate-limit and test the code, we could just write a script that frantically calls the external API until we receive a _'429 Enough!'_. But, how often do we go to such lengths?

![manual-vs-production](/assets/http/manual-vs-production.svg)

And so it happens that the rate-limit response is usually handled in one of 2 ways:
- option A): _Ups, totally forgot to handle any errors at all_ 
- option B): _All errors are equal, all errors are bad, code stop_

## Option A) _Ups, totally forgot to handle any errors at all_ 

This is the easy-way-out. 

It is also called the "happy path" or the "first iteration", but those names were picked just to make us feel better about this code. _"Yeah, I know this isn't handling errors, but that's just the first iteration, the proof or concept. Just wait a couple of weeks, we'll fix this soon."_

Nevertheless, this is often production code.

```python
from requests import Response
import requests

def fetch_all_user_repos() -> list[str]:
    """Ups, totally forgot to handle errors"""
    response: Response = requests.get("https://api.github.com/user/repos")
    response_data: list = response.json()
    all_repos = [repo["full_name"] for repo in response_data]
    return all_repos
```

We expect to receive:
```json
[
  {
    "id": 1296269,
    "name": "Hello-World",
    "full_name": "octocat/Hello-World",
    "owner": { "login": "octocat", ...},
    ...
  },
  {
    "id": 1296459,
    "name": "Good-Morning-World",
    "full_name": "octocat/Good-Morning-World",
    "owner": { "login": "octocat", ...},
    ...
  }
]
```

If we get anything else, then... we transfer any responsibilities to other code, to the calling code.

Because, **our puny function doesn't have enough context to know what to do.** Surely, the caller will have all the context and will handle all the errors. We must stay transparent, and the caller must just learn to handle every possible exception from every possible sub-call.

Of course this makes no sense. The caller shouldn't have to know that this function even makes API calls. Some reasonable levels of layering have to exist, each layer should take care of its own errors.

![no-error-handling](/assets/http/no-error-handling.svg)


## Option B): _All errors are equal, all errors are bad, code stop_

When we have a bit more time, and we do consider errors, **we often treat all errors equally: all errors are unrecoverable**, a "500 Internal Server Error" response is the same as a "401 Unauthorized" response and the same as a "429 Too Many Requests" response. 

```python
import logging
from requests import Response
import requests

logger = logging.getLogger(__name__)

def fetch_all_user_repos() -> list[str]:
    """All errors are equal, all errors are bad, code stop"""
    # Handle RequestException
    try:
        response: Response = requests.get("https://api.github.com/user/repos")
    except requests.RequestException as exc:
        logger.warning(f"We received broken data when fetching repos for ...", exc_info=exc)
        return []
    
    # Handle non-200 response
    if response.status_code != 200:
        logger.warning(f"We received non-200 response fetching repos for ...")
        return []
    
    # Handle non-JSON response
    try:
        response_data: list = response.json()
    except ValueError as exc:
        logger.warning(f"We received broken data when fetching repos for ...", exc_info=exc)
        return []
    
    # Finally return repo names
    all_repos = [repo["full_name"] for repo in response_data if "full_name" in repo]
    return all_repos
```

This time, we don't let the `RequestException` bubble up to the caller, because we realize we _do_ have more context for handling _HTTP related problems_ than some code way up the chain that is just trying to populate a dropdown with all list of all options.

![all-errors-equal](/assets/http/all-errors-equal.svg)

## But not all errors are made equal

- A 500 response often means there is **nothing we can do** about it. Sometimes it can also mean our payload is invalid in a way that the developers in that other company didn't anticipate.
- A 401 Unauthorized response means that **we can absolutely fix the problem**, but it will happen **outside of code**. We have to get the right token/permissions from somewhere.
- A 429 Too Many Requests response also means **we can fix the problem**, and we should fix it **in code**. We should wait a bit and then send the API call again.

![errors-not-equal](/assets/http/errors-not-equal.svg)

## What is a 429-Too Many Requests response made up of?

In theory, when an API wants to communicate that you are sending it too many requests too quickly, it _should_ send you:
- the HTTP **status code 429** and
- the **HTTP header `Retry-After`** with information (number of seconds or HTTP date) about how long we have to wait until we make another request.

The idea is that the caller will respect `Retry-After` and diligently wait before making further API calls, **because they have nothing to gain from not respecting it.** Surely, they aren't trying to DDoS the external API, right?!

```http
HTTP/1.1 429 Too Many Requests
Content-Type: text/html
Retry-After: 120

<html lang="en-US">
  <head>
    <title>Too Many Requests</title>
  </head>
  <body>
    <h1>Too Many Requests</h1>
  </body>
</html>
```

**In practice, both the API owners and the API callers are disobeying the rules.**

**The API owners** seem to dislike the `Retry-After` header and instead **love to invent their own**, custom names for **headers**. Because why follow the established standard, when we can just invent our own `X-Rate-Limit-Remaining-Seconds`-header or `X-RateLimit-Reset` and send the number of second in these headers. One has to be free to express oneself.

**The API callers**, however, mostly **ignore this header**, no matter what it is called. 

**It turns out, we do have something to gain, by not waiting.** "To wait" needs to be written into code, whereas "just call again" can be as simple as one for-loop or one function call. Particularly in modern systems, where, at any given time, we can have several tasks that are running in the background calling the same API and several users who are also simultaneously asking for the same API responses. **It is hard work to coordinate them all to wait for 30s** until the 429-window passes. It is really, really much easier to just let all code call whatever it wants and turn every 429-response into `return []` or `return None` or whatever is used for empty-response.

We can only expect developers to wait for `Retry-After`-number-of-seconds if we can find
- **a simple! way to talk to all processes** making API calls **at once**, so all workers, all tasks, and
- **a simple! way to express that they need to wait**. 
It is not enough that we can easily detect 429-response in one place, we also need a simple way to communicate the "don't-call-again"-behavior.

## Step 1: How to speak to all tasks/workers from 1 place?

If only we had **a central location** that all API calls travel through, then we could easily prevent further calls to a rate-limited-API for `Retry-After`-number-of-seconds. Do we have such a place?

Often yes. In the form of **the Python `requests`-library**.

In the `requests` library there is a concept of **"transport adapters"**, these serve as a sort of middleware for every HTTP request. In these adapters you can express rules such as our "when you receive a 429 response do ...<something>..." and also "when you make a call to http://api.github.com/ always do ...<something>...".

The `HTTPAdapter`-s are meant to define rules for interacting with a specific external API, that is why the adapters are always "mounted" on a specific url-prefix. But we will mount/register our custom adapter to all urls by choosing the `prefix="https://"` and `prefix="http://"`.

```python
import requests
from requests.adapters import HTTPAdapter
from requests.models import Response

# ↓ Our custom adapter. It extends requests.HTTPAdapter.
# For now, it does nothing.
class RateLimitAdapter(HTTPAdapter):
    def send(self, **kwargs) -> Response:
        response: Response = super().send(**kwargs)
        return response

def new_session():
    session = requests.Session()
    
    # TODO: here comes other common HTTP code 
    #  like setting headers or retry strategy or ...
    
    # ↓ Here our adapter is "mounted" onto the session object.
    # We mounted it onto 2 partial urls: http and https, because the idea
    # behind adapters is that they define the rules of interaction for
    # one, specific, external API. But by saying "http://" we are tying these
    # rules the whole trafic (except ftp:// and such of course).
    adapter = RateLimitAdapter()
    session.mount("https://", adapter)
    session.mount("http://", adapter)
```

![coordination-challenge](/assets/http/coordination-challenge.svg)

### Best next steps are:
1. put the above code into the `http.py` file or `http` folder and
2. call it with `http.new_session().get("http://api....")` or `http.new_session().post("http://api...", json={})`
3. make sure we always go via `http.new_session` instead of calling `requests.get/.post/...` directly.

**With this we have solved the first hurdle: how to speak to ALL calling code from 1 place.** Now on to: how do we tell them all to wait?


## Step 2: How to communicate "wait for 30s"?

What can we possibly put into `RateLimitAdapter` that carries the message "you have to wait for 30s"?

A custom **exception** class could do this. But then we also have to catch this exception everywhere, which defeats the purpose of finding this central location. ❌ 

Also, our goal is to not do API calls for 30s, so we have to act before the API call goes out, so before we call `super().send(**kwargs)`.

We need an if-statement like this:

```python
class RateLimitAdapter(HTTPAdapter):
    def send(self, request: PreparedRequest, **kwargs) -> Response:
        
        # 🡻
        if we_are_in_429_window(request):
            return something
        # 🢁
        
        response: Response = super().send(request, **kwargs)
        return response
```

The `we_are_in_429_window` could access some sort of **global state**, where we can store data about the 429-window, which would be:
- **the API endpoint**, example: `http:://api.github.com` for GitHub's REST API
- **the duration**, example: 30s
- **the token/authorization data** this applies to, because not all of our tokens, not all of our customers have reached their API rate-limit, just 1 token has, everybody else can keep calling GitHub's API as much as they want to

Now, **we could build a complex, precise system** to handle this or ... we could build **a simple, quick, alternative** solution: we store 429-responses in a Redis cache for the duration of the 429-window under a token-defined key.

💡 Solution: **Let's cache the 429-response in Redis for the duration of the requested wait-period.** 
{:.box}

## Redis flow

The flow would go like this:

![redis-429-flow](/assets/http/redis-429-flow.svg)


In summary: 
- before we make any API calls, check Redis
- after we make API calls, store the `Response` object in Redis if it is a 429-response with `TTL=<Retry-After> seconds`

**This would work precisely because the `TTL` for the Redis `Response` object is precisely the "30 seconds window", precisely the number of seconds that we have to wait until we stop being rate-limited.**

![429-ttl-window](/assets/http/429-ttl-window.svg)

This solution also means that **we don't have to change any other code** (if we don't want to). The code that makes triggers the API calls, that calls `new_session().request("get", "http:...")` needs no change. It will receive the _very same_ response it would receive if we DID call the remote API.

Yes, ideally, all calling code would also handle rate limit responses, but that is not a separate problem. 

What we've achieved with this Redis-cache is that "if the API says wait 60 seconds, we actually wait 60 seconds". And we did this with the minimal amount of code.

## We glossed over the Redis key

Now, to iron out the details. The most delicate detail of this plan is how to define the Redis key.

The Redis key must be unique for every token/authorization data. **But this means that when we are building the key, we must know _where every API stores their authorization data_ to be able to extract it.**

In my mind this is annoying. This generic HTTP adapter class must now understand that there is a GitHub API and a Linear API and a Jira API and Cirlce API and ... and how each of these authorize their API users, which is ... silly. The HTTP adapters should be API agnostic. And when in 3 months another developer introduces a new external API, let's say PagerDuty's API, how will she know that she needs to modify our `RateLimitAdapter` class? It's not ideal, but, in this case, my stance is: _"such is life"_. This problem can be solved, code can be built to handle these connection, but I, for one, decided it isn't worth building a solution for this in our system. Your system might be different.

## How I build the Redis key

I decided that extracting API authorizations will be **an ongoing task**. 

My code will look at all the places, where I know the authorization data can be. **If I find no authorization data, then I refuse to store anything to Redis and I log an error to nudge developers to research.**

![redis-429-key-building](/assets/http/redis-429-key-building.svg)

```python
import hashlib
import logging
from urllib3.util import parse_url
from urllib3.util import Url
from requests.adapters import HTTPAdapter
from requests.models import PreparedRequest
from requests.models import Response

logger = logging.getLogger(__name__)

class RateLimitAdapter(HTTPAdapter):
    ...
    def _get_auth_tokens_from_request(self, request: PreparedRequest) -> str | None:
        headers = request.headers
        
        # Standard location for auth tokens
        auth_header = headers.get("Authorization")
        
        dd_tokens = str(headers.get("DD-API-KEY", "")) + str(headers.get("DD-APPLICATION-KEY", ""))  # Datadog
        sf_token = headers.get("X-SF-Token")  # SignalFX
        gl_token = headers.get("PRIVATE-TOKEN")  # GitLab
        cc_token = headers.get("Circle-Token")  # CircleCI
        # .... more tokens

        all_tokens = (auth_header, dd_tokens, sf_token, gl_token, cc_token)
        if not any(all_tokens):
            return None

        # hash the access tokens, because we don't want to have customer's tokens plainly visible in Redis
        hashed_tokens = hashlib.sha256(f"various header tokens: {all_tokens}".encode()).hexdigest()
        return hashed_tokens
    
    def _get_redis_key(self, request: PreparedRequest) -> str | None:
        org_id = ... # get the tenant ID as you do 
        url: Url = parse_url(request.url)
        
        hashed_auth_token: str | None = self._get_auth_tokens_from_request(request)
        if not hashed_auth_token:
            # The nudge to developers. The correct location for this would be when we actually
            # get a 429 response, so we only log the error when we know that an authorization header
            # must be present. Presumably no API will rate limit non-authenticated users.
            logger.log(
                logging.WARNING, # or logging.ERROR
                "Could not extract authorization info to build a Redis key " 
                "for storing 429 response. " 
                "We probably need to amend RateLimitAdapter._get_auth_tokens_from_request "
                "and add a new way to extract the authorization info.",
                extra={"url": url, ...}
            )

        key = f"http.rate_limits.{org_id}.{url.host}.{hashed_auth_token}"
        return key
```

## Safeguard: Why not take all HTTP headers?

I could have just **packaged up all the HTTP headers**, but what some API call sent to tokens at all or didn't send them in HTTP headers? In this case it is better to not cache and call the API endpoints incessantly than to cache the wrong response.

## Safeguard: Include tenant information

Since my code lives in a multi-tenant project, I preemptively also included the Org information into the key. Just to shrink the scope of damage in case my code has a bug.

## Safeguard: Hash the tokens

We don't want the API tokens to just sit in Redis in their correct form. So, we do quickly hash them with `hashlib.sha256()`. 

## What about the TTL?

To get the TTL, we have a similar problem as with defining the Redis key, we again have to **check all the different HTTP headers where this information could possibly be**. The difference is that we can always use a default value, if we can't find this header. With the authorization data, we could not default to any value.

The one safeguard I do recomend is: have a max value. **Even if the API sends you `Retry-After=<5h>`, I would ignore this and keep the max TTL relatively low, at maybe max 1 hour.**

```python
import logging
from requests.adapters import HTTPAdapter
from requests.models import Response
from datetime import timedelta

logger = logging.getLogger(__name__)


class RateLimitAdapter(HTTPAdapter):
    DEFAULT_429_SLEEP_SEC = 5
    MAX_RETRY_AFTER = timedelta(minutes=60).total_seconds()
    
    ...
    def _extract_sleep_time(self, response: Response) -> int | None:
        headers = response.headers
        retry_after: str | None = headers.get("Retry-After")
        if retry_after is None:
            retry_after = headers.get("X-Rate-Limit-Remaining-Seconds")
        if retry_after is None:
            .... # more way to extract the number of seconds we need to wait for

        if retry_after is None:
            logger.warning(
                "We can't find Retry-After information about "
                "how long we have to wait before the next request. "
                "We probably need to amend RateLimitAdapter._extract_sleep_time "
                "and add a new way to extract this info."
            )
            retry_after = self.DEFAULT_429_SLEEP_SEC

        retry_after_sec: int = self._str_to_int(retry_after, default=0)
        retry_after_sec = min(retry_after_sec, self.MAX_RETRY_AFTER)
        if retry_after_sec > 0:
            return retry_after_sec
            
        logger.warning(
            f"The {retry_after_sec=}, the value must be >0 ." 
            "Will not save to Redis.",
            extra={...}
        )
```

## How to store an HTTP response in Redis

We can't store the `requests.Response` directly in Redis, we need to serialize it first. 

At the time I chose to use `marshmallow` for the serialization and deserialization.

There is 1 important thing about the deserialization: we want to return a `requests.Response` object. Because that is what all the callers expect. We want the response from `redis.get()` to match the response from `requests.send()`, so that the calling code doesn't have to make any adjustments to our change. 


```python
import logging
from marshmallow import Schema
from marshmallow import fields
from marshmallow import post_load
from requests.adapters import HTTPAdapter
from requests.models import Response
from requests.models import PreparedRequest
from requests.utils import CaseInsensitiveDict

logger = logging.getLogger(__name__)


class RateLimitAdapter(HTTPAdapter):
    ...
    def _store_response(self, response: Response, key: str,retry_after_sec: int) -> bool:
        # Before we write to Redis, we need to serialize
        try:
            serialized_response = ResponseSchema().dumps(response)
        except Exception:
            logger.exception(f"An error occurred while trying to serialize a response")
            return False

        success = redis.setex(key, retry_after_sec, serialized_response)
        if not success:
            logger.exception(
                f"Could not add serialized response to Redis, key={key}, retry_after_sec={retry_after_sec}"
            )
            return False
        return True
    
    def _deserialize_redis_response(self, key: str, request: PreparedRequest) -> Response:
        # We want to deserialize the redis data right back into a requests.Response obj
        response_data: bytes = redis.get(key)
        
        try:
            response: Response = ResponseSchema().loads(response_data)
        except Exception:
            logger.exception(
                f"Could not deserialize Response from Redis. Will make the request now and delete "
                f"this Redis key {key}."
            )
            redis.delete(key)
            return None
        
        # we want to pretend we make the API request, so we want to
        # return a requests.Response that looks just like what we would receive 
        # in that case
        response.request = request
        response.url = request.url
        return response


class ResponseSchema(Schema):
    status_code = fields.Int()
    encoding = fields.Str()
    reason = fields.Str(allow_none=True)

    @post_load
    def make_response_obj(self, data, **kwargs) -> DeserializedResponse:
        response = DeserializedResponse()
        response._content = b""  # We don't care what the content was
        response.status_code = data["status_code"]
        response.encoding = data["encoding"]
        response.reason = data["reason"] or ""
        return response


class DeserializedResponse(Response):
    def __repr__(self):
        return "<%s [%s]>" % (self.__class__.__name__, self.status_code)
```


## Conclusion 

The elegance of this solution is in its simplicity and in using Redis TTL as the rate-limit window itself. The cache disappears by itself as soon as the window passes. On top of that, we were able to contain the code changes to 1 place and every `session.request()` magically benefits. 

This solution could be polished further if we needed it to be better. It can also be further simplified. It is very adjustable to the particularities of your system.  

It is in our best interest to let the remote API be after they tell us to relax. Otherwise, 
- **we are wasting our own resources**: CPU time, network traffic both ways, storing logs is expensive
- **our app could get banned entirely**: some APIs punish repeat offenders with IP blocks and revoked API keys

And here is **this very simple solution** that can solve this annoying problem.

## Next
⏭️ To be continued...
