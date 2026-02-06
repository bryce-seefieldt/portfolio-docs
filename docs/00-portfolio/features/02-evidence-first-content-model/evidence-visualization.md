---
title: 'Feature: Evidence Visualization Components'
description: 'Evidence badges and grids that surface documentation artifacts.'
sidebar_position: 2
tags: [portfolio, features, evidence, components]
---

## Purpose

- Feature name: Evidence visualization components
- Why this feature exists: Make evidence discoverable without forcing reviewers to hunt for links.

## Scope

### In scope

- evidence badges on project detail pages
- evidence grid cards for dossier, threat model, ADRs, and runbooks
- empty-state handling for missing evidence

### Out of scope

- registry schema validation
- docs base URL configuration

## Prereqs / Inputs

- project registry contains evidence fields
- docs base URL configured for link construction

## Procedure / Content

### Feature summary

- Feature name: Evidence visualization components
- Feature group: Evidence-first content model
- Technical summary: Renders badges and evidence grids based on registry evidence fields.
- Low-tech summary: Shows proof links in a clean, scannable layout.

### Feature in action

- Where to see it working: `/projects/portfolio-app` and other project detail pages.

### Confirmation Process

#### Manual

- Steps: Open a project detail page and review the badges and evidence grid.
- What to look for: Badges appear for available evidence, cards link to the correct docs pages.
- Artifacts or reports to inspect: Playwright evidence link coverage in CI.

#### Tests

- Unit tests: None specific (component behavior is covered by route and evidence link E2E tests).
- E2E tests: [`/portfolio-app/tests/e2e/evidence-links.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/evidence-links.spec.ts)

### Potential behavior if broken or misconfigured

- Badges missing despite evidence being present.
- Evidence cards show empty or invalid links.

### Long-term maintenance notes

- Keep evidence categories aligned with registry fields.
- Update styling and accessibility with the design system.

### Dependencies, libraries, tools

- Next.js App Router
- React
- Tailwind CSS

### Source code references (GitHub URLs)

- [`/portfolio-app/src/components/BadgeGroup.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/BadgeGroup.tsx)
- [`/portfolio-app/src/components/VerificationBadge.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/VerificationBadge.tsx)
- [`/portfolio-app/src/components/EvidenceBlock.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/EvidenceBlock.tsx)

### ADRs

- None.

### Runbooks

- None.

### Additional internal references

- [`/20-engineering/ux-design-system.md`](/docs/20-engineering/ux-design-system.md)
- [`/70-reference/registry-schema-guide.md`](/docs/70-reference/registry-schema-guide.md)

### External reference links

- https://react.dev/
- https://tailwindcss.com/docs/installation/framework-guides

## Validation / Expected outcomes

- Evidence badges and cards render consistently across project pages.
- Links route to the correct documentation artifacts.

## Failure modes / Troubleshooting

- Missing badges: verify registry evidence fields and rebuild.
- Incorrect links: validate docs base URL and link construction.

## References

- None.
