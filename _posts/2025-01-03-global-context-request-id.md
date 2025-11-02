---
title: "Build me a global <code>user_id</code> / <code>request_id</code> / <code>tenant_id</code>"
tags: ["Building Blocks collection"]
excerpt_separator: <!--more-->
biblio:
  - link: https://github.com/python/cpython/blob/3.13/Lib/_threading_local.py
    title: "threading.local() in CPython"
  - link: https://peps.python.org/pep-0567/
    title: "PEP 567 -- Context Variables"
  - link: https://refactoring.guru/design-patterns/singleton/python/example#example-0
    title: "Refactoring Guru: Singleton Design Pattern in Python"
  - link: https://realpython.com/async-io-python/
    title: "Real Python: Async IO in Python"
---

Sometimes you want to have a **globally** accessible function like `get_current_user()` that somehow magically stores the current user **for the duration of the request**. How do you implement this? How is the `user` stored?

Or maybe you want `get_current_request_id()` or `request_cache.add_to_cache(some_data)` or `get_tenant()`. 

We are surely not going to pass `user`/`request_id` as arguments to every function in our app.  

So, how is this made?

<!--more-->

## Let's learn from an example 

Let's build `get_current_request_id()` as an example. I'm assuming we are talking about HTTP requests.

_You can build all the other functions in the same way, even those that don't have anything to do with HTTP requests._


## First: we need to set the `request_id` somewhere

This somewhere is going to be **the middleware** (or a middleware, one of them).

Middlewares are called at the beginning of every request. We want to set the `request_id` at the beginning of every request and unset it after the request is done.

I don't know what framework you are using, but most of them have a list of middleware classes/functions defined somewhere, usually in the settings.
In Django there is the setting `MIDDLEWARE`. In Flask, you can use the `before_request` decorator and the `after_request` decorator.

Pseudocode (a Django example is at the end of the article):
```python
import request_storage  # <- our file
from uuid import uuid4

def my_middleware():
    # 1. Build a unique identifier for the request
    request_id = str(uuid4())
    # 2. Store the request_id (we'll implement this below)
    request_storage.set(request_id)
    try:
        ... # this is where the request is processed
    finally:
        # 3. Unset the request_id after the request is done
        # The unset must happen even if there is an exception, this is why
        # finally is used and no except-block is needed.
        request_storage.set(None)
```

## Level 1: Only used in **school**, on a single-process app

_I don't know what it is with schools, but the ones I've seen always want to teach concepts, which are not used (anymore?) in the real world._

So... **don't use this in production** 🫠. Or do, what do I know what you're building. 🙂

Create a Singleton class and store the `request_id` in it. 

_A Singleton is a class that can only have one instance in your app. It's a design pattern. Trying to instantiate it 2x just returns the same instance both times._

Very simple example:
```python
class RequestStorage:
    _instance = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
            cls._instance.request_id = None
        return cls._instance

    def set(self, request_id):
        self.request_id = request_id

    def get(self):
        return self.request_id
```

We can't use this in production, because it's not thread-safe. 

Once you have 2 threads, they will both execute code at the same time, but they will each handle the request of a different user. They will both call `RequestStorage().get()` and get the SAME `request_id`. We don't want this. We want a Singleton PER thread. 


## Level 2: Multi-threading apps can use `threading.local()`

Pyhon's module `threading` handles all sorts of threading-related stuff. One of those things is handling data that is only visible to the current thread. That's exactly what we are after.

> Thread-local objects support the management of thread-local data.
> If you have data that you want to be local to a thread, simply create
> a thread-local object and use its attributes:
>
>  ```
>  mydata = local()
>  mydata.number = 42
>  mydata.number
>  42
> ```

<small>- Excerpt from the docstring of threading.local() in CPython[1]</small>

In our case we'd have something like so in `request_storage.py`:

```python
import threading

_threading = threading.local()

def get() -> str | None:
    return getattr(_threading, "request_id", None)

def set(request_id: str | None):  # pylint: disable=redefined-builtin
    _threading.request_id = request_id
```

I didn't bother with a class in this case, because we are storing just 1 string. But, you can easily store more complex data if you want.


## Level 3: I have asyncio code, `threading.local()` doesn't work

Once you have some asyncio code, you need `contextvars.ContextVar`.

We introduced asyncio code to a part of our codebase, because we were doing a bunch of HTTP requests to other APIs and were mostly just waiting for them to respond.

`threading.local()` doesn't work with asyncio, because asyncio runs on a single thread. It instead uses coroutines and tasks. You can read more about them in Python docs.

Our example would look like this in `request_storage.py`:

```python
import contextvars

_request_id: contextvars.ContextVar[str | None] = contextvars.ContextVar("request_id")

def get() -> str | None:
    return _request_id.get(None)

def set(request_id: str | None):  # pylint: disable=redefined-builtin
    _request_id.set(request_id)
```

These `ContextVar` work great for 2 reasons:
- if their value is modified inside a coroutine, the modification is only visible to that coroutine
- if we set the value from outside asyncio code, then the value is visible to all coroutines that run after that => we don't have to manually pass `request_id` to asyncio-functions


## What about `concurrent.ThreadPoolExecutor`?

This is tricky. 

Both the following statements are true:
- `ThreadPoolExecutor` uses threads, so go with `threading.local()`.
- `ThreadPoolExecutor` re-uses threads, so if 1 thread sets its own value in `threading.local()` and this thread is then re-used (because the number of workers is less than the number of tasks), then the second task will see the `threading` value set by the first task.

So... you have about the following options:
- you *know* your concurrent code doesn't set any values in `threading.local()` => just use `threading.local()`
- use `contextvars.ContextVar` => you need to call `contextvars.copy_context()` on thread-init

`ThreadPoolExecutor` doesn't know about `contextvars`. By default, it doesn't see the values set to `ContextVar` objects. 

We can fix this by calling `contextvars.copy_context()` at the beginning of every thread. And `ThreadPoolExecutor` has an init-argument for this logic. 

An example of how to copy the context:
```python
import contextvars
from concurrent.futures import ThreadPoolExecutor

def _set_contextvars(context: contextvars.Context):
    # This is called first thing before a thread starts running your code
    for var, value in context.items():
        var.set(value)

parent_context = contextvars.copy_context()  # this stores the values before any thread has started
num_of_workers = 5
with ThreadPoolExecutor(num_of_workers, initializer=_set_contextvars, initargs=(parent_context,)) as executor:
    ...
```


## Bonus: Using `contextmanager`, not a middleware

I've mostly talked about HTTP requests, but really they have nothing to do with global state. They just provide an easy-to-understand example.

Another common pattern for setting "global state" is with `contextmanager`. You set a variable as you `__enter__` and unset it as you `__exit__`.

Here's a silly example:

```python
from contextlib import contextmanager
import user_storage  # just like request_storage, but for current user

@contextmanager
def impersonate_user(user: User):
    """For the duration of this contextmanager, let's change the current_user to user"""
    old_user = user_storage.get()
    
    try:
        user_storage.set(user)
        yield
    finally:
        user_storage.set(old_user)
```


## Bonus 2: Django example with middleware

All together now and just for Django and just the `request_id` example:

```python
# 
# File: myapp/middleware.py
#
import request_storage
from uuid import uuid4

class RequestIdMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        request_id = str(uuid4()) 
        request_storage.set(request_id)
        
        try:
            return self.get_response(request)
        finally:
            # Unset the request_id after the request is done
            request_storage.set(None)

# ------------------------------------
# 
# File: request_storage.py
# 
import contextvars

_request_id: contextvars.ContextVar[str | None] = contextvars.ContextVar("request_id")

def get() -> str | None:
    return _request_id.get(None)

def set(request_id: str | None):  # pylint: disable=redefined-builtin
    _request_id.set(request_id)
    
def get_current_request_id() -> str | None:
    return get()

# ------------------------------------
# 
# File: anywhere
# 
from request_storage import get_current_request_id

request_id = get_current_request_id()
```
