---
title: 'Feature: ISR and Caching'
description: 'Incremental static regeneration and cache-control behavior.'
sidebar_position: 1
tags: [portfolio, features, performance, caching]
---

## Purpose

- Feature name: ISR and caching
- Why this feature exists: Keep project pages fast and fresh without full rebuilds.

## Scope

### In scope

- ISR revalidation for project detail pages
- cache-control headers for static routes

### Out of scope

- bundle size monitoring
- analytics and observability dashboards

## Prereqs / Inputs

- project registry provides static params
- cache headers configured in deployment

## Procedure / Content

### Feature summary

- Feature name: ISR and caching
- Feature group: Performance and observability
- Technical summary: Uses `revalidate` on project detail pages and cache-control for static routes.
- Low-tech summary: Pages load fast and update regularly without a full rebuild.

### Feature in action

- Where to see it working: `/projects/[slug]` pages and cache headers on `/`.

### Confirmation Process

#### Manual

- Steps: Load a project page, inspect response headers for cache-control.
- What to look for: `max-age` and `stale-while-revalidate` values set.
- Artifacts or reports to inspect: Browser DevTools or `curl -I` output.

#### Tests

- Unit tests: None specific.
- E2E tests: [`/portfolio-app/tests/e2e/routes.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/routes.spec.ts) (route coverage only).

### Potential behavior if broken or misconfigured

- ISR disabled causing stale content.
- Cache headers missing or inconsistent.

### Long-term maintenance notes

- Revisit cache strategy after content volume changes.

### Dependencies, libraries, tools

- Next.js App Router
- Vercel caching

### Source code references (GitHub URLs)

- [`/portfolio-app/src/app/projects/[slug]/page.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/projects/%5Bslug%5D/page.tsx)

### ADRs

- None.

### Runbooks

- [`/50-operations/runbooks/rbk-portfolio-performance-optimization.md`](/docs/50-operations/runbooks/rbk-portfolio-performance-optimization.md)

### Additional internal references

- [`/70-reference/performance-optimization-guide.md`](/docs/70-reference/performance-optimization-guide.md)

### External reference links

- https://nextjs.org/docs/app/building-your-application/data-fetching/incremental-static-regeneration

## Validation / Expected outcomes

- Project detail pages revalidate without full rebuilds.
- Cache headers align with documented strategy.

## Failure modes / Troubleshooting

- No revalidation: verify ISR configuration and build logs.

## References

- None.
