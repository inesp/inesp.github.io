---
title: "Exceptions: how to take advantage of them, while not destroying your code"
biblio:
---

Exceptions are a tricky beast. It is difficult to know when to raise them and it is even more difficult to know when to catch them. Raising them is phylosophical dilema: is my unexpected situation exceptional enough that it merits an Exception or should I just put more effort into validating my function's input. Catching them is even worse. Catching exceptions entails me knowing exactly which are the exceptions a line of code can throw and then also knowing exactly what to do in all of these different cases.  Both of these conditions individually are practically unknowable, put together they just ... completely eliminate my chances of getting it right the first time. Still, as parents say: just because something is difficult to learn, doesn't mean we shouldn't try to master it. Exceptions have 2 extraordinary superpowers, which shouldn't be underplayed. But these superpowers take time and effort to learn.

Nothing is quite like exceptions. You can't substitute them with any other statement, block, pattern or tool.. not truly anyway. But unfortunately, no systematic, easy to follow method for using them exists. And therein lies the rub. For to use them skillfully, you have to draw on your good experience, which you can only have if you have used them before. Notice the circular dependency? So what do you do? You have at least 2 options: you can go with the flow of the Go people and forbid anybody using them or you get intrigued and humbly try to get the circular dependency running. After all, rumors have it lots of code with circular dependencies is running in the world since many, many years.

## So.. what do we have to gain from using exceptions?

Exceptions are good for 2 amazing things:
- they immediately stop any execution, no matter how deeply nested in the stack
- they will tell anybody, who wants to know, the exact details for why they stopped

You might think, that doesn't sound amazing at all, but let me prove you wrong by showing how they tie your code together. 😁

Let's take the following function as an example:

```python
def calculate_aquarium_size_for(animals: List[Animal]) -> float:
  """Return the size of the needed aquarium in m^3, given a list of animals
  that will live in it."""
```

Our main objective in this exercise is to know when our code is messing up, returning an incorrect value. **How will you know that your function is working correctly?**

Something goes wrong and suddenly a *horse* is one of the input variables. What should your function do? How big an aquarium does a horse need?

Hm,.. frankly, probably at least a big enough aquarium that we can put a reasonably sized island into it, might be the correct answer. But our function can never figure this out, so .. what should our function do? Because it absolutely does not know what to do with a horse, it can decide to raise an `Exception`, which is nothing more than an explanation of its predicament. It can send this *"message in a bottle"* to its caller and hope that somebody somewhere higher up the stack will have more context to solve this crisis.

If our exception catching in the stack above is reasonable this error will find its way to the user, in the form of a more or less opaque error message, and also to the programmer, because, a smart developer logs all exceptions :wink: . Our program will also stop all future steps, which in our case might mean that we will not send out an order to buy an aquarium of the calculated size and that is definitely a good thing.

But what if we don't like exceptions and have sworn to never use them. Maybe we have bad experiences, maybe we've seen idiots misuse exceptions in an old nuclear-missiles storage facility. Maybe it all almost went kabooom. And now we are scared for life. Or maybe we just saw a really badly maintained codebase that was littered with exceptions as if the devs were payed by the number of exceptions they raise.

## What are the alternatives then?

If the exceptions are like raising an alarm, with bells and sirens, then the alternative is to simply process this unexpected input and return something, something that will convey the same message: "This input is unexpected", but that will only reach the immediate caller and not bubble up the call-stack.

We might, for instance, return 0: a horse will need 0 m^3 of water. Maybe even better, we could return -1 and make it more obvious that this number represents an error. As the next step, we have to make sure that the caller understands this output. If it sees -1, then it must do something, must handle this situation. If it doesn't know how, then it should return a similar error value to its caller. And so must the next caller do and the next caller and the next caller ... .

If there are no exceptions, then each function must first check the results of any other function it calls and decide if the result is valid or not. If the result isn't valid, it has to pass a similar error response to its caller. This sounds like a really good idea. Each time you call a function, you have to think about any invalid value it could return, any errors it could cause. But then, that is exactly how exceptions work. Exceptions are basically a special return value. Programming languages already come with the detector for this invalid return value, an `Exception`, which they then automatically pass to the next caller, if this caller doesn't know what to do about it. The initial rule still stands: the dev has to think about what exceptions any function call might raise. The problem is just that this is very, very difficult.

So, yes, you can build your own exceptions or you can use the ones, which are provided (if any are).

## Passing the exception context

The second superpower of `Exceptions` I have listed is the ability to pass a lot of context with it. When raising an exception, we tend to overlook this aspect. But when we get a bug report,

Think about it, a good exception will tell you exactly what went wrong.   



----




# Afterall, exceptions exist to solve a very real problem: what should we do when an unexpected situation happens?

## So.. what are the pitfalls of using exceptions?

Exceptions are bad for 1 horribly prickly problem:
- you can never know which line can cause what kind of exceptions, never

And so it goes. Adding exceptions is great, but catching them is the real art.

Whenever we compare 2 approaches, we often compare the thing that we are doing now in a very messy way with the perfect, often trivial example of how approach B should be used. We are rarely comparing our messy version of approach A with our future messy version of approach B. Any anything messy will always look worse than something ...
