---
title: "Celery: A few gotchas explained"
excerpt_separator: <!--more-->
biblio:
  - title: "Celery docs"
    link: "https://docs.celeryproject.org/en/stable/index.html"
  - title: "Celery docs: Should I use retry or acks_late?"
    link: "https://docs.celeryproject.org/en/stable/faq.html#faq-acks-late-vs-retry"
  - title: "Celery Execution Pools: What is it all about?"
    link: "https://www.distributedpython.com/2018/10/26/celery-execution-pool/"
  - title: "Task Queues"
    link: "https://fixes.co.za/python/task-queues/#:~:text=Task%20queue%20%2D%20A%20system%20for,in%20the%20broker%20(Application%20code)"
  - title: "Wikipedia: Thread pool"
    link: "https://en.wikipedia.org/wiki/Thread_pool"
  - title: "Eventlet"
    link: "https://eventlet.net/"
  - title: "Gevent"
    link: "http://www.gevent.org/"
  - title: "What are greenlets?"
    link: "https://learn-gevent-socketio.readthedocs.io/en/latest/greenlets.html"
---

Have you ever heard of the continuum of theory-before-practice VS. practice-before-theory? Probably not, since I created the name just now 😏. But, though the name is new, the continuum is old. The question is simple: should I first study, study, study the documentation and then only after I presumably fully understand the library and its logic start using it in my code, or should I first dive into it, use it and abuse it before going back and reading the documentation of it.

{% include image.html alt="Children vector created by freepik - www.freepik.com" src="celery-watercolor-spectrum.png" ref="https://www.freepik.com/vectors/children" %}

 <!--more-->

We all float in the continuum, none of us is stationary. Life-events nudge us to the left and to the right and sometimes fiercely sling us into one of the extremes as if we were pink-pong balls. Often we only want to study as much as is absolutely needed, because we equate Practice with joy and Theory with tediousness. And we are right to a degree: how much of a foreign language can you remember if you don't use it regularly. But then, sometimes, it turns out that we badly underestimate how much theory is "absolutely needed". And we have to go back, just like I had to go back to figure out Celery. My strategy of broadly getting it was only broadly enough. Now I had to go back and read all the theory.

Celery is actually full of gotcha-s. Partly because we are dealing with processes, concurrencies, threads, .. and most of the time such details are abstracted away and a developer doesn't need to think about them and thus has little experience with them. And partly because Celery does here and there perform in unexpected ways. Some documentation-reading is definitely required.

So, here it is, all kinds of basic and advanced concepts around Celery.


## Workers and brokers

First, let me explain some basic concepts, under which Celery operates.

Celery is a **"Task Queue"**. Yeah, I also didn't know this was an actual term, I just thought it was a description of what it is: a queue of tasks that will eventually be executed (Maybe our Slovene universities should start using English terms after all. I don't want us to sacrifice regional languages, but doctors also have to understand the Latin terminology. And English has become our de facto Latin, for better or for worse. It is just embarrassing to not know basic English terms after 5 years of study and 10 years of work...). So, Celery is essentially a program that **keeps track of tasks** that need to be run and **keeps a group of workers**, which will execute the tasks. Its main points are that it can execute several tasks **in parallel** and that it is **not blocking** the independent applications(=**Producers**), which are giving it tasks.

But, Celery doesn't actually store the queue of tasks in its memory. It needs somebody else to store the tasks, it needs a **Message Broker** (or Broker for short), which is a fancy term for a program that can store and handle a queue 🙃. These are usually either Redis or RabbitMQ. So, Celery understands and controls the queue, but the queue is stored inside Redis/RabbitMQ.

On to the workers..

When you start Celery (`celery -A tasks worker`) 1 worker is created. This worker is actually a supervisor process that will spawn child-processes or threads which will execute the tasks. By default, the worker will create child-processes, not threads, and it will create as many concurrent child-processes as there are CPUs on the machine. The supervisor process will keep tabs on what is going on with the tasks and the processes/threads, but it will not run the tasks itself. This group of child-processes or threads, which is waiting for tasks to execute, is called **an execution pool** or **a thread pool**.

## Queues

Yes, I deliberately used the plural for queues, because there is more than one type of queue 🧙🏽‍⚗️.

First, there is the main queue, which accepts tasks from the producers as they come in and passes them on to workers as the workers ask for them. By default, you have only 1 such queue. All workers take tasks from the same queue. But you can also specify a few such queues and limit specific workers to specific queues. The default queue is called [`celery`](https://docs.celeryproject.org/en/stable/userguide/configuration.html#task-default-queue){:target="_blank"}.

To see the first 100 tasks in the queue in Redis, run:

```bash
redis-cli lrange celery 0 100
```

These queues are more or less, but not precisely FIFO (if the priority of all tasks is the same). The tasks that are put into the queue first, get taken out of the queue first, BUT they are not necessarily executed first. When workers fetch new tasks from the queue, they usually (and by default) do not fetch only as many tasks as they have processes, they fetch more. By default, they fetch [4 times as many as they have processed](https://docs.celeryproject.org/en/stable/userguide/configuration.html#std-setting-worker_prefetch_multiplier){:target="_blank"}. They do this because it saves them time. Communicating with the broker takes some time and if the tasks that need to be run are quick to execute, then the workers will ask for more tasks again and again and again in very quick successions. To avoid this, they ask for X-times as many tasks as they have processes (=`worker_prefetch_multiplier`).

But there are tasks that never make it into the queue and still get executed by the workers. How is that possible, you ask me? I was asking myself and google the very same question. And let me tell you, Google had very little to say about it. I found just scraps of information. But taking Celery and Redis apart for a few hours (or was it days??), here is what I discovered.

Tasks with an ETA are never put into the main queue. They are put directly into the half-queue-half-list of "unacknowledged tasks", which they named `unacked`. And I do agree that "unacknowledged" is a very long word with a good amount of silenced letters sprinkled in, but it is very easy to miss something named `unacked` when you are trying to understand how some tasks have just disappeared. So, a note for next time I or you need to name something: all user-facing names should be spelled out completely.

So what are ETA tasks? They are scheduled tasks. ETA stands for "estimated time of arrival". All tasks that have ETA or Countdown specified (ie. `my_task.apply_async((1, 2), countdown=3)`, `my_task.apply_async((1, 2), eta=tomorrow_datetime)`) are kept in this other type of queue-list. This also includes **all task retries**, because when a task is retried, it is retried after a specific number of seconds, which means it has an ETA.

To see which tasks are in the ETA-queue in Redis, run:

```bash
redis-cli HGETAL unacked
```

You will get a list of keys and their values alternating, like this:

```
1) "46165d9f-cf45-4a75-ace1-44443337e000"
2) "[{\"body\": \"W1swXSwge30sIHsiY2FsbGJhY2tzIjogbnVsbCwgImVycmJhY2tzIj\", \"content-encoding\": \"utf-8\", \"content-type\": \"application/json\", \"priority\": 0, \"body_encoding\": ...
3) "d91e8c77-25c0-497f-9969-0ccce000c6667"
4) "[{\"body\": \"W1s0XSwge30sIHsiY2FsbGJhY2tzIjogbnVsbCwgI\", \"content-encoding\": \"utf-8\", ...
...
```


## Tasks


Tasks are sometimes also called messages. At its core, the message broker is just something that passes messages from one system to another. In our case, the message is a description of tasks: the task: the task name (a unique identifier), the input parameters, the ETA, the number of retries, ... .

In Celery the task is actually a class. So every time you decorate a function to make it a task, a class is created in the background. This means that each task has a `self`, unto which a lot of things are appended (i.e. `name`, `request`, `status`, `priority`, `retries`, [and more](https://github.com/celery/celery/blob/8c5e9888ae10288ae1b2113bdce6a4a41c47354b/celery/events/state.py#L247-L264){:target="_blank"}). Sometimes we need access to these properties. In those cases we use `bind=True`:

```python
@shared_tas(bind=True,...)
def _send_one_email(self, email_type, user_id):
    ...
    num_of_retries = self.request.retries
    ...
```

## Task acknowledgment


Previously we said that when workers are free, they go and fetch some more tasks from the broker. But it is a bit more nuanced. When a worker "takes" a task, the task moved from the main queue to the `unacked` queue-list. The task is completely removed from the broker only once the worker acknowledges it. **This means that when the worker "prefetches" a number of tasks, what really happens is that those tasks are only marked as his (reserved). They are put into the unacked queue, so other workers won't take them.** If the worker dies, then those tasks are made available to other workers.

So, when does a worker acknowledge a task? By default Celery assumes that it is dangerous to run tasks more than once, consequently it acknowledges tasks just before they are executed. You can change this by setting the famous [`acks_late`](https://docs.celeryproject.org/en/stable/userguide/tasks.html#Task.acks_late){:target="_blank"}. In this case, a task has the slight possibility of being run more than once, if the worker running it dies in the middle of the execution. And with "dies", I literally mean die. A Python exception in the task code will not kill the worker. Such a task will still be acknowledged, but its state will be set to `FAILURE`. Something has to happen so that the worker never reaches the code [`self.acknowledge()`](https://github.com/celery/celery/blob/8c5e9888ae10288ae1b2113bdce6a4a41c47354b/celery/worker/request.py#L373). And this is rare. For this reason, I suspect that setting `acks_late` or not setting it has little bearing.


## ETA

As I already mentioned ETA tasks are ... hard to find. They never make it to the main queue. They are immediately assigned to a worker and put into the `unacked` queue. I suspect that it was not intentional that the ETA tasks immediately get **assigned to a specific worker**. I suspect this was just a consequence of the existing code. An ETA task can't go into a general queue, which works almost as FIFO. The only other place is among the unacknowledged tasks in which case it needs to be reserved by one worker.

Interestingly, the ETA time is not the exact time this task will run. **Instead, this is the earliest time this task will run.** Once the ETA time comes around, the task must wait for the worker to be free.


## Retry Tasks

Celery doesn't perform any retry logic by default. Mostly because it assumes that tasks are not idempotent, that it is not safe to run more than once. Retrying a task does, however, have full support in Celery, but it has to be set up explicitly and separately for every task.

One way of triggering a retry is by calling `self.retry()` in a task. What happens after this is triggered? An ETA time is calculated, some new metadata is put together and then the task is sent to the broker, where it falls into the `unacked` queue and is assigned to the same worker that already ran this task. This is how retry-tasks become ETA tasks and are therefore never seen in the main broker queue. It is a very sleek, but unexpected system. And again, Google has very little to say about this.

Learn more about retries in [Celery task retry guide]({% post_url 2020-10-29-retry-celery-tasks %}).


## CPU bound or I/O bound and processes vs threads


As we already said, by default Celery executes tasks in separate processes, not threads. But you can make it switch to threads, by starting the workers with either `--pool eventlet` or `--pool gevent`. Both eventlet and gevent actually create greenlets, not threads. Greenlets (or green threads) are thread-like, but they are not threads, because by definition threads are controlled by the OS. Greenlets do not rely on the OS to provide thread support, instead, they emulate multithreading. They are managed in application space and not in OS space. There is no pre-emptive switching between the threads at any given moment. Instead, the greenlets voluntarily or explicitly give up control to one another at specified points in your code.

If your tasks are heavy on CPU usage: if they do a lot of computing (=are CPU bound), then you should keep using processes. If, on the other hand, your tasks are mostly doing HTTP requests (=I/O bound), then you can profit from using threads. The reason for this is that while your task is waiting for the HTTP request to return a result, it is not doing anything, it is not using the CPU and would thus not mind if another thread would make use of it.


## There is a lot more to Celery


and the documentation is not perfect. Many features have their description split up and dotted around the web page. It is difficult to find details of the implementation. But it is also a complicated subject matter. I don't know how Celery will behave outside of the few scenarios I have literally created and experimented on. Sure, after a few years of intensive work I might have a good understanding of how it works, but Celery lives on the fringes of my day to day. I set it up, but then it disappears into async-land. It behaves radically different when on the server and when on my computer. I can see which tasks were done, but I can't see how well they were done. Transparency is very difficult with something that runs in parallel, possibly in threads and semi-independent of the application. I don't trust it, I don't trust that I understand its settings correctly or I don't trust that I know how to set them correctly. Celery is like a spirit, it comes and goes, sometimes it breaks, but most of the time, it just works. Hopefully, it works on the tasks we assigned it, but if that is not the case, it will be equally silent.
