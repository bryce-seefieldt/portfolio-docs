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

### Option 1: Comprehensive verification script (recommended)

For a streamlined workflow with detailed reporting:

```bash
pnpm install
pnpm verify
```

The `verify` command runs a comprehensive 7-step validation workflow:

1. **Environment check**: Validates Node version, pnpm availability, `.env.local` existence, and required environment variables
2. **Auto-format**: Runs `format:write` to fix formatting issues automatically
3. **Format validation**: Confirms formatting correctness with `format:check`
4. **Linting**: Executes ESLint with zero-warning enforcement
5. **Type checking**: Validates TypeScript types across the codebase
6. **Registry validation**: Ensures project registry schema compliance and data integrity
7. **Build**: Produces production bundle to catch build-time errors

**Benefits:**
- Single command runs all pre-commit quality checks
- Auto-formats code before validation (reduces false failures)
- Provides color-coded output for quick status assessment
- Includes detailed troubleshooting guidance for each failure type
- Mirrors CI workflow for local/remote consistency
- Generates summary report with next steps

**When to use:**
- Before every commit (catches issues early)
- Before opening a PR (ensures CI will pass)
- After pulling changes from main (validates clean state)
- When troubleshooting CI failures locally

### Option 2: Individual commands (granular control)

For targeted validation or when you need to run specific checks:

```bash
pnpm install
pnpm lint          # ESLint validation
pnpm format:check  # Prettier validation (or format:write to fix)
pnpm typecheck     # TypeScript type checking
pnpm build         # Production build
```

**When to use individual commands:**
- Debugging a specific type of failure
- Running checks during active development (e.g., `typecheck` while coding)
- Understanding what each check does
- Integrating with editor/IDE workflows

### Local preview server

To preview the site during development:

```bash
pnpm dev
```

This starts the Next.js development server at `http://localhost:3000`.

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

### Dependabot CI hardening (implemented)

**Status:** Implemented in PR #15 (merged 2026-01-19).

**Problem:** Dependabot PRs fail quality checks due to `pnpm-lock.yaml` formatting violations. Dependabot regenerates lockfiles but does not run Prettier, causing `pnpm format:check` to fail.

**Solution implemented:**

1. **Lockfile exclusions in `.prettierignore`:**
   - Added `pnpm-lock.yaml`, `package-lock.json`, `yarn.lock`
   - Rationale: Machine-generated files don't benefit from formatting; prevents CI failures

2. **Auto-format step for Dependabot PRs in CI:**
   - Runs in `ci / quality` job before lint/format/typecheck steps
   - Conditional execution: `if: ${{ github.actor == 'dependabot[bot]' }}`
   - Actions:
     - Runs `pnpm format:write || true`
     - Detects changes with `git status --porcelain`
     - Auto-commits formatting fixes as `chore: auto-format (CI)`
     - Pushes to PR branch
   - Permissions: Workflow has `contents: write` to enable auto-commit

3. **Workflow permissions:**
   - Changed from `contents: read` to `contents: write`
   - Required for CI to push auto-format commits to Dependabot PR branches

**Impact:**

- Future Dependabot PRs will auto-fix formatting issues without manual intervention
- Quality gate failures due to lockfile formatting eliminated
- Maintains zero-tolerance formatting enforcement for non-generated code

**Evidence:**

- PR #15: https://github.com/bryce-seefieldt/portfolio-app/pull/15
- Fixed PRs #12 and #13 (manual fixes before automation)
- Configuration files: `.prettierignore`, `.github/workflows/ci.yml`

**Governance note:** Auto-format only runs for Dependabot; human PRs still require manual formatting to maintain developer discipline.

## Phased testing strategy

Note: Items marked (implemented) are in the current state. Others are (planned).

### Phase 1 (MVP): Gates + manual smoke checks (implemented)

- quality + build gates
- manual review on preview deployments:
  - navigation
  - page rendering
  - key links to `/docs`

### Phase 2: Automated smoke tests with Playwright (implemented)

**Status:** Implemented in PR #10 (merged 2026-01-17).

**Framework:** Playwright (multi-browser E2E testing)

**Coverage:**

- 6 smoke test cases (12 total executions across 2 browsers)
- Core routes: `/`, `/cv`, `/projects`, `/contact`
- Dynamic routes: `/projects/[slug]` (example: `/projects/portfolio-app`)
- Evidence link resolution validation

**Configuration:**

- Test directory: `tests/e2e/`
- Config file: `playwright.config.ts`
- Browsers: Chromium, Firefox (WebKit excluded for stability)
- Retries: 2 in CI, 0 locally
- Workers: 1 in CI (sequential for stability), unlimited locally
- Base URL: `http://localhost:3000` (local/CI dev server)

**CI Integration:**

- Tests run in `ci / build` job after successful build
- Playwright browsers installed via `npx playwright install --with-deps`
- Dev server started with `pnpm dev &` and readiness check via `wait-on http://localhost:3000`
- Tests execute with `pnpm test` (runs `playwright test`)
- HTML test reports generated (`.gitignored`)

**Test Scripts:**

```bash
pnpm test        # Run all tests headlessly
pnpm test:ui     # Open Playwright UI mode (local dev)
pnpm test:debug  # Run tests in debug mode
```

**Evidence:**

- PR #10: https://github.com/bryce-seefieldt/portfolio-app/pull/10
- Test runtime: ~10 seconds for 12 tests
- All tests passing in CI and local environments

**Next.js 15 Compatibility Fix:**

- Fixed dynamic route params (now async in Next.js 15)
- Changed `params: { slug: string }` to `params: Promise<{ slug: string }>`
- Added `await` for params destructuring in `[slug]/page.tsx`

### Phase 3: Unit tests (planned)

- add Vitest for:
  - slug generation
  - project metadata validation
  - components with business logic
- CI adds `pnpm test:unit`

### Phase 4: Extended E2E coverage (planned)

- Expand Playwright coverage:
  - form submissions (contact page)
  - navigation flows (multi-page journeys)
  - accessibility checks
  - visual regression tests (if needed)

## Definition of Done for changes

A PR is acceptable when:

- CI gates pass:
  - `ci / quality` (lint, format, typecheck)
  - `ci / build` (build + smoke tests)
- preview deployment renders as expected
- smoke tests pass (12/12 tests)
- no broken evidence links are introduced
- if behavior changes materially:
  - dossier updated
  - runbooks updated (if ops changes)
  - ADR added/updated (if architectural)
  - smoke tests updated if routes/navigation changes

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
