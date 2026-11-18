// Marks the section in view in the left menu (wide screens only show it).
const links = [...document.querySelectorAll('.toc a')];
const sections = links.map(a => document.querySelector(a.getAttribute('href'))).filter(Boolean);

if (links.length && 'IntersectionObserver' in window) {
  const mark = id => links.forEach(a => a.setAttribute('aria-current', String(a.getAttribute('href') === `#${id}`)));
  const io = new IntersectionObserver(entries => {
    const visible = entries.filter(e => e.isIntersecting).sort((a, b) => a.boundingClientRect.top - b.boundingClientRect.top);
    if (visible[0]) mark(visible[0].target.id);
  }, { rootMargin: '-35% 0px -55% 0px' });
  sections.forEach(s => io.observe(s));
  mark(sections[0].id);
}
