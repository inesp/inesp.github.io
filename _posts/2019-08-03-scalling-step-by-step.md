---
title: Scale your system from 1 to millions of users
biblio:
  - 
    title: "System Design Interview - An insider's guide"
  - 
    title: "Introduction to System Architecture Design"
    link: "https://medium.com/backendarmy/introduction-to-system-architecture-design-fcd4f327b6c9"
  - 
    title: "Udacity: Web Development"
    link: "https://www.youtube.com/playlist?list=PLAwxTw4SYaPlLXUhUNt1wINWrrH9axjcI"
  - 
    title: "What is domain name resolution?"
    link: "https://www.cloudns.net/blog/domain-name-resolution/"
  -
    title: "IP Addresses for Domains and their Subdomains the same?"
    link: "https://stackoverflow.com/questions/11561757/ip-addresses-for-domains-and-their-subdomains-the-same"
  - 
    title: "When should one consider having a separate database server?"
    linke: "https://www.quora.com/When-should-one-consider-having-a-separate-database-server"
  - 
    title: "Database Network Latency"
    link: "https://stackoverflow.com/questions/605648/database-network-latency"
  -  
    title: "Denial of Service Attack Mitigation on AWS"
    link: "https://aws.amazon.com/answers/networking/aws-ddos-attack-mitigation/"
---

In this post, I wanted to create a list of stages, possible designs of a system as it caters to different-sized audiences. What is the minimum setup for a system if it has but 1 user a day and how it progresses towards a system, which serves 500M users per day.

## Stage 1: 1 user

What is the minimum architecture you need for a simple website? 

Let's say you want to start a radio website called Radiodeck. You haven't yet told this to anyone, so for now, there is going to be just you visiting Radiodeck. What is the basic system architecture for this website?

Since this is 2019, you will not host your website on your own server in the basement but will buy some server capabilities at **a cloud provider** (AWS, Google Cloud, Digital Ocean, ... ).

The cloud provider will assign a **Virtual Server** to your website with a specific amount of resources (CPU, RAM, SSD, Bandwith, ...) reserved for it.

You schema looks something like this:

![Scaling for 1 user](/assets/scaling-for-1-user.jpg)

After you have registered your new domain and reserved space at the cloud provider, your IP and domain will be mapped together and stored in DNS servers. When a user types `www.radiodeck.si` into their browser's URL window, their router will start the process of resolving this domain name to an IP address. Eventually, this initial request will be resolved by some **DNS server**.

An interesting tidbit about IP addresses: Do different subdomains have different IP addresses or the same? In our case, we have `api...` and `www....`. They can be the same or different. A domain can be registered with a wildcard `*.radiodeck.si`, in which case all subdomains will have the same IP and will live on the same server. In this case, the server needs to be able to distinguish between subdomains to handle them correctly.
{:.box}

Once the IP address is known, the actual request can take place. The browser will send an **HTTP** protocol request specifying what page/resource they need and will receive an **HTTP** response with the appropriate response. 

The most common response is a **HTML document**. This is what is usually served to browsers for their GET requests. Mobile apps, on the other hand, most commonly receive structured data in the **JSON** format (or for historical reasons in the **XML** format).

## Stage 2: 500 active users

\*Generally speaking a 500 users is not much, but let's say your Radiodeck website is somewhat memory(RAM) intensive and your visitors tend to stick on the site for a longer time.
{:.small}

How do you modify your system?

You have 2 options: either you scale **Vertically** or **Horizontally**. Either you buy a server with better performance, more RAM, CPU, storage, ... or you buy a second server.

![Scaling up and out](/assets/scaling-up-and-out.jpg)

Scaling up (vertically) is generally more expensive, but it also has very hard limits. After a certain amount, you cannot get more CPU or more RAM for any price. Scaling out (horizontally) is thus usually preferred. It does demand a few code changes (or at least settings changes), but it also opens up the possibility to create redundancy more easily later on.

The easiest way to test out horizontal scaling, without having to drastically change your code or delve into the problems of distributed systems, is to put your DB on a separate server. 

![Scaling for 250 users](/assets/scaling-for-stage-2-B.jpg)

This way you have duplicated your resources for a low price. Both of your servers can now scale independently of one another. They can take care of their available resources without disturbing one another.

One downside, however, is the newly introduced latency between the 2 servers. But most of the time, this will be nothing compared to the time you are loosing querying the database with bad code or non-optimized ORM calls.

## Stage 3: 1000\* active users

\*Again, 1000 is a randomly chosen number. 1000 users can be a lot or a little, depending on your site.
{:.small}

### Scale your App server

You are gaining in popularity (or at least you are hoping you are :smile:). The load on your app server is getting a bit too much, what can you do next?

Let's add another app server. If one is happy handling 1000 users, two should be able to take care of 2000 users. But since we have 2 app servers now, we need to add a **Load Balancer** to direct the requests evenly to both.

![Scaling for 1000 users](/assets/scaling-for-stage-3.jpg)

With this setup, we gain the capacity to serve more users, but we have also increased the availability of our radio. If one of the servers goes down, our website will still be available through the other one. 

The IP address that is associated with our website is now used to contact the load balancer. Our servers are now reachable only on the private network. This has the added benefit of increased security. Since there are fewer components accessible publicly, there are also fewer resources to attack.

Over the years, load balancers have gained more and more responsibility and have developed into a sort of gatekeepers for the servers they "guard". They are often used as a line of defence against DDoS attacks since they can automatically redirect suspicious requests away from your servers. 

### Scale your DB server

What if it is your DB server, which is struggling? With these few users you are probably not suffering from too many writes, but from too many reads. Or maybe you just want to add some redundancy on the DB side as well. If one of your app servers dies, you still have the other one, but if your DB server dies, Radiodeck does not work. 

What can you do?

The first step in scaling a DB server are **Read Replicas**. 
