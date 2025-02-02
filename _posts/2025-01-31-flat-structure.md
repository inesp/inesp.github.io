---
title: "Opinion: In Defence of Hierarchical Command Structures or Why Developers Argue all the Time"
excerpt_separator: <!--more-->
biblio:
---

Developers. Aren't we just a most ... argumentative bunch of ... people? We fight on pull requests, we fight on tech-specs, we fight in meetings. We just don't agree on anything. And we are very willing to die on many hills just to prove a point.

<!--more-->


### How it all started


I was looking at a thread of comments on a pull request the other day. 

We work in several time zones, so comments often follow each other overnight.    

I was wondering how the conversation got so over the top. It seemed to have started pretty innocently. Or that was at least my intention when _I_ started it.

I was looking at the new dataclass that was being proposed by the new developer. I liked all of it, especially the effortlessness of the code, except its name. We already had a different class, a pretty important class by this very same name. So now there were going to be 2 classes, both called ... let's say `Notification`, both dealing with notifications, but ever so slightly differently.

**I already saw the trap this code was setting up for some unsuspecting future dev. Maybe me.** 

Somebody will work on this code and think they are dealing with the other `Notification` class, the one that has been around for 5 years already. They will make a change, and it will break something. And they will be confused. And somebody will be angry.

And so I thought to myself: "Be a good person, point this out, and suggest a different name". And I did, I even took the time to come up with several different names, to offer a choice, and make the comment more friendly, more collaborative.

But, "collaborative" is not the word to use for what followed. ...


### How it breaks


We developers spend so much time in our heads. 

**Alone.** 

**Thinking.**

Reading.

Writing and thinking again.

By the time we open a PR, we often aren't interested in feedback anymore. We've already thought and read and wrote. 

We are done now. 

And that is when somebody comes along and demands we change the _name_ of some small data class. _I mean common! Talk about nitpicking!_

"_Any BY THE WAY ... I'm not since yesterday, I've been developing awe-inspiring systems for X years already. I'm quite brilliant if I dare say so myself. And what have they done?_

_Honestly, I have no clue..._

_They don't even have a title. I haven't seen anything from them yet. And they are telling me what to do?"_ 

So, what I got as a response was a message that was a bit more ... _forceful_ than I expected. A bit more _defensive_ than I expected. 

**And it ended with the beautiful words: "Something to think about."** Which I still don't know how to interpret. Do **I** have to think about this? Is it because I appear to be lacking basic Python knowledge in their opinion? Or is this Python knowledge not really basic, so they genuinely wanted to share it with me? I don't know.

I wanted to reply. I thought about not replying at all, but I wasn't prepared to accept defeat.

So, I wrote several, very different potential replies. 

But I never clicked "send" because I could not, for the life of me, figure out how my reply would help the situation, and how it would make anything better. 

And how would making it worse help me?


### How it gets worse


When little kids fight and a teacher gets involved, the kids start lying: one says "she hit me" and the other says "he talked smack about me". And you don't know which one lies. So, you can't solve the problem. (_Basically, children lie way better than adults._)

When 2 developers fight on a PR, all the communication is archived. It's all there. All the "smack" and all the "hits".

**And still, the end result is the same. Both get scolded. Both get a "talking to".**

_We are such a weird society: we really want things to be fair, but we are all shitty judges of fairness._

So I didn't send my reply. Not the first one, not the 10th one. 


### How the Gordian knot is cut


But I did do something. ... 🥁😏

I replied with just 1 single meme. 

A funny meme. In a language "my opponent" doesn't speak.

He isn't sure what it means. 

It's not an insulting meme, it's not offensive. It's just a funny meme that de-escalates the situation while also accidentally expressing my feelings about the whole thing.

> Let go of the things you can't control. 🤷‍♀️

Right?!


### How we prove a point


It took me a bit, but I genuinely saw "make it funny" as the only way out. And the reason is: there was nothing left to win in this argument.

An argument about the name of a class. ... 🤦 What are we doing with our time??

The energy we spent arguing about the name is way more than all the benefits a better name could have on the codebase.

I wish we were all striving to build a great tool, a great codebase and a great team together. **But every person is driven by different things and assigns different values to different things.**

You can't logically convince everybody every time to follow your lead. You just can't.

**You can't spend your life arguing with people.** (Imagine just the sheer amount of time this would take. Convincing every person you meet, every time you disagree.)

**Nobody cares if you are right.** At some point, you have to accept this human fallacy.

The whole idea of constantly relying on logic and arguments is naive and exhausting and also very disconnected from our biological reality.

Our brain loves shortcuts because it's smart. (Sometimes smarter than we are.) You interact with someone/something, you make up your mind of how it/they work, then you take it/them for granted and move on to other topics. This frees you up, so you can spend your limited brain power on new challenges. Moving on _is_ the smart thing to do.

But in this developer world of ours teams are constantly in flux. 

**We build teams where we are all equal to each other, but then keep on adding and removing members incessantly.** And so, we keep having to re-prove ourselves again and again. 

**The internal hierarchy of the team needs to re-establish itself again and again and again.** 

Why are we doing this to ourselves?! **Why is trust a bad word?**


### How _you_ can win


Just argue better!

The one who wins is the one who is seen standing last.

We like to tell ourselves that the last-one-standing is the one with the better arguments. 

But in my experience **the chances are 50-50** that the one "winning" will be the one with fewer scruples, the more stubborn one, the one willing to go further, exhaust more time.


### How it was always managed


We used to share impressions. 

"I met this person 10 years ago, she impressed me as I saw her solve problems X, Y and Z. I now trust her to solve such and such problems, thus I've given her the title of **Principal Investigator so others should trust her as well**."

Everything we ever created as humans did solve a problem at some point.

**We created hierarchies to solve the problem of trust.** We gave people titles and ranks as a shortcut, to save time and energy, to skip the step of everybody needing to prove themselves every time they meet someone new.

**Obviously, we overdid it eventually.** And now titles are worth nothing because we don't trust the people awarding titles.

So here we are: **quarrelling over everything all the time because we don't trust other people to make good decisions**. We don't know others well enough to be confident in their decisions and we don't want to rely on titles, because we don't trust them either. 

Is this it then? This is what we have to live with?


### How to build the future


I think a few steps back, into the world of hierarchies, would do us good.

Having a bit more trust that others are not complete idiots would do the developer community a world of good.

**Smart, until proven silly.** This should be a good rule of thumb. 😁

And following this mantra leaves you with just 2 options:
- **a)** test everybody yourself -> sacrifice your time and energy to test people and become a judgy person nobody wants to work with
- **b)** trust somebody else's judgement -> help build titles that actually mean something and then trust people with these titles

So, which do you want to be?

