---
title: "Building blocks collection: Isolate code blocks from each other?"
excerpt_separator: <!--more-->
biblio:
  - link: https://docs.python.org/3/library/contextlib.html#contextlib.contextmanager
    title: "Python: contextlib.contextmanager"
  - link: https://docs.python.org/3/library/functools.html#functools.wraps
    title: "Python: functools.wraps"
  - link: https://mypy.readthedocs.io/en/stable/additional_features.html#extended-callable-types
    title: "Mypy: NamedArg and other extra types"
---

Aren't we all just constantly re-creating the same bits of code?

This goes beyond boilerplate code. We are adding the same bits of code to every project, the same 
git shortcuts, the same logs formatters, the same permissions decorators, ... 

Here I've started putting together a personal collection of building blocks. 

And I'm starting with: Code that isolates (insulates) code blocks. 

<!--more-->

**Hint**: The full function is [at the end of the page](#full-code).
{:.box}

### Example: I'm sending emails to all team members. 

If 1 person's email causes a bug, I want the code to skip this person and continue sending emails to others.

Naive - no error handling:
```python
def send_all_emails(users: list[User]):
    for user in users:
        send_report_email_to_user(user)
```
*If we have a list of 10 users, but we encounter an unexpected error
with the report for user num 3, then only the first 2 users will get the email, others will not.*

With error handling:
```python
def send_all_emails(users: list[User]):
    for user in users:
        with suppress_and_log_exc():
            # ↑ Will catch any Exception, log it correctly 
            # and then continue with the next user
            send_report_email_to_user(user)
```

### What `suppress_and_log_exc` does

- it catches some `Exception` class
- logs it properly
- lets the code continue

So, something like this:

```python
@contextmanager
def suppress_and_log_exc(
    *,
    action_desc: str,
    # ↑ Let's require an identifier. The error msg will be more helpful this way.
):
    try:
        yield
    except Exception as exc:
        logger.error(
            f"Error `{exc.__class__.__name__}` occurred while {action_desc}",
            exc_info=exc,
        )
```

### Possible use cases

This code comes in handy whenever you have a list of actions that are independent of each other.

Like for example: we are triggering various side effects after some event.

Maybe a new user has registered, so, we want to:
- send a Slack high-five to the dev team and also 
- create a ticket for the customer success team to contact them and also 
- ... . 

If any of these side effects fail, the others must still be triggered.

Another example: we have a multi-tenant system and want to trigger one Celery task for each tenant.

If the code for creating a Celery task for customer number 5 has a problem, we still want to create the tasks for customers 6 to 1.000.000. 

It would be silly, if our code were to fail at...,  say sending out the monthly bill, with customer number 5 and then not even try to send it to customer number 6 and 7 and so on. 


### Adding more settings to the contextmanager

We can make the function more customizable by adding a setting for:
1. the log level - some things are in reality just a warning or an info
2. a map of log levels - a specific log level per exception class
3. the exception class that we want to catch - maybe we just care about EmailSendingException
4. more log data - so we can better understand what went wrong when we see this msg in Sentry
5. an error callback - a function that is called, when the error happens, which can be used for custom error-cleanup
6. .. whatever your heart desires .. 💖

So, here is now the full code:


## <a name="full-code"></a>Full code:

```py
from __future__ import annotations

import logging
from collections.abc import Callable
from contextlib import contextmanager
from functools import wraps
from typing import TYPE_CHECKING
from typing import Any


if TYPE_CHECKING:
    from mypy_extensions import NamedArg

logger = logging.getLogger(__name__)


@contextmanager
def suppress_and_log_exc(
    *,
    action_desc: str,
    # 1. a custom log level (read above)
    log_level: int = logging.ERROR,
    # 2. a map of log levels (read above)
    log_level_maps: dict[type[Exception], int] | None = None,
    # 3. the exception class that we want to catch (read above)
    exc_types_to_catch: type[Exception] | tuple[type[Exception], ...] = Exception,
    # 4. more log data (read above)
    extra: dict[str, Any] | None = None,
    # 5. an error callback (read above)
    on_exception_callback: Callable[[NamedArg(Exception, "exception")], None] | None = None,
):
    clean_log_level_maps = log_level_maps or {}
    del log_level_maps

    try:
        yield
    except exc_types_to_catch as exc:
        msg_level: int = clean_log_level_maps.get(exc.__class__, log_level)

        logger.log(
            msg_level,
            msg=f"Error `{exc.__class__.__name__}` occurred while {action_desc}",
            exc_info=exc,
            extra=dict(action_desc=action_desc, **extra if extra else {}),
        )

        if on_exception_callback:
            on_exception_callback(exception=exc)


# And for good measure, let's also have a decorator-version of the code            
def suppress_and_log_exc_decorator(
    *,
    action_desc: str,
    log_level_maps: dict[type[Exception], int] | None = None,
    log_level: int = logging.ERROR,
    exc_types_to_catch: type[Exception] | tuple[type[Exception], ...] = Exception,
):
    def decorator_supress(func):
        @wraps(func)
        def wrapper_supress(*args, **kwargs):
            with suppress_and_log_exc(
                action_desc=action_desc,
                log_level_maps=log_level_maps,
                log_level=log_level,
                exc_types_to_catch=exc_types_to_catch,
            ):
                return func(*args, **kwargs)

        return wrapper_supress

    return decorator_supress

```

### Fin: All together now

Our Example code could now look like this:

```python
def send_all_emails(users: list[User]):
    for user in users:
        with suppress_and_log_exc(
            action_desc="Sending my very special report email",
            extra={"user": user.id}
        ):
            # ↑ Will catch any Exception, log it correctly and then. 
            send_report_email_to_user(user)
```

Or it could be crazy complicated like so:

```python
import logging


def send_all_emails(users: list[User]):
    for user in users:
        with suppress_and_log_exc(
            action_desc="Sending my very special report email",
            log_level=logging.WARNING, # <- default log level
            log_level_maps={EmailIsInvalidException: logging.INFO},
            exc_types_to_catch=(ReportException, EmailException,),
            extra={"user": user.id}
        ):
            # ↑ Will catch any Exception, log it correctly and then. 
            send_report_email_to_user(user)
```

