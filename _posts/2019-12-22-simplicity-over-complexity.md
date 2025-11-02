---
title: "Simplicity over Complexity! Or is it the other way around?"
tags: ["Opinion", "Software Design Principles", "Code Style"]
biblio: 
  - link: "https://en.wikipedia.org/wiki/Minimum_viable_product"
    title: "Minimum viable product"
  - link: "https://en.wikipedia.org/wiki/Pareto_principle"
    title: "Pareto principle"
  - link: "https://en.wikipedia.org/wiki/Occam%27s_razor"
    title: "Occam's razor"
---

Today, I had not one, but two lightbulb moments. In the middle of a casual discussion about code reviews, it struck me that nearly all of my coding decisions stem from just a few core principles. The first one is: simple is better than complex.

Then, about three seconds later, I came to the second epiphany: this isn’t some universally accepted truth nor is it something you can easily explain.

It’s a belief that that you grow into. But how do I share this hard-won conviction with my teammate without sounding like a monk on a mountain or making them wait five years for the same revelation?

To me, *"simplicity over complexity"* is a pragmatic answer to questions of many flavours, a simple Occam's razor. It gives me 2 benefits: 
- it lets me separate a problem into the part that I need to solve now and the part I can postpone,
- it gives me confidence into my decision because it is backed up by so many other theorems, principles, rules and guidelines.


## What is "simple"?

**Simple**: Solutions that are easy to understand, maintain, and scale. It's the kind of solution that makes you nod appreciatively when you revisit it six months later. It’s easy to grasp, easy to tweak **and doesn’t require a flowchart to explain**. Fewer moving parts, cleaner logic and far less swearing.

**Complex**: The beast with too many heads. It's the kind of solution that might feel clever at first, until future devs start leaving angry comments in the code. It has too many interconnected parts, too much tangled logic and a stubborn refusal to be modified to new requirements.


## So what does "simple is better than complex" mean?

This guideline wants you to gravitate towards simpler solutions. You are meant to ask yourself often: Could you simplify your code and still achieve the same result? Could you simplify the design and still achieve the same goal?

It's never about sacrificing features!

It can be small things like: are you overusing powerful language structures? Do you benefit from using a `try`-`except` statement or does a simple `if` statement fit into your flow better? 

Or it can be larger things like: should you really support 20 different scenarios of something or can you achieve a comparable user experience by providing just the most common 3? 

This guideline coaxes you to be vigilant about complexity and to demand good reasons for increasing it.


## How complexity influences a project


At the beginning of a project, there is no code, no specs. The future (the things we will have to create) is daunting, but the past (the things we did create) is simple. We've created nothing so far and that was very simple, anybody could have done it 🙃.

Now we need to create something. We can't create everything at once, what should we start with? 

If we should trust the booming startup scene, then **the pragmatic way is to start with an MVP**. MVP stands for minimum viable product, a product with just enough features that it is useful, that it successfully completes its main task. The goal at this stage is to keep the costs of developing the project low until we have proof that we are developing the right features. 

The MVP principle is just different phrasing for "simple is better than complex". The simplest solution, which solves your problem, should be used. Do not increase complexity (aka costs) until you have good reasons to.

A similar concept is present in the **Pareto Principle**, which is also called the *80/20 rule* or the *law of vital few*. The Pareto Principle states that for many events, roughly 80% of the effects come from 20% of the causes, ie. 80% of bug reports are caused by 20% of bugs, 80% of the time 20% of the features are used. 

The Pareto Principle originated in statistics, in economics, but has been applied to a wide range of topics. It supports our *Simplicity over Complexity* concept very well. Why bother supporting every conceivable workflow for our software, if 80% of our customers use just 20% of the possible workflows?

Thus, to determine which features to develop first, we must be picky. **Everything we will build, we will also have to support for some time.** Everything we add to our software will have a cost of maintenance and will influence how and at what cost we can build other, completely unrelated, new things.


### What is a good reason to increase complexity?


On paper, all of the above seems logical. But it is also very vague. There is nothing even resembling an actual definition of either complexity or simplicity, nothing we can use as a rule of thumb to judge which feature is worth a month of effort, which 6 months, which just a day. And this is where the fog commences and the bickering starts.

The real reason, why developers and managers don't care for this guideline, is **because we don't agree on the meaning of "simple".**

**If I’m in a meeting** and our biggest customer says they’ll walk unless we ship X by the end of the quarter, that instantly feels like a “drop everything, the company’s survival depends on this” kind of moment. And yeah, in that moment, adding complexity suddenly seems like a totally reasonable thing to do.

**But if I’m the new developer** on the project looking at the software and seeing all the scars from passed rushed projects, I might also be convinced that if we do not act now and start paying for our past misjudgments, then this project is doomed either way. 

So what do we do?

## We plan ahead.

What if we could avoid this situation entirely? We don't want to be in the position, where the complexity has grown to an extent where the project is difficult to maintaining.

Planning ahead doesn’t mean predicting the future perfectly nor does it mean locking ourselves in rigid structures or spending months debating over every decision.

It means building-in enough simplicity and flexibility that we’re not trapped by our own cleverness later. 

It means choosing boring, predictable code over impressive abstractions, because boring is easier to change, if we got it wrong.

It also means pushing back, gently, but firmly on decisions we feel are too dangerous in the long run. It also means talking honestly about the trade-offs of every new decision. 

All of this is really hard when you are in the thick of things. It's much easier to open these conversations long before the deadlines are looming, long before the pressure is on.

Choosing simplicity isn’t about being idealistic, it’s about being realistic about the cost of complexity. We can code anything, but everything will have side effects.


### Are all exceptions evil?

Of course not. Show me 1 solution in nature that is clean, easy and minimalistic. There are none. Life is complicated and so is code.

It is only in theoretical settings, that we can *"ignore the air-resistance"*. 

Life is messy and complex, so our code will also reflect this same messiness.


### And still, simplicity is better

Yet, it's essential to understand what the ideal looks like. We need to know what we are striving for so that we will know when we bend away from it so that we might know why we've bent away from it.

There is no magic solution, there is no 3 steps guide. Whether a good balance was struck between simplicity and complexity only becomes evident later on.

If we plan on sticking with this project for a bit longer, we should consider our future selves, who will have to deal with the consequences of today’s choices.

Will this feature still make sense in the long run?

