---
series: Cognitive Biases in Code
title: "Exhibit C: It'll Take Two Weeks, Tops"
tags: ["Cognitive Biases in Code", "Engineering Research"]
prev_post: 2025-07-23-blind-spots-in-code-part-II
biblio:
  - title: "R. Mohanani, I. Salman, B. Turhan P. Rodriguez & P. Ralph, Cognitive Biases in Software Engineering: A Systematic Mapping Study, 2020"
    link: https://www.researchgate.net/publication/328410759_Cognitive_Biases_in_Software_Engineering_A_Systematic_Mapping_Study
  - title: "D. Kahneman & A. Tversky, Intuitive Prediction: Biases and Corrective Procedures, 1977"
    link: https://apps.dtic.mil/sti/pdfs/ADA047747.pdf
  - title: "Kahneman and Lovallo, Timid Choices and Bold Forecasts: A Cognitive Perspective on Risk Taking, 1993"
    link: https://doi.org/10.1287/mnsc.39.1.17
  - title: "Wikipedia: Optimism bias"
    link: https://en.wikipedia.org/wiki/Optimism_bias
  - title: "Wikipedia: Status quo bias"
    link: https://en.wikipedia.org/wiki/Status_quo_bias
  - title: "Wikipedia: Confirmation bias"
    link: https://en.wikipedia.org/wiki/Confirmation_bias
  - title: "Wikipedia: Availability heuristic"
    link: https://en.wikipedia.org/wiki/Availability_heuristic
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
  - title: "Jihun Park, Miryung Kim, Baishakhi Ray, and Doo-Hwan Bae. An empirical study of supplementary bug fixes, 2012"
    link: https://www.researchgate.net/publication/254040777_An_empirical_study_of_supplementary_bug_fixes
---

The previous chapters covered anchoring bias and confirmation bias. This chapter is dedicated to **optimism bias**: **the tendency to overestimate the likelihood of positive events and underestimate that of negative events**.

In software, **we like to underestimate how long things will take, how many bugs we'll have to fix, how complex the project will be**. We downplay the risks and plan for a sure and swift victory.


{% include toc.html %}

## Optimism bias & estimations

Optimism bias is best seen when we estimate projects.

Weirdly enough, it seems that the more you know about how to build something, the worse you estimate how long it will take. 

The problem is, that if you ask me to build you a simple piece of software, I can immediately imagine the solution, the functions, the classes, the calls... I can see it all. But what I'm missing is all the things around the main logic that also need to be done for this piece of software to reach users. All the input validations, all the security features, all the meetings, product syncing, all the server infrastructure, the testing and deploying, ...

There's a big difference between "works on my machine" and "is running in production and being used by customers".

One study showed this neatly. The researchers went to a company and gathered **20 software professionals: 5 developers, 5 PMs, 5 designers, and 5 customer-success people**. 

Then they also found an old project of this company, a typical project that this company usually produces. 

This project had taken **2,400 hours**. None of the participants knew this or worked on this project.

Then, the participants were asked to estimate the project. Here are the average estimates for every group:

![estimation-exercise](/assets/estimation/estimation-exercise.svg)

**The most optimistic numbers (and the worst) come from developers.** The people with the **most technical knowledge** on how to do this project. And they were off by a lot!

Basically, the technical knowledge we have as devs compels us to underestimate the effort.

They tell us to multiply each estimate by 2 or 3. Yes, we should definitely do this. This seems to be the only reliable way for us to overcome our optimism bias.

It was the people who **talk to customers** who gave the higher numbers. Possibly because they need to go speak to the customer, face to face, when a project takes too long. They are the ones that have to say _"Soooo, it's going to be another month of waiting. Sorry."_


## How we estimate risk

This same pattern was observed in other studies as well, studies that don't focus on IT, but on the human ability to assess risk.

What researchers observed is that people can have an **inside view** or an **outside view** on risks and estimations.

> An **inside view** forecast is generated by focusing on the case at hand, by considering the plan and the obstacles to its completion, by constructing scenarios of future progress, and by extrapolating current trends.
>
> The **outside view** [...] essentially ignores the details of the case at hand, and involves no attempt at detailed forecasting of the future history of the project. Instead, it focuses on the statistics of a class of cases chosen to be similar in relevant respects to the present one.
<figcaption>
&mdash; Kahneman and Lovallo, Timid Choices and Bold Forecasts: A Cognitive Perspective on Risk Taking
</figcaption>

![Inside vs Outside view](/assets/bias/inside-outside-view-D.svg)

An inside view is when you concentrate on the details of the project, on the plan and the obstacles. You are creating steps to execute the project and are focused on the future.

An outside view turns out to be better. With the outside view you focus on statistics, on the past, on similar projects that have been completed and how risky those were.

**And it turns out that an outside view tends to produce more realistic estimates.**


## The paradox of listing risks

Let me mention one more risk-related research paper, this one is mind-boggling.

It was an experiment looking at how risk is assessed for software projects. The experiment was done 4 times and in 4 countries, all in all with 180 participants (mostly developers).

The participants were given the spec for a hypothetical project and were asked to identify risks on this project. Then, they were asked to estimate the project.

But there was a catch.

Half of the group was given substantially more time to think about the risks, to come up with a longer list of possible risks. This group was encouraged to identify **all the things that could possibly go wrong**.

Then the researchers compared the estimates of the 2 groups. It turns out, **the more time the participants thought about risks, the _lower_ their estimate for the project.**

Rather counterintuitive...  **The more risks the developers identified, the more optimistic they were about the project.**

Why might this be?

It could be the **illusion of control**: when we list the risks, we feel like we could handle them. A known problem is closer to a solution than an unknown problem.

Or it could be that **we judge problems by the last thing we listed**: we start with the worst risks and then add less bad risks, until at the end we list really very minor risks. Which might give us the feeling that: _"This whole project has mostly only minor risks."_

Or it could be that **when we struggle to add more problems to the list**, our brain interprets that as: _"Oh, there are no more risks! I've listed them all and there are none that I could have forgotten."_ Which then becomes evidence that risks are rare, since we can't even find them.

This really makes one think. **Listing risks _seems_ like such good practice, but what if it's actually harming us?**

There really seems to be no way to win over cognitive biases.

_As a side note: this hypothetical project was actually built by one company. And it took that company **700 hours** to do it. So, way more than even the group with higher estimates estimated._


## It is _done_.

**Optimism bias also affects our sense of "doneness".** We declare victory too early. The function works, but we forgot to handle the null case, update the test, rename the other two occurrences, fix the import, ...

In 2012, Park et al. published a study in which they showed that **22% to 33% of bugs require more than one fix attempt**.

They studied the version histories of Eclipse JDT core, Eclipse SWT, and Mozilla, spanning roughly 8-10 years of development each.

They identified all bugs that were fixed more than once: cases where a developer submitted a patch, the bug was marked resolved... and then the bug was re-opened and fixed again (22% in Eclipse JDT core, 24% in Eclipse SWT, and 33% in Mozilla).

To understand why, they manually inspected 100 of these incomplete fixes. The causes were varied: 
- missed porting to a different branch (28%), 
- incorrect handling of conditionals (23%), 
- forgetting to update code that references the changed code (15%), 
- incomplete refactorings (3%)
- ...

![incomplete-fixes-causes](/assets/bias/incomplete-fixes-causes.svg)

Interestingly, most fixes of resolved bugs came in less than 24h after the original "fix".   

> If there are multiple fix commits, we measure the time gap between the first fix revision and the last fix revision. More than **60% of supplementary fixes in JDT core appear within 24 hours**. The majority of supplementary fixes are resolved in a short amount of time. 
> However, some supplementary fixes take a very long time and take a large number of fix attempts. For example, in Mozilla, one bug was fixed **53 times**, and one bug report in Eclipse SWT took a total of **1113 days** to be resolved.
<figcaption>
&mdash; Park et al., An empirical study of supplementary bug fixes
</figcaption>


## Conclusion

We are optimistic about how long things will take. We are optimistic about how risky a project is. We are optimistic about whether our code is done.

And unfortunately, **knowing about optimism bias doesn't make it go away.** You can read this whole post, nod along, and still underestimate your next project by 70%. (Or you can become the pessimistic nay-sayer at your company whom nobody likes.)

But maybe the goal of eliminating bias was always silly.

What we can do is we can multiply our estimates, we can sleep on our "finished" code, and we can ask others to poke holes in our plan. But we aren't going to stop being optimistic. 

Optimism is surely at least 50% why we keep building software, instead of just giving up. 

But, what would help us is to take our outlook with a grain of salt, so as to not be *surprised* when reality looks less sensational than envisioned.

