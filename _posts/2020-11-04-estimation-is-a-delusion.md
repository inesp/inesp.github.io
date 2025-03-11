---
title: Software estimation is a delusion
excerpt_separator: <!--more-->
biblio:
  - title: "N. Fenton: Software measurement: a necessary scientific basis"
    link: "https://www.ipd.kit.edu/mitarbeiter/padberg/lehre/sqs07/FentonTSE1994.pdf"
  - title: "M. Jørgensen: Estimation of Software Development Work Effort:Evidence on Expert Judgment and Formal Models"
    link: "https://www.simula.no/publications/estimation-software-development-work-effortevidence-expert-judgment-and-formal-models"
  - title: "M. Jørgensen, S. Grimstad: The Impact of Irrelevant and Misleading Information on Software Development Effort Estimates: a Randomized Controlled Field Experiment"
    link: https://www.simula.no/publications/impact-irrelevant-and-misleading-information-software-development-effort-estimates
  - title: "COCOMO: Not worth serious attention"
    link: "http://shape-of-code.coding-guidelines.com/2016/05/19/cocomo-how-not-to-fit-a-model-to-data/"
  - title: "M. Jørgensen, M. Shepperd: Systematic Review of Software Development Cost Estimation Studies"
    link: "https://www.simula.no/publications/systematic-review-software-development-cost-estimation-studies"
  - title: "M. Jørgensen, K. Teigen, K. J. Moløkken-Østvold: Better Sure Than Safe? Overconfidence in Judgment Based Software Development Effort Prediction Intervals"
    link: "https://www.simula.no/publications/better-sure-safe-overconfidence-judgment-based-software-development-effort-prediction"
  - title: "S. Basha, P.Dhavachelvan: Analysis of Empirical Software Effort Estimation
Models"
    link: "https://www.researchgate.net/publication/43245283_Analysis_of_Empirical_Software_Effort_Estimation_Models"
  - title: "Estimation Techniques - Function Points"
    link: "https://www.tutorialspoint.com/estimation_techniques/estimation_techniques_function_points.htm"
  - title: "Timid Choices and Bold Forecasts: A Cognitive Perspective on Risk Taking"
    link: "https://www.researchgate.net/publication/330960812_Timid_Choices_and_Bold_Forecasts_A_Cognitive_Perspective_on_Risk_Taking"
  - title: "B.Boehm, C.Abts: Software Development Cost Estimation Approaches – A Survey"
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

As long as your projects don't resemble each other as your signatures do, you will not know how much effort it will take to finish a new project.

A lot has been said and written about software estimation, but one thing is clear: **predictions of future effort are always based on the amounts of past effort**.

<!--more-->

#### The human vs the mathematical model

2 distinct approaches exist for measuring the future time and effort of software development:
- asking a human expert for her opinion or
- building a mathematical model and condensing the requirements of the software project to only the relevant parameters

The approaches might seem radically different, **but the 2nd one is just trying to create a formal model of the 1st one**.

It is trying to cut out the human component of software estimation. It is trying to reduce an expert's decision process into a relatively simple and highly portable mathematical formula.

While it is doing this it is also often **pretending to be searching for a law of nature, for the natural relationship between software building and time, which is independent of the organization or the customer that the project is built for or by**.

However, the best mathematical models for software estimations are those that are **highly calibrated to the team they are measuring**.

By "calibrated" I mean that the function for calculating the required effort is fitted to data produced by this team in past projects. **And so we are back to experiences.** If you have done this project before, then you will be able to estimate accurately how much effort it will take to do it again.


#### Life is a moving target


But of course, life is a moving target. As you do the same thing again and again, you get better and faster at it. As the world around you changes: new versions of OSs, new browsers, new programming-language versions, ... you have to change too, which makes you slower again.

As you lose or gain members on your project, the effort and time needed are also changed. And I haven't even begun listing any big changes: like having a harassing customer, getting a disruptive team member, having to comply with a new law, ... .

It all boils down to whether or not you see the world as ever-unpredictable or ever-predictable.

If it is ever predictable, then software estimation is perfectly possible and also works perfectly brilliantly.

If, on the other hand, you see the world as ever-changing or you yourself are inclined to take on ever-changing projects, then any time or effort estimations are useless and deceiving.

**Nobody has yet come up with a prediction system that is not based on existing past data.**


## Is it even important?


Why are people even asking this question: "How long will it take to create this piece of software"? Because they don't have the resources to work on this forever. And this is understandable.

But there is a secret message in that question as well. It is something that we understand so very, very well that we don't even think about it.

The proposed piece of software doesn't need to be so complicated. It could be much simpler and still do its job.

Simpler software will take fewer resources to produce. **But people don't want the simple software, they want the most that they can get for their budget.**

The true question isn't: *How long will this take?*, but *What can you build for this much money?*.


#### What can you build for this much money?


2 types of people ask this question: **managers and customers**.

These 2 groups are pretty different, we communicate with them differently. **The core of answer for both of them is something along the lines of: *"Let's build it iteratively"*.**

Let's first organize the requirements by priority: what is core functionality and what is optional.

Let's then first build the foundations and the core functionality.

If we will then still have time and money left, let's continue.

**And if we will then still have time and money left, let's continue.** And if we will then still have time and money left, ...


#### Iterative solution

For instance, let's say I am a freelancer creating simple web pages. A customer asks me to create their first web page, a simple presentation of who they are and what they do.

They might come with a well-defined idea of what they like, with all kinds of details and requirements and a 100-page description document.

They want to know how much this will cost and how long it will take.

For me, this is nearly impossible to estimate. But let's say I still give them a number, which might be too big for them. So they might continue: "What about if we take these 20 pages out. How much does it cost then?".

This doesn't make the job of estimating any easier. Even if I know exactly how much time it saves me to ignore those 20 pages, my estimation of the full 100 pages was wonky. So.. `wonky - 20 = still wonky`.

It is much easier to start with a simpler page that can stand by itself, preferably one similar to something I've already built. After that, we can add more fancy functionalities if we will still want to.


#### In reality every project is still a gamble


And what if the task cannot be split up? Because such things exist too: we either switch to a new system or we don't.

The answer is simple but unpopular: We don't know how long something big that has not been done before will take.

We have no experience doing it.

**But here is a list of things we will gain and here is a list of risks we will take.**

One of the risks is also that all this time and effort will go to waste. If this project is important enough, let's allocate a few resources to it so that somebody can start working on it. **If their work goes well, then let's continue, if it will still go well, then let's continue,** if it will still go well, then let's continue gradually increasing that somebody's resources.

**But it could also not go well, in which case, we have to be prepared to stop work on this project and forget about it.**

**Just because we've already invested 20 person-months into this project, doesn't necessarily mean it makes sense to finish it.** Maybe it will be better to drop it. And maybe it will all go very well and we'll soon reap the rewards of starting this project.


#### What are you going to do with the answer?


The importance of this question is questionable. If you are asking your developers how long something will take because you will secretly send this number over to the customer as a binding offer, then stop doing it.

**Your developers are not freelancers,** they don't need to haggle with your customers over how much they pay you. That is your job.

If you are asking your developers for numbers to report to your superiors, then only ask for estimates of projects that are similar to existing projects they did.

If you ask for estimates for projects they have no experience with, you will get made-up numbers, that you will have trouble defending later on.

If you are asked this question by a customer and you are the one, who has to come up with answers to it, then try to split up the project into sub-projects that are similar to your experience.

**There is no point in giving estimations that you can't stick to with a reasonable error margin.**

But what if your projects are similar and you want to give estimation a go, what are your options?


## What are your options for estimation?

All estimates usually take 2 things into account:

- **the size and complexity of the project**
- **the resources provided to the project - the team**

Unfortunately, none of these attributes is easy to assess.

It would be great if I could say: "I have 4 developers and a project of size 75200. How long will it take to build the project?".

But, what is *4* and what is *75200*?

This leaves you with 2 choices: **either you spend a looong time putting the *4* and the *75200* into some kind of perspective,** some kind of mathematical function, a prediction machine **or you ask a human to feel it,** to look at it and then say a number, from the gut, "What is your gut telling you?".

Yes, these are your options. You can rely on a human or on a machine, each comes with a set of advantages and disadvantages.

There have been studies comparing which is better: human or machine. The results are ... depends on who you ask. Sometimes it is the models that are better other times it is the humans.


## Human Expert


An expert would be someone, who knows how to build your project and has done it before and also knows the team. It is the complexity of the project in relation to the capabilities of the team that define the effort needed to finish the project. **This is a difficult person to find.**

**It has been known since the 70s that developers tend to give very optimistic estimations. Nothing has changed since then.**

One of the reasons is that developers have to give lots of estimates, but then rarely track the actual effort that went into the tasks.

**If they don't track, then they can't review the initial estimate after the project is done**.

Another is, that developers often estimate by breaking up the task into smaller tasks, estimate the sub-tasks and then just sum up the numbers.

But this way inevitably misses some tasks, while giving the estimator a really good feeling of having thought of everything.

It is nearly impossible to come up with a complete list of every sub-task that will need to be done. We also tend to forget to include any unexpected problems. Problems we will only understand once we are staring them down.


#### Research proves that devs are really bad at estimating


The researchers M. Jørgensen, K. Teigen, K. J. Moløkken-Østvold did a marvelous study of how developers badly under-estimate the required effort titled ***Better Sure Than Safe? Overconfidence in Judgment Based Software Development Effort Prediction Intervals***.

They observed how estimates are asked for, but then rarely reviewed after the project:

> We investigated <u>more than 100 projects</u> from 6 development organizations and found that about <u>30% of the projects had applied effort prediction intervals</u> on the activity level. However, <u>only 3 of these projects had logged the actual effort</u> applying the same work break-down structure as used when estimating the effort. In fact, even these three projects had to split and combine some of the logged effort data to enable an analysis of the accuracy of the effort of PIs (tn: PI = prediction interval, a minimum - maximum effort).

They also created 5 teams of developers and asked them to estimate the effort needed for a project.

**The project was an actual past project of the company they worked for.**

The original estimation for the project was 1240 hours, but the project took 2400 hours to be finished.

The teams produced the following values as the Estimate of the most likely effort: 1100, 1500, 1550, 1339, 2251. **Just one of the teams came close to the actual number of hours spent, the other 4 had incredibly optimistic numbers.**

Another interesting part of the experiment was that **the worse estimations were done by developers and project managers**. (So, please, project managers, stop pressuring the developers with statements like: "How can this take more than 1 day to create?". Such statements are just pure ignorance 🙄 )

> The lowest effort estimates were provided by the developers and the project managers, whereas the user interaction designers and the engagement managers gave generally higher estimates.<br>
> ...<br>
> As a result, technical background did not lead to better effort PIs (tn: PI = prediction interval, a minimum - maximum effort), only to more confidence in the estimates. This is in line with the distinction between an "inside" versus an "outside" view in predictions (Kahneman and Lovallo 1993).

So.. what did Kahneman and Lovallo say about inside and outside predictions? Here is an excerpt of their paper *Timid Choices and Bold Forecasts: A Cognitive Perspective on Risk Taking*:

> An inside view forecast is generated by focusing on the case at hand, by considering the plan and the obstacles to its completion, by constructing scenarios of future progress, and by extrapolating current trends. The outside view is the one that the curriculum expert was encouraged to adopt. It essentially ignores the details of the case at hand, and involves no attempt at detailed forecasting of the future  history of the project. Instead, it focuses on the statistics of a class of cases chosen to be similar in relevant respects to the present one.


#### "Could we do it in 4 months?" <br> "If we skip a few things and smash up a few others, maybe..probably.." <br> "Ok, let's put 3 months then".


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


#### Better to be precise than accurate


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


All of them have been studied by researchers, but I could find no data about how often a mathematical approach is used in software companies.

Even worse, I did find this 2007 review of existing studies (A Systematic Review of Software Development Cost Estimation Studies by M.Jørgensen and M.J.Shepperd), which found **very few case studies of how estimation is actually performed in companies**:

> The proportion of estimation studies where estimation methods are studied or evaluated in real-life situations is low. We could not, for example, find a single study on how software companies actually use formal estimation models. Our knowledge of the performance of formal estimation models is, therefore, limited to laboratory settings

It has been shown that a model that is better fitted to the organization using it will produce better estimates. (By C.S.Murali and C.Sankar in "Issues in estimating real-time data communications software projects" in 1997 and R.Jeffery, M.Ruhe and I.Wieczorek in "Comparative study of two software development cost modeling techniques using multi-organizational and company-specific data" in 2000.)

**But this again means that your organization must be producing similar projects with similar people**, that you have to first meticulously track the requirements and the effort invested into several projects and that you must be careful to not create a model that is over-fitted to your data.


### Estimation variables


Producing a good model for your organization may legitimately be too complex or too time-consuming.

The biggest issue is how to get all the contextual information that is currently stored in the heads of your team  members into the model. Which information is even relative?

**Given that there is no one estimation method that had been proven best, it seems safe to say that it is not the method itself that produces accurate results, but what information you feed it with.**

Figuring out which information produces the most accurate result is a difficult job and it is made even worse by the fact that all your numbers are fabricated.

**You don't know how big a project will be once it is finished: how many lines of code you will create, how many tests, how many files.**

Even if you have finished a very similar project, you still don't know how much more time you will need to add that 1 "tiny" change that is in the requirements.


#### A metric must be defined together with the procedure to measure it


In 1994 N. Fenton published an elegant paper titled *"Software Measurement: A Necessary Scientific Basis"*, in which he emphasized that we have to define metrics in an empirical way.

A metric has to be defined together with the procedure for determining the value.** It is not enough to say that a project's size can be small, medium or big. We must also define how to measure the project's size.**

Do we look for the number of files, the number of lines, is 1000 lines a small project, is it medium?

This is especially important for predictions. Some mathematical models still exist that need the LOC (=lines of code) number to predict the time and effort for a software project. But it is impossible to know the LOC of a future project, **so we are replacing one guess with another**:

> ..  size is defined as the number of delivered source statements (tn: LOC), which is an attribute of the final implemented system. Since the prediction system is used at the specification phase, we have to predict the product attribute size in order to plug it into the model. This means that we are replacing one difficult prediction problem (effort prediction) with another prediction problem which may be no easier (size prediction).

A way to estimate the size and complexity of a project is **via function points (=FPs), which express the amount of functionality a program provides to its users**.

Once 1 FP is defined, it is theoretically easy to count all FPs a project will create by reading through the requirements.

The time it takes to deliver 1 FP is calculated from previous projects. The theory has been developed into a few ISO standards, but it has also seen a lot of criticism and quite a few improvement attempts. **Whether it will work for you or not is ... unknown.** 😛


## Conclusion


**It is easy to get pulled into the details of *how* these approaches work and completely forget that we haven't yet proven that they even *will* work**, that they will give you an accurate number. The research does not favor one approach over the others.

B.Boehm and C. Abts say in *Software Development Cost Estimation Approaches – A Survey*:

> The important lesson to take from this paper is that no one method or model should be preferred over all others. The key to arriving at sound estimates is to use a variety of methods and tools and then investigating the reasons why the estimates provided by one might differ significantly from those provided by another.

But as we've seen, **maybe it isn't really accuracy that businesses and people are looking for. Maybe estimates are needed for the sole purpose of risk aversion.** People want to know what the risks of starting this project are.

Risk can be measured in other ways.

At my current stage in life, I find that **everybody involved in a project is much happier if we go through the project in iterations**.

We don't have to decide everything at the beginning of a project. We should first concentrate on the essential bits. Things that can be done in a few days, a week at most and review the result.

It is much less risky to see somebody spend a few days on a project and then review the results than it is to wait for a few months.

An amusing consequence of this approach is that the developer will then also first concentrate on the essential bits. Maybe the first goal will be a proof of concept, something ugly and hacky, but something that works. Or maybe the first goal will be bits and pieces of code and in-depth research of the requirements and limitations and then comes the proof of concept. Either way, we will be kept in the loop on the progress. And being kept in the loop is what makes the risk lesser.

**Maybe it is time we stop estimating tasks left and right and instead start managing the project's risk and customer's expectations.**
