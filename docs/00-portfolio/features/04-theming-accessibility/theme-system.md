---
title: 'Feature: Theme System'
description: 'CSS variable theme system with locked Phase 2C palettes and four type registers.'
sidebar_position: 3
tags: [portfolio, features, theming, accessibility]
---

## Purpose

- Feature name: Theme system
- Why this feature exists: Provide consistent color tokens and transitions across light and dark modes.

## Scope

### In scope

- CSS variables for locked light and dark palettes
- transition timing and reduced-motion handling
- global color and typography tokens including Departure Mono accent register

### Out of scope

- theme toggle UI
- navigation components

## Prereqs / Inputs

- Tailwind CSS configured
- global CSS loaded in the app

## Procedure / Content

### Feature summary

- Feature name: Theme system
- Feature group: Theming and accessibility
- Technical summary: Defines locked Phase 2C tokens in `globals.css` (`:root` dark default, `html.light` alternate) and binds four type registers through `next/font` variables in `layout.tsx`.
- Low-tech summary: Light mode is warm beige hardware powered down; dark mode is the same hardware powered on with phosphor accents.

### Feature in action

- Where to see it working: Any route, including `/` and `/cv`.

### Confirmation Process

#### Manual

- Steps: Toggle theme and compare hero/nav/footer plus home modules under both themes.
- What to look for: Warm-cream text remains readable in dark mode, burnt-orange accent remains readable in light mode, and Departure Mono appears only in accent/readout contexts.
- Artifacts or reports to inspect: None.

#### Tests

- Unit tests: None specific.
- E2E tests: [`/portfolio-app/tests/e2e/routes.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/routes.spec.ts) (route coverage only).

### Potential behavior if broken or misconfigured

- Colors render with low contrast.
- Transitions appear jarring or inconsistent.

### Long-term maintenance notes

- Re-evaluate contrast after palette updates.
- Keep tokens aligned with the design system reference.
- Keep Departure Mono usage sparse (labels/counters/display accents only).

### Dependencies, libraries, tools

- Tailwind CSS
- PostCSS

### Source code references (GitHub URLs)

- [`/portfolio-app/src/app/globals.css`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/globals.css)
- [`/portfolio-app/src/app/layout.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/layout.tsx)
- [`/portfolio-app/src/app/design-tokens-preview/page.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/design-tokens-preview/page.tsx)

### ADRs

- [`/10-architecture/adr/adr-0014-class-based-dark-mode.md`](/10-architecture/adr/adr-0014-class-based-dark-mode.md)

### Runbooks

- None.

### Additional internal references

- [`/70-reference/theme-system-reference.md`](/70-reference/theme-system-reference.md)
- [`/20-engineering/ux-engineering-standards.md`](/20-engineering/ux-engineering-standards.md)

### External reference links

- https://tailwindcss.com/docs/theme

## Validation / Expected outcomes

- Theme tokens render consistently across routes and maintain AA contrast in both themes.

## Failure modes / Troubleshooting

- Inconsistent colors: verify CSS variable definitions.

## References

- None.
