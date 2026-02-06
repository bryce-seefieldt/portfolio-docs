---
title: 'Feature: CV Page (/cv)'
description: 'Evidence-first CV timeline with proof links and reviewer guidance.'
sidebar_position: 2
tags: [portfolio, features, core-pages, cv]
---

## Purpose

- Feature name: CV page (`/cv`)
- Why this feature exists: Present an evidence-first CV that connects experience to verifiable artifacts.

## Scope

### In scope

- timeline entries with role summaries
- proof links to dossiers, ADRs, runbooks, and threat models
- reviewer guidance callouts

### Out of scope

- projects registry management (covered in evidence-first content model)
- global navigation and theming

## Prereqs / Inputs

- CV data source populated (timeline entries and proofs)
- docs base URL configured

## Procedure / Content

### Feature summary

- Feature name: CV page (`/cv`)
- Feature group: Core pages and reviewer journey
- Technical summary: Renders timeline data into sections, with proof links built from configured docs URLs.
- Low-tech summary: A resume page that links each claim to evidence.

### Feature in action

- Where to see it working: `/cv` in the deployed app or `http://localhost:3000/cv` during `pnpm dev`.

### Confirmation Process

#### Manual

- Steps: Open `/cv`, scan timeline entries, click at least two proof links.
- What to look for: Evidence links resolve correctly and match the described capability.
- Artifacts or reports to inspect: Optional E2E route coverage in CI.

#### Tests

- Unit tests: [`/portfolio-app/src/lib/__tests__/linkConstruction.test.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/__tests__/linkConstruction.test.ts)
- E2E tests: [`/portfolio-app/tests/e2e/routes.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/routes.spec.ts)

### Potential behavior if broken or misconfigured

- Proof links route to incorrect docs sections.
- Timeline entries are missing or render out of order.

### Long-term maintenance notes

- Keep proof links current as documentation moves.
- Update timeline entries as experience changes to avoid stale claims.

### Dependencies, libraries, tools

- Next.js App Router
- React
- Tailwind CSS

### Source code references (GitHub URLs)

- [`/portfolio-app/src/app/cv/page.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/cv/page.tsx)
- [`/portfolio-app/src/data/cv.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/data/cv.ts)
- [`/portfolio-app/src/lib/config.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/config.ts)

### ADRs

- None.

### Runbooks

- None.

### Additional internal references

- [`/20-engineering/ux-design-system.md`](/docs/20-engineering/ux-design-system.md)
- [`/70-reference/evidence-audit-checklist.md`](/docs/70-reference/evidence-audit-checklist.md)

### External reference links

- https://nextjs.org/docs/app
- https://nextjs.org/docs/app/building-your-application/routing
- https://tailwindcss.com/docs

## Validation / Expected outcomes

- CV timeline renders without missing sections.
- Evidence links are functional and relevant to each capability.

## Failure modes / Troubleshooting

- Broken evidence links: update proof URLs in the CV data source.
- Missing timeline entries: validate data export and rebuild.

## References

- None.
