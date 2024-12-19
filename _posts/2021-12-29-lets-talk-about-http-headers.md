---
title: "A couple of HTTP headers that devs don't seem to know about"
excerpt_separator: <!--more-->
biblio:
  - title: "MDN Web Docs: HTTP headers"
    link: "https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers"
  - title: "MDN Web Docs: HTTP caching"
    link: "https://developer.mozilla.org/en-US/docs/Web/HTTP/Caching"
  - title: "RFC: The OAuth 2.0 Authorization Framework: Bearer Token Usage"
    link: "https://www.rfc-editor.org/rfc/rfc6750.html"
---

Here's the thing, as far as I can tell lots of (most?) web developers know shockingly little about the HTTP headers or the HTTP standard as a whole. 

I mean, I get it, most education curricula don't include much HTTP-protocol-related information (mine certainly didn't) and who sits at home on an idle Sunday morning and says to herself: "You know what? I'm going to pamper myself today by reading the HTTP standard." Nobody. I know. 

But, ... fact is, for a web developer, which many, many of us are, not having some understanding of the HTTP standard is a glaring gap in our knowledge. So, let's fix this problem.

![HTTP header](/assets/HTTP-header.jpg)

<!--more-->


## What are HTTP headers anyway


HTTP headers exist to exchange meta-information about the request/response.

The client and server pass each other extra information in them. They are present in the request as well as the response.

The client (the browser, the curl command, ...) might send the header: `Accept: text/html` to signal that it wants the response to take the form of an HTML document. Or maybe `Accept: */*` as in "Send me whatever, I understand it all".

 The server might send a response with the header `Cache-Control: public, max-age=600`. The `public` part signals that the returned document can be cached by *any* cache. The response was not intended for one, single user. And the `max-age=600` means that after 600s seconds this response must be removed from the cache.

The HTTP headers thus have 2 parts: the name and the value, which are separated by a colon. **The header names are case insensitive.**


## Take from the basket of existing headers


The best way to learn about all the HTTP headers, which already have a defined name and role, is to visit the [MDN Web Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers){:target="_blank"}.

**In truth, the server and client can invent their own headers.** But let's not re-invent the wheel. Let's always first check the official list of headers, before creating our own, custom, very special, most precious HTTP header. After all, there is a high probability that somebody before us already needed a header for the exact same purpose we do now.

And if we do re-use what already exists, we get 2 added benefits:

  - the documentation is already there
  - people already know how to use our header

I currently work on an app that needs to call an assortment of different APIs and I can tell you I would really appreciate it if we could all start using the same headers. 

Many APIs *do* stick to the standards, but lots don't. Based on my limited experience, I would estimate that about 30% of API unnecessarily invent their own custom HTTP headers as replacement for standard HTTP headers.

About 1 in 3 APIs I have integrated, force us to use their custom headers and their docs never fully explain how these headers behave.

It is really unnecessarily tricky to write intercepting code for all the APIs, when those APIs insist on sending the same information in vastly different ways. Especially when those different ways aren't documented well. Because let's face it, we suck at writing documentation. 

So, let's improve our docs, let's make our users happy and let's just use the headers that are already well documented.


## First HTTP header too few devs know: `Authorization`

So, ... I don't know how else to say this, but, .. the `Authorization` header is meant for authorization. A shocker, I know. But seriously, if you expect requests to your server where the client must send some authentication information, like, ... an API key for instance 😉, please, use this header. Let's just all agree that from now on we will put authorization data of every API into the authorization header.

Let's not invent our own headers like `PRIVATE-TOKEN` or `DD-API-KEY` or `X-SF-Token` and let's not put authorization tokens in `GET` parameters or `POST` parameters either. 

It's really easy to use, the data is passed like this:

```
Authorization: <type> <authorisation-parameters>
```

Since there are many ways to authenticate on a server, the `Authorization` header supports a few different standard types of authentication. That is what the `<type>` part is for. The most common 2 are `Basic` and `Bearer`, **the latter one is used for OAuth2**.

The `authorisation-parameters` is the actual authorization data (username & password, tokens, ...) encoded according to the rules of the authorization type.


## Second HTTP header too few devs know: `Retry-After`

When you implement **rate limiting** on your API, use this header to tell the caller how long she should wait before making a new request.

In general, this header was designed to be used in these responses:

- 503 or Service Unavailable
- 429 or Too Many Requests - the response code for rate limiting
- very rarely 301 or Moved Permanently

The server should return either an integer, the number of seconds to wait before re-requesting or the datetime, after which to re-request.

```
Retry-After: <http-date>
Retry-After: <delay-seconds>
```

This means there is no need to create your own header called `X-Rate-Limit-Remaining-Seconds` or `X-RateLimit-Reset`, because `Retry-After` is always available.


## Fin

Ok, now you know. Please go, tell the others.
