---
title: "Self-Documenting Code Concept 2: Error msgs with calls to action"
excerpt_separator: <!--more-->
tags: self-documenting-code
---

To reiterate from the [previous chapter]({% post_url 2025-04-17-how-to-make-code-self-document-itself %}): Why do we want self-documenting code? Because then future devs (and we) will use our code as it was intended, whether they read the docs or not. 

Self-documenting code blocks are like **friendly tripping wire** or an alert for the future. The code will quietly listen and watch and when it sees a mistake, **it will reveal itself** and help fix the mistake.

![Communicate via error messages](/assets/docs/errors-docs.png)

<!--more-->

## Previous chapter
⏮️ [Self-Documenting Code Concept 1: `assert` finds its calling]({% post_url 2025-04-17-how-to-make-code-self-document-itself %})

In the previous chapter, we talked about using `assert`-s to kill new code even before it goes to production. Now we'll look at how to use error messages to help fix bugs that already made it to production.


## 💡 Concept 2: Error messages with fixing instructions

Errors logged in production have a certain level of **irritation** associated with them. 

This irritation can be ascribed to lots of reasons. It can stem from the slight feeling of **disgrace** that we feel when we see our own code being faulty. It can be caused by the **accumulated bitterness** of having to clean up after the subpar work of the same somebody else. It can be just the **dread** of having to confront, yet again, a bug that is just above your pay grade. It can also be just the annoyance that you have to stop working on a pleasant project and focus on this ... _thing_. 

Thus, **it's reasonable to assume that people will most often read our error messages while already feeling a little frustrated.**

And so, we hit them with the most useful message like this: `ValueError: invalid value`. Just an awesomely precise message. Really helpful! 🤦

Or maybe a message like this: `TypeError: unsupported operand type(s)    for +: 'int' and 'str'`. It looks better, but it still doesn't tell them if they need to change the `int` or the `str` to make the code work.

Let's not do this, **let's lend a helping hand** (it will often be to ourselves) and write an error message that genuinely helps solve the problem. Sure, the bug might still be unsolvable and frustrating, but at least the messenger delivering it was friendly.

## 💌 Dearest Mrs. Eleanor, I've noticed you’ve been having trouble with ...

You can think of error messages as little emails that you are sending into the future. 

Help out the future developer! After all, it will probably be you.

**Historically, error messages have all the charm of a brick wall; they were overly serious and overly general and mysteriously unhelpful.** But we don't have to stick to what worked in the olden days (if it ever really worked). We have the freedom and the opportunity to make our **error messages not just clearer and more specific, but even a little delightful**.

When crafting a new error message, picture your future self staring at the screen, **irritated**. 

**What info would make that moment less miserable?** A description of the possible solutions. If we are already the messengers of bad news, might as well extend the delivery with the **steps to fix the problem** together with any other useful context info.
{: .box}

 Future-you will be eternally grateful.


## Example 1: Listen and don't judge, but do call for help

Our scenario: we have an app where users can create organizations. Each organization has an owner.

Our problem: technically, an organization owner can "lose" their email address (don’t ask how, it just happens). But we’re not fans of silent partners, every org needs a designated email we can reach with notifications about problems. So, what do we do when there is no email? 

Solution: **we'll look for no-email passively and when we come across no-email, we'll give the dev precise instructions on what needs to happen next.**

Code example: 
```py
def send_email_about_abc(org: Organization) -> bool:
    ...  # some code
    org_owner_email: str | None = ...
    if not org_owner_email:
        #
        # Our magic error-log:
        #
        # We don't:
        # - raise an Exception nor
        # - ignore that the email can be None!
        #
        # We handle the missing email and we give instructions
        # to the developer on how to fix the problem.
        #
        logger.error(
            f"Org {org} has no owner email. "
            "Contact customer support on Slack channel #customer-support "
            "and ask them to urgently get a valid email address for the org owner " 
            "and to tell them about this un-sent email message's content. "
            "For billing purposes we always have valid contact info, they should have "
            "no problem contacting the customer.",
            extra={
                "org": org,
                "org_owner": org.owner,
                "action": "sending email about ABC",
                "org_history": org_history_link,
                ...
            },
        )
        return False
    success = send_email(...)
    return success
```

## Example 2: Handle `None` gracefully

Our scenario: our app listens to some events and sends Slack notifications when those events happen. We record every sent Slack message in a database table.
We have a Postgres table `slack_msgs` with a JSON column called `extra_data`. In this column we store data that should be in the form of one of our defined dataclasses: `RainData`, `OutOfYogurtData`, ... .

Our problem: It can happen that he `extra_data` is corrupted and it doesn't fit into the right dataclass, what do we do?

Solution: we log an error, but we also pretend the value is `None`, so the app doesn't brake.

```py
import dataclasses
from datetime import datetime

@dataclasses.dataclass
class RainData:
    rain_start: datetime
    rain_end: datetime | None
    
@dataclasses.dataclass
class OutOfYogurtData:
    yogurt_flavor: str
    
class SlackMessage(Model):
    ...
    extra_data: dict[str, str] | None = None

    def extra_data_obj(self) -> RainData | OutOfYogurtData | None:
        # Take extra_data that is stored as dictionary / JSON in the database
        # and transform it into a dataclass object, either RainData or OutOfYogurtData.
        data_cls: type[RainData] | type[OutOfYogurtData] = ...
        #
        # Our magic error-log:
        #
        # We try to squeeze the dict into the dataclass, but we allow it to fail.
        # Gracefully!
        # Consequently, we will have to handle the return value `None` in every call
        # to this function.
        #
        # We also explain what the most likely cause of the error is and how
        # those should be fixed.
        # 
        try:
            extra_data = self.extra_data or {}
            return data_cls(**extra_data)
        except Exception as exc:
            logger.error(
                f"Could not transform 'extra_data' into {data_cls}. " 
                "The database data isn't compatible with the data-class, which means that "
                "either (A) the data class has been modified recently " 
                "(ie: a new required field was added, a field was removed) "
                "or (B) the data is corrupted. The solution is probably to make (and handle) "
                "the problematic field(s) as optional or/and to run a migration script to fix the data. ",
                exc_info=exc,
                extra={
                    "slack_msg": self,
                    "extra_data": self.extra_data,
                    "action": "transforming extra_data into dataclass",
                    "data_cls": data_cls,
                }
            )
            return None
```

## Example 3: Name me, I can't exist without a name

Our scenario: we have a `contextmanager` called `start_transaction` that handles a DB transaction. It is called all over the place. But, when the transaction fails and we log the error, it is often hard to understand what exactly was being written to DB and why the write failed.

Our solution: **require a mandatory argument `action_name` that describes the action that is being performed.**

```py
from contextlib import contextmanager
from typing import Generator

@contextmanager
def start_transaction(
    *, 
    # 
    # Our magic:
    # The `action_desc` and `extra_log` arguments aren't technically 
    # required for the code to work. But they are required
    # for the error msgs to be useful.
    # 
    action_desc: str, 
    extra_log: dict | None = None
) -> Generator[None, None, None]:
    try:
        ... # start DB transaction
        yield
        ... # commit DB transaction
    except DBException as exc:
        ... # rollback DB transaction
        # 
        # Our magic error-log:
        # 
        # Once this error happens, we will have all kinds of 
        # context info about the action that was being performed.
        # Because this info was passed in as a mandatory argument.
        #
        logger.error(
            f"DB transaction failed while performing action `{action_desc}`",
            exc_info=exc,
            stack_info=True,
            extra={
                "action_desc": action_desc,
                **(extra_log or {})
            },
        )
        
# -------------------------------------
# How it is used:
#
with start_transaction(
    action_desc="Creating a new user",
    extra_log={"org_id": org.id, "user_email": user.email}
):
    pass

# Or even:
#
with start_transaction(
    action_desc=f"Creating a new user with email {user.email} in {org.id}",
):
    pass

```


## Example 4: What feature flag?

Our scenario: we have a fancy feature that is enabled only for some organizations. To enable it for Org ABC, a feature flag needs to be set to `True`. But how do we tell people which feature flag?

Solution: **log the skipping over some organizations and mention the flag that controls it.**

```py
def send_slack_msg(org, ...) -> bool:
    if STOP_SENDING_SLACK_MSGS(org):
        # 
        # Our magic:
        #
        # We could skip the whole log-msg, but then how will support know that we
        # did try sending the Slack msg for org Z, but this functionality is
        # disabled for them?
        # Even nicer is the fact that we tell exactly which feature flag 
        # needs to be changed, if we want to enable this feature for this org.
        # 
        logger.warning(
            f"Aborting sending of Slack msg ABC. ABC is disabled for {org=} "
            f"with the feature flag `STOP_SENDING_SLACK_MSGS`",
            extra={
                "org_id": org_id,
                "org_billing_plan": org.billing_plan.slug,
                "flag": "http://www............../STOP_SENDING_SLACK_MSGS",
            },
        )
        return False
    ...
```

## Example 5: Progress bar in logs

Our scenario: we are sending some documents to ElasticSearch. Sometimes it's only a few documents, other times it is many documents, and thus this indexing can take hours.

Problem: we want to know how far along the indexing is. We can see the past logs, but we have no idea how many more documents need to be indexed.

Solution: **add a prefix to the logs that acts as a progress bar.** Once you have this, it is even possible to index documents in parallel and still know how many more need to be done. 

Code: 
```py

def index_documents_in_batches():

    documents: list[Doc] = ....
    
    batches: list[list[Doc]] = create_batceh_of_documents(documents, batch_size=100)
    num_of_batches: int = count(batches)
    
    for i, one_batch in enumerate(batches):
        # 
        # Our magic: 
        #
        # We prefix every log with the number of the batch, ie. batch 1/15, 12/10300, ...
        # And if we see we the action has been running for 5 mins and is at 50/100, 
        # we know it needs about 5 more mins to be done. 
        # We can also setup async indexing via Celery tasks and watch only the
        # log msg 'Finished indexing batch' and look at the batch-numbers
        # as they are rolling in.
        # 
        prefix = f"{i+1}/{num_of_batches}"  # this will be 1/15, 2/15, ... 15/15
        logger.info(f"{prefix}: Starting to index batch")
        ...
        logger.info(f"{prefix}: Finished indexing batch")
```

## Conclusion

There is a lot you can communicate in error messages and other logs.

When something takes an unexpected turn, devs often go check the logs. They will read the logs, thus you should communicate via the logs. 

## Next
⏭️ To be continued...
