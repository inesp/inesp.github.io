---
series: Nobody Cares What You Built
title: 
tags: []
# prev_post:
# next_post:
# biblio:
#   - title:
#     link:
---

Intro paragraph here.

{% include toc.html %}


---------------------

Nobody cares about your company. Please, don't start talks and presentations with a history of your company.

Very important: Don't make it sound like self.help!!!

Even if they like you,... do they act in the way you wnt them to after the meeting?



------------------------------------
## Thoughts


ok, first off, what do I want to speak about here?

- emails, and slack msgs, about how you have to statr with the gist and then continue with the explanation
- code, how you want to make the docs just guide people, where they have no other way but to do what you want them to without needing to read the docs
- you want buy in to your idea. And however annoying this is, it's not true that the best idea wins, the most popular idea wins. Who gets the best jobs? The most connected people. They may or they may not be the smartest too, but the person, who gets the most exposure, statistically gets the best chances to land the best job. 
- Repetition across channels. One email = forgotten. A Slack message + updated docs + a PR comment template + a 2-min demo in standup = it sticks. Marketers call this "multi-touch."
- The curse of knowledge. You spent weeks on this, so it feels obvious and important. To everyone else, it's noise. You have to bridge that gap by showing, not telling — a before/after, a "look how painful the old way is" demo.
. Make the right thing the easy thing. Don't write a doc explaining the new way — make the old way harder. Linters, deprecation warnings, CI checks that nudge. This is "choice architecture" / nudge theory applied to dev work. The best marketing is when people don't realize they're being marketed to.
- - Write for the scanner, not the reader. Bold key phrases, use bullet points, front-load every paragraph. People's eyes jump around — design your text like a landing page, not an essay.         
- One message, one ask. The moment you combine "here's the new CLI process" with "also we're changing the deploy pipeline," both get ignored. Marketers know: one CTA per email.
- Optimize the first 60 seconds. If someone tries your thing and it doesn't work immediately, you've lost them forever. A working copy-paste example beats a perfect explanation.
- Authority borrowing. "I built this" = ignorable. "DevOps asked us to do this" or "this came out of the incident retro" = suddenly important. Same message, different weight.
- The demo > the doc. A 2-minute screen recording of you using the thing beats 2000 words. People trust what they can see working.
- Nobody owes you their attention. Attention is a currency and you're competing with Slack, Jira, their own deadlines, lunch. You have to earn the read.

> You build an internal tool. 3 people use it. Someone finds an external tool that does half as much. Everyone switches to that.
 Same idea, different packaging, different outcome.

I'm tired of:
- PR desc being an essay about all sorts of things. I don't hae time for that. I know you think I should, but I have my own work.... I'm not the baby sitter for your code.
- The "wall of text" Slack message where someone dumps their entire thought process and expects you to extract the point yourself <- also emails. just ... wall of text! maybe thta should be 1 post
- The "@ines read the above convo and implement it" — where someone just tags you into a 47-message thread with zero summary, zero ask, zero respect for your time. They did the easy part (tagging you) and left the hard part (figuring out what's needed) to you 

**people communicate what's in their head instead of what the other person needs.**

**people optimize for their own convenience, not the recipient's.** <-  docs are too hard to read, so I just ask Claude and hope it won't lie to me.. too much.

> packaging is not a nice-to-have, it's an engineering skill. Like testing or code review. And devs who refuse to learn it are like devs who refuse to write tests — they think the code should "just work" and anyone who doesn't get it isn't trying hard enough.
> you're not a good engineer if you can't get your work adopted.
