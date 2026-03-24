// Add rabbit holes to TOC in document order
(function() {
  document.addEventListener('DOMContentLoaded', function() {
    const toc = document.querySelector('details.toc nav');
    if (!toc) return;

    // Get all headings and rabbit holes in document order
    const article = document.querySelector('.article-body');
    if (!article) return;

    const elements = article.querySelectorAll('h2, h3, details.rabbit-hole');
    let lastTocLink = null;

    elements.forEach(function(el, i) {
      if (el.tagName.match(/^H[23]$/) && el.id) {
        // It's a heading - find its TOC link
        lastTocLink = toc.querySelector('a[href="#' + el.id + '"]');
      } else if (el.classList.contains('rabbit-hole')) {
        // It's a rabbit hole - add after last heading's TOC item
        const summary = el.querySelector('summary');
        if (!summary || !lastTocLink) return;

        // Create ID if missing
        if (!el.id) {
          el.id = 'rabbit-hole-' + i;
        }

        // Create and insert link
        const li = document.createElement('li');
        li.className = 'toc-rabbit-hole';
        li.innerHTML = '<a href="#' + el.id + '">🐰 ' + summary.textContent.trim() + '</a>';

        const parentLi = lastTocLink.closest('li');
        if (parentLi && parentLi.parentNode) {
          parentLi.parentNode.insertBefore(li, parentLi.nextSibling);
          lastTocLink = li.querySelector('a'); // So next rabbit hole goes after this one
        }
      }
    });
  });
})();
