---
title: "Self-Documenting Code Concept 1: <code>assert</code> finds its calling"
excerpt_separator: <!--more-->
biblio:
  - title: "Python: The assert statement"
    link: https://docs.python.org/3/reference/simple_stmts.html#the-assert-statement
tags: self-documenting-code
---

**How much documentation, dev-documentation does you app have?** Presumably less than it should have. At least according to new hires. 

**How much documentation do your new devs actually read?** Presumably less than they should. At least according to old hires.

Isn't this dichotomy funny? 

> What do we want? All the documentation! Are we going to read it? Only sometimes!

But, no worries, because I've been looking into self-documenting code for years now. Code that jumps at you, if it sees that you haven't read the docs. Let me show you what I mean. 

As the silly but melodious adage goes: Trust is good, control is better.

![How to document with asserts](/assets/docs/assert-docs.jpg)


<!--more-->

## 💡 Concept 1: Assert finally finds its calling

The `assert ...`-statements are a weird concept. Officially, they are supposed to be debugging aids, but in reality they are often active in production code, in the production environment.

Given how flexible and type-unsafe and non-prescriptive Python code often is, it is nerve-wrecking to add `assert`-s to existing code that already runs in production. Add to this that there are basically never any `except AssertionError`-statements anywhere, so a failing `assert`-statement will crash the whole program.

Thus, we often choose to avoid using `assert`-s entirely. Instead, we use `raise ValueError()` or `raise TypeError()` or `raise MyCustomException()`. It's just easier, more consistent, cleaner that way.

**But, there is one niche where `assert`-s are actually the best choice. And that is as forceful documentation.** Assert-statements can be a tripping wire for future code changes, they can prevent the code from being changed in ways that are not supported by all parties. Let me show you how.

**IMPORTANT**: These `assert` statements must fail as soon as the code is written / imported, not only once the code is run. Thus, these are generally not inside functions, but alongside them.
{:.box}


## Example 1: If you change me, you have to change them too

Our scenario: we have 2 "systems" (any 2 small pieces of code) that work together. They have to be in-sync. **If you change the one, you _need_ to update the other.**

Solution: Add an `assert` that expresses this relationship. The assert should fail, if the 2 "systems" become out of sync.

Code example:

We let users connect various providers (GitHub, Jira, ...) into our app, some are connected via OAuth, others via API keys.

```python
# File constants.py
from enum import StrEnum

# All providers that our app supports
class Provider(StrEnum):
  GITHUB = "GitHub"
  GITLAB = "GitLab"
  BITBUCKET = "Bitbucket"
  JIRA = "Jira Cloud"
  LINEAR = "Linear"
  ...

# Providers that can be connected with an API key / token:
API_KEY_PROVIDERS = {Provider.GITLAB, Provider.BITBUCKET, ...}

# Providers that can be connected with OAuth:
OAUTH_PROVIDERS = {Provider.GITHUB, Provider.JIRA, ...}

#
# Our magic assert:
#
# When a new developer adds a new Provider, they will also have to decide if 
# it supports an API token kind-of connection or an OAuth kind.
# But at least 1 has to be chosen!
#
assert API_KEY_PROVIDERS.union(OAUTH_PROVIDERS) == set(Provider), (
    "API_KEY_PROVIDERS and OAUTH_PROVIDERS must contain all Providers. "
    f"Missing providers: {set(Provider) - API_KEY_PROVIDERS.union(OAUTH_PROVIDERS)}"
)
```

## Example 2: Keeping the collection in order

Our scenario: we create objects that need to be registered under **a globally unique name** and we have to make sure that **2 objects don't register under the same name**.

Solution: Add an `assert` that expresses this limitation.

Code example:

We have `Action`-classes. Each action needs a global-slug, so we register them in a registry. 

```python
# --- File base_action.py ---
from abc import ABC
from abc import abstractmethod
from typing import TypeVar

# The basic Action-class with the mandatory property "slug"

class ActionABC(ABC):
    @property
    @abstractmethod
    def slug(self) -> str: ...
    
    ...
    
TAnyAction = TypeVar("TAnyAction", bound=ActionABC)

# --- File registry.py ---

# Our registry of all defined Action-classes
TActionSlug = str
_registry: dict[TActionSlug, TAnyAction] = {}

def register_action(action: TAnyAction) -> None:
    # 
    # Our magic assert:
    #
    # Here we make sure that no 2 action classes can ever have the same slug.
    # 
    assert action.name not in _registry, (
        f"Action with name '{action.name}' is already registered. "
        f"Please use a different name for action class {action}."
    )
    _registry[action.name] = action

    return action

# --- File sky_actions.py ---

# Some action classes, that we define and register

@register_action
class CouldAction(ActionABC):
    name = "cloud"

@register_action
class SunAction(ActionABC):
    name = "sun"

@register_action
class BrightSunAction(ActionABC):
    name = "sun"  # <- will raise an AssertionError, because "sun" is already taken
```


## Example 3: Mandatory style

Our scenario: We have some code in prod and we kept running into the same kind of bugs. After some deliberation, we decided that the best way forward is to **enforce a stricter coding style for these specific pieces of code.** 

More specifically: let's say we are using Celery for running background tasks. Every task accepts any arbitrary list of arguments, but we now want all of these arguments to always be keyword arguments, never positional arguments, always `kwargs`.

Solution: extend the Celery `task`-decorator (or the BaseCelery task) with an `assert` that demands `kwargs` only.

Code example:

We are defining Celery tasks and we want to allow only keyword arguments as task inputs.

```python
# --- File celery.py ---
import functools
from collections.abc import Callable
from typing import Any

from celery import Celery

# Initialize the Celery app
app = Celery(...)

# This decorator is used to register a new Celery task. Every func that wants to
# be a Celery task will be decorated with this decorator.
@functools.wraps(app.task)
def celery_task(**kwargs: Any):
    def inner(func: Callable):
        _enforce_kwargs(func)

        return app.task(**kwargs)(func)

    return inner

def _enforce_kwargs(func: Callable) -> None:
    # Here we check the args and kwargs of the wannaby Celery task
    func_name: str = func.__name__
    
    num_of_positional_args = func.__code__.co_argcount
    if num_of_positional_args == 0:
        return
    
    all_args = func.__code__.co_varnames
    all_positional_args = all_args[0:num_of_positional_args]
    # The only positional arg allowed is "self"
    all_positional_args = set(all_positional_args) - {"self"}
    
    #
    # Our magic assert:
    # 
    # Here we make sure that no positional args are defined for this function.
    # 
    assert len(all_positional_args) == 0, (
        f"Celery task {func_name} accepts positional arguments {all_positional_args}. "
        "All task should accept just keyword args. "
        f"This makes it more future proof, because we can more easily add and remove args."
    )

# --- File sky_task.py ---

# Here we register some Celery tasks

@celery_task(queue="sky", ...)
def create_a_sky_task(*, num_of_clouds: int, num_of_suns: int) -> None:
    pass

@celery_task(queue="sky", ...)  # <- will raise an AssertionError, 
# because "num_of_clouds" is a positional argument
def create_a_cloud_task(num_of_clouds: int) -> None:
    pass

```

## Conclusion

And that is how `assert` can be used to replace a bit of the documentation. Docs that are shown as errors are read much more often than docs that are neatly stored in `.md`-files.


**Note on the side:** But, obviously, you can also just raise a `ValueError` or `TypeError` or `MyCustomException`. No need to specifically use `assert`-s. :smile:

## Next chapter
⏭️ [Self-Documenting Code Concept 2: Error msgs with calls to action]({% post_url 2025-05-05-self-documented-code-part-II %})
