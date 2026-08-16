---
title: "API Resilience: research, references and anecdotes (consumer-side) for the posts and the talk"
---

Reference material for the API Resilience series and the 45-min talk.
ALTITUDE: the backend dev who CONSUMES third-party APIs she doesn't control. Not the
SRE/operator who runs a big service. The old SRE-flavored research (metastable failures,
cascading failures, AWS retry storms) was cut on purpose, see the note at the bottom.

All links verified against the primary source unless flagged. The "could say" lines are
raw hooks, not finished prose.

Verification key:
- ✅ read off the primary source
- ⚠️ verified only via a secondary source, or has a caveat, check before publishing
- ❌ do not use


# The through-line: every provider tells you the same four things

The spine, at the consumer's altitude. Six different providers, different companies,
different domains, all instruct the calling developer to do the same four things, in
writing, and we ignore all of it. This is the recognition wow: the API is begging you to
behave, in the response headers, and we don't listen.

The four instructions:
1. Respect Retry-After / the reset header (GitHub, Slack, Shopify, Twilio hand you the seconds to wait)
2. Back off exponentially, with jitter (Stripe, Google, Twilio, GitHub)
3. Use idempotency keys so retries are safe (Stripe)
4. Stop hammering a throttled or down API (GitHub: serial not concurrent; Shopify: early requests just get throttled again)

Maps one-to-one onto the three patterns: Retry-After respect = cache the 429,
safe-retry/idempotency = resume don't restart, stop hammering = circuit breaker.

Provider guidance, all ✅ fetched:
- **GitHub**, "Best practices for using the REST API". Honor retry-after, if
  x-ratelimit-remaining is 0 wait until x-ratelimit-reset, make requests serially not
  concurrently, pause >=1s between writes, use webhooks instead of polling, repeated
  secondary limits = exponential backoff. Ignoring it can get your integration banned.
  https://docs.github.com/en/rest/using-the-rest-api/best-practices-for-using-the-rest-api
- **Stripe** (rate limits). "Watch for 429... exponential backoff... add randomness to the
  backoff schedule to avoid a thundering herd effect." Suggests client-side token-bucket
  throttling.
  https://docs.stripe.com/rate-limits
- **Slack**. On 429 read Retry-After and wait that many seconds. Endpoints are tiered,
  design for ~1 request/second. Sustained abuse risks app disablement.
  https://docs.slack.dev/apis/web-api/rate-limits
- **Google Drive / Google APIs**. Publishes the actual formula: truncated exponential
  backoff, min(((2^n)+random_ms), max_backoff), add up to 1000ms jitter, cap at 32-64s.
  Could say: "Google wrote the backoff-with-jitter as math so you wouldn't have to."
  https://developers.google.com/drive/api/guides/limits
- **Shopify**. 429 + Retry-After, leaky bucket. "Any request made before the wait time has
  elapsed is throttled." Could say: "Retrying early isn't neutral, it keeps you in the
  penalty box."
  https://shopify.dev/docs/api/admin-rest/usage/rate-limits
- **Twilio**. A 429 means the request wasn't processed, so it's safe to retry, with
  exponential backoff. Watch Twilio-Concurrent-Requests.
  https://www.twilio.com/docs/usage/rest-api-best-practices


# Post 1: Caching 429s in Redis (rate limits)

The standards joke: the standard exists, everyone ignores it and invents their own header.

- ✅ **RFC 6585** defines HTTP 429 (since 2012). https://www.rfc-editor.org/rfc/rfc6585
- ✅ **RFC 9110** defines Retry-After. https://www.rfc-editor.org/rfc/rfc9110.html#name-retry-after
- ✅ **draft-ietf-httpapi-ratelimit-headers**, an active IETF draft (rev -11, May 2026) to
  standardize the RateLimit headers. Still a draft after years, while everyone shipped their own.
  https://datatracker.ietf.org/doc/draft-ietf-httpapi-ratelimit-headers/

The header zoo, "nobody agrees, not even on the hyphens", all ✅ from official docs:
- GitHub: `x-ratelimit-remaining` / `x-ratelimit-reset`
- X / Twitter: `x-rate-limit-remaining` (WITH dashes, unlike GitHub)
- Stripe: a bespoke `Stripe-Rate-Limited-Reason` (a reason, not a counter)
- Shopify: leaky bucket, 429 + Retry-After

Mental models and explainers:
- ✅ **Shopify's "bucket of marbles"**: ~60 marbles, one drains per second, overflow = 429.
  https://shopify.dev/docs/api/admin-rest/usage/rate-limits
- ✅ **Stripe, "Scaling your API with rate limiters"** (2017). Canonical token-bucket explainer
  if I want one slide on how the wall I'm hitting is built.
  https://stripe.com/blog/rate-limiters


# Post 2: Resumable pagination + safe retries

Resuming instead of restarting is the work-side of not throwing more load at an API that
just asked for less. The companion idea is the idempotency key: retrying a WRITE safely.

- ✅ **Stripe idempotency keys**. Every POST accepts an Idempotency-Key (V4 UUID, retained
  ~24h). "If a connection error occurs, you can safely repeat the request without risk of
  creating a second object." The safe-retry primitive, built for you.
  Could say: "The network drops AFTER Stripe charged the card but BEFORE you got the
  response. Their answer is one header. You just send a UUID."
  https://docs.stripe.com/api/idempotent_requests

War stories (consumer-side, verified):
- ✅ **Airbnb, "Avoiding double payments in a distributed payments system."** They call
  external processors, a response is lost, they can't tell if the charge went through,
  retrying risks double-charging the guest. Built an idempotency library (Orpheus); classify
  4xx as non-retryable, 5xx/network as retryable. The marquee anecdote.
  https://medium.com/airbnb-engineering/avoiding-double-payments-in-a-distributed-payments-system-2981f6b070bb
- ✅ **Kirill Platonov, "4 strategies to deal with Shopify API rate limits."** Solo dev
  updating prices for 300k products keeps tripping Shopify's 429s, walks through queue-based
  throttling and bulk operations. Small-team relatable.
  https://kirillplatonov.com/posts/shopify-api-rate-limits/
- ⚠️ **GoCardless, "Safely retrying API requests"** (idempotency explainer, not an incident).
  Tip: derive the idempotency key from your own DB id, not just a random UUID.
  https://gocardless.com/blog/idempotency-keys/
- ⚠️ **Stripe, "Because nobody likes being charged twice"** (stripe.dev, 2025). Idempotency +
  durable queue. Title confirmed, body NOT fully read, verify before quoting specifics.
  https://stripe.dev/blog/because-nobody-likes-being-charged-twice

Honest gap: no clean first-person "a vendor went down and our background jobs piled up"
incident post exists in the wild (buried under tutorial spam). My own GitHub-outage war
story is probably the best one available, which is fine, it's mine.


# Post 3: Circuit breaker

- ✅ **Michael Nygard, _Release It!_** Named/popularized the circuit breaker (and bulkhead)
  in 2007. Lead with this so it isn't "a Java thing".
  https://pragprog.com/titles/mnee2/release-it-second-edition/
- ✅ **Martin Fowler, "CircuitBreaker" bliki.** Cleanest three-state explainer, credits Nygard.
  https://martinfowler.com/bliki/CircuitBreaker.html
- ✅ **Netflix Hystrix.** "Industry took this seriously" anchor, now in maintenance mode,
  points to resilience4j. https://github.com/Netflix/Hystrix
- ✅ **Netflix Chaos Monkey.** Kills prod servers at random so resilience isn't optional.
  (⚠️ founding year fuzzy, say "around 2010".) https://github.com/Netflix/chaosmonkey
- ✅ **Electrical etymology.** CLOSED = current flows, OPEN = cut off. Explains why OPEN feels
  backwards. https://en.wikipedia.org/wiki/Circuit_breaker

⚠️ Accuracy note: the timeout-doubling I describe is a common enhancement, NOT part of
Fowler's or Nygard's canonical breaker (theirs uses a fixed timeout). Frame as "a common addition".


# "You don't build this from scratch" (the pip-install slide)

All ✅ verified actively maintained in 2026 unless flagged:
- **tenacity** v9.1.4. General-purpose retry: backoff, jitter, stop conditions, async.
  Successor to the dead `retrying`. https://github.com/jd/tenacity
- **stamina** v26.1.0 (Hynek Schlawack). Opinionated wrapper around tenacity, jitter on by
  default, attempt + time caps, instrumentation. Good beat: even experts think raw tenacity
  is too footgunny, so someone shipped the batteries-included version. https://github.com/hynek/stamina
- **urllib3 Retry + requests HTTPAdapter**. Built in if you're on requests. `backoff_factor`
  gives exponential backoff, `status_forcelist` picks which codes to retry.
  https://urllib3.readthedocs.io/en/stable/reference/urllib3.util.html
- ⚠️ **httpx** `HTTPTransport(retries=)` retries ONLY connection errors, not status codes. Its
  own docs tell you to use tenacity for the rest. Nice "the library hands you the hard problem
  on purpose" slide. https://www.python-httpx.org/advanced/transports/
- **pybreaker** v1.4.1 and **circuitbreaker** v2.1.3, both cite Nygard's _Release It!_.
  https://github.com/danielfm/pybreaker , https://github.com/fabfuel/circuitbreaker
- **pyrate-limiter** v4.2.0 (leaky bucket) and **requests-ratelimiter** v0.10.0 (bolts it onto
  requests). Respect limits before you even hit the wall.
  https://github.com/vutran1710/PyrateLimiter , https://github.com/JWCook/requests-ratelimiter
- ❌ **backoff**: dormant since Oct 2022. Mention as predecessor at most, don't recommend live.


# Survey stat (for "everyone integrates APIs")

- ✅ **Postman 2024 State of the API** (5,600+ respondents): 74% of orgs are API-first.
  https://www.postman.com/report/state-of-api-2024/
- ⚠️ "26 to 50 APIs power the average app": only verified via a secondary source, check the PDF.


# Anti-citations, do NOT use

- ❌ The viral "$4,800 in duplicate Black Friday charges" idempotency story is a made-up
  teaching hook, not a real incident. Don't repeat the number.
- ❌ Operator/SRE-side material (metastable failures, AWS DynamoDB retry storm, Google SRE
  cascading failures, Marc Brooker "retries are selfish", thundering herd as a systemic
  collapse). CUT ON PURPOSE: wrong altitude. This talk is the consumer's seat, not the
  operator's. The "every provider tells you the same four things" through-line replaces it,
  and it's the recognition wow instead of "the giants fall too". If a 20-second "the big
  version has a scary name" aside is ever wanted, metastable failures is the reference, but
  don't build on it.
