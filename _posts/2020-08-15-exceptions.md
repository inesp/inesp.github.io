---
title: "Exceptions: how to take advantage of them, while not destroying your code"
biblio:
---

Exceptions are a tricky beast. You could get on with your whole programming career without ever truly using them. But you would be missing out **big time**. Exceptions have 2 extraordinary superpowers, which shouldn't be underplayed. But these superpowers take time and effort to learn. Still, as parents say: just because something is difficult to learn, doesn't mean we shouldn't try to master it.

Nothing is quite like exceptions. You can't substitute them with any other statement, block, pattern or tool.. not truly anyway. But unfortunately, no scientific, easy to follow method for using them exists. And therein lies the rub. For to use them skillfully, you have to draw on your good experience, which you can only have if you have used them before. Notice the circular dependency? So what do you do? You have at least 2 options: you can go with the flow of the Go people and forbid anybody using them or you get intrigued and humbly try to get the circular dependency running. After all, there is code out there that has circular dependencies in it and is still running since many, many years.

## So.. what do we have to gain from using exceptions?

Exceptions are good for 2 amazing things:
- they immediately stop any execution, no matter how deeply nested in the stack
- they will tell anybody, who wants to know, the exact details for why they stopped

At first, you might think these 2 things aren't that amazing at all, but let me prove you wrong with a few examples. 😁

Exceptions exist to solve a very real problem: what should we do when an unexpected situation happens?

Let's say we have a function that calculates how big an aquarium should be according to what fish we will put inside. But suddenly, somebody wants to put a horse inside the aquarium. What do we do? How big an aquarium does a horse need? Em... at least a big enough aquarium that we can put a reasonably sized island into it, I guess. But in the real world, a function like this cannot think on its feet, it doesn't know who called it and what it needs its results for. So, it will raise an exception, which is nothing more than an explanation of its predicament. It will send this "message in a bottle" to its caller and hope that somebody somewhere higher up the stack will have more context to solve this crisis.

The alternative to raising an exception here might be to simply return 0 cubic cm: a horse will need 0 cubic cm. Or maybe the function should pretend this is a see-horse and will thus need as much space as a small see-horse? Or maybe, we should return -1 and hope that the caller of this function will understand that -1 is a special value and will thus not continue with its execution and instead diligently return -1 up the stack until this -1 reaches somebody somewhere who will have more context to solve this crisis of -1.

If we just try to make the Horse-input value work for our function we will most probably be silently hiding a bug. As far as I have seen a huge percentage of bugs never show up in Sentry. If our functions turn any kind of invalid input into a valid output, how are we then to know that our code didn't do what the user wanted/expected it to do?

Let's say we decide to return 0 for all non-fishy creatures. If the user submits a list of 9 fish and 1 horse into our aquarium-size-calculator function and we spit out the number 17405 cm^3, how should even the user know that the number is wrong? But what if our aquarium-size-calculator is an internal tool and the user is asking about the recommended size of a farm for 100 fish, 50 horses and 50 cows and we have internally miss-classified the horses as see creatures and now we return the number 500 m^2 of land 500 m^3 of water. How will we ever find this bug? The code works, no error is ever reported, all integers are integers, all strings are strings, the world is in order. When in fact, we are giving out bogus suggestions and having no back-loop to test our own results.

Even worse, what if this recommended-farm-size-calculator is our internal tool, an inside appraisal to determine if a farmer is following our animal-friendly-guidelines and is thus qualified to be included into our animal-friendly-farms association which is dedicated to financially support animal-friendly-farms and to hinder the success of all others? Bugs can have real life consequences



## So.. what are the pitfalls of using exceptions?

Exceptions are bad for 1 horribly prickly problem:
- you can never know which line can cause what kind of exceptions, never

And so it goes. Adding exceptions is great, but catching them is the real art.

Whenever we compare 2 approaches, we often compare the thing that we are doing now in a very messy way with the perfect, often trivial example of how approach B should be used. We are rarely comparing our messy version of approach A with our future messy version of approach B. Any anything messy will always look worse than something ...
