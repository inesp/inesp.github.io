---
title: Software estimation is a delusion
excerpt_separator: <!--more-->
biblio:
  - title: "N. Fenton: Software measurement: a necessary scientific basis, 1994"
    link: "https://www.ipd.kit.edu/mitarbeiter/padberg/lehre/sqs07/FentonTSE1994.pdf"
  - title: "M. Jørgensen: Estimation of Software Development Work Effort:Evidence on Expert Judgment and Formal Models, 2007"
    link: "https://www.simula.no/publications/estimation-software-development-work-effortevidence-expert-judgment-and-formal-models"
  - title: "M. Jørgensen, S. Grimstad: The Impact of Irrelevant and Misleading Information on Software Development Effort Estimates: a Randomized Controlled Field Experiment, 2011"
    link: https://www.simula.no/publications/impact-irrelevant-and-misleading-information-software-development-effort-estimates
  - title: "M. Jørgensen and M. Shepperd: A Systematic Review of Software Development Cost Estimation Studies, 2007"
    link: https://web-backend.simula.no/sites/default/files/publications/Jorgensen.2007.1.pdf
  - title: "COCOMO: Not worth serious attention, 2016"
    link: "http://shape-of-code.coding-guidelines.com/2016/05/19/cocomo-how-not-to-fit-a-model-to-data/"
  - title: "M. Jørgensen, M. Shepperd: Systematic Review of Software Development Cost Estimation Studies, 2007"
    link: "https://www.simula.no/publications/systematic-review-software-development-cost-estimation-studies"
  - title: "M. Jørgensen, K. Teigen, K. J. Moløkken-Østvold: Better Sure Than Safe? Overconfidence in Judgment Based Software Development Effort Prediction Intervals, 2004"
    link: "https://www.simula.no/publications/better-sure-safe-overconfidence-judgment-based-software-development-effort-prediction"
  - title: "S. Basha, P.Dhavachelvan: Analysis of Empirical Software Effort Estimation Models, 2010"
    link: "https://www.researchgate.net/publication/43245283_Analysis_of_Empirical_Software_Effort_Estimation_Models"
  - title: "Estimation Techniques - Function Points"
    link: "https://www.tutorialspoint.com/estimation_techniques/estimation_techniques_function_points.htm"
  - title: "D. Kahneman and Dan Lovallo: Timid Choices and Bold Forecasts: A Cognitive Perspective on Risk Taking, 2000"
    link: "https://www.researchgate.net/publication/330960812_Timid_Choices_and_Bold_Forecasts_A_Cognitive_Perspective_on_Risk_Taking"
  - title: "Hareton Leung: Software Cost Estimation, 2001"
    link: https://www.researchgate.net/publication/2406503_Software_Cost_Estimation
  - title: "B.Boehm, C.Abts: Software Development Cost Estimation Approaches – A Survey, 2000"
    link: "https://www2.seas.gwu.edu/~mlancast/cs254/usccse2000-505.pdf"
  - title: "Wikipedia: Regression analysis"
    link: "https://en.wikipedia.org/wiki/Regression_analysis"
  - title: "Wikipedia: Decision tree learning"
    link: "https://en.wikipedia.org/wiki/Decision_tree_learning"
  - title: "Wikipedia: Artificial neural network"
    link: "https://en.wikipedia.org/wiki/Artificial_neural_network"
  - title: "Wikipedia: Bayes' theorem"
    link: "https://en.wikipedia.org/wiki/Bayes%27_theorem"
short: It has been known since the 70s that developers tend to give very optimistic estimations. We prefer to have exact numbers, even if that means they are wrong most of the time. But maybe it isn’t really accuracy people are looking for. Maybe it is all about risk aversion.
long: “It doesn’t have to be correct”, I was told, but I do have to give a number. You will never be able to accurately estimate the time and effort it will take you to build a piece of software .. for as long as you keep doing *new* things. Searching for a good effort estimation method is too often compared to searching for a law of nature, for the natural relationship between software building and time, which is independent of the organization or the customer that the project is built for or by. However, the best mathematical models for software estimations are those that are highly calibrated to the team they are measuring. In research, developers admitted that they believe their managers will see them as less competent if they provide estimates with huge margins. But mathematically speaking providing a wider min-max interval means you will be right more often. But maybe it isn’t really accuracy that businesses and people are looking for. Maybe estimates are needed for the sole purpose of risk aversion. People want to know what the risks of starting this project are. Risk can be measured in other ways. Maybe it is time we stop estimating tasks left and right and instead start managing the project’s risk and customer’s expectations.
---

**You will never be able to accurately estimate the time and effort it will take you to build a piece of software .. for as long as you keep doing new things.**

It is impossible to estimate the time needed to do something you aren't familiar with it. If you haven't done a thing before and you don't have good statistics on how long these things usually take, what can you possibly base your estimate on?

I know this is not the consensus among developers. Estimation is generally thought to be annoying, but doable. I've even met such devs that are very proud that _they_ can estimate projects pretty accurately. But then you look at research and research paints a different picture. 

Research corroborates my personal experience, namely that developers are horrendous at estimating the required effort for software changed.

<!--more-->

The unfortunate truth is that **predictions of future effort are always based on the amounts of past effort**.

You can only estimate projects that you are very familiar with. And only when they are executed by a team you are very familiar with. And also only if the circumstances are such that you are also very familiar with them.


## The mathematical model that shall conquer the human model

2 distinct approaches exist for measuring the future time and effort of software development:
- asking a human expert for her opinion or
- building a mathematical model and condensing the requirements of the software project to only the relevant parameters

The approaches might seem rather different, **but the 2nd one is just trying to create a formal model of the 1st one**.

It is trying to cut out the human component of software estimation. It is trying to reduce an expert's decision process into a relatively **simple** and highly **portable** mathematical formula.

We want estimation to be as simple as putting in 5, 10, maybe 15 parameters and the robot must spits out the exact date that the code will be done. And we want the robot to be able to handle all projects, from building a web page to knitting a sweater to creating a new OS. And it shall work from now and till forever.

We have this notion that whatever is human is **flawed** and **biased**. And everything that is from-a-computer is not flawed and not biased. Which is of course utter nonsense. **Many studies have shown that we have absolutely no problem building our human flaws and biases directly into computer code.** 

But still, we gravitate towards something that would transcend our mere humanity.


## And the mathematical model that just copies humans


The math model is trying to beat the human by **pretending to be searching for a law of nature, for the natural relationship between software building and time, which is independent of the organization or the customer that the project is built for or by**.

But then research shatters our idea of a superior robot, by proving that the best mathematical models for software estimations are those that are **highly calibrated to the team they are measuring**.

By "calibrated" I mean that the function for calculating the required effort is fitted to data produced by this team in past projects. Or simpler: you need a team's statistics to be able to predict the team's future work.

1. So, first you have to have a stable team. No team changes every year, no hiring no firing. 
2. And then you need to measure the team's work, categorize every task and measure the time. 

That is how you build yourself some good statistics, which you need to train your model.

**And so we are back to experiences.** If you have done this project before AND have measured it before, then you will be able to estimate accurately how much effort it will take to do it again.


## Life is a moving target


But of course, life is a moving target. As you do the same thing again and again, you get better and faster at it. 

As the world around you changes: new programming-language versions, new dev tool that everybody is talking about and you to apparently will have to try out, new testing requirements,  ... you have to change too, which makes you slower again.

You can't stay static, you have to change too, but that makes you slower again.

And I haven't even begun listing any big changes: 
- getting new team members, who have to be trained,
- losing team members, who were important for certain tasks,
- having a harassing customer, who makes you re-do your work again and again until you become passive-agressive and start spending more and more of your time thinking of clever email answers to annoying comments,
- getting a disruptive team member, who pissed of everybody on you team, who was so very productive up until just now,
- having to comply with a new law, 
- ... .

It's a never ending tug of war. 

**We are trying to stabilize the world, but the world is changing under our feet.** 

**If you are a creative person, then it is even worse for your.**

Creative people are inclined to take on ever-changing projects or to solve the same projects in ever new ways. Thereby never standardizing their work and thus sabotaging themselves at estimating the required effort majorly. 

So, what can we do?! 


## Why do you keep asking me for estimations?!

Is it even important? Won't a task just take however long it takes?

What happened last time our project took 2x as long as estimated? **Nothing.** And the time before that? Nothing either. 

So, why are you even asking me: "How long will it take to create this piece of software"? 

...

**Because people don't have the resources to work on _this_ forever.** And this is understandable.

But if the goal is to minimize resources, then let's just make the project simpler. 

Whatever it is we are building, it could be built faster if we cut corners. Let's make it less pretty, less user-friendly, less error-safe. 

**If we boil the project down to its minimum, then it will be done faster, thus cheaper.**

But here is the catch: **people don’t want the simple software, they want the most that they can get for their budget.**

The true question isn't: *How long will this take?*, but ***What can you build for this much money?*.**


## Iteration to the rescue


2 types of people ask this question: **managers and customers**.

These 2 groups aren't the same. We communicate differently with them. Even though a certain air of professionalism is expected, we are still rather more honest with our managers than with our customers.

But no matter how you will say it, the core of the answer to both of them is something along the lines of: **"Let's build it iteratively"**.

Let's first organize the requirements by priority: **what is core functionality and what is optional.** And I know everything seems "core" at the beginning, but usually lots of things are more "nice to have" and less "must have".

Let's then first build the foundations and the core functionality.

If we will then still have time and money left, let's continue.

**And if we will then still have time and money left, let's continue.** And if we will then still have time and money left, ...


## Wonky - 20 = still wonky

For instance, let's say I am a freelancer creating simple web pages. A customer comes to me with a 100-pages spec of what exactly they want. They have all the details of what they like and what they don't. 

They feel they've done all the work, all they want now is to find a person who can build it for them for the right price.

For me, this is nearly impossible to estimate. I didn't write the spec, it's hard for me to discern if the details are detailed enough, if all the weird cases are covered, if all functionalities are even possible.

But let's say I do some work, I crunch the numbers, I do some push ups, I drink some coffee and I come up with a number.

And then they respond with: "What's too much for us, what if we take these 20 pages out. How much does it cost then?".

I don't know. I have to figure out again, how much effort those 20 pages alone are. Yes, sure, estimating 20 pages will probably produce a more accurate number than estimating 100 pages, but it is still a guess.

Even if I know exactly how much time it saves me to ignore those 20 pages, my estimation of the full 100 pages was wonky. So.. `wonky - 20 = still wonky`.

It is much easier to start with a simpler page that can stand by itself, preferably one similar to something I've already built. After that, we can add more fancy functionalities if we still want to.


## An electron cannot be split


And what if the task cannot be split up? Because such things exist too: we either switch to a new system or we don't.

The answer is simple but unpopular: We don't know how long something big that has not been done before will take.

We have no experience doing it.

**But here is a list of things we will gain and here is a list of risks we will take.**

It is kinda funny how the tasks that are unsplitable also tend to be such that nobody has any experience with them.
You would only ever upgrade a specific system from Python 2 to Python 3 once. So, before it is done, you haven't done it before and after it is done, it doesn't have to be done again. The only way to re-do this task is to find a similar system that is still on Python 2 and offer to upgrade it to Python 3.

One of the risks of an un-splittable project is also that the project fails. With it all the time and effort wil go to waste. This is something that needs to be discussed before the project is started.

**Just because we've already invested 20 person-months into project X, doesn't necessarily mean it makes sense to finish it.** If we know project X is doomed, then let's stop wasting resources on it immediatelly. The fact that we've already lost 20 months doesn't mean wasting 21 months is the way to go.

But maybe the project will all go very well and we'll soon reap the rewards of starting it.

The way to split up an un-splittable project is to start slowly. Let's allocate only a few resources to it so that somebody can start working on it. **If their work goes well, then let's continue, if it will still go well, then let's continue,** if it will still go well, then let's continue gradually increasing that somebody's resources.

In reality every project is still a gamble


## What are you going to do with the answer?


And then there is the question: **What are you going to do with my answer?** What do you plan to do with "52 hours"?

If you are asking your developers how long something will take because you will secretly send this number over to the customer as a binding offer, then stop doing it.

**Your developers are not freelancers,** they don't need to haggle with your customers over how much the customer pays you. That is your job.

If you are asking your developers for numbers to report to your superiors, then only ask for estimates of projects that are similar to existing projects they did.

If you ask for estimates for projects the devs have no experience with, you will get made-up numbers, that you will have trouble defending later on.

If you are asked this question by a customer and you are the one, who has to come up with answers to it, then try to split up the project into sub-projects that are similar to your experience.

**There is no point in giving estimations that you can't stick to with a reasonable error margin.**

Estimations are tricky, don't use them just because. Use them when you can actually mitigate the risks.


## What are your options for estimation?

Ok, so now we are finally at projects that we actually _can_ estimate.

So, how does one go about doing this?

All estimates usually take 2 things into account:

- **the size and complexity of the project**
- **the resources provided to the project - the team**

Unfortunately, none of these attributes is easy to assess.

It would be great if I could say: "I have 4 developers and a project of size 75200. How long will it take to build the project?".

But what is 4 developers? Is every dev interchangeable? What is the avg dev's skill and motivation? Are we talking about junior/mid/senior, a new hire, a 1-year-old hire? How much is 1 dev? And am I 1 dev, 0.5 dev or 2 devs?

And how does one measure the size and complexity? What is 75200? Lines of code? Number of files? Number of PRs? Number of tickets? Is 1 HTML form with 3 simple text input fields the same as 1 HTML form with 1 select field? Or is 1 select only worth 2 input fields? How does 1 GQL field compare? Is it the same as 1 HTML text input or the same as 3 or 5?

But, even if we do say 1 form is 5 somethings and 1 GQL field is 10 of those somethings. This is still not in days. 

How many days is project of this size 725200 when divided by 4 developers?

Somebody or something needs to specify what the relationship is between number of people and project size.

And then also between people and time. How many hours does 1 average developer work? Officially 8, but practically she needs to go to meetings and needs to review other people's code and needs to answer questions and ...

This leaves you with 2 choices: 
- **either you spend a looong time putting the *4* and the *75200* into some kind of perspective,** some kind of mathematical function, a prediction machine 
- **or you ask a human to feel it,** to look at it and then say a number, from the gut, "What is your gut telling you?".

You can rely on a human or on a machine, each comes with a set of advantages and disadvantages.

There have been studies comparing which is better: human or machine. The results are ... depends on who you ask. Sometimes it is the models that are better other times it is the humans.


## Human Expert - is there such a person?

Let's look at the Human Expert first.

An expert would be someone, who knows how to build your project and has done it before and also knows the team. It is the complexity of the project in relation to the capabilities of the team that define the effort needed to finish the project. 

**This is a difficult person to find.**

**It has been known since the 70s that developers tend to give very optimistic estimations.**

**And unfortunately, nothing has changed since then.**

One of the reasons that nothing change is that developers **rarely track the actual effort that went into the tasks**. They estimate, but then the estimate kinda disappears into the void. The actual effort is rarely logged, so it can't truly be compared to the estimate. 

**If you don't track, then you can't review the initial estimate after the project is done**. And cannot get better at estimating.

Another reason for optimistic estimations is that developers often estimate by breaking up the task into smaller tasks and then they estimate the sub-tasks and then just sum up the numbers.

But this way inevitably misses some tasks, while giving the estimator a really good feeling of having thought of everything.

It is nearly impossible to come up with a complete list of every sub-task that will need to be done. 

We especially tend to forget to include any unexpected problems. Problems we will only understand once we are staring them down. These are often called the unknown-unknowns. They are things we don't know will come up.


## Research shows that devs are horrendous at estimating


The researchers M. Jørgensen, K. Teigen, K. J. Moløkken-Østvold did a marvelous study of how developers badly under-estimate the required effort titled ***Better Sure Than Safe? Overconfidence in Judgment Based Software Development Effort Prediction Intervals***.

They observed how estimates are asked for, but then rarely reviewed after the project:

> We investigated <u>more than 100 projects</u> from 6 development organizations and found that about <u>30% of the projects had applied effort prediction intervals</u> on the activity level. However, <u>only 3 of these projects had logged the actual effort</u> applying the same work break-down structure as used when estimating the effort. In fact, even these three projects had to split and combine some of the logged effort data to enable an analysis of the accuracy of the effort of PIs (tn: PI = prediction interval, a minimum - maximum effort).
<figcaption>
&mdash; M. Jørgensen, K. Teigen, K. J. Moløkken-Østvold, Better Sure Than Safe? Overconfidence in Judgment Based Software Development Effort Prediction Intervals
</figcaption>

There is 1 specific excercise they did in this study that I particularly like.

The researches went to one company and chose 20 participants and put them into 5 teams. Each team got 4 members: 
- one developer
- one project manager
- one designer
- and one "Engagement manager", a person who is responsible for the customer relationship.

So, only 2 people with a more technical know-how of creating software.

Then the researches choose an old project that the company did in the past and none of the participants worked on. This past project had an original effort estimation of 1240 hours, but it took the team 2400 hours to finish. **The project was chosen because it was very typical for the company and because it didn't encounter any weird problems, which would explain why it took 100% more time than estimated.**

Then they asked the participants of the exercise to estimate the effort needed to complete the project, first by themselves and in teams.

The teams produced the following values as the Estimate of the most likely effort: 
- 1100h 
- 1500h 
- 1550h 
- 1339h 
- 2251h

**Just one of the teams came close to the actual number of hours spent, the other 4 had incredibly optimistic numbers.**

So, again, this was a typical project for this organization, nothing extraordinary has happened. The estimates are just too optimistic.

The best part, however, come to light when you look at the individual estimations. It turns out that **the worse estimations were done by developers and project managers**.

| Team                | Median estimate |
|:--------------------|-----------------|
| Developers          | 660h            |
| Project Managers    | 960h            |
| Designers           | 1260h           |
| Engagement Managers | 1550h           |
{:.table}

> The lowest effort estimates were provided by the developers and the project managers, whereas the user interaction designers and the engagement managers gave generally higher estimates.<br>
> ...<br>
> As a result, technical background did not lead to better effort PIs (tn: PI = prediction interval, a minimum - maximum effort), only to more confidence in the estimates. This is in line with the distinction between an "inside" versus an "outside" view in predictions (Kahneman and Lovallo 1993).
<figcaption>
&mdash; M. Jørgensen, K. Teigen, K. J. Moløkken-Østvold, Better Sure Than Safe? Overconfidence in Judgment Based Software Development Effort Prediction Intervals
</figcaption>

Thus, maybe you can take this as a friendly remider to stop saying (even to yourself) "How can this take more than X?". It can, because it does. We are just too optimistic about our abilities.

But let's look at the "Kahneman and Lovallo" who are mentioned aboe. What do they say about inside and outside predictions?

> An inside view forecast is generated by focusing on the case at hand, by considering the plan and the obstacles to its completion, by constructing scenarios of future progress, and by extrapolating current trends. The outside view is the one that the curriculum expert was encouraged to adopt. It essentially ignores the details of the case at hand, and involves no attempt at detailed forecasting of the future  history of the project. Instead, it focuses on the statistics of a class of cases chosen to be similar in relevant respects to the present one.
<figcaption>
&mdash; Kahneman and Lovallo, Timid Choices and Bold Forecasts: A Cognitive Perspective on Risk Taking
</figcaption>

## "Could we do it in 4 months?" <br> "If we skip a few things and smash up a few others, maybe..probably.." <br> "Ok, let's put 3 months then".


Another powerful reason for over-optimistic developer-estimates I would like to emphasize is the social component of estimation.

When a developer is asked to give an estimate, 2 social constraints guide her estimate.

Firstly, the estimate cannot be huge, because that effectively stops the project immediately.

Secondly, she cannot come up with a very wide estimate. An estimate is wide when the expected min and max values are far apart.

**Providing a wide estimate or an unexpectedly big one is considered the same as providing a useless estimate.**

I still very vividly remember an event in my past.

I was the head of a delicate effort to replace a patched-up version of something that was at the core of our app with a new, cleaner and more complete implementation.

It was a tricky job, we didn't know what we were getting into simply because this project wasn't similar to any other project we did. But it was important.

We couldn't live with the old implementation anymore and we had finally convinced the management to give us resources to replace it. I didn't give any estimate of the project at the beginning, but at some point during the project, I was convinced that I do have to provide some estimate.

**"It doesn't have to be correct", I was told,** but I do have to give a number.

And so I sat down, opened the form and picked a date 6 months into the future.

**My manager was sitting next to me and said something like: "What?! No, we can't put that in.".**

But I knew that 6 months was a perfectly optimistic number. Our app was huge and a lot of work will need to be done. And so, I and my manager looked at each other. We knew that this project needs to be done, the engineering department is convinced of it, but the management is difficult to persuade. We've already come very far, the finish line is very close.

The +6-months number will stir up a lot of anxiety, but the project still needs to be done, it will be great, once it is done and anxiety is not helping anyone. And so we said: **"Could we do it in 4 months?", "If we skip a few things and smash up a few others, maybe..probably..", "Ok, let's put +3 months then".**


## Better to be precise than accurate


M. Jørgensen, K. Teigen and K. J. Moløkken-Østvold saw something similar in their research.

**Developers admitted that they believe their managers will see them as less competent if they provide estimates with huge margins.**

To test this thinking they created an experiment in which they asked 37 software professionals to evaluate some hypothetical project estimations. All 37 participants had some experience with project management.

They were presented with estimates for 5 hypothetical tasks given by 2 hypothetical developers: D1 and D2.

Both developers gave the same "Most likely effort", but different "Estimated min" and "Estimated max". D1 would give a narrow min-max interval, while D2 would give a much wider min-max interval. The participants were also provided the actual effort needed for each task.

**Mathematically speaking providing a wider min-max interval means you will be right more often.** D2's estimates were correct for 4 tasks out of 5, whereas D1 was right only 3 times.

The participants were then asked 3 questions. Here is how they answered the first 2:

- **"As a project manager, would you prefer the estimates of D1 or D2?"**

  35 out of 37 participants prefer D1, even though D1's estimates are objectively less accurate than D2's. The other 2 choose D2.

- **"Do you believe D1 or D2 knew more about how to solve the development tasks?"**

  29 participants choose D1, 1 participant choose D2.

> The preference for D1 in the (a)-question means that nearly all the software professionals preferred the much too narrow intervals of D1 to the statistically more appropriate intervals of D2!<br>
> ...<br>
> Answers to question (b) revealed that wider intervals were believed to indicate less task knowledge.
<figcaption>
&mdash; M. Jørgensen, K. Teigen and K. J. Moløkken-Østvold, Better sure than safe? Overconfidence in judgment based software development effort prediction intervals, 2004
</figcaption>

From all this, we can say that a lot goes into producing an estimate. It is not just the number of resources that need to be reserved.

**We prefer to have exact numbers, even if that means they are wrong most of the time.** We want to have certainty, the feeling that somebody knows, what is going on, somebody else has things under control. Or at least somebody should pretend to have things under control.

We are definitely not rational beings, but emotional ones :)


## Mathematical models


There is an incredible variety of mathematical models available:

- **regression-based approaches**

  That is when you want to create a formula (ie. $ Y = ? * X ^ ? + ? $) that expresses the relationship between a dependent variable ($Y$), also called the "outcome variable" and one or more independent variables ($X$).

- **classification and regression trees**

  That is when you want to create a decision tree where each node represents a question and the node's branches represent possible answers to the question. Traversing through the tree eventually leads us to a leaf, which represents the outcome, our prediction. If the leaves represent a class (a discreet value), then the tree is called a classification tree. If the leaves can take any number in a continuum, then the tree is called a regression tree.

- **neural networks**

  That is when you create a huge, directed and weighted graph, and teach it to return a specific output given a specific input. And then feed it new input data and use its output as predictions of the future. The internal workings of this system become completely unknown to you, they become a black box of decision making.

- **Bayesian statistics**

  That is when you calculate the probability of an event happening given some prior knowledge of other conditions that might be relevant. $ P(A\|B) = \frac{P(B\|A) P(A)}{P(B)} $

- **lexical analyses of requirement specifications**

  That is when you analyze the words used in the documents describing the new software.

- **case-based reasoning**
- **fuzzy logic modeling**
- **simulation based probability**
- ...


All of them have been studied by researchers. It was studied how accurate these methods are and how they compare to each other.

But then I came across this 1 paper that did a review of existing studies and found that **very few case studies exist on how estimation is actually performed in companies**:

> The proportion of estimation studies where estimation methods are studied or evaluated in real-life situations is low. We could not, for example, find a single study on how software companies actually use formal estimation models. Our knowledge of the performance of formal estimation models is, therefore, limited to laboratory settings
<figcaption>
&mdash; M.Jørgensen and M.J.Shepperd, A Systematic Review of Software Development Cost Estimation Studies, 2007
</figcaption>

It is true that 2007 is quite some years ago, but still. 

So, all these formal modals are created and tested and researched and compared, but nobody is actually using them? 

We, devs, in our daily work, still prefer to estimate by gut feeling, by experience? 

At least most, if not all, companies use the "Human expert"-approach and not the mathematical model approach.

This means I could go on and on about how great neural networks are or how great Bayesian statistics are, but we, devs, don't seem to be truly interested in this. 

What makes matters for these formal models even worse is that for each one you can for sure find studies praising it, but you can also find other studies pointing out their weaknesses and failures. 

The more I read about these, the more I felt I was reading about nutrition. Which food is health for us? What can/should I eat? Research doesn't seem to agree. Fish is really healthy, except for the mercury. Vegetables are really healthy, except for the pesticides. Estimation algorithms seem to follow the same pattern.

> Today, almost no model can estimate the cost of software with a high degree of accuracy. This state of the practice is created because
> - (1) there are a large number of interrelated factors that influence the software development \[...\]
> - (2) the development environment is evolving continuously
> - (3) the lack of measurement that truly reflects the complexity of a software system
> 
> \[...\]
> 
> To improve the algorithmic models, there is a great need for the industry to collect projectdata on a wider scale.
<figcaption>
&mdash; Hareton Leung, "Software Cost Estimation", 2001
</figcaption>


## Estimation variables - which information is even relative?


Producing a good model for your organization may legitimately be too complex or too time-consuming.

The biggest issue is how to get all the contextual information that is currently stored in the heads of your teams into the model. Which information is even relative?

**Given that there is no one estimation method that had been proven best, it seems safe to say that it is not the method itself that produces accurate results, but what information you feed it with.** This "information" is called "estimation variables".

Estimation variables are the main parameters that define your project's required time and effort. It is things like: 
- the LOC (lines of code) that will be produced for this project
- the complexity of the product, which is usually just assessed as T-shirt sizes
- the size of the database needed
- how many "function points" is the project going to produce
- ...


## A metric must be defined together with the procedure to measure it


In 1994 N. Fenton published an elegant paper titled *"Software Measurement: A Necessary Scientific Basis"*, in which he emphasized that we have to define metrics in an empirical way.

A metric has to be defined together with the procedure for determining the value. **It is not enough to say that a project's size can be small, medium or big. We must also define how to measure the project's size.**

> For  predictive  measurement  the  model (tn: =metric)  alone  is  not  sufficient.  Additionally,  we  need  to  define  the  procedures  for 
> - a) determining model parameters and 
> - b) interpreting  the results.
> \[...\]
>
> The model, together with procedures (a) and (b), is called a prediction system. Using  the same model  will generally yield  different results if  we  use different prediction procedures.

If the model/metric is LOC(=lines of code), then we also need to define how to **unambiguously count** the lines of code and **unambiguously interpret** the result of. For LOC this means that formatting must be perfectly clear, so that the same project always produces the same number and that this number is always interpreted as the same project size.


## The problem with estimation variables


But the problem with **lots of these estimation variables is that you can only know these after the project is done**. How many lines of code will this project produce? Nobody knows.

It is impossible to know the LOC of a future project, **so we are replacing one guess with another**:

> ..  size is defined as the number of delivered source statements (tn: LOC), which is an attribute of the final implemented system. Since the prediction system is used at the specification phase, we have to predict the product attribute size in order to plug it into the model. This means that we are replacing one difficult prediction problem (effort prediction) with another prediction problem which may be no easier (size prediction).
<figcaption>
&mdash; N. Fenton, Software Measurement: A Necessary Scientific Basis, 1994
</figcaption>

Of course, not everything is based on LOC. Some estimations are based on **function points (=FPs), which express the amount of functionality a program provides to its users**.

Once 1 FP is defined, it is theoretically easy to count all FPs a project will create by reading through the requirements.

The time it takes to deliver 1 FP is calculated from previous projects. The theory has been developed into a few ISO standards, but it has also seen a lot of criticism and quite a few improvement attempts. **Whether it will work for you or not is ... unknown.** 😛

Now, to be fair, behind every estimation variable is a whole spec for how to estimate it accurately, how to make it work for any project. And I don't want to go into those details.

But this all feels to me like kicking the can down the road. We don't know how to estimate the project's deadline, so we try to estimate the projects's lines-of-code, but we don't know how to get that number, so we say, we can get this out of "function points" of the project, but we don't know how to get that number, so we'll count certain words in the technical specification for ht project, but we can't really take that for granted, so we'll try to compile a list of synonyms that should also be included, but we can't...


## Conclusion


**It is easy to get pulled into the details of *how* these approaches work and completely forget that we haven't yet proven that they even *will* work**, that they will give you an accurate number. The research does not favor one approach over the others.

> The important lesson to take from this paper is that no one method or model should be preferred over all others. The key to arriving at sound estimates is to use a variety of methods and tools and then investigating the reasons why the estimates provided by one might differ significantly from those provided by another.
<figcaption>
&mdash; B.Boehm and C. Abts, Software Development Cost Estimation Approaches – A Survey, 2000
</figcaption>

But as we've seen, **maybe it isn't really accuracy that businesses and people are looking for. Maybe estimates are needed for the sole purpose of risk aversion.** People want to know what the risks of starting this project are.

Risk can be measured in other ways.

At my current stage in life, I find that **everybody involved in a project is much happier if we go through the project in iterations**.

We don't have to decide everything at the beginning of a project. We should first concentrate on the essential bits. Things that can be done in a few days, a week at most and review the result.

It is much less risky to see somebody spend a few days on a project and then review the results than it is to wait for a few months.

An amusing consequence of this approach is that the developer will then also first concentrate on the essential bits. Maybe the first goal will be a proof of concept, something ugly and hacky, but something that works. Or maybe the first goal will be bits and pieces of code and in-depth research of the requirements and limitations and then comes the proof of concept. Either way, we will be kept in the loop on the progress. And being kept in the loop is what makes the risk lesser.

**Maybe it is time we stop estimating tasks left and right and instead start managing the project's risk and customer's expectations.**
