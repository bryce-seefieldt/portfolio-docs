---
title: 'Feature: Landing Page (/)'
description: 'Landing page with evaluation path, evidence callouts, and key entry points.'
sidebar_position: 1
tags: [portfolio, features, core-pages, landing]
---

## Purpose

- Feature name: Landing page (`/`)
- Why this feature exists: Provide a fast reviewer entry point that explains how to evaluate the portfolio and links directly to evidence.

## Scope

### In scope

- hero narrative and value proposition
- reviewer evaluation path callout
- primary calls to action (CTAs)
  - e.g. CV, Projects, Evidence Docs
- featured work highlights

### Out of scope

- global navigation and footer (covered in Navigation and UX polish)
- theme management (covered in Theming and accessibility)

## Prereqs / Inputs

- `NEXT_PUBLIC_DOCS_BASE_URL` configured for evidence links
- optional `NEXT_PUBLIC_GITHUB_URL` and `NEXT_PUBLIC_LINKEDIN_URL`

## Procedure / Content

### Feature summary

- Feature name: Landing page (`/`)
- Feature group: Core pages and reviewer journey
- Technical summary: Server-rendered Next.js route that composes CTA buttons, evidence callouts, and featured project cards using shared layout components.
- Low-tech summary: The home page tells reviewers what to look at first and gives quick links to proof.

### Feature in action

- Where to see it working: `/` in the deployed app or `http://localhost:3000/` during `pnpm dev`.

### Confirmation Process

#### Manual

- Steps: Open `/`, click “Start with the CV,” “Browse projects,” and “Open evidence docs.”
- What to look for: CTA links resolve correctly, evidence callout lists a clear review path, featured cards show dossier links.
- Artifacts or reports to inspect: Optional Playwright E2E runs in CI showing core route coverage.

#### Tests

- Unit tests: [`/portfolio-app/src/lib/__tests__/config.test.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/__tests__/config.test.ts)
- E2E tests:
  - [`/portfolio-app/tests/e2e/routes.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/routes.spec.ts)
  - [`/portfolio-app/tests/e2e/smoke.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/smoke.spec.ts)

### Potential behavior if broken or misconfigured

- Evidence links route to the wrong docs base URL.
- CTAs are missing or point to invalid routes.
- Featured work section shows empty or stale content.

### Long-term maintenance notes

- Keep the evaluation path aligned with the reviewer guide and evidence structure.
- Update featured work as projects change or new gold-standard entries exist.

### Dependencies, libraries, tools

- Next.js App Router
- React
- Tailwind CSS

### Source code references (GitHub URLs)

- [`/portfolio-app/src/app/page.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/page.tsx)
- [`/portfolio-app/src/components/Callout.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/Callout.tsx)
- [`/portfolio-app/src/components/Section.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/Section.tsx)
- [`/portfolio-app/src/components/ScrollFadeIn.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/ScrollFadeIn.tsx)
- [`/portfolio-app/src/lib/config.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/config.ts)

### ADRs

- None.

### Runbooks

- None.

### Additional internal references

- [`/20-engineering/ux-design-system.md`](/docs/20-engineering/ux-design-system.md)
- [`/70-reference/portfolio-app-config-reference.md`](/docs/70-reference/portfolio-app-config-reference.md)

### External reference links

- https://nextjs.org/docs/app
- https://nextjs.org/docs/app/getting-started/layouts-and-pages
- https://tailwindcss.com/docs/installation/framework-guides

## Validation / Expected outcomes

- Reviewers can reach `/cv`, `/projects`, and docs within two clicks.
- Evidence callouts match the current documentation structure.

## Failure modes / Troubleshooting

- Docs links broken: verify `NEXT_PUBLIC_DOCS_BASE_URL` and redeploy.
- Empty featured cards: verify project registry content and rebuild.

## References

- None.
