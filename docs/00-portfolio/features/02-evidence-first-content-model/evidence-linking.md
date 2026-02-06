---
title: 'Feature: Evidence Link Construction'
description: 'Environment-safe construction of evidence and repository links.'
sidebar_position: 3
tags: [portfolio, features, evidence, links]
---

## Purpose

- Feature name: Evidence link construction
- Why this feature exists: Ensure evidence links resolve correctly across preview, staging, and production environments.

## Scope

### In scope

- docs base URL configuration
- helper functions for docs and GitHub links
- environment-safe link building

### Out of scope

- evidence rendering UI (covered in evidence visualization)
- project registry validation logic

## Prereqs / Inputs

- `NEXT_PUBLIC_DOCS_BASE_URL` configured
- optional `NEXT_PUBLIC_GITHUB_URL` and `NEXT_PUBLIC_DOCS_GITHUB_URL`

## Procedure / Content

### Feature summary

- Feature name: Evidence link construction
- Feature group: Evidence-first content model
- Technical summary: Uses centralized helpers to build docs and repo URLs from public environment variables.
- Low-tech summary: Keeps links consistent no matter which environment is deployed.

### Feature in action

- Where to see it working: Evidence links on `/projects/[slug]` and `/cv` pages.

### Confirmation Process

#### Manual

- Steps: Open a project page and click dossier and ADR links.
- What to look for: Links resolve to the expected docs base URL across environments.
- Artifacts or reports to inspect: Environment variable values and E2E evidence link checks.

#### Tests

- Unit tests:
  - [`/portfolio-app/src/lib/__tests__/config.test.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/__tests__/config.test.ts)
  - [`/portfolio-app/src/lib/__tests__/config-variants.test.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/__tests__/config-variants.test.ts)
  - [`/portfolio-app/src/lib/__tests__/linkConstruction.test.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/__tests__/linkConstruction.test.ts)
- E2E tests: [`/portfolio-app/tests/e2e/evidence-links.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/evidence-links.spec.ts)

### Potential behavior if broken or misconfigured

- Evidence links point to localhost in production.
- Missing docs base URL falls back to `/docs` unexpectedly.

### Long-term maintenance notes

- Keep environment variables documented and validated.
- Re-check link construction when domain strategy changes.

### Dependencies, libraries, tools

- Next.js App Router
- React
- Vercel (environment variables)

### Source code references (GitHub URLs)

- [`/portfolio-app/src/lib/config.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/config.ts)

### ADRs

- None.

### Runbooks

- None.

### Additional internal references

- [`/70-reference/portfolio-app-config-reference.md`](/docs/70-reference/portfolio-app-config-reference.md)
- [`/30-devops-platform/ci-cd-pipeline-overview.md`](/docs/30-devops-platform/ci-cd-pipeline-overview.md)

### External reference links

- https://nextjs.org/docs/app/guides/environment-variables
- https://vercel.com/docs/environment-variables

## Validation / Expected outcomes

- Evidence links resolve correctly in preview, staging, and production.
- Docs base URL changes do not require code changes.

## Failure modes / Troubleshooting

- Incorrect docs host: update environment variables and redeploy.
- Broken link helpers: fix config tests and re-run CI.

## References

- None.
