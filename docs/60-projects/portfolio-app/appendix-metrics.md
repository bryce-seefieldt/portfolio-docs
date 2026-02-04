---
title: 'Appendix: Metrics & Quality Signals'
description: 'Quality gates, testing coverage, and operational thresholds for the Portfolio App.'
tags: [projects, portfolio, appendix, metrics, quality]
---

## Purpose

Centralize quantitative quality signals and operational thresholds referenced by the dossier without cluttering the front door.

## Scope

### In scope

- CI quality gates and verification steps
- test counts and coverage targets
- performance and reliability thresholds

### Out of scope

- step-by-step procedures (belongs in runbooks)
- release timeline (belongs in release notes)

## CI Quality Gates

- `ci / quality`: lint, format check, typecheck
- `ci / test`: unit + E2E tests
- `ci / build`: Next.js build
- `codeql`: security analysis

## Test Coverage Signals

- Unit tests (Vitest): 70+ tests covering registry validation and link helpers
- E2E tests (Playwright): 58 tests across Chromium and Firefox
- Coverage target: ≥80% for core `src/lib/` modules

## Verification Workflow (Local)

- `pnpm verify`: full validation workflow (includes registry and link validation)
- `pnpm verify:quick`: fast iteration, skips performance checks and tests

## Operational Thresholds

- MTTR targets:
  - Deployment failure: 5 minutes
  - Service degradation: 10 minutes
- Health endpoint states: healthy / degraded / unhealthy

## References

- Testing guide: [/docs/70-reference/testing-guide.md](/docs/70-reference/testing-guide.md)
- Performance optimization: [/docs/70-reference/performance-optimization-guide.md](/docs/70-reference/performance-optimization-guide.md)
- Runbooks: [/docs/50-operations/runbooks/index.md](/docs/50-operations/runbooks/index.md)
