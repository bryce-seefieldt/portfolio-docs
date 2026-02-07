---
title: 'ADR-0020: Portfolio App UI and Route Testing Strategy'
description: 'Adopt React Testing Library with jsdom for component/page tests and add unit coverage for API routes.'
tags: [architecture, adr, testing, vitest, portfolio-app]
---

# ADR-0020: Portfolio App UI and Route Testing Strategy

## Purpose

Decide how to cover UI components, page rendering, and API route handlers with unit tests without weakening existing Vitest coverage or introducing heavy integration tooling.

## Scope

### In scope

- unit testing approach for React components and App Router pages
- unit testing approach for API route handlers
- Vitest environment configuration for UI tests
- minimal test tooling additions to support the approach

### Out of scope

- E2E coverage strategy (covered by Playwright docs)
- performance testing and load testing
- end-to-end system test orchestration

## Prereqs / Inputs

- Decision owner(s): Portfolio maintainer
- Date: 2026-02-06
- Status: Accepted
- Related work items (optional identifiers): PR-76 (portfolio-app commentary tests)
- Related risks (optional): UI regressions without unit coverage; route handler behavior drift

## Decision Record

### Title

ADR-0020: Portfolio App UI and Route Testing Strategy

### Context

The Portfolio App has strong unit coverage for lib utilities, but gaps exist in UI components, App Router pages, and API route handlers. Current E2E tests validate user journeys, but they are not a replacement for fast, targeted unit tests. We need a lightweight, maintainable approach that keeps the testing pyramid intact and fits the existing Vitest setup.

Constraints and assumptions:

- Vitest is the unit test runner.
- Coverage thresholds apply to src/lib only; we should not add a brittle coverage gate for UI files yet.
- We want to avoid large runtime overhead or complex environment configuration.

### Decision

Adopt React Testing Library (RTL) with jsdom for component and page unit tests, while keeping the default Vitest environment as node and opting into jsdom on a per-test basis. Add unit tests for API route handlers that exercise request/response behavior. Continue using Playwright for E2E flows.

Key configuration choices:

- Add RTL + jest-dom matchers for component/page tests.
- Keep Vitest default environment as node, and add `// @vitest-environment jsdom` only for UI tests.
- Place UI tests in co-located `__tests__` folders for pages and in `src/components/__tests__` for shared UI.
- Add route handler tests in `src/app/api/**/__tests__` or `src/app/__tests__` with direct invocation of exported handlers.

### Alternatives considered

1. E2E-only for UI and route behavior
   - Pros: no new dependencies; simple configuration
   - Cons: slower feedback; harder to isolate regressions; tests become brittle
   - Why not chosen: does not meet unit-test best practices or coverage expectations

2. Playwright component testing instead of RTL
   - Pros: realistic browser environment; consistent with E2E tooling
   - Cons: heavier setup; slower; less common for small UI units
   - Why not chosen: overhead is disproportionate for the current scale

3. React Test Renderer or shallow rendering
   - Pros: minimal dependencies; fast
   - Cons: weaker user-centric assertions; less aligned with modern best practices
   - Why not chosen: RTL is the industry standard for React unit testing

### Consequences

- Positive consequences:
  - Faster, more targeted feedback for UI and API route changes
  - Clearer regression coverage for component props and conditional rendering
  - Maintains testing pyramid with unit tests beneath E2E
- Negative consequences / tradeoffs:
  - Adds RTL + jsdom dependencies
  - Requires explicit jsdom annotations on UI tests
- Operational impact:
  - Slightly longer unit test setup time; still fast and deterministic
- Security impact:
  - None; tests run locally/CI without external calls
- Cost/complexity impact:
  - Low; incremental dependency and config changes

### Implementation notes (high-level)

- Add RTL + jest-dom dev dependencies.
- Add a Vitest setup file to register jest-dom matchers.
- Write UI tests for key components/pages and route handler tests for API routes.
- Update testing guide to document the approach and file locations.

## Validation / Expected outcomes

- New UI and route tests run via `pnpm test` and `pnpm test:unit`.
- Component/page smoke tests verify headings, key links, and conditional rendering.
- API route tests cover expected status codes, validation errors, and headers.
- E2E coverage remains unchanged and focuses on flows.

## Failure modes / Troubleshooting

- UI tests fail due to missing DOM APIs → add jsdom annotations or polyfills.
- Route tests fail due to missing Request globals → use native Fetch API and avoid Next internals.
- Over-testing DOM structure → focus on accessible text and behavioral assertions.

## References

- Testing guide: /docs/70-reference/testing-guide.md
- Portfolio App testing dossier: /docs/60-projects/portfolio-app/05-testing.md
- Vitest config: /portfolio-app/vitest.config.ts
