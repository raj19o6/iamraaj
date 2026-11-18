# Design

Built with the design-taste-frontend skill (tasteskill 2.5) on its kit (`public/assets/system.css`, `system.js`,
`motion/`, `layout/layout.css`), copied in unchanged. The page's own CSS and JavaScript live in
`public/assets/page.css` and `page.js` (files, not inline, so the Content-Security-Policy stays strict).

**Light theme only**, by the owner's choice: no dark mode (`<meta name="color-scheme" content="light">`).
Text only, no images.

**Kind:** service (a person who is hired). **Deal:** hero `statement` (text only), nav `nav-centre`, close `close-word` (dealt
`close-photo`; there is no photograph of the client), footer `footer-columns`, rhythm `surface-pairs` (Experience and
Skills on `.ground-surface`), buttons `arrow`, mark `initial`, no moment (it needs pictures).

## Colour (palette `putty-black-teal`)

| Token | Value | Use |
|---|---|---|
| `--p-bg` | `#dedad3` | Page ground (warm putty) |
| `--p-surface` | `#d3cec6` | The surface band (Services, Stack) |
| `--p-ink` | `#0a0a0a` | All text and lines |
| `--p-muted` | `#5c5852` | Labels, a heading's grey half |
| `--p-accent` / `--p-action` | `#256f82` | The one button, links, focus ring, the R mark |

The interface stays neutral: one teal accent for the button, links and focus.

## Type

Hanken Grotesk for display and text, weight 400 for headings with -0.03em tracking (-0.038em at the largest sizes).

## Pictures

None, by the client's choice: the page is data, content and links. Live demos and client projects link to their sites.

## Motion

- The hero enters once on load (kit), then the terminal card on the right rises in and types its commands
  (`whoami`, `cat now.txt`, `cat stack.txt`, `ls live-demos/`); wide screens only (1100px and up).
- Headings, rows and facts rise in as they scroll into view, a row at a time; the closing name rises letter by letter.
- The two stats count up (kit, `data-m-count`); a thin teal line along the top shows reading progress.
- Rows answer the pointer: a teal line draws in beside the row and its name takes the accent.
- Everything rests under reduced motion; with no JavaScript every line simply shows.
