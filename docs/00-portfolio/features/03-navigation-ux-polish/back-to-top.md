---
title: "Feature: Back-to-Top Button"
description: "Scroll-aware back-to-top control with reduced-motion support."
sidebar_position: 2
tags: [portfolio, features, navigation, ux]
---

## Purpose

- Feature name: Back-to-top button
- Why this feature exists: Help reviewers navigate long pages without losing context.

## Scope

### In scope

- visibility toggle based on scroll position
- smooth scroll behavior with reduced-motion fallback

### Out of scope

- global navigation links
- theme switching

## Prereqs / Inputs

- client-side JavaScript enabled
- reduced-motion preferences respected by browser

## Procedure / Content

### Feature summary

- Feature name: Back-to-top button
- Feature group: Navigation and UX polish
- Technical summary: Uses an Intersection Observer sentinel and smooth scrolling for return-to-top behavior.
- Low-tech summary: A button appears after scrolling to quickly return to the top.

### Feature in action

- Where to see it working: Any long page such as `/projects`.

### Confirmation Process

#### Manual

- Steps: Scroll down past the fold, click the back-to-top button.
- What to look for: Button appears after scrolling, page scrolls to top, reduced-motion users get instant jump.
- Artifacts or reports to inspect: None.

#### Tests

- Unit tests: None specific.
- E2E tests: [`/portfolio-app/tests/e2e/routes.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/routes.spec.ts) (route coverage only).

### Potential behavior if broken or misconfigured

- Button never appears due to missing sentinel.
- Scroll behavior ignores reduced-motion preferences.

### Long-term maintenance notes

- Re-verify behavior after layout changes that shift scroll length.

### Dependencies, libraries, tools

- Next.js App Router
- React
- Tailwind CSS

### Source code references (GitHub URLs)

- [`/portfolio-app/src/components/BackToTop.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/BackToTop.tsx)

### ADRs

- None.

### Runbooks

- None.

### Additional internal references

- [`/20-engineering/ux-design-system.md`](/docs/20-engineering/ux-design-system.md)

### External reference links

- https://developer.mozilla.org/en-US/docs/Web/API/Intersection_Observer_API

## Validation / Expected outcomes

- Button appears after scrolling and returns the user to the top.

## Failure modes / Troubleshooting

- Button not visible: check sentinel placement and CSS.
- Scroll jumps inconsistently: verify reduced-motion handling.

## References

- None.
