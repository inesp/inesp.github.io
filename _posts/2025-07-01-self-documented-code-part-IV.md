---
title: "Self-Documenting Code Concept 4: Embrace Copy-Paste"
excerpt_separator: <!--more-->
tags: self-documenting-code
---

**What's the point of documentation?** To help other people use _your_ code.

**What's the point of your code?** To help other people solve _their_ problem.

If no one can/is willing to figure out how to use your code, does it really exist? **Is it not just digital noise?** An undecipherable hieroglyphic?

We are so focused on our own code-solution, that we often expect and believe people will sit down with our docs, take their time, light a candle, invite some friends and study the docs like ancient scrolls.

Who ever does that? It is more reasonable to expect them to skim your docs and copy the first code block that smells like it might solve their problem 🌬️.

And we should take advantage of this behavior 😎.

![Self-Documenting Code Concept 4: Embrace Copy-Paste - Set the Trap](/assets/docs/copy-paste.jpg)

<!--more-->

## Previous chapter
⏮️ [Self-Documenting Code Concept 3: Abstract functions and code patterns]({% post_url 2025-05-09-self-documented-code-part-III %})

## Concept 4: Embrace Copy-Paste

The various schools that care of us from a young age have made us blind to the fact that **copy-paste is a valid way of learning**. I would even go so far as to say it is by far the most common and effective way of learning ... anything really.

It takes a lot more effort to learn from theory than to learn from a practical example: we have to first truly understand the theory and then truly understand our circumstances and then apply the theory to our practical situation while compensating for various limitations that the true world has compared to the theoretical world. This is hard work! 

And life is short.

So, we copy-paste. **We take actual, practical examples of solutions that worked and try to apply them to our own problem.**

**This cuts down the time it takes to make use of something new.**

We can take advantage of this copy-paste reflex by making sure **our code has just 1 way of doing something.** (Or alternatively, it has just very few ways to do something, as few as it makes sense in your particular codebase.)

When I ask somebody to create a new DB Model class, they will most likely copy-paste another existing Model class as the base from which to start. If I ask for a new Graphql mutation, they will copy-paste another Graphql mutation. If I ask them to create a new Y, they will most likely try to find any existing Y and copy-paste it.

**And if all the DB Models / Graphql mutations / Y's ... are written in the same way, in the way that "is best", then the new code will just auto-magically also be written in "best" way.** No need to explain it or teach developers how to use it.

We don't have to guarantee that everybody is educated in every detail of our code, we just have to guarantee that when they will inevitably copy-paste, they will copy-paste our preffered way of doing things.


## Example 1: Mixins or The Silent Superpowers

Our scenario: We want every Model to have a `created_on` and `last_updated_on` field. This will help us debug issues in the future. 

Solution: Create a `BaseModelMixin` that has these fields and then make sure every Model inherits from this mixin. 

If we just add these 2 columns to every Model class, other devs might miss them or ignore them. A mixin is much more visible and much more scary for devs to delete (or not copy). All the base-classes always feel much more important than things that are inside the class body.

```py
from django.db import models

class TimestampedMixin(models.Model):
    class Meta:
        abstract = True

    # We gave both field meta_-prefix, to make the names very specific
    # and they don't crash with any other field.
    meta_created_on = models.DateTimeField(auto_now_add=True)
    meta_last_updated_on = models.DateTimeField(auto_now=True)

#
# ALL Models must inherit from the mixin, otherwise you won't know which
# Model class gets copy-pasted:
# 
# --- some file:
class ModelA(TimestampedMixin,...): pass
class ModelB(TimestampedMixin,...): pass
# -- some other file:
class ModelC(TimestampedMixin,...): pass
```

Another often seen use-case for this pattern is seen **in multi-tenant apps**. Where it is used to add the column `organization`/`tenant` to every Model to make sure that every row of every table truly belongs to a specific organization/tenant.


## Example 2: Registrar and the Bureaucracy

Scenario: We are parsing some data form Jira, but we can't support all data types Jira supports, because that's too much work. We want to support only a select list of field types. For every type, we also need a chosen function for processing that type.

Solution: We create a registry of supported field types and their corresponding functions to process them. 

Had we stopped with just a list of supported fields types, then future devs would have to figure out how to process each type of field. But by also registering the function that processes each type, we make it easy for future devs to add support for new field types. Their new function will automatically be called in the correct place, they just have to create it and register it.

```py
# 1. Define the exact type of the processing function
Type_Field_Processing_Function = Callable[<define the parameters>, <define the return type>]

# 2. Register every field type with its processing function, which must be
#  compatible with the Type_Field_Processing_Function type.
SUPPORTED_FIELD_SCHEMAS: dict[str, Type_Field_Processing_Function] = {
    "multicheckboxes": _fetch_name_from_multi_checkbox,
    "sd-customerrequesttype": _fetch_name_from_sd_customer_request_type,
}

def _fetch_name_from_multi_checkbox(...): ...
def _fetch_name_from_sd_customer_request_type(...): ...
```

Or in a more fancy way with a `@register`-decorator as shown in [Chapter I, Example 2: Keeping the collection in order]({% post_url 2025-04-17-how-to-make-code-self-document-itself %}#example-2-keeping-the-collection-in-order).


## Example 3: The Gateway and the Gatekeeper

Scenario: We soft-delete objects in our app, thus we really have to make sure only non-soft-deleted objects are shown to the user at all times. 

Solution: **We control the access to all objects at 1 place, at the "gateway" and we make it impossible to access objects directly, without going through the gateway.**

This is harder to show in code because it is very, very situation + context specific. 

If we are talking about Django, we are probably best off if we create a dedicated `models.Manager` for every Model, but I wouldn't want to do this, because `models.Manager` are awfully unflexible and annoying to work with.

Scenario 2: We want to log the current user with every HTTP request to our app.

Solution: We put the code into a `Middleware`. Every request passes through the middleware, it is not possible to skip it, thus it is not possible to forget to log the user.


## Example 4: An Enum Knows All Types of Things


Scenario: We are keeping track of all actions that users take. The user, who did an action is either a human user with an email address, an API key with a name or it is us, the app itself. We want to validate calls to our audit-function to make sure we always store the user with email address. 

Solution: The input to our app is an `Enum`: `UserType`. It can have only 3 values: `HUMAN`, `API_KEY`, `SYSTEM` and we can validate the input against this enum.

Had we not used an enum, but just a string, then future devs would need to 
- a) know what precisely to send in for "system user" (is it `system` or `app` or `application` or `system_user` or `system-user` or ...?) and
- b) somebody would inevitably send in a new string, possible simply because they wouldn't realize that their choice will have any repercussions at all. **And frankly, how would they know the nature of this field if the function signature allows just any old string?** When the function signature is limited to this enum, however, it is clear what needs to be sent in.

```py
from enum import StrEnum

class UserType(StrEnum):
    HUMAN = "human"
    API_KEY = "api_key"
    SYSTEM = "system"
    
    
def audit_action(user: User | None, user_type: UserType, action: str, ...):
  # 
  # Our magic: 
  #
  # Here we do the validation, we tie the user_type and user together.
  # In production we probably wouldn't want to raise an error, 
  # but log it instead or do something else.
  if user_type == UserType.HUMAN and user is None:
      raise ValueError("User type is HUMAN, but no user was provided.")
  if user_type != UserType.HUMAN:
    user = None
  # ... 

# somewhere in the code:
audit_action(current_user, UserType.HUMAN, "created a new project", ...)
# or
audit_action(None, UserType.SYSTEM, "project missing ...", ...)

```

## Conclusion

Copy-paste is good. People will copy-paste. Let's write our code to be copy-paste friendly. So,..

**instead of writing 5000 words of documentation on a new pattern, we should just fix our code to use the new pattern everywhere**.

The old pattern has been erased from history and future devs will just copy-paste the new pattern.

## Next
⏭️ To be continued...
