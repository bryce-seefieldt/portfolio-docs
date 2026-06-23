---
title: 'Feature: CV Page (/cv)'
description: 'Traditional, scannable CV focused on experience, education, and technical skills.'
sidebar_position: 2
tags: [portfolio, features, core-pages, cv]
---

## Purpose

- Feature name: CV page (`/cv`)
- Why this feature exists: Present a clean, traditional CV that hiring managers can scan quickly.

## Scope

### In scope

- experience entries with role summaries and quantified outcomes
- education history and technical skill categories
- direct contact links and downloadable resume action

### Out of scope

- project dossier deep-dive content (owned by `/projects` and docs pages)
- global navigation and theming

## Prereqs / Inputs

- canonical CV content maintained and current
- profile links configured in public env vars

## Procedure / Content

### Feature summary

- Feature name: CV page (`/cv`)
- Feature group: Core pages and reviewer journey
- Technical summary: Renders semantic CV sections (header, summary, experience, education, skills, references) in a single page component.
- Low-tech summary: A straightforward resume page with accurate work history and contact information.

### Feature in action

- Where to see it working: `/cv` in the deployed app or `http://localhost:3000/cv` during `pnpm dev`.

### Confirmation Process

#### Manual

- Steps: Open `/cv`, confirm section order (summary, experience, education, skills), verify role titles/dates and key quantified outcomes.
- What to look for: No evidence-hub callouts, no capability-tag walls, and no inflated role titles.
- Artifacts or reports to inspect: Route smoke tests and unit tests for CV content structure.

#### Tests

- Unit tests: [`/portfolio-app/src/lib/__tests__/linkConstruction.test.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/__tests__/linkConstruction.test.ts)
- E2E tests: [`/portfolio-app/tests/e2e/routes.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/routes.spec.ts)

### Potential behavior if broken or misconfigured

- Experience entries missing or rendered out of order.
- Resume download link points to a missing PDF asset.

### Long-term maintenance notes

- Keep CV content synchronized with the canonical resume source.
- When adding a new role or credential, preserve reverse-chronological ordering.

### Dependencies, libraries, tools

- Next.js App Router
- React
- Tailwind CSS

### Source code references (GitHub URLs)

- [`/portfolio-app/src/app/cv/page.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/cv/page.tsx)
- [`/portfolio-app/src/lib/config.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/config.ts)

### ADRs

- None.

### Runbooks

- None.

### Additional internal references

- [`/20-engineering/ux-design-system.md`](/20-engineering/ux-design-system.md)
- [`/70-reference/evidence-audit-checklist.md`](/70-reference/evidence-audit-checklist.md)

### External reference links

- https://nextjs.org/docs/app
- https://nextjs.org/docs/app/building-your-application/routing
- https://tailwindcss.com/docs

## Validation / Expected outcomes

- CV renders with expected semantic section hierarchy and complete role history.
- Quantified outcomes and contact links are visible and accurate.

## Failure modes / Troubleshooting

- Missing PDF link target: add `bryce-seefieldt-cv.pdf` to `/public`.
- Incorrect or stale experience details: update CV source content and sync page text.

## References

- None.
