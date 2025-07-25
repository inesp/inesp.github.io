---
title: "How reading other people's python code shaped my style"
biblio:
  -
    title: "Python Marshmallow"
    link: "https://marshmallow.readthedocs.io/en/stable/"
---

Code readability is a hot topic. We do not agree on what it looks like and we do not agree on how much of it is needed. It is rarely discussed on a new project and practically never on a project with only 1 developer. 

The obvious advantage of striving for readability is to have code, which is easier to share between developers and which is easier to maintain, expand, correct and modify later on.

Consequently, if you hope for your project to be long-lived or if you hope for it to grow with plenty of new features, there are benefits to be gained. If your code is easy to read and understand, then new developers can be onboarded quicker and will be valuable sooner. Arguable, they will also make fewer bugs, because it is far easier to make a mistake when dealing with code, which you barely understand than in straightforward code.  

But the biggest problem with readability is that it is not objectively measurable. It is subjective in its nature. English, written with Japanese katakana letters, is not readable to me, because I am not fluent in katakana. For somebody else, the opposite might be true, they are fluent in katakana, but not in English. None of these 2 examples is objectively more readable than the other.

Code will always be exquisitely more readable and maintainable to those, who wrote it, than to those, who came after them.

Nevertheless, you can do a lot to help your successors understand your intentions. Here are my 3 random illustrations.

## Use the more common default

**Problem** 

You have a function, which calculates a user's favourite colour. The calculation is complicated, so you will cache the result, but you will let the programmer decide whether she wants a freshly calculated colour or the value from the cache.

**Question**

Here are 4 possible definitions. They are 4 possible variants to the 2 questions:
- should the default be USE cache or NOT USE cache?
- should the parameter's name be `use_cache` or `ignore_cache`?

<script src="https://gist.github.com/inesp/76978a498e33e238776c4d01f82f0459.js"></script>

**Guideline**

To answer *"should the default be USE cache or NOT USE cache?"* we must look at how our function will be called. 

If we already have a bunch of functions, with the same cache behaviour, then we should prefer to copy that behaviour.

If the programmers will use cache 80% of the time, then this should be the default behaviour of this function.

Let's say, that we want the default to be *USE cache*.

To answer the second question *"should the parameter's name be use_cache or ignore_cache"*, we must look at the inside of the function. How do we use this parameter in if-statements? Do we usually say `if xxx` or `if not xxx`? Extra points can be lost with a double negation, i.e. `if not ignore_cache`, such statements are especially difficult to keep in mind.

Which of the following 2 options do you prefer?

**Hint:** One useful test for code readability is: do you need a pen and paper, to remember the flow of a function?
{:.box}

**Option A) using `use_cache=True`**

<script src="https://gist.github.com/inesp/d269d2d4e6f13d225bd993c26ac4fd76.js"></script>

**Option B) using `ignore_cache=False`**

<script src="https://gist.github.com/inesp/7c806216c188a14c5f85b9665f59a3e8.js"></script>

I definitely prefer Option A. The `if not ignore_cache` followed immediately by a `if ignore_cache` with a nested `if not ignore_cache` is just too much for me. It looks like an absurd complication of what must have started out as a simple flow.

**Problem<sup>2</sup>**

What if we absolutely have to use `ignore_cache` because all the other functions use it or because this function already exists and is used heavily?

**Proposal<sup>2</sup>**

Refactor the function. You can do something as simple as create an internal variable `use_cache = not ignore_cache` or you can look at the flow of the function and see if there is something that can be done to improve it.

Maybe something like this would work:

<script src="https://gist.github.com/inesp/609db41a4b8757e7d3d51360713b7849.js"></script>

## Prefer safelisting function arguments to using `**kwargs`

**Problem**

You class accepts many, many `init` parameters. To save time (or because Pylint has a limit of 5 parameters per function) you decide to group them all into `**pizza_properties`:

<script src="https://gist.github.com/inesp/a085ff7ca1f52e7a015fefa05ce83827.js"></script>

**Question**

How stable do you find the above code? Do you think it will prevent bugs or be a breeding ground for them? 

How have we documented which keys in `piza_properties` we support? Will the next developer have to go through every `Pizza` class to get a list of possible parameters, their types and their default values? Have we just added a 2-level parameter lookup?

What if the call to `PizzaMaker.create_pizaa()` is already nested somewhere deep inside the project's code? This 2-level parameter lookup might be 10 levels deep already.

What if `create_pizza` is also called in a function with semi-specified input parameters? This can get out of hand quickly.

But maybe the more important question is: How secure do you think the above code is?

We have just enabled all future developers (and possibly users) to have direct access to the pizza table in the database. Every column in the `Pizza` database model is accessible. Yes, we might have some model/database-level validators, but why let a potential attacker this close to the database? What if there is a bug in the validators?

Just by calling:

<script src="https://gist.github.com/inesp/a909c0565bbeb0f6a66d8d019489f7a5.js"></script>

I have the potential to create faulty data, which will be very difficult to spot and debug.

**Guidelines**

It is always safer to safelist possible parameters as opposed to blocklisting them. And it is always safer to spell out each parameter we support. This gives us also the chance to raise an error early if an unexpected parameter is encountered. Someone might have just misspelled the word `cheze`, but an error with a message `create_cheeze() got an unexpected keyword argument 'cheze'` is much more informative than receiving a database error.

There will, of course, be times, when it makes sense to use `**kwargs` or `*args`, but this is mostly useful for passing parameters between 2 well-defined functions/classes.  

We should always look at our code from the view-point of other developers. How will they call it? How will they figure out what they can call it with? And we must always limit what our function can do! Trust no one, as they say. Even if you think your function cannot get un-sanitized user input, you can never be sure that everybody else properly sanitizes user input before sending it to you.

So, what can you do to make this code better? Many different things, here are some of my immediate ideas. 

**Proposal A)**

We can define (Marshmallow) schemas for the input parameters. This will allow us to validate the parameters before we use them:

<script src="https://gist.github.com/inesp/6efa458b76c13e96dbd009d02aa560f8.js"></script>

**Proposal B)**

We could define dedicated `PizzaMaker`s for each pizza type.

<script src="https://gist.github.com/inesp/44ef0e01989f7af8e7f9b474e88df6fd.js"></script>

Both of these proposals might not be the perfect solution to our problem, they both certainly consist of more code than the original solution. But they also both validate the `pizza_properties`, they do something helpful in the extra lines of code.

## Functions and classes are for free, use them

Functions and classes are just an abstraction layer. They are just commentary of the code, they explain the purpose of the code and guide other developers towards the intentioned use. 

**Problem**

Your app's users can create 10 different types of objects. They can create: issues, tasks, people, events, news, ... . All of these objects have a `title`, except for people, they have a `name`. 

When you show dropdowns of issues, you show the issues' `title`s, when you show dropdowns of people, you show people's `name`s.

1 `if`-statement shows up a lot in your code: `obj.name if isinstance(obj, Person) else obj.title`.

**Question**

Is 1 line already considered code-repetition? Are we already violating the DRY (=do not repeat yourself)  principle?

Or is 1 line too little to create a dedicated function?

**Guidelines**

Functions and classes are for free. As long as a function does some work, it is worth having it.

When we move some functionality into a dedicated function or class, we fence it off from the other code and we give it intent. Consequently, it will be much easier to replace or upgrade it. 

In our example, we can do: 

<script src="https://gist.github.com/inesp/b67ec7347be4246678573aa21b1901fb.js"></script>

and then (IMPORTANT!) replace every `if` with a call to this class. It is crucial that we also replace as much outdated code as possible with the new code. This will signal other developers that they too have to use `PrimaryTitleFiner` when resolving the title.

While doing this, we will no doubt also find other, similar `if`-statements. Maybe one like this: `"name" if isinstance(obj, Person) else "title"` and maybe one like this: `"name" if obj_type == "Person" else "title"`. Now that we have created `PrimaryTitleFinder`, we can add to it all the variations of all the `if`-statements. Alternatively, we can unify the different `if` statements and simplify the code base a bit.

## Conclusion

Readability is in the eye of the beholder. But ignoring it completely creates chaos in your project. 

Everything we built needs to be maintained, updated, refreshed to suit the changing times, changing requirements and expectations.

As long as we hope for our projects to become big and maintained by many people, we need to care about how others will interact with it.

![readability-issues](/assets/readability.png)





