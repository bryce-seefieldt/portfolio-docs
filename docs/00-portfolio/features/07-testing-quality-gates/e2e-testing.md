---
title: 'Feature: End-to-End Testing'
description: 'Playwright E2E coverage for routes, links, and metadata.'
sidebar_position: 3
tags: [portfolio, features, testing, e2e]
---

## Purpose

- Feature name: End-to-end testing
- Why this feature exists: Validate critical routes, evidence links, and metadata in a real browser.

## Scope

### In scope

- route coverage across core pages
- evidence link checks
- metadata endpoints where applicable

### Out of scope

- unit test logic
- performance budgets

## Prereqs / Inputs

- Playwright configured in the app
- test base URL configured for CI

## Procedure / Content

### Feature summary

- Feature name: End-to-end testing
- Feature group: Testing and quality gates
- Technical summary: Runs Playwright suites against core routes, evidence links, and key endpoints.
- Low-tech summary: Browser-based tests confirm the site works like a user expects.

### Feature in action

- Where to see it working: `pnpm test:e2e` in the app repo.

### Confirmation Process

#### Manual

- Steps: Run `pnpm test:e2e` locally or against staging.
- What to look for: All routes pass, evidence links resolve.
- Artifacts or reports to inspect: Playwright HTML report on failures.

#### Tests

- Unit tests: None.
- E2E tests:
  - [`/portfolio-app/tests/e2e/routes.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/routes.spec.ts)
  - [`/portfolio-app/tests/e2e/smoke.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/smoke.spec.ts)
  - [`/portfolio-app/tests/e2e/evidence-links.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/evidence-links.spec.ts)

### Potential behavior if broken or misconfigured

- E2E tests skipped due to missing browsers or base URL.
- Route failures due to bad slugs or links.

### Long-term maintenance notes

- Keep tests aligned with route additions.
- Update Playwright config when environments change.

### Dependencies, libraries, tools

- Playwright
- Node.js
- pnpm

### Source code references (GitHub URLs)

- [`/portfolio-app/playwright.config.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/playwright.config.ts)
- [`/portfolio-app/tests/e2e/routes.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/routes.spec.ts)

### ADRs

- None.

### Runbooks

- [`/50-operations/runbooks/rbk-portfolio-deploy.md`](/docs/50-operations/runbooks/rbk-portfolio-deploy.md)
- [`/50-operations/runbooks/rbk-portfolio-ci-triage.md`](/docs/50-operations/runbooks/rbk-portfolio-ci-triage.md)

### Additional internal references

- [`/70-reference/testing-guide.md`](/docs/70-reference/testing-guide.md)
- [`/30-devops-platform/observability-health-checks.md`](/docs/30-devops-platform/observability-health-checks.md)

### External reference links

- https://playwright.dev/docs/intro

## Validation / Expected outcomes

- E2E tests pass for core routes and evidence links.

## Failure modes / Troubleshooting

- Browser failures: reinstall Playwright browsers or use CI runners.

## References

- None.
