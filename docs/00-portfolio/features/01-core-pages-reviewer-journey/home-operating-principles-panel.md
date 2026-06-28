---
title: 'Feature: Home Operating Principles Panel'
description: 'Module 02 annunciator panel with radio semantics and aria-live CRT detail.'
sidebar_position: 7
tags: [portfolio, features, core-pages, accessibility, home]
---

## Purpose

- Feature name: Home operating principles panel (Module 02)
- Why this feature exists: Present seven working principles as interactive proof while preserving full keyboard and screen-reader access.

## Scope

### In scope

- annunciator tile controls (`role="radiogroup"`, `role="radio"`, `aria-checked`)
- keyboard interaction (arrow keys, Home/End, Enter/Space)
- CRT detail region updates with `aria-live="polite"`

### Out of scope

- global theme switching
- site-wide animation system

## Procedure / Content

### Feature summary

- Technical summary: Client component with deterministic in-DOM principle content and radio-style selection state.
- Low-tech summary: Click or arrow through seven principles; the detail screen updates immediately.

### Confirmation Process

#### Manual

- Steps: Open `/`, tab to Module 02, use arrow keys across tiles, activate with Enter.
- What to look for: Selected tile lights, non-selected tiles dim, and detail text updates without page navigation.

#### Tests

- Unit tests: [`/portfolio-app/src/components/__tests__/OperatingPrinciplesPanel.test.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/__tests__/OperatingPrinciplesPanel.test.tsx)

### Source code references (GitHub URLs)

- [`/portfolio-app/src/components/home/OperatingPrinciplesPanel.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/home/OperatingPrinciplesPanel.tsx)
- [`/portfolio-app/src/app/globals.css`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/globals.css)
- [`/portfolio-app/src/app/page.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/page.tsx)

## References

- [`/20-engineering/design-system/index.md`](/20-engineering/design-system/index.md)
