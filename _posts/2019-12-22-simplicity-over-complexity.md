---
title: "Simplicity over Complexity! Or is it the other way around?"
biblio: 
  - link: "https://en.wikipedia.org/wiki/Minimum_viable_product"
    title: "Minimum viable product"
  - link: "https://en.wikipedia.org/wiki/Pareto_principle"
    title: "Pareto principle"
  - link: "https://en.wikipedia.org/wiki/Occam%27s_razor"
    title: "Occam's razor"
---

Today, I came to 2 realizations, both of them surprising and both of them essential. During an innocuous debate about code review, I suddenly discovered that only a few basic ideas underlie all of my coding-related decisions. One of them is: simple is better than complex. And about 3 seconds later, I realized that this is neither a well-known mantra nor one that can be quickly explained. It's a conviction that you grow into. But without having to wait for a few years, how do I explain it to my teammate?

To me, *"simplicity over complexity"* is a pragmatic answer to questions of many flavours, a simple Occam's razor. It gives me 2 benefits: 
- it lets me separate a problem into the part that I need to solve now and the part I can postpone,
- it gives me confidence into my decision because it is backed up by so many other theorems, principles, rules and guidelines.

## So what does "simple is better than complex" even mean? 

This guideline wants you to gravitate towards simpler solutions. You are meant to ask yourself often: Could you simplify your code and still achieve the same result? Could you simplify the design and still achieve the same goal? 

It can be small things like: are you overusing powerful language structures? Do you benefit from using a `try`-`except` statement or does a simple `if` statement fit into your flow better? 

Or it can be larger things like: should you really support 20 different scenarios of something or can you achieve a comparable user experience by providing just the most common 3? 

This guideline coaxes you to be vigilant about complexity and to demand good reasons for increasing it.

## How complexity influences a project

At the beginning of a project, there is no code, no specs. The future (the things we will have to create) is daunting, but the past (the things we did create) is simple. We've created nothing so far and that was very simple, anybody could have done it 🙃.

Now we need to create something. We can't create everything at once, what should we start with? 

If we should trust the booming startup scene, then the pragmatic way is to start with an MVP. MVP stands for minimum viable product, a product with just enough features that it is useful, that it successfully completes its main task. The goal at this stage is to keep the costs of developing the project low until we have proof that we are developing the right features. 

The MVP principle is just different phrasing for "simple is better than complex". The simplest solution, which solves your problem, should be used. Do not increase complexity (aka costs) until you have good reasons to.

A similar concept is present in the Pareto Principle, which is also called the *80/20 rule* or the *law of vital few*. The Pareto Principle states that for many events, roughly 80% of the effects come from 20% of the causes, ie. 80% of bug reports are caused by 20% of bugs, 80% of the time 20% of the features are used. 

The Pareto Principle originated in statistics, in economics, but has been applied to a wide range of topics. It supports our *Simplicity over Complexity* concept very well. Why bother supporting every conceivable workflow for our software, if 80% of our customers use just 20% of the possible workflows?

Thus, to determine which features to develop first, we must be picky. Everything we will build, we will also have to support for some time. Everything we add to our software will have a cost of maintenance and will influence how and at what cost we can build other, completely unrelated, new things.

### What is a good reason to increase complexity?

On paper, all of the above seems logical. But it is also very vague. There is nothing even resembling an actual definition of either complexity or simplicity, nothing we can use as a rule of thumb to judge which feature is worth a month of effort, which 6 months, which just a day. And this is where the fog commences and the bickering starts being intense.

The real reason, why developers and managers don't care for this guideline, is because we don't agree on the meaning of "simple".

If I'm at a meeting and our biggest customer convinces me they will leave our company, if we don't deliver X by the end of the quarter, then to me this will seem like an "our-company-is-on-the-line" insanely good reason to increase complexity. 

If, however, I am a new developer on the project and I can see the software all scarred from botched passed projects, I might also be convinced that if we do not act now and start paying for our past misjudgments, then this project is doomed either way. 

So what do we do?

We plan ahead. 

This situation might be unsolvable. The most efficient way to resolve it is to avoid it. We don't want to be in the position, where the complexity has grown so much that we are having difficulties maintaining this project. 

As long as a project is simple, it is easy to add more people to it and crucially, it is easy to remember all the scenarios we are covering. 

The more a project is complex, the longer it takes for new people to help in a meaningful way. The project becomes more and more dependant on its original authors, the only ones, who still know what complexity was added where and why. But the project also becomes more and more buggy, because of forgotten features and forgotten flows. And as it becomes more buggy, it also uses flexibility. A significant number of bugs sooner or later become features. Users don't know which functionalities were intended and which were not. They start relying on the broken functionality and every change from here on is a brake of promise. 

Interestingly, teams are sometimes using tests to alleviate this problem. Even if something was unintentional, as long as a test is asserting it, it will alarm us if we accidentally change the logic. But I would argue that this is a futile defence. Very few tests are properly read, understood or maintained. Such tests are just like sending perpetual drunken border officers to the border. We see them, but we do not take them seriously. 

### Is every exception evil?

On the other hand, when we write our code, we want it to be used by real-life people in real-life problems. Now, show me 1 problem in nature, which has a clean, easy solution with no exceptions! There are none. Life is complicated and so is code.

It is only in theoretical settings, that we can *"ignore the air-resistance in this physics formula"*. 

### And still, simplicity is better

And still, we need to know what the ideal is. We need to know what we are striving for so that we will know when we bend away from it so that we might know why we've bent away from it.

There is no magic solution, there is no 3 steps guide. Whether a good balance was struck between simplicity and complexity only becomes evident later on. Once the decision is often unchangeable or expensive to change.

But if our plan is to continue working on some project for at least a bit longer, we should think of our future selves, who will have to live with this decision. 

Is this feature really good in the long run?

