---
title: 'Runbook: Portfolio App CI Triage (Quality + Build Gates)'
description: 'Deterministic procedure for diagnosing and fixing Portfolio App CI failures: lint, format checks, typecheck, and build failures.'
sidebar_position: 6
tags: [operations, runbook, portfolio-app, cicd, troubleshooting, quality-gates]
---

## Purpose

Provide a fast and repeatable procedure to diagnose and resolve CI failures for the Portfolio App.

CI failures are treated as “stop-the-line” events. The correct response is to fix the root cause or rollback—not to weaken gates.

## Governance Context

This runbook assumes Vercel and GitHub governance are already configured per [rbk-vercel-setup-and-promotion-validation.md](./rbk-vercel-setup-and-promotion-validation.md). Required checks are:

- `ci / quality` (lint, format:check, typecheck)
- `ci / test` (unit tests, coverage, E2E tests)
- `ci / build` (Next.js build)

When any required check fails, this runbook provides deterministic diagnosis and fix procedures. See [rbk-portfolio-deploy.md](./rbk-portfolio-deploy.md) for the deploy workflow where CI gating is enforced.

## Scope

### Use when

- `ci / quality` fails (lint, format:check, typecheck)
- `ci / test` fails (unit tests, coverage, E2E tests)
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
  - `pnpm test:unit`
  - `pnpm test:coverage`
  - `pnpm test:e2e`

## Procedure / Content

### CI topology (for context)

- `ci / quality` job runs:
  - Auto-format step (Dependabot PRs only)
  - `pnpm lint`
  - `pnpm format:check`
  - `pnpm typecheck`
- `ci / secrets-scan` job runs **on pull requests only** (not on push to main)
  - TruffleHog secret scanning with verified detectors
  - reason: TruffleHog requires a diff between base and head; direct pushes to main have identical references and would fail
- `ci / build` job runs:
  - `pnpm install --frozen-lockfile`
  - `pnpm build`
  - Playwright browser installation (`npx playwright install --with-deps`)
  - Dev server startup (`pnpm dev &` + readiness check via `wait-on`)
  - Smoke tests (`pnpm test` - 12 tests across Chromium + Firefox)
  - depends on `ci / quality` being green
  - note: `secrets-scan` is not a strict dependency (only runs on PRs, but all PRs require it via branch protection)
- `ci / test` job runs:
  - `pnpm test:unit`
  - `pnpm test:e2e`
  - uploads coverage artifacts from `pnpm test:coverage` when configured

### 1) Identify the failing check and error class

In the PR or `main` workflow run, identify:

- failing job: `quality` or `build`
- failing step (lint vs format vs typecheck vs build)
- affected file paths

### 2) Reproduce locally (required)

**Option 1: Comprehensive verification (recommended)**

Run the complete validation suite to identify all issues at once:

```bash
pnpm install
pnpm verify
```

The verify script runs all CI checks (environment validation, auto-format, format check, lint, typecheck, registry validation, build) with detailed error reporting and troubleshooting guidance.

**Option 2: Individual commands (targeted debugging)**

On the same branch/commit:

```bash
pnpm install
pnpm lint
pnpm format:check
pnpm typecheck
pnpm build
pnpm test  # Smoke tests (Playwright)
```

Use individual commands when you need to:

- Debug a specific failure type
- Run checks in isolation
- Understand what each check validates

If local results differ from CI:

- confirm Node and pnpm versions match project standards
- ensure lockfile is committed and install is deterministic
- for smoke test failures: ensure dev server is running (`pnpm dev`) or Playwright will start it automatically

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
  Common build failure modes:

1. **Registry validation errors during page data collection:**
   - Error: `"demoUrl" is missing or invalid according to a Zod schema validation`
   - Symptom: Build fails during static page generation for `/projects/[slug]`
   - Root Cause: Environment variable interpolation failing (see Known Issue below)
   - Fix: Verify environment variables are set correctly
   - Verification: `pnpm registry:validate` should pass

2. **Known Issue: Registry interpolation with tsx/Node.js:**
   - **Problem:** Module load order causes environment variables to not be visible during registry loading
   - **Solution (Fixed in commit 1a1e272):** Use `process.env` directly in `interpolate()` function instead of module-level imports
   - **Prevention:** Ensure `NEXT_PUBLIC_*` environment variables are set before build
   - **Reference:** [Stage 3.1 Known Issues](/docs/00-portfolio/roadmap/issues/stage-3-1-app-issue.md#known-issues--solutions)

3. **Environment variable check:**

```bash
# Verify required variables are set
echo $NEXT_PUBLIC_DOCS_BASE_URL
echo $NEXT_PUBLIC_GITHUB_URL

# Test registry interpolation
pnpm registry:validate
# Should output: Registry OK (projects: N)
```

4. **Quick verification recipe (registry-specific):**

```bash
cd portfolio-app
pnpm registry:validate   # Expect: Registry OK (projects: N)
pnpm lint                # Expect: silent, 0 warnings
pnpm build               # Expect: ✓ Compiled successfully
```

5. **If build still fails on registry interpolation:**

- Check env vars: `cat .env.local | grep NEXT_PUBLIC`
- Run with debug: `DEBUG_REGISTRY=1 pnpm registry:validate 2>&1 | head -20`
  - Look for `interpolated="https://..."` (absolute URLs)
- Clean and rebuild: `rm -rf .next node_modules/.cache && pnpm build`
- Ensure `interpolate()` reads from `process.env` (fixed in commit `1a1e272`)

#### E) Smoke test failures (`pnpm test`)

**Status:** Smoke tests implemented in Phase 2 (PR #10).

Symptoms:

- Playwright tests fail (route rendering, navigation, evidence links)
- Browser launch failures in CI
- Server connection errors

Common failure modes:

1. **Browser binaries missing in CI:**
   - Error: `browserType.launch: Executable doesn't exist`
   - Fix: Ensure `npx playwright install --with-deps` runs in CI before tests
   - Verification: Check CI workflow includes installation step

2. **Dev server not running:**
   - Error: `NS_ERROR_CONNECTION_REFUSED` or `net::ERR_CONNECTION_REFUSED`
   - Fix: Ensure dev server starts before tests (`pnpm dev &` + `wait-on http://localhost:3000`)
   - Local: Playwright auto-starts server via `webServer` config (disabled in CI)

3. **Route rendering failures:**
   - Error: Test expects status < 400 but receives 404 or 500
   - Fix: Verify route exists and renders correctly locally
   - Check: Dynamic routes may need param fixes (Next.js 15 async params)

4. **Evidence link resolution failures:**
   - Error: `a[href*="/docs/"]` locator not found
   - Fix: Verify project pages include documentation links
   - Check: `NEXT_PUBLIC_DOCS_BASE_URL` is configured correctly

5. **Timeout failures:**
   - Error: Test timeout exceeded (default 30s per test)
   - Fix: Increase timeout in `playwright.config.ts` or optimize slow routes
   - CI: Reduce parallelism (already set to 1 worker in CI for stability)

Debugging smoke tests:

```bash
# Local debugging
pnpm test:debug      # Opens Playwright inspector
pnpm test:ui         # Opens Playwright UI mode

# CI debugging
# - Download HTML test report artifact from failed CI run
# - Open playwright-report/index.html locally to see screenshots/traces

#### F) Unit test or coverage failures (`pnpm test:unit` / `pnpm test:coverage`)

Symptoms:

- Vitest failures in UI, API route handlers, data wrappers, or lib helpers
- Coverage thresholds failing after new code paths are added

Fix:

- Run `pnpm test:unit` to reproduce and isolate the failing test
- Run `pnpm test:coverage` to identify uncovered files or branches
- Add or update unit tests for affected modules (pages, components, API handlers)
```

Fix workflow:

- Reproduce locally with `pnpm test`
- Check Playwright config (`playwright.config.ts`) for environment differences
- Verify test file (`tests/e2e/smoke.spec.ts`) expectations match actual behavior
- Update tests or fix routes as needed
- Re-run locally to confirm fix
- Push and verify CI passes

#### 4) Validate and push fix

After changes:

```bash
pnpm lint
pnpm format:check
pnpm typecheck
pnpm build
pnpm test  # Smoke tests
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
