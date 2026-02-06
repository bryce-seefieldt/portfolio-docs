---
title: 'Feature: Project Registry and Validation'
description: 'Data-driven project registry with schema validation and slug guarantees.'
sidebar_position: 1
tags: [portfolio, features, evidence, registry]
---

## Purpose

- Feature name: Project registry and validation
- Why this feature exists: Keep project metadata consistent, validated, and safe to render across routes.

## Scope

### In scope

- registry schema validation
- slug uniqueness and required fields
- featured and full project lists

### Out of scope

- evidence rendering UI (covered in evidence visualization)
- route layouts and navigation

## Prereqs / Inputs

- project registry data in the portfolio app
- schema validation helpers available in the app

## Procedure / Content

### Feature summary

- Feature name: Project registry and validation
- Feature group: Evidence-first content model
- Technical summary: Validates project records at build and in CI to enforce schema constraints and slug uniqueness.
- Low-tech summary: A single, checked source of truth for projects so pages do not break.

### Feature in action

- Where to see it working: `/projects` and `/projects/[slug]` render from registry data in the deployed app.

### Confirmation Process

#### Manual

- Steps: Open `/projects`, select a project, and confirm the detail page renders expected fields.
- What to look for: No missing title/summary, valid slug routing, and consistent tags/status.
- Artifacts or reports to inspect: CI registry validation output (from `pnpm registry:validate`).

#### Tests

- Unit tests:
  - [`/portfolio-app/src/lib/__tests__/registry.test.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/__tests__/registry.test.ts)
  - [`/portfolio-app/src/lib/__tests__/registry-functions.test.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/__tests__/registry-functions.test.ts)
  - [`/portfolio-app/src/lib/__tests__/registry-cli.test.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/__tests__/registry-cli.test.ts)
  - [`/portfolio-app/src/lib/__tests__/slugHelpers.test.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/__tests__/slugHelpers.test.ts)
- E2E tests: [`/portfolio-app/tests/e2e/routes.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/routes.spec.ts)

### Potential behavior if broken or misconfigured

- Projects list renders empty due to invalid registry data.
- Duplicate slugs cause routing collisions or 404s.

### Long-term maintenance notes

- Keep schema changes versioned and update validation tests.
- Review featured project criteria as the registry expands.

### Dependencies, libraries, tools

- Next.js App Router
- React
- Zod

### Source code references (GitHub URLs)

- [`/portfolio-app/src/lib/registry.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/registry.ts)
- [`/portfolio-app/src/data/projects.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/data/projects.ts)

### ADRs

- [`/10-architecture/adr/adr-0011-data-driven-project-registry.md`](/docs/10-architecture/adr/adr-0011-data-driven-project-registry.md)

### Runbooks

- None.

### Additional internal references

- [`/70-reference/registry-schema-guide.md`](/docs/70-reference/registry-schema-guide.md)
- [`/70-reference/testing-guide.md`](/docs/70-reference/testing-guide.md)

### External reference links

- https://zod.dev/
- https://nextjs.org/docs/app

## Validation / Expected outcomes

- Registry validation passes in CI and locally.
- Project pages render without missing required fields.

## Failure modes / Troubleshooting

- Validation failures: fix schema violations and re-run checks.
- Slug conflicts: update entries and revalidate.

## References

- None.
