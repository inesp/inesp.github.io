---
layout: topic
title: API Resilience Patterns
permalink: /topic/api-resilience-patterns/
tags: "API Resilience Patterns"
---

External APIs are a pain to integrate... particularly because they each follow their own rules, but also because these rules are often badly documented.

It could be so simple: authenticate, fetch, parse the response status, store the data or log an error. 

But we get **stuck at authenticate** already, because everybody chooses their own special rules for identifying the user. We then also get **stuck at fetch**, because the payload rules or paths are always a bit different. We then again get **stuck at parsing** the response, because not everybody uses the standardized HTTP response codes in a standardized way. Even when I'm comparing 2 APIs from the same company, chances are there are major rule differences between them. Presumably because they are being maintained by 2 different teams, who just _don't share as many meetings and team building events as one would wish_. 

So... **hand-holding** ... that is the magic word. Every API has to be meticulous monitored when it's being integrated with and also after it has been let into production code.

**This series distills various insights I've gathered as I was integrating various APIs into our 1 product.**
