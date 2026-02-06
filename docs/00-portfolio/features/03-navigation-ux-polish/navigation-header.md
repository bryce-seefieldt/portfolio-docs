---
title: 'Feature: Navigation Header'
description: 'Sticky navigation with desktop links and mobile menu.'
sidebar_position: 1
tags: [portfolio, features, navigation, header]
---

## Purpose

- Feature name: Navigation header
- Why this feature exists: Provide consistent access to core routes and evidence links across the site.

## Scope

### In scope

- sticky header behavior on scroll
- desktop navigation links
- mobile menu toggle and close behaviors

### Out of scope

- theme toggle behavior (covered in theming group)
- page-specific CTAs (covered in core pages)

## Prereqs / Inputs

- docs base URL configured for evidence link
- optional `NEXT_PUBLIC_GITHUB_URL` for GitHub link

## Procedure / Content

### Feature summary

- Feature name: Navigation header
- Feature group: Navigation and UX polish
- Technical summary: Client-side navigation component with sticky behavior, desktop links, and a mobile menu.
- Low-tech summary: A header that helps reviewers move between pages quickly.

### Feature in action

- Where to see it working: Header on any route, such as `/` or `/projects`.

### Confirmation Process

#### Manual

- Steps: Open any page, scroll to trigger sticky shadow, open mobile menu, select a link.
- What to look for: Header stays visible, menu opens/closes, links route correctly.
- Artifacts or reports to inspect: Optional route coverage in CI.

#### Tests

- Unit tests: None specific.
- E2E tests:
  - [`/portfolio-app/tests/e2e/routes.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/routes.spec.ts)
  - [`/portfolio-app/tests/e2e/smoke.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/smoke.spec.ts)

### Potential behavior if broken or misconfigured

- Navigation links route to the wrong pages.
- Mobile menu does not close on selection or escape.
- Sticky styling does not engage when scrolling.

### Long-term maintenance notes

- Keep navigation entries aligned with core routes.
- Update evidence link if docs base URL changes.

### Dependencies, libraries, tools

- Next.js App Router
- React
- Tailwind CSS

### Source code references (GitHub URLs)

- [`/portfolio-app/src/components/NavigationEnhanced.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/NavigationEnhanced.tsx)

### ADRs

- None.

### Runbooks

- None.

### Additional internal references

- [`/20-engineering/ux-design-system.md`](/docs/20-engineering/ux-design-system.md)

### External reference links

- https://nextjs.org/docs/app
- https://react.dev/

## Validation / Expected outcomes

- Navigation is consistent across routes and breakpoints.
- Evidence link routes to the configured docs base URL.

## Failure modes / Troubleshooting

- Broken links: verify route paths and redeploy.
- Mobile menu stuck open: check client-side event handling.

## References

- None.
