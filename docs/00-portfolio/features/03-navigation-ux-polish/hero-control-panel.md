---
title: 'Feature: Control-Panel Hero'
description: 'Above-the-fold hero layout combining locked pitch copy with a cassette-futurism instrument panel.'
sidebar_position: 5
tags: [portfolio, features, navigation, ux, hero]
---

## Purpose

- Feature name: Control-panel hero
- Why this feature exists: Land the developer pitch in the first screen while demonstrating a distinctive, reviewer-legible UI system.

## Scope

### In scope

- above-the-fold home hero composition on `/`
- hero copy hierarchy (eyebrow, headline, subhead, CTAs)
- control-panel composition using existing primitives (`Panel`, `Readout`, `LabelTag`, `Dial`)
- deploy pipeline strip visual (`COMMIT → CHECKS → STAGING → PRODUCTION`)

### Out of scope

- sections below the hero on `/`
- other routes
- runtime telemetry wiring (future metrics/dashboard work)

## Prereqs / Inputs

- phase 2A and 2A.1 primitives exist in the app
- design tokens and glow utility are available in global styles
- docs base URL is configured for the tertiary docs CTA

## Procedure / Content

### Feature summary

- Feature name: Control-panel hero
- Feature group: Navigation and UX polish
- Technical summary: The home route hero in `/portfolio-app/src/app/page.tsx` composes reusable primitives inside an elevated panel to present locked copy, CTA routing, and an instrument-style deploy pipeline strip.
- Low-tech summary: The top of the home page now looks like a purposeful control panel while keeping the message clear and quick to scan.

### Feature in action

- Where to see it working: Home route `/` (first screen, above the fold).

### Confirmation Process

#### Manual

- Steps: Open `/`, view desktop and mobile widths (~360px), verify CTA links, inspect first-screen hierarchy.
- What to look for: Eyebrow/headline/subhead/CTA order is clear; panel visual supports the copy; pipeline labels are readable; no overflow on mobile.
- Artifacts or reports to inspect: Latest app PR preview + `pnpm verify` summary from app repo.

#### Tests

- Unit tests:
  - [`/portfolio-app/src/app/__tests__/page.test.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/__tests__/page.test.tsx)
- E2E tests:
  - [`/portfolio-app/tests/e2e/routes.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/routes.spec.ts)

### Potential behavior if broken or misconfigured

- Hero copy renders but panel visual collapses or overflows on mobile.
- CTA text exists but links route incorrectly.
- Pipeline strip becomes decorative noise and competes with copy readability.

### Long-term maintenance notes

- Keep hero copy and CTA labels synchronized with product/content decisions.
- Treat panel primitives as shared contracts; avoid one-off hero styling drift.
- Re-check spacing and overflow whenever header or font scale changes.

### Dependencies, libraries, tools

- Next.js App Router
- React
- Tailwind CSS
- Existing design primitives (`Panel`, `Readout`, `LabelTag`, `Dial`)

### Source code references (GitHub URLs)

- [`/portfolio-app/src/app/page.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/page.tsx)
- [`/portfolio-app/src/components/Panel.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/Panel.tsx)
- [`/portfolio-app/src/components/Readout.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/Readout.tsx)
- [`/portfolio-app/src/components/LabelTag.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/LabelTag.tsx)
- [`/portfolio-app/src/components/Dial.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/Dial.tsx)

### ADRs

- [`/10-architecture/adr/adr-0021-visual-identity.md`](/10-architecture/adr/adr-0021-visual-identity.md)

### Runbooks

- None.

### Additional internal references

- [`/20-engineering/design-system/index.md`](/20-engineering/design-system/index.md)
- [`/20-engineering/ux-engineering-standards.md`](/20-engineering/ux-engineering-standards.md)
- [`/70-reference/theme-system-reference.md`](/70-reference/theme-system-reference.md)

### External reference links

- https://nextjs.org/docs/app
- https://tailwindcss.com/docs

## Validation / Expected outcomes

- The first viewport on `/` communicates the pitch clearly and provides immediate reviewer navigation.
- The hero visual language is distinctive but does not reduce readability.
- The implementation remains compatible with existing route/link tests.

## Failure modes / Troubleshooting

- Overflow at small widths: tighten panel grid and CTA wrap classes.
- Hero dominates content: reduce decorative density (labels/readouts) before touching copy.
- CTA mismatch: verify route paths and docs base URL handling.

## References

- None.
