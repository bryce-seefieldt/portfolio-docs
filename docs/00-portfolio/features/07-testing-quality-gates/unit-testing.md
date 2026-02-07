---
title: 'Feature: Unit Testing'
description: 'Vitest-based unit tests for registry, APIs, components, and pages.'
sidebar_position: 2
tags: [portfolio, features, testing, unit]
---

## Purpose

- Feature name: Unit testing
- Why this feature exists: Validate core logic such as registry validation and link construction.

## Scope

### In scope

- Vitest unit test suite
- full source coverage targets

### Out of scope

- E2E testing
- performance budgets

## Prereqs / Inputs

- Vitest configured in the app
- test data and fixtures available

## Procedure / Content

### Feature summary

- Feature name: Unit testing
- Feature group: Testing and quality gates
- Technical summary: Runs deterministic tests across core utilities, API handlers, components, and pages.
- Low-tech summary: Confirms the app logic works before shipping.

### Feature in action

- Where to see it working: `pnpm test:unit` in the app repo.

### Confirmation Process

#### Manual

- Steps: Run `pnpm test:unit` and review output (currently 195 tests across 39 files).
- What to look for: All tests pass with expected coverage.
- Artifacts or reports to inspect: CI test job logs.

#### Tests

- Unit tests:
  - [`/portfolio-app/src/lib/__tests__/registry.test.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/__tests__/registry.test.ts)
  - [`/portfolio-app/src/lib/__tests__/registry-functions.test.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/__tests__/registry-functions.test.ts)
  - [`/portfolio-app/src/lib/__tests__/linkConstruction.test.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/__tests__/linkConstruction.test.ts)
  - [`/portfolio-app/src/lib/__tests__/config.test.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/__tests__/config.test.ts)
  - [`/portfolio-app/src/app/api/__tests__/echo.test.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/api/__tests__/echo.test.ts)
  - [`/portfolio-app/src/app/__tests__/projects-page.test.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/__tests__/projects-page.test.tsx)
  - [`/portfolio-app/src/components/__tests__/NavigationEnhanced.test.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/__tests__/NavigationEnhanced.test.tsx)
  - [`/portfolio-app/src/__tests__/proxy.test.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/__tests__/proxy.test.ts)
- E2E tests: None.

### Potential behavior if broken or misconfigured

- Unit test coverage drops below target.
- Tests fail due to schema or helper changes.

### Long-term maintenance notes

- Update tests when registry schema changes.
- Keep coverage thresholds aligned with policies.

### Dependencies, libraries, tools

- Vitest
- TypeScript
- pnpm

### Source code references (GitHub URLs)

- [`/portfolio-app/vitest.config.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/vitest.config.ts)
- [`/portfolio-app/src/lib/__tests__/registry.test.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/__tests__/registry.test.ts)

### ADRs

- None.

### Runbooks

- [`/50-operations/runbooks/rbk-portfolio-ci-triage.md`](/docs/50-operations/runbooks/rbk-portfolio-ci-triage.md)

### Additional internal references

- [`/70-reference/testing-guide.md`](/docs/70-reference/testing-guide.md)

### External reference links

- https://vitest.dev/guide/

## Validation / Expected outcomes

- Unit tests pass in CI and locally.
- Coverage targets are met across the full source tree.

## Failure modes / Troubleshooting

- Failing tests: update fixtures or implementation, then re-run.

## References

- None.
