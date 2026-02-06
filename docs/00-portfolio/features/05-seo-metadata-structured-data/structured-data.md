---
title: 'Feature: Structured Data (JSON-LD)'
description: 'Schema.org Person and Website structured data for search engines.'
sidebar_position: 2
tags: [portfolio, features, seo, structured-data]
---

## Purpose

- Feature name: Structured data (JSON-LD)
- Why this feature exists: Provide search engines with explicit, machine-readable context about the site and author.

## Scope

### In scope

- Person schema
- Website schema
- JSON-LD script injection

### Out of scope

- Open Graph and Twitter metadata
- per-project metadata overrides

## Prereqs / Inputs

- site URL configured for structured data output

## Procedure / Content

### Feature summary

- Feature name: Structured data (JSON-LD)
- Feature group: SEO, metadata, and structured data
- Technical summary: Generates JSON-LD for Person and Website schema definitions and injects them in the document head.
- Low-tech summary: Helps search engines understand who the site is about and what it represents.

### Feature in action

- Where to see it working: Any route, inspect the JSON-LD scripts in the page head.

### Confirmation Process

#### Manual

- Steps: Open a page and inspect JSON-LD scripts in DevTools.
- What to look for: Valid JSON-LD with expected schema types.
- Artifacts or reports to inspect: Schema validation tools.

#### Tests

- Unit tests: [`/portfolio-app/src/lib/__tests__/structured-data.test.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/__tests__/structured-data.test.ts)
- E2E tests: None specific.

### Potential behavior if broken or misconfigured

- JSON-LD scripts missing or invalid.
- Incorrect schema properties or URLs.

### Long-term maintenance notes

- Update schema values if site identity changes.
- Revalidate structured data when metadata strategy changes.

### Dependencies, libraries, tools

- Next.js App Router
- React

### Source code references (GitHub URLs)

- [`/portfolio-app/src/lib/structured-data.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/structured-data.ts)
- [`/portfolio-app/src/app/layout.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/layout.tsx)

### ADRs

- [`/10-architecture/adr/adr-0015-metadata-strategy.md`](/docs/10-architecture/adr/adr-0015-metadata-strategy.md)

### Runbooks

- None.

### Additional internal references

- [`/70-reference/seo-metadata-guide.md`](/docs/70-reference/seo-metadata-guide.md)
- [`/70-reference/social-metadata-guide.md`](/docs/70-reference/social-metadata-guide.md)

### External reference links

- https://schema.org/
- https://developers.google.com/search/docs/appearance/structured-data/intro-structured-data

## Validation / Expected outcomes

- Structured data scripts are present and valid.

## Failure modes / Troubleshooting

- Invalid JSON-LD: validate schema output and update tests.

## References

- None.
