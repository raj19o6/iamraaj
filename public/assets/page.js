// iamraaj.in: the page's own motion (the kit's motion.js does the hero entrance and the stat count-up).
// - scroll reveals for headings, rows and facts, a few at a time
// - the closing name rises letter by letter
// - the hero terminal types its commands once, after the headline is in
// Nothing runs under prefers-reduced-motion; with no JavaScript every line simply shows.
const html = document.documentElement;
const reduced = matchMedia('(prefers-reduced-motion: reduce)').matches;
const sleep = ms => new Promise(r => setTimeout(r, ms));

/* ---------------------------------------------------------------- terminal */
async function typeTerminal(body) {
  await sleep(1100);
  for (const p of body.children) {
    if (p.classList.contains('term__cmd') && !p.classList.contains('term__cmd--last')) {
      const text = p.textContent;
      p.textContent = '';
      p.classList.add('is-on');
      for (const ch of text) { p.textContent += ch; await sleep(34 + Math.random() * 46); }
      await sleep(260);
    } else {
      p.classList.add('is-on');
      await sleep(320);
    }
  }
  html.classList.add('ty-done');
}
const termBody = document.querySelector('.term__body');
if (termBody && html.classList.contains('ty') && getComputedStyle(termBody.parentElement).display !== 'none') typeTerminal(termBody);
else html.classList.add('ty-done');

/* ---------------------------------------------------------------- reveals */
if (!reduced && 'IntersectionObserver' in window) {
  // the closing name, one clipped box per letter
  const word = document.querySelector('.close__word');
  if (word) {
    // built with DOM calls, not innerHTML or style="", so the strict Content-Security-Policy allows it
    let i = 0;
    const letters = [...word.textContent];
    word.textContent = '';
    for (const ch of letters) {
      if (ch === ' ') { word.append(' '); continue; }
      const box = document.createElement('span'), inner = document.createElement('span');
      box.className = 'cw'; inner.textContent = ch; inner.style.setProperty('--i', i++);
      box.append(inner); word.append(box);
    }
  }

  const groups = [
    'main > .section:not(.hero) .section-head',
    '.list-head',
    'main > .section:not(.hero) .rows > li',
    '#experience .facts dl > div',
    '#experience .facts > div:not(:has(dl))',
    '.closing__cta .section-head--split > *',
    '.closing__links .grid > *',
  ];
  const targets = [];
  for (const sel of groups) {
    document.querySelectorAll(sel).forEach(el => {
      const sibs = [...el.parentElement.children].filter(c => c.matches(sel));
      el.style.setProperty('--i', Math.min(sibs.indexOf(el), 8));
      el.classList.add('rv');
      targets.push(el);
    });
  }
  if (word) { word.classList.add('rv-word'); targets.push(word); }

  html.classList.add('rv-on');
  const io = new IntersectionObserver(entries => {
    for (const e of entries) if (e.isIntersecting) { e.target.classList.add('rv-in'); io.unobserve(e.target); }
  }, { rootMargin: '0px 0px -8% 0px', threshold: 0.12 });
  targets.forEach(el => io.observe(el));
}
