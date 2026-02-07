---
title: 'Stage 3.3 — Unit & E2E Tests (Docs)'
description: 'Documents the testing strategy, updates Portfolio App dossier with testing approach, and provides reference guides for testing patterns.'
tags:
  [
    portfolio,
    roadmap,
    planning,
    phase-3,
    stage-3.3,
    docs,
    documentation,
    testing,
  ]
---

# Stage 3.3: Unit & E2E Tests — Documentation

**Type:** Documentation / Reference  
**Phase:** Phase 3 — Scaling & Governance  
**Stage:** 3.3  
**Linked Issue:** [stage-3-3-app-issue.md](/docs/00-portfolio/roadmap/issues/stage-3-3-app-issue.md)  
**Duration Estimate:** 2–3 hours  
**Assignee:** GitHub Copilot / Engineering Lead  
**Created:** 2026-01-22  
**Status:** Ready to execute

---

## Overview

This stage complements the app testing implementation ([stage-3-3-app-issue.md](/docs/00-portfolio/roadmap/issues/stage-3-3-app-issue.md)) by documenting the testing strategy, updating the Portfolio App dossier with testing architecture, and providing reference guides for writing tests.

While the app work creates unit tests (Vitest) and E2E tests (Playwright) for registry validation and evidence link resolution, this docs work ensures reviewers understand:

- **Why** testing is critical (quality gates, regression prevention, enterprise credibility)
- **What** is tested (registry schema, slug rules, link construction, evidence links)
- **How** to write tests (patterns, best practices, examples)
- **Where** tests fit in the CI pipeline (build-blocking enforcement)

**Why this matters:** Testing documentation builds reviewer confidence that the portfolio's quality gates are production-grade and not aspirational. Clear testing guides enable future project additions without degrading quality.

## Objectives

- Update Portfolio App dossier with testing architecture and strategy
- Document testing patterns for registry validation and E2E tests
- Provide reference guide for writing tests (Vitest and Playwright)
- Update CI/CD documentation with test integration details
- Ensure testing approach aligns with enterprise SDLC standards

---

## Scope

### Files to Create

1. **`docs/70-reference/testing-guide.md`** — Comprehensive testing reference
   - Testing strategy overview (unit, integration, E2E)
   - Vitest patterns for registry validation
   - Playwright patterns for evidence link resolution
   - Running tests locally and in CI
   - Troubleshooting common test failures

### Files to Update

1. **`docs/60-projects/portfolio-app/02-architecture.md`** — Architecture deep-dive
   - Add subsection: "Testing Architecture (Stage 3.3)"
   - Document testing pyramid (unit → integration → E2E)
   - Explain test coverage targets and enforcement
   - Link to testing guide for patterns

2. **`docs/60-projects/portfolio-app/05-testing.md`** — Testing page
   - Update with Stage 3.3 test suite details
   - Add section: "Registry Validation Tests (Vitest)"
   - Add section: "Evidence Link Resolution Tests (Playwright)"
   - Document CI integration and coverage reporting
   - Provide examples of running tests locally

3. **`docs/30-devops-platform/ci-cd/pipeline-overview.md`** — CI/CD pipeline
   - Update with test job details
   - Explain test job dependencies (test → build)
   - Document coverage reporting and artifacts
   - Show example CI output for test failures

4. **`.github/copilot-instructions.md`** (portfolio-app) — Copilot instructions
   - Add testing patterns section
   - Document test file naming conventions
   - Provide templates for unit and E2E tests
   - Explain coverage expectations

### Files to NOT Update

- **No new ADRs needed:** Testing is an implementation detail, not an architectural decision (testing is expected in Phase 3)
- **No new runbooks:** Testing is part of development workflow, not operational procedure
- **No threat model updates:** Tests do not introduce new attack surface or trust boundaries

---

## Content Structure & Design

### Document Type & Template

**Type:** Reference Guide + Dossier Updates

**Audience:** Engineers adding projects, code reviewers evaluating quality, architects assessing maturity

**Front Matter (new testing guide):**

```yaml
---
title: 'Testing Guide'
description: 'Comprehensive guide to writing unit tests (Vitest) and E2E tests (Playwright) for the Portfolio App.'
sidebar_position: 10
tags: [testing, vitest, playwright, quality, ci-cd]
---
```

### Content Outline

#### 1. New File: `docs/70-reference/testing-guide.md`

**Purpose:** Provide comprehensive testing patterns and examples for portfolio-app contributors.

**Structure:**

````markdown
# Testing Guide

## Purpose

This guide provides patterns and examples for writing tests in the Portfolio App.

## Testing Strategy

### Testing Pyramid

[Diagram showing unit → integration → E2E layers]

### Coverage Targets

- Unit tests: ≥80% for `src/lib/` modules
- E2E tests: 100% route coverage

## Unit Testing with Vitest

### Setup

[How to install and configure Vitest]

### Writing Registry Tests

[Examples of testing registry validation]

```typescript
// Example test
describe('Registry Validation', () => {
  it('should enforce slug uniqueness', () => {
    // test implementation
  });
});
```
````

### Writing Link Construction Tests

[Examples of testing docsUrl() and githubUrl()]

### Running Unit Tests

```bash
# All unit tests
pnpm test:unit

# Watch mode
pnpm test

# With coverage
pnpm test:coverage
```

## E2E Testing with Playwright

### Setup

[How to install and configure Playwright]

### Writing Evidence Link Tests

[Examples of testing EvidenceBlock rendering]

```typescript
// Example test
test('evidence block renders', async ({ page }) => {
  await page.goto('/projects/portfolio-app');
  await expect(page.locator('text=Evidence Artifacts')).toBeVisible();
});
```

### Running E2E Tests

```bash
# All E2E tests
pnpm playwright test

# Interactive UI
pnpm playwright test --ui

# Specific browser
pnpm playwright test --project=chromium
```

## CI Integration

[How tests run in GitHub Actions]

## Troubleshooting

### Common Issues

[Solutions to common test failures]

````

#### 2. Update: `docs/60-projects/portfolio-app/02-architecture.md`

**Addition:** Create new subsection after "Evidence Visualization Layer (Stage 3.2)"

```markdown
### Testing Architecture (Stage 3.3)

#### Overview

After Stage 3.2 established evidence visualization components, Stage 3.3 adds comprehensive test coverage to ensure registry integrity and link resolution. The testing architecture follows the testing pyramid: unit tests (Vitest) for business logic, E2E tests (Playwright) for user-facing behavior.

#### Testing Pyramid

````

┌─────────────────────────────────────────┐
│ E2E Tests (Playwright) │
│ - Evidence link resolution │
│ - Component rendering │
│ - Route coverage │
├─────────────────────────────────────────┤
│ Integration Tests (Future) │
├─────────────────────────────────────────┤
│ Unit Tests (Vitest) │
│ - Registry validation │
│ - Slug helpers │
│ - Link construction │
└─────────────────────────────────────────┘

````

#### Unit Tests (Vitest)

**Purpose:** Validate registry schema, slug rules, and link construction helpers

**Modules Tested:**

- `src/lib/registry.ts`: Zod schema validation, slug uniqueness
- `src/lib/config.ts`: docsUrl(), githubUrl() helpers
- `src/lib/slugHelpers.ts`: Slug format enforcement

**Coverage Target:** ≥80% for all `src/lib/` modules

**Example Test:**

```typescript
describe('Registry Validation', () => {
  it('should enforce slug format', () => {
    const invalidSlug = 'Invalid Slug!';
    expect(() => validateSlug(invalidSlug)).toThrow(/lowercase.*hyphens/i);
  });
});
````

#### E2E Tests (Playwright)

**Purpose:** Verify evidence link resolution, component rendering, and responsive design

**Routes Tested:**

- All project pages: `/projects/[slug]`
- Evidence link navigation
- Component rendering (EvidenceBlock, BadgeGroup)

**Coverage Target:** 100% route coverage

**Example Test:**

```typescript
test('evidence block renders all categories', async ({ page }) => {
  await page.goto('/projects/portfolio-app');
  await expect(page.locator('text=Dossier')).toBeVisible();
  await expect(page.locator('text=Threat Model')).toBeVisible();
});
```

#### CI Integration

Tests run in GitHub Actions before build:

1. **Test Job:** Runs unit and E2E tests
2. **Build Job:** Depends on test job passing
3. **Coverage Reports:** Uploaded as GitHub Actions artifacts

**Build Blocking:** Merge is blocked if any tests fail

#### Design Decisions

1. **Why Vitest over Jest?**
   - Native ESM support (Next.js 15 App Router)
   - Faster execution (Vite's transform pipeline)
   - Better TypeScript integration

2. **Why Playwright over Cypress?**
   - Multi-browser support (Chromium, Firefox, WebKit)
   - Better CI integration (GitHub Actions optimized)
   - Faster test execution

3. **Why ≥80% coverage target?**
   - Balance between quality and development speed
   - Focus on critical paths (registry, link construction)
   - Avoid test maintenance burden for trivial code

#### See Also

- **Testing Guide:** [docs/70-reference/testing-guide.md](/docs/70-reference/testing-guide.md)
- **Testing Dossier:** [docs/60-projects/portfolio-app/05-testing.md](/docs/60-projects/portfolio-app/05-testing.md)
- **Implementation:** [stage-3-3-app-issue.md](/docs/00-portfolio/roadmap/issues/stage-3-3-app-issue.md)

````

#### 3. Update: `docs/60-projects/portfolio-app/05-testing.md`

**Addition:** Expand existing testing page with Stage 3.3 details

```markdown
### Registry Validation Tests (Vitest)

**Purpose:** Ensure registry schema, slug rules, and link construction are validated at build time.

**Test Suites:**

1. **Registry Schema Tests** (`src/lib/__tests__/registry.test.ts`)
   - Valid project entries pass schema validation
   - Invalid entries rejected (missing fields, malformed data)
   - Slug uniqueness enforced
   - Required fields validated

2. **Slug Helper Tests** (`src/lib/__tests__/slugHelpers.test.ts`)
   - Slug format: `^[a-z0-9]+(?:-[a-z0-9]+)*$`
   - Deduplication logic
   - Edge cases: empty strings, uppercase, special characters

3. **Link Construction Tests** (`src/lib/__tests__/linkConstruction.test.ts`)
   - `docsUrl()` with environment variable
   - `githubUrl()` builds correct URLs
   - Fallback behavior when env vars missing

**Running Tests:**

```bash
# All unit tests
pnpm test:unit

# Watch mode (local development)
pnpm test

# With coverage report
pnpm test:coverage
````

**Coverage Report:**

After running `pnpm test:coverage`, view coverage in `coverage/index.html`:

- ✅ `src/lib/registry.ts`: 85% coverage
- ✅ `src/lib/config.ts`: 90% coverage
- ✅ `src/lib/slugHelpers.ts`: 95% coverage

### Evidence Link Resolution Tests (Playwright)

**Purpose:** Verify evidence links resolve correctly and components render as expected.

**Test Suites:**

1. **Evidence Link Tests** (`e2e/evidence-links.spec.ts`)
   - EvidenceBlock component renders all 5 categories
   - All evidence links resolve (dossier, threat model, ADRs, runbooks)
   - BadgeGroup displays correct badges based on evidence presence
   - Responsive design (mobile/tablet/desktop viewports)

**Example Test:**

```typescript
test('portfolio-app evidence block renders', async ({ page }) => {
  await page.goto('/projects/portfolio-app');

  // Verify component renders
  await expect(page.locator('text=Evidence Artifacts')).toBeVisible();

  // Verify all categories present
  await expect(page.locator('text=Dossier')).toBeVisible();
  await expect(page.locator('text=Threat Model')).toBeVisible();
  await expect(page.locator('text=ADRs')).toBeVisible();
  await expect(page.locator('text=Runbooks')).toBeVisible();
  await expect(page.locator('text=GitHub Repository')).toBeVisible();
});
```

**Running Tests:**

```bash
# All E2E tests
pnpm playwright test

# Interactive UI mode
pnpm playwright test --ui

# Specific browser only
pnpm playwright test --project=chromium

# View test report
pnpm playwright show-report
```

### CI Integration

**Test Job in GitHub Actions:**

The CI pipeline includes a `test` job that runs before the `build` job:

```yaml
test:
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@v4
    - uses: pnpm/action-setup@v2
    - uses: actions/setup-node@v4
    - run: pnpm install --frozen-lockfile
    - run: pnpm test:unit
    - run: pnpm playwright install --with-deps
    - run: pnpm playwright test
    - uses: actions/upload-artifact@v4
      with:
        name: coverage-report
        path: coverage/
```

**Build Blocking:**

The `build` job depends on the `test` job:

```yaml
build:
  needs: test
  runs-on: ubuntu-latest
  # ...
```

This ensures the build fails if any tests fail, preventing broken code from merging.

### Coverage Reporting

**Coverage Targets:**

- Unit tests: ≥80% for `src/lib/` modules
- E2E tests: 100% route coverage

**Viewing Coverage:**

1. Run: `pnpm test:coverage`
2. Open: `coverage/index.html`
3. Review: Per-file coverage metrics

**CI Coverage:**

Coverage reports are uploaded to GitHub Actions artifacts for each PR. Reviewers can download and inspect coverage before merging.

````

#### 4. Update: `docs/30-devops-platform/ci-cd/pipeline-overview.md`

**Addition:** Add test job details to CI/CD pipeline documentation

```markdown
### Test Job (Stage 3.3)

**Purpose:** Run unit and E2E tests before build to enforce quality gates

**Steps:**

1. Checkout code
2. Install dependencies: `pnpm install --frozen-lockfile`
3. Run unit tests: `pnpm test:unit`
4. Install Playwright browsers: `pnpm playwright install --with-deps`
5. Run E2E tests: `pnpm playwright test`
6. Upload coverage reports as artifacts

**Dependencies:**

The `build` job depends on the `test` job passing. If any tests fail, the build is blocked.

**Coverage Reporting:**

Coverage reports are uploaded to GitHub Actions artifacts for review. Download from the "Artifacts" section of the workflow run.

**Example Test Output:**

````

✓ src/lib/**tests**/registry.test.ts (12 tests) 450ms
✓ src/lib/**tests**/slugHelpers.test.ts (8 tests) 120ms
✓ src/lib/**tests**/linkConstruction.test.ts (6 tests) 90ms

Test Files 3 passed (3)
Tests 26 passed (26)
Start at 10:15:32
Duration 1.2s

```

```

#### 5. Update: `.github/copilot-instructions.md` (portfolio-app)

**Addition:** Add testing patterns section

````markdown
## Testing Patterns (Stage 3.3)

### Test File Naming

- Unit tests: `src/lib/__tests__/[module].test.ts`
- E2E tests: `e2e/[feature].spec.ts`

### Unit Test Template (Vitest)

```typescript
import { describe, it, expect } from 'vitest';
import { functionToTest } from '../module';

describe('Module Name', () => {
  describe('functionToTest', () => {
    it('should [behavior description]', () => {
      // Arrange
      const input = 'test-input';

      // Act
      const result = functionToTest(input);

      // Assert
      expect(result).toBe('expected-output');
    });

    it('should handle edge case: [description]', () => {
      // test implementation
    });
  });
});
```
````

### E2E Test Template (Playwright)

```typescript
import { test, expect } from '@playwright/test';

test.describe('Feature Name', () => {
  test('should [user-facing behavior]', async ({ page }) => {
    // Navigate
    await page.goto('/route');

    // Interact
    await page.click('button');

    // Assert
    await expect(page.locator('text=Expected Result')).toBeVisible();
  });
});
```

### Coverage Expectations

- All `src/lib/` modules: ≥80% coverage
- All routes: 100% E2E coverage
- Run `pnpm test:coverage` before creating PR

---

## Integration with Existing Docs

### Cross-References

**Links to:**

- Testing Guide: [docs/70-reference/testing-guide.md](/docs/70-reference/testing-guide.md)
- Testing Dossier: [docs/60-projects/portfolio-app/05-testing.md](/docs/60-projects/portfolio-app/05-testing.md)
- CI/CD Pipeline: [docs/devops-platform/ci-cd-pipeline-overview.md](/docs/devops-platform/ci-cd-pipeline-overview)

**Referenced by:**

- Architecture page: [docs/60-projects/portfolio-app/02-architecture.md](/docs/60-projects/portfolio-app/02-architecture.md)
- Copilot instructions: `.github/copilot-instructions.md`

**Update required in:**

- Portfolio App overview: Add mention of Stage 3.3 testing in "Quality Standards" section
- Roadmap: Mark Stage 3.3 complete after implementation

---

## Implementation Tasks

### Phase 1: Create Testing Guide (1–1.5 hours)

**Description:** Write comprehensive testing reference guide with Vitest and Playwright patterns.

#### Tasks

- [ ] Create `docs/70-reference/testing-guide.md`
  - Testing strategy overview
  - Testing pyramid diagram
  - Vitest setup and patterns
  - Playwright setup and patterns
  - Running tests locally and in CI
  - Troubleshooting common failures

- [ ] Add examples for registry validation tests
  - Show how to test valid/invalid project entries
  - Show how to test slug uniqueness
  - Show how to test required field validation

- [ ] Add examples for E2E tests
  - Show how to test component rendering
  - Show how to test evidence link resolution
  - Show how to test responsive design

- [ ] Build and verify links
  - Run: `pnpm build` (portfolio-docs)
  - Verify no broken links
  - Verify navigation works

#### Success Criteria for This Phase

- [ ] Testing guide created with comprehensive patterns
- [ ] Examples cover unit and E2E tests
- [ ] Build succeeds: `pnpm build` exits 0
- [ ] No broken links in testing guide

---

### Phase 2: Update Dossier Pages (1 hour)

**Description:** Update Portfolio App dossier with testing architecture and Stage 3.3 details.

#### Tasks

- [ ] Update `02-architecture.md` with testing architecture
  - Add "Testing Architecture (Stage 3.3)" subsection
  - Document testing pyramid
  - Explain unit and E2E test suites
  - Link to testing guide

- [ ] Update `05-testing.md` with test suite details
  - Add "Registry Validation Tests" section
  - Add "Evidence Link Resolution Tests" section
  - Document CI integration
  - Provide examples of running tests

- [ ] Update `01-overview.md` (brief mention)
  - Add sentence in "Quality Standards" section
  - Mention Stage 3.3 testing coverage

- [ ] Build and verify links
  - Run: `pnpm build`
  - Verify dossier updates render correctly
  - Verify cross-references work

#### Success Criteria for This Phase

- [ ] Architecture page includes testing architecture
- [ ] Testing page updated with Stage 3.3 details
- [ ] Overview mentions testing coverage
- [ ] All links resolve correctly
- [ ] Build succeeds without warnings

---

### Phase 3: Update CI/CD and Copilot Instructions (30 min)

**Description:** Document test job in CI/CD pipeline and add testing patterns to copilot instructions.

#### Tasks

- [ ] Update `30-devops-platform/ci-cd/pipeline-overview.md`
  - Add "Test Job (Stage 3.3)" section
  - Explain test job dependencies
  - Document coverage reporting

- [ ] Update `.github/copilot-instructions.md` (portfolio-app)
  - Add "Testing Patterns (Stage 3.3)" section
  - Document test file naming conventions
  - Provide unit and E2E test templates
  - Explain coverage expectations

- [ ] Build and verify
  - Run: `pnpm build` (portfolio-docs)
  - Verify CI/CD documentation updates
  - Check for broken links

#### Success Criteria for This Phase

- [ ] CI/CD pipeline documentation updated
- [ ] Copilot instructions include testing patterns
- [ ] Build succeeds without warnings
- [ ] All cross-references resolve

---

## Success Criteria

- [ ] Testing guide created: `docs/70-reference/testing-guide.md`
- [ ] Architecture page updated with testing architecture subsection
- [ ] Testing dossier page updated with Stage 3.3 details
- [ ] CI/CD pipeline documentation includes test job
- [ ] Copilot instructions include testing patterns
- [ ] All links resolve correctly (no broken links)
- [ ] Build succeeds: `pnpm build` (portfolio-docs) exits 0
- [ ] Examples provided for writing unit and E2E tests
- [ ] Coverage reporting documented

---

## Documentation Quality Standards

All updates must follow portfolio-docs authoring standards:

- [ ] Front matter correct: title, description, tags, sidebar_position
- [ ] Standard page shape: Purpose / Scope / Content / Links
- [ ] No broken links: all relative links start with `/docs/`, include prefix numbers, include `.md`
- [ ] Tone: enterprise engineering organization (explicit, verifiable)
- [ ] Code examples tested and verified
- [ ] Build succeeds: `pnpm build` with no warnings
- [ ] No secrets or sensitive information

---

## Effort Breakdown

| Phase     | Task                     | Hours      | Notes                    |
| --------- | ------------------------ | ---------- | ------------------------ |
| 1         | Create testing guide     | 1–1.5h     | Patterns, examples       |
| 2         | Update dossier pages     | 1h         | Architecture, testing    |
| 3         | Update CI/CD and copilot | 30min      | Pipeline, instructions   |
| **Total** | **Stage 3.3**            | **2.5–3h** | **Within 2–3h estimate** |

---

## Related Issues

- **Linked:** [stage-3-3-app-issue.md](/docs/00-portfolio/roadmap/issues/stage-3-3-app-issue.md) (companion implementation)
- **Dependency:** stage-3-2-docs-issue.md (completed) — evidence components documented
- **Reference:** Phase 3 Implementation Guide: [docs/00-portfolio/roadmap/phase-3-implementation-guide.md](/docs/00-portfolio/roadmap/phase-3-implementation-guide.md#stage-33-unit--e2e-tests-46-hours)

---

## Notes for Reviewers

**Scope Boundaries:**

This docs work is **intentionally limited** to testing strategy documentation and dossier updates. It does NOT include:

- New ADRs (testing is expected practice, not architectural decision)
- New threat models (tests add no attack surface)
- New runbooks (testing is development workflow, not ops procedure)

**Testing Documentation Philosophy:**

The testing guide is a **reference document** for engineers, not a tutorial. It provides:

- Patterns for writing tests
- Examples of good test structure
- Commands for running tests
- Troubleshooting common failures

It does NOT replace official Vitest/Playwright documentation. Engineers should refer to those for API details.

**Evidence Consistency:**

All testing documentation references the actual test files created in [stage-3-3-app-issue.md](/docs/00-portfolio/roadmap/issues/stage-3-3-app-issue.md). No fictional examples.

---

## Reference Documentation

- **Phase 3 Implementation Guide:** [phase-3-implementation-guide.md](/docs/00-portfolio/roadmap/phase-3-implementation-guide.md#stage-33-unit--e2e-tests-46-hours)
- **Portfolio App Dossier — Testing:** [docs/60-projects/portfolio-app/05-testing.md](/docs/60-projects/portfolio-app/05-testing.md)
- **CI/CD Pipeline:** [docs/devops-platform/ci-cd-pipeline-overview.md](/docs/devops-platform/ci-cd-pipeline-overview)
- **Vitest Documentation:** https://vitest.dev
- **Playwright Documentation:** https://playwright.dev
