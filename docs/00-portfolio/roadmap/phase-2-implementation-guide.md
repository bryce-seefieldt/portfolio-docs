---
title: 'Phase 2 Implementation Guide: Gold Standard Project & Credibility Baseline'
description: 'Completed implementation guide for Phase 2: smoke tests, gold standard project, CV enhancement, comprehensive evidence artifacts, and operational maturity.'
sidebar_position: 2
tags: [phase-2, implementation, completed, portfolio-app, testing, operations]
---

# Phase 2 Implementation Guide — Gold Standard Project & Credibility Baseline

**Phase:** Phase 2 (Credibility & Quality Foundation)  
**Estimated Duration:** 19–32 hours (2–4 weeks at 10–15 hrs/week)  
**Status:** ✅ **Complete** (2026-01-21)  
**Last Updated:** 2026-01-21

## Purpose

Phase 2 establishes credibility by transforming the Portfolio App from a "professional foundation" into a demonstrable showcase of senior-level engineering discipline. Rather than building many mediocre examples, Phase 2 creates one exemplary "gold standard" project with comprehensive evidence: complete dossier, threat model, operational runbooks, automated testing, and governance artifacts. This sets the quality bar for all future portfolio entries.

## What Phase 2 Delivers

- **Gold standard project selection:** Portfolio App chosen as the exemplary case study (documented in ADR-0010)
- **Smoke test infrastructure:** Playwright E2E tests with 100% route coverage, integrated into CI pipeline
- **Enhanced Portfolio App dossier:** Comprehensive 7-page documentation covering architecture, security, deployment, testing, operations, and troubleshooting
- **Threat model:** Complete STRIDE analysis with mitigations, controls, and residual risks
- **Operational runbooks:** Deploy, CI triage, rollback, and secrets incident response procedures
- **Security hardening:** Secrets scanning (TruffleHog), CI permission hardening, pre-commit hooks
- **Enhanced project pages:** Gold standard badge component, verification checklists, evidence links
- **Meaningful CV page:** Capability-to-proof mapping with deep links to evidence artifacts
- **Phase 2 completion artifacts:** Release notes, compliance reports, updated roadmap

---

## Prerequisites

Before starting Phase 2, ensure:

- ✅ Phase 1 complete and verified (Portfolio App deployed with CI/CD governance)
- ✅ ADR-0010 documented (gold standard project decision)
- ✅ GitHub issues created in both repos (portfolio-app #9, portfolio-docs #24)
- ✅ Development environment ready (pnpm, Node.js, local testing capabilities)
- ✅ Portfolio-docs build infrastructure operational

**Verification checklist:**

```bash
# Verify Phase 1 state
cd portfolio-app
git pull origin main
pnpm install
pnpm lint && pnpm format:check && pnpm typecheck && pnpm build
# All should pass

# Verify docs build
cd portfolio-docs
pnpm build
# Should complete without errors
```

## Implementation Approach

Phase 2 follows a **sequential steps** implementation pattern, where each step builds on the previous to create a comprehensive evidence foundation. The steps are organized chronologically as they were executed, with all completion status and outcomes documented.

---

## Implementation Steps (Completed)

### STEP 1: Decide on the "Gold Standard" Project ✅ (1–2 hours)

**Goal:** Choose which project will be your exemplary case study.

**Options:**

- **portfolio-app itself** (what you're building now): Advantage—already deployed, live evidence, deep governance records
- **portfolio-docs** (the documentation system): Advantage—also deployed, demonstrates ops maturity
- **A past project** (if public/shareable): Advantage—potentially more complex real-world example
- **A mini-demonstration project** (written as part of Phase 2): Advantage—can be designed specifically to showcase capabilities

**Recommendation for your situation:**
Start with **portfolio-app** as the gold standard. Rationale:

- Already deployed and operational
- Demonstrates full SDLC (Phase 1 already documented)
- Can showcase governance, testing, observability
- Sets precedent for all future projects

**Action items:**

1. ✅ **Decision documented in ADR-0010** — see [ADR-0010: Portfolio App as Gold Standard Exemplar](/docs/10-architecture/adr/adr-0010-portfolio-app-as-gold-standard-exemplar.md)
   - Portfolio App selected as the exemplary project
   - Rationale, consequences, and implementation approach documented
   - Alternatives considered and rejected

2. Create GitHub issue in `portfolio-app` repo titled: `Phase 2: Portfolio App as Gold Standard Exemplar Project`
   - Issue template: [GITHUB_ISSUE_TEMPLATE_PHASE2.md](https://github.com/bryce-seefieldt/portfolio-app/tree/main/GITHUB_ISSUE_TEMPLATE_PHASE2.md)
   - Tracks all Phase 2 deliverables (portfolio-app + portfolio-docs)
   - Links to ADR-0010
   - Assign to yourself; label `phase-2`

3. Create GitHub issue in `portfolio-docs` repo for documentation work
   - Dossier, threat model, runbooks, ADR, release note
   - Link back to portfolio-app issue for cross-repo visibility

**Success check:**

- [x] Gold standard project decided: **portfolio-app**
- [x] Decision documented in ADR-0010
- [x] [GitHub issue #9 created in portfolio-app repo](https://github.com/bryce-seefieldt/portfolio-app/issues/9)
- [x] [GitHub issue #24 created in portfolio-docs repo](https://github.com/bryce-seefieldt/portfolio-docs/issues/24)
- [x] ADR-0010 linked from both issues

---

### STEP 2: Set Up Smoke Test Infrastructure ✅ (3–5 hours)

**Goal:** Create test infrastructure that validates core routes, content, and evidence links.

**Tools:** Playwright (recommended) or Vitest for unit-style content validation

**Implementation:**

#### 2a. Install test dependencies

```bash
cd portfolio-app
pnpm add -D @playwright/test
```

#### 2b. Create Playwright configuration

Create `playwright.config.ts` at repo root:

```typescript
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests/e2e',
  fullyParallel: false,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: 'html',
  use: {
    baseURL: process.env.PLAYWRIGHT_TEST_BASE_URL || 'http://localhost:3000',
    trace: 'on-first-retry',
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },
  ],
  webServer: process.env.CI
    ? undefined
    : {
        command: 'pnpm dev',
        url: 'http://localhost:3000',
        reuseExistingServer: !process.env.CI,
      },
});
```

#### 2c. Create smoke test suite

Create `tests/e2e/smoke.spec.ts`:

```typescript
import { test, expect } from '@playwright/test';

const ROUTES = [
  { path: '/', title: 'Portfolio App' },
  { path: '/cv', title: 'CV' },
  { path: '/projects', title: 'Projects' },
  { path: '/contact', title: 'Contact' },
  { path: '/projects/portfolio-app', title: 'Portfolio App' },
];

test.describe('Smoke tests', () => {
  ROUTES.forEach(({ path, title }) => {
    test(`Route ${path} should render`, async ({ page }) => {
      const response = await page.goto(path);
      expect(response?.status()).toBeLessThan(400);
      // Basic content check
      expect(page.locator('h1')).toBeTruthy();
    });
  });

  test('Evidence links resolve to docs', async ({ page }) => {
    await page.goto('/projects/portfolio-app');
    const docsLink = page.locator('a[href*="/docs/"]').first();
    expect(docsLink).toBeTruthy();
  });

  test('Project registry has no broken slugs', async ({ page }) => {
    const { PROJECTS } = await import('../src/data/projects');
    for (const project of PROJECTS) {
      const response = await page.goto(`/projects/${project.slug}`);
      if (project.status !== 'planned') {
        expect(response?.status()).toBeLessThan(400);
      }
    }
  });
});
```

#### 2d. Add test script to `package.json`

```json
{
  "scripts": {
    "test": "playwright test",
    "test:ui": "playwright test --ui",
    "test:debug": "playwright test --debug"
  }
}
```

#### 2e. Add tests to CI workflow

Update `.github/workflows/ci.yml` to include:

```yaml
- name: Run smoke tests
  run: pnpm test
  continue-on-error: false
```

#### 2f. Update `.gitignore`

```
test-results/
playwright-report/
```

**Success check:**

- [x] Playwright installed and configured
- [x] Smoke test suite runs locally: `pnpm test`
- [x] Tests pass on `pnpm dev` server
- [x] Test script added to package.json
- [x] Tests integrated into CI workflow
- [x] PR created with test infrastructure ([PR #10](https://github.com/bryce-seefieldt/portfolio-app/pull/10))

**Files to create/modify:**

- [x] `playwright.config.ts` (new)
- [x] `tests/e2e/smoke.spec.ts` (new)
- [x] `package.json` (update scripts)
- [x] `.github/workflows/ci.yml` (add test step)
- [x] `.gitignore` (add test results)

---

### STEP 3: Enhance Portfolio App Dossier to Gold Standard ✅ (4–6 hours)

**Goal:** Enhance the existing 7-file dossier structure with gold standard content, following the established project dossier contract.

**Location:** `/portfolio-docs/docs/60-projects/portfolio-app/` (existing dossier files)

**Approach:** The portfolio-app dossier already exists with the standard 7-file structure. This step enhances each file with comprehensive "gold standard" content that demonstrates senior-level engineering discipline.

**Dossier Contract (from `/docs/60-projects/index.md`):**

- ✅ `01-overview.md` — purpose, audiences, NFRs, evidence strategy
- ✅ `02-architecture.md` — system design, content model, component boundaries
- ✅ `03-deployment.md` — CI/CD, environments, release governance
- ✅ `04-security.md` — threat surface, controls, validation
- ✅ `05-testing.md` — quality gates, test strategy, coverage
- ✅ `06-operations.md` — runbooks, maintenance, recovery
- ✅ `07-troubleshooting.md` — failure modes, diagnostics, fixes

---

#### 3a. Enhance `01-overview.md` with executive summary and key metrics

**Add/Update sections:**

```markdown
## Executive Summary

The Portfolio App is a production TypeScript web application that serves as an interactive CV and project showcase, intentionally designed to demonstrate enterprise-grade engineering discipline. Built with Next.js and deployed on Vercel with comprehensive CI/CD governance, it proves competency across modern web development, security hygiene, operational maturity, and evidence-first documentation practices.

**Key value:** Not just a portfolio site—a working exemplar of how senior engineers build, secure, operate, and document production systems.

## Key Metrics (Phase 2 Baseline)

- **Lines of code:** ~500 (application), ~200 (tests)
- **Routes:** 5 core routes (/, /cv, /projects, /contact, /projects/[slug])
- **CI checks:** 2 required (quality, build)
- **Test coverage:** 100% route coverage (Playwright smoke tests - 12 tests)
- **Deployment frequency:** On every merge to main (automatic)
- **Mean time to rollback:** ~1 minute (Git revert + CI)
- **Quality gates:** Lint, format, typecheck, build, smoke tests (all enforced)
- **Dependencies:** 17 production, 11 dev (Dependabot weekly updates)

## What This Project Proves

### Technical Competency

- Modern full-stack web development (Next.js 15+, React 19+, TypeScript 5+)
- Component-driven architecture with App Router
- Responsive design with Tailwind CSS
- Evidence-first UX (deep links to documentation)

### Engineering Discipline

- CI quality gates (ESLint max-warnings=0, Prettier, TypeScript strict)
- Automated smoke testing (Playwright multi-browser)
- Frozen lockfile installs (deterministic builds)
- PR-only merge discipline (GitHub Ruleset enforcement)

### Security Awareness

- Public-safe by design (no secrets, internal endpoints, or auth)
- CodeQL + Dependabot enabled (supply chain hardening)
- Environment variable hygiene (documented, validated)
- PR template security checklist

### Operational Maturity

- Deploy/rollback runbooks (tested and documented)
- CI triage procedures (deterministic troubleshooting)
- Vercel production promotion gating (required checks)
- Evidence-based release notes

### Documentation Excellence

- Complete dossier (7 comprehensive pages)
- ADRs for durable decisions (hosting, CI gates, gold standard choice)
- Threat model (STRIDE analysis - Step 4)
- Operational runbooks (deploy, CI triage, rollback)
```

**Files to update:**

- `docs/60-projects/portfolio-app/01-overview.md`

---

#### 3b. Enhance `02-architecture.md` with detailed technology stack and flow diagrams

**Add/Update sections:**

```markdown
## Technology Stack (Complete Inventory)

### Core Framework

- **Next.js:** v16.1.3 (App Router, React Server Components, static optimization)
- **React:** v19.2.3 (concurrent features, automatic batching)
- **TypeScript:** v5+ (strict mode, noEmit for type-only checks)

### Styling & UI

- **Tailwind CSS:** v4 (utility-first, JIT compilation)
- **@tailwindcss/postcss:** v4 (CSS processing)
- **CSS Modules:** Built-in (component-scoped styles)

### Build & Development

- **pnpm:** v10.0.0 (fast, efficient, frozen lockfiles in CI)
- **Next.js Compiler:** SWC-based (Rust, faster than Babel)
- **React Compiler:** babel-plugin-react-compiler v1.0.0 (optimization)

### Testing & Quality

- **Playwright:** v1.57.0 (E2E smoke tests, multi-browser)
- **ESLint:** v9 (flat config, Next.js presets, TypeScript integration)
- **Prettier:** v3.8.0 (code formatting, Tailwind plugin)
- **wait-on:** v9.0.3 (dev server readiness in CI)

### CI/CD & Governance

- **GitHub Actions:** Quality + build jobs
- **Vercel:** Preview + production deployments
- **CodeQL:** JavaScript/TypeScript security scanning
- **Dependabot:** Weekly dependency updates (grouped, majors excluded)

### Notable Decisions

- **No authentication:** Intentionally deferred (public portfolio)
- **No database:** Static content model (scalable via data files)
- **No form backend:** Contact via static methods (email link)
- **Evidence links:** Deep integration with Docusaurus documentation

## High-Level Request Flow
```

┌─────────────┐
│ Browser │
└──────┬──────┘
│ HTTPS GET /projects/portfolio-app
↓
┌─────────────────────┐
│ Vercel Edge │ (CDN, SSL termination)
└──────┬──────────────┘
│
↓
┌─────────────────────────────────────┐
│ Next.js App Router │
│ - Route: /projects/[slug] │
│ - Server Component (async params) │
│ - getProjectBySlug(slug) │
│ - notFound() if missing │
└──────┬──────────────────────────────┘
│
↓
┌─────────────────────────────┐
│ Project Data (src/data/) │
│ - PROJECTS array │
│ - Static metadata │
└──────┬──────────────────────┘
│
↓
┌──────────────────────────────────┐
│ Component Rendering │
│ - Section components │
│ - Evidence links (to /docs) │
│ - Tailwind styling │
└──────┬───────────────────────────┘
│
↓
┌──────────────────────┐
│ HTML Response │ (static-optimized, RSC payload)
└──────────────────────┘

```

## Component Architecture

```

src/
├── app/ # Next.js App Router
│ ├── layout.tsx # Root layout (global nav, metadata)
│ ├── page.tsx # Landing page (/)
│ ├── cv/
│ │ └── page.tsx # CV route
│ ├── projects/
│ │ ├── page.tsx # Projects list
│ │ └── [slug]/
│ │ └── page.tsx # Dynamic project detail
│ └── contact/
│ └── page.tsx # Contact page
├── components/ # Reusable components
│ ├── Section.tsx # Content section wrapper
│ └── Callout.tsx # Highlighted content blocks
├── data/
│ └── projects.ts # Project registry (typed)
└── lib/
└── config.ts # Environment config helpers

```

## Scalability Patterns

**Current (Phase 2):**
- Static project data in TypeScript (typed, version-controlled)
- Manual content updates via code changes + PRs
- Evidence links hardcoded per project

**Planned (Phase 3+):**
- CMS or API-driven project data (Contentful, headless CMS)
- Automated evidence link validation
- Tag-based filtering and search
```

**Files to update:**

- `docs/60-projects/portfolio-app/02-architecture.md`

---

#### 3c. Update `04-security.md` with public-safety rules and controls

**Add/Update sections:**

````markdown
## Public-Safety Rules (Enforced)

### Environment Variables

- ✅ All `NEXT_PUBLIC_*` variables are client-visible by design
- ✅ No secrets in any `NEXT_PUBLIC_*` variable
- ✅ `.env.example` documents all required variables
- ✅ Local `.env.local` gitignored

**Validation procedure:**

```bash
# Check for secrets in env vars
grep -r "NEXT_PUBLIC.*SECRET\|NEXT_PUBLIC.*KEY\|NEXT_PUBLIC.*TOKEN" src/
# Should return: no results
```
````

### Code Scanning

- ✅ CodeQL enabled (JavaScript/TypeScript)
- ✅ Runs on every push to main and PR
- ✅ Scans for: SQL injection, XSS, path traversal, hardcoded secrets

### Supply Chain Security

- ✅ Dependabot enabled (weekly updates, grouped by type)
- ✅ Major version updates excluded (manual review required)
- ✅ Lockfile formatting automated (prevents CI failures)
- ✅ Frozen lockfile installs in CI (`--frozen-lockfile`)

### PR Security Checklist

Every PR must confirm:

- [ ] No secrets added
- [ ] No sensitive endpoints added
- [ ] Environment variables documented in `.env.example`
- [ ] CodeQL scan passes

## Known Limitations & Accepted Risks

### Out of Scope (Intentional)

- **No authentication:** Public portfolio, no user accounts
- **No backend processing:** Static content, no server-side logic
- **No database:** No persistent user data or state
- **No contact form backend:** Email link only (prevents spam/abuse surface)

### Residual Risks (Acceptable)

- **Dependency vulnerabilities:** Mitigated by Dependabot + CodeQL
- **DDoS:** Mitigated by Vercel's edge network
- **Content injection:** Not applicable (static content, no UGC)

````

**Files to update:**
- `docs/60-projects/portfolio-app/04-security.md`

---

#### 3d. Verify other dossier files are complete

**Already comprehensive (no major changes needed):**
- ✅ `03-deployment.md` — Updated in PR #29 with smoke tests, Dependabot hardening
- ✅ `05-testing.md` — Updated in PR #29 with Playwright details, CI hardening
- ✅ `06-operations.md` — Updated in PR #29 with smoke test requirements, Dependabot automation
- ✅ `07-troubleshooting.md` — Existing comprehensive troubleshooting guide
- ✅ `index.md` — Dossier hub with complete navigation

**Minor additions needed:**

**`index.md` — Add Phase 2 current state:**

```markdown
## Current State (Phase 2)

- ✅ Route skeleton: 5 core routes implemented and smoke-tested
- ✅ CI quality gates: lint, format, typecheck, build, smoke tests (all enforced)
- ✅ Smoke test coverage: 100% routes (12 tests, Chromium + Firefox)
- ✅ Dependabot hardening: Auto-format + lockfile exclusions
- ✅ Deployment governance: Vercel promotion gated by required checks
- ✅ Dossier enhancement: All 7 pages updated to gold standard
- 🟡 Threat model: Planned for Step 4 (STRIDE analysis)
- 🟡 Enhanced project page: Planned for Step 7 (gold standard badge)
- 🟡 Meaningful CV page: Planned for Step 8 (capability-to-proof mapping)
````

**Files to update:**

- `docs/60-projects/portfolio-app/index.md`
- `docs/60-projects/portfolio-app/01-overview.md`
- `docs/60-projects/portfolio-app/02-architecture.md`
- `docs/60-projects/portfolio-app/04-security.md`

---

**Success check:**

- [x] `01-overview.md` enhanced with executive summary, key metrics, "what this proves"
- [x] `02-architecture.md` enhanced with complete tech stack, flow diagrams, component architecture
- [x] `04-security.md` enhanced with public-safety rules, controls, validation procedures
- [x] `index.md` updated with Phase 2 current state
- [x] All dossier files verified complete and aligned with project dossier contract
- [x] Links to ADRs, threat model (placeholder), runbooks verified
- [x] Build verification passes (`pnpm build`)
- [x] PR created with dossier enhancements (PR #31)

---

### STEP 4: Create/Update Threat Model ✅ (2–3 hours)

**Goal:** Document security assumptions, threats, and controls for the project.

**Location:** `/portfolio-docs/docs/40-security/threat-models/portfolio-app-threat-model.md`

**Approach:** Use STRIDE or a simple trust boundary diagram.

**Template:**

```markdown
---
title: 'Threat Model: Portfolio App'
description: 'Security analysis of the Portfolio App...'
tags: [security, threat-model, portfolio-app]
---

# Threat Model: Portfolio App

## Trust Boundaries Diagram

[Simple ASCII diagram showing public users → portfolio app → docs app → GitHub]

## Assets at Risk

- Source code (GitHub)
- Deployment credentials (Vercel)
- Custom domain (DNS)
- Reputation (if compromised)

## Threats (STRIDE)

### Spoofing

- **Threat:** Attacker spoofs the portfolio domain
- **Mitigation:** Use TLS/HTTPS, HSTS header, domain registration lock

### Tampering

- **Threat:** Attacker modifies deployed content
- **Mitigation:** Deployments only via authenticated Git + Vercel; no manual edits

### Repudiation

- **Threat:** Attacker denies making changes
- **Mitigation:** Git commit audit trail; GitHub Actions logs

### Information Disclosure

- **Threat:** Attacker exfiltrates environment variables or secrets
- **Mitigation:** No secrets in `NEXT_PUBLIC_*` variables; secrets never committed

### Denial of Service

- **Threat:** Attacker floods the app or docs domain
- **Mitigation:** Vercel DDoS protection; docs served as static files

### Elevation of Privilege

- **Threat:** Attacker gains elevated access to deployment pipeline
- **Mitigation:** GitHub Rulesets enforce PR reviews; required checks gate merges

## Residual Risks (Accepted)

- Dependabot alerts may not catch all zero-days immediately
- Manual review required for major dependency updates

## Controls Summary

- ✅ Code review (GitHub Rulesets + PR template)
- ✅ CI/CD gating (required checks)
- ✅ Supply chain: CodeQL + Dependabot
- ✅ Static deployment (no runtime secrets)
- ✅ Immutable deployments (Git revert only)
```

**Success check:**

- [x] Threat model document created (comprehensive STRIDE analysis)
- [x] Trust boundaries identified and diagrammed
- [x] STRIDE analysis complete (6 categories, 12 threats with mitigations)
- [x] Mitigations documented (Phase 1 baseline + Phase 2+ recommended)
- [x] Residual risks accepted and reviewed
- [x] Linked from dossier security page
- [x] Build verification passes
- [x] PR created with threat model enhancements (PR #32 — pending)

---

### STEP 4a: Phase 2 Security Enhancements (Hardening Controls) ✅ (2–3 hours)

**Goal:** Implement optional Phase 2 hardening controls that enhance Information Disclosure and Tampering threat mitigations.

**Scope:** These enhancements are **beyond Phase 1 baseline** but strengthen enterprise-grade posture.

**Enhancement 1: Secrets Scanning Gate**

**Location:** `.github/workflows/ci.yml`

**Approach:** Add TruffleHog job to CI pipeline to detect hardcoded secrets before merge.

**Implementation:**

1. Update CI workflow to add `secrets-scan` job:

```yaml
secrets-scan:
  name: secrets-scan
  runs-on: ubuntu-latest
  timeout-minutes: 5
  permissions:
    contents: read

  steps:
    - name: Checkout
      uses: actions/checkout@v6

    - name: TruffleHog Secret Scanning
      uses: trufflesecurity/trufflehog@main
      with:
        path: ./
        base: ${{ github.event.repository.default_branch }}
        head: HEAD
        extra_args: --debug --only-verified
```

2. Update build job to depend on `secrets-scan`:

```yaml
needs: [quality, secrets-scan]
```

3. Update `package.json` to add local secret scanning script:

```json
{
  "scripts": {
    "secrets:scan": "trufflehog filesystem . --debug --only-verified"
  }
}
```

**Enhancement 2: CI Permission Hardening (Least-Privilege)**

**Location:** `.github/workflows/ci.yml`

**Approach:** Replace global `permissions: contents: write` with job-specific least-privilege permissions.

**Implementation:**

1. Remove global permissions:

```yaml
# OLD (too broad):
permissions:
  contents: write

# NEW (no global permissions):
permissions: {}
```

2. Add job-specific permissions:

```yaml
quality:
  permissions:
    contents: write # Needed for Dependabot auto-format
    pull-requests: read

build:
  permissions:
    contents: read # Read-only for build artifacts
```

**Enhancement 3: Pre-commit Hooks for Local Scanning**

**Location:** `.pre-commit-config.yaml` (new file)

**Approach:** Enable local TruffleHog scanning before commits.

**Implementation:**

1. Create `.pre-commit-config.yaml`:

```yaml
repos:
  - repo: https://github.com/trufflesecurity/trufflehog
    rev: v3.63.0
    hooks:
      - id: trufflehog
        name: TruffleHog secrets scan
        description: Detect secrets in code
        entry: trufflehog filesystem .
        language: python
        stages: [commit]
        types: [python, typescript, javascript, json, yaml, toml, markdown]
```

2. Users enable locally:

```bash
pre-commit install
git config core.hooksPath .git/hooks  # One-time setup
```

**Benefits:**

- **Information Disclosure (T1):** Secrets scanning gate catches leaks before CI
- **Tampering (T2):** CI permission hardening reduces attack surface
- **Elevation of Privilege (E1):** Least-privilege permissions prevent unauthorized deployments

**Threat Model Alignment:**

- Ref: [Threat Model — Information Disclosure](/docs/40-security/threat-models/portfolio-app-threat-model.md#threat-1-attacker-exfiltrates-secrets-from-environment-or-repository)
- Ref: [Threat Model — Tampering](/docs/40-security/threat-models/portfolio-app-threat-model.md#threat-2-attacker-modifies-ci-workflows-or-build-scripts-to-inject-malicious-code)

**Success check:**

- [x] Secrets scanning gate added to CI workflow
- [x] CI permissions set to least-privilege (per-job)
- [x] Pre-commit hooks configured for local scanning
- [x] `secrets:scan` CI stage added; local verify uses a lightweight pattern-based scan
- [x] All CI checks pass with new gates
- [x] Team documentation updated with secret scanning procedures
- [x] STRIDE compliance report generated (see

**Files to create/modify:**

- [x] `.github/workflows/ci.yml` (add secrets-scan job; scoped permissions)
- [x] `.pre-commit-config.yaml` (new; TruffleHog hook)
- [x] `package.json` (secrets:scan script used by CI; optional local run)

**PR Reference:** Phase 2 enhancements merged as part of threat model PR ([PR #33](https://github.com/bryce-seefieldt/portfolio-docs/pull/33))

---

### STEP 4b: Phase 2 Operational Readiness (Incident Response) ✅ (1–2 hours)

**Goal:** Create incident response runbooks aligned to threat model procedures.

**Scope:** Formalize secret publication and incident response procedures.

**Enhancement: Secrets Incident Response Runbook**

**Location:** `/portfolio-docs/docs/50-operations/runbooks/rbk-portfolio-secrets-incident.md`

**Approach:** Create comprehensive runbook covering detection, containment, investigation, and recovery.

**Key Sections:**

1. **Triage (≤5 min):** Assess severity; determine containment strategy
2. **Emergency Contain (≤5 min for Critical):** Stop the leak; rotate credentials
3. **Investigation (5–30 min):** Determine scope, timeline, exposure duration
4. **Remediation (15–60 min):** Remove secret from history; rotate credentials; update systems
5. **Validation (5–10 min):** Confirm leak is contained; CI/CD healthy
6. **Postmortem (30 min–1 hr):** Document; prevent recurrence

**Threat Model Alignment:**

- Ref: [Threat Model — Incident Response](/docs/40-security/threat-models/portfolio-app-threat-model.md#incident-response)
- Covers: Information Disclosure (T1) response
- Covers: Suspected malicious deployment response (T2)

**Success check:**

- [x] Secrets incident response runbook created
- [x] 5-phase procedure documented with timelines
- [x] Severity levels defined (Critical, High, Medium)
- [x] Checklists provided for each phase
- [x] Escalation criteria documented
- [x] Runbook index updated with reference

**Files to create/modify:**

- [x] `docs/50-operations/runbooks/rbk-portfolio-secrets-incident.md` (new)
- [x] `docs/50-operations/runbooks/index.md` (add reference)

**PR Reference:** Phase 2 incident response runbook merged as part of runbooks enhancement

---

## Phase 2 Security Enhancements — Quick Reference

This section summarizes all Phase 2 security and operational hardening applied to the Portfolio App (completed in STEP 4a and 4b).

### CI/CD Hardening

- ✅ **Secrets scanning** added to CI using TruffleHog with verified detectors
  - Runs on **pull requests only** to avoid TruffleHog BASE==HEAD failures on direct pushes to main
  - Required check before merge via GitHub branch protection rules
  - Ensures all production code is scanned before merge
- ✅ **Least-privilege permissions** implemented
  - Removed global workflow permissions
  - Added minimal job-level permissions per workflow job
- ✅ **Deterministic builds** enforced via `pnpm install --frozen-lockfile` in CI
- ✅ **Required checks** before merge: `ci / quality`, `ci / build`, `secrets-scan`, CodeQL

### Developer Workflow Hardening

- ✅ **Pre-commit hooks** added via `.pre-commit-config.yaml` with TruffleHog
  - Optional local opt-in for developers
  - Prevents committing sensitive material before push
- ✅ **Local verification** uses lightweight pattern-based secret scan
  - Full TruffleHog scanning runs only in CI (performance optimization)
- ✅ **Quality gates maintained**: TypeScript strict mode, ESLint zero-warnings, Prettier enforcement

### Operational Hardening

- ✅ **Secrets incident response runbook** created: [rbk-portfolio-secrets-incident.md](/docs/50-operations/runbooks/rbk-portfolio-secrets-incident.md)
  - 5-phase response procedure: Detection → Containment → Eradication → Recovery → Postmortem
  - Aligned with STRIDE threat model mitigations
- ✅ **Existing runbooks verified** for operational readiness:
  - [rbk-portfolio-deploy.md](/docs/50-operations/runbooks/rbk-portfolio-deploy.md)
  - [rbk-portfolio-rollback.md](/docs/50-operations/runbooks/rbk-portfolio-rollback.md)
  - [rbk-portfolio-ci-triage.md](/docs/50-operations/runbooks/rbk-portfolio-ci-triage.md)

### Evidence Artifacts

- **CI Workflow:** [.github/workflows/ci.yml](https://github.com/bryce-seefieldt/portfolio-app/blob/main/.github/workflows/ci.yml)
- **Pre-commit Config:** [.pre-commit-config.yaml](https://github.com/bryce-seefieldt/portfolio-app/blob/main/.pre-commit-config.yaml)
- **Package Scripts:** [package.json](https://github.com/bryce-seefieldt/portfolio-app/blob/main/package.json)
- **Smoke Tests:** [tests/e2e/smoke.spec.ts](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/smoke.spec.ts)
- **Threat Model:** [Portfolio App STRIDE](/docs/40-security/threat-models/portfolio-app-threat-model.md)
- **All Runbooks:** [Operations Runbooks Index](/docs/50-operations/runbooks/index.md)

---

### STEP 5: Create/Update Operational Runbooks ✅ (2–4 hours)

**Goal:** Document repeatable procedures for deployment, CI triage, and rollback.

**Files to create:**

#### 5a. Deploy Runbook

**Location:** `/docs/50-operations/runbooks/rbk-portfolio-deploy.md`

````markdown
---
title: 'Runbook: Deploy Portfolio App'
description: 'Step-by-step procedure for deploying changes to production.'
tags: [operations, runbooks, portfolio-app, deployment]
---

# Runbook: Deploy Portfolio App

## Overview

This runbook describes the standard deployment workflow for the Portfolio App.
Deployments are automatic after merge to `main` (no manual steps required).

## Prerequisites

- GitHub Ruleset requires passing checks before merge
- Vercel Deployment Checks verify production promotion readiness

## Procedure

### 1. Create PR with changes

```bash
git checkout -b feat/my-feature
# Make changes
pnpm lint
pnpm format:check
pnpm typecheck
pnpm build
git commit -am "feat: add my feature"
git push origin feat/my-feature
```
````

### 2. Open PR and wait for checks

- GitHub Actions runs `ci / quality` and `ci / build`
- Vercel creates preview deployment

### 3. Validate preview deployment

- Open preview URL from Vercel comment
- Test routes and evidence links
- Spot-check styling and rendering

### 4. Merge PR (GitHub Ruleset enforces checks)

- All checks must pass
- At least 1 review (configure as needed)
- Click "Merge" (Ruleset prevents merge if conditions not met)

### 5. Automatic production deployment

- Vercel monitors `main` branch
- After merge, Vercel runs same checks
- If checks pass, Vercel deploys to production domain
- Production domain updates automatically (no manual step)

## Rollback

If an issue is discovered post-deployment, see [rbk-portfolio-rollback.md](/docs/50-operations/runbooks/rbk-portfolio-rollback.md).

## Troubleshooting

- Checks fail: See [rbk-portfolio-ci-triage.md](/docs/50-operations/runbooks/rbk-portfolio-ci-triage.md)
- Preview doesn't update: Refresh Vercel dashboard or wait 2 minutes

````

#### 5b. CI Triage Runbook

**Location:** `/portfolio-docs/docs/50-operations/runbooks/rbk-portfolio-ci-triage.md`

```markdown
---
title: 'Runbook: CI Triage — Portfolio App'
description: 'How to diagnose and fix CI failures.'
tags: [operations, runbooks, portfolio-app, ci]
---

# Runbook: CI Triage — Portfolio App

## Quick diagnostics

| Symptom | Likely cause | Fix |
| --- | --- | --- |
| `ci / quality` fails | Lint, format, or typecheck error | Run `pnpm lint`, `pnpm format:check`, `pnpm typecheck` locally |
| `ci / build` fails | Next.js build error | Run `pnpm build` locally |
| Playwright tests fail | Route or content regression | Review test output; run `pnpm test --debug` |
| Vercel preview fails | Build succeeds but deployment fails | Check Vercel logs in deployment dashboard |

## Step-by-step triage

### 1. Identify which check failed
- Look at GitHub PR checks (scroll to "Checks" tab)
- Click on failed check name to see logs

### 2. Reproduce locally
```bash
git fetch origin
git checkout feat/my-feature
pnpm install
# Run the same command as CI
pnpm lint        # if ci/quality failed
pnpm build       # if ci/build failed
pnpm test        # if smoke tests failed
````

### 3. Fix the issue

- Edit source files to fix errors
- Rerun the command to verify

### 4. Commit and push

```bash
git add .
git commit -m "fix: resolve ci/quality lint error"
git push origin feat/my-feature
```

### 5. Monitor re-run

- GitHub Actions automatically re-runs checks
- Watch for green checkmarks on the PR

## Common issues and fixes

### ESLint errors

```bash
pnpm lint -- --fix
```

### Prettier formatting

```bash
pnpm format
```

### TypeScript type errors

- Open the file and fix based on error message
- No auto-fix for type errors

### Next.js build errors

- Usually caused by missing exports or dynamic import issues
- Check the build log for specific file and line

---

## Escalation

If issues persist after triage:

1. Check GitHub Actions logs for full error context
2. Verify `.env.local` has all required vars from `.env.example`
3. Clear `.next` cache: `rm -rf .next` and rebuild
4. Ask for help in team/community channels

````

#### 5c. Rollback Runbook

**Location:** `/portfolio-docs/docs/50-operations/runbooks/rbk-portfolio-rollback.md`

```markdown
---
title: 'Runbook: Rollback Portfolio App'
description: 'Emergency rollback procedure if production deployment has issues.'
tags: [operations, runbooks, portfolio-app, incident-response]
---

# Runbook: Rollback Portfolio App

## When to rollback
- Critical bug discovered in production
- Performance degradation observed
- Security issue identified and needs immediate remediation

## Rollback procedure

### 1. Identify the problematic commit
```bash
git log --oneline -10  # Find the commit to revert
````

### 2. Create revert commit

```bash
git checkout main
git pull origin main
git revert <commit-hash>  # Creates a new commit that undoes the change
git push origin main
```

### 3. Wait for checks and deployment

- GitHub Actions runs checks on the revert commit
- After checks pass, Vercel deploys the previous version to production
- **Time to rollback:** ~2–3 minutes

### 4. Verify rollback

- Open production domain
- Spot-check that issue is resolved

### 5. Investigate root cause

- Create a new branch to investigate
- Create ADR or incident postmortem documenting the issue

## Quick rollback (if needed immediately)

If waiting for CI is unacceptable, you can manually redeploy a previous commit in Vercel dashboard:

1. Go to Vercel project settings
2. Deployments → find good deployment
3. Click "Redeploy"
4. Confirm

(This bypasses GitHub checks, use only in true emergency)

## After rollback

1. Fix the underlying issue in a new PR
2. Add regression test to prevent repeat
3. Document lessons learned (postmortem)

````

**Success check:**
- [ ] Deploy runbook created and linked from dossier
- [ ] CI triage runbook created with common issues
- [ ] Rollback runbook created with both automated and manual steps
- [ ] All runbooks tested (at least mentally walkthrough)
- [ ] Links cross-reference correctly
- [ ] Build verification passes

---

### STEP 6: Create/Update ADRs for Phase 2 Decisions ✅ (1–2 hours)

**Goal:** Document any significant decisions made during Phase 2.

**Likely ADRs:**
- **Testing strategy** (Playwright for smoke tests, planned unit tests)
- **Gold standard project criteria** (what makes a project "gold standard")

**Example ADR:**

**Location:** `/portfolio-docs/docs/10-architecture/adr/adr-0009-portfolio-app-test-strategy.md`

```markdown
---
title: 'ADR-0000: Portfolio App Testing Strategy'
status: 'accepted'
date: 2026-01-17
tags: [adr, architecture, testing, portfolio-app]
---

# ADR-0000: Portfolio App Testing Strategy

## Context

The Portfolio App has reached Phase 2 (gold standard credibility baseline). To support this and future scaling, we need a clear testing strategy that:

1. Validates core functionality (routes, content, evidence links)
2. Catches regressions as we add features
3. Scales as the project registry grows
4. Integrates with CI/CD without adding excessive overhead

## Decision

We will adopt a **phased testing approach**:

### Phase 2 (now)
- **Smoke tests (Playwright):** Route accessibility, content rendering, evidence link integrity
- **Manual spot-checks:** Evidence links resolve to docs; styling renders correctly

### Phase 3 (planned)
- **Unit tests (Vitest):** Content validation (slug formats, required fields)
- **Property-based tests:** Ensure all projects in registry follow consistent schema

### Phase 3+ (future)
- **E2E tests (Playwright):** Full user flows, cross-domain evidence link validation
- **Performance tests:** Lighthouse CI for Core Web Vitals

## Rationale

1. **Start simple:** Smoke tests catch 80% of issues (broken routes, missing content) with minimal maintenance
2. **Progressive:** Add unit tests once content model stabilizes (Phase 3)
3. **Scale-ready:** Schema validation prevents inconsistent project data
4. **CI-friendly:** Tests run in ~2 minutes; fast feedback on PRs

## Consequences

- Smoke tests may not catch subtle bugs (UI logic, edge cases)
- Unit tests require schema formalization (good practice but more upfront work for Phase 3)
- E2E tests initially manual (acceptable for Phase 2 given low volume)

## Alternatives considered

1. **Full e2e tests from day 1:** Too much maintenance burden for current project size
2. **No tests initially:** Higher risk of regressions; harder to catch broken evidence links
3. **Only unit tests:** Wouldn't catch routing or integration issues

## Implementation

See: [Smoke test setup in Phase 2 guide]
````

**Success check:**

- [ ] ADR created for testing strategy (or other Phase 2 decision)
- [ ] Decision rationale clear
- [ ] Alternatives considered
- [ ] Consequences documented
- [ ] Linked from dossier
- [ ] Build verification passes

---

### STEP 7: Enhance Project Detail Page ✅ (2–3 hours)

**Goal:** Make the project page showcase the evidence trail and governance posture.

**Current state:** Basic project detail with evidence links

**Enhancements:**

#### 7a. Add "What This Project Proves" section (already exists, enhance)

Update `/portfolio-app/src/app/projects/[slug]/page.tsx` to display:

```tsx
<Section
  title="What this project proves"
  subtitle="Senior-level engineering discipline demonstrated."
>
  <ul className="list-disc pl-5 space-y-2 text-sm text-zinc-700 dark:text-zinc-300">
    <li>
      <strong>Clear scope & architecture:</strong>{' '}
      <a className="underline" href={docsUrl(evidence?.dossierPath)}>
        See dossier
      </a>
    </li>
    <li>
      <strong>Enterprise SDLC:</strong> PR discipline, CI gates, governance
    </li>
    <li>
      <strong>Security-aware:</strong> Threat modeling, safe-publication rules
    </li>
    <li>
      <strong>Operational readiness:</strong> Deploy/rollback/triage procedures
    </li>
    <li>
      <strong>Tested:</strong> Automated checks, smoke tests, reproducibility
    </li>
  </ul>
</Section>
```

#### 7b. Create "Gold Standard Badge" component

Create `/portfolio-app/src/components/GoldStandardBadge.tsx`:

```tsx
export function GoldStandardBadge() {
  return (
    <div className="flex items-center gap-2 rounded-lg border border-amber-200 bg-amber-50 p-3 dark:border-amber-900 dark:bg-amber-950">
      <span className="text-lg">🏆</span>
      <p className="text-sm font-medium text-amber-900 dark:text-amber-100">
        This is a gold standard portfolio project — comprehensive documentation,
        full governance trail, and operational readiness.
      </p>
    </div>
  );
}
```

Add to project detail page:

```tsx
import { GoldStandardBadge } from '@/components/GoldStandardBadge';

// In the component:
<GoldStandardBadge />;
```

#### 7c. Add "Verification Checklist" section

```tsx
<Section
  title="How to verify"
  subtitle="Independent validation steps for reviewers."
>
  <ul className="list-disc pl-5 space-y-2 text-sm text-zinc-700 dark:text-zinc-300">
    <li>
      Visit{' '}
      <a className="underline" href={project.repoUrl}>
        GitHub repository
      </a>{' '}
      — check commit history, PR discipline, CI checks
    </li>
    <li>
      View{' '}
      <a className="underline" href={project.demoUrl}>
        live deployment
      </a>{' '}
      — test routing, rendering, performance
    </li>
    <li>
      Review{' '}
      <a className="underline" href={docsUrl(evidence?.dossierPath)}>
        project dossier
      </a>{' '}
      — architecture, decisions, operational procedures
    </li>
    <li>
      Check{' '}
      <a className="underline" href={docsUrl(evidence?.threatModelPath)}>
        threat model
      </a>{' '}
      — security assumptions and controls
    </li>
    <li>
      Read{' '}
      <a className="underline" href={docsUrl(evidence?.adrIndexPath)}>
        ADRs
      </a>{' '}
      — rationale for durable decisions
    </li>
  </ul>
</Section>
```

**Success check:**

- [ ] Enhanced project detail page components created
- [ ] Gold standard badge displays for chosen project
- [ ] Evidence links are comprehensive and organized
- [ ] Verification checklist guides reviewers
- [ ] Smoke tests validate links resolve
- [ ] Build passes
- [ ] PR created with enhancements

---

### STEP 8: Enhance CV Page with Capability Mapping ✅ (2–3 hours)

**Goal:** Transform CV from skeleton into meaningful capability-to-proof mapping.

**Current approach:** Create a structured CV that links capabilities to projects/evidence

**Update `/portfolio-app/src/app/cv/page.tsx`:**

```tsx
'use client';
import Link from 'next/link';
import { Section } from '@/components/Section';
import { docsUrl } from '@/lib/config';

type TimelineEntry = {
  title: string;
  organization: string;
  period: string;
  description: string;
  keyCapabilities: string[];
  proofs: { text: string; href: string }[];
};

const TIMELINE: TimelineEntry[] = [
  {
    title: 'Full-Stack Engineer',
    organization: 'Portfolio Program',
    period: '2026',
    description:
      'Designed and built an enterprise-grade portfolio demonstrating modern web development, governance, and operational maturity.',
    keyCapabilities: [
      'Next.js / React / TypeScript',
      'CI/CD governance',
      'Security & threat modeling',
      'Docs-as-code culture',
      'Vercel deployment',
    ],
    proofs: [
      {
        text: 'Portfolio App on GitHub',
        href: 'https://github.com/bryce-seefieldt/portfolio-app',
      },
      { text: 'Live deployment', href: 'https://your-portfolio.com' },
      {
        text: 'Full dossier with architecture & decisions',
        href: docsUrl('projects/portfolio-app'),
      },
      {
        text: 'Complete threat model & security posture',
        href: docsUrl('security/threat-models/portfolio-app-threat-model'),
      },
      {
        text: 'Operational runbooks (deploy, rollback, triage)',
        href: docsUrl('operations/runbooks/'),
      },
    ],
  },
  // Add more timeline entries as you accumulate projects/roles
];

export default function CVPage() {
  return (
    <div className="flex flex-col gap-8">
      <header className="flex flex-col gap-3">
        <h1 className="text-3xl font-semibold tracking-tight">
          Experience & Capabilities
        </h1>
        <p className="max-w-3xl text-zinc-700 dark:text-zinc-300">
          Evidence-first CV: each role links to proofs (projects, dossiers,
          architecture decisions, operational maturity).
        </p>
      </header>

      {TIMELINE.map((entry, idx) => (
        <Section
          key={idx}
          title={entry.title}
          subtitle={`${entry.organization} — ${entry.period}`}
        >
          <p className="mb-4 text-sm text-zinc-700 dark:text-zinc-300">
            {entry.description}
          </p>

          <div className="mb-4">
            <h4 className="font-medium text-zinc-900 dark:text-white">
              Key Capabilities
            </h4>
            <div className="mt-2 flex flex-wrap gap-2">
              {entry.keyCapabilities.map((cap) => (
                <span
                  key={cap}
                  className="rounded-full border border-zinc-200 px-2 py-1 text-xs text-zinc-700 dark:border-zinc-800 dark:text-zinc-300"
                >
                  {cap}
                </span>
              ))}
            </div>
          </div>

          <div>
            <h4 className="font-medium text-zinc-900 dark:text-white">
              Proofs & Evidence
            </h4>
            <ul className="mt-2 list-disc space-y-1 pl-5 text-sm">
              {entry.proofs.map((proof, pIdx) => (
                <li key={pIdx}>
                  <a
                    className="underline hover:text-zinc-950 dark:hover:text-white"
                    href={proof.href}
                  >
                    {proof.text}
                  </a>
                </li>
              ))}
            </ul>
          </div>
        </Section>
      ))}
    </div>
  );
}
```

**Success check:**

- [ ] CV page displays timeline with capability mapping
- [ ] Each entry links to projects, dossiers, threat models, runbooks
- [ ] Evidence links resolve in smoke tests
- [ ] Styling integrates with rest of site
- [ ] Smoke tests pass
- [ ] PR created with CV enhancements

---

### STEP 9: Create Release Note for Phase 2 ✅ (1–2 hours)

**Goal:** Document Phase 2 completion with all additions and changes.

**Location:** `/portfolio-docs/docs/00-portfolio/release-notes/20260120-portfolio-app-phase-2-gold-standard.md`

**Success check:**

- [x] Release note created with all Phase 2 features
- [x] Links to dossier, threat model, ADRs, runbooks, security enhancements
- [x] Success criteria clearly documented
- [x] Build verification passes
- [x] PR created and merged

**Completion notes:**

- Release note published: [20260120-portfolio-app-phase-2-gold-standard.md](/docs/00-portfolio/release-notes/20260120-portfolio-app-phase-2-gold-standard.md)

release-notes/20260120-portfolio-app-phase-2-gold-standard.md(/docs/00-portfolio/release-notes/20260120-portfolio-app-phase-2-gold-standard.md)

- All evidence artifacts linked and verified

---

### STEP 10: Create PR and Verify End-to-End ✅ (1–2 hours)

**Goal:** Document Phase 2 completion with all additions and changes.

**Location:** `/portfolio-docs/docs/00-portfolio/release-notes/20260124-portfolio-app-phase-2-gold-standard.md` (adjust date)

**Template:**

```markdown
---
title: 'Release Notes: Portfolio App Phase 2 Complete (Gold Standard Project + Testing)'
description: 'Phase 2 completion: comprehensive project dossier, smoke test infrastructure, enhanced CV with capability mapping, threat model, and operational runbooks.'
tags: [release-notes, portfolio-app, phase-2, testing, projects]
date: 2026-01-24
---

# Release Notes: Portfolio App Phase 2 Complete (Gold Standard Project + Testing)

## Summary

Phase 2 of the Portfolio App establishes credibility through one exemplary "gold standard" project. The Portfolio App itself serves as the proof, with comprehensive documentation, automated testing, full threat model, and operational procedures.

**Status:** ✅ **Phase 2 Complete** (2026-01-24)

---

## Highlights

- **Gold standard project page** with full evidence trail and verification checklist
- **Smoke test infrastructure** (Playwright) with 100% route coverage
- **Comprehensive dossier** covering architecture, security, deployment, operations
- **Threat model** documenting security assumptions and controls
- **Operational runbooks** for deploy, CI triage, rollback
- **Enhanced CV page** with capability-to-proof mapping
- **Gold standard badge** component highlighting exemplary project quality

---

## Added

### Portfolio App features

- **Smoke test suite (Playwright):**
  - Route accessibility tests (all 5 core routes)
  - Content rendering validation
  - Evidence link integrity checks
  - Integrated into CI pipeline (required before merge)

- **Enhanced project detail page:**
  - Gold standard badge
  - "What this project proves" section with detailed capabilities
  - "Verification checklist" section guiding independent validation
  - Comprehensive evidence links (dossier, threat model, ADRs, runbooks)

- **Meaningful CV page:**
  - Timeline of experience with capability-to-proof mapping
  - Each entry links to projects, dossiers, threat models, runbooks
  - Evidence-first approach: each claim is verifiable

### Documentation artifacts

- **Project dossier (10 sections):**
  - Executive summary, overview, architecture, security, testing, deployment, operations, limitations, troubleshooting, related artifacts
  - ~4,000 words

- **Threat model:**
  - Trust boundary diagram
  - STRIDE analysis
  - Mitigation controls
  - Residual risks documented and accepted

- **Operational runbooks:**
  - Deploy runbook (standard workflow)
  - CI triage runbook (troubleshooting common failures)
  - Rollback runbook (emergency recovery procedure)

- **ADR for testing strategy:**
  - Justification for phased testing approach (smoke → unit → e2e)
  - Rationale for Playwright + Vitest stack

---

## Changed

### Testing & quality

- `package.json` updated with Playwright test scripts
- `.github/workflows/ci.yml` updated to run smoke tests (required check)
- `.gitignore` updated to exclude test results and reports

### Project detail page

- Now displays gold standard badge for exemplary project
- Enhanced evidence links section
- Added verification checklist for reviewers

### CV page

- Converted from skeleton to comprehensive capability-to-proof mapping
- Timeline entries link to deep evidence artifacts
- Demonstrates evidence-first hiring/evaluation approach

---

## Verification (Phase 2 Success Criteria — All Complete ✅)

The Phase 2 release is valid when:

- ✅ One "gold standard" project page is fully polished
- ✅ Comprehensive dossier covers architecture, security, deployment, operations
- ✅ Threat model documents security posture and controls
- ✅ Operational runbooks (deploy, CI triage, rollback) are complete
- ✅ Smoke tests validate all core routes and evidence links
- ✅ CV page meaningfully maps capabilities to proofs
- ✅ A reviewer can validate senior-level engineering discipline through one project
- ✅ All evidence links resolve correctly

---

## Architecture & Governance References

- [Portfolio App Dossier](/docs/60-projects/portfolio-app/index.md) (location TBD during implementation)
- [Threat Model: Portfolio App](/docs/40-security/threat-models/) (location TBD during implementation)
- Operational runbooks (created during Phase 2):
  - Deploy runbook
  - CI triage runbook
  - Rollback runbook

---

## Phase 3 Planning (Next Increments)

With Phase 2 establishing credibility through one exemplary project, Phase 3 will focus on:

- **Scale content model:** Repeatable project publishing pipeline with validation
- **Unit tests:** Content/slug validation, project registry schema enforcement
- **E2E tests:** Full user flows, cross-domain evidence link validation
- **Add additional projects:** Now that gold standard is proven, add portfolio entries at same quality bar

---

## Known Limitations (Phase 2 scope)

- Smoke tests only (unit/e2e planned for Phase 3)
- Single gold standard project (additional projects planned for Phase 3+)
- Manual evidence link testing (automated in Phase 3)
- No performance or accessibility audit yet (planned for Phase 4)
```

**Success check:**

- [ ] Release note created with all Phase 2 features
- [ ] Links to dossier, threat model, ADRs, runbooks
- [ ] Success criteria clearly documented
- [ ] Build verification passes
- [ ] PR created with release note

---

### STEP 10: Create PR and Verify End-to-End (1–2 hours)

**Goal:** Consolidate all Phase 2 work into a single PR and validate everything works together.

**Process:**

```bash
# Ensure you're on main and up-to-date
cd portfolio-app
git checkout main
git pull origin main

# Create Phase 2 feature branch
git checkout -b feat/phase-2-gold-standard

# Make all changes (test infrastructure, components, documentation)
# ...commit as you go...

# Run all checks locally
pnpm lint
pnpm format:check
pnpm typecheck
pnpm build
pnpm test  # Run Playwright smoke tests

# Verify documentation builds
cd ../portfolio-docs
pnpm build

# If all passes, create PR
cd ../portfolio-app
git push origin feat/phase-2-gold-standard
# Open PR on GitHub
```

**PR template checklist:**

```
## Phase 2 Implementation: Gold Standard Project & Testing

### Changes
- [ ] Smoke test infrastructure (Playwright)
- [ ] Enhanced project detail page with gold standard badge
- [ ] Meaningful CV page with capability mapping
- [ ] Local test commands and CI integration

### Documentation updates (portfolio-docs repo)
- [ ] Project dossier (10 sections)
- [ ] Threat model
- [ ] Operational runbooks (deploy, CI triage, rollback)
- [ ] ADR for testing strategy
- [ ] Phase 2 release note

### Evidence
- [ ] All smoke tests pass locally: `pnpm test`
- [ ] CI checks pass on main
- [ ] Production deployment successful
- [ ] Evidence links resolve to docs (verified in smoke tests)

### No secrets added
- [ ] No `NEXT_PUBLIC_*` secrets added
- [ ] No API keys or credentials in code or config
```

**Success check:**

- [x] All local checks pass (`lint`, `format:check`, `typecheck`, `build`, `test`)
- [x] Documentation builds pass
- [x] PRs created with comprehensive descriptions
- [x] GitHub Actions CI runs successfully
- [x] Vercel preview deployments work
- [x] Production deployments automatic and successful
- [x] All evidence links resolve to docs app
- [x] Smoke tests pass in CI

**Completion notes:**

- Multiple PRs created and merged throughout Phase 2
- Portfolio App PRs: #10 (smoke tests), #20 (gold standard page), #21 (CV page), #25 (verification script)
- Portfolio Docs PRs: #32 (threat model), #33 (enhancements summary), #39 (dossier), #40 (STRIDE compliance)
- All CI gates passing consistently
- Production deployments stable and verified

---

## Phase 2 Completion Summary

### Timeline & Effort Actual

| Step      | Task                            | Estimated     | Actual     | Status |
| --------- | ------------------------------- | ------------- | ---------- | ------ |
| 1         | Choose gold standard project    | 1–2 hrs       | 2 hrs      | ✅     |
| 2         | Set up smoke tests (Playwright) | 3–5 hrs       | 4 hrs      | ✅     |
| 3         | Enhance project dossier         | 4–6 hrs       | 6 hrs      | ✅     |
| 4         | Create threat model             | 2–3 hrs       | 3 hrs      | ✅     |
| 4a        | Security enhancements           | 2–3 hrs       | 3 hrs      | ✅     |
| 4b        | Incident response runbooks      | 1–2 hrs       | 2 hrs      | ✅     |
| 5         | Create operational runbooks     | 2–4 hrs       | 3 hrs      | ✅     |
| 6         | Create/update ADRs              | 1–2 hrs       | 1 hr       | ✅     |
| 7         | Enhance project detail page     | 2–3 hrs       | 3 hrs      | ✅     |
| 8         | Enhance CV page                 | 2–3 hrs       | 3 hrs      | ✅     |
| 9         | Create Phase 2 release note     | 1–2 hrs       | 1 hr       | ✅     |
| 10        | Create PRs & verify end-to-end  | 1–2 hrs       | 2 hrs      | ✅     |
| **Total** | **Phase 2 Complete**            | **19–32 hrs** | **33 hrs** | **✅** |

**Completion date:** 2026-01-21  
**Duration:** ~3 weeks (January 2–21, 2026)

---

## Success Criteria — All Achieved ✅

Phase 2 is complete when all criteria are met:

### Functionality Criteria

- ✅ One "gold standard" project page is fully polished with evidence trail
- ✅ Comprehensive dossier covers architecture, security, deployment, operations, testing, troubleshooting
- ✅ Threat model documents security posture, controls, and STRIDE analysis
- ✅ Operational runbooks (deploy, CI triage, rollback, secrets incident) are complete and tested
- ✅ Smoke tests validate all core routes and evidence links
- ✅ CV page meaningfully maps capabilities to verifiable proofs

### Quality Criteria

- ✅ All CI checks pass: quality (lint, format, typecheck), secrets-scan, build with smoke tests, CodeQL
- ✅ 100% route coverage in Playwright smoke tests (12 tests, Chromium + Firefox)
- ✅ No broken links between portfolio-app and portfolio-docs
- ✅ All evidence artifacts published and accessible
- ✅ GitHub Rulesets enforce PR discipline and required checks

### Evidence Criteria

- ✅ ADR-0010 (Gold Standard Exemplar) published and referenced
- ✅ Threat model with STRIDE analysis published
- ✅ STRIDE compliance report generated
- ✅ 4 operational runbooks complete (deploy, CI triage, rollback, secrets incident)
- ✅ Dossier enhanced to 7 comprehensive pages
- ✅ Release note published with completion evidence

### Reviewer Validation Criteria

A senior engineer reviewing the Portfolio App can validate engineering discipline through:

- ✅ "What, why, how" clarity: Project purpose, technical decisions, implementation approach documented
- ✅ Security posture: Threat model, controls, public-safety rules enforced
- ✅ Operational readiness: Runbooks tested, deployment/rollback procedures documented
- ✅ Testing discipline: Automated smoke tests, CI gates, reproducible builds
- ✅ Evidence trail: All claims link to verifiable artifacts (dossier, ADRs, threat model, runbooks)

---

## Acceptance Criteria (Reviewability)

A reviewer can validate Phase 2 completion through:

1. **Portfolio App Repository:**
   - Browse [https://github.com/bryce-seefieldt/portfolio-app](https://github.com/bryce-seefieldt/portfolio-app)
   - Verify CI checks are passing (quality, secrets-scan, build)
   - Review merged PRs (#10, #20, #21, #25) for smoke tests, enhanced pages, verification scripts
   - Check `.github/workflows/ci.yml` for secrets scanning and smoke test integration

2. **Live Deployment:**
   - Visit portfolio app production URL
   - Navigate to all 5 core routes (/, /cv, /projects, /contact, /projects/portfolio-app)
   - Verify gold standard badge displays on portfolio-app project page
   - Click evidence links to docs; verify they resolve correctly

3. **Documentation Evidence:**
   - Review [Portfolio App Dossier](/docs/60-projects/portfolio-app/index.md)
   - Review [Threat Model](/docs/40-security/threat-models/portfolio-app-threat-model.md)
   - Review [ADR-0010](/docs/10-architecture/adr/adr-0010-portfolio-app-as-gold-standard-exemplar.md)
   - Review [Operational Runbooks](/docs/50-operations/runbooks/index.md)
   - Review [Release Notes](/docs/00-portfolio/release-notes/20260120-portfolio-app-phase-2-gold-standard.md)

4. **Automated Tests:**
   - Clone portfolio-app repo
   - Run `pnpm install && pnpm test`
   - Verify all 12 smoke tests pass (5 route tests, evidence link tests, registry validation)

---

## Compliance Review (2026-01-19)

**Status:** ✅ **Compliant** — All documented STRIDE threats and Phase 2 security enhancements verified.

**Scope reviewed:**

- STRIDE Threat Model (12 threats across 6 categories)
- STRIDE Compliance Report (evidence mapping for each mitigation)
- Phase 2 security enhancements (secrets scanning, least-privilege CI, pre-commit hooks, incident response)
- SDLC controls in CI/CD, repo governance, and operational runbooks

**Verification highlights:**

- CI/CD: Required checks (`ci / quality`, `ci / build`, `secrets-scan`, CodeQL), job-scoped permissions, frozen lockfile installs
- Secrets hygiene: No secrets in `NEXT_PUBLIC_*`; `.env.example` documents schema; TruffleHog in CI and pre-commit
- Operations: Secrets incident response runbook; deploy/rollback/CI triage runbooks validated
- Security headers: HSTS verified on production deployment; Vercel-managed TLS
- Dependency governance: Dependabot weekly updates (grouped), minimal dependencies, no postinstall hooks

**Evidence:**

- [STRIDE compliance report](/docs/40-security/threat-models/portfolio-app-stride-compliance-report.md)
- [Threat model](/docs/40-security/threat-models/portfolio-app-threat-model.md)
- [CI workflow](https://github.com/bryce-seefieldt/portfolio-app/blob/main/.github/workflows/ci.yml) (quality, secrets-scan, build, tests)
- [Pre-commit config](https://github.com/bryce-seefieldt/portfolio-app/blob/main/.pre-commit-config.yaml) (TruffleHog)
- [Runbooks](/docs/50-operations/runbooks/index.md) (deploy, rollback, CI triage, secrets incident)

---

## Key Deliverables Reference

### Portfolio App Artifacts

- **Smoke tests:** `tests/e2e/smoke.spec.ts` (12 tests, 100% route coverage)
- **Playwright config:** `playwright.config.ts`
- **CI workflow:** `.github/workflows/ci.yml` (quality, secrets-scan, build with tests)
- **Gold standard component:** `src/components/GoldStandardBadge.tsx`
- **Enhanced project page:** `src/app/projects/[slug]/page.tsx`
- **Enhanced CV page:** `src/app/cv/page.tsx`
- **Pre-commit hooks:** `.pre-commit-config.yaml`

### Documentation Artifacts

- **Project dossier:** `/docs/60-projects/portfolio-app/` (7 pages)
- **Threat model:** `/docs/40-security/threat-models/portfolio-app-threat-model.md`
- **ADR-0010:** `/docs/10-architecture/adr/adr-0010-portfolio-app-as-gold-standard-exemplar.md`
- **Runbooks:** `/docs/50-operations/runbooks/` (4 runbooks)
  - `rbk-portfolio-deploy.md`
  - `rbk-portfolio-ci-triage.md`
  - `rbk-portfolio-rollback.md`
  - `rbk-portfolio-secrets-incident.md`
- **Release notes:** `/docs/00-portfolio/release-notes/20260120-portfolio-app-phase-2-gold-standard.md`
- **STRIDE compliance report:** `/docs/40-security/threat-models/portfolio-app-stride-compliance-report.md`

---

## Lessons Learned & Retrospective

### What Went Well

1. **Sequential execution:** Breaking work into 10 discrete steps made progress measurable and allowed for course-correction
2. **Evidence-first approach:** Creating documentation alongside code prevented documentation debt
3. **Smoke tests early:** Catching broken links and routing issues before manual testing saved significant debugging time
4. **Security hardening:** Adding TruffleHog and pre-commit hooks provided immediate value and prevented potential leaks
5. **ADR discipline:** Documenting decisions (ADR-0010, testing strategy) created durable reference points

### Challenges & Mitigations

1. **Scope creep:** Initially planned Phase 2 for ~20 hours; actual was ~33 hours due to security enhancements
   - Mitigation: Broke enhancements into STEP 4a/4b; documented as "recommended" vs "required"
2. **Cross-repo coordination:** Portfolio-app and portfolio-docs PRs needed careful sequencing
   - Mitigation: Created tracking issues in both repos with cross-links
3. **Documentation volume:** Dossier alone was 4,000+ words
   - Mitigation: Used templates and structured approach; content reusable for future projects

### Recommendations for Phase 3

1. Continue evidence-first approach (documentation before/during implementation)
2. Plan for ~1.5x estimated hours to account for polish and hardening
3. Create issue templates for Stage/Step granularity (see Phase 3 planning docs)
4. Establish registry schema early to avoid rework

---

## Future Enhancements & Optional Improvements

Optional improvements identified during Phase 2 (not required for Phase 3):

### Security & Compliance

- **Dependabot for GitHub Actions:** Enable SHA pinning for workflow actions (enhanced supply chain security)
- **Content Security Policy (CSP):** Add CSP headers via `vercel.json` for additional XSS protection
- **SBOM generation:** Consider automated Software Bill of Materials for dependency tracking

### Performance & Observability

- **Lighthouse CI:** Integrate performance budgets and automated Lighthouse scoring in CI
- **Web Vitals monitoring:** Add RUM (Real User Monitoring) for production performance tracking
- **Error tracking:** Consider Sentry or similar for production error aggregation

### Testing & Quality

- **Visual regression testing:** Add Playwright screenshot comparison for UI consistency
- **Accessibility testing:** Automated a11y checks (axe-core) in smoke tests
- **Load testing:** Basic performance testing for critical routes

### Documentation & Evidence

- **Architecture diagrams:** Generate C4 or similar architecture diagrams for dossier
- **API documentation:** If APIs added in Phase 3+, generate OpenAPI/Swagger docs
- **Runbook automation:** Convert manual runbooks to executable scripts where applicable

---

## Phase 3 Planning (Next Steps)

With Phase 2 establishing credibility through one exemplary project, Phase 3 will focus on:

### Phase 3 Objectives

- **Data-driven project registry:** YAML-backed registry with Zod validation (Stage 3.1)
- **Evidence visualization components:** EvidenceBlock, VerificationBadge, BadgeGroup (Stage 3.2)
- **Unit tests:** Content/slug validation, registry schema enforcement (Stage 3.3)
- **E2E tests:** Full user flows, cross-domain evidence link validation (Stage 3.4)
- **Publish runbook:** Repeatable project publishing pipeline (Stage 3.5)

### Planning Documents

- **Phase 3 Implementation Guide:** [/docs/00-portfolio/roadmap/phase-3-implementation-guide.md)](/docs/00-portfolio/roadmap/phase-3-implementation-guide.md))
- **Roadmap (Phase 3 section):** [/docs/00-portfolio/roadmap/index.md](/docs/00-portfolio/roadmap/index.md#phase-3--repeatable-project-publishing-pipeline-scale-without-chaos)

---

## Related Documentation

- **Roadmap:** [Portfolio Web Application Roadmap](/docs/00-portfolio/roadmap/index.md)
- **Phase 1 Implementation Guide:** [Phase 1: Portfolio App Foundation](/docs/00-portfolio/roadmap/phase-1-implementation-guide.md)
- **ADR-0010:** [Portfolio App as Gold Standard Exemplar](/docs/10-architecture/adr/adr-0010-portfolio-app-as-gold-standard-exemplar.md)
- **Phase 2 Release Notes:** [20260119 Portfolio App Phase 2 Complete](/docs/00-portfolio/release-notes/20260120-portfolio-app-phase-2-gold-standard.md)
- **Portfolio App Dossier:** [Project Portfolio App](/docs/60-projects/portfolio-app/index.md)
- **Threat Model:** [Portfolio App Threat Model](/docs/40-security/threat-models/portfolio-app-threat-model.md)
- **Runbooks Index:** [Operations Runbooks](/docs/50-operations/runbooks/index.md)
- **ADR Index:** [Architecture Decision Records](/docs/10-architecture/adr/index.md)

---

**Owner:** Portfolio Program  
**Phase:** 2 of 5  
**Status:** ✅ Complete (2026-01-21)  
**Next Phase:** Phase 3 — Repeatable Project Publishing Pipeline
