---
series: API Resilience Patterns
title: "Deep-dive #1: Why a Slow API Is Worse Than a Dead One"
tags: ["API Resilience Patterns", "Networking", "System Design"]
next_post: 2026-02-06-api-resilience-caching-429
biblio:
    - title: "RFC 9110 — HTTP Semantics"
      link: https://www.rfc-editor.org/rfc/rfc9110
    - title: "RFC 9112 — HTTP/1.1"
      link: https://www.rfc-editor.org/info/rfc9112/

    - title: "Release It! (2nd edition) — Michael T. Nygard"
      link: https://pragprog.com/titles/mnee2/release-it-second-edition/
    - title: "Requests: Timeouts (official docs)"
      link: https://requests.readthedocs.io/en/latest/user/advanced/#timeouts
    - title: "golang/go#24138 — net/http's default client has no timeout"
      link: https://github.com/golang/go/issues/24138
    - title: "Node.js http.request() — timeout option"
      link: https://nodejs.org/api/http.html
    - title: "MDN: AbortSignal.timeout()"
      link: https://developer.mozilla.org/en-US/docs/Web/API/AbortSignal/timeout_static
    - title: "tcp(7) — Linux manual page"
      link: https://man7.org/linux/man-pages/man7/tcp.7.html
    - title: "TCP_RTO_MIN, TCP_RTO_MAX and tcp_retries2"
      link: https://pracucci.com/linux-tcp-rto-min-max-and-tcp-retries2.html
    - title: "TCP Keepalive HOWTO"
      link: https://tldp.org/HOWTO/TCP-Keepalive-HOWTO/usingkeepalive.html
---

Let's do a deep dive on the following scenario: **you are calling a third-party API, the API becomes degraded,** it's still kinda working, but **it is slow**. Now my question is: **how _exactly_ can a degraded third-party API cause your app to become unresponsive?**

I mean, I get the general **gist of it:** as the API calls become slow, **things pile up** and once more things pile up than can be processed everybody waits. 

But then, is the solution to simply move API calls to dedicated workers? So, that when things pile up, only the workers doing API calls die. Can we solve the problem with more `async` code? Surely scheduling a million non-blocking API calls can also kill us.

**What are the mechanics of this process?**

Disclaimer: we don't care what exactly is wrong with the remote API. Our request is probably stuck in some queue on their end, it could be waiting for a **free worker**, it could be waiting for **DB access** while a worker is already processing it, or it could even be in the **TCP accept queue**, an OS-owned queue and their app doesn't even yet know a request is waiting.

{% include toc.html %}

## No default timeouts

**There are, technically speaking, no default timeouts defined by HTTP protocol itself.** So, technically, we could be waiting forever.

The remote API's servers can set various timeouts, but we want to build a resilient app on our side, so **we have to assume they have NO timeouts** in place, because that is the worst case scenario.

Most code libraries for HTTP requests also don't set default timeouts, because, ... they are built around raw socket API, which is usually part of a language's standard library and follows the HTTP protocol. So,.. you should probably go check the defaults in your code right now :-D.

So, how long will we wait, if we also set NO timeouts?

And let's keep this in mind: a simple API call is usually a few hundred ms, let's say 200ms.
{:.box}

- The remote server refuses the connection, nothing is listening at our port. => Instant rejection, **no wait time**.
- The TCP handshake takes a long time, because some of our `SYN` packets get lost. => Linux will retry a backoff, so the handshake either succeeds at some point, or we get a connect error after **roughly ~2 minutes**.
- The remote server disappears mid-conversation **AND** it never sent `ACK` for our last message. => TCP protocol will notice this and act. It will re-transmit a fixed number of tries, and it will back off between attempts. But the default timeout on Linux machines for this scenario is a whopping **15 minutes**.
- The remote disappears mid-conversation, **but** it already sent `ACK` for everything we sent. => TCP doesn't do anything, because nothing on the connection looks of. We will **wait forever**. 
- We're running `async` code, the API calls are non-blocking. => We still keep piling up more and more stuck connections and hit the resource limit. It is only then that every **new API call will fail immediately, but the old calls are still waiting forever**.

![how-long-is-eventually](/assets/http/how-long-is-eventually.svg)

One thing that SREs will probably shout about now is the TCP keepalive, `SO_KEEPALIVE`, which occasionally probes an idle connection to check that the peer is still there. Except it's **disabled by default on most platforms**, and has to be explicitly turned on by the application. It is usually a well hidden setting, but even if we did turn it on, Linux's defaults are to wait **2 hours** before the first probe, then send 9 probes 75 seconds apart before giving up.

<details class="code-details" markdown="1">
<summary>Evidence: "no default timeout" in libraries</summary>

**Python:** the `requests` library defaults its timeout to `None`, and its own documentation directly says: "By default, requests do not time out."

**Go:** `http.DefaultClient`'s `Timeout` field defaults to its zero value, which means no timeout, wait indefinitely.

**Node.js / JavaScript:** the built-in `http.request()` applies no timeout, unless you explicitly pass a `timeout` option or call `request.setTimeout()` yourself. `fetch()` is kinda even worse, because it has **no timeout option at all**. The only way to bound it is to bolt on an `AbortController` and call `setTimeout()` on it (or use the newer `AbortSignal.timeout(...)`).

</details>

## Setting our own timeouts

What timeouts can we set on our side?

![four-timeouts-race](/assets/http/four-timeouts-race.svg)

**Read timeout**: set this timeout first. It starts once your request has been fully sent and ends the moment response starts arriving. This is the best timeout to address the topic of this whole post.

**Connect timeout**: ends when the TCP handshake completes. Set this next. It only guards against a slow or failed *handshake* (an unreachable host, dropped `SYN` packets), not against a server that connects instantly but is slow to actually respond, that's the read timeout's job.

**Retry count/policy**: obviously this isn't a timeout, but it is the next thing I would set. We should retry at least 1x, because of transient errors. Sometimes, for some reason, the API just has a bad moment and will momentarily give you a faulty response. We need to retry. But, we must retry only 2 or 3 times and with an exponential backoff. 

Retries can make this exact situation, the topic of this post, way, way worse. But we still need them, because of the transient API errors.

![timeout-times-retries](/assets/http/timeout-times-retries.svg)

If we set only these 3 we should be good. But, what should we set them to? 

Usually, a good rule of thumb is to see how long your API calls usually take and set the timeouts to help guide you. But my experience is.. you set the timeouts globally, and then you call 50 different APIs, from 50 different companies, so... what does an average even mean in this case?


## Blocking vs non-blocking requests

HTTP requests are I/O like any other, and I/O comes in two modes: blocking or non-blocking mode.

Blocking was the original mode. It meant that a process would send the API call and then be tied down waiting, doing nothing else, until the response arrives.

But, as the internet expanded and we now routinely expect (and wish for) millions of users per day to any humble app, we adopted the non-blocking mode. Instead of the process (or thread) waiting, it can do other stuff. Maybe send another hundred API calls to several providers.

In the blocking mode, the OS suspends the thread that made the API call. It will only wake up once the call resolves to something, anything. For this reason we resolve to spinning up lots of worker threads, so users don't need to wait for one another.

In the non-blocking mode, there's no pool of worker threads anymore. The single thread makes all the API calls, because it doesn't wait for a response. It gets back to processing the response only once the response arrives. When the response takes a longer time to arrive, we are technically free to execute other tasks, that is if we have these other tasks that need to be executed.

It sounds like we should just switch to non-blocking requests and we'll solve our problem.

## The limit of the pool

If we use blocking API calls, then we are limited by how many threads we can realistically keep alive at once. Threads eat up memory, they compete for shared resources like the database connection pool, and the OS's scheduler has overhead switching between them.

If we use non-blocking API calls, then we are still limited by the shared resources, like the database.

But in either case, we are always limited by the max number of allowed open connections. Every open connection is still a **file descriptor**, and every OS process has a hard cap on how many it can have open at once (`ulimit -n`, often 1024 by default).

## Example with numbers

Say we run a pool of **20 workers**, we run blocking calls, and a normal call to this API **takes 200ms**. 

One worker can do max $$\frac{1s}{0.2s} = 5 \frac{calls}{second}$$. Twenty workers, running in parallel, can do:

$$
20 × 5 = 100 \frac{calls}{second}
$$ 

Now the API degrades to **8s per call**. This changes our ceiling: 

$$
20 × \frac{1s}{8s} = 2.5 \frac{calls}{second}
$$

If the API's speed decreases by 40x, then our throughput also decreases by 40x.

In order to serve the same number of requests as before, we then have to increase our resources by 40x. This means running 800 workers, which is surely over the limit of our system, given that we normally have only 20 of them.

But, let's say new requests only keep arriving at **20 requests per second**. So, way below our original max. The queue fills up crazy fast. 

| After | Processed | In Queue |
|-------|-----------|----------|
| 1s    | 2         | 18       |
| 2s    | 5         | 35       |
| 1 min | 150       | 1 K      |
| 5 min | 750       | 5.25 K   |
| 1 h   | 9 K       | 63 K     |
| 3 h   | 27 K      | 189 K    |

The queue length is actually optimistic, it assumes nothing major breaks and **our code isn't retrying any API calls**. But, let's be honest, the code probably re-tries failed API calls, that is like API calling 101.


## The overflow

The problem is that our app isn't only doing API calls and it isn't calling just the 1 degraded API. 

With blocking requests, we eventually run out of workers, and that means **no code can be executed at all**, not even code that has nothing to do with APIs. With non-blocking requests, we instead run out of file descriptors (or memory), and the failure looks different: **no more _new_ connections can be opened**, often this includes our own ability to accept new incoming requests, but everything already running keeps running. This is how a problem with one dependency spreads to code that has nothing to do with it.

This is sometimes called a **cascading failure**: a failure in one part of the system has cascaded into other parts of the system.

> A crack in 1 layer triggers a crack in a calling layer. [...]
> 
> Cascading failures often result from resource pools that get drained because of a failure in a lower layer. Integrations without timeouts are a surefire way to create cascading failures.
<figcaption>
&mdash; Michael Nygard, Release It!
</figcaption>

One bad **escalation** from here on is that our instance can't even process our health check. In which case our load balancer will stop sending requests to it, which is good news for this instance. But the traffic is still oncoming, so it will get re-routed to other instances, which are probably also near their breaking point from calling the same degraded API. 

If this repeats across enough instances, it can take all instances down. 

Of course, we then have safety checks in place that auto replace unhealthy instances. But, if the API doesn't change for the better, then it is just a question of time before these new instances fail in the same way.


## How helpful are the timeouts?

They are very helpful, you should always set them. But, they aren't a miracle solution.

The main problem of timeouts is that they have to be set to a few times the average expected regular request time.

Sure, our average API call is done in 200 ms, but we get some regular responses also at 2s. Which means we will set the timeout to a few seconds, let's say 5s. And we have to have re-tries, at least 1 retry, to handle the occasional transient API error. So, then we are in reality at `timeout = 10s`.

But our system is set out to handle API calls that on average take 0.2s, but suddenly the average is closer to 10s (50x more).

**Unfortunately, our generous timeout does nothing for a slow-but-under-the-limit response.**

But, let's lower the timeout to 1s. Now every API call will timeout. We will retry and that will also timeout. 

**A much lower timeout means that every API call fails. But we are still doing them.** 

Working API: $throughput = 100 \frac{calls}{second}$ and all workers work.

Slow API, but the timeout is not triggered: $throughput = 2.5 \frac{calls}{second}$ and our workers are slow, eventually it will crash.

Slow API and a low timeout: $throughput = 0$, but our workers are fast. 

But now the question becomes: what does our code do when the API timeouts? **If we just retry immediately, then we are just scheduling dead tasks.** We are creating phantom tasks that will accomplish no work at all.


## Flow summary

Let's go back to the original question: **what are the mechanics of this process?** 

1. A slow API response holds a resource hostage: a worker if we're blocking, a file descriptor if we're not. Even a non-blocking request hits this wall, but the ceiling is higher, so more tasks can pile up before the same thing happens.
2. Some resources are shared and finite, like (usually) the DB connections pool, while also being crucial for every task. 
3. If a shared resource runs out (a DB connection), it (usually) cascades into every connected "system", every code that needs it.
4. Retries can make this worse, but we can't live without them.

It's funny, how there are no clean solutions. Of course, you need timeouts, but they possibly won't help at all. Of course, you need to retry API calls, but that can also be the cause for your incident.

Here's an excerpt from "Release It!" about one particular incident where the regular retry used to work brilliantly, until one day it didn't anymore:

> Ultimately, the calling layer was using 100 percent of its CPU making calls to the lower layer and logging failures in calls to te lower layer. 
<figcaption>
&mdash; Michael Nygard, Release It!
</figcaption>


## Solutions

The question is not _if_ you will experience an incident, but _how fast_ you will recover, once the inevitable happens.

There is no magic bullet. But, what helps is: 

**Bulkheads**: give each external dependency its own pool, its own thread or connection budget, so a slow GitHub can't starve work that has nothing to do with GitHub.

In Celery, this could mean a dedicated queue. It can also be a dedicated HTTP connection pool, something that limits the number of concurrent calls to the same API, but then you still have to handle the waiting somewhere. 

**Circuit breakers**: listen for API failures and stop calling them when they are broken. The advantage is already the simple fact that you immediately know the API is down, you don't need to wait for any timeout to be reached. Calls to this specific API still fail, but your workers are free again instantly, so throughput for everything *else* isn't hurt. But you have to again handle the retry yourself.

I wrote up how we actually built one of these in [Pattern #3]({% post_url 2026-04-09-api-resilience-circuit-breaker %}).

**Anything that caps how many requests are allowed per API provider.** You can really be as creative at this as you want. Some solutions are more watertight, but they are also more expensive to maintain. You have to figure out what the right balance is for you.

