---
title: 'Feature: Project Detail Pages (/projects/[slug])'
description: 'Evidence-rich project detail pages with badges and verification checklist.'
sidebar_position: 4
tags: [portfolio, features, core-pages, project-detail]
---

## Purpose

- Feature name: Project detail pages (`/projects/[slug]`)
- Why this feature exists: Provide a single page where reviewers can validate evidence for a specific project.

## Scope

### In scope

- project metadata (title, summary, repo/demo links)
- evidence badges and evidence grid
- verification checklist for gold-standard project(s)

### Out of scope

- global navigation and layout shell
- registry data entry and validation

## Prereqs / Inputs

- project registry populated with valid slugs and evidence URLs
- docs base URL configured for evidence links
- optional `NEXT_PUBLIC_SITE_URL` for canonical metadata

## Procedure / Content

### Feature summary

- Feature name: Project detail pages (`/projects/[slug]`)
- Feature group: Core pages and reviewer journey
- Technical summary: Generates static project pages from registry data with ISR revalidation and evidence components.
- Low-tech summary: A project page that shows the proof and how to verify it.

### Feature in action

- Where to see it working: `/projects/portfolio-app` or any valid slug in the deployed app.

### Confirmation Process

#### Manual

- Steps: Open a project detail page, confirm badges, evidence links, and repo/demo links.
- What to look for: Evidence cards render correctly, links resolve, and invalid slugs return 404.
- Artifacts or reports to inspect: Playwright E2E route coverage and metadata checks in CI.

#### Tests

- Unit tests:
  - [`/portfolio-app/src/lib/__tests__/registry.test.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/__tests__/registry.test.ts)
  - [`/portfolio-app/src/lib/__tests__/slugHelpers.test.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/__tests__/slugHelpers.test.ts)
- E2E tests:
  - [`/portfolio-app/tests/e2e/routes.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/routes.spec.ts)
  - [`/portfolio-app/tests/e2e/evidence-links.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/evidence-links.spec.ts)

### Potential behavior if broken or misconfigured

- Evidence cards render empty due to missing registry fields.
- Metadata uses incorrect canonical URLs.
- Slug routing fails and returns 404 for valid projects.

### Long-term maintenance notes

- Keep evidence URLs synchronized with documentation changes.
- Update gold-standard checklist if governance changes.

### Dependencies, libraries, tools

- Next.js App Router
- React
- Tailwind CSS

### Source code references (GitHub URLs)

- [`/portfolio-app/src/app/projects/[slug]/page.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/projects/%5Bslug%5D/page.tsx)
- [`/portfolio-app/src/components/BadgeGroup.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/BadgeGroup.tsx)
- [`/portfolio-app/src/components/EvidenceBlock.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/EvidenceBlock.tsx)
- [`/portfolio-app/src/data/projects.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/data/projects.ts)
- [`/portfolio-app/src/lib/config.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/config.ts)

### ADRs

- [`/10-architecture/adr/adr-0011-data-driven-project-registry.md`](/docs/10-architecture/adr/adr-0011-data-driven-project-registry.md)

### Runbooks

- None.

### Additional internal references

- [`/70-reference/registry-schema-guide.md`](/docs/70-reference/registry-schema-guide.md)
- [`/70-reference/seo-metadata-guide.md`](/docs/70-reference/seo-metadata-guide.md)
- [`/70-reference/testing-guide.md`](/docs/70-reference/testing-guide.md)

### External reference links

- https://nextjs.org/docs/app
- https://nextjs.org/docs/app/getting-started/layouts-and-pages
- https://tailwindcss.com/docs/installation/framework-guides

## Validation / Expected outcomes

- Valid project slugs render complete evidence blocks.
- Invalid slugs return a 404 page.

## Failure modes / Troubleshooting

- Evidence missing: update registry data and revalidate.
- Incorrect metadata: verify `NEXT_PUBLIC_SITE_URL` and rebuild.

## References

- None.
