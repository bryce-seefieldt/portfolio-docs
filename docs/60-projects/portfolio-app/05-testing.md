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

### Three-Stage Validation: Local → CI → Staging

The Portfolio App enforces quality at three distinct stages:

1. **Local validation** (developer machine, before PR)
   - Run `pnpm verify` to catch issues early
   - Prevents CI failures and speeds up review

2. **CI validation** (GitHub Actions, on PR and main)
   - Automatic: lint, format, typecheck, unit tests, E2E tests, build
   - Blocks merge if checks fail
   - Required before staging validation

3. **Staging validation** (production-like environment, after merge to main)
   - Manual smoke tests on `https://staging-bns-portfolio.vercel.app`
   - Optional automated Playwright tests against staging domain
   - Required before production is considered "live"

### Option 1: Comprehensive verification (recommended)

For a streamlined workflow with detailed reporting and full test coverage:

```bash
pnpm install
pnpm verify
```

The `verify` command runs a comprehensive 11-step validation workflow:

1. **Environment check**: Validates Node version, pnpm availability, `.env.local` existence, and required environment variables
2. **Auto-format**: Runs `format:write` to fix formatting issues automatically
3. **Format validation**: Confirms formatting correctness with `format:check`
4. **Linting**: Executes ESLint with zero-warning enforcement
5. **Type checking**: Validates TypeScript types across the codebase
6. **Secret scan (lightweight)**: Pattern-based scan to catch obvious secrets (local-only; CI uses TruffleHog)
7. **Registry validation**: Ensures project registry schema compliance and data integrity
8. **Build**: Produces production bundle to catch build-time errors
9. **Performance verification**: Validates bundle size and cache headers against `docs/performance-baseline.yml`
10. **Unit tests**: Runs Vitest suite (~120 tests: registry validation, slug helpers, link construction, structured data, observability)
11. **E2E tests**: Runs Playwright suite (58 tests across Chromium + Firefox: smoke + route coverage + metadata endpoints + evidence links)

**Benefits:**

- Single command runs all pre-commit quality checks and tests
- Auto-formats code before validation (reduces false failures)
- Provides color-coded output for quick status assessment
- Includes detailed troubleshooting guidance for each failure type
- Protects performance budgets by enforcing bundle size and cache headers locally
- Mirrors CI workflow for local/remote consistency
- Generates summary report with next steps

**When to use:**

- Before every commit (catches issues early)
- Before opening a PR (ensures CI will pass)
- After pulling changes from main (validates clean state)
- Before final push to production branch

### Option 2: Quick verification (fast iteration)

For rapid feedback during active development without tests:

```bash
pnpm verify:quick
```

Runs steps 1-8 above, **skips performance checks and all tests** (steps 9-11).

**When to use:**

- During active development with frequent small changes
- When debugging specific issues in a feature branch
- For rapid iteration cycles
- Always run full `pnpm verify` before final commit/push

### Option 3: Individual commands (granular control)

For targeted validation or when you need to run specific checks:

```bash
pnpm install
pnpm lint          # ESLint validation
pnpm format:check  # Prettier validation (or format:write to fix)
pnpm typecheck     # TypeScript type checking
pnpm build         # Production build
pnpm test:unit     # Unit tests (Vitest)
pnpm test:e2e       # E2E tests (Playwright)
```

**When to use individual commands:**

- Debugging a specific type of failure
- Running checks during active development (e.g., `typecheck` while coding)
- Understanding what each check does
- Integrating with editor/IDE workflows
- Running only unit tests (without E2E): `pnpm test:unit`
- Debugging E2E tests: `pnpm test:e2e:ui` or `pnpm test:e2e:debug`

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

### Phase 2: Automated E2E tests with Playwright (implemented)

**Status:** Implemented in PR #10 (merged 2026-01-17). Enhanced in Stage 3.3 to validate evidence link resolution.

**Framework:** Playwright (multi-browser E2E testing)

**Coverage:**

- 58 test cases across 2 browsers (Chromium, Firefox)
- Core routes: `/`, `/cv`, `/projects`, `/contact`
- Dynamic routes: `/projects/[slug]` (discovered from `/projects`)
- 404 handling for unknown routes and invalid slugs
- Health + metadata endpoints: `/api/health`, `/robots.txt`, `/sitemap.xml`
- Evidence link rendering and accessibility on `/projects/portfolio-app`
- Responsive checks for evidence content (mobile/tablet/desktop)

**Configuration:**

- Test directory: `tests/e2e/`
- Config file: `playwright.config.ts`
- Browsers: Chromium, Firefox (WebKit excluded for stability)
- Retries: 2 in CI, 0 locally
- Workers: 1 in CI (sequential for stability), unlimited locally
- Base URL: `http://localhost:3000` (local/CI dev server)

**Running E2E Tests:**

```bash
pnpm test:e2e          # Run all E2E tests headlessly
pnpm test:e2e:ui       # Open Playwright UI mode (local dev)
pnpm test:e2e:debug    # Run tests in debug mode with inspector
npx playwright show-report    # View HTML test report
```

**CI Integration:**

- Tests run in `ci / test` job before build
- Playwright browsers installed via `npx playwright install --with-deps`
- Dev server started with `pnpm dev &` and readiness check via `wait-on http://localhost:3000`
- Tests execute with `pnpm test:e2e`
- HTML test reports generated (`.gitignored`)
- Build fails if any E2E tests fail

**Test Scripts:**

- `pnpm test:e2e` — Run all E2E tests
- `pnpm test:e2e:ui` — Interactive UI mode for debugging
- `pnpm test:e2e:debug` — Debug mode with step-through inspector

**Evidence:**

- PR #10: https://github.com/bryce-seefieldt/portfolio-app/pull/10
- Test runtime: ~25 seconds for 58 tests across 2 browsers
- Test files: `tests/e2e/smoke.spec.ts`, `tests/e2e/routes.spec.ts`, `tests/e2e/evidence-links.spec.ts`
- All tests passing in CI and local environments

**Next.js 15 Compatibility Fix:**

- Fixed dynamic route params (now async in Next.js 15)
- Changed `params: { slug: string }` to `params: Promise<{ slug: string }>`
- Added `await` for params destructuring in `[slug]/page.tsx`

### Phase 3: Unit tests (implemented — Stage 3.3)

**Status:** Implemented in PR #XX (2026-01-22).

**Framework:** Vitest (fast, ESM-native unit testing)

**Purpose:** Validate registry schema, slug rules, and link construction helpers at build time to ensure data integrity

**Coverage:**

- ~120 unit tests across core `src/lib/` suites
- All tests passing locally and in CI
- Code coverage: ≥80% for `src/lib/` modules

**Local execution:**

```bash
pnpm test:unit      # Run all ~120 unit tests (CI-like execution)
pnpm test           # Run tests in watch mode (for development)
pnpm test:coverage  # Run tests and generate coverage report
pnpm test:ui        # Visual UI mode for debugging failing tests
```

#### Registry Validation Tests

**File:** `src/lib/__tests__/registry.test.ts` (17 tests)

**Purpose:** Ensure project registry entries are valid according to Zod schema

**What's tested:**

- Valid project entries pass schema validation
- Invalid entries (missing fields, malformed slugs) are rejected
- Required fields (title, summary, tags, tech stack) are validated
- Date format enforcement (YYYY-MM for startDate/endDate)
- Slug uniqueness is enforced (duplicate slugs rejected)
- Tech stack categories are validated (language, framework, library, tool, platform)
- Evidence links structure is validated

**Key assertions:**

```typescript
it('should accept valid project entries', () => {
  const validProject = {
    slug: 'portfolio-app',
    title: 'Portfolio App',
    summary: 'A comprehensive portfolio application.',
    tags: ['nextjs', 'typescript'],
    // ... other required fields
  };
  expect(ProjectSchema.safeParse(validProject).success).toBe(true);
});

it('should reject projects with invalid slug format', () => {
  const invalid = { slug: 'Invalid Slug!' };
  expect(ProjectSchema.safeParse(invalid).success).toBe(false);
});
```

#### Link Construction Tests

**Files:**

- `src/lib/__tests__/config.test.ts` (18 tests)
- `src/lib/__tests__/linkConstruction.test.ts` (16 tests)

**Purpose:** Ensure URL helpers (`docsUrl()`, `githubUrl()`, `docsGithubUrl()`, `mailtoUrl()`) work correctly

**What's tested:**

1. **docsUrl()**: Builds documentation URLs with `NEXT_PUBLIC_DOCS_BASE_URL`
   - With environment variable configured
   - Fallback to `/docs` when env var missing
   - Leading slash normalization
   - Nested path handling

2. **githubUrl()**: Builds GitHub URLs with `NEXT_PUBLIC_GITHUB_URL`
   - With environment variable configured
   - Placeholder return when env var missing
   - Path normalization

3. **docsGithubUrl()**: Builds documentation GitHub URLs with `NEXT_PUBLIC_DOCS_GITHUB_URL`
   - URL construction from environment variable
   - Fallback behavior

4. **mailtoUrl()**: Builds mailto links with optional subject parameters
   - Email address handling
   - Subject parameter encoding
   - Special character escaping

**Key assertions:**

```typescript
it('should build URL with default base path', () => {
  const result = docsUrl('/portfolio/roadmap');
  expect(result).toBe('/docs/portfolio/roadmap');
});

it('should handle email with subject', () => {
  const result = mailtoUrl('test@example.com', 'Hello World');
  expect(result).toBe('mailto:test@example.com?subject=Hello%20World');
});
```

#### Slug Validation Tests

**File:** `src/lib/__tests__/slugHelpers.test.ts` (19 tests)

**Purpose:** Enforce slug format rules and validate edge cases

**What's tested:**

- Valid slug format: lowercase, hyphens, alphanumeric only
- Regex pattern: `^[a-z0-9]+(?:-[a-z0-9]+)*$`
- Rejection of: uppercase, spaces, special characters, unicode, emoji
- Edge cases: empty strings, single characters, very long slugs
- Multiple consecutive hyphens rejected
- Hyphens at start/end rejected

**Key assertions:**

```typescript
it('should accept valid lowercase slugs', () => {
  expect(isValidSlug('portfolio-app')).toBe(true);
  expect(isValidSlug('my-project-2024')).toBe(true);
});

it('should reject uppercase slugs', () => {
  expect(isValidSlug('Portfolio-App')).toBe(false);
});
```

#### Running Unit Tests

```bash
# All unit tests in watch mode (development)
pnpm test

# Unit tests once (for CI verification)
pnpm test:unit

# With coverage report (outputs to coverage/index.html)
pnpm test:coverage

# Visual UI dashboard (for debugging)
pnpm test:ui

# Debug mode with inspector
pnpm test:debug
```

**Available test suites:**

- `src/lib/__tests__/registry.test.ts` — Registry validation (17 tests)
- `src/lib/__tests__/slugHelpers.test.ts` — Slug format and deduplication (19 tests)
- `src/lib/__tests__/config.test.ts` — Link construction helpers (34 tests)

**CI Integration:**

- Runs in `ci / test` job as prerequisite to build
- Command: `pnpm test:unit`
- Coverage reports uploaded as artifacts
- Build fails if any tests fail
- Must pass ≥80% coverage thresholds (lines, functions, branches, statements)

**Coverage Report:**

After running `pnpm test:coverage`:

- Open `coverage/index.html` in a browser
- Review per-file coverage metrics
- Identify uncovered branches and functions

**Coverage thresholds** (enforced in CI):

- Lines: ≥80%
- Functions: ≥80%
- Branches: ≥75%
- Statements: ≥80%

#### Evidence Links

- **Test Guide:** [docs/70-reference/testing-guide.md](/docs/70-reference/testing-guide.md#unit-testing-with-vitest)
- **PR #XX:** Stage 3.3 unit tests implementation
- **Configuration:** `vitest.config.ts`

### Phase 4: Extended E2E coverage (Stage 3.3 enhanced)

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
- E2E tests pass (58/58 test cases, 2 browsers)
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
