---
title: Why is sooooo..o much documentation a pain to read?
biblio:
  - title: "5 Whys"
    link: "https://en.wikipedia.org/wiki/5_Whys" 
---

Because it is written in a boring, counterproductive style. But why is that? Because it copied the style of academic papers. But why are academic papers dry and boring? Because most schools have since forever talked to their pupils in a dry and boring manner. But why is that? Because until recently human society has been managed in an authoritarian manner. Everybody knew exactly who was above them and who was below them, who they have to obey and who they can give orders to. For the most part, *fun* was reserved for the afterlife and the rich. But come-on! let me show you how to make your docs fun :grin:

*(I utterly love this 5-whys interrogation technique! I recommend trying it out.)*
{:.small}

## Learning through experience

Learning is easiest through experience, thus let's start with a practical exercise. We will write an email.

Imagine the following scenario. 

It is Thursday, the 4th day of your 1-week sprint. You have just finished a ticket and have opened up a pull request. The ticket was about developing a new way to create CLI commands. The existing commands were all built on a now defunct library.

You are happy with your work, it took a lot of coordination between departments. You've talked to DevOps, you've talked to Product, you've talked to senior engineers, you've taken care of all concerns. Your PR will no doubt be approved quickly. However, one thing is still left to do: you have to tell everybody about this new way of writing commands. How do you do it?

Let's say you decide to write an email:

<div class="box">
Everybody,

I’ve been consulting with DevOps a lot lately, because I was writing a new command. And it turns out DevhOps has a lot of problems running our existing commands, they can’t do … and … and they are frustrated with … . Another problem is the fact that our library …. is not maintained anymore, so we shouldn’t use it anymore. It is not super dangerous to use it, but we should switch to something more stable soon. Together we’ve come to the conclusion that the best way forward is to use approach …. . I've written documentation about how to use the new system for CLI commands. So the old way is now deprecated, please do not use the old way anymore. If you need any help with the new way, you can ping me. 

Thank you,

Me
</div>

Great, done! Let's send it out. You have done everything and more. You've finished the ticket, you've communicated with everybody, you've even written docs and an email and everything. You are one great developer :relaxed: !

But, are you really done? 

The crucial part of email sending comes after the email has been sent. Will anybody read it? And will the recipient act on it?

Let's switch perspectives.

You are a different developer now. It is still Thursday, the 4th day of your 1-week sprint. You are down to 1 un-finished ticket. Truth be told, you have solved this last ticket as well, but the pesky end-to-end tests are failing. You've been staring at the failing tests for 1 hour now, trying to figure out how could your change have caused this, maybe the tests are just flaky. Should you take some time and make them stable? Do you even have the time? There is this important meeting tomorrow, you should start preparing for. Hm... oh, look an email has arrived.

What will happen now? Will this second developer read our email? Will she read it thoroughly? 

Of course not. 

The second developer has her own stuff to worry about. Maybe she has been with this team for a year and never had to write a command and so ... this email consists of nothing tangible for her. She'll skip over the text and forget it.

What did we expect to happen? People are not machines, we cannot insert a new if-statement into their decision mechanisms. People remember through repetition, not by reading emails. So... what exactly was our goal with the email? We never specified it. 

We should have started with instructions. First the TL;DR, then the explanation:

<div class="box">
Everybody,

Please, read the following docs: http://....

We have defined a new procedure for creating CLI commands. It is very important that we all adhere to it.

Thank you,

Me
</div>

This way of writing feels unnatural at the beginning. Intuitively, we would first explain the situation and then ask people to act. But we are all flooded with messages daily. I have recently realized, that I am being payed to read. I read emails, blogs, docs, Slack, Confluence, JIRA, 15five, ... There is always more to read. The logical consequence is skimming text. We no longer read, we skim, searching for a glimpse of relevance. 

Know your audience. Because they will only skim, be relevant and concise. 

What would have been the reaction to the above, shortened email? My guess is that 70% of its recipients would skim it and 20% would read the docs.

Is this it? Have we given it our best? Is this the best possible outcome?

Of course not. We went at this from the from angle. Sending out an email would always have been futile. 
