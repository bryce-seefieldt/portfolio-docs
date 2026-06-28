---
title: 'Feature: Landing Page (/)'
description: 'Landing page with six ordered modules (arc, principles, instrumentation, highlights, work, contact) and control-panel hero framing.'
sidebar_position: 1
tags: [portfolio, features, core-pages, landing]
---

## Purpose

- Feature name: Landing page (`/`)
- Why this feature exists: Provide a fast reviewer entry point that explains how to evaluate the portfolio and links directly to evidence.

## Scope

### In scope

- control-panel hero (module 00) with physical CTAs and deploy instrumentation
- module sequence below hero: 01 Arc, 02 Operating Principles, 03 By the Numbers, 04 Career Highlights, 05 Selected Work, 06 Contact
- panel grammar application: prose on clean background, data in inset panels, interactive cards/controls in raised panels
- home-specific instrumentation components (annunciator panel, clustered bank readouts, era cards)

### Out of scope

- global navigation and footer (covered in Navigation and UX polish)
- theme management (covered in Theming and accessibility)

## Prereqs / Inputs

- `NEXT_PUBLIC_DOCS_BASE_URL` configured for evidence links
- optional `NEXT_PUBLIC_GITHUB_BASE_URL` and `NEXT_PUBLIC_LINKEDIN_URL`

## Procedure / Content

### Feature summary

- Feature name: Landing page (`/`)
- Feature group: Core pages and reviewer journey
- Technical summary: Server-rendered route composing six content modules beneath the hero, with a client-side accessible annunciator (`radiogroup` + `aria-live`) and reusable instrument/card sub-components for narrative and evidence framing.
- Low-tech summary: The page tells a clear story first, then shows proof through interactive principles, numbers, highlights, and inspectable work links.

### Feature in action

- Where to see it working: `/` in the deployed app or `http://localhost:3000/` during `pnpm dev`.

### Confirmation Process

#### Manual

- Steps: Open `/`, review modules in order, toggle one principle tile, and verify contact/work controls.
- What to look for: All six module labels appear; Module 02 keyboard interaction works (arrow keys on tiles); Module 03 stats are readable text even without motion; Module 04 era cards stack cleanly on mobile.
- Artifacts or reports to inspect: Optional Playwright E2E runs in CI showing core route coverage.

#### Tests

- Unit tests: [`/portfolio-app/src/lib/__tests__/config.test.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/__tests__/config.test.ts)
- Unit tests: [`/portfolio-app/src/app/__tests__/page.test.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/__tests__/page.test.tsx)
- Unit tests: [`/portfolio-app/src/components/__tests__/OperatingPrinciplesPanel.test.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/__tests__/OperatingPrinciplesPanel.test.tsx)
- E2E tests:
  - [`/portfolio-app/tests/e2e/routes.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/routes.spec.ts)
  - [`/portfolio-app/tests/e2e/smoke.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/smoke.spec.ts)

### Potential behavior if broken or misconfigured

- Module order drifts from the intended narrative flow.
- Annunciator interaction loses keyboard semantics or live-region updates.
- Instrument labels display decoratively but lose readable text values.

### Long-term maintenance notes

- Preserve the module ordering and panel grammar; avoid collapsing back into generic card stacks.
- Keep Module 03 figures aligned with canonical bio docs (no age metrics).
- Keep home instrumentation components reusable and documented in the design-system source map.

### Dependencies, libraries, tools

- Next.js App Router
- React
- Tailwind CSS

### Source code references (GitHub URLs)

- [`/portfolio-app/src/app/page.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/page.tsx)
- [`/portfolio-app/src/components/home/OperatingPrinciplesPanel.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/home/OperatingPrinciplesPanel.tsx)
- [`/portfolio-app/src/components/home/ByTheNumbersCluster.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/home/ByTheNumbersCluster.tsx)
- [`/portfolio-app/src/components/home/CareerEraCards.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/home/CareerEraCards.tsx)
- [`/portfolio-app/src/components/ScrollFadeIn.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/ScrollFadeIn.tsx)
- [`/portfolio-app/src/lib/config.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/config.ts)

### ADRs

- None.

### Runbooks

- None.

### Additional internal references

- [`/20-engineering/ux-engineering-standards.md`](/20-engineering/ux-engineering-standards.md)
- [`/70-reference/portfolio-app-config-reference.md`](/70-reference/portfolio-app-config-reference.md)

### External reference links

- https://nextjs.org/docs/app
- https://nextjs.org/docs/app/getting-started/layouts-and-pages
- https://tailwindcss.com/docs/installation/framework-guides

## Validation / Expected outcomes

- Reviewers can understand the narrative-to-proof flow without leaving `/`.
- Module 02, 03, and 04 present principles, quantified evidence, and highlights without sacrificing readability.

## Failure modes / Troubleshooting

- Docs links broken: verify `NEXT_PUBLIC_DOCS_BASE_URL` and redeploy.
- Empty featured cards: verify project registry content and rebuild.

## References

- None.
