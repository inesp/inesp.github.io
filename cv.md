---
layout: page
title: Curriculum vitae
permalink: /cv/
css: cv
---


Ines Panker, <b>senior staff software engineer</b> and <b><a href="/talks/">conference speaker</a></b>. 

I build backends and the architecture around them, in <b>Python</b>, and I have a habit of picking up whatever the job is missing:
- the <b>circuit breakers</b> when our 30+ integrations started flaking
- the <b>anomaly-detection algorithm</b> when customer metrics needed watching
- the <b>profiling middleware</b> when production slowed down
- the <b>team training sessions</b>, which eventually outgrew the company and became conference talks

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
    <dt>Writing code since</dt>
    <dd>2010, Python since 2017</dd>
  </div>
  <div>
    <dt>Find me</dt>
    <dd><a href="https://www.linkedin.com/in/{{ site.social.linkedin }}" target="_blank">LinkedIn</a>, <a href="https://github.com/{{ site.social.github }}" target="_blank">GitHub</a></dd>
  </div>
  <div>
    <dt>Languages</dt>
    <dd>Slovenian (native)<br>English (fluent)<br>German (fluent)<br>French (basic)</dd>
  </div>
</dl>

<div class="career-list career-wide">
  <div class="career-item career-next">
    <div class="career-years">next</div>
    <div class="career-body">
      <h3>What I'm looking for</h3>
      <p>Helping teams make sense of complex systems: a <b>staff engineering role</b>, <b>architecture work</b>, <b>untangling a codebase</b> that's outgrown its team, or <b>developer-facing work</b> where explaining clearly is the job. <br>Reach me on <a href="https://www.linkedin.com/in/{{ site.social.linkedin }}" target="_blank">LinkedIn</a>.</p>
    </div>
  </div>
</div>

<div class="colorful"></div>

## What I work with

<div class="career-list career-wide career-skills">
  <div class="career-item">
    <div class="career-years">Core</div>
    <div class="career-body">
      <p class="career-tech"><span class="badge bg-teal">Python</span> <span class="badge bg-teal">Django</span> <span class="badge bg-teal">Flask</span> <span class="badge bg-teal">Celery</span> <span class="badge bg-teal">PostgreSQL</span> <span class="badge bg-teal">Redis</span> <span class="badge bg-teal">Elasticsearch</span></p>
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

## Experience

<div class="career-list career-wide">
  <div class="career-item">
    <div class="career-years">{% include career_icon.html name="nodes" %} 2020 – now</div>
    <div class="career-body">
      <h3>Senior Staff Software Engineer, <a href="https://www.sleuth.io" target="_blank">Sleuth</a> <span class="career-place">(San Francisco, remote)</span></h3>
      <p>The first engineer they hired, and the <b>de-facto architect</b> ever since. A prototype grew into a multi-tenant <b>SaaS observability platform</b> for DORA metrics, environment health and real-time anomalies, and the company to about 40 people.</p>
      <ul class="career-points">
        <li><b>Architecture from zero</b>: the multi-tenant data model, tenant isolation, service boundaries, API contracts, and the integration framework behind 30+ third-party services.</li>
        <li><b>Resilience</b>: a circuit breaker system guarding, at peak, <b>2-3 million API calls a day</b>, PostgreSQL advisory locks and Redis distributed locks for cluster-wide concurrency, and transaction-aware Celery tasks across 7 queues.</li>
        <li><b>The MTTR engine</b>: attributes deploys to incident episodes with a two-pointer matching algorithm, which is where the platform's mean-time-to-recovery number comes from.</li>
        <li><b>Applied ML</b>: a self-tuning anomaly detector for customer metrics, a fresh data point every 2 minutes, running for hundreds of clients for years without hand-tuning. <a href="/2026/02/18/impact-of-a-deploy.html">How it works, explained with pictures.</a></li>
        <li><b>LLM work</b>: the pipeline behind Sleuth's AI-usage analytics, and the small RAG behind the product's AI assistant.</li>
      </ul>
      <p class="career-tech"><span class="badge bg-teal">Python</span> <span class="badge bg-teal">Django</span> <span class="badge bg-teal">Celery</span> <span class="badge bg-teal">PostgreSQL</span> <span class="badge bg-teal">Redis</span> <span class="badge bg-teal">Elasticsearch</span> <span class="badge bg-teal">Pandas</span></p>
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
      <p class="career-tech"><span class="badge bg-teal">C#</span> <span class="badge bg-teal">JavaScript</span></p>
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
      <p>I aim to make complex ideas clear and relevant, blending technical insight with a focus on the people around the code.</p>
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
      <p>I started teaching before I learned programming, and I never stopped. I've given several talks all over Europe, all in my own time, no sponsors and no employer agenda. The subjects that interest me most are the lies we tell ourselves: how we estimate, how we argue, how we misuse statistics, ... <a href="/talks/">The full record and the talk catalogue.</a></p>
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

<p class="hero-links hero-links-left">
  <a href="/talks/">List of my talks</a>
</p>
