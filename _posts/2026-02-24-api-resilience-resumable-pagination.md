---
series: API Resilience Patterns
title: "When your Celery task gets rate-limited on page 47"
tags: ["API Resilience Patterns", "Code Patterns", "Celery"]
prev_post: 2026-02-06-api-resilience-caching-429
biblio:
  - title: "Celery: Retrying tasks"
    link: https://docs.celeryq.dev/en/stable/userguide/tasks.html#retrying
---

You're syncing 5,000 records from GitHub. Your Celery task is on page 12 when the API says **"429 - slow down" (you are rate-limited)**. The task fails. If you've thought about rate-limits, then you have retries set up, so Celery reruns your task a few seconds later and the task, of course, starts from page 1 again. Which means the task wastes your resources by **re-fetching and re-processing the 11 pages that were already successfully fetched and processed** the last time. 

Wouldn't it be nice **if the task continued from page 12 after it gets restarted**?

If it worked like this:

![pagination-retry-flow](/assets/http/pagination-retry-flow-idea.svg)

**... and! if we could include this somewhat generically into all existing and future Celery tasks?**

## The common approach

Commonly, if we even consider re-running Celery tasks, we set them up like so:

```python
@app.task(autoretry_for=(APIError,), max_retries=3)
def sync_all_prs():
    for pr in fetch_all_prs():
        save_pr(pr)
```

We _did_ think of `APIError`-s and we do allow the task to retry 3x. 

But, **there is no built-in way to say retry from a specific page**. We need to build that logic ourselves.

## Our custom solution, that can't be generalized

If we want to continue paginating from where we left off, we need to add custom parameters that will hold onto the pagination data and that will be modified with every retry.

The custom parameters will of course only work for this 1 custom Celery task. 

There is no way to make this a general solution, because requests can have all sorts of pagination patterns and why should Celery even know what pagination is let alone know how to handle it.

Although, all this is true... I think, I did find a good enough way to generalize this concept.

## What we need

To make resumable pagination work, we need to:

1. **Track pagination state and accept a starting point** -> know which page we requested last from the API and support starting from any page
2. **Intercept rate-limit responses** -> catch 429s before they bubble up as generic errors, and extract the `Retry-After` header that tells us when we're allowed to make requests again
3. **Hook into Celery's retry mechanism and inject the pagination info into the retry** -> pass the pagination info into the next task run's kwargs so it can resume where we left off

And this doesn't seem too hard to do.



## Step 1: Track pagination state and accept a starting point

This is for sure the most straightforward step.

**Tracking pagination just means collecting the parameters that define _The Page_.** What do we send to the API to say "give me the next batch"?

| API pattern  | Parameters         | Example                                                     |
|--------------|--------------------|-------------------------------------------------------------|
| Page-based   | `page`             | `?page=5`                                                   |
| Cursor-based | `cursor`           | `?after=abc123` or<br>`pull_requests(after: abc123){...}`   |
| Offset-based | `limit` + `offset` | `?limit=100&offset=400`                                     |

**Accepting a starting point** is a bit unusual. Instead of always starting from page 1, our function must accept pagination info passed in.

```python
def fetch_all_prs(page_info=None):
    while True:
        response = fetch_page(page_info)
        yield response
        page_info = response.next_page_info  # <- track position
        if not page_info:
            return
```

No matter what pagination you are dealing with, the basic pattern is the same: **accept starting position -> use it -> track latest position**.


![pagination-tracking-loop](/assets/http/pagination-tracking-loop.svg) 

<details class="rabbit-hole" markdown="1">
<summary>Rabbit hole: What if 1 GQL request has one pagination nested inside another?</summary>

What if your GraphQL request paginates over PRs _inside_ of paginating over repositories? Like fetching all PRs for all repos in an organization?

The solution is obvious: we track both paginations. After all, the GQL query doesn't care if we are trying to fetch page 22 of pull requests that belong to repos on page 4.

```graphql
query {
    repositories(cursor: "<page-4>") {
        pull_requests(cursor: "<page-22>"){
            ...
        }
    }
}
```

We also then need **two separate pagination kwargs**: `next_page_info_repos_loop` and `next_page_info_prs_loop`.

```python
@app.task()
def sync_prs(
    *,
    next_page_info_repos_loop: dict | None = None,  # <- outer loop
    next_page_info_prs_loop: dict | None = None,    # <- inner loop
):
    for repo in fetch_repos(next_page_info=next_page_info_repos_loop):
        for pr in fetch_prs(repo, next_page_info=next_page_info_prs_loop):
            save_pr(pr)
```

When you hit a rate limit, you raise the retry exception with the appropriate suffix:

```python
task_kwargs = <original_kwargs>
task_kwargs["next_page_info_repos_loop"] = <last_repo_page_cursor>
task_kwargs["next_page_info_prs_loop"] = <last_pr_page_cursor>

retry_task_with(**task_kwargs)
```

The retry will populate `next_page_info_repos_loop` and/or `next_page_info_prs_loop` accordingly, and you pick up exactly where you left off.

</details>


## Step 2: Intercept rate-limit responses

This step is all about **reading up on how your selected API communicates Rate-Limit situations**. Technically, it should send a `429` HTTP status and a `Retry-After` HTTP header, but not every API works like that (actually, most don't... unfortunately.....).

Once you know how to detect a rate-limit, you must also **catch it, preferably into a dedicated error-class**, so various pieces of your system can interact with it.

This error will bubble up from `make_request` through `fetch_page` and out of our pagination loop from Step 1. Later, our custom Celery code will catch it and transform it into a task retry.

```python
# somewhere in a make_request()-type of function:
if response.status_code == 429:
    raise RateLimitHitError("Rate limit hit", retry_after=response.headers["Retry-After"])
```

<details class="code-details" markdown="1">
<summary>Extended code for RateLimitHitError and make_request</summary>

```python
from datetime import timedelta

class APIError(Exception):
    """Base error class for all our API problems."""
    ...

class RateLimitHitError(APIError):
    """Raised when an API returns a 429 rate limit response."""
    def __init__(self, msg: str, *, retry_after: timedelta):
        self.retry_after: timedelta = retry_after
        super().__init__(msg)

def make_request(...):
    response = _make_request(...)
    if response.status_code == 429:
        retry_after_sec = int(response.headers.get("Retry-After", 60))
        raise RateLimitHitError(
            f"Rate limit hit, retry after {retry_after_sec}s",
            retry_after=timedelta(seconds=retry_after_sec),
        )
    return response
```

</details>


## Step 3: Hook into Celery's retry mechanism

Celery supports 2 ways to retry tasks: 
- automatic: via the decorator `@app.task(max_retries=3, retry_backoff=True, ...)`
- manual: by calling `self.retry(countdown=30)` within the task-code (`self` is only available if you call the decorator with `@app.task(bind=True)`)

We want to **control the `countdown` value**, because we want to set it to the value of `Retry-After`, so, only the manual method is viable for us:

```python
except RateLimitHitError as exc:
    self.retry(countdown=exc.retry_after.total_seconds())
```

However, we also want to **inject the pagination state into the retry. This is something the built-in retry mechanism can't do.** They will always retry with the original arguments.

So, ... **let's hook into the core-retry-logic and add support for modifying the task's arguments.** To get the modified args into the retry-logic, let's go with a new, dedicated exception class: `RetryCeleryTask`. 

**We will make Celery listen to this error and trigger a retry with the modified task-arguments and a custom countdown value.** 

For this whole logic to work, our **Celery task arguments have to be passed in as kwargs.** I strongly recommend to always accept only kwargs for all Celery tasks. This makes the code more flexible. For example, if you want to later add or remove arguments, you can do it without breaking existing queued tasks or needing to migrate them to new params. 
{:.box}


We want a flow like this:

1. in the task, raise a special exception when rate-limited
   ```python
   raise RetryCeleryTask(countdown=retry_after, page_info=current_position, kwarg_name="page_info")
   ```
2. in our custom Celery base class, catch it and retry with modified kwargs
   ```python
   except RetryCeleryTask as exc:
       kwargs[exc.kwarg_name] = exc.page_info
       self.retry(kwargs=kwargs, countdown=exc.countdown)
   ```

We have to pass `kwarg_name` explicitly because a task might have multiple pagination loops (repos + PRs), and the exception is raised deep in the call stack, which means there's no way to automatically know which kwarg we're paginating through.

<details class="code-details" markdown="1">
<summary>Code details: Retry Celery task with new pagination info</summary>

```python
from datetime import timedelta
import celery

class RetryCeleryTask(Exception):
    def __init__(self, countdown: timedelta, page_info: dict, kwarg_name: str):
        self.countdown: timedelta = countdown
        self.page_info: dict = page_info
        self.kwarg_name: str = kwarg_name

    def __reduce__(self) -> tuple[type, tuple[timedelta, dict, str]]:
        # Is needed for pickling. And pickling is needed for Celery. Celery pickles the exception between retries.
        return self.__class__, (self.countdown, self.page_info, self.kwarg_name)

    
class MyCeleryTask(celery.Task):
    """
    Base class for all tasks, overriding the default behavior of Celery tasks.
    """
    
    abstract = True
    
    def __call__(self, *args, **kwargs):
        # DON'T CALL super().__call__() - Celery's base implementation is unrolled
        # into the tracer for optimization. Call self.run() directly.
        try:
            return self.run(*args, **kwargs)
        except RetryCeleryTask as exc:
            # kwargs is a dictionary, so we can change it in place and the tasks will
            # receive the changed values, not the originals
            kwargs[exc.kwarg_name] = exc.page_info
            return self.retry(kwargs=kwargs, countdown=exc.countdown.total_seconds(), exc=exc)
```

</details>

And that's it. 

When a rate limit hits, we raise `RetryCeleryTask` with the current pagination state. Our base class catches it, injects the pagination info into the kwargs, and schedules a retry. When the task runs again, it picks up right where it left off.

Now a few notes, to make this code production ready.


## Safeguard: Use Pydantic models, not dicts

Throughout this post, I've been passing dictionaries around for simplicity. But I would hate to see this in production code.

What data can we expect in `next_page_repo_info: dict`? Anything really. It could be `{"cursor": "abc"}` or `{"page": 5}` or `{"offset": 100, "limit": 50}` or anything at all. If we accept anything, then it is only right that we also support anything. It stresses me out if I see code: 

```python
def sync_repos(next_page_repo_info: dict):
    page_num: int = next_page_repo_info["page"]
```

How do we know that `"page"` will always be present AND that it will be an `int`? It would be more correct to call `int(next_page_repo_info.get("page"))` and then to also handle the value missing or not being an `integer`. But all of this can be avoided...

**Data structures in Python are free.** So, there is no reason to not use them! I chose to do with `pydantic` this time.

**It is NOT overkill to use data structures, even when the data structure has just 1 property.**
{:.box}

We have a choice: will we spend more time reading code or writing it? I say, let's write more slowly, so that we can read faster. I know, I'm not the only one, who finds writing code much more pleasurable than reading it.

```python
from pydantic import BaseModel

class PageInfo(BaseModel):
    cursor: str | None = None
```

And then `RetryCeleryTask` and your Celery task both use `PageInfo` instead of `dict`:

```python
class RetryCeleryTask(Exception):
    def __init__(
        self,
        countdown: timedelta,
        next_page_info: PageInfo,  # <- not a dict
        kwarg_suffix: str,
    ):
        ...

@app.task()
def sync_all_prs(*, next_page_info: PageInfo | None = None):
    cursor = next_page_info.cursor if next_page_info else None
    ...
```

Also, Pydantic models serialize nicely for Celery's pickling. Dicts do too, but with Pydantic you get validation for free.

If somebody makes a typo and sends in `{"cusror": "abc"}`, Pydantic will complain while a dictionary will not. A dictionary will camouflage your bug and your code will fail somewhere completely unrelated. It will take you some time backtracking to the place of the bug.


## Safeguard: Create specific PageInfo classes for each API

Different APIs paginate differently. GraphQL uses cursors. Jira uses offsets and needs the JQL query. Some REST APIs use page numbers.

Instead of cramming everything into one generic `PageInfo` class, I create subclasses:

```python
from pydantic import BaseModel

class PageInfo(BaseModel):
    """Base class for pagination state."""
    pass

class GQLCursorPageInfo(PageInfo):
    """For GraphQL APIs using cursor-based pagination."""
    after_cursor: str | None = None

class OffsetPageInfo(PageInfo):
    """For REST APIs using offset/limit pagination."""
    offset: int = 0
    limit: int = 100

class JiraPageInfo(PageInfo):
    """Jira has its own quirks."""
    start_at: int = 0
    jql: str | None = None  # need to remember the query too
```

Then my tasks have specific type hints:

```python
@app.task()
def sync_github_prs(*, next_page_info: GQLCursorPageInfo | None = None):
    ...

@app.task()
def sync_jira_issues(*, next_page_info: JiraPageInfo | None = None):
    ...
```

Each class holds exactly what that API needs to resume. And when you read the task signature, you immediately know what kind of pagination you're dealing with.



## Safeguard: Use response objects, not raw data

All of my API calls return an `APIResponse` object. 

When I call `fetch_prs()`:
- I don't receive `[<pr1>, <pr2>, ...]`,
- I receive a `PRsResponse(prs=[<pr1>, <pr2>, ...])` object.

This wrapper gives me the option **to attach anything I want to the response**. 

_**I built this to have a generic way to attach the parsed remote API's error message.** We had lots of API providers, we would fetch PRs from GitHub, Bitbucket, GitLab, ... and the error parsing is specific to every provider, while error-message-displaying is common to all of them._ 

Throughout this post, I've been writing `fetch_all_prs()` as if it just yields PRs directly. But in my actual code, it yields response objects, each with 1 page of PRs.

```python
from abc import ABC
from pydantic import BaseModel

class APIResponse(BaseModel, ABC):
    exception: APIException | None = None
    next_page_info: NextPageInfo | None = None
    
class PRsResponse(APIResponse):
   prs: list[PR]
```

```python
for pr_response in fetch_all_prs():
    prs: list[PR] = pr_response.prs  # <- the actual PRs
```

This might seem like a lot of ceremony for "just fetching some data", but it pays off. All my API-calling code follows the same pattern, errors are handled consistently, and I have a natural place to hang meta-data and helper methods.


## Safeguard: Let `APIResponse` raise the retry

In Step 3, I'm raising `RetryCeleryTask` manually in the task code. These 3-4 lines of code will get repeated in lots of tasks. Why copy-paste this code, if I can just wrap it into a function?

Since we already have `APIResponse`, we can extend it. Tell _it_ how to convert a rate-limit exception into a retry-task exception.

```python
class APIResponse(BaseModel, ABC):
    exception: APIException | None = None
    page_info: PageInfo | None = None

    def raise_task_retry_if_rate_limit_hit(self, *, kwarg_name: str) -> None:
        if not isinstance(self.exception, RateLimitHitError):
            return
        if not self.page_info:
            return
        raise RetryCeleryTask(
            countdown=self.exception.rate_limit_timeout,
            page_info=self.page_info,
            kwarg_name=kwarg_name,
        )
```

Now in our task, instead of all that manual construction, I just call:

```python
@app.task(autoretry_for=(APIError,), max_retries=3)
def sync_all_prs():
    for pr_response in fetch_all_prs():
       pr_response.raise_task_retry_if_rate_limit_hit(kwarg_name="prs_loop")
       save_prs(pr_response.prs)
```

Less code in tasks, less copy-pasting, less chance I'll mess up the logic somewhere.


## Safeguard: Use a naming convention for pagination kwargs

In all the code above I pass `kwarg_name` around. But in production, I use a naming convention instead. I pass `kwarg_suffix`, and the full kwarg name gets built with a prefix:

```python
CELERY_KWARG_PREFIX = "next_page_info_"

class RetryCeleryTask(Exception):
    def __init__(self, countdown: timedelta, next_page_info: dict, kwarg_suffix: str):
        self._kwarg_suffix = kwarg_suffix
        ...

    @property
    def kwarg_name(self) -> str:
        return f"{CELERY_KWARG_PREFIX}{self._kwarg_suffix}"
```

So `kwarg_suffix="prs_loop"` becomes `next_page_info_prs_loop`. All pagination kwargs start with the same prefix, which makes them easy to spot when scanning task signatures.


## Conclusion

I built this system where Celery tasks can resume pagination from where they left off after a rate limit.

Of course this isn't the only way to do it. You could store pagination state in Redis, or in the database, or pass it through a message queue.

I liked this approach, because it makes minimal changes and keeps everything in Celery's existing retry mechanism. And it is incredibly easy to add this to new tasks, once you have it on 1 task.

