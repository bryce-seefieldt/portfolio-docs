---
title: 'Feature: Reduced Motion Support'
description: 'Respects user motion preferences across animations and transitions.'
sidebar_position: 4
tags: [portfolio, features, theming, accessibility]
---

## Purpose

- Feature name: Reduced motion support
- Why this feature exists: Respect user accessibility preferences and reduce motion for sensitive users.

## Scope

### In scope

- reduced-motion media query handling
- disabling non-essential transitions and animations

### Out of scope

- animation definitions (covered in navigation and UX polish)
- theme toggle behavior

## Prereqs / Inputs

- browser support for `prefers-reduced-motion`

## Procedure / Content

### Feature summary

- Feature name: Reduced motion support
- Feature group: Theming and accessibility
- Technical summary: Uses CSS and JS checks to reduce or disable animations when users prefer reduced motion.
- Low-tech summary: The site reduces animations when the user requests it.

### Feature in action

- Where to see it working: Any route with animations, such as `/` or `/projects`.

### Confirmation Process

#### Manual

- Steps: Enable reduced motion in OS settings and reload the page.
- What to look for: Animations are minimized or disabled.
- Artifacts or reports to inspect: None.

#### Tests

- Unit tests: None specific.
- E2E tests: [`/portfolio-app/tests/e2e/routes.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/routes.spec.ts) (route coverage only).

### Potential behavior if broken or misconfigured

- Animations still play for reduced-motion users.
- Transitions do not disable in CSS.

### Long-term maintenance notes

- Re-test reduced-motion behavior after animation changes.

### Dependencies, libraries, tools

- Tailwind CSS
- React

### Source code references (GitHub URLs)

- [`/portfolio-app/src/app/globals.css`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/globals.css)
- [`/portfolio-app/src/components/ScrollFadeIn.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/ScrollFadeIn.tsx)

### ADRs

- [`/10-architecture/adr/adr-0016-scroll-animations.md`](/docs/10-architecture/adr/adr-0016-scroll-animations.md)

### Runbooks

- None.

### Additional internal references

- [`/70-reference/theme-system-reference.md`](/docs/70-reference/theme-system-reference.md)
- [`/20-engineering/ux-design-system.md`](/docs/20-engineering/ux-design-system.md)

### External reference links

- https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-reduced-motion

## Validation / Expected outcomes

- Motion is reduced when users opt in to reduced motion.

## Failure modes / Troubleshooting

- Motion still plays: verify media query and JS checks.

## References

- None.
