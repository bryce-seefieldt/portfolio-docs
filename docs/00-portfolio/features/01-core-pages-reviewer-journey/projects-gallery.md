---
title: 'Feature: Projects Gallery (/projects)'
description: 'Featured and all-projects gallery backed by the registry.'
sidebar_position: 3
tags: [portfolio, features, core-pages, projects]
---

## Purpose

- Feature name: Projects gallery (`/projects`)
- Why this feature exists: Offer a fast, scannable entry point to project evidence and gold-standard examples.

## Scope

### In scope

- featured project grid with status badges
- full project list from the registry
- quick links to repo/demo when available

### Out of scope

- project detail evidence rendering (covered in project detail feature)
- registry validation logic (covered in evidence-first content model)

## Prereqs / Inputs

- project registry populated and validated
- docs base URL configured for evidence links

## Procedure / Content

### Feature summary

- Feature name: Projects gallery (`/projects`)
- Feature group: Core pages and reviewer journey
- Technical summary: Uses registry data to render featured cards and a complete list, with tag and status metadata.
- Low-tech summary: A project directory that highlights the best entry points and lists everything else.

### Feature in action

- Where to see it working: `/projects` in the deployed app or `http://localhost:3000/projects` during `pnpm dev`.

### Confirmation Process

#### Manual

- Steps: Open `/projects`, click a featured project and a non-featured project.
- What to look for: Status badges render, tags display, detail links resolve.
- Artifacts or reports to inspect: Registry validation in CI and Playwright route coverage.

#### Tests

- Unit tests:
  - [`/portfolio-app/src/lib/__tests__/registry.test.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/__tests__/registry.test.ts)
  - [`/portfolio-app/src/lib/__tests__/registry-functions.test.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/__tests__/registry-functions.test.ts)
- E2E tests: [`/portfolio-app/tests/e2e/routes.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/routes.spec.ts)

### Potential behavior if broken or misconfigured

- Featured list empty because registry tags or status are missing.
- Detail links route to 404 due to invalid slugs.

### Long-term maintenance notes

- Keep featured list aligned with reviewer priorities.
- Maintain tag taxonomy consistency as projects expand.

### Dependencies, libraries, tools

- Next.js App Router
- React
- Tailwind CSS

### Source code references (GitHub URLs)

- [`/portfolio-app/src/app/projects/page.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/projects/page.tsx)
- [`/portfolio-app/src/data/projects.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/data/projects.ts)
- [`/portfolio-app/src/lib/registry.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/registry.ts)

### ADRs

- [`/10-architecture/adr/adr-0011-data-driven-project-registry.md`](/docs/10-architecture/adr/adr-0011-data-driven-project-registry.md)

### Runbooks

- None.

### Additional internal references

- [`/70-reference/registry-schema-guide.md`](/docs/70-reference/registry-schema-guide.md)
- [`/20-engineering/ux-design-system.md`](/docs/20-engineering/ux-design-system.md)

### External reference links

- https://nextjs.org/docs/app
- https://nextjs.org/docs/app/getting-started/layouts-and-pages
- https://tailwindcss.com/docs/installation/framework-guides

## Validation / Expected outcomes

- Featured projects render with correct status and tags.
- All projects list matches the registry source of truth.

## Failure modes / Troubleshooting

- Missing projects: validate the registry data and rebuild.
- Broken slugs: run registry validation and fix duplicates.

## References

- None.
