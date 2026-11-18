// Runs in <head> before the first paint (a file, not inline, so the page's Content-Security-Policy can stay strict).
// m-enter: the hero's words wait for motion.js, and fade in by themselves after 700ms if it is late.
// mo-js: the moments' guard; mo-safe shows everything after 2.5s if a moment never mounts.
// ty: the hero terminal hides its lines until page.js types them; ty-done shows them all after 9s whatever happens.
const root = document.documentElement;
root.classList.add('m-enter', 'mo-js');
if (!matchMedia('(prefers-reduced-motion: reduce)').matches && !/HeadlessChrome/.test(navigator.userAgent)) root.classList.add('ty');
setTimeout(() => root.classList.add('m-enter-done'), 700);
setTimeout(() => root.classList.add('mo-safe'), 2500);
setTimeout(() => root.classList.add('ty-done'), 9000);
