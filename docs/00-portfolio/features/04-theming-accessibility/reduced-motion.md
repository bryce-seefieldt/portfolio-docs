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
- control-button and switch transition reduction
- deploy pipeline LED transition reduction

### Out of scope

- animation definitions (covered in navigation and UX polish)
- theme toggle behavior

## Prereqs / Inputs

- browser support for `prefers-reduced-motion`

## Procedure / Content

### Feature summary

- Feature name: Reduced motion support
- Feature group: Theming and accessibility
- Technical summary: CSS `prefers-reduced-motion` handling removes non-essential transition effects (controls, switch thumb, pipeline transitions) while preserving functional state changes.
- Low-tech summary: Motion-heavy polish is reduced, but controls still work and status changes remain understandable.

### Feature in action

- Where to see it working: Any route with animations, such as `/` or `/projects`.

### Confirmation Process

#### Manual

- Steps: Enable reduced motion in OS settings and reload the page.
- What to look for: Hover/press transitions become immediate, switch movement transition is removed, and deploy pipeline state shifts without glowing transition ramps.
- Artifacts or reports to inspect: None.

#### Tests

- Unit tests: None specific.
- E2E tests: [`/portfolio-app/tests/e2e/routes.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/routes.spec.ts) (route coverage only).

### Potential behavior if broken or misconfigured

- Animations still play for reduced-motion users.
- Transitions do not disable in CSS.
- Pipeline status appears to pulse or flicker instead of changing state discretely.

### Long-term maintenance notes

- Re-test reduced-motion behavior after animation changes.
- Include reduced-motion QA whenever hero sequencing timing is updated.

### Dependencies, libraries, tools

- Tailwind CSS
- React

### Source code references (GitHub URLs)

- [`/portfolio-app/src/app/globals.css`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/globals.css)
- [`/portfolio-app/src/components/ScrollFadeIn.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/ScrollFadeIn.tsx)
- [`/portfolio-app/src/components/DeployPipeline.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/DeployPipeline.tsx)

### ADRs

- [`/10-architecture/adr/adr-0016-scroll-animations.md`](/10-architecture/adr/adr-0016-scroll-animations.md)

### Runbooks

- None.

### Additional internal references

- [`/70-reference/theme-system-reference.md`](/70-reference/theme-system-reference.md)
- [`/20-engineering/ux-engineering-standards.md`](/20-engineering/ux-engineering-standards.md)

### External reference links

- https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-reduced-motion

## Validation / Expected outcomes

- Motion is reduced when users opt in to reduced motion.

## Failure modes / Troubleshooting

- Motion still plays: verify media query and JS checks.

## References

- None.
