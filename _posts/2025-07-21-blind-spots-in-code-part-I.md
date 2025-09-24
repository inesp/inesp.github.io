---
title: "Why do smart devs write silly code? Exhibit A: Because Writing a Fresh Query Is Too Much Work"
conf_title: "Why do smart devs write silly code? Cognitive Biases Behind Everyday Coding Mistakes"
conf_title_2: "Why do smart devs write silly code? How Invisible Biases Lead to Bugs, Delays, and Rollbacks"
excerpt_separator: <!--more-->
tags: bias-in-code
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

We are not infallible. **We are not mathematical.** We make just as many mental shortcuts as anybody else. We fall pray to cognitive biases just the same as everybody else does. 

The word "bias" has become synonymous with movements for inclusion of people, but cognitive biases are a far bigger topic than just being about people exclusion. 

**Cognitive bias is everywhere around us.** Bias is:
- when you only read articles (**listen to co-workers**) that support your world view (confirmation bias), 
- it's when you stick to buying coffe from the same place for 20 years (**stick with an old framework**), even though the coffe isn't even that great (status quo bias)
- it's when you dislike French people (**Javascript**), because you had one bad experience (implicit bias),
- and sooooooo maaaaaaany more ...

Our biases are holding us all back. But it needn't be this way.

{% include image.html alt="Anchoring" src="bias/anchor.jpg" ref="https://www.pexels.com/photo/freediver-ascending-in-blue-underwater-cave-33042384/" %}

<!--more-->


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

Bias can quickly grow out of control. They generally start out as a rational shortcut, but they always have the potential to outgrow the rational space. **The rational and irrational have a very muddy border between them.**

The biggest problem with cognitive biases is that you (generally) don't see them. **Cognitive biases are blind spots. They are the thing you don't pay attention to.** They are in control, not you. And wouldn't you love to take back control over your own decisions?


## Exhibit A: Anchors are a chain with a weight at the end


Anchoring is a cognitive bias, where people rely too heavily on the **first piece of information** they see (the "anchor") when making decisions.

What if I give you a programming task: _"Compile me the top 10 list of winners in our latest game"_ and then I add: _"and here is the query we used for the same task with the previous game"_. What will be yor next step?

Surely, you will first inspect the existing query. 

You can already picture it: if my query works, then this task is 1/10 on the difficulty scale. This task will be done in a jiffy. You can go home early today.

This whole optimistic outlook is being painted in your head in a split second... by my words alone.

All you need to do is check if that query works for your data. And because checking something is obnoxious, as it takes a surprising amount of mental energy, you most likely won't do your _best_ job at it.

**Even if the query won't immediately produce the correct result for you, you will still take this query as your starting point. You will try to tweak it, little by little, until it works for you.** Instead of writing a new query from scratch.

**And that is how anchoring got you to waste your time.** Who says that starting from my query will be faster than starting from scratch?!


## Code produced while anchored is less correct than code produced while floating freely


What I described to you is very similar to an experiment conducted by G. Allen and B. J. Parsons for their paper "A Little Help can Be A Bad Thing: Anchoring and Adjustment in Adaptive Query Reuse".

In an experiment, they asked participants to write SQL queries. Some participants were given a sample query (the "anchor") to "help" them with the task of writing a new query, while others weren't given anything. All in all 157 participants took part in the experiment.

The sample query was a functioning SQL query that was similar to the new task at hand, but it wasn't an outright solution.

> To adequately adjust a sample query, a subject needed to make both **surface-structure** modifications that required little cognitive effort and **deep-structure modifications** that required substantially more cognitive effort.
<figcaption>
&mdash; G. Allen and B. J. Parsons, A Little Help can Be A Bad Thing: Anchoring and Adjustment in Adaptive Query Reuse
</figcaption>

As expected, the participants who received a sample query made use of it. They took the helpful example, adjusted it, and shaped it into something that (more or less) fit the task.

Unfortunately, their end results generally fit less, not more.  Those who _didn’t_ get a sample query performed better than those who had. 

Starting from scratch led to more correct solutions. The group with no sample query had a **44.3% success rate**, while the group that got a sample query had only **21.5% success rate**. **Turns out, a ready-made starting point can quietly steer you in the wrong direction.**

|              | With sample query | Without sample query |
|--------------|-------------------|----------------------|
| Success rate | 21.5%             | 44.3%                |
{:.first-column}

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


## Anchoring makes your very confident

The study also observed another very unfortunate side effect of anchoring: **overconfidence**.

Participants who had an anchor ended up with fewer correct solutions, but they were just as sure they've solved the task correctly as those who started from scratch.

In other words, the anchor didn’t just lead them astray, it also gave them a false sense of certainty.

> Even though reused queries are more likely to have errors, query writers are not correspondingly less confident of their correctness. This is particularly troubling, since the **unwarranted overconfidence increases the likelihood that decisions may be made based on incorrect query results**.  Consequently, query reuse has the potential to lead to bad outcomes for an organization.
<figcaption>
&mdash; G. Allen and B. J. Parsons, A Little Help can Be A Bad Thing: Anchoring and Adjustment in Adaptive Query Reuse
</figcaption>

I am speculating here, but I'd say 2 things are happening:
1. anchoring narrows your view, if you stay in one place, you can only see what is visible from that one spot
2. you never did a deep dive into the problem, you never tried to truly understand how deep it actually goes

Either way, **the end-result is that you don't truly understand the expanse of the problem and thus have no reason to mistrust your simple solution**. From where you stand the problem looks simple, so you assume the solution is simple too.

## AI will make everything better, right? right?


🤖 This same pattern very much applies to working with AI assistants, like Claude, Cursor or Copilot. Whatever the bot suggests, that is your anchor. And as we've seen, **anchoring leads to more bugs in the code** and also to **overconfidence in the correctness of that code**. 

That’s been my personal experience too. AI-generated code solutions somehow instill an astonishing level of confidence in some developers.

**It's hard to convince a dev that thair AI-generated code has major bugs, when neither of us actually did the work of understanding the problem.** 

_I glanced over your PR. You skimmed over the problem. Now we’re both standing here pretending we know what’s going on. We do not._


## Experience sometimes helps

Having been wrongly anchored before makes you more aware of this problem. The chances of you being anchored again (in the same way) are ever so slightly reduced.

As they say: "fool me once, shame on you, fool me twice, shame on me". 

Thus, we can say that **experience helps to reduce the anchoring effect. Sometimes. Somewhat.**

The reason experience isn't a magic cure-all is that **there are a million different ways to be anchored**. It takes a very skeptical mind to spot them. And even if you have one of those, all anchoring just cannot be avoided.

Here's an example from a paper called "A cognitive perspective on pair programming" where it was observed that **experts refuse to read the documentations**, while **novices refuse to research the whole range of solutions**.

> Experts exhibit confidence biases as they were reluctant to examine documentation. Novices were less susceptible to this bias.
> 
> Experts were more willing to explore wide range of solutions rather than anchoring to just one solution.
Novices, due to their inability to identify such wider range of solutions, tended to anchor to their initial solution
<figcaption>
&mdash; R. Jain, J. Muro, and K. Mohan, A cognitive perspective on pair
programming
</figcaption>


## Conclusion

When we are anchored, we write worse code, **code with more bugs. This has been proven.**

We can get anchored in a million ways. Spotting them demands from us to be at least a bit over the top skeptical.

The first step to overcoming anchoring is to **be aware of it**. Once we know how the trick works, we can start taking precautions against it.


## Next
⏭️ [Why do smart devs write silly code? Exhibit B: I Just Need to Confirm Something (But I'm Pretty Sure I'm Right)]({% post_url 2025-07-23-blind-spots-in-code-part-II %})

