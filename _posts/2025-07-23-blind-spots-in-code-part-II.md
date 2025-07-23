---
title: "Blind Spots in Code Exhibit B: I Just Need to Confirm Something (But I'm Pretty Sure I'm Right)"
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
  - title: J. Klayman, Y.-W. Ha, Confirmation, disconfirmation, and information in hypothesis testing, 1987
    link: https://scholar.google.com/citations?view_op=view_citation&hl=en&user=PsHLbGUAAAAJ&citation_for_view=PsHLbGUAAAAJ:u5HHmVD_uO8C
  - title: "Jetzen T, Devroey X., Matton N. and Vanderose B., Towards debiasing code review support, 2024"
    link: https://arxiv.org/abs/2407.01407
  - title: "Salman I., Turhan B. and Vegas S., A controlled experiment on time pressure and confirmation bias in functional software testing, 2018"
    link: https://www.researchgate.net/publication/329751502_A_controlled_experiment_on_time_pressure_and_confirmation_bias_in_functional_software_testing
  - title: "D. Spadini, G. C¸ alikli, and A. Bacchelli, Primers or reminders? The Effects of Existing Review Comments on Code Review, 2020”"
    link: https://sback.it/publications/icse2020.pdf
  - title: "S. Chattopadhyay, N. Nelson, A. Au, N. Morales, C. Sanchez, R. Pandita, and A. Sarma, A tale from the trenches: cognitive biases and software development, 2020"
    link: https://d1wqtxts1xzle7.cloudfront.net/92130960/ICSE2020_Bias-libre.pdf
---

The previous chapter was all about anchoring bias, which makes us glue ourselves to the first idea we come across (is whispered to us). This chapter is dedicated to **confirmation bias** and **accessibility bias**, which can inhibit innovation when they make us stubbornly stick to unproven ideas.

Why is fighting cognitive biases important? Because research shows cognitive biases lead to more bugs and to a lot of wasted time:

> Not only are biases frequently present during development (45.72%), but also biased actions are significantly more likely **to be reversed later**. Furthermore, developers spend a **significant amount of time reversing** these biased actions.
<figcaption>
&mdash; S. Chattopadhyay et al., A tale from the trenches: cognitive biases and software development
</figcaption>


<!--more-->

## Previous chapter
⏮️ [Blind Spots in Code Exhibit A: Because Writing a Fresh Query Is Too Much Work]({% post_url 2025-07-21-blind-spots-in-code-part-I %})


## Exhibit B: I just need to confirm something (but I'm pretty sure I'm right)

**Confirmation bias** is about being deaf to everything that contradicts your beliefs. Your mind has been made up. This is unchangeable. It is

> the tendency to search for, interpret, favor, and recall information in a way that confirms that confirms or supports one's prior beliefs or values.
<figcaption>
&mdash; Wikipedia: Confirmation bias
</figcaption>

**Accessibility bias** is to truly, really truly trust your gut. _"I saw the problem and the first thing I thought of was Y, so Y must be the best solution."_ It's a cognitive bias, where people trust that 

> if something can be recalled, it must be important, or at least more important than alternative solutions not as readily recalled, is inherently biased toward recently acquired information.
<figcaption>
&mdash; Wikipedia: Availability heuristic
</figcaption>

**We love to forget that software engineering combines the individual and the collective**, there are (most often) 2 steps in creating software. **We first pour our individual technical knowledge into a solution**, we stare at a screen or at a board for hours. But right after the code is written, **we go out into the collective to defend it, in the form of PR reviews**, meetings and discussions. And the probability that we fail to solve the original problem is just as high at the first stage (creating a technical solution) as it is at the second stage (defending the solution in front of out peers).

Our work is just as social as it is technical, and all social activities are deeply affected by cognitive biases.

So, now let's look at how we fall pray to biases in software development.


## A bias for me, a bias for you


When we are asked to create a completely new project for something, **which framework will we choose? A known framework, of course, one that we have already used preferably**, right? We are hardly going to go researching for a new framework.

And if a team member suggests a new framework? We will immediately point out how that one won't be any good, because it lacks these 2 minor features our framework has, but we will be silent about the fact that we won't really need these 2 features. 

Or maybe we'll be even more generic and claim that using the good old framework is better, because **these new frameworks are not "mature enough"** and not "battle-tested" and anyway, aren't these new frameworks just "different, not better"?

However, **the accessibility bias also works the other way**. The team member suggesting the new framework might be pushing for it just **because she read about it last month**. Since then, she have been itching to test it out somewhere, anywhere. Suddenly, all she can see is the glittering features of the new framework, the promise of easier work, the poetry of the new code... _"It's just going to be such a joy to work with the new framework"_.

Always picking the new thing and always sticking with the old thing, both stances often stem from cognitive biases.


## I am not infallible, check my work

And how do we review PRs?

PR reviews are just a spectacular breading ground for biases. Again, because it is a very social activity.

The idea of PR reviewing is great, it's the same as peer-reviewing a scientific paper. **We need to double-check everybody's work, not because we don't trust people, but because we are wisely accepting our own imperfections.** Everybody can make mistakes, small typos or big, silly logic errors. If we work together, we can catch bugs in the making, before they reach our users.

This is all in theory, however.

In practice, PRs as well as scientific papers are often poorly peer-reviewed. The reason? **It is SOOOO MUCH WORK to review something!** And this is work that **isn't really appreciated, nor is it rewarded**. We neither care if you did a good nor are we going to award you for it.

There is basically nothing in it for you, no reason to do a good job at reviewing. 

Spending a good amount of time and energy to deliver a thorough review can even hurt you substantially. **People hate reviewing even their own code, so if you are offering excellent reviews for free, then why should their brains not take this shortcut?** There really isn't any point in doing a wholesome review.

What do devs often do to reduce the load of reviewing? We apply shortcuts, the same ones that are classified as cognitive biases.

We:
- focus on the author, **what are the things this author usually does wrong** (confirmation bias - what do we already believe about this author)
- focus on **recent production bugs**, the bugs that are fresh in our minds and for which we can still easily remember the cause and solution (availability bias - what is fresh in our minds)
- focus on our own recent code changes, **let's just double-check that the open PR plays nicely with our own newest code, others will review their own code too** (availability bias)
- focus on the **existing PR comments**, thinking somebody else maybe already did this work for us (availability bias, bystander effect)
- ...

Reviewing something is surely better than reviewing nothing 🤪. 


## Can you please revert your PR? We don't need those changes anymore


One of the most annoying parts of software work is when **your code changes get deleted**. All the effort spent crafting that code was for nothing. **You might as well have gone for some icecream and a walk in the park.** The result would have been the same. 

Sometimes it's about **whole projects being hyped as very important**. Their importance demands stress from you and your team, it demands heightened care, maybe even overtime. But not long after the work is done, maybe as soon as the code reached your customers, it turns out this project wasn't that consequential after all. Maybe the customers don't like it, or maybe it's worse: they don't care. This whole project was the product of somebody's cognitive bias. **Somebody up the chain really, really(!) believed that this _will_ be a valuable software solution... and they based this belief on nothing.** All the work and care you put into this project were superfluous. **Your code was born dead.**

Other times it's about smaller changes. A bug happens in production. Two people look into it. One immediately "finds the culprit", one specific logic needs to be redone. The other person doesn't believe this theory and keeps looking. **The first person goes into overdrive** and spends hours fixing the logic, **then they push the logic to production only for the bug to not be affected**. The real culprit was found just minutes later by the second person. It was just a setting, hidden somewhere else in the code. Time to revert the first person's PR.

Chattopadhyay et al. observed bias and action reversals among developers at work, **in real-life situations, not carefully crafted laboratory settings**. They showed that **actions triggered by biases have a much higher likelihood of being reversed later on**. And also that **actions that had to be reversed are most likely to have been biased actions**.

> Figure 1a (tn: below) shows the distribution of developer actions (biased or non-biased), and whether it led to a negative outcome. There were 953 actions with biases, and 1131 without. Similarly, there were 1104 reversal actions and 980 non-reversal actions. **Reversal actions were more likely to occur with a bias - 68.75% (759/1104 cases), and biased actions were more likely to be reversed - 79.64% (759/953 cases).**
<figcaption>
&mdash; S. Chattopadhyay et al., A tale from the trenches: cognitive biases and software development
</figcaption>

|                          | Biased Actions | Unbiased Actions | Total    |
|--------------------------|----------------|------------------|----------|
| Action was reversed      | 759            | 345              | 1104     |
| Action was NOT reversed  | 194            | 786              | 980      |
| Total                    | 953            | 1131             |          |
{:.last-column .last-row .first-column}


| Time spent                           | Biased Actions  | Unbiased Actions | Total            |
|--------------------------------------|-----------------|------------------|------------------|
| Action was reversed                  | 7839 sec (2.2h) | 3348 sec (0.9h)  | 11187 sec (3.1h) |
| Action was NOT reversed              | 1837 sec (0.5h) | 8383 sec         | 10220 sec        |
| Total                                | 9676 sec (2.7h) | 11731 sec        |                  |
{:.last-column .last-row .first-column}

These two tables above are the _"Figure 1a"_ mentioned in the quote. 

They show how much harm biased actions can cause. **Reversed actions took up 3.1h of work and 70% of these were biased actions.** So, if there were no bias, far fewer actions would need to be reversed, far less time would be wasted on reversing actions.

**Cognitive biases are fast, they let us run towards the goal. This is their benefit and their trouble.** 

Getting to the destination faster and with less effort is great, but only as long as we are running towards the right goal. Sometimes we run towards just any goal, just for the sake of running. 

**It's healthy to slow down occasionally and double-check what we are running towards.**


## The test coverage is 200%, no!, 300%, so the code must be good


How do we achieve a good test coverage? By testing the happy path, of course. **By testing the scenarios for how our code is supposed to work** instead of testing for how it can be broken.

If I have the function `def send_email(msg: str, recipient: str)`, then I only need to write a test for `send_email("Hi!", "my@email.com")` right? No need to test for HTML-text of for an empty recipient (`recipient=""`) or for an invalid email address or for a **too long msg** or for a broken HTML msg or ...

A surprisingly huge number of papers are researching cognitive biases in software testing. And they are concluding that we like testing almost only the expected behavior. **We prefer writing tests that confirm the code works, not tests that disprove it. Even among professional QA engineers, this is a common bias.**

Is it time pressure that causes this? 

Surely, it is not that we don't know or don't care that unexpected input data must also be tested?

If I'm testing the **login**-method, surely, it is clear that **at the very, very least we need 2 tests: a positive and a negative test, a test for a successful login and a test for a failed login.** Surely, the correct behavior of this method is to let in only people with correct credentials and to let them in only as themselves, right? But this demands more than 1 test. Even more than just 2 tests. 

A paper called "A controlled experiment on time pressure and confirmation bias in functional software testing" researched this topic. Unfortunately, it found out that time pressure is downgrading our testing skills. We simply have very poor testing skills to begin with. Here's their conclusion:

> We observed, overall, **participants designed significantly more confirmatory test cases as compared to disconfirmatory ones**, which is in line with previous research. However, **we did not observe time pressure as an antecedent (tn: cause)** to an increased rate of confirmatory testing behaviour.
> 
> People tend to design confirmatory test cases regardless of time pressure. For practice, we find it necessary that testers develop self-awareness of confirmation bias and counter its potential adverse effects with a disconfirmatory attitude.
<figcaption>
&mdash; Salman I., Turhan B. and Vegas S., A controlled experiment on time pressure and confirmation bias in functional software testing
</figcaption>   

They designed an experiment with 43 participants. All participants had little experience in software testing:

> More than 80% of the participants have less than 6 months of testing experience both in academia and industry, which is equivalent to almost no testing experience [...]
> 
> [...] 40% of the participants have industrial experience, i.e. more than 6 months.

The researchers presented the participants with the task to write tests specification for a new app. The software development was to be test-driven, so the participants didn't need to write actual, passing tests, but only the test specifications, the test scenarios as input + expected output pairs.

Half of the participants were given 30 minutes to write the tests, while the other half had 60 minutes (before the experiment the researches tested that 45 mins is about enough to finish the task, thus the 60mins limit seemed very adequate). The 30-mins group also got 3 reminders about the time running out, this happened at the 15th, 20th and 25th minute. This was done to build the pressure.

When we test only what we expect to work, we miss the opportunity to uncover corner cases or conflicting behaviors that can cause failures. Breaking free from confirmation bias means deliberately seeking out tests that challenge assumptions, which is the only way to build robust software.


## Next time, check that the couch doesn't stink


I would guess that the thing that drives us towards writing confirmatory tests and forget about disconfirmatory tests is the natural world that we live in. We make this same mistake in practically everything we do.

In the beginning, there is nothing. Then we create/buy something. **And we expect that thing to just be good enough.** We are focused on acquiring the thing, we don't expect it to be subpar or to need further improvements.

An example: I want to rent an apartment and I want it to have a couch. So, my test will be: does the apartment have a couch.

After moving in, I see the couch is old and uncomfortable. So, for my next apartment my test will be: does the apartment have a couch that is comfortable to sit on.

After I move again, I see that the couch is now comfortable, but small. So, my next test will be: does the apartment have a couch that is comfortable to sit on and big enough for 3 people.

After I move again, I see that the couch is now comfortable, big enough for 3 people, but it stinks. So, my next test will be: does the apartment have a couch that is comfortable to sit on, big enough for 3 people and does not stink.

And so on.

**It is only with lots and lots of experience that we can finally stretch our imagination to think of all the things that can go wrong, even though we've never yet seen them go wrong.**


## How to counter-act

All is not lost.

**The bad news is that nobody is immune to biases (not even your boss). The good news is that knowing about them takes half of their power away.** 

> To eliminate biases (i.e., debiasing), previous research has shown that **neither applying more effort nor being more
experienced in a field helps mitigate cognitive biases** [Fischhoff B, Debiasing, 1982]. However, **training on cognitive biases** and applying specific techniques **can make a substantial difference**. This has been proven not only for experts in a field but also to affect the judgment of non-experts [9].
<figcaption>
&mdash; Jetzen T, Devroey X., Matton N. and Vanderose B., Towards debiasing code review support
</figcaption>

**The trick is to be attentive to your motivations (and silently you can also speculate about other people's motivations).** What is behind your decisions (and theirs)?

Are you sure you are choosing the best solution and not just the fancy one? Have you fallen into decision fatigue? Do you just not like a co-worker? Are you just stressed out from the deadline?

**It helps to strategically pause projects.** I know they _said_ the project is super urgent, but what if _today_ you just **do some research and open up discussions** about possible solutions and their **repercussions**? 

I've learnt this helps the project a lot. **In my experience, a breather creates space for good decisions to be made. It's always great, when good decisions are made _at the start of a project_, instead of after some code already needs to be reverted.** 

Generally, there is also other stuff to work on, so it's not like you are sitting, waiting and watching the paint dry during the pause.

I love running, but let's just first make sure we all know which direction we are running towards and why.


## Next
⏭️ To be continued...

