---
layout: page
title: Conference Proposals
permalink: /proposals/
css: proposals-page
---

<div class="proposals-summary">
  <h2>📋 CFP Collection</h2>
  <p class="summary-text">A curated collection of conference proposals ready for submission. Each proposal represents hours of thought distillation and practical insights from real-world software development experiences.</p>
  
  <div class="stats-grid">
    <div class="stat-item">
      <span class="stat-number">3</span>
      <span class="stat-label">Ready Proposals</span>
    </div>
    <div class="stat-item">
      <span class="stat-number">2</span>
      <span class="stat-label">With Video</span>
    </div>
    <div class="stat-item">
      <span class="stat-number">3</span>
      <span class="stat-label">With Slides</span>
    </div>
  </div>
</div>

<div class="proposals-container">

  <article class="proposal-card">
    <div class="proposal-header">
      <h3 class="proposal-title">Software Estimation is a Delusion</h3>
      <div class="proposal-meta">
        <span class="proposal-length">⏱️ 45 minutes</span>
        <span class="proposal-status">✅ Delivered</span>
      </div>
    </div>
    
    <div class="proposal-abstract">
      <h4>Abstract</h4>
      <p>Software estimation is one of the most discussed and controversial topics in software development. We treat it as a science, but it behaves more like fortune telling. This talk explores why estimation consistently fails, what psychological biases cloud our judgment, and whether we should abandon the practice entirely or learn to use it differently.</p>
      
      <p>Through real-world examples and cognitive science research, we'll examine the gap between estimated and actual delivery times, the pressure to provide "accurate" estimates, and practical approaches to handle uncertainty in software projects without falling into the estimation trap.</p>
    </div>

    <div class="proposal-notes">
      <h4>Speaker Notes</h4>
      <ul>
        <li>Open with the classic "How long will this take?" scenario</li>
        <li>Include interactive polling about audience estimation experiences</li>
        <li>Reference Daniel Kahneman's work on cognitive biases</li>
        <li>Provide practical alternatives: story points, t-shirt sizing, probabilistic estimates</li>
        <li>End with actionable takeaways for both developers and managers</li>
      </ul>
    </div>

    <div class="proposal-links">
      <a href="https://speakerdeck.com/inesp/software-estimation-is-a-delusion" target="_blank" class="link-slides">📂 Slides</a>
      <a href="https://luxembourg.voxxeddays.com/en/" target="_blank" class="link-video">📷 Video</a>
    </div>
  </article>

  <article class="proposal-card">
    <div class="proposal-header">
      <h3 class="proposal-title">Conquering JSONB in PostgreSQL</h3>
      <div class="proposal-meta">
        <span class="proposal-length">⏱️ 30 minutes</span>
        <span class="proposal-status">✅ Delivered</span>
      </div>
    </div>
    
    <div class="proposal-abstract">
      <h4>Abstract</h4>
      <p>PostgreSQL's JSONB data type bridges the gap between relational and document databases, offering the flexibility of JSON with the performance of binary storage. This talk demonstrates practical patterns for using JSONB effectively in real applications.</p>
      
      <p>We'll explore indexing strategies, query optimization, data validation, and migration patterns. Learn when JSONB is the right choice and when traditional normalization serves you better. Perfect for developers working with evolving schemas or complex nested data structures.</p>
    </div>

    <div class="proposal-notes">
      <h4>Speaker Notes</h4>
      <ul>
        <li>Start with a comparison: JSONB vs traditional relational approach</li>
        <li>Live demo of GIN indexes and query performance</li>
        <li>Show real database schema evolution examples</li>
        <li>Discuss trade-offs between flexibility and consistency</li>
        <li>Include anti-patterns and common mistakes</li>
      </ul>
    </div>

    <div class="proposal-links">
      <a href="https://speakerdeck.com/inesp/conquering-jsonb-in-postgresql" target="_blank" class="link-slides">📂 Slides</a>
      <a href="https://www.youtube.com/watch?v=Agi7WWEZBNM&list=PLIZtfj-D-vQyHICP4U2rave3u8Tmzc7pZ" target="_blank" class="link-video">📷 Video</a>
      <a href="/2019/01/15/jsonb-postgresql-python.html" target="_blank" class="link-blog">📝 Blog Post</a>
    </div>
  </article>

  <article class="proposal-card">
    <div class="proposal-header">
      <h3 class="proposal-title">Applying Marketing Techniques to Developers' Day-to-Day</h3>
      <div class="proposal-meta">
        <span class="proposal-length">⏱️ 25 minutes</span>
        <span class="proposal-status">✅ Delivered</span>
      </div>
    </div>
    
    <div class="proposal-abstract">
      <h4>Abstract</h4>
      <p>Marketing and software development might seem like opposite worlds, but they share surprising similarities. Both involve understanding user behavior, crafting compelling narratives, and driving adoption. This talk explores how developers can apply marketing principles to improve code quality, team communication, and career growth.</p>
      
      <p>From "selling" code reviews to your team to positioning your technical decisions, learn practical techniques borrowed from marketing that make you a more effective developer and colleague.</p>
    </div>

    <div class="proposal-notes">
      <h4>Speaker Notes</h4>
      <ul>
        <li>Open with the question: "What do developers and marketers have in common?"</li>
        <li>Use examples from internal tool adoption within development teams</li>
        <li>Discuss the psychology of code reviews and PR descriptions</li>
        <li>Show how to "package" technical decisions for different audiences</li>
        <li>Include personal anecdotes about successful and failed "campaigns"</li>
      </ul>
    </div>

    <div class="proposal-links">
      <a href="https://speakerdeck.com/inesp/applying-marketing-techniques-to-developers-day-to-day" target="_blank" class="link-slides">📂 Slides</a>
    </div>
  </article>

</div>

<style>
.proposals-page {
  font-family: 'Exo 2', sans-serif;
}

.proposals-summary {
  background: linear-gradient(135deg, #fff283 0%, #ffed50 100%);
  border-radius: 12px;
  padding: 2rem;
  margin-bottom: 3rem;
  border-left: 4px solid #ff7898;
}

.proposals-summary h2 {
  font-family: 'Saira Stencil One', cursive;
  color: #212529;
  margin-bottom: 1rem;
  font-size: 1.8rem;
}

.summary-text {
  font-size: 1.1rem;
  line-height: 1.6;
  margin-bottom: 1.5rem;
  color: #212529;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
  gap: 1rem;
  margin-top: 1.5rem;
}

.stat-item {
  text-align: center;
  padding: 1rem;
  background: rgba(255, 255, 255, 0.3);
  border-radius: 8px;
  border: 1px solid rgba(255, 120, 152, 0.2);
}

.stat-number {
  display: block;
  font-size: 2rem;
  font-weight: 600;
  color: #ff0040;
  font-family: 'Saira Stencil One', cursive;
}

.stat-label {
  display: block;
  font-size: 0.9rem;
  color: #5c5200;
  margin-top: 0.5rem;
  font-weight: 600;
}

.proposals-container {
  display: grid;
  gap: 2rem;
}

.proposal-card {
  background: #fff;
  border-radius: 12px;
  padding: 2rem;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1), 0 1px 3px rgba(0, 0, 0, 0.08);
  border-left: 4px solid #ff7898;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.proposal-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15), 0 4px 10px rgba(0, 0, 0, 0.1);
}

.proposal-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 1.5rem;
  flex-wrap: wrap;
  gap: 1rem;
}

.proposal-title {
  font-family: 'Saira Stencil One', cursive;
  color: #212529;
  font-size: 1.4rem;
  margin: 0;
  flex: 1;
  min-width: 200px;
}

.proposal-meta {
  display: flex;
  gap: 1rem;
  flex-wrap: wrap;
}

.proposal-length, .proposal-status {
  background: #fff283;
  padding: 0.3rem 0.8rem;
  border-radius: 15px;
  font-size: 0.85rem;
  font-weight: 600;
  color: #5c5200;
  white-space: nowrap;
}

.proposal-status {
  background: #e8f5e8;
  color: #2d6e2d;
}

.proposal-abstract, .proposal-notes {
  margin-bottom: 1.5rem;
}

.proposal-abstract h4, .proposal-notes h4 {
  color: #ff0040;
  font-size: 1rem;
  font-weight: 600;
  margin-bottom: 0.8rem;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.proposal-abstract p {
  line-height: 1.6;
  margin-bottom: 1rem;
  color: #212529;
}

.proposal-notes ul {
  margin: 0;
  padding-left: 1.5rem;
}

.proposal-notes li {
  line-height: 1.6;
  margin-bottom: 0.5rem;
  color: #212529;
}

.proposal-links {
  display: flex;
  gap: 1rem;
  flex-wrap: wrap;
  padding-top: 1rem;
  border-top: 1px solid #f0f0f0;
}

.proposal-links a {
  display: inline-flex;
  align-items: center;
  padding: 0.5rem 1rem;
  border-radius: 6px;
  text-decoration: none;
  font-weight: 600;
  font-size: 0.9rem;
  transition: all 0.2s ease;
}

.link-slides {
  background: #fff283;
  color: #5c5200;
}

.link-slides:hover {
  background: #ffed50;
  color: #5c5200;
  transform: translateY(-1px);
}

.link-video {
  background: #ff7898;
  color: #fff;
}

.link-video:hover {
  background: #ff0040;
  color: #fff;
  transform: translateY(-1px);
}

.link-blog {
  background: #e8f5e8;
  color: #2d6e2d;
}

.link-blog:hover {
  background: #d4e8d4;
  color: #2d6e2d;
  transform: translateY(-1px);
}

@media (max-width: 768px) {
  .proposals-summary {
    padding: 1.5rem;
  }
  
  .proposal-card {
    padding: 1.5rem;
  }
  
  .proposal-header {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .proposal-meta {
    width: 100%;
  }
  
  .stats-grid {
    grid-template-columns: repeat(3, 1fr);
  }
  
  .stat-number {
    font-size: 1.5rem;
  }
}
</style>