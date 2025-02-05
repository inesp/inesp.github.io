---
title: "Quick and easy: Add Postgres advisory locks to your Python code"
tags: database
excerpt_separator: <!--more-->
biblio: 
  - title: PostgreSQL's Advisory Locks
    link: https://www.postgresql.org/docs/17/explicit-locking.html#ADVISORY-LOCKS
---

**When you need it**: when you want to lock the DB, but don't have the row to lock yet. As in: you want to create a row. 

*... the other option would be to lock the whole table, but that only makes sense if you have like... 5 users... and the 4 don't mind waiting for the 5th before they can do anything.. which is for sure not our case, cus we have a hugely popular app! Yes.* 🙃

**What it does**: The locks <ins>_can_</ins> guarantee that only 1 thread at a time executes some specific code. As in: only 1 thread updates the bank account balance at one time.

The "can" is in italics (and underscored, to really make it stand out), because of what is written below: <ins>_you_</ins> have to check the locks manually. Postgres won't do it for you. 

This means the locks are only as good as you are 😉.


<!--more-->


**Does PG care about it?** No. Not at all. Not even a tiny bit. 

The DB server completely ignores these locks. The DB just stores them. We need to make sure we check for them before writing/deleting/reading/what-have-you.

No `SELECT`, `UPDATE`, `INSERT` nor `DELETE` nor any other SQL command will be blocked by these locks.


**Are these like Redis's redlock?** Why, yes. They are. 

**How do I set an advisory lock?** Just call `pg_advisory_xact_lock(lock_key)` with `lock_key` being a (unique) string. 

Alternatively, call `pg_try_advisory_xact_lock(lock_key)`, if having a lock is preferable, but not required. This function will try to set the lock, but if it can't, it won't wait, thus you'll be able to just continue with your code, but without the protection of a lock.

**How do I un-set an advisory lock?** You can't. 

These locks can only be set. They live until the **transaction** is committed or rolled back. If you set them outside a transaction, they will live until the connection is closed.

Hint: use them only inside transactions. Makes it safer. DB transactions are short lived and have a very clear beginning and end inside Python code, so it's easy to know when the lock will be released.


<!--more-->

## Use case example

We have a multithreaded system.

We are listening to a webhook from a remote system, ie: we are listening to GitHub's webhook for when a new PR is created.

GitHub guarantees they will ping us at least 1x when a new PR is created, but occasionally they ping us 2x.

So, occasionally 2 threads will receive the same signal at almost the same time and will step on each other's toes when writing to our DB.

Here is the basic code, BEFORE the introduction of advisory locks:
```python
def handle_github_pr_has_been_created(event_data):
    pr_id = event_data[...]
    pr = fetch_pr_from_db(pr_id)
    if not pr:
        create_pr_in_our_db(event_data)
```

### Wherein lies the problem

Without advisory locks, 2 threads both check if the PR exists, don't find one, then both try to create one.

One of the 2 threads will probably fail, because we probably have a unique constraint on the PR ID.

But it will still raise an exception first, which we either 
- have to **automatically** throw away => which is bad, because we will be hiding errors from ourselves. Maybe the error won't be caused by 2 threads writing the same PR, but something worse and we've been throwing away DB errors this whole time. 
- or **manually** throw away => Which means a human person needs to monitor Sentry and decide which errors are "real" and which are "irrelevant". And this is also bad, because it wastes people and time. And then also requires that everybody *knows* that DB errors are the expected behavior.


### With advisory locks, it can look like this:

```python
def handle_github_pr_has_been_created(event_data):
    pr_id = data[...]
    
    # 1. we choose to set advisory locks only inside DB transactions (read more above)
    with start_db_transaction():
      
      # 2. create a unique lock key, PG accepts only an 64-bit integer
      lock_key: int = crc32(f"PR-{pr_id}".encode("utf-8"))
      
      # 3. set the lock
      # This function will wait for as long as it needs to.
      # If another thread has already set the lock, this thread will wait until the lock is released.
      sql_execute("SELECT pg_advisory_xact_lock(%s)", params=[lock_key])
      
      # 4. do what you need to do
      pr = fetch_pr_from_db(pr_id)
      if not pr:
          create_pr_in_our_db(event_data)
```


## Bonus: A Django function for PG advisory locks


```python
import logging
from zlib import crc32

from django.db import connection
from django.db.transaction import TransactionManagementError

logger = logging.getLogger(__name__)

def acquire_advisory_lock(*, lock_key: str) -> None:
    """Acquire a transaction level advisory lock. If the lock exists, wait for it to be released.

    The lock is in place until the transaction commits or is rolledback.
    """

    if connection.get_autocommit():
        raise TransactionManagementError("Transactional advisory lock can only be created inside a transaction")

    # PG needs a 64-bit integer
    lock_id: int = crc32(lock_key.encode("utf-8"))

    logger.info(
        f"Advisory lock about to be acquired {lock_id=} {lock_key=}", 
        extra={"lock_key": lock_key}
    )
    
    with connection.cursor() as cursor:
        cursor.execute(f"SELECT pg_advisory_xact_lock(%s)", [lock_id])
```



