---
title: 'Stage 3.3 — Unit & E2E Tests (App)'
description: 'Implements comprehensive test coverage for registry validation, slug rules, link construction, and evidence link resolution using Vitest and Playwright.'
tags:
  [
    portfolio,
    roadmap,
    planning,
    phase-3,
    stage-3.3,
    app,
    testing,
    vitest,
    playwright,
  ]
---

# Stage 3.3: Unit & E2E Tests — App Implementation

**Type:** Testing / Quality Assurance  
**Phase:** Phase 3 — Scaling & Governance  
**Stage:** 3.3  
**Linked Issue:** [stage-3-3-docs-issue.md](/docs/00-portfolio/roadmap/issues/stage-3-3-docs-issue.md)  
**Duration Estimate:** 4–6 hours  
**Assignee:** GitHub Copilot / Engineering Lead  
**Created:** 2026-01-22  
**Status:** Ready to execute

---

## Overview

This stage adds comprehensive test coverage to enforce registry integrity, slug rules, link construction, and evidence link resolution. After Stage 3.1 (registry) and Stage 3.2 (evidence components) are complete, Stage 3.3 ensures the data-driven architecture is validated at build time and runtime through automated testing.

The test suite—unit tests (Vitest) for registry/schema validation and E2E tests (Playwright) for evidence link resolution—enables reviewers to verify the portfolio's quality gates are production-grade and prevent regressions.

**Why this matters:** Testing is the foundation of enterprise credibility. Automated validation of the registry schema, slug uniqueness, and link integrity ensures projects can be added at scale without introducing broken links or invalid data.

## Objectives

- Add unit tests (Vitest) for registry validation, slug rules, and link construction helpers
- Extend E2E tests (Playwright) to verify evidence link resolution and component rendering
- Integrate tests into CI pipeline with build-blocking enforcement
- Achieve 80%+ code coverage for registry and helper modules
- Document testing patterns for future project additions

---

## Scope

### Files to Create

1. **`src/lib/__tests__/registry.test.ts`** — Registry validation unit tests
   - Test valid project entries pass schema validation
   - Test invalid entries (missing fields, malformed slugs) are rejected
   - Test slug uniqueness enforcement
   - Test required field validation (title, description, tech stack, proofs)

2. **`src/lib/__tests__/slugHelpers.test.ts`** — Slug validation unit tests
   - Test slug format enforcement: `^[a-z0-9]+(?:-[a-z0-9]+)*$`
   - Test slug deduplication logic
   - Test edge cases: empty strings, special characters, uppercase

3. **`src/lib/__tests__/linkConstruction.test.ts`** — Link helper unit tests
   - Test `docsUrl()` builds correct URLs with environment variable
   - Test `githubUrl()` builds correct GitHub URLs
   - Test edge cases: missing base URLs, trailing slashes, relative paths

4. **`e2e/evidence-links.spec.ts`** — Evidence link resolution E2E tests
   - Test project pages render EvidenceBlock component
   - Test all evidence links resolve (dossier, threat model, ADRs, runbooks)
   - Test BadgeGroup displays correct badges based on evidence presence
   - Test responsive design (mobile/tablet/desktop)

5. **`vitest.config.ts`** — Vitest configuration
   - TypeScript support via `ts-node` or `tsx`
   - Coverage reporting with Istanbul
   - Test environment: Node.js
   - Path aliases matching `tsconfig.json`

### Files to Update

1. **`package.json`** — Add test scripts and dependencies
   - Add script: `"test": "vitest"`
   - Add script: `"test:unit": "vitest run"`
   - Add script: `"test:coverage": "vitest run --coverage"`
   - Add script: `"test:ui": "vitest --ui"`
   - Add dev dependencies: `vitest`, `@vitest/ui`, `@vitest/coverage-v8`

2. **`.github/workflows/ci.yml`** — Integrate tests into CI pipeline
   - Add test job before build job
   - Run `pnpm test:unit` (unit tests)
   - Run `pnpm playwright test` (E2E tests)
   - Fail build if any tests fail
   - Upload coverage reports to GitHub Actions artifacts

3. **`playwright.config.ts`** — Enhance Playwright configuration
   - Add new test file: `e2e/evidence-links.spec.ts`
   - Ensure multi-browser coverage (Chromium, Firefox, WebKit)
   - Configure baseURL for local and CI environments
   - Enable trace on first retry for debugging

4. **`.gitignore`** — Ignore test artifacts
   - Add `coverage/` (Vitest coverage reports)
   - Add `.vitest/` (Vitest cache)
   - Add `test-results/` (Playwright results, if not already present)

### Dependencies to Add

- `vitest` (dev) — Fast unit test runner with native ESM support
- `@vitest/ui` (dev) — Visual UI for test exploration
- `@vitest/coverage-v8` (dev) — Code coverage via V8
- `@types/node` (dev) — Node.js type definitions (if not present)

### Dependencies to Remove

None (no dependencies need removal for this stage)

---

## Design & Architecture

### Testing Strategy Overview

```
┌─────────────────────────────────────────────────────────────┐
│                     Testing Pyramid                          │
├─────────────────────────────────────────────────────────────┤
│  E2E Tests (Playwright)                                      │
│  ├─ Evidence link resolution                                 │
│  ├─ Component rendering (EvidenceBlock, BadgeGroup)          │
│  └─ Route coverage (all project pages)                       │
├─────────────────────────────────────────────────────────────┤
│  Integration Tests (Future: API routes, data fetching)       │
├─────────────────────────────────────────────────────────────┤
│  Unit Tests (Vitest)                                         │
│  ├─ Registry validation (Zod schema)                         │
│  ├─ Slug helpers (format, uniqueness)                        │
│  ├─ Link construction (docsUrl, githubUrl)                   │
│  └─ Tech stack parsing (if applicable)                       │
└─────────────────────────────────────────────────────────────┘
```

### Unit Test Architecture

**Module:** `src/lib/registry.ts`

```typescript
// Example test structure for registry validation
describe('Registry Validation', () => {
  it('should accept valid project entries', () => {
    const validProject = {
      /* valid schema */
    };
    expect(() => validateProject(validProject)).not.toThrow();
  });

  it('should reject projects with invalid slugs', () => {
    const invalidProject = { slug: 'Invalid Slug!' };
    expect(() => validateProject(invalidProject)).toThrow();
  });

  it('should enforce slug uniqueness', () => {
    const duplicateSlugs = [
      { slug: 'portfolio-app', title: 'Project 1' },
      { slug: 'portfolio-app', title: 'Project 2' },
    ];
    expect(() => validateRegistry(duplicateSlugs)).toThrow(/duplicate slug/i);
  });
});
```

**Module:** `src/lib/config.ts` (link construction helpers)

```typescript
// Example test structure for link helpers
describe('Link Construction Helpers', () => {
  it('should build docsUrl with environment variable', () => {
    process.env.NEXT_PUBLIC_DOCS_BASE_URL = 'https://docs.example.com';
    expect(docsUrl('/portfolio/roadmap')).toBe(
      'https://docs.example.com/docs/portfolio/roadmap'
    );
  });

  it('should handle missing environment variable gracefully', () => {
    delete process.env.NEXT_PUBLIC_DOCS_BASE_URL;
    expect(docsUrl('/portfolio/roadmap')).toBe('/docs/portfolio/roadmap');
  });
});
```

### E2E Test Architecture

**Test File:** `e2e/evidence-links.spec.ts`

```typescript
// Example E2E test structure
import { test, expect } from '@playwright/test';

test.describe('Evidence Link Resolution', () => {
  test('portfolio-app project page renders evidence block', async ({
    page,
  }) => {
    await page.goto('/projects/portfolio-app');

    // Verify EvidenceBlock component renders
    await expect(page.locator('text=Evidence Artifacts')).toBeVisible();

    // Verify all evidence categories present
    await expect(page.locator('text=Dossier')).toBeVisible();
    await expect(page.locator('text=Threat Model')).toBeVisible();
    await expect(page.locator('text=ADRs')).toBeVisible();
  });

  test('evidence links resolve to correct URLs', async ({ page }) => {
    await page.goto('/projects/portfolio-app');

    // Click dossier link and verify navigation
    const dossierLink = page
      .locator('a[href*="/docs/projects/portfolio-app"]')
      .first();
    await expect(dossierLink).toHaveAttribute(
      'href',
      expect.stringContaining('portfolio-app')
    );
  });

  test('BadgeGroup displays correct badges', async ({ page }) => {
    await page.goto('/projects/portfolio-app');

    // Verify gold standard badge present
    await expect(page.locator('text=Gold Standard')).toBeVisible();
    await expect(page.locator('text=Docs Available')).toBeVisible();
  });
});
```

---

## Validation Rules & Constraints

### Registry Validation Rules (Unit Tests Must Enforce)

1. **Slug Format:** `^[a-z0-9]+(?:-[a-z0-9]+)*$`
   - Valid: `portfolio-app`, `my-project-2024`
   - Invalid: `My Project`, `project_name`, `Project-App` (uppercase)
   - Error: "Slug must be lowercase with hyphens only"

2. **Slug Uniqueness:** No duplicate slugs in registry
   - Enforcement: Registry loader rejects duplicate slugs
   - Error: "Duplicate slug detected: `[slug]`"

3. **Required Fields:** title, description, slug, tech stack (≥1), proofs (≥1)
   - Enforcement: Zod schema validation
   - Error: "Missing required field: `[field]`"

4. **URL Validation:** Evidence links must be valid URLs or relative paths
   - Enforcement: Zod `.url()` or `.string()` with pattern validation
   - Error: "Invalid URL format: `[url]`"

### E2E Test Coverage Requirements

1. **Route Coverage:** All project pages must render without errors
2. **Component Rendering:** EvidenceBlock and BadgeGroup must display
3. **Link Resolution:** All evidence links must resolve (no 404s)
4. **Responsive Design:** Components must render correctly on mobile/tablet/desktop

---

## Implementation Tasks

### Phase 1: Vitest Setup & Registry Unit Tests (1.5–2 hours)

**Description:** Configure Vitest and write unit tests for registry validation, slug rules, and schema enforcement.

#### Tasks

- [x] Install Vitest and coverage dependencies
  - Run: `pnpm add -D vitest @vitest/ui @vitest/coverage-v8`
  - Files: `package.json`

- [x] Create Vitest configuration
  - File: `vitest.config.ts`
  - Configure TypeScript support, path aliases, coverage
  - Example:

    ```typescript
    import { defineConfig } from 'vitest/config';
    import path from 'path';

    export default defineConfig({
      test: {
        environment: 'node',
        coverage: {
          provider: 'v8',
          reporter: ['text', 'json', 'html'],
          include: ['src/lib/**/*.ts'],
        },
      },
      resolve: {
        alias: {
          '@': path.resolve(__dirname, './src'),
        },
      },
    });
    ```

- [x] Write registry validation tests
  - File: `src/lib/__tests__/registry.test.ts`
  - Test valid project entries pass schema
  - Test invalid entries are rejected (missing fields, malformed slugs)
  - Test slug uniqueness enforcement
  - Test required field validation

- [x] Write slug helper tests
  - File: `src/lib/__tests__/slugHelpers.test.ts`
  - Test slug format regex: `^[a-z0-9]+(?:-[a-z0-9]+)*$`
  - Test deduplication logic
  - Test edge cases: empty strings, uppercase, special characters

- [x] Run unit tests locally
  - Run: `pnpm test:unit`
  - Verify all tests pass
  - Check coverage: `pnpm test:coverage`

#### Success Criteria for This Phase

- [x] Vitest configured and runs successfully
- [x] Registry validation tests cover valid/invalid cases
- [x] Slug helper tests enforce format rules
- [x] Unit tests pass: `pnpm test:unit` exits 0
- [x] Code coverage ≥80% for `src/lib/registry.ts`

---

### Phase 2: Link Construction Unit Tests (1–1.5 hours)

**Description:** Write unit tests for link construction helpers (docsUrl, githubUrl) to ensure environment-safe URL building.

#### Tasks

- [x] Write link construction tests
  - File: `src/lib/__tests__/linkConstruction.test.ts`
  - Test `docsUrl()` with environment variable
  - Test `docsUrl()` fallback when env var missing
  - Test `githubUrl()` builds correct GitHub URLs
  - Test edge cases: trailing slashes, relative paths, missing base URLs

- [x] Test environment variable handling
  - Mock `process.env.NEXT_PUBLIC_DOCS_BASE_URL`
  - Verify URL construction with/without env var
  - Example:

    ```typescript
    describe('docsUrl Helper', () => {
      beforeEach(() => {
        process.env.NEXT_PUBLIC_DOCS_BASE_URL = 'https://docs.example.com';
      });

      it('builds URL with env variable', () => {
        expect(docsUrl('/portfolio/roadmap')).toBe(
          'https://docs.example.com/docs/portfolio/roadmap'
        );
      });

      it('handles missing env variable', () => {
        delete process.env.NEXT_PUBLIC_DOCS_BASE_URL;
        expect(docsUrl('/portfolio/roadmap')).toBe('/docs/portfolio/roadmap');
      });
    });
    ```

- [x] Run unit tests and verify coverage
  - Run: `pnpm test:unit`
  - Check coverage: `pnpm test:coverage`
  - Ensure `src/lib/config.ts` has ≥80% coverage

#### Success Criteria for This Phase

- [x] Link construction tests cover all helpers
- [x] Environment variable mocking works correctly
- [x] Edge cases tested (missing base URL, trailing slashes)
- [x] All unit tests pass
- [x] Code coverage ≥80% for `src/lib/config.ts`

---

### Phase 3: E2E Evidence Link Tests (1.5–2 hours)

**Description:** Extend Playwright E2E tests to verify evidence link resolution, component rendering, and responsive design.

#### Tasks

- [x] Create evidence link E2E test file
  - File: `e2e/evidence-links.spec.ts`
  - Test project pages render EvidenceBlock component
  - Test all evidence links resolve (dossier, threat model, ADRs, runbooks)
  - Test BadgeGroup displays correct badges
  - Test responsive design (viewport sizes: mobile, tablet, desktop)

- [x] Test EvidenceBlock rendering
  - Navigate to `/projects/portfolio-app`
  - Verify "Evidence Artifacts" heading visible
  - Verify all 5 evidence categories render (Dossier, Threat Model, ADRs, Runbooks, GitHub)
  - Example:

    ```typescript
    test('EvidenceBlock renders all categories', async ({ page }) => {
      await page.goto('/projects/portfolio-app');
      await expect(page.locator('text=Evidence Artifacts')).toBeVisible();
      await expect(page.locator('text=Dossier')).toBeVisible();
      await expect(page.locator('text=Threat Model')).toBeVisible();
      await expect(page.locator('text=ADRs')).toBeVisible();
      await expect(page.locator('text=Runbooks')).toBeVisible();
      await expect(page.locator('text=GitHub Repository')).toBeVisible();
    });
    ```

- [x] Test BadgeGroup rendering
  - Verify gold standard badge displays for portfolio-app
  - Verify "Docs Available" badge displays when dossier exists
  - Verify "Threat Model" badge displays when threat model exists
  - Verify "ADR Complete" badge displays when ADRs exist

- [x] Test responsive design
  - Test mobile viewport (390px): 1 column layout
  - Test tablet viewport (768px): 2 column layout
  - Test desktop viewport (1440px): 3 column layout
  - Example:

    ```typescript
    test('EvidenceBlock responsive on mobile', async ({ page }) => {
      await page.setViewportSize({ width: 390, height: 844 });
      await page.goto('/projects/portfolio-app');
      // Verify grid has 1 column
      const grid = page.locator('[class*="grid-cols-1"]');
      await expect(grid).toBeVisible();
    });
    ```

- [x] Run E2E tests locally
  - Run: `pnpm playwright test`
  - Verify all tests pass
  - Check test report: `pnpm playwright show-report`

#### Success Criteria for This Phase

- [x] E2E tests cover evidence link resolution
- [x] Component rendering tests pass (EvidenceBlock, BadgeGroup)
- [x] Responsive design tests pass (3 viewport sizes)
- [x] All E2E tests pass: `pnpm playwright test` exits 0
- [x] Test report shows 100% route coverage for project pages

---

### Phase 4: CI Integration & Coverage Reporting (1 hour)

**Description:** Wire unit and E2E tests into CI pipeline with build-blocking enforcement and coverage reporting.

#### Tasks

- [x] Update CI workflow with test jobs
  - File: `.github/workflows/ci.yml`
  - Add `test` job before `build` job
  - Run unit tests: `pnpm test:unit`
  - Run E2E tests: `pnpm playwright test`
  - Upload coverage reports as artifacts

- [x] Configure test job dependencies
  - Ensure `build` job depends on `test` job passing
  - Example:

    ```yaml
    test:
      runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v4
        - uses: pnpm/action-setup@v2
        - uses: actions/setup-node@v4
          with:
            node-version: 20
            cache: 'pnpm'
        - run: pnpm install --frozen-lockfile
        - run: pnpm test:unit
        - run: pnpm playwright install --with-deps
        - run: pnpm playwright test
        - uses: actions/upload-artifact@v4
          if: always()
          with:
            name: coverage-report
            path: coverage/
    ```

- [x] Add test scripts to package.json
  - Add: `"test": "vitest"`
  - Add: `"test:unit": "vitest run"`
  - Add: `"test:coverage": "vitest run --coverage"`
  - Add: `"test:ui": "vitest --ui"`

- [x] Update `.gitignore` with test artifacts
  - Add: `coverage/`
  - Add: `.vitest/`
  - Verify: `test-results/` already present (Playwright)

- [x] Test CI pipeline locally
  - Run: `pnpm test:unit` (verify passes)
  - Run: `pnpm playwright test` (verify passes)
  - Commit changes and push to feature branch
  - Verify CI pipeline runs and passes

#### Success Criteria for This Phase

- [x] CI workflow includes test job
- [x] Build job depends on test job passing
- [x] Coverage reports uploaded to GitHub Actions
- [x] `.gitignore` excludes test artifacts
- [x] CI pipeline passes on feature branch

---

## Testing Strategy

### Unit Tests (Vitest)

**Scope:** Registry validation, slug rules, link construction helpers

**Coverage Target:** ≥80% for `src/lib/registry.ts`, `src/lib/config.ts`

**Test Categories:**

1. **Registry Validation:**
   - Valid project entries pass schema
   - Invalid entries rejected (missing fields, malformed data)
   - Slug uniqueness enforced
   - Required fields validated

2. **Slug Helpers:**
   - Format validation: lowercase, hyphens only
   - Deduplication logic
   - Edge cases: empty strings, special characters

3. **Link Construction:**
   - `docsUrl()` with environment variable
   - `githubUrl()` builds correct URLs
   - Fallback behavior when env vars missing

### E2E Tests (Playwright)

**Scope:** Evidence link resolution, component rendering, responsive design

**Coverage Target:** 100% route coverage for project pages

**Test Categories:**

1. **Component Rendering:**
   - EvidenceBlock displays all 5 evidence categories
   - BadgeGroup displays correct badges based on evidence presence

2. **Link Resolution:**
   - All evidence links resolve (no 404s)
   - Links navigate to correct URLs

3. **Responsive Design:**
   - Mobile (390px): 1 column layout
   - Tablet (768px): 2 column layout
   - Desktop (1440px): 3 column layout

### Test Commands

```bash
# Run all tests
pnpm test

# Run unit tests only
pnpm test:unit

# Run unit tests with coverage
pnpm test:coverage

# Run E2E tests
pnpm playwright test

# Run E2E tests with UI
pnpm playwright test --ui

# View test coverage report
open coverage/index.html
```

---

## Acceptance Criteria

This stage is complete when:

- [x] Vitest configured and integrated
- [x] Unit tests written for registry validation, slug helpers, link construction
- [x] E2E tests written for evidence link resolution and component rendering
- [x] All unit tests pass: `pnpm test:unit` exits 0
- [x] All E2E tests pass: `pnpm playwright test` exits 0
- [x] Code coverage ≥80% for `src/lib/registry.ts` and `src/lib/config.ts`
- [x] CI pipeline includes test job (unit + E2E)
- [x] Build job depends on test job passing
- [x] Coverage reports uploaded to GitHub Actions
- [x] `.gitignore` excludes test artifacts
- [x] No TypeScript errors: `pnpm typecheck`
- [x] No ESLint violations: `pnpm lint`
- [x] Production build succeeds: `pnpm build`

---

## Code Quality Standards

All tests must meet:

- **TypeScript:** Strict mode enabled; full type annotations for test helpers
- **Test Structure:** Descriptive test names; clear arrange/act/assert pattern
- **Coverage:** ≥80% for registry and helper modules
- **Assertions:** Specific assertions; avoid generic `toBeTruthy()`
- **Mocking:** Mock environment variables and external dependencies where appropriate
- **Documentation:** Complex test logic explained with comments

---

## Deployment & CI/CD

### CI Pipeline Integration

- [x] Test job runs before build job
- [x] Unit tests run: `pnpm test:unit`
- [x] E2E tests run: `pnpm playwright test`
- [x] Coverage reports uploaded as artifacts
- [x] Build fails if any tests fail

### Environment Variables / Configuration

**Vitest Configuration:**

```typescript
// vitest.config.ts
export default defineConfig({
  test: {
    environment: 'node',
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
      include: ['src/lib/**/*.ts'],
    },
  },
});
```

**Playwright Configuration:**

```typescript
// playwright.config.ts (update)
export default defineConfig({
  testDir: './e2e',
  fullyParallel: true,
  projects: [
    { name: 'chromium', use: { ...devices['Desktop Chrome'] } },
    { name: 'firefox', use: { ...devices['Desktop Firefox'] } },
    { name: 'webkit', use: { ...devices['Desktop Safari'] } },
  ],
});
```

### Rollback Plan

- Quick rollback: Revert test additions via `git revert`
- No data migration concerns (tests are code-only)
- No config rollback needed (tests are additive)

---

## Dependencies & Blocking

### Depends On

- [x] Stage 3.1 complete: Registry implementation with validation
- [x] Stage 3.2 complete: EvidenceBlock and BadgeGroup components

### Blocks

- [x] Stage 3.4: ADRs & Documentation (testing patterns documented)
- [x] Stage 3.5: CI Link Validation (tests integrated into CI)

### Related Work

- Related documentation: [Phase 3 Implementation Guide](docs/00-portfolio/roadmap/phase-3-implementation-guide.md#stage-33-unit--e2e-tests-46-hours)

---

## Performance & Optimization Considerations

**Test Performance:**

- Unit tests should run in < 5 seconds
- E2E tests should run in < 30 seconds per browser
- Parallel execution enabled for E2E tests

**Optimization Strategies:**

- Use Vitest's watch mode for local development
- Run E2E tests in parallel across browsers
- Cache dependencies in CI (pnpm cache, Playwright browsers)

---

## Security Considerations

- [x] No secrets in test files
- [x] Mock environment variables for testing
- [x] No sensitive data in test fixtures
- [x] Test coverage reports do not expose secrets

---

## Effort Breakdown

| Phase     | Task                          | Hours      | Notes                    |
| --------- | ----------------------------- | ---------- | ------------------------ |
| 1         | Vitest setup & registry tests | 1.5–2h     | Install, config, write   |
| 2         | Link construction tests       | 1–1.5h     | Helpers, env vars        |
| 3         | E2E evidence link tests       | 1.5–2h     | Playwright, responsive   |
| 4         | CI integration & coverage     | 1h         | Workflow, artifacts      |
| **Total** | **Stage 3.3**                 | **5–6.5h** | **Within 4–6h estimate** |
