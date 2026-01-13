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

Status: Implemented in Phase 1.

### Gate 1: Quality

- `pnpm lint`
- `pnpm format:check`
- `pnpm typecheck`

### Gate 2: Build

- `pnpm build`

These checks must run on:

- PRs targeting `main`
- pushes to `main`

### Linting

Configuration approach:

- ESLint 9+ with flat config (`eslint.config.mjs`)
- Presets:
  - `eslint-config-next/core-web-vitals` (Next.js recommended rules)
  - `eslint-config-next/typescript` (TypeScript integration)
- Custom global ignores: `.next/`, `out/`, `dist/`, `coverage/`, `.vercel/`, `next-env.d.ts`

Command:

```bash
pnpm lint  # fails on warnings (--max-warnings=0)
```

Rationale:

- Flat config is the modern ESLint standard (ESLint 9+)
- Next.js presets provide sensible defaults for App Router + TypeScript
- Zero warnings enforced to maintain code quality

### Formatting

Configuration (`prettier.config.mjs`):

```javascript
{
  semi: true,
  singleQuote: false,
  trailingComma: "all",
  printWidth: 100,
  tabWidth: 2,
  plugins: ["prettier-plugin-tailwindcss"]
}
```

- Prettier uses an ESM config (`prettier.config.mjs`) to satisfy plugin ESM/TLA requirements
- **Tailwind plugin:** `prettier-plugin-tailwindcss` automatically sorts Tailwind utility classes for consistency
- `pnpm format:check` is a required gate in CI and must stay stable to avoid check-name drift

Commands:

```bash
pnpm format:check  # CI gate
pnpm format:write  # local fix
```

### Merge gates (GitHub ruleset)

- Required checks: `ci / quality`, `ci / build` (must exist and run to be selectable as required).
- Checks run on PRs and on pushes to `main` to gate production promotion and keep ruleset enforcement valid.
- Check naming stability is mandatory; changing names would break required-check enforcement and Vercel promotion alignment.

## Phased testing strategy

Note: Items marked (implemented) are in the current state. Others are (planned).

### Phase 1 (MVP): Gates + smoke checks (implemented)

- quality + build gates
- manual review on preview deployments:
  - navigation
  - page rendering
  - key links to `/docs`

### Phase 2: Unit tests (planned)

- add Vitest for:
  - slug generation
  - project metadata validation
  - components with business logic
- CI adds `pnpm test`

### Phase 3: E2E tests (planned)

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
- CI triage runbook: [docs/50-operations/runbooks/rbk-portfolio-ci-triage.md](docs/50-operations/runbooks/rbk-portfolio-ci-triage.md)
- Deploy runbook: [docs/50-operations/runbooks/rbk-portfolio-deploy.md](docs/50-operations/runbooks/rbk-portfolio-deploy.md)
- Rollback runbook: [docs/50-operations/runbooks/rbk-portfolio-rollback.md](docs/50-operations/runbooks/rbk-portfolio-rollback.md)
- Portfolio Docs App CI posture: [docs/60-projects/portfolio-docs-app/05-testing.md](docs/60-projects/portfolio-docs-app/05-testing.md)
