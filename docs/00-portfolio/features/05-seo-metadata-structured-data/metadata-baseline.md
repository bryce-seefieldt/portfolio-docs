---
title: 'Feature: Metadata Baseline'
description: 'Global metadata for SEO and social previews.'
sidebar_position: 1
tags: [portfolio, features, seo, metadata]
---

## Purpose

- Feature name: Metadata baseline
- Why this feature exists: Ensure consistent SEO metadata and social previews across the site.

## Scope

### In scope

- global metadata defaults
- Open Graph and Twitter cards
- canonical URLs

### Out of scope

- JSON-LD structured data (covered in structured data feature)
- per-project metadata (covered in project detail pages)

## Prereqs / Inputs

- optional `NEXT_PUBLIC_SITE_URL` for canonical metadata
- Open Graph image available in the public assets

## Procedure / Content

### Feature summary

- Feature name: Metadata baseline
- Feature group: SEO, metadata, and structured data
- Technical summary: Defines site-wide metadata defaults in the root layout for SEO and social sharing.
- Low-tech summary: Gives the site proper titles, descriptions, and preview images.

### Feature in action

- Where to see it working: Any route such as `/` or `/projects`.

### Confirmation Process

#### Manual

- Steps: Open a page, inspect `<head>` metadata, and verify Open Graph and Twitter tags.
- What to look for: Title/description present, canonical URL correct, social image referenced.
- Artifacts or reports to inspect: Browser DevTools or SEO validation tools.

#### Tests

- Unit tests: None specific.
- E2E tests: [`/portfolio-app/tests/e2e/routes.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/routes.spec.ts) (route coverage only).

### Potential behavior if broken or misconfigured

- Missing or incorrect Open Graph tags.
- Canonical URLs point to the wrong host.

### Long-term maintenance notes

- Update descriptions and keywords when the portfolio focus changes.
- Replace social preview image as branding evolves.

### Dependencies, libraries, tools

- Next.js App Router
- React

### Source code references (GitHub URLs)

- [`/portfolio-app/src/app/layout.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/layout.tsx)

### ADRs

- [`/10-architecture/adr/adr-0015-metadata-strategy.md`](/docs/10-architecture/adr/adr-0015-metadata-strategy.md)

### Runbooks

- None.

### Additional internal references

- [`/70-reference/seo-metadata-guide.md`](/docs/70-reference/seo-metadata-guide.md)
- [`/70-reference/social-metadata-guide.md`](/docs/70-reference/social-metadata-guide.md)

### External reference links

- https://nextjs.org/docs/app/building-your-application/optimizing/metadata
- https://ogp.me/
- https://developer.twitter.com/en/docs/twitter-for-websites/cards/overview/abouts-cards

## Validation / Expected outcomes

- Metadata is present on all primary routes.
- Social previews resolve with correct titles and images.

## Failure modes / Troubleshooting

- Missing tags: verify metadata definitions in the root layout.
- Incorrect canonical URL: verify `NEXT_PUBLIC_SITE_URL`.

## References

- None.
