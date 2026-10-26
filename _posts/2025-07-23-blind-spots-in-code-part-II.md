---
series: Cognitive Biases in Code
title: "Exhibit B: I Just Need to Confirm Something (But I'm Pretty Sure I'm Right)"
tags: ["Cognitive Biases in Code", "Engineering Research"]
prev_post: 2025-07-21-blind-spots-in-code-part-I
next_post: 2026-03-23-blind-spots-in-code-part-III
biblio:
  - title: "Wikipedia: Confirmation bias"
    link: https://en.wikipedia.org/wiki/Confirmation_bias
  - title: "Wikipedia: Availability heuristic"
    link: https://en.wikipedia.org/wiki/Availability_heuristic
  - title: "Wikipedia: Anchoring effect"
    link: https://en.wikipedia.org/wiki/Anchoring_effect
  - title: "Jetzen T, Devroey X., Matton N. and Vanderose B., Towards debiasing code review support, 2024"
    link: https://arxiv.org/abs/2407.01407
  - title: "Salman I., Turhan B. and Vegas S., A controlled experiment on time pressure and confirmation bias in functional software testing, 2018"
    link: https://www.researchgate.net/publication/329751502_A_controlled_experiment_on_time_pressure_and_confirmation_bias_in_functional_software_testing
  - title: "S. Chattopadhyay, N. Nelson, A. Au, N. Morales, C. Sanchez, R. Pandita, and A. Sarma, A tale from the trenches: cognitive biases and software development, 2020"
    link: https://d1wqtxts1xzle7.cloudfront.net/92130960/ICSE2020_Bias-libre.pdf
  - title: J. Klayman, Y.-W. Ha, Confirmation, disconfirmation, and information in hypothesis testing, 1987
    link: https://scholar.google.com/citations?view_op=view_citation&hl=en&user=PsHLbGUAAAAJ&citation_for_view=PsHLbGUAAAAJ:u5HHmVD_uO8C
---

The previous chapter was all about anchoring bias, which makes us cling to the first idea we come across. This chapter is dedicated to **confirmation bias** and **availability bias**, which can inhibit innovation when they make us stubbornly stick to unproven ideas.

Why is fighting cognitive biases important? Because research shows they lead to more bugs and wasted time:

> Not only are biases frequently present during development (45.72%), but also biased actions are significantly more likely **to be reversed later**. Furthermore, developers spend a **significant amount of time reversing** these biased actions.
<figcaption>
&mdash; S. Chattopadhyay et al., A tale from the trenches: cognitive biases and software development
</figcaption>

{% include image.html alt="Cognitive biases" src="bias/confirm.png" ref="https://www.pexels.com/photo/worms-eye-view-of-spiral-stained-glass-decors-through-the-roof-161154/" %}


{% include toc.html %}

## "I just need to confirm something (but I'm pretty sure I'm right)"

**Confirmation bias** is about being deaf to everything that contradicts your beliefs. Your mind has been made up. This is unchangeable. It is:

> the tendency to search for, interpret, favor, and recall information in a way that confirms or supports one's prior beliefs or values.
<figcaption>
&mdash; Wikipedia: Confirmation bias
</figcaption>

**Availability bias** is to truly, really truly trust your gut. _"When I saw the problem the first thing I thought of was Y, so Y must be the best solution."_ It's a cognitive bias where people believe that:

> if something can be recalled, it must be important, or at least more important than alternative solutions not as readily recalled, is inherently biased toward recently acquired information.
<figcaption>
&mdash; Wikipedia: Availability heuristic
</figcaption>


## All social activities are deeply affected by cognitive biases

IT work is just as social as it is technical. 

**We love to forget that software engineering combines the individual and the collective**.

There are 2 distinct phases in creating software: one is solitary and the other is social. 

The solitary phase is the physical action of writing words into code, it is about **pouring our technical knowledge into a solution**. We do this alone with our thoughts and our screens. 

The social phase is about the meetings and discussions that precede and also follow the solitary phase. Before we write some code, we often talk about it, about the expanse of the problem and the options for solutions. And after we write the code **we go out into the collective to defend it, in the form of PR reviews** (which got [their own chapter]({% post_url 2026-10-26-blind-spots-in-code-part-IV %})).

The probability that **we fail to solve the original problem is just as high at the solitary stage (creating a technical solution) as it is at the social stage (defending the solution in front of our peers)**.


## Laser-focused on (only) what is immediately accessible


When asked to start a new project, **which framework do we choose? A known one, of course.** Preferably one we've used before. We are hardly going to go researching for a new framework.

And if a team member suggests a new framework? We often jump to poke holes in it. Maybe it lacks two minor features that our suggested framework has. But we will be silent about the fact that we won't really need these two features. 

Or maybe we'll be even more generic and claim that using the good old framework is better, because **these new frameworks are not "mature enough"** and not "battle-tested" and anyway, aren't these new frameworks just "different, not better"?

We, as the oldtimer, focus on the good-old-framework, because knowledge about it is the most accessible to us. **We mainly focus on collecting information that confirms our viewpoint and are reluctant to give pause to opposing views.** We see ourselves as very rational, but what if it's just bias that is keeping us in place? 

However, **bias also works the other way**. The team member suggesting the new framework might just be excited **because she read about it in several places already.** This framework seems to be the great new thing, the thing that everybody will adopt sooner or later, so let's join the "sooner"-cohort. After reading soo much about it, all she can see is the glittering features of the new framework, the promise of easier work, the poetry of the new code... _"It's just going to be such a joy to work with the new framework"_.

Always choosing the new thing or always sticking with the old, both tendencies often stem from biases.


## Cognitive biases lead to code reverting

As I was researching this topic I stumbled upon a study that wanted to see cognitive biases in REAL life, not in laboratory settings, but as they happen at a developer's job.

They found a very interesting connection between **biased actions and action reversals**.

It is true that the number of participants was rather small. Too small really, to make sweeping statements, but boy are the results satisfying to talk about.

The study was done by S. Chattopadhyay et al. and is called _A tale from the trenches: cognitive biases and software development_. 

The researchers were observing a team of software professionals and wrote down **all the actions they saw and all the consequences.**

What they found is that **actions triggered by biases are more likely to be reversed later**. And also that **actions that had to be reversed are, overwhelmingly, biased ones**.

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

![Biased actions get reversed](/assets/bias/reversal-bias-chart.svg)

They show how much harm biased actions can cause. **Reversed actions took up 3.1h of work and 70% of these were biased actions.** So, if there were no bias, far fewer actions would need to be reversed, far less time would be wasted on reversing actions.

The researchers calculated that **developers lost approximately 25% of their entire working time** to reversing biased actions.

**Cognitive biases are fast, they let us run towards the goal. This is their benefit and their trouble.**

**The solution is to slow down occasionally ... and double-check what we are running towards.**


## Sisyphus's Project

This is one of the most disheartening parts of software work: writing code that gets deleted soon after. 

All the effort spent crafting that solution was for nothing! You might as well have gone for some ice-cream and a walk in the park. The result would have been the same. But no! You were stuck in the office writing some silly code that will never be used now.

Sometimes a whole project gets reverted. A whole, finished project.

And often this happens to a project that started out as very important, very valuable. The importance was so great that your team better be stressed out about it. Maybe even do some overtime.

But not long after the work is done, maybe as soon as the code reaches your customers, it turns out this project wasn't that consequential after all. Sometimes the customers just don't like it, but sometimes they don't care, which is arguably worse.

**This whole project was most probably the product of somebody's cognitive bias.**

Maybe it was somebody up the chain who really believed that this will be a valuable software solution. And they based this belief on... who knows what.

Maybe it was **confirmation bias**: people didn't actually listen to what the customers said, they just tried to scrape enough of the answers together to confirm their own plan.

Maybe it was **anchoring bias**: a different company also offers this feature, so it must be a feature that is valuable.

Maybe it was the **bystander effect**: the boss mentioned this feature and nobody was brave enough to question the idea's validity.

Maybe it was **optimism bias**: the team focused on the idea of how great this feature will be, how happy it will make the customers, and they ignored the reality of what is actually possible.

Or it could have been any number of other biases.

**Look at AI,** at the beginning, we were told it's going to cure cancer. But now that we've let it into the real world, it is mostly producing more spam, more convincing fake videos, and more convincing phishing emails.

**Just because it seems plausible for a new project idea to work, doesn't mean the project will actually turn out as hoped.**


## Stress triggers biases

Often biases are triggered by stress.

The boss wants something done **now!** Yesterday would also work. 

We believe them...

..and speed up our actions. But when we are moving fast, we rely on the subconscious more than the conscious, which means we rely on our biases: _"Let's just copy what we did last time! No time to think."_

But that is usually when we need to think more.

Over the years, I've noticed that the projects that went poorly were often the very same projects that we started in stress mode. **People tend to overestimate the urgency of certain tasks.**

And you, as the senior expert in your field, are in the meeting to **help** flesh out the true urgency and also true scope of the project (because scope and urgency do go hand in hand).

Let me emphasize first that I am NOT advocating for devs to be gatekeepers. I believe we, developers, already have a problem with this sort of attitude.

But as an expert, **you do need to start noticing when a project is being rushed without good foundations.** And this is when you can **constructively** push the conversation towards more planning and less running.

Once we have a few things figured out, we can immediately start running. Because the worst is to run like crazy, but then arrive at the wrong destination.

I've been taking this approach for quite some years now and I can truly say that it works like a charm. When I see a rushed project, **I focus a bit more on a written plan.** I want people to have a bit of time to think about it (preferably at least 24 hours, so they can sleep on it).

It forces everybody to think about the details of what they want and how they think things will work. And it forces developers to consider a few more edge cases and ask for more clarifications.

It really helps.


## Testing is suffering especially from confirmation bias

The last thing I want us to look at is testing.

How do we achieve a good test coverage? By testing the happy path, of course. **By testing the scenarios for how our code is supposed to work** instead of testing for how it can be broken.

If I have the function `def send_email(msg: str, recipient: str)`, then I only need to write a test for `send_email("Hi!", "my@email.com")` right? No need to test for HTML-text or for an empty recipient (`recipient=""`) or for an invalid email address or for a **too long msg** or for a broken HTML msg or ...

![What we test vs. what we ignore](/assets/bias/email-edge-cases.svg)

A surprising number of papers are researching cognitive biases in software testing. And they are concluding that we like testing almost only the expected behavior. **We prefer writing tests that confirm the code works, not tests that disprove it. Even among professional QA engineers, this is a common bias.**

Is it time pressure that causes this? 

Surely, it is not that we don't know or don't care that unexpected input data must also be tested?

If I'm testing the **login**-method, surely, it is clear that **at the very, very least we need 2 tests: a positive and a negative test, a test for a successful login and a test for a failed login.** Surely, the correct behavior of this method is to let in only people with correct credentials and to let them in only as themselves, right? But this demands more than 1 test. Even more than just 2 tests.

![Testing login: The bare minimum](/assets/bias/login-tests-minimum.svg)

A paper called "A controlled experiment on time pressure and confirmation bias in functional software testing" researched this topic. Unfortunately, it found out that time pressure is NOT downgrading our testing skills. **We simply have very poor testing skills** to begin with. Here's their conclusion:

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

Half of the participants were given 30 minutes to write the tests, while the other half had 60 minutes. 

Before the experiment the researchers tested that 45 mins is about enough to finish the task, thus the 60mins limit seemed very adequate and 6 people from this group finished the task before the time was up. So, they definitely had enough time.

The 30-mins group also got 3 reminders about the time running out: at the 15th, 20th and 25th minute. This was done to build the pressure.

The results go like this: **both groups wrote almost the same number of negative tests**, 24 vs 26 tests. On average this amounts to a bit more than 1 per person.

![Confirmatory vs Disconfirmatory Tests](/assets/bias/testing-bias-chart.svg)

The minimum number of negative tests per person was 0 for **both** groups. Most people wrote zero or one disconfirmatory tests, regardless of time pressure. The median was 0 for the time-pressured group and just 1 for those with plenty of time.

![Disconfirmatory Tests Per Person](/assets/bias/testing-disconfirm-stats.svg)

When we test only what we expect to work, **we miss the opportunity to uncover corner cases** or conflicting behaviors that can cause failures. Breaking free from confirmation bias means **deliberately seeking out tests that challenge assumptions, which is the only way to build robust software.**

**The point of tests is to try to break the code! And failing at it.**


## It is in our nature to assume the best

I think this behavior of ours is really just our nature.

When we picture any solution, we always assume it's going to be a good solution.

When we first imagined democracy or the internet, we imagined they would encourage human cooperation. They would be superior to everything that came before, they would have no downsides, we would all be happier.

It seems to be that **it's hard for us to believe that something _can_ be built and also that we might build it poorly.** I mean, we plan to build it really well, why would it not work really well?

## The coffee machine conundrum

Here's an example: you want to buy your first coffee machine.

Obviously you are going to read some reviews. You do that and then buy a good coffee machine. Easy-peasy. You buy the one with great reviews.

But after using it a while, you find the machine is too loud. Originally, it didn't cross your mind to check the specs for decibels. So, you decide to give this one to your parents and buy a new one. This time a machine that makes good coffee and is quiet. You do that.

But after a while you decide that the containers are just too hard to clean. So, you're giving this machine to your poor, student cousin and get yourself a new coffee machine. You want it to make good coffee, you want it to be quiet and containers need to be easy to clean. You find one and buy it.

But after a while, you see that the new machine's coffee beans dispenser is simply too small, you need to refill this thing every day. Who has time for that?

And so on.

![The ever-growing list of requirements](/assets/bias/coffee-machine-requirements.svg)

**It is only with lots and lots of experience that we can finally stretch our imagination to think of all the things that can go wrong, even though we've never yet seen them go wrong.**


## Mathematics as a liability

People who are educated in something adjacent to mathematics often become very skilled at delivering proof. We get trained on how to turn a hypothetical idea into a law.

But this skill often becomes a liability. **The problem is that we trust ourselves too much.**

And so we believe that our decisions are data-driven, purely rational. And if they are data-driven, well then they must be the best decisions a human can possibly make.

But of course this isn't true. **We are not data-driven.** We are logical sometimes. But we want to believe we are logical all the time.

When we make ourselves the sole judge of how code is done "right," our code becomes limited by whatever we happen to believe right then — by our current set of biases. **The software ends up being exactly as small as our current best guess is.**


## How to counteract

All is not lost.

**The bad news is that nobody is immune to biases (not even your boss). The good news is that knowing about them takes half of their power away.** 

> To eliminate biases (i.e., debiasing), previous research has shown that **neither applying more effort nor being more
experienced in a field helps mitigate cognitive biases** [Fischhoff B, Debiasing, 1982]. However, **training on cognitive biases** and applying specific techniques **can make a substantial difference**. This has been proven not only for experts in a field but also to affect the judgment of non-experts [9].
<figcaption>
&mdash; Jetzen T., Devroey X., Matton N. and Vanderose B., Towards debiasing code review support
</figcaption>

**The trick is to be attentive to your motivations (and silently you can also speculate about other people's motivations).** What is behind your decisions (and theirs)?

Are you choosing the best solution or just the familiar/fancy one? Have you fallen into decision fatigue? Are you frustrated with a teammate? Are you just stressed out from the deadline?

**It helps to strategically pause projects.** I know they _said_ the project is super urgent, but what if _today_ you just **do some research and open up discussions** about possible solutions and their **repercussions**? 

I've learnt this helps the project a lot. **In my experience, giving a project time creates space for good decisions to be made. It's always great when good decisions are made _at the start of a project_, instead of after some code already needs to be reverted.** 

Generally, there is also other stuff to work on, so it's not like you are sitting, waiting and watching the paint dry during the pause.


