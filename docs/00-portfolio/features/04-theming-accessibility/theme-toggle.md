---
title: 'Feature: Theme Toggle'
description: 'Class-based light and dark mode switching through a cockpit-style rocker control with persistence.'
sidebar_position: 1
tags: [portfolio, features, theming, accessibility]
---

## Purpose

- Feature name: Theme toggle
- Why this feature exists: Allow reviewers to switch between light and dark themes while preserving accessibility.

## Scope

### In scope

- cockpit-style rocker UI and interaction
- persistence in local storage
- system preference fallback
- keyboard and focus-visible accessibility behavior

### Out of scope

- CSS variable definitions (covered in theme system)
- scroll animations (covered in navigation and UX polish)

## Prereqs / Inputs

- client-side JavaScript enabled
- `prefers-color-scheme` available in browser

## Procedure / Content

### Feature summary

- Feature name: Theme toggle
- Feature group: Theming and accessibility
- Technical summary: A backlit cockpit-style rocker toggles `html.light` and `html.dark` classes, persists state in localStorage, and supports keyboard operation with accessible labeling.
- Low-tech summary: A mode switch in the header flips between dark and light themes and remembers the choice.

### Feature in action

- Where to see it working: Header on any route, such as `/` or `/projects`.

### Confirmation Process

#### Manual

- Steps: Toggle the rocker in the header, refresh, and verify persisted mode.
- What to look for: Switch state and page theme stay aligned; mode persists across reloads; focus ring is visible during keyboard navigation.
- Artifacts or reports to inspect: None.

#### Tests

- Unit tests:
  - [`/portfolio-app/src/components/__tests__/ThemeToggle.test.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/__tests__/ThemeToggle.test.tsx)
- E2E tests: [`/portfolio-app/tests/e2e/routes.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/routes.spec.ts) (route coverage only).

### Potential behavior if broken or misconfigured

- Theme does not persist after reload.
- Theme toggle causes hydration mismatch warnings.
- Rocker visual state drifts from active theme class.

### Long-term maintenance notes

- Re-test after changes to layout or theme initialization scripts.
- Keep rocker labels and semantics aligned with mode names used in UI copy.

### Dependencies, libraries, tools

- Next.js App Router
- React
- Tailwind CSS

### Source code references (GitHub URLs)

- [`/portfolio-app/src/components/ThemeToggle.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/ThemeToggle.tsx)
- [`/portfolio-app/src/app/globals.css`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/globals.css)

### ADRs

- [`/10-architecture/adr/adr-0014-class-based-dark-mode.md`](/10-architecture/adr/adr-0014-class-based-dark-mode.md)

### Runbooks

- None.

### Additional internal references

- [`/70-reference/theme-system-reference.md`](/70-reference/theme-system-reference.md)
- [`/20-engineering/ux-engineering-standards.md`](/20-engineering/ux-engineering-standards.md)

### External reference links

- https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-color-scheme

## Validation / Expected outcomes

- Theme toggle changes appearance immediately and persists across reloads.

## Failure modes / Troubleshooting

- Theme does not persist: verify local storage usage.
- Flash of wrong theme: validate pre-hydration script.

## References

- None.
