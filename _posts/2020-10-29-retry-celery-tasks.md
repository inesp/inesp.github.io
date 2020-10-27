---
title: "Celery task retry guide"
excerpt_separator: <!--more-->
biblio:
  - title: "Celery docs: Retry"
    link: "https://docs.celeryproject.org/en/stable/userguide/tasks.html?highlight=autoretry_for#retrying"
  - title: "Celery Execution Pools: What is it all about?"
    link: "https://www.distributedpython.com/2018/10/26/celery-execution-pool/#:~:text=The%20Celery%20worker&text=It%20spawns%20child%20processes%20(or,known%20as%20the%20execution%20pool."
---


## Celery explained:


Part 1: [Scale your system Part 1: From 1 to 99 999 users]({% post_url 2019-08-03-scaling-1-to-10-000-users %})

## All available settings

Firstly, here is a list of everything you can set and unset to change the retry-behavior of Celery.

All the retry-related settings:
- `default_retry_delay`: number of seconds to wait before the next retry.
- `max_retries`: the number of times to retry, the default is 3. If this is set to 5, then the task will run **up to 6 times**: the first time + 5 retries.
- `autoretry_for`: a list/tuple of exceptions. When one of these exceptions occurs, the task will be retried. If a different exception occurs, the task will NOT be retried.
- `retry_backoff`: retry the task with ever bigger waiting times in between retries. The number represents the number of seconds to wait until the next retry. The number of seconds to wait is calculated with  $$ retry\_backoff * 2^{retry} $$ .
- `retry_backoff_max`: the max value for the number of minutes to wait between retries. This exists to curb the exponential growth of `retry_backoff`.
- `retry_jitter`: is `True` or `False`. It is used only together with `retry_backoff`. If this is set to `True`, then the number of seconds to wait between retries will be randomly choose on in interval between 0 and the number that `retry_backoff` produces: `new_num_of_seonds = random.randrange(num_of_seconds + 1)`.


IMPORTANT: The retry tasks are created as ordinary tasks with an ETA date. They will get put into the ETA queue, which is not the same as the oridinary queue. And all retries of the same task will be handled by **the same worker**.


## Common settings

##### Explicit manual retry


```python
@celery_app.task(default_retry_delay=30, max_retries=3)
def generate_and_send_email(user_id: int, event_name: str):
  ...
  if something_went_wrong_temporarily:
    generate_and_send_email.retry()
```


##### Retry on Exception

```python

@celery_app.task(autoretry_for=(EmailServerNotReachable, SomeEmailException, ),default_retry_delay=30,  max_retries=5)
def generate_and_send_email(user_id: int, event_name: str):
  ...
  raise SomeEmailException(...)

```

## Retry

```python

```

```python

```





---
