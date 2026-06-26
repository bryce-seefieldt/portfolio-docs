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
- control-panel composition using primitives (`Panel`, `Readout`, `LabelTag`, `Dial`, `DeployPipeline`)
- physical CTA controls (`WORK`, `CV`, `DOCS`) mapped to unchanged destinations
- deploy pipeline sequence behavior and stage status readability

### Out of scope

- sections below the hero on `/`
- other routes
- runtime telemetry wiring (future metrics/dashboard work)

## Prereqs / Inputs

- phase 2A and 2A.1 primitives exist in the app
- design tokens and glow utility are available in global styles
- docs base URL is configured for the DOCS control destination

## Procedure / Content

### Feature summary

- Feature name: Control-panel hero
- Feature group: Navigation and UX polish
- Technical summary: The home hero keeps headline and paragraph on clean background while the right-side panel hosts instrumentation, compacted readouts, location labeling, physical CTA controls, and a staged deploy sequence component.
- Low-tech summary: The first screen balances person-first messaging with machine-style proof controls.

### Feature in action

- Where to see it working: Home route `/` (first screen, above the fold).

### Confirmation Process

#### Manual

- Steps: Open `/`, test desktop/tablet/~360px, verify WORK/CV/DOCS routes, observe deploy LEDs from initial load through final state.
- What to look for: Readouts do not overlap, copy remains on clean background, location appears on panel, and pipeline timing is one-time staged progression.
- Artifacts or reports to inspect: Latest app PR preview + `pnpm verify` summary from app repo.

#### Tests

- Unit tests:
  - [`/portfolio-app/src/app/__tests__/page.test.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/__tests__/page.test.tsx)
- - [`/portfolio-app/src/components/__tests__/NavigationEnhanced.test.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/__tests__/NavigationEnhanced.test.tsx)
- E2E tests:
  - [`/portfolio-app/tests/e2e/routes.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/routes.spec.ts)

### Potential behavior if broken or misconfigured

- Hero copy renders but panel visual collapses or overflows on mobile.
- CTA text exists but links route incorrectly.
- Pipeline strip timing drifts (for example, all LEDs syncing or final state not holding on PRODUCTION).

### Long-term maintenance notes

- Keep hero copy and CTA labels synchronized with product/content decisions.
- Treat panel primitives as shared contracts; avoid one-off hero styling drift.
- Re-check readout spacing and overflow whenever typography or panel grid changes.
- Post-spec timing language is authoritative for current behavior: one-time sequence, 1 second per stage, earlier LEDs switch off as the next stage lights, and PRODUCTION holds at the end.

### Dependencies, libraries, tools

- Next.js App Router
- React
- Tailwind CSS
- Existing design primitives (`Panel`, `Readout`, `LabelTag`, `Dial`)
- Deploy pipeline primitive (`DeployPipeline`)
- Control button primitive (`ControlButton`)

### Source code references (GitHub URLs)

- [`/portfolio-app/src/app/page.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/page.tsx)
- [`/portfolio-app/src/components/Panel.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/Panel.tsx)
- [`/portfolio-app/src/components/Readout.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/Readout.tsx)
- [`/portfolio-app/src/components/LabelTag.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/LabelTag.tsx)
- [`/portfolio-app/src/components/Dial.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/Dial.tsx)
- [`/portfolio-app/src/components/DeployPipeline.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/DeployPipeline.tsx)
- [`/portfolio-app/src/components/ControlButton.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/ControlButton.tsx)

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
- Deploy stages advance once per load in left-to-right order and finish with only PRODUCTION active.

## Failure modes / Troubleshooting

- Overflow at small widths: tighten panel grid and CTA wrap classes.
- Hero dominates content: reduce decorative density (labels/readouts) before touching copy.
- CTA mismatch: verify route paths and docs base URL handling.
- Pipeline mismatch: verify `DeployPipeline.tsx` timer logic and `pipeline-led--active` class behavior.

## References

- None.
