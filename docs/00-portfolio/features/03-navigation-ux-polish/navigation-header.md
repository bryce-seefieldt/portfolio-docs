---
title: 'Feature: Navigation Header'
description: 'Sticky raised control strip with stacked brand, control-style navigation links, and responsive menu behavior.'
sidebar_position: 1
tags: [portfolio, features, navigation, header]
---

## Purpose

- Feature name: Navigation header
- Why this feature exists: Provide consistent access to core routes and evidence links across the site.

## Scope

### In scope

- sticky header behavior on scroll
- raised control-strip materiality
- stacked persistent brand nameplate
- desktop navigation controls
- mobile menu toggle and close behaviors

### Out of scope

- theme toggle behavior (covered in theming group)
- page-specific CTAs (covered in core pages)

## Prereqs / Inputs

- docs base URL configured for evidence link
- optional `NEXT_PUBLIC_GITHUB_BASE_URL` for GitHub profile link

## Procedure / Content

### Feature summary

- Feature name: Navigation header
- Feature group: Navigation and UX polish
- Technical summary: Client-side navigation component renders a raised control strip with compact control links, stacked branding, sticky-on-scroll shadow state, and mobile expansion behavior.
- Low-tech summary: The header now reads like a control console while keeping routes easy to reach.

### Feature in action

- Where to see it working: Header on any route, such as `/` or `/projects`.

### Confirmation Process

#### Manual

- Steps: Open any page, scroll to trigger sticky shadow, verify stacked brand text, test desktop and mobile link controls.
- What to look for: Header stays visible, control strip styling persists across routes, menu opens/closes, links route correctly.
- Artifacts or reports to inspect: Optional route coverage in CI.

#### Tests

- Unit tests:
  - [`/portfolio-app/src/components/__tests__/NavigationEnhanced.test.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/__tests__/NavigationEnhanced.test.tsx)
- E2E tests:
  - [`/portfolio-app/tests/e2e/routes.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/routes.spec.ts)
  - [`/portfolio-app/tests/e2e/smoke.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/smoke.spec.ts)

### Potential behavior if broken or misconfigured

- Navigation links route to the wrong pages.
- Mobile menu does not close on selection or escape.
- Sticky styling does not engage when scrolling.
- Stacked brand regresses to outdated naming.

### Long-term maintenance notes

- Keep navigation entries aligned with core routes.
- Update evidence link if docs base URL changes.
- Keep link labels and control treatment consistent with `ControlButton` contracts.

### Dependencies, libraries, tools

- Next.js App Router
- React
- Tailwind CSS

### Source code references (GitHub URLs)

- [`/portfolio-app/src/components/NavigationEnhanced.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/NavigationEnhanced.tsx)
- [`/portfolio-app/src/components/ControlButton.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/ControlButton.tsx)
- [`/portfolio-app/src/app/globals.css`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/globals.css)

### ADRs

- None.

### Runbooks

- None.

### Additional internal references

- [`/20-engineering/ux-engineering-standards.md`](/20-engineering/ux-engineering-standards.md)

### External reference links

- https://nextjs.org/docs/app
- https://react.dev/

## Validation / Expected outcomes

- Navigation is consistent across routes and breakpoints.
- Evidence link routes to the configured docs base URL and opens in a new tab.

## Failure modes / Troubleshooting

- Broken links: verify route paths and redeploy.
- Mobile menu stuck open: check client-side event handling.

## References

- None.
