---
title: 'Feature: Theme System'
description: 'CSS variable theme system with light/dark tokens and transitions.'
sidebar_position: 3
tags: [portfolio, features, theming, accessibility]
---

## Purpose

- Feature name: Theme system
- Why this feature exists: Provide consistent color tokens and transitions across light and dark modes.

## Scope

### In scope

- CSS variables for light and dark themes
- transition timing and reduced-motion handling
- global color and typography tokens

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
- Technical summary: Defines CSS variables for light/dark themes and smooth transitions.
- Low-tech summary: A shared palette that keeps the site consistent in both modes.

### Feature in action

- Where to see it working: Any route, including `/` and `/cv`.

### Confirmation Process

#### Manual

- Steps: Toggle theme and compare colors across pages.
- What to look for: Consistent color tokens and readable contrast in both modes.
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

### Dependencies, libraries, tools

- Tailwind CSS
- PostCSS

### Source code references (GitHub URLs)

- [`/portfolio-app/src/app/globals.css`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/globals.css)

### ADRs

- [`/10-architecture/adr/adr-0014-class-based-dark-mode.md`](/docs/10-architecture/adr/adr-0014-class-based-dark-mode.md)

### Runbooks

- None.

### Additional internal references

- [`/70-reference/theme-system-reference.md`](/docs/70-reference/theme-system-reference.md)
- [`/20-engineering/ux-design-system.md`](/docs/20-engineering/ux-design-system.md)

### External reference links

- https://tailwindcss.com/docs/theme

## Validation / Expected outcomes

- Theme tokens render consistently across routes.

## Failure modes / Troubleshooting

- Inconsistent colors: verify CSS variable definitions.

## References

- None.
