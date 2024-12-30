---
title: Why is sooooo.. much documentation a pain to read?
biblio:
  - title: "5 Whys"
    link: "https://en.wikipedia.org/wiki/5_Whys"
  - title: "Webpack from Nothing"
    link: "https://what-problem-does-it-solve.com/webpack/index.html"
---

Because it is written in a boring, counterproductive style. But why is that? Because it copied the style of academic papers. But why are academic papers dry and boring? Because most schools have since forever talked to their pupils in a dry and boring manner. But why is that? Because until recently human society has been managed in an authoritarian manner. Everybody knew exactly who was above them and who was below them, who they have to obey and who they can give orders to. For the most part, *fun* was reserved for the afterlife and the rich. But come-on! we can do better, here are a few pointers.

*(I utterly love this 5-whys interrogation technique! I recommend trying it out.)*
{:.small}

Learning is easiest through experience, thus let's start with a practical exercise. We will write an email.

## Imagine the following scenario. 

It is Thursday, the 4th day of your 1-week sprint. You have just finished a ticket and have opened up a pull request. The ticket was about developing a new way to create CLI commands. The existing commands were all built on a now-defunct library.

You are happy with your work, it took a lot of coordination between departments. You've talked to DevOps, you've talked to Product, you've talked to senior engineers, you've taken care of all concerns. Your PR will no doubt be approved quickly. However, one thing is still left to do: you have to tell everybody about this new way of writing commands. How do you do it?

Let's say you decide to write an email. How better to make everybody understand this new approach, then to tell them everything, the whole story, from start to finish

<div class="box">
Everybody,

I’ve been consulting with DevOps a lot lately because I was writing a new command. And it turns out DevOps has a lot of problems running our existing commands, they can’t do … and … and they are frustrated with … . Another problem is the fact that our library …. is not maintained anymore, so we shouldn’t use it anymore. It is not super dangerous to use it, but we should switch to something more stable soon. Together we’ve come to the conclusion that the best way forward is to use approach …. . I've written documentation about how to use the new system for CLI commands. So the old way is now deprecated, please do not use the old way anymore. If you need any help with the new way, you can ping me. 

Thank you,

Me
</div>

Great, done! Let's send it out. You have done everything and more. You've finished the ticket, you've communicated with everybody, you've even written docs and an email and everything. You are one great developer :relaxed: !

But, are you really done? 

The crucial part of email sending comes after the email has been sent. Will anybody read it? And will the recipient act on it?

## Why no one is reading your emails

Let's switch perspectives.

You are a different developer now. It is still Thursday, the 4th day of your 1-week sprint. You are down to 1 un-finished ticket. Truth be told, you have solved this last ticket as well, but the pesky end-to-end tests are failing. You've been staring at the failing tests for 1 hour now, trying to figure out how could your change have caused this, maybe the tests are just flaky. Should you take some time and make them stable? Do you even have the time? There is this important meeting tomorrow, you should start preparing for. Hm... oh, look an email has arrived.

What will happen now? Will this second developer read our email? Will she read it thoroughly? 

Of course not. 

The second developer has her own stuff to worry about. Maybe she has been with this team for a year and never had to write a command and so ... this email consists of nothing tangible for her. She'll skip over the text and forget it.

What did we expect to happen? People are not machines, we cannot insert a new if-statement into their decision mechanisms via one email. People remember through repetition, not by reading emails. So... what exactly was our goal with the email? We never specified it. 

## A better email message

We should have started with instructions. First the TL;DR, then the explanation:

<div class="box">
Everybody,

Please, read the following docs: http://....

We have defined a new procedure for creating CLI commands. We must all adhere to it.

Thank you,

Me
</div>

This way of writing feels unnatural at the beginning. Intuitively, we would first explain the situation and then ask people to act. But we are all flooded with messages daily. I have recently realized, that I am being paid to read. I read emails, blogs, docs, specs, Slack, Confluence, JIRA, 15five, ... There is always more to read. The logical consequence is skimming all text. We no longer read, we skim, searching for a glimpse of relevance. 

Know your audience. Because they will only skim, be relevant and concise. 

What would have been the reaction to the above, shortened email? I guess that 70% of its recipients would skim it and 20% would read the docs.

Is this it? Have we given it our best? Is this the best possible outcome?

Of course not. We went at this from the wrong angle. Sending out an email would always have been futile. 

Email has its limitations, but this does not mean we cannot still achieve our goal.

## Secret-agent messages

First, we need to be clear about what we really want to achieve. What do we really want? We want that all future commands are written in the new way.

We must switch perspectives. We must think like "the other". A little marketing comes into play now. How do I make everybody buy my product? How do I make everybody follow my way?

We must imagine the scenarios, in which somebody will need our information and optimize for them.

Who will need to know about the new way of writing commands?

Definitely a developer. She might be a senior developer, who has been at the company for 10 years, or she might be a junior developer in her 2nd week. It might be somebody from another team or another department, it could be a DevOps or it could be a QA person.

OK, so it will be somebody, who has written at least a few lines of code in her life. They might be part of your team or your paths might never cross, a pull request might be opened, reviewed and merged without you noticing. This means all hints and instructions need to be written down and they must be very visible.

What will this developer want? They will want to quickly and efficiently write a command. They will absolutely NOT want to know the history of your meetings, what who said, what who thought, what day of the week it was, what anybody had for breakfast, none of these things. They will want to quickly and efficiently write a command. Their first question might be: are there any existing commands, how are they run and can I just do the same. The will either search the docs or the source. So... you need to fix both paths. 

If you search for "command" in docs, do you find docs about the old approach? Change this. The docs need to reference the new approach, delete old docs, if possible, or add big bold "Deprecated" signs.

If you search for "command" in source, what do you find? Is there a folder called `commands` in your app, but all the commands inside are done in the deprecated way? Rename the folder. Add "Deprecation" notices to all the old commands' classes. There are tools in many languages, with which you mark deprecated-code. 

Leave breadcrumbs everywhere!

## Archetype

What does all of this have to do with documentation? The best documentation follows the same principle. Think about your audience and state the things that will be important to them. Everything else comes later.

A while ago I was searching for a Git-history drawing tool. I stumbled upon GitGraphJS and its utterly awesome docs:

[![Git Graph's amazing docs](/assets/docs-git-graph.png)](https://gitgraphjs.com/#0){:target="_blank"}

The docs are concise, short and cover all the important first questions I had. Once I had set up the library with a simple example, I could look into any details.

## Infamous Webpack

Webpack is infamously difficult to set up and infamously difficult to understand. What problem is it even solving? 

Here is the top of their current home page. After reading this, I still don't know what Webpack even is, I don't know why I should use it, how it will help me and, honestly, I had to stare at those 4 file examples for a very long time before I understood what they are trying to tell me. 

![Webpack Home Page](/assets/docs-webpack-homepage.png)

Lots of start-up products lack a clear description of what they do. Their pages talk about improving performance, collaboration, bundling or some other aloft subject. But read as I may, I still can't find a clear answer to: "What does this product actually do?".

But maybe, I am unfair towards Webpack, maybe Webpack is accomplishing such complicated things, that it is impossible to explain these things simply. Who-ever uses Webpack must simply invest that 1-6 months of study, before they can continue working on their own project. But then again, who are these people, who will need to invest a sizable amount of their time into Webpack? 

Webpack is being used in web development, which is a notoriously fast pacing environment. I'm not sure if there are project managers out there, who would casually approve that 1 of their few developers studies Webpack for a month or two. There are releases to catch, features to finish, promises to keep. And what is the average developer turnover again?

Several wrapper-libraries have been created around Webpack. Libraries, which provide a few simple and easy commands and translate them into this big bad wolf of a Webpack settings file. And if these libraries have found a way to make Webpack easy to set up, why wasn't Webpack able to do the same?

[![Laravel Mix](/assets/docs-laravel-mix.png)](https://laravel-mix.com/){:target="_blank"}

One of these wrapper libraries is Laravel Mix. To set up and use Laravel Mix, it can be enough to read its 350 words long quick guide. I've tried it, it works! There is more documentation than this, you can go into depth on many topics, but you do not need to and that is the point. 

If Webpack were meant for CS researchers to study it, then its documentation would be just perfect. If it was meant for us, however, then it missed the target. But it did provoke a bunch of memes.

![Webpack meme](/assets/docs-webpack-meme.png)

## FAQ, the underdog

Why is Stack Overflow so immensely popular? Because most documentation is just not good at answering questions.

When you have a problem, how often do you go check the official documentation and how often do you check random blogs or Stack Overflow? I should trust the official docs of any product more than a random blog post from a random person/bot(?) on the internet. But I can't, because docs so rarely explain the most common use cases. 

![Stack Overflow, FAQ](/assets/docs-FAQ.png)

I would love it if most docs would include a FAQ section. If you are writing some docs right now, please, add a FAQ section. This will be a chance for you to see us: what will we do with your library, how will we use your code, what will be most confusing about your approach, ... .

## An Appeal to all Writers

To all you, future authors of documentations. Please, 
- write a short and a long version of your docs (a tl;dr section is greatly appreciated)
- consider the user experience of your readers
- include a FAQ section and expand it with time.

Thank you! We will repay you with likes and shares and subscribes and also by cloning your approach. 
