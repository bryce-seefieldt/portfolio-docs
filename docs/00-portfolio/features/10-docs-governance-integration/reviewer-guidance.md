---
title: 'Feature: Reviewer Guidance'
description: 'Explicit guidance to lead reviewers to the evidence trail.'
sidebar_position: 2
tags: [portfolio, features, documentation, reviewer]
---

## Purpose

- Feature name: Reviewer guidance
- Why this feature exists: Help reviewers understand how to evaluate the portfolio quickly.

## Scope

### In scope

- callouts describing the evaluation path
- guidance for evidence-first review

### Out of scope

- project registry data
- internal documentation site navigation

## Prereqs / Inputs

- core pages include reviewer callouts
- evidence links configured

## Procedure / Content

### Feature summary

- Feature name: Reviewer guidance
- Feature group: Documentation and governance integration
- Technical summary: Callout components provide a structured reviewer path.
- Low-tech summary: Step-by-step hints that show where to start and what to check.

### Feature in action

- Where to see it working: `/` and `/cv` pages.

### Confirmation Process

#### Manual

- Steps: Open `/` and `/cv`, read the callouts, follow at least one suggested path.
- What to look for: Guidance is clear and links route to evidence.
- Artifacts or reports to inspect: None.

#### Tests

- Unit tests: None specific.
- E2E tests: [`/portfolio-app/tests/e2e/routes.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/routes.spec.ts) (route coverage only).

### Potential behavior if broken or misconfigured

- Guidance out of date with the documentation structure.
- Callouts removed or hidden.

### Long-term maintenance notes

- Update guidance as the reviewer journey evolves.

### Dependencies, libraries, tools

- Next.js App Router
- React

### Source code references (GitHub URLs)

- [`/portfolio-app/src/app/page.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/page.tsx)
- [`/portfolio-app/src/app/cv/page.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/cv/page.tsx)
- [`/portfolio-app/src/components/Callout.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/Callout.tsx)

### ADRs

- None.

### Runbooks

- None.

### Additional internal references

- [`/20-engineering/ux-design-system.md`](/docs/20-engineering/ux-design-system.md)

### External reference links

- https://nextjs.org/docs/app

## Validation / Expected outcomes

- Reviewer guidance is visible and actionable on core pages.

## Failure modes / Troubleshooting

- Missing guidance: restore callout content and verify links.

## References

- None.
