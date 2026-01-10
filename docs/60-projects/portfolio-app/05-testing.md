---
title: ' Portfolio App: Testing'
description: 'Quality model for the Portfolio App: CI gates, phased testing strategy, and deterministic validation steps for PR review and releases.'
sidebar_position: 5
tags: [projects, testing, quality-gates, ci, nextjs, typescript]
---

## Purpose

Define what “testing” means for the Portfolio App at each maturity phase, and specify the CI quality gates required to merge and release.

The emphasis is on **enterprise credibility**:

- deterministic validation
- enforceable gates in CI
- clear pass/fail criteria

## Scope

### In scope

- required local validation commands
- required CI checks (quality + build)
- phased test strategy (unit then e2e)
- acceptance criteria for “release-ready”

### Out of scope

- detailed test case definitions for specific pages (add as the app matures)

## Prereqs / Inputs

- Portfolio App repo exists and is runnable locally
- ESLint/Prettier/TypeScript tooling is installed
- CI workflow exists and is enforced via branch protections

## Procedure / Content

## Local validation workflow (required)

Run before opening a PR:

```bash
pnpm install
pnpm lint
pnpm format:check
pnpm typecheck
pnpm build
```

Optional local preview:

```bash
pnpm dev
```

## CI quality gates (required)

### Gate 1: Quality

- `pnpm lint`
- `pnpm format:check`
- `pnpm typecheck`

### Gate 2: Build

- `pnpm build`

These checks must run on:

- PRs targeting `main`
- pushes to `main`

## Phased testing strategy

### Phase 1 (MVP): Gates + smoke checks

- quality + build gates
- manual review on preview deployments:
  - navigation
  - page rendering
  - key links to `/docs`

### Phase 2: Unit tests

- add Vitest for:
  - slug generation
  - project metadata validation
  - components with business logic
- CI adds `pnpm test`

### Phase 3: E2E tests

- add Playwright:
  - landing page loads
  - `/cv` renders
  - `/projects` lists projects
  - at least one project detail page loads and contains evidence links
- CI adds `pnpm test:e2e` (nightly or required depending on runtime)

## Definition of Done for changes

A PR is acceptable when:

- CI gates pass
- preview deployment renders as expected
- no broken evidence links are introduced
- if behavior changes materially:
  - dossier updated
  - runbooks updated (if ops changes)
  - ADR added/updated (if architectural)

## Validation / Expected outcomes

- failures are caught before merge
- build remains deterministic
- tests expand over time without slowing delivery unreasonably

## Failure modes / Troubleshooting

- format drift causes repeated failures:
  - run `format:write` locally and recommit
- lint rules too strict early on:
  - tune deliberately; document policy changes if significant
- typecheck fails due to config mismatch:
  - align tsconfig; keep checks scoped to repo sources

## References

- CI policy ADR (create): `docs/10-architecture/adr/`
- Runbooks: `docs/50-operations/runbooks/`
- Porfolio Docs App CI posture: `docs/60-projects/portfolio-docs-app/testing.md`
