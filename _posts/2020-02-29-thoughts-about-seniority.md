---
title: "Take control of you environment: Write a script"
biblio: 
  - title: "Stack Overflow: Developer Survey Results 2019"
    link: "https://insights.stackoverflow.com/survey/2019#experience"
---

Not very long ago I joined the development team at a new company, let's call the company Company X. Company X was rather big, it certainly had by far the biggest development department I have ever worked in, and it had a distinct Corpo flavor to it. When I joined I had been a professional software developer for almost a decade. This was the first time I got hired directly into the Senior Developer title (whatever that may mean) and coincidentally this was not long after I first started seeing myself as a somewhat senior developer. 

So, having my fair share of employments and projects behind me meant that I finally gained some retrospective abilities. My pool of experience and knwledge was finally diverse enough to have some statistical merit. And I finnaly had a decent grasp of the big-picture of life, work and politics, of action and all the possible reactions that can follow. 

Changing teams and companies is like traveling to another, sometimes distant, culture. People there also eat food everyday, but they do it using forks instead of chopsticks. It takes some time to absorb their customs. However, with my new found "versed developer"-abilities, meeting new colegues was a completely different experience than ever before. Instead of just learning the new practices and assimilating them as the absolutely correct approach, I was able to spot the ineffective parts quickly and push towards precise changes. 

It is much more straigntforward to identify sketchy practices, once you have hands-on experience with alternatives that have worked better. It is easy to suggest new methods of development, when these are not just theoretically interesting concepts, but something your previous team has tested out and liked.

My experience is that our development teams are lacking seasoned developers. This condition might be a consequence of my geographical location or it might not be. Stackoverflow's developer surveys show every year that about half of developers have less than 5 years of experience. Here are the results of the 2019 survey:

![Stack Overflow: Years Coding Professionally](/assets/scripts-yeasr-prof-coding.png)

In a perfectly selected group of 10 developers, there would thus be only 1 person with more than 20 years of experience and only 2 more with more than 10 years. 

![Where are all the senior developers?](/assets/scripts-senior-developers.png)

Once you reach your 10 year milestone, you have to start looking thoroughly to find knowledgeable mentors, to find wordly people whom you need to further cultivate your skill.


## What have I seen in that distant country?


Every company has its own work flow, its own set of processes and un-written laws. A surprisengly huge amount of small things felt very unfamiliar to me. It is usually the small things, that trip us up. The big things were all recognizable, they were assigning Jira tickets to each other just like (almost) all software companies. But the things they had to do with these Jira tickets, to mark them as *Done*, were perplexing in my eyes. There was so much manual labor involved. I had to personally remember the different flows that a ticket can take and then apply them by hand. This was new to me. I wasn't used to having to reserve a chunk of my daily mental capacity to thinkng about tickets. 

I felt like being asked to participate in the Japanese tea ceremony after hving only read a pamflet about what the different steps are.

This feeling that I barely have time to solve any business problems, because I'm spending my day doing prep-work, kept screeming at me again and again. To me our development environment felt very messy. I saw so much that needed to be automated. Surely I wasn't the first person to be asking: Why are we doing these things manually? But if there was somebody before me, if there were other developers, who also found it tedious to manually repeat the same jobs, why have they not left more automation scripts?

As I was discussing the need for automation with other developers and debating about the pros and cons and particularly about *who* should be responsible for developing these scripts, I came to a realization. All the great developers, I ever got to know, write stupid little scripts to make their lives easier, to automate repetetive tasks, to test out things, to free up their memory, to take control of their work enironment. It turns out writing scripts is a sign of seniority. Writing scripts means leveraging a computer's power for your own advantage.

If you are already sitting behind a computer and solving business problems, why not use this same computer and also make yuor own life easier? 


## The calculation in favor of automatization


Let's say that there is this Task X, that 20 developers in your company have to do regularly and let's say it takes each of them $$ 1h $$ a week to do it.

An average month has $$ 21 $$ working days, each developer works a bit more than 4h per month on Task X:

$$ \frac{1h}{week} * 21 \frac{days}{month} = \frac{0.2h}{day} * 21 \frac{days}{month} = 4.2 \frac{h}{month} 
$$

Let's say that a developer works about $$ 7.5h $$ per day (-lunch). In a month the 4.2h amount to less than 3% of their working hours. 

$$
\frac{4.2h}{21 * 7.5h} = 2.7\ \%
$$

Does it make sense to automate this task? Yes, because it costs the company half of 1 developer each month (a month has 157.5h, the task takes 84h).

$$
20\ developers * 4.2 \frac{h}{month\ *\ developer} = 84 \frac{h}{month}
$$

$$
\frac{84h}{month} / \frac{21 * 7.5 h}{month} = 53\ \%
$$

Ok, we've decided to automate. Let's say it will take 1 developer $$ 8h $$ to write the script and teach all developers to use it. And let's say the script now runs in $$ 1 min $$ per week (ie. 6 times 10s). In the first 4 weeks we thus save the developers $$ 51h $$ of work. 

| time    | status quo | with automation script | result |
|---------|------------|------------------------|-------:|
| 0.week  | 20h        | 28h                    |    +8h |
| 1.week  | 40h        | 28h + 20min = 28.3h    | -11.6h |
| 2. week | 60h        | 28.6h                  | -31.3h |
| 3. week | 80h        | 29h                    |   -51h |
{:.table}



-------------------



Their work env was like a wilnerness. There were all these developers around me, but the strip of software land they live on is still a wild forest. 

----------------

Company X had the biggest development department I have ever worked with. For some reason I have always avoided working in big corporations. I never liked the atmosphere they created. Once, at the early stages of my career, I went on an interview to a company, which was renting out a huge space in the industrial zone


They tell you: you have to know yourself, you have to know what you want? I'm sorry, but how I am supposed to know which icecream flavor I like most if I only ever tasted strawbery and chocolate? I will know exactly which type of job I like most on my dead bed. Once I go through all the permutations, I will finaly know what suits me best. But even then, I might join a company too early in their yourney or too late in mine. 



It amazed me how few tools they had, how much stuff they decided to do manually.

You have a wilderness. Taim it! It will be more pleasant to live in a hut and sleap in a bed that to live under the treas and sleep on the rocks.
