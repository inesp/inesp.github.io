---
series: Cognitive Biases in Code
title: "Exhibit A: Because Writing a Fresh Query Is Too Much Work"
tags: ["Cognitive Biases in Code", "Engineering Research"]
next_post: 2025-07-23-blind-spots-in-code-part-II
biblio:
  - title: "R. Mohanani, I. Salman, B. Turhan P. Rodriguez & P. Ralph, Cognitive Biases in Software Engineering: A Systematic Mapping Study, 2020"
    link: https://www.researchgate.net/publication/328410759_Cognitive_Biases_in_Software_Engineering_A_Systematic_Mapping_Study
  - title: "Wikipedia: Status quo bias"
    link: https://en.wikipedia.org/wiki/Status_quo_bias
  - title: "Wikipedia: Confirmation bias"
    link: https://en.wikipedia.org/wiki/Confirmation_bias
  - title: "Wikipedia: Anchoring effect"
    link: https://en.wikipedia.org/wiki/Anchoring_effect
  - title: "G. Allen and B. J. Parsons, A Little Help can Be A Bad Thing: Anchoring and Adjustment in Adaptive Query Reuse, 2006"
    link: https://www.researchgate.net/publication/221598895_A_Little_Help_can_Be_A_Bad_Thing_Anchoring_and_Adjustment_in_Adaptive_Query_Reuse
  - title: "R. Jain, J. Muro, and K. Mohan, A cognitive perspective on pair
programming, 2006"
    link: https://citeseerx.ist.psu.edu/document?repid=rep1&type=pdf&doi=2e0461a5259134e8f59ac9eda1c5df185f607a3d
---

> It works on my machine.

This might just be the original example of bias that we, developers, just can't seem to overcome when creating software.

**We trust ourselves excessively.** And this mindset **confines us (and the software** we produce) to the **teeny-tiny space that we happen to occupy at this particular point in time**. When we are the great (and only) judge, our code is physically limited to the set of experiences and skills we have, to the few solutions we remember the moment we write that bit of code.

We are not infallible. **We are not mathematical.** We make just as many mental shortcuts as anybody else. We fall prey to cognitive biases just the same as everybody else does. 

The word "bias" has become synonymous with movements for inclusion of people, but cognitive biases are a far bigger topic than just being about people exclusion... they are more about thought exclusion.

**Cognitive biases help us in our decision-making. They are thought habits.** They save us time and energy.

**And they are everywhere around us:** They activate:
- when you only read articles (**listen to co-workers**) that support your world view (confirmation bias),
- when you stick to buying coffee from the same place for 20 years (**stick with an old framework**), even though the coffee isn't even that great (status quo bias)
- when you dislike French people (**Javascript**), because you had one bad experience (implicit bias),
- and sooooooo maaaaaaany more ...

Our biases are holding us all back. But it needn't be this way.

{% include image.html alt="Anchoring" src="bias/anchor.jpg" ref="https://www.pexels.com/photo/freediver-ascending-in-blue-underwater-cave-33042384/" %}



{% include toc.html %}

## Biases are good

After I've scared you a little bit, let me now present the flip side of the coin.

**Cognitive biases are just shortcuts in decision-making.** 

**Biases make life possible.** They are needed because they make us choose faster. In this world, indecision can get you killed. When a lion is chasing you, you can only survive if you find a solution fast. **Will you take this job or not? You have to decide now. And with too little information.**

Had we not developed biases, we wouldn't be alive, not as individuals, not as a species.

Biases are just a little more advanced form of "last time I ate _This_ thing and liked it, let's order _This_ thing again today".


## Biases are bad

With speed come mistakes.

**Biases speed up our decisions, but we pay for this speed with the loss of correctness.**

I cannot review 1,000 job applications in a day if I treat every applicant like a beautifully complex human, even though they are one. 

But I can do it by applying a **handful of quick, slightly arbitrary criteria**, hoping they’ll shrink the list down to the "good-enough" candidates. Not the best candidates, just the good-enough candidates.

The filter-biases start strong but their logic quickly dwindles, it might go like this:
1. Let's filter the candidates to those who already work in this field. ➡️ debatable, but plausible
2. Let's also filter to only the top 3 universities in the country. ➡️ pseudo-intellectual
3. And of course, ugly fonts are a no-go. ➡️ arbitrary

Biases can quickly grow out of control. They generally start out as rational shortcuts, but they always have the potential to outgrow the rational space. **The rational and irrational have a very muddy border between them.**

The biggest problem with cognitive biases is that you (generally) don't see them. **Cognitive biases are blind spots. They are the thing you don't pay attention to.** They are in control, not you. And wouldn't you love to take back control over your own decisions?


## Exhibit A: Anchors are a chain with a weight at the end

Anchoring is a cognitive bias where people rely too heavily on the **first piece of information** they see (the "anchor") when making decisions.

### An example: You are a game-developer

Let's say **you're a developer** at a company that builds little **mini-games for users**. Last month, one such game went live and people loved it and played it a lot. The company announced that the top 100 players would get a reward... a t-shirt or plane tickets or something.

Your boss asks you to pull the **list of top 100 players from the database**. You have 2 tables: 
- a list of all scores for every gameplay, 
- and a list of all users. 

The boss wants the **best scores, for every player, without duplicates**.

![game-tables.svg](/assets/bias/game-tables.svg)

You start thinking about the SELECT statement, but before you get very far, the boss adds: _"Actually! No need to think too hard! We have the SELECT statement from last month right here."_

The game was a _bit_ different last month. It didn't have one score, it had speed and number of coins collected. But generally, it was a very similar game.

**So... should you use the old SQL from last month?**

I'm pretty sure most of us would say _"Yeah! Of course!"_ Inspect it, run it, see if the results look good.

**We all want to save time.** Time is like the ultimate limited resource in our lives. And this sounds like a **generic task** for this company, so let's use the **generic solution**. If this old query just works, you can wrap up this task in a jiffy. You can go home early today.

And if the query doesn't immediately produce the correct result? You'll probably still take this query as your starting point. You'll tweak it, little by little, until it works. Because writing a query from scratch is _so much more complicated_.

But....

## Checking correctness is surprisingly exhausting

It takes a **surprising amount of mental energy** to check for correctness. Often much more than it looks like it will take.

**It _looks_ so simple.** It _looks_ as if the real work has already been done, and we just need to "stamp" the result. How long can that possibly take? A minute? Five minutes?

![anchoring-trap-flow](/assets/bias/anchoring-trap-flow.svg)

But as soon as we start working on it, it becomes clear that it will take longer. This contradicts our expectations that the query would be a shortcut.

So what do we do? **We don't go too deep.** We don't think about the various edge cases too precisely. **If it looks more or less right... it probably is right.**

And that is how anchoring gets us. **Who ever said that taking the old query is going to save us time?** We just assumed that, because that's how it was presented to us... and also because we _wanted_ it to be true.


## Code produced while anchored is less correct than code produced while floating freely


What I described to you is **very similar to an experiment** conducted by G. Allen and B. J. Parsons for their paper "**A Little Help can Be A Bad Thing**: Anchoring and Adjustment in Adaptive Query Reuse".

In an experiment, they asked participants to write SQL queries. Some participants were given a sample query (the "anchor") to "help" them with the task of writing a new query, while others weren't given anything. All in all, 157 participants took part in the experiment.

The sample query was a functioning SQL query that was similar to the new task at hand, but it wasn't an outright solution.

> To adequately adjust a sample query, a subject needed to make both **surface-structure** modifications that required little cognitive effort and **deep-structure modifications** that required substantially more cognitive effort.
<figcaption>
&mdash; G. Allen and B. J. Parsons, A Little Help can Be A Bad Thing: Anchoring and Adjustment in Adaptive Query Reuse
</figcaption>

As expected, the participants who received a sample query made use of it. They took the helpful example, adjusted it, and shaped it into something that (more or less) fit the task.

Unfortunately, their end results generally fit less, not more.  **Those who _didn't_ get a sample query performed better than those who did.**

Starting from scratch led to more correct solutions. The group with no sample query had a **44.3% success rate**, while the group that got a sample query had only **21.5% success rate**. **Turns out, a ready-made starting point can quietly steer you in the wrong direction.**

![bias/success-rate-comparison](/assets/bias/success-rate-comparison.svg)

> Hypothesis 1 _(tn: Reuse of queries results in more errors than starting from scratch  )_ is supported.  This result is extremely compelling. It means that **when individuals compose queries from scratch they are more likely to product(tn: produce) the correct answer than when they modify an existing query;** [...]  
> 
> Average performance in our sample showed that subjects generated **the correct answer 44.3 percent** of the time when no sample query was presented and **only 21.5 percent** of the time when an example was available.
> 
> [...]
> In our sample, subjects correctly adjusted from 85 percent of surface-structure anchors and **only 31 percent of deep-structure anchors**.
<figcaption>
&mdash; G. Allen and B. J. Parsons, A Little Help can Be A Bad Thing: Anchoring and Adjustment in Adaptive Query Reuse
</figcaption>

Anchoring limits your ability to think freely, to explore the problem space and all possible solutions. Consequently, it leads to **more bugs in your code**.


## Anchoring makes you overconfident

The study observed another very unfortunate side effect of anchoring: **overconfidence**.

Participants who had an anchor ended up with fewer correct solutions, but they were just as sure they'd solved the task correctly as those who started from scratch.

Not only did the anchor lead to more buggy code, it also hid these bugs from the developers. The developers seemed to have lost some of their ability to judge the quality of the code. They got overconfident.

> Even though reused queries are more likely to have errors, query writers are not correspondingly less confident of their correctness. This is particularly troubling, since the **unwarranted overconfidence increases the likelihood that decisions may be made based on incorrect query results**.  Consequently, query reuse has the potential to lead to bad outcomes for an organization.
<figcaption>
&mdash; G. Allen and B. J. Parsons, A Little Help can Be A Bad Thing: Anchoring and Adjustment in Adaptive Query Reuse
</figcaption>

I am speculating here, but I'd say 2 things are happening:
1. anchoring narrows your view, if you stay in one place, you can only see what is visible from that one spot
2. you never did a deep dive into the problem, you never tried to truly understand how deep it actually goes

You neither understand the full expanse of the problem nor the choices your solution is making.

From where you stand the problem looks simple, so you assume the solution is simple too.

![bias/two-problem-spaces.svg](/assets/bias/two-problem-spaces.svg)

As far as I can tell this happens more than we think. During my years, I've seen several projects that would have gone much better, had we started from scratch, instead of from something that looked sooo similar ... from afar. But turned out to not be similar ... from up close.

The problem with starting from an existing thing is that you have to acquire a deep understanding of 2 things, not just ONE: 

- your actual problem 
- and also of the problem space of that other thing. 

Only then can you adequately compare them and understand if and how the anchor can actually help you.

**The seductive promise of the anchor is that it saves you work.** But the anchor demands its own cognitive tax. Often, this tax exceeds what you would have paid just doing the thing fresh.


## AI will make everything better, right? right?


This same pattern very much applies to working with AI assistants, like Claude, Cursor, or Codex. Whatever the bot suggests, that is your anchor. And as we've seen, **anchoring leads to more bugs in the code** and also to **overconfidence in the correctness of that code**.

That's been my personal experience too. AI-generated code solutions somehow instill an _astonishing_ level of confidence in some developers.

**It's hard to convince a dev that their AI-generated code has major bugs.** The problem is, that to prove them wrong, _I'd_ have to do the work of researching the problem properly. And _I also_ don't want to put in that work, just like they didn't bother to.

_I glanced over your PR. You skimmed over the problem. Now we’re both standing here pretending we know what’s going on. We do not._


## Experience sometimes helps

Being fooled once has its benefits.

As they say: _"fool me once, shame on you, fool me twice, shame on me"_.

After you've experienced anchoring once, you become more aware of it, and more embarrassed by it. You can spot it better next time.

Thus, we can say that **experience helps to reduce the anchoring effect. Sometimes. Somewhat.**

Unfortunately, there are a million different ways to get anchored. It takes an exceptionally skeptical mind to spot them all. And even then, complete immunity just isn't possible.

One study found that **experts often get anchored because they refuse to read the documentation**. Meanwhile, **novices get anchored because they refuse to explore all possible solutions**, they jump in too quickly.

> Experts exhibit confidence biases as they were reluctant to examine documentation. Novices were less susceptible to this bias.
>
> Experts were more willing to explore wide range of solutions rather than anchoring to just one solution. Novices, due to their inability to identify such wider range of solutions, tended to anchor to their initial solution.
<figcaption>
&mdash; R. Jain, J. Muro, and K. Mohan, A cognitive perspective on pair programming
</figcaption>

So apparently, we're all destined to be anchored. **But we should at least try to choose when and where it happens.**


## Conclusion

When we are anchored, we write worse code, **code with more bugs. This has been proven.**

We can get anchored in a million ways. Spotting them demands a skeptical mind.

The first step to overcoming anchoring is to **be aware of it**. Once we know how the trick works, we can start taking precautions against it.



