---
layout: page
title: Curriculum vitae
permalink: /cv/
css: cv
---


Ines Panker, <b>senior staff software engineer</b> and <b><a href="/talks/">conference speaker</a></b>. 16 years in software, the last 6 as the first engineer and <b>de-facto architect</b> of a SaaS observability platform. The engineering teams built on what I designed, and I led the response when complex incidents crossed system boundaries.

Lately my work has turned toward LLMs: I've worked on the <b>LLM pipeline</b> for our AI-usage analytics tool (a tool that gives insights into what your team does with AI). I've built the small <b>RAG</b> behind our product's AI assistant, written many Claude skills and rules and have <b>built several agents for my own tooling</b>.

I also love speaking at conferences, like <b>Devoxx Belgium</b> (3,000+ developers, sells out in minutes), <b>J-Fall</b> (the biggest Java conference in the Netherlands) and <b>PyCon Italia</b>. Some talks come straight from the systems above: what happens when a third-party API goes down, and how to tell if a deploy broke production. The others are about the lies we tell ourselves: how we estimate, how we argue, ...


<dl class="cv-meta">
  <div>
    <dt>Based in</dt>
    <dd>Ljubljana, Slovenia (EU citizen)</dd>
  </div>
  <div>
    <dt>Working</dt>
    <dd>Remote since 2017, mostly with US teams</dd>
  </div>
  <div>
    <dt>Find me</dt>
    <dd><a href="https://www.linkedin.com/in/{{ site.social.linkedin }}" target="_blank">LinkedIn</a>, <a href="https://github.com/{{ site.social.github }}" target="_blank">GitHub</a>, <a href="/talks/">my talks</a></dd>
  </div>
  <div>
    <dt>Languages</dt>
    <dd>Slovenian (native)<br>English (fluent)<br>German (fluent)<br>French (basic)</dd>
  </div>
</dl>

<div class="colorful"></div>

## Experience

<div class="career-list career-wide">
  <div class="career-item">
    <div class="career-years">{% include career_icon.html name="nodes" %} 2020 – now</div>
    <div class="career-body">
      <h3>Senior Staff Software Engineer, <a href="https://www.sleuth.io" target="_blank">Sleuth</a> <span class="career-place">(San Francisco, remote)</span></h3>
      <p>The first engineer they hired, and the <b>de-facto architect</b> ever since. Sleuth is a multi-tenant <b>SaaS observability platform</b> for DORA metrics, environment health and real-time anomalies, fed by 30+ third-party services. I joined when it was two coding founders and a small codebase; the company grew to about 40 people, with the engineering teams building on that architecture.</p>
      <ul class="career-points">
        <li><b>Architecture</b>: <b>set the technical direction</b> the engineering teams built on. Designed the multi-tenant data model, tenant isolation, service boundaries and API contracts, and built the integration framework behind webhook and API ingestion from 30+ third-party services (Datadog, Sentry, PagerDuty, GitHub...).</li>
        <li><b>Resilience</b>: designed a circuit breaker system guarding, at peak, <b>2-3 million API calls a day</b>, added PostgreSQL advisory locks and Redis distributed locks for cluster-wide concurrency, and made Celery tasks transaction-aware to prevent race conditions.</li>
        <li><b>Background jobs</b>: set up and maintained the Celery workers that run all of Sleuth's background work, with separate queues for each kind of work. <b>Led the reliability project</b> when jobs kept failing halfway and customer data went missing: planned the milestones, split the work across the team, and moved us from Redis to RabbitMQ.</li>
        <li><b>The MTTR engine</b>: built the engine that attributes deploys to incident episodes, which is where the platform's mean-time-to-recovery number comes from.</li>
        <li><b>Applied ML</b>: created a self-tuning anomaly detector for customer metrics, with a fresh data point every 2 minutes, running for hundreds of clients for years without hand-tuning. <a href="/2026/02/18/impact-of-a-deploy.html">How it works, explained with pictures.</a></li>
        <li><b>LLM work</b>: worked on the pipeline behind Sleuth's AI-usage analytics, and built the small RAG behind the product's AI assistant.</li>
        <li><b>Go tooling</b>: built <a class="remote-link" href="https://github.com/sleuth-io/sx" target="_blank">sx</a>, an open-source CLI (300+ GitHub stars) that gives a whole team the same AI skills and rules in whichever coding tool each person uses: Copilot, Codex, Gemini, Cline, Kiro, including team scoping and role-based access.</li>
      </ul>
      <p class="career-tech"><span class="badge bg-teal">Python</span> <span class="badge bg-teal">Go</span> <span class="badge bg-teal">Django</span> <span class="badge bg-teal">Celery</span> <span class="badge bg-teal">PostgreSQL</span> <span class="badge bg-teal">Redis</span> <span class="badge bg-teal">RabbitMQ</span> <span class="badge bg-teal">Elasticsearch</span> <span class="badge bg-teal">Pandas</span></p>
    </div>
  </div>
  <div class="career-item">
    <div class="career-years">{% include career_icon.html name="magnifier" %} 2017 – 2019</div>
    <div class="career-body">
      <h3>Software Engineer, Reciprocity <span class="career-place">(now ZenGRC, San Francisco, remote)</span></h3>
      <ul class="career-points">
        <li>Reverse-engineered the legacy query patterns, mapped the hidden dependencies, and <b>rebuilt the model layer</b> on top of what I found.</li>
        <li>Ran internal training sessions on development environments, performance work and code practices.</li>
      </ul>
      <p class="career-tech"><span class="badge bg-teal">Python</span> <span class="badge bg-teal">Flask</span> <span class="badge bg-teal">SQLAlchemy</span> <span class="badge bg-teal">PostgreSQL</span></p>
    </div>
  </div>
  <div class="career-item">
    <div class="career-years">{% include career_icon.html name="cart" %} 2011 – 2017</div>
    <div class="career-body">
      <h3>Software Engineer, Innovatif <span class="career-place">(Ljubljana)</span></h3>
      <ul class="career-points">
        <li>Led the build of a <b>full e-commerce platform</b>.</li>
        <li>Built custom web applications for clients, and ran the deployment lifecycle on the Linux servers they lived on.</li>
      </ul>
      <p class="career-tech"><span class="badge bg-teal">PHP</span> <span class="badge bg-teal">MySQL</span> <span class="badge bg-teal">JavaScript</span> <span class="badge bg-teal">jQuery</span></p>
    </div>
  </div>
  <div class="career-item">
    <div class="career-years">{% include career_icon.html name="receipt" %} 2010 – 2011</div>
    <div class="career-body">
      <h3>Software Engineer, Infonova <span class="career-place">(Ljubljana)</span></h3>
      <p>First full-time job: an automated monthly invoicing system, from the calculation logic to the rendered documents.</p>
      <p class="career-tech"><span class="badge bg-teal">C#</span> <span class="badge bg-teal">Java</span> <span class="badge bg-teal">JavaScript</span></p>
    </div>
  </div>
  <div class="career-item">
    <div class="career-years">{% include career_icon.html name="blackboard" %} 2006 – 2007</div>
    <div class="career-body">
      <h3>Lecturer (student job), Housing Co. <span class="career-place">(Ljubljana)</span></h3>
      <p>Taught adults the basics of computers and Microsoft Office. The explaining-things career started before the engineering one.</p>
    </div>
  </div>
</div>

<div class="colorful"></div>

## What I work with

<div class="career-list career-wide career-skills">
  <div class="career-item">
    <div class="career-years">Core</div>
    <div class="career-body">
      <p class="career-tech"><span class="badge bg-teal">Python</span> <span class="badge bg-teal">Go</span> <span class="badge bg-teal">Django</span> <span class="badge bg-teal">Flask</span> <span class="badge bg-teal">Celery</span> <span class="badge bg-teal">PostgreSQL</span> <span class="badge bg-teal">Redis</span> <span class="badge bg-teal">RabbitMQ</span> <span class="badge bg-teal">Elasticsearch</span></p>
    </div>
  </div>
  <div class="career-item">
    <div class="career-years">Systems</div>
    <div class="career-body">
      <p class="career-tech"><span class="badge bg-teal">Multi-tenant SaaS</span> <span class="badge bg-teal">Circuit breakers</span> <span class="badge bg-teal">Distributed locking</span></p>
    </div>
  </div>
  <div class="career-item">
    <div class="career-years">Data</div>
    <div class="career-body">
      <p class="career-tech"><span class="badge bg-teal">Pandas</span> <span class="badge bg-teal">Anomaly detection</span> <span class="badge bg-teal">Time series</span></p>
    </div>
  </div>
  <div class="career-item">
    <div class="career-years">LLMs</div>
    <div class="career-body">
      <p class="career-tech"><span class="badge bg-teal">LLM agents</span> <span class="badge bg-teal">Context engineering</span> <span class="badge bg-teal">RAG</span></p>
    </div>
  </div>
  <div class="career-item">
    <div class="career-years">Explaining</div>
    <div class="career-body">
      <p class="career-tech"><span class="badge bg-teal">Technical writing</span> <span class="badge bg-teal">Documentation</span> <span class="badge bg-teal">Teaching</span> <span class="badge bg-teal">Conference talks</span></p>
    </div>
  </div>
  <div class="career-item">
    <div class="career-years">Earlier</div>
    <div class="career-body">
      <p class="career-tech"><span class="badge bg-yellow-washed-out">PHP</span> <span class="badge bg-yellow-washed-out">MySQL</span> <span class="badge bg-yellow-washed-out">JavaScript</span> <span class="badge bg-yellow-washed-out">C#</span> <span class="badge bg-yellow-washed-out">Java</span></p>
    </div>
  </div>
</div>

<div class="colorful"></div>

## On the side

<div class="career-list career-wide">
  <div class="career-item">
    <div class="career-years">{% include career_icon.html name="robot" %} 2026 – now</div>
    <div class="career-body">
      <h3>Agents that do real work for me</h3>
      <p><a class="remote-link" href="https://github.com/inesp/confetti-engine" target="_blank">Confetti</a>, my own conference tracker: two Claude agents research conferences and return structured JSON, deterministic Python validates it and writes the data. Each agent gets <b>two tools and a four-sentence brief</b> and nothing else: no project context, no MCP servers, none of the coding-agent scaffolding. Every run carries a hard dollar ceiling and logs what it cost.</p>
    </div>
  </div>
  <div class="career-item">
    <div class="career-years">{% include career_icon.html name="pen" %} 2019 – now</div>
    <div class="career-body">
      <h3>Writing this blog</h3>
      <p>Either production problems I had to solve, written up with diagrams: rate limits, circuit breakers, spotting a bad deploy. Or observations about humans interacting with code: cognitive biases that make smart devs write silly code, how we lie to each other with stats, ...</p>
    </div>
  </div>
  <div class="career-item">
    <div class="career-years">{% include career_icon.html name="diamond" %} 2017 – now</div>
    <div class="career-body">
      <h3>One product, all of it</h3>
      <p>My partner's business site, where I am the entire team: the full-stack engineer, the designer, the sysadmin, and even the marketing.</p>
    </div>
  </div>
  <div class="career-item">
    <div class="career-years">{% include career_icon.html name="mic" %} 2006 – now</div>
    <div class="career-body">
      <h3>Teaching, and later conference speaking</h3>
      <p>I started teaching before I learned programming. Lately, I speak at big developer conferences like <b>Devoxx Belgium</b> (3,000+ developers, sells out in minutes), <b>J-Fall</b> (the biggest Java conference in the Netherlands) and <b>PyCon Italia</b>, all in my own time, no sponsors and no employer agenda. Some talks come straight from the systems above: what happens when a third-party API goes down, and how to tell if a deploy broke production. The others are about the lies we tell ourselves: how we estimate, how we argue, ... <a href="/talks/">The full record and the talk catalogue.</a></p>
    </div>
  </div>
</div>

<div class="colorful"></div>

## Education

<div class="career-list career-wide">
  <div class="career-item">
    <div class="career-years">{% include career_icon.html name="cap" %} 2012</div>
    <div class="career-body">
      <h3>B.Sc. Computer Science, University of Ljubljana</h3>
      <p>With a semester in 2008 at the <b>University of Southern Denmark</b>, in Odense, on exchange.</p>
    </div>
  </div>
</div>


<div class="colorful"></div>

<div class="career-list career-wide">
  <div class="career-item career-next">
    <div class="career-years">next</div>
    <div class="career-body">
      <h3>What I'm looking for</h3>
      <p>Helping teams make sense of complex systems: a <b>staff engineering role</b>, <b>architecture work</b>, <b>untangling a codebase</b> that's outgrown its team, or <b>developer-facing work</b> where explaining clearly is the job. <br>Reach me on <a href="https://www.linkedin.com/in/{{ site.social.linkedin }}" target="_blank">LinkedIn</a>.</p>
    </div>
  </div>
</div>
