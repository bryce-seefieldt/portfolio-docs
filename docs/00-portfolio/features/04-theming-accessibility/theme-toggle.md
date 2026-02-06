---
title: 'Feature: Theme Toggle'
description: 'Class-based light and dark theme toggle with persistence.'
sidebar_position: 1
tags: [portfolio, features, theming, accessibility]
---

## Purpose

- Feature name: Theme toggle
- Why this feature exists: Allow reviewers to switch between light and dark themes while preserving accessibility.

## Scope

### In scope

- theme toggle UI and interaction
- persistence in local storage
- system preference fallback

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
- Technical summary: Toggles the `dark` class on the root element and persists the setting in local storage.
- Low-tech summary: A button that switches the site between light and dark modes.

### Feature in action

- Where to see it working: Header on any route, such as `/` or `/projects`.

### Confirmation Process

#### Manual

- Steps: Toggle the theme, refresh the page, and verify the preference persists.
- What to look for: Theme changes immediately, persists across reloads, and respects system preference on first load.
- Artifacts or reports to inspect: None.

#### Tests

- Unit tests: None specific.
- E2E tests: [`/portfolio-app/tests/e2e/routes.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/routes.spec.ts) (route coverage only).

### Potential behavior if broken or misconfigured

- Theme does not persist after reload.
- Theme toggle causes hydration mismatch warnings.

### Long-term maintenance notes

- Re-test after changes to layout or theme initialization scripts.

### Dependencies, libraries, tools

- Next.js App Router
- React
- Tailwind CSS

### Source code references (GitHub URLs)

- [`/portfolio-app/src/components/ThemeToggle.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/ThemeToggle.tsx)

### ADRs

- [`/10-architecture/adr/adr-0014-class-based-dark-mode.md`](/docs/10-architecture/adr/adr-0014-class-based-dark-mode.md)

### Runbooks

- None.

### Additional internal references

- [`/70-reference/theme-system-reference.md`](/docs/70-reference/theme-system-reference.md)
- [`/20-engineering/ux-design-system.md`](/docs/20-engineering/ux-design-system.md)

### External reference links

- https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-color-scheme

## Validation / Expected outcomes

- Theme toggle changes appearance immediately and persists across reloads.

## Failure modes / Troubleshooting

- Theme does not persist: verify local storage usage.
- Flash of wrong theme: validate pre-hydration script.

## References

- None.
