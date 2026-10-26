---
series: Cognitive Biases in Code
title: "Exhibit D: LGTM and pull requests"
tags: ["Cognitive Biases in Code", "Engineering Research", "Opinion"]
prev_post: 2026-03-23-blind-spots-in-code-part-III
biblio:
  - title: "Wikipedia: Confirmation bias"
    link: https://en.wikipedia.org/wiki/Confirmation_bias
  - title: "Wikipedia: Availability heuristic"
    link: https://en.wikipedia.org/wiki/Availability_heuristic
  - title: "E. Fregnan, L. Braz, M. D'Ambros, G. Çalikli and A. Bacchelli, First Come First Served: The Impact of File Position on Code Review, 2022"
    link: https://arxiv.org/abs/2208.04259
  - title: "APA Dictionary of Psychology: Attention decrement"
    link: https://dictionary.apa.org/attention-decrement
  - title: "O. Wilhelm, A. Hildebrandt and K. Oberauer, What is working memory capacity, and how can we measure it?, 2013"
    link: https://doi.org/10.3389/fpsyg.2013.00433
  - title: "T. Baum, K. Schneider and A. Bacchelli, On the optimal order of reading source code changes for review, 2017"
    link: https://doi.org/10.1109/ICSME.2017.28
  - title: "T. Baum, K. Schneider and A. Bacchelli, Associating working memory capacity and code change ordering with code review performance, 2019"
    link: https://doi.org/10.1007/s10664-018-9676-8
  - title: "A. Bacchelli and C. Bird, Expectations, Outcomes, and Challenges of Modern Code Review, 2013"
    link: https://www.microsoft.com/en-us/research/publication/expectations-outcomes-and-challenges-of-modern-code-review/
  - title: "C. Sadowski, E. Söderberg, L. Church, M. Sipko and A. Bacchelli, Modern Code Review: A Case Study at Google, 2018"
    link: https://research.google/pubs/modern-code-review-a-case-study-at-google/
  - title: "LinearB, Engineering Metrics Benchmarks"
    link: https://linearb.io/engineering-benchmarks/
  - title: "D. Spadini, G. Çalikli and A. Bacchelli, Primers or reminders? The Effects of Existing Review Comments on Code Review, 2020"
    link: https://sback.it/publications/icse2020.pdf
---

PR reviews are a spectacular breeding ground for biases.

The idea of PR reviewing is great, it's the same as peer-reviewing a scientific paper. **We need to double-check everybody's work, not because we don't trust people, but because we are wisely accepting our own imperfections.** Everybody can make mistakes, small typos or big, silly logic errors. If we work together, we can catch bugs in the making, before they reach our users.

This is all in theory, however.

In practice, PRs as well as scientific papers (and all other types of reviews) are often poorly peer-reviewed. The reason? **It is SOOOO MUCH WORK to review something.** And this is work that **isn't really appreciated or rewarded**.

We neither care if you did a good job reviewing _this_ nor are we going to reward you for it.

{% include toc.html %}

## The free labor of PR reviewers

People who review PRs are, in a way, providing free labor to the code owners. **They are supposed to check your work for mistakes, just like a teacher would.** 

**But the work itself is sooo hard to rank that we choose not to capture it in performance reviews or pay compensation.** There is simply no easy way to tell who is providing real value to the company with their reviewing, it's much easier to focus on the shipped projects. Those are clear-cut. Feature X shipped. Feature Y did too. On the other hand, we have: Incident A didn't happen, neither did incident B. Much harder to promote.

![What gets counted vs. the free labor of reviewers](/assets/bias/review-iceberg.svg)

Thus, it's hard to find reasons to do a good review, other than your own personal sense of duty.

**Spending a good amount of time and energy to deliver a thorough review can even hurt you.** 

**People dislike reviewing, even when it is about their own code. So if you are offering excellent reviews for free, then why should they be diligent when writing code? We have tests and great reviews, those will catch any bugs.** They can just write what looks like working code, and you will then review the code and find all the bugs. There really isn't any point in doing a thorough review.

## Simplifying the work

What do we do to reduce the load of reviewing? We apply shortcuts, the same ones that are classified as cognitive biases.

![PR review shortcuts](/assets/bias/pr-review-shortcuts.svg)

At the end of the day, we are told: _"Reviewing something is surely better than reviewing nothing."_ But is it?

Here are some example scenarios that can be seen in PR reviewing, in the same order as the boxes above:

### Author's past mistakes

_"What do I already believe about this author?"_

You already think this particular developer writes sloppy code, so you notice every minor issue. Things that would not bother you if this was somebody else's PR.

👉 This is **Confirmation bias**.

### Recent production bugs

_"What can I think of without thinking too much?"_

Last week production showed stale data, because somebody forgot to invalidate the cache. So now your first question in every PR is: _did you invalidate the cache?_ But the real problem in the PR slips right past you, because it isn't the problem that is on your mind this week.

👉 This is **Availability bias**.

### My own recent code changes

_"I'm still thinking of my code anyway."_

You just spent two days refactoring the auth module, so that is what you see in every PR. Does this change touch my code? Does it follow the pattern I just introduced? The parts of the PR that have nothing to do with your work get a quick glance, at best.

👉 This is **Availability bias**, again.

### Existing PR comments

_"Let's just follow the crowd."_

Two colleagues already left comments, so the PR feels reviewed. You read their comments, agree with them, and approve. Nobody checks if the three of you together actually read the whole diff.

👉 This is the **Bystander effect**.

### Author's seniority

_"Superheroes are always right."_

One thing we admire about a person (seniority, reputation) makes us assume everything else they do is just as good. The PR comes from the most senior dev on the team, so it must be fine. You skim it and approve it in 2 minutes. It works the other way around too: I once worked with a very senior person who was extremely respected in the company. He blocked our PRs with comments about insignificant implementation details, and because he was trusted, nobody questioned them.

👉 This is the **Halo effect**.

### PR's age

_"It's too late now, let's just merge it."_

The PR has been open for three weeks. It was rebased four times, it has 40 comments, everybody is tired of it. Now you notice the whole approach is wrong... but saying so means throwing away three weeks of work. So you merge it.

👉 This is the **Sunk cost fallacy**.


## How to get bugs through the PR reviews

In 2022, Fregnan et al. looked at **219,476 pull requests from 138 GitHub projects** and counted the review comments per file. They saw that the files shown first in the diff got more comments and the files further down got fewer. Their real objective, however, was to understand why this is.

> Could this choice or, more generally, the relative position in which a file is presented influence the outcome of code review?
<figcaption>
&mdash; E. Fregnan et al., First Come First Served: The Impact of File Position on Code Review
</figcaption>

The main question was: **do the files at the bottom matter less**, because they are tests or config files or boring helper files and such, **or were the developers influenced by cognitive factors** like maybe the so-called "attention decrement", a decrease in attention when exposed to a list of elements.

So the researchers ran an experiment:
- **106 developers** reviewed the same small Java change, 
- 5 files, with 2 bugs planted in it,
- an `if` that missed an edge case, 
- and a `switch` with a missing `break`. 

Most of the participants (72 of the 106) were professional software developers, from juniors to people with 11+ years of experience, so this isn't a study on students. 

**Half of the developers got the edge-case file first and the `switch` file last, the other half got it the other way around.**

When the edge-case bug was in the first file, it was found by 61% of developers. When it was in the last file, only 36% found it.
When the break-bug was in the first file, 52% of devs found it. When it was in the last file, only 43% did.

|                                          | Edge-case bug found | Edge-case bug missed | Missing `break` found | Missing `break` missed |
|------------------------------------------|---------------------|----------------------|-----------------------|------------------------|
| Edge-case file first, `switch` file last | **34 (61%)**        | 22                   | **24 (43%)**          | 32                     |
| `switch` file first, edge-case file last | **18 (36%)**        | 32                   | **26 (52%)**          | 24                     |
{:.first-column}

![Who found the bug? File shown first vs. last](/assets/bias/file-position-bug-found.svg)

This tells us 2 things: 
- **Yes, the file position does matter.** Apparently bugs in later files have a higher chance of staying undetected.
- **No, not all bugs are the same.** The edge-case bug was much harder to find in later files than the break-bug.

At the end of the experiment, the researchers showed both bugs to the participants and asked whether they felt the position of the bugs had any impact. About 3 out of 4 developers said that the file's position didn't affect them at all. Classic. 

> A total of 77 (72.6%) participants **rejected the idea that files’ position influenced their ability** to find for the Corner Case defect. However, the results of our experiment found evidence of the contrary.
<figcaption>
&mdash; E. Fregnan et al., First Come First Served: The Impact of File Position on Code Review
</figcaption>

**I've read soo many studies about developers by now and this is a red thread to a lot of this research: developers being completely oblivious of the cognitive biases they have.**

## Attention and the working memory

Humans are not robots, we give different levels of attention to different things, our brains are plastic, they adapt.

A relevant term for us is **attention decrement**:

> the tendency for people to pay less attention to stimuli coming later in a sequential occurrence.
<figcaption>
&mdash; APA Dictionary of Psychology: attention decrement
</figcaption>

The first item in a list gets our full attention, and every next item gets a little bit less. We start the review fresh and careful, and by the last file we are mostly scrolling. This is also why it's always smart to submit a conference talk proposal soon after the CFP opens, not just before it closes.

The second interesting idea is **working memory**, _"the memory for short-term storage during ongoing tasks"_ (Wilhelm et al., 2013). It's the part of our brain that holds everything we are juggling right now: what the model looks like, what the view expects, which variable came from where... Unfortunately, it is relatively small. 

**It's impossible for us to keep a full model of the codebase and all of its bugs and users in mind at the same time.** We have to choose what to remember, which inevitably means we let some things go. Lots of them usually.

## Bigger working memory

In 2019, Baum, Schneider and Bacchelli wanted to know if people with a bigger working memory are better reviewers.

They ran an online experiment with **50 developers**. Most of them were professionals: 42 called themselves software developers, and 40 had at least 3 years of professional experience. Each of them reviewed 3 real code changes from an open-source Java project (jEdit, a text editor):

- a small warm-up change: 2 files, 31 lines, **3 bugs**,
- and 2 larger changes: 7 files each, 490 and 233 lines, **with 9 and 10 bugs**.

![The experiment: 3 code changes, 22 bugs](/assets/bias/baum-experiment-setup.svg)

The researchers planted some bugs into the code. Some bugs were simple, like a misspelled message or a missing boundary check, others were hard, like a variable that wasn't adjusted somewhere in a complex algorithm.

6 of the bugs were **delocalized**: you can only find them by combining knowledge from several places in the code. For example, a method call with 2 parameters swapped.

At the end, the developers could (optionally) take a working memory test. 45 of them did. 

**The test of their working memory went like this:** you see a letter for a moment, then you solve a simple math problem, then you see the next letter, then another math problem... and after 3 to 7 letters, you have to recall all the letters in the right order. Every correct letter is 1 point, 50 points max. **So the test measures how much you can keep in your head while your brain is busy with something else.**

The scores went from 17 to 50, the median was 45.

The result: **reviewers with a bigger working memory found more of the delocalized bugs.** For all the other bugs, working memory made almost no difference.

> We find that there is a moderate association between working memory capacity and the effectiveness of finding delocalized defects, influenced by other factors, whereas the association with other defect types is almost non-existing.
<figcaption>
&mdash; T. Baum, K. Schneider and A. Bacchelli, Associating working memory capacity and code change ordering with code review performance
</figcaption>

![Working memory vs. delocalized bugs found](/assets/bias/working-memory-delocalized.svg)

**However, a big working memory doesn't guarantee anything.** Plenty of people with high scores found only 0 or 1 of the delocalized bugs. 

**A high working memory is _necessary, but not sufficient_** for bug finding. 

The strongest factor overall wasn't memory at all, it was time: **the longer people reviewed, the more bugs they found**.

![More time reviewing, more bugs found](/assets/bias/review-time-bugs-found.svg)

> Even for delocalized defects, working memory capacity is only one of several factors, of which the strongest is review time.
<figcaption>
&mdash; T. Baum, K. Schneider and A. Bacchelli, Associating working memory capacity and code change ordering with code review performance
</figcaption>

## GitHub sorts PR files in alphabetical order

Does it matter?

In 2017, Baum et al. interviewed and surveyed developers about how they review, and found that most reviewers simply start with the first file the tool shows them.

> most developers tend to start their reviews in the order presented by the review tool (Baum et al., 2017b)
<figcaption>
&mdash; E. Fregnan et al., First Come First Served: The Impact of File Position on Code Review
</figcaption>

I sometimes leave a comment or two on my PRs, when the PR is a bit more complex, and mark the line(s) where I'd like a second pair of eyes: _"start here"_, or _"this is the main change"_.

I thought I was just being nice to the reviewers, but it turns out I was also counteracting their bias.


## Why do we review?

I was always told we review to find bugs. That is the main reason. Then there is also the maintainability of the code, sharing knowledge... but bug-finding is first and foremost.

In 2013, Bacchelli and Bird asked devs at Microsoft this question, and _then_ also read hundreds of real review comments and compared.

Because, as we all know: you can't ask people why they do what they do. They have no clue why they do what they do. :-P 

> Our study reveals that while **finding defects remains the main motivation** for review, reviews are less about defects than expected and **instead provide additional benefits such as knowledge transfer, increased team awareness, and creation of alternative solutions to problems**. Moreover, we find that code and change understanding is the key aspect of code reviewing and that developers employ a wide range of mechanisms to meet their understanding needs, most of which are not met by current tools. 
<figcaption>
&mdash; A. Bacchelli and C. Bird, Expectations, Outcomes, and Challenges of Modern Code Review
</figcaption>

**Most comments were about making the code better in general, not about bugs.** 

![How well do you need to understand the change](/assets/bias/review-understanding-needed.svg)

They also asked developers how well they need to understand a change to reach each of these goals. **Finding bugs needs the deepest understanding of all**: about 8 in 10 said they need a high or complete understanding of the change for it. 

Sharing knowledge or keeping the team aware of what's going on works fine with a quick skim. 

**And maybe this is why so few PR comments are about finding bugs.** Finding a bug needs the highest level of understanding of the PR, so the biggest amount of time and effort, thus it is cut first.


## Leading by example

I always wanted my own PRs to be reviewed quickly, because **I find it incredibly frustrating to finish a task to 80%, then wait and wait and wait** and then do a few fixes and wait again and then maybe deploy. 

**Context switching is hard on everybody, but it's even harder on some of us.**

To encourage my co-team-members to be fast reviewers I decided to be a fast reviewer myself.

I hate spending time reviewing open PRs, but if I can overcome this annoyance and still review in a timely manner, then surely this can be done by other people too.

**So, for 4 years (from 2021 till 2024) I made sure to review PRs swiftly!** 

Over all 4 years, I reviewed 42.4% of all PRs that were opened on our 2 main repositories. (They opened 8,346 PRs, I reviewed 3,523 of them.)

![my-reviews-per-year](/assets/bias/my-reviews-per-year.svg)

**On a hypothetical average day in 2022, I would thus review 4.7 PRs and open 2.3 PRs.** Looking back now, I must have been quite bussy... but I promise I've double-tripple-quadruple checked all numbers!

| Year | PRs I reviewed | Share of colleagues' PRs I reviewed | PRs I opened |
|------|----------------|-------------------------------------|--------------|
| 2021 | 798            | 44% (of 1,802)                      | 482          |
| 2022 | 1,036          | 52% (of 1,980)                      | 511          |
| 2023 | 905            | 38% (of 2,393)                      | 512          |
| 2024 | 784            | 36% (of 2,171)                      | 511          |
{:.table-center}

## But was I fast?

Yes, I was also fast:

|                             | With me  | Without me      |
|-----------------------------|----------|-----------------|
| Median time to first review | 25 min   | **50 min**      |
| Within 1 hour               | 65%      | 52%             |
| Within 24 hours             | 94%      | 82%             |
| Reviewed only by me         | -        | **14%**         |

**My median time to first review for _the whole of 4 years_ was just 25 mins.** And 65% of PRs I've looked at within the 1st hour.

I also came back for **2.0 review rounds per PR**. My colleagues: 1.1 to 1.3.

So, when I say that reviewing other's PRs doesn't pay... I speak out of personal experience. This was a long-running experiments, years of experimenting, and these years conclusively show that this is un-rewarded-hard-labor.


## Do we have any data on how fast PR reviews are in general?

Google is known for its quick reviews, and this is what they measured:

> In terms of speed, we find that developers have to wait for initial feedback on their change a median time of under an hour for small changes and about 5 hours for very large changes. The overall (all code sizes) median latency for the entire review process is under 4 hours.
<figcaption>
&mdash; C. Sadowski et al., Modern Code Review: A Case Study at Google
</figcaption>

LinearB, a company that sells engineering metrics, publishes yearly benchmarks, "created from a study of 8.1+ M PRs from 4,800 engineering teams across 42 countries". They rate the **pickup time**, the time until a reviewer first picks up a PR, like this:

| Pickup time | Rating      |
|-------------|-------------|
| under 1h    | Elite       |
| 1 to 4h     | Good        |
| 5 to 16h    | Fair        |
| over 16h    | Needs focus |
{:.table-center}

This means m 25mins till first comment truly **is** fast.


## Is there a solution for PRs?

I think we need to have an honest conversation about how pull request reviews don't really work.

PRs are a **group effort**, it's not something you can solve by yourself. 

Yes, you can use the same tactic as for every other bias: question your motivations, question your emotional responses. Are you really being methodical? Are you sure you aren't just trying to get it over with? Are you just stuck in your own code style?

And you can try these things. But it will take years to overcome your reflexes, to silence your opinionated ego. It will take you a lot of energy to remain calm and collaborative. But if you devote yourself to it, you can make it.

How many people are going to devote themselves to overcoming their reviewing biases? Very few, I'd say. 

Think about the junior on your team, who just doesn't yet have meaningful insights to contribute. And of your boss, who still sometimes meddles in PRs, although he shouldn't. Or the new hire, who says they did it differently at their previous company, and low-key suggests it was better there. 

Reading about biases once won't make a difference. It takes continuous effort, constant self-reflection, and a genuine desire to improve. It is hard work to silence your opinionated ego. **Good reviewing is practically non-existent.** So maybe we shouldn't expect it from people.

PRs might work for open source, where they solve an actual problem: who decides what gets included into a library?

In companies, however, each team generally owns one part of any repo. Gatekeeping with PRs is very much too late. The gatekeeping should have happened in meetings and instructions and planning stages. 

So maybe it doesn't matter how biased your PR reviewing is, because its effect on the overall product is just too small.

**PRs just seem like a lost cause to me.**

Maybe we should focus our energy elsewhere: on better testing, on pair programming, on automated checks... Because relying on humans to overcome their cognitive shortcuts in every single review is wishful thinking.

