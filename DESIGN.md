# Design

Hand-written HTML and one stylesheet (`public/assets/site.css`), no framework. A small script
(`public/assets/site.js`) marks the section in view in the left menu.

## Layout

- From 1024px: two columns. The left panel stays in place (name, role, a one-line pitch, the section
  menu, the Email button and links); the right column scrolls through About, Experience, Projects and Skills.
- Under 1024px: one column, nothing fixed except each section's name, which stays at the top while you read it.
- Experience and projects are entries: a date or kind on the left, the title, two lines and skill tags.
  A project's whole entry is its link; on a mouse, the entry under the pointer lifts and the others dim.

## Colour

Light and dark follow the visitor's system setting.

| Token | Light | Dark | Use |
|---|---|---|---|
| `--bg` | `#fafaf7` | `#0e1217` | Page |
| `--ink` | `#15171a` | `#e8eaed` | Headings |
| `--ink-2` | `#3a3f46` | `#c3c8cf` | Body text |
| `--muted` | `#5f656d` | `#949ca6` | Dates, labels |
| `--accent` | `#1d6b7d` | `#6cbccd` | The button, hover titles, focus |
| `--tag-bg` / `--tag-ink` | `#e2eef0` / `#17596a` | teal at 12% / `#8fd0de` | Skill tags |

## Type

Hanken Grotesk, 400 to 600. Name 40 to 56px, body 16px at 1.65, dates and labels 13px.

## Content

Text only, no images (owner's choice). Every fact comes from the CV
or the apps' own repos; figures (6 developers, 70%, 60%) are the CV's.
