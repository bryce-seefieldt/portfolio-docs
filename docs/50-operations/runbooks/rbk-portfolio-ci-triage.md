---
title: 'Runbook: Portfolio App CI Triage (Quality + Build Gates)'
description: 'Deterministic procedure for diagnosing and fixing Portfolio App CI failures: lint, format checks, typecheck, and build failures.'
sidebar_position: 6
tags: [operations, runbook, portfolio-app, cicd, troubleshooting, quality-gates]
---

## Purpose

Provide a fast and repeatable procedure to diagnose and resolve CI failures for the Portfolio App.

CI failures are treated as “stop-the-line” events. The correct response is to fix the root cause or rollback—not to weaken gates.

## Scope

### Use when

- `ci / quality` fails (lint, format:check, typecheck)
- `ci / build` fails (Next build)
- Vercel promotion is blocked due to failing checks

### Do not use when

- failures are unrelated to CI (use relevant operational runbooks)

## Prereqs / Inputs

- Access to GitHub Actions logs for the failing run
- Ability to run commands locally:
  - `pnpm lint`
  - `pnpm format:check`
  - `pnpm typecheck`
  - `pnpm build`

## Procedure / Content

### CI topology (for context)

- `ci / quality` job runs:
  - `pnpm lint`
  - `pnpm format:check`
  - `pnpm typecheck`
- `ci / build` job runs:
  - `pnpm install --frozen-lockfile`
  - `pnpm build`
  - depends on `ci / quality` being green

### 1) Identify the failing check and error class

In the PR or `main` workflow run, identify:

- failing job: `quality` or `build`
- failing step (lint vs format vs typecheck vs build)
- affected file paths

### 2) Reproduce locally (required)

On the same branch/commit:

```bash
pnpm install
pnpm lint
pnpm format:check
pnpm typecheck
pnpm build
```

If local results differ from CI:

- confirm Node and pnpm versions match project standards
- ensure lockfile is committed and install is deterministic

### 3) Fix by failure type

#### A) Formatting failures (`format:check`)

Symptoms:

- Prettier reports files are not formatted

Fix:

- run formatting write (if available):
  - `pnpm format:write`
- re-run:
  - `pnpm format:check`

Known failure mode:

- Prettier fails with ESM plugin / require() errors:
  - ensure config file is `prettier.config.mjs`
  - ensure plugins are specified as strings (e.g., `"prettier-plugin-tailwindcss"`)

#### B) Lint failures (`lint`)

Symptoms:

- ESLint reports rule violations

Fix:

- resolve violations explicitly
- avoid disabling rules without governance rationale
- if a rule is overly strict:
  - tune intentionally and document via ADR if policy change is significant

#### C) Typecheck failures (`typecheck`)

Symptoms:

- TypeScript errors appear (unsafe typing, invalid imports)

Fix:

- correct typings or imports
- avoid broad any usage unless explicitly justified
- ensure tsconfig aligns with Next.js project structure

#### D) Build failures (`build`)

Symptoms:

- Next.js build fails due to code errors, routing issues, or environment assumptions

Fix:

- reproduce with `pnpm build`
- correct the root cause
- do not “paper over” build errors by weakening the build process

#### 4) Validate and push fix

After changes:

```bash
pnpm lint
pnpm format:check
pnpm typecheck
pnpm build
```

Commit and push to PR branch.

#### 5) Confirm CI is green and promotion unblocks

- Confirm GitHub checks pass.
- Confirm Vercel promotion gates clear.

#### 6) Prevent recurrence

If the failure mode is likely to repeat:

- update contributor guidance
- add a checklist item to PR template
- add or refine lint/format/typecheck configuration
- consider pre-commit hooks (optional; CI remains authoritative)

## Validation / Expected outcomes

- Local and CI results converge (deterministic)
- Required checks are green:
  - `ci / quality`
  - `ci / build`
- Production promotion proceeds once checks pass

## Rollback / Recovery

If the fix is non-trivial and production is impacted:

- rollback via revert and stabilize first
- fix forward in a new PR with proper validation

## Failure modes / Troubleshooting

- CI fails but local passes:
  - toolchain mismatch; confirm Node/pnpm; ensure frozen lockfile install behavior
- Persistent formatting churn:
  - ensure editor integration and formatting scripts are documented and used
- Type errors cascade:
  - reduce scope; fix incrementally; avoid mixing large refactors with feature changes

- Merge is blocked because required checks are unavailable to select in the ruleset:
  - ensure checks exist with the exact names `ci / quality` and `ci / build`
  - run the workflow on a PR and on `main` so GitHub can offer them as Required

### How to re-run checks

- From the GitHub Actions UI:
  - Use “Re-run all jobs” on the failed workflow run (preferred for transient issues).
- Push a no-op change if necessary to retrigger (e.g., amend commit message or whitespace change). Avoid `ci skip` patterns since required checks must execute for promotion.
- If checks are still not appearing as Required candidates, ensure a recent successful run exists on both a PR and a push to `main` with the exact job names.

## References

- Portfolio App testing and gates: `docs/60-projects/portfolio-app/testing.md`
- Deploy runbook: `docs/50-operations/runbooks/rbk-portfolio-deploy.md`
- Rollback runbook: `docs/50-operations/runbooks/rbk-portfolio-rollback.md`
