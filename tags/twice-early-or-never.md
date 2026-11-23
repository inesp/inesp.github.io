---
layout: topic
title: Twice, Early, or Never
permalink: /topic/twice-early-or-never/
tags: "Twice, Early, or Never"
---

When we put a task into a queue, we expect the task to be run soon and precisely once. But the queue has made us no promises. The only thing the queue agreed to was to hold our message until a worker takes it. It is surprisingly little.

So sooner or later, a task will run twice, or it will vanish, or it will be cut in half, or it will be stuck behind a slow job, or...

This series goes through various failures and looks at how exactly they happen, and what we can do about them.
