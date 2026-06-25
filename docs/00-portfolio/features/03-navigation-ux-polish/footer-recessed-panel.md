---
title: 'Feature: Footer Recessed Panel'
description: 'Inset control-surface footer with consistent evidence links and responsive accessibility behavior.'
sidebar_position: 6
tags: [portfolio, features, navigation, ux, footer]
---

## Purpose

- Feature name: Footer recessed panel
- Why this feature exists: Present persistent portfolio identity and evidence links in a terminal-style inset surface that matches the control-panel visual language.

## Scope

### In scope

- recessed/inset footer surface treatment
- footer link presentation for GitHub, LinkedIn, and Engineering Docs
- responsive wrapping and readability

### Out of scope

- route-level content changes
- social/link destination changes

## Prereqs / Inputs

- layout shell renders global footer
- control-surface token styles are available in app globals

## Procedure / Content

### Feature summary

- Feature name: Footer recessed panel
- Feature group: Navigation and UX polish
- Technical summary: Footer container in `layout.tsx` uses `footer-inset` and `control-link` classes to render a recessed information plate with stable external evidence links.
- Low-tech summary: The site footer now looks like a recessed machine label panel instead of a plain border strip.

### Feature in action

- Where to see it working: Footer on any route.

### Confirmation Process

#### Manual

- Steps: Open any route in dark and light mode; inspect footer at desktop and mobile widths.
- What to look for: Inset materiality reads clearly, links remain legible and keyboard-focusable, and text wraps cleanly.
- Artifacts or reports to inspect: App verification output and visual QA screenshots.

#### Tests

- Unit tests:
  - `/portfolio-app/src/app/__tests__/layout.test.tsx`
- E2E tests:
  - `/portfolio-app/tests/e2e/routes.spec.ts`

### Potential behavior if broken or misconfigured

- Footer styling regresses to flat strip with low affordance.
- Link contrast drops below readability threshold in one theme.
- Footer link wrapping causes overlap on narrow screens.

### Long-term maintenance notes

- Keep footer links synchronized with configuration helpers.
- Keep inset treatment aligned with control-strip and panel materiality updates.

### Dependencies, libraries, tools

- Next.js App Router
- React
- Tailwind CSS

### Source code references (GitHub URLs)

- `/portfolio-app/src/app/layout.tsx`
- `/portfolio-app/src/app/globals.css`

### Additional internal references

- [/20-engineering/design-system/index.md](/20-engineering/design-system/index.md)
- [/20-engineering/ux-engineering-standards.md](/20-engineering/ux-engineering-standards.md)

## Validation / Expected outcomes

- Footer content remains readable and usable across themes and breakpoints.
- Footer link controls remain visually consistent with the broader control language.

## Failure modes / Troubleshooting

- Low contrast: tune token pairing before changing content.
- Crowded footer on mobile: adjust wrapping and spacing classes in layout.

## References

- None.
