---
title: 'Feature: Hero Contrast and Motion Safety'
description: 'Accessibility and theming constraints applied to the control-panel hero in dark and light modes.'
sidebar_position: 5
tags: [portfolio, features, theming, accessibility, hero]
---

## Purpose

- Feature name: Hero contrast and motion safety
- Why this feature exists: Keep the control-panel hero visually distinctive while maintaining WCAG AA readability and reduced-motion-safe behavior.

## Scope

### In scope

- hero text/background contrast in both themes
- dark-mode phosphor glow usage constraints
- static-safe hero behavior (no required motion)
- accessibility treatment for decorative instrumentation

### Out of scope

- dashboard/live-metrics animations
- non-hero pages

## Prereqs / Inputs

- token variables defined in app global styles
- hero composition implemented in home route
- reduced-motion policies defined in UX Engineering Standards

## Procedure / Content

### Feature summary

- Feature name: Hero contrast and motion safety
- Feature group: Theming and accessibility
- Technical summary: The hero uses token-driven colors and controlled glow so headline/subhead/CTA text remains legible in both dark and light modes; decorative instrumentation is non-essential and does not gate content.
- Low-tech summary: The hero keeps the style without sacrificing readability or accessibility.

### Feature in action

- Where to see it working: Home route `/` in both dark and light mode.

### Confirmation Process

#### Manual

- Steps: Open `/` in dark and light mode, inspect headline/subhead/CTA contrast, test with reduced-motion preference enabled.
- What to look for: Readable copy in both themes; glow is supportive (not blurry); no motion is required to understand hero content.
- Artifacts or reports to inspect: App verification run and visual QA screenshots.

#### Tests

- Unit tests:
  - [`/portfolio-app/src/app/__tests__/page.test.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/__tests__/page.test.tsx)
- E2E tests:
  - [`/portfolio-app/tests/e2e/routes.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/routes.spec.ts)

### Potential behavior if broken or misconfigured

- Glow overwhelms text, reducing readability in dark mode.
- Decorative visuals are interpreted as required state instead of optional ornament.
- Theme variants diverge and one mode loses contrast.

### Long-term maintenance notes

- Re-verify hero contrast whenever token values or glow intensity change.
- Keep decorative elements `aria-hidden` unless they carry essential status meaning.
- Keep reduced-motion handling conservative if hero motion is introduced later.

### Dependencies, libraries, tools

- CSS variables in app global styles
- Tailwind CSS
- Shared hero and primitive components

### Source code references (GitHub URLs)

- [`/portfolio-app/src/app/page.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/page.tsx)
- [`/portfolio-app/src/app/globals.css`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/globals.css)
- [`/portfolio-app/src/components/Readout.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/Readout.tsx)

### ADRs

- [`/10-architecture/adr/adr-0021-visual-identity.md`](/10-architecture/adr/adr-0021-visual-identity.md)

### Runbooks

- None.

### Additional internal references

- [`/20-engineering/ux-engineering-standards.md`](/20-engineering/ux-engineering-standards.md)
- [`/20-engineering/design-system/index.md`](/20-engineering/design-system/index.md)
- [`/70-reference/theme-system-reference.md`](/70-reference/theme-system-reference.md)

### External reference links

- https://www.w3.org/WAI/WCAG21/quickref/
- https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-reduced-motion

## Validation / Expected outcomes

- Hero copy remains readable in both themes while preserving the cassette-futurism look.
- Users with reduced-motion preferences experience equivalent functionality.

## Failure modes / Troubleshooting

- Low legibility in one theme: tune token pairings first, then glow intensity.
- Motion discomfort: disable non-essential transitions and confirm reduced-motion media query behavior.

## References

- None.
