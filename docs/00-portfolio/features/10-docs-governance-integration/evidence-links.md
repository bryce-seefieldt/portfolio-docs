---
title: 'Feature: Evidence Links'
description: 'Direct links from the app to dossiers, ADRs, and runbooks.'
sidebar_position: 1
tags: [portfolio, features, documentation, evidence]
---

## Purpose

- Feature name: Evidence links
- Why this feature exists: Make documentation artifacts discoverable directly from the app.

## Scope

### In scope

- links to dossier pages
- links to ADR and runbook indexes
- evidence callouts on core pages

### Out of scope

- registry validation logic
- documentation site navigation

## Prereqs / Inputs

- docs base URL configured
- evidence URLs present in registry or page content

## Procedure / Content

### Feature summary

- Feature name: Evidence links
- Feature group: Documentation and governance integration
- Technical summary: Constructs links to `/docs/...` artifacts and surfaces them in the UI.
- Low-tech summary: Buttons and links that take reviewers to the proof.

### Feature in action

- Where to see it working: `/`, `/cv`, and `/projects/[slug]` pages.

### Confirmation Process

#### Manual

- Steps: Click evidence links from core pages and verify they resolve.
- What to look for: Links open the correct docs section without 404s.
- Artifacts or reports to inspect: E2E evidence link checks.

#### Tests

- Unit tests: [`/portfolio-app/src/lib/__tests__/linkConstruction.test.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/__tests__/linkConstruction.test.ts)
- E2E tests: [`/portfolio-app/tests/e2e/evidence-links.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/evidence-links.spec.ts)

### Potential behavior if broken or misconfigured

- Evidence links point to incorrect docs paths.
- Missing docs base URL causes fallback to `/docs`.

### Long-term maintenance notes

- Update evidence URLs when documentation moves.
- Re-validate links after docs restructure.

### Dependencies, libraries, tools

- Next.js App Router
- React

### Source code references (GitHub URLs)

- [`/portfolio-app/src/lib/config.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/config.ts)
- [`/portfolio-app/src/components/EvidenceBlock.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/EvidenceBlock.tsx)
- [`/portfolio-app/src/app/page.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/page.tsx)

### ADRs

- None.

### Runbooks

- None.

### Additional internal references

- [`/70-reference/registry-schema-guide.md`](/docs/70-reference/registry-schema-guide.md)
- [`/70-reference/portfolio-app-config-reference.md`](/docs/70-reference/portfolio-app-config-reference.md)

### External reference links

- https://nextjs.org/docs/app

## Validation / Expected outcomes

- Evidence links resolve to the correct docs pages.

## Failure modes / Troubleshooting

- Broken links: update docs base URL and registry entries.

## References

- None.
