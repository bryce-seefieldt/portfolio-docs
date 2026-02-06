---
title: 'Feature: Scroll Reveal Animations'
description: 'Intersection Observer based fade-in transitions for content blocks.'
sidebar_position: 3
tags: [portfolio, features, navigation, ux]
---

## Purpose

- Feature name: Scroll reveal animations
- Why this feature exists: Improve readability and focus by pacing content as the reviewer scrolls.

## Scope

### In scope

- fade-in-on-scroll behavior
- reduced-motion compliance

### Out of scope

- global theme transitions
- page-level navigation structure

## Prereqs / Inputs

- client-side JavaScript enabled
- reduced-motion preference available

## Procedure / Content

### Feature summary

- Feature name: Scroll reveal animations
- Feature group: Navigation and UX polish
- Technical summary: Intersection Observer toggles visibility classes to animate content blocks.
- Low-tech summary: Sections gently fade in as you scroll.

### Feature in action

- Where to see it working: Content sections on `/` and `/projects`.

### Confirmation Process

#### Manual

- Steps: Scroll down a page with multiple sections.
- What to look for: Sections fade in as they enter the viewport and respect reduced-motion preferences.
- Artifacts or reports to inspect: None.

#### Tests

- Unit tests: None specific.
- E2E tests: [`/portfolio-app/tests/e2e/routes.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/routes.spec.ts) (route coverage only).

### Potential behavior if broken or misconfigured

- Animations never trigger due to observer not attaching.
- Reduced-motion users still see transitions.

### Long-term maintenance notes

- Re-check animations after layout or CSS changes.

### Dependencies, libraries, tools

- Next.js App Router
- React
- Tailwind CSS

### Source code references (GitHub URLs)

- [`/portfolio-app/src/components/ScrollFadeIn.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/ScrollFadeIn.tsx)
- [`/portfolio-app/src/app/globals.css`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/globals.css)

### ADRs

- [`/10-architecture/adr/adr-0016-scroll-animations.md`](/docs/10-architecture/adr/adr-0016-scroll-animations.md)

### Runbooks

- None.

### Additional internal references

- [`/20-engineering/ux-design-system.md`](/docs/20-engineering/ux-design-system.md)
- [`/70-reference/theme-system-reference.md`](/docs/70-reference/theme-system-reference.md)

### External reference links

- https://developer.mozilla.org/en-US/docs/Web/API/Intersection_Observer_API

## Validation / Expected outcomes

- Sections fade in on scroll without blocking content access.

## Failure modes / Troubleshooting

- No animation: confirm observer attaches and CSS classes exist.
- Animation jank: verify reduced-motion handling and layout stability.

## References

- None.
