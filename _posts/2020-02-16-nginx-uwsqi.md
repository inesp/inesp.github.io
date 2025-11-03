---
title: "The layered world of web development: Why I need NGINX and uWSGI to run a Python app?"
tags: ["Networking"]
biblio:
  - title: "Full Stack Python"
    link: "https://www.fullstackpython.com/"
  - title: "What is NGINX?"
    link: "https://www.nginx.com/resources/glossary/nginx/"
  - title: "What is WSGI?"
    link: "https://wsgi.readthedocs.io/en/latest/what.html"
  - title: "Usage of web servers broken down by ranking"
    link: "https://w3techs.com/technologies/cross/web_server/ranking"
  - title: "What the hell is WSGI anyway and what do you eat it with?"
    link: "https://rahmonov.me/posts/what-the-hell-is-wsgi-anyway-and-what-do-you-eat-it-with/"
  - title: "Why do I need nginx when I have uWSGI"
    link: "https://serverfault.com/questions/590819/why-do-i-need-nginx-when-i-have-uwsgi"
  - title: "PEP 3333 -- Python Web Server Gateway Interface v1.0.1"
    link: "https://www.python.org/dev/peps/pep-3333/"
---

Nginx is *"a web server which can also be used as a reverse proxy, load balancer, mail proxy and HTTP cache"*. uWSGI is an implementation of the WSGI spec, which describes how a web server should communicate with a web app, which makes uWSGI also a type of web server. So, why does a typical server setup for a Python app consists of 2 web servers?

## Can I ditch uWSGI?

Given the fact that Nginx is the [2nd most popular web server (right after Apache)](https://w3techs.com/technologies/cross/web_server/ranking){:.target=_blank} and uWSGI's website does an absolutely horrible job at explaining what uWSGI is or what it provides, I feel inclined to ditching uWSGI. I mean, just look at this description:

![uWSGI explanation](/assets/uWSGI-description.jpg)

This does not sound like something that would make my life easier. Its focus is even directed at other languages (C-languages). 

In truth, uWSGI does provide a lot of value. But to understand what it does, we need to take a closer look at WSGI (not uWSGI) and web servers.

Traditionally web servers are meant to serve static resources, static files. They don't know how to run Python scripts (or scripts in any other language) and more crucially, they don't know how to interpret the responses of these scripts. 

In such a world each developer would devise their own protocol for communication between their selected web server and their Python code. This protocol, this code would only work for the selected web server and Python app. Creating a new app would mean writing the protocol-bit again as well. Moving to another team would mean learning a new protocol. Writing a web framework would be a much more difficult task. 

To avoid this mess, WSGI was agreed upon (in PEP 333). WSGI is a simple API spec. It simply specifies how a web server and a Python script are to communicate with eatch other.

WSGI defines a very clear boundary between your application and a web server. Changing the server will not affect the application and vice versa.

This is what uWSGI gives us. uWSGI knows how to talk to a Python app and knows how to transform the response into something that a browser understands (an HTTP response) or something that a traditional web server (NGINX) understands (an HTML or JSON file).

## Can I then ditch NGINX?

uWSGI could be used as a standalone web server in production, but that is not it's intentional use. It may sound odd, but uWSGI was always supposed to be a go-between a full-featured web server like NGINX and your Python files. One funny detail is that uWSGI isn't that good at serving static files.

NGINX is much more powerful than uWSGI. For starters, it is more secure. Its default security settings are already decent and they can be configured further. NGINX has better handling of static resources, which can significanlly reduce server and network load. It offers ways to cache your dynamic content and it communicates with CDNs better. It is a great load balancer. ... 

It is just more powerful and can support a wider range of uses.

## The layered world of web development

Here is how the whole flow works

![Flow for a Python web app](/assets/uWSGI-flow.jpg)

Using both layers: a web server and a WSGI server gives us the future freedom to replace either one with any other server without having to make any changes to our codebase.

The way we do web development is becoming more and more layered. There is a constant stream of new tools entering our work environment with each tool providing a solution for one specific job. It is difficult to keep up. But a lot of these tools are genuinely useful. Because we are covering ever new problems with web development solutions, new ideas and new needs emerge. On the other hand, because we are constantly making progress, old ideas, which seemed too far fetched at the time, become possible now and thus spur the invention of new tools.

Like it or now, new tools are here to stay. Setting up a new project is currently a real pain because so much background has to be set up. True, we have tools for this as well, meta-tools, but unfortunately those also have to be learnt :) 

Maybe, after our community matures a bit more, we will find a pleasant balance between having to manually tinker with every layer in the system and having no control over what happens beyond our implementation. But until then, we will have to resort to reading lots and lots of blog post to be kept in the loop about constant improvements in our very young profession.


