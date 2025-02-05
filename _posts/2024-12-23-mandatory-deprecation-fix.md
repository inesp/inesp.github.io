---
title: "How to <i><s>force</s></i> encourage developers to fix Python warnings for deprecated features"
tags: people
excerpt_separator: <!--more-->
biblio: 
  - link: https://docs.pytest.org/en/stable/how-to/capture-warnings.html
    title: "Pytest: How to capture warnings"
  - link: https://docs.python.org/3/library/warnings.html#the-warnings-filter
    title: "Python: The warnings filter"
---

Our code is so interdependent! Adding dependencies to projects is just how code is done. 

Every time somebody sneezes a new dependency is added to a project somewhere. 

It is kinda great that we are on this side of the copy-right debate, where the default is building things on top of other people's work, and not shooting at everybody, who dares to even look in the direction of my code. But... who is going to upgrade all these dependencies all the time?

In the perfect world, we are a community and we all keep the libs upgraded to the latest versions, right? 

Wrong! Devs need to be *softly* pushed to do the right thing. Yes, *softly*, so they don't notice they are being pushed 😉🚧🚧🚧.

<!--more-->

## Step 1: First we need to listen to deprecation warnings

We are using `pytest`, so this step is easy-peasy for us.  

> Starting from version `3.1`, pytest now automatically catches warnings during test execution and displays them at the end of the session:

<small>- [Pytest: How to capture warnings](https://docs.pytest.org/en/stable/how-to/capture-warnings.html){:target="_blank"}</small>

like this:

````bash
============================= warnings summary =============================
test_bla_bla_bla.py::test_test
  .../some_file.py:65: PydanticDeprecatedSince20: `pydantic.config.Extra` 
    is deprecated, use literal values instead (e.g. `extra='allow'`). 
    Deprecated in Pydantic V2.0 to be removed in V3.0. See Pydantic V2 Migration Guide 
    at https://errors.pydantic.dev/2.9/migration/
      extra=Extra.allow,
    
  .../marshmallow/fields.py:1186: RemovedInMarshammlow4Warning: The 'default' argument
    to fields is deprecated. Use 'dump_default' instead.
      super().__init__(**kwargs)
    
======================= 1 passed, 2 warnings in 0.12s =======================
````

## Step 2: Pick the warnings you want to get rid of

I saw the `marshmallow` warning, looked at the code and saw that it was a simple fix. 

So, I'm choosing `RemovedInMarshammlow4Warning`.


## Step 3: Make deprecation warnings fail the tests

Again, we are using `pytest`, so this step is also easy-peasy for us. 

Just add this to the config file:

```toml
[tool.pytest.ini_options]
...
filterwarnings = [
    "error::marshmallow.warnings.RemovedInMarshmallow4Warning"
]
```

<small>- [Pytest: Controlling warnings](https://docs.pytest.org/en/stable/how-to/capture-warnings.html#controlling-warnings){:target="_blank"}</small>

Now every test that triggers this deprecation warning will fail.

## Step 4: Fix the code

Unfortunately, you have to take one for the team here. You have to go and fix all the places where this warning is triggered.

I know.. it's unfair. 

It's a lot of work, it's tedious work and you won't even be able to brag to your boss about it, because it is too technical and generally perceived as irrelevant from their standpoint.

And everything this does is help the next person (who won't be you), who will upgrade marshmallow and nothing in code will break. So, they won't thank you either, because they won't even notice anything has been done. 

So, ... what I'm saying is: sometimes you need to do the right thing, and nobody will thank you for it. 

But I will know. And you will know. 🤝

## Step 5: Lean back and listen to Slack convos and GitHub comments

Eventually, there should be one message somewhere of somebody being confused: they wrote the code the same as last time, but this time, the tests fail, what's going on? 

And you can say: "oh, hard to say, but I do see this is a deprecated feature, that must be the reason". 🍹
