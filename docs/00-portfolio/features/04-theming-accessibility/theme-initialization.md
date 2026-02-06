---
title: 'Feature: Theme Initialization'
description: 'Pre-hydration script to prevent flash of incorrect theme.'
sidebar_position: 2
tags: [portfolio, features, theming, accessibility]
---

## Purpose

- Feature name: Theme initialization
- Why this feature exists: Apply the correct theme before first paint to avoid visual flashes.

## Scope

### In scope

- pre-hydration script in the document head
- applying the `dark` class before render

### Out of scope

- theme toggle UI
- CSS variable definitions

## Prereqs / Inputs

- inline script execution allowed by CSP
- theme toggle state stored in local storage

## Procedure / Content

### Feature summary

- Feature name: Theme initialization
- Feature group: Theming and accessibility
- Technical summary: Inline script reads stored preference or system default and sets the `dark` class before hydration.
- Low-tech summary: Stops the page from flashing the wrong theme on load.

### Feature in action

- Where to see it working: Initial load of any route such as `/`.

### Confirmation Process

#### Manual

- Steps: Set dark mode, refresh, and watch for visual flashes.
- What to look for: No flash of light theme when dark mode is selected.
- Artifacts or reports to inspect: None.

#### Tests

- Unit tests: None specific.
- E2E tests: [`/portfolio-app/tests/e2e/routes.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/routes.spec.ts) (route coverage only).

### Potential behavior if broken or misconfigured

- Flash of incorrect theme on reload.
- CSP blocks inline script execution.

### Long-term maintenance notes

- Re-check when CSP or layout scripts change.

### Dependencies, libraries, tools

- Next.js App Router
- React

### Source code references (GitHub URLs)

- [`/portfolio-app/src/app/layout.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/layout.tsx)

### ADRs

- [`/10-architecture/adr/adr-0014-class-based-dark-mode.md`](/docs/10-architecture/adr/adr-0014-class-based-dark-mode.md)

### Runbooks

- None.

### Additional internal references

- [`/70-reference/theme-system-reference.md`](/docs/70-reference/theme-system-reference.md)

### External reference links

- https://developer.mozilla.org/en-US/docs/Web/API/Window/matchMedia

## Validation / Expected outcomes

- Theme applies before first paint and avoids FOUC.

## Failure modes / Troubleshooting

- Flash persists: check script placement and CSP nonce configuration.

## References

- None.
