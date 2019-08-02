---
title: How to estimate data requirements
tags: ["estimation"]
---

Lately, this has become a common interview question. How many Bytes will some kind of hypothetical app probably need? But in fact, planning the data storage capacity is usually a complicated and time-consuming operation.

For my taste, there are too many too loosely defined variables for the result to have any kind of real value. Even if the end goal is just to provide a ballpark figure. However, let us assume that we absolutely have to come up with a plausible number, how would we go about doing it.

I have found that in a way the best approach is to see the interviewer as if they were a colleague of yours, they don't know the answer, you don't know the answer, but let's see what numbers we can come up with together.

## Types of estimates

There are at least the following types of estimates:
- **traffic/throughput and bandwidth estimates**
  
  How much traffic do you expect? Traffic is usually measured per month or per day. While bandwidth is measured per second and roughly describes the peak amount of traffic you will have to serve per second.
 
- **storage estimates**

  How much DB space do you expect to take up? Will 1 DB server be enough? How much other disk space do you expect to need?

- **memory estimates**



### Scenario 1

You are building an app for photo sharing. You have about 500M active users per month. How much hardware space do you need?

---

First of all, let's figure out what will we store? 

Our users will upload pictures and they will download pictures. 

![Uploads-and-downloads](/assets/estimates-upload-download.jpg)

Let's first focus on the upload. We will derive the download numbers once we understand the upload numbers.

How much disk space do we need to store all uploaded pictures? Which variables are we interested in? Let's limit our discussion to average values. 

For every day we want to know
- the average number of images uploaded per user
- the average size of an image
- the number of users per day

To sum it up. On every day we need:

$$ space-needed = users * img_per_day * img_size$$

**Hint #1:** Start with variables. Turn them into concrete numbers later.
{:.box}

Now it is time to make up some numbers :bowtie:

We were presented with the 500 M active users per month. Some of them will be very active every day, other might upload a few pictures in a whole year, but let's just say that on average each user uploads 10 images a day, every day. The average size of these images shall be 3 MB.

To sum up:
```python

space_needed_per_day = 500 * e6
```







The only number we were presented with is 500 M users per month. But as far as storage goes, as far as hardware goes, this is not really a useful number. 

Things you could be asking yourself is How are these users geographically spaced? Are they all over the world are they all on the same continent? When do they use the app? Are they all using it at the same time, at 5:30 PM when they come from work?




###### External sources:
{:.external_links}

- [Episode 06: Into to Architecture and Systems Design Interviews](https://www.youtube.com/watch?v=ZgdS0EUmn70){:target="_blank"}
- [Grokking the System Design Interview](https://www.educative.io/collection/5668639101419520/5649050225344512){:target="_blank"}


