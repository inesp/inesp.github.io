---
title: How to estimate data requirements
biblio:
  - 
    title: "Episode 06: Into to Architecture and Systems Design Interviews"
    link: "https://www.youtube.com/watch?v=ZgdS0EUmn70"
  -
    title: "Grokking the System Design Interview"
    link: "https://www.educative.io/collection/5668639101419520/5649050225344512"
  - 
    title: "Storage Pod 6.0: Building a 60 Drive 480TB Storage Server"
    link: "https://www.backblaze.com/blog/open-source-data-storage-server/"
  - 
    title: "Does Google Photos Compress The Life Out Of Your Pics? Here's What Our Experiment Revealed"
    link: "https://www.huffingtonpost.in/arpit-verma/bursting-the-myth-of-comp_b_8902076.html"
  - 
    title: "Test: Megabit/Gigabit Upgrade for a Download Server"
    link: "https://www.paessler.com/tools/webstress/sample_performance_tests/megabit_gigabit_upgrade_for_a_download_server"
---

Lately, this has become a common interview question: How many Bytes will some hypothetical app probably need? When in fact, planning the data storage capacity is usually a complicated and time-consuming operation. So how do you present your case in 45 minutes?

From where I stand, I see too many too loosely defined variables to see any real point in answering such questions, but being the interviewee, we usually decide to play along.

So, even if the result can have no real-world value, let's say that we absolutely must come up with a plausible number, a ballpark figure. How would we go about doing it?

## Let's talk over coffee

For starters, we need to take the scariness out of this interview question.

Since it is far more pleasant to discuss ideas with friends over coffee, than with bosses across the table, a good approach is to see the interviewer as if they were a colleague of yours, they don't know the answer, you don't know the answer, but let's see what numbers we can come up with together.

## Types of estimates

There are at least the following types of estimates:
- **traffic, throughput, bandwidth estimates**
  How much traffic do you expect? Traffic is usually measured per month or per day. While bandwidth is measured per second and roughly describes the peak amount of traffic you will have to serve per second.
- **storage estimates**
  How much DB space do you expect to take up? Will 1 DB server be enough? How much other disk space do you expect to need?
- **memory estimates**

## Scenario

You are building an app for photo sharing. You have about 500M active users per month. How much hardware space do you need?

---

First of all, let's figure out what will we store? 

Our users will upload pictures and they will download pictures. 

![Uploads-and-downloads](/assets/estimates-upload-download.jpg)

Let's first focus on the upload. We will derive the download numbers once we understand the upload numbers.

### Storage estimations for uploaded files

How much disk space do we need to store all uploaded pictures? Which variables are we interested in? Let's limit our discussion to average values. 

For every day we want to know
- the average number of images uploaded per user
- the average size of an image
- the number of users per day

And how many days will we store the images? Probably a few years.

To sum it up:

$$ 
space\_needed = users * img\_per\_day * img\_size * days\_to\_store
$$

**Hint #1:** Start with variables. Turn them into concrete numbers later.
{:.box}

Now it is time to make up some numbers :bowtie:

We were presented with the 500 M active users per month. Some of them will be very active every day, others might upload a few pictures in a whole year. 

Here you can start asking questions about when will the users use your app, how will they use it, how will they interact with it, how will they expect it to behave. Let's say that users will usually upload only a few times a year, after holidays and celebrations. In this case, they might upload 1000 pictures in 1 day or maybe just 100, but then not upload anything for the next 2 months. There might be a few, who will upload a picture every day, but these will probably not be many.... 
{:.small}

Let's just say that on average each user uploads 3 images a day, every day. The average size of these images shall be 1 MB. We will definitely start thinking about an image compressor. And let's limit the storage time to 1 month.

To sum up:

$$
images_{per\_day} = 500 e^6 users * 3 \frac{images}{user*day}\\ 
= 1 500\ milion\ \frac{images}{day} \\= 1.5\ bilion\ \frac{images}{day} 
$$

**Hint #2:** Use units with numbers, this way you will be more certain what the result represents. 
{:.box}

Ok, so about $$1.5\ bilion$$ images a day. Considering the average image size of 1 MB, after 1 month, this would amount to:

$$
  space\_needed = 1.5e9\ \frac{images}{day} * 1 \frac{MB}{image} * 31\ days\\
  = 46\ e3\ TB \\
  = 46\ PB
$$ 

So we are at $$46 000 TB$$. But we haven't yet talked about backup storage. :joy: 

Storage costs per GB are very low, we are talking about a few US$-cents, maybe $$\$0.05$$ per GB. Which still amounts to only a few thousand US$ for all of the 46 PB.

Still, we might be interested to research some kind of image compression techniques. From our users' perspectives, it would make sense to increase the storage time to a few years at least.

But let's move on to traffic estimations. The numbers we got are good enough for our purposes.

### Traffic estimations

**Hint #3:** Build upon established numbers.
{:.box}

When thinking about expected traffic, you could be asking yourself are: 

> OK, we have 500M users per month, how many are this per day? Of course, it is not 500M / 30 days. How are these users geographically spaced? Are they all over the world are they all on the same continent? When do they use the app? Are they all using it at the same time, at 5:30 PM when they come from work?...
{:.font-italic}

But since we already went through the trouble of figuring out the $$1.5\ bilion$$ image uploads per day. This is the number we should lean on.

For simplicity, let's say these uploads will be perfectly distributed over the whole day. This gives us:

$$
  uploads = 1.5e9 \frac{images}{day} / (24h * 60m * 60s) \\
  \cong 17000 \frac {images}{s}
$$

$$17K$$ images are uploaded every second, but each of these images is also viewed $$v$$ times. This is a photo-*sharing* app, so for every upload, there is going to be $$v$$ viewings. Let's say that on average every image gets viewed 10 times. This means $$170 000$$ requests per second:

$$
 requests = 17000 \frac{images}{s} * 10 \frac{req}{image} = 170\ K \frac{req}{s} \\ 

  170 K \frac{req}{s} * 1\frac{MB}{req} = 170 \frac{GB}{s}
$$

This means that our servers need to serve $$170 GB/s$$.

Servers are limited by 2 things: the number of concurrent connections and the bandwidth.

What is a reasonable number of concurrent connections for a server? I have no idea. This depends at least on the server's spec and the kind of processing we will be doing for each request. The only way to answer this would be to look at the statistics of some actual servers, of which there seem to be very few on the internet.

How are we supposed to continue with no data from here on? I don't know. Can I server deliver 1 GB of data per second (that is 8 000 000 kbit/s), I don't know. Maybe it is closer to 0.1 GB/s, maybe it is 0.01 GB/s. 

Everything up to here was pure speculation, but everything from here on would be just imagination. I presume there are some specialists somewhere, who deal with these numbers all the time. Better ask them :grin:

## Exhausted...

As you can see, we still came up with some compelling numbers. We are most definitely wrong because the world has a special way of being whimsical, but we did persevere. We did not give up and we did not get scared ad we will easily be persuaded that we are wrong. But doesn't every success story incorporate at least a bit of faking along the way?
