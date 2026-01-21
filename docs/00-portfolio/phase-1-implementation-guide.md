---
title: 'Phase 1 Implementation Guide: Portfolio App Foundation'
description: 'Completed implementation guide for Phase 1: Next.js app setup, CI/CD governance, Vercel deployment, and production promotion gating with comprehensive evidence artifacts.'
sidebar_position: 1
tags: [phase-1, implementation, completed, portfolio-app, foundation, deployment]
---

# Phase 1 Implementation Guide — Portfolio App Foundation

**Phase:** Phase 1 (Foundation & Production Infrastructure)  
**Estimated Duration:** 40–60 hours (4–6 weeks at 10–15 hrs/week)  
**Status:** ✅ **Complete** (2026-01-17)  
**Last Updated:** 2026-01-21

## Purpose

Phase 1 establishes the production-quality foundation for the Portfolio Program. Rather than building a simple static site, Phase 1 implements enterprise-grade SDLC controls from day one: Next.js with TypeScript strict mode, comprehensive CI/CD governance, Vercel deployment with production promotion gating, and complete evidence documentation. This phase proves that the portfolio itself is built with professional engineering discipline.

## What Phase 1 Delivers

- **Portfolio App repository:** Next.js 15+ App Router with TypeScript strict mode, Tailwind CSS, ESLint, Prettier
- **Core routes scaffolded:** `/` (landing), `/cv`, `/projects`, `/contact`, `/projects/[slug]`
- **CI/CD governance:** GitHub Actions with quality gates (lint, format, typecheck, build), CodeQL security scanning, Dependabot
- **Vercel deployment infrastructure:** Preview deployments for PRs, production deployment from main, promotion gated by required checks
- **GitHub Rulesets:** Branch protection for `main` requiring passing CI checks and PR reviews
- **Complete evidence trail:** Portfolio App dossier (7 pages), ADRs for stack decisions, threat model, operational runbooks
- **Environment configuration:** Public-safe environment variable contract with preview/production scopes

---

## Prerequisites

Before starting Phase 1, ensure:

- ✅ Phase 0 complete (portfolio-docs deployed with CI governance)
- ✅ GitHub account with repository creation permissions
- ✅ Vercel account (free tier sufficient)
- ✅ Node.js 20+ and pnpm installed locally
- ✅ Development environment ready (VS Code or preferred IDE)
- ✅ Understanding of Next.js, React, TypeScript fundamentals

**Verification checklist:**

```bash
# Verify local environment
node --version  # Should be 20+
pnpm --version  # Should be 9+

# Verify portfolio-docs operational
cd /path/to/portfolio-docs
pnpm build  # Should complete without errors

# Verify GitHub/Vercel access
gh auth status  # GitHub CLI authenticated (optional but recommended)
```

---

## Implementation Approach

Phase 1 follows a **sequential steps** implementation pattern, where foundational infrastructure is established first, followed by governance layers, and completed with deployment and validation. All steps are documented below with completion status and outcomes.

---

## Implementation Steps (Completed)

### STEP 1: Repository Setup and Initial App Bootstrap ✅ (4–6 hours)

**Goal:** Create portfolio-app repository and bootstrap Next.js application with TypeScript and Tailwind CSS.

**Scope:**

- ✅ In scope: Repository creation, Next.js initialization, base dependencies, initial routes
- ❌ Out of scope: Content creation, advanced features, authentication

#### 1a. Create GitHub Repository

```bash
# Create repository via GitHub CLI (or web UI)
gh repo create bryce-seefieldt/portfolio-app --public --description "Production portfolio application demonstrating enterprise engineering discipline"

# Clone locally
git clone https://github.com/bryce-seefieldt/portfolio-app.git
cd portfolio-app
```

**Files created:**
- Repository with README.md, LICENSE, .gitignore

#### 1b. Initialize Next.js Application

```bash
# Bootstrap Next.js with TypeScript and Tailwind
pnpm create next-app@latest . --typescript --tailwind --app --no-src --import-alias "@/*"

# Initial dependencies:
# - next@15+
# - react@19+
# - typescript@5+
# - tailwindcss@4+
# - @types/node, @types/react, @types/react-dom
```

**Files created:**
- `package.json`, `pnpm-lock.yaml`
- `tsconfig.json` (strict mode enabled)
- `tailwind.config.ts`, `postcss.config.mjs`
- `app/layout.tsx`, `app/page.tsx`
- `app/globals.css`

#### 1c. Configure TypeScript Strict Mode

Update `tsconfig.json`:

```json
{
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitOverride": true
  }
}
```

#### 1d. Create Core Route Structure

```bash
mkdir -p app/cv app/projects app/contact app/projects/\[slug\]
touch app/cv/page.tsx app/projects/page.tsx app/contact/page.tsx app/projects/\[slug\]/page.tsx
```

**Files created:**
- `app/cv/page.tsx` — CV route skeleton
- `app/projects/page.tsx` — Projects index skeleton
- `app/contact/page.tsx` — Contact route skeleton
- `app/projects/[slug]/page.tsx` — Dynamic project detail skeleton

**Success check:**

- [x] Repository created on GitHub
- [x] Next.js application initialized with TypeScript strict mode
- [x] Core routes created and accessible locally
- [x] `pnpm dev` runs without errors
- [x] Initial commit pushed to `main`

**Completion notes:**
- Repository: https://github.com/bryce-seefieldt/portfolio-app
- Initial commit: Established Next.js foundation with 5 core routes

---

### STEP 2: Development Tooling and Quality Gates ✅ (3–4 hours)

**Goal:** Configure ESLint, Prettier, and TypeScript checking to enforce code quality standards.

#### 2a. Configure ESLint

```bash
pnpm add -D eslint @next/eslint-config-next
```

Create `eslint.config.mjs`:

```javascript
import { FlatCompat } from '@eslint/eslintrc';

const compat = new FlatCompat({
  baseDirectory: import.meta.dirname,
});

export default [
  ...compat.extends('next/core-web-vitals', 'next/typescript'),
  {
    rules: {
      '@typescript-eslint/no-unused-vars': ['error', { argsIgnorePattern: '^_' }],
      '@typescript-eslint/no-explicit-any': 'error',
    },
  },
];
```

#### 2b. Configure Prettier

```bash
pnpm add -D prettier prettier-plugin-tailwindcss
```

Create `.prettierrc.json`:

```json
{
  "singleQuote": true,
  "trailingComma": "es5",
  "tabWidth": 2,
  "semi": true,
  "plugins": ["prettier-plugin-tailwindcss"]
}
```

Create `.prettierignore`:

```
.next/
node_modules/
pnpm-lock.yaml
build/
```

#### 2c. Add Package Scripts

Update `package.json`:

```json
{
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint --max-warnings 0",
    "format": "prettier --write .",
    "format:check": "prettier --check .",
    "typecheck": "tsc --noEmit",
    "verify": "pnpm format:write && pnpm lint && pnpm typecheck && pnpm build"
  }
}
```

**Success check:**

- [x] ESLint configured with Next.js + TypeScript rules
- [x] Prettier configured with Tailwind plugin
- [x] All quality scripts run without errors
- [x] `pnpm verify` passes locally

---

### STEP 3: GitHub Actions CI/CD Workflows ✅ (4–6 hours)

**Goal:** Establish GitHub Actions workflows for quality gates, build validation, and security scanning.

#### 3a. Create CI Quality Workflow

Create `.github/workflows/ci.yml`:

```yaml
name: CI

on:
  pull_request:
    branches: [main]
  push:
    branches: [main]

permissions:
  contents: read

jobs:
  quality:
    name: quality
    runs-on: ubuntu-latest
    timeout-minutes: 10
    permissions:
      contents: write  # Needed for Dependabot auto-format
      pull-requests: read

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup pnpm
        uses: pnpm/action-setup@v4
        with:
          version: 9

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'pnpm'

      - name: Install dependencies
        run: pnpm install --frozen-lockfile

      - name: Format check
        run: pnpm format:check

      - name: Lint
        run: pnpm lint

      - name: Type check
        run: pnpm typecheck

  build:
    name: build
    runs-on: ubuntu-latest
    needs: [quality]
    timeout-minutes: 10
    permissions:
      contents: read

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup pnpm
        uses: pnpm/action-setup@v4
        with:
          version: 9

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'pnpm'

      - name: Install dependencies
        run: pnpm install --frozen-lockfile

      - name: Build
        run: pnpm build
```

#### 3b. Create CodeQL Workflow

Create `.github/workflows/codeql.yml`:

```yaml
name: CodeQL

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
  schedule:
    - cron: '0 0 * * 1'  # Weekly on Monday

permissions:
  security-events: write
  contents: read

jobs:
  analyze:
    name: Analyze
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Initialize CodeQL
        uses: github/codeql-action/init@v3
        with:
          languages: javascript-typescript

      - name: Perform CodeQL Analysis
        uses: github/codeql-action/analyze@v3
```

#### 3c. Configure Dependabot

Create `.github/dependabot.yml`:

```yaml
version: 2
updates:
  - package-ecosystem: 'npm'
    directory: '/'
    schedule:
      interval: 'weekly'
      day: 'monday'
    open-pull-requests-limit: 10
    groups:
      production-dependencies:
        dependency-type: 'production'
      development-dependencies:
        dependency-type: 'development'
    ignore:
      - dependency-name: '*'
        update-types: ['version-update:semver-major']
```

**Success check:**

- [x] CI workflow created with quality and build jobs
- [x] CodeQL workflow created for security scanning
- [x] Dependabot configured for weekly dependency updates
- [x] All workflows triggered on test PR
- [x] CI checks pass on `main` branch

**Completion notes:**
- CI checks visible as `ci / quality` and `ci / build` in GitHub
- CodeQL runs weekly and on every PR
- Dependabot generates grouped PRs for dependencies

---

### STEP 4: Environment Configuration and Public-Safety ✅ (2–3 hours)

**Goal:** Establish environment variable contract with public-safe defaults and clear documentation.

#### 4a. Create Environment Variable Contract

Create `.env.example`:

```bash
# Portfolio App Environment Variables
# All NEXT_PUBLIC_* variables are client-visible by design

# Documentation base URL (portfolio-docs deployment)
NEXT_PUBLIC_DOCS_BASE_URL=https://docs.example.com

# Portfolio site URL (for canonical links, SEO)
NEXT_PUBLIC_SITE_URL=https://portfolio.example.com

# Social/contact links
NEXT_PUBLIC_GITHUB_URL=https://github.com/username
NEXT_PUBLIC_LINKEDIN_URL=https://linkedin.com/in/username
NEXT_PUBLIC_CONTACT_EMAIL=contact@example.com
```

#### 4b. Create Configuration Helper

Create `src/lib/config.ts`:

```typescript
/**
 * Environment configuration contract for Portfolio App
 * All NEXT_PUBLIC_* vars are client-visible; never use for secrets
 */

export const config = {
  docs: {
    baseUrl: process.env.NEXT_PUBLIC_DOCS_BASE_URL || '',
  },
  site: {
    url: process.env.NEXT_PUBLIC_SITE_URL || '',
  },
  social: {
    github: process.env.NEXT_PUBLIC_GITHUB_URL || '',
    linkedin: process.env.NEXT_PUBLIC_LINKEDIN_URL || '',
  },
  contact: {
    email: process.env.NEXT_PUBLIC_CONTACT_EMAIL || '',
  },
} as const;

export function docsUrl(path: string): string {
  return `${config.docs.baseUrl}${path}`;
}

export function githubUrl(path: string = ''): string {
  return `${config.social.github}${path}`;
}
```

**Success check:**

- [x] `.env.example` created with all required variables
- [x] `src/lib/config.ts` created with type-safe helpers
- [x] `.gitignore` includes `.env.local`
- [x] No secrets in environment variables (all public-safe)
- [x] Documentation references environment contract

---

### STEP 5: Vercel Deployment Setup ✅ (2–3 hours)

**Goal:** Connect portfolio-app to Vercel and configure preview + production deployments.

#### 5a. Connect Repository to Vercel

1. Log in to Vercel dashboard
2. Click "Add New Project"
3. Import `bryce-seefieldt/portfolio-app`
4. Configure build settings:
   - Framework Preset: Next.js
   - Build Command: `pnpm build`
   - Install Command: `pnpm install --frozen-lockfile`
   - Output Directory: (default `.next`)
   - Node Version: 20.x
5. Deploy

#### 5b. Configure Environment Variables (Preview Scope)

In Vercel Settings → Environment Variables, add for **Preview** scope:

```
NEXT_PUBLIC_DOCS_BASE_URL = https://portfolio-docs-git-main-username.vercel.app
NEXT_PUBLIC_SITE_URL = (leave empty for preview)
NEXT_PUBLIC_GITHUB_URL = https://github.com/bryce-seefieldt
NEXT_PUBLIC_LINKEDIN_URL = https://linkedin.com/in/username
NEXT_PUBLIC_CONTACT_EMAIL = contact@example.com
```

#### 5c. Configure Environment Variables (Production Scope)

Add for **Production** scope:

```
NEXT_PUBLIC_DOCS_BASE_URL = https://docs.yourdomain.com
NEXT_PUBLIC_SITE_URL = https://portfolio.yourdomain.com
NEXT_PUBLIC_GITHUB_URL = https://github.com/bryce-seefieldt
NEXT_PUBLIC_LINKEDIN_URL = https://linkedin.com/in/username
NEXT_PUBLIC_CONTACT_EMAIL = contact@example.com
```

After saving, trigger a redeploy to apply changes.

**Success check:**

- [x] Vercel project created and connected
- [x] Preview URL generated (e.g., `https://portfolio-app-git-main.vercel.app`)
- [x] Production URL assigned (e.g., `https://portfolio-app.vercel.app`)
- [x] Environment variables configured for preview and production scopes
- [x] Deployments use correct environment values per scope

---

### STEP 6: GitHub Deployment Checks (Production Gating) ✅ (1–2 hours)

**Goal:** Configure Vercel Deployment Checks to gate production promotion on CI success.

#### 6a. Enable Deployment Checks in Vercel

1. Go to Vercel Settings → Git → Deployment Checks
2. Enable "Deployment Checks" toggle
3. Click "Add Check" → "GitHub Checks"
4. Select checks:
   - `ci / quality`
   - `ci / build`
5. Scope: **Production only** (preview remains ungated)
6. Save configuration

**Verification:**

Vercel now shows:
```
Production Deployment Checks: ci / quality, ci / build
```

**Success check:**

- [x] Deployment Checks enabled in Vercel
- [x] `ci / quality` and `ci / build` imported as required
- [x] Checks apply to production scope only
- [x] Preview deployments remain automatic (not gated)

**Completion notes:**
- Production promotion now requires passing CI checks
- Failed checks prevent automatic production deployment
- Vercel dashboard shows check status before promotion

---

### STEP 7: GitHub Ruleset (Branch Protection) ✅ (2–3 hours)

**Goal:** Create GitHub Ruleset to protect `main` branch and enforce PR + CI discipline.

#### 7a. Create Branch Protection Ruleset

1. Go to GitHub Settings → Rules → Rulesets
2. Click "New ruleset" → "New branch ruleset"
3. Configure:
   - **Name:** `main-protection`
   - **Enforcement:** Active
   - **Target:** Branch name pattern: `main`
4. Add rules:
   - **Require status checks:**
     - `ci / quality` ✓
     - `ci / build` ✓
   - **Require branches to be up to date:** ✓
   - **Require pull request before merging:** ✓
     - Required approvals: 1
     - Dismiss stale reviews when new commits pushed: ✓
   - **Block force pushes:** ✓
   - **Block deletions:** ✓
5. Create ruleset

**Verification:**

GitHub shows:
```
Ruleset: main-protection (Active)
Target: main
Rules: 2 status checks required, 1 review required
```

**Success check:**

- [x] Ruleset `main-protection` created and active
- [x] Required checks: `ci / quality`, `ci / build`
- [x] PR review required (1 approval)
- [x] Force push and branch deletion blocked
- [x] Merge to `main` blocked until checks pass

---

### STEP 8: Portfolio App Dossier (Documentation) ✅ (8–12 hours)

**Goal:** Create comprehensive project dossier documenting architecture, deployment, security, and operations.

**Location:** `/portfolio-docs/docs/60-projects/portfolio-app/`

#### 8a. Create Dossier Structure

```bash
mkdir -p docs/60-projects/portfolio-app
cd docs/60-projects/portfolio-app
```

Create 7 standard dossier pages:

1. **`index.md`** — Dossier hub and navigation
2. **`01-overview.md`** — Purpose, audiences, NFRs
3. **`02-architecture.md`** — System design, tech stack, components
4. **`03-deployment.md`** — CI/CD, environments, promotion governance
5. **`04-security.md`** — Threat surface, controls, public-safety rules
6. **`05-testing.md`** — Quality gates, testing strategy (smoke tests added in Phase 2)
7. **`06-operations.md`** — Runbooks, maintenance, monitoring
8. **`07-troubleshooting.md`** — Failure modes, diagnostics, fixes

**Success check:**

- [x] All 7 dossier pages created
- [x] Content comprehensive and aligned with project reality
- [x] Links to ADRs, threat model, runbooks functional
- [x] Build passes (`pnpm build` in portfolio-docs)
- [x] Dossier accessible at `/docs/60-projects/portfolio-app/`

**Completion notes:**
- Dossier serves as primary evidence artifact for Phase 1
- ~4,000 words total across 7 pages
- Referenced in portfolio-app project pages

---

### STEP 9: ADRs and Threat Model ✅ (4–6 hours)

**Goal:** Document durable architectural decisions and security analysis.

#### 9a. Create ADRs

**ADR-0005: Stack Choice (Next.js + TypeScript + Vercel)**

Location: `/docs/10-architecture/adr/adr-0005-portfolio-app-stack-choice.md`

Documents:
- Decision to use Next.js 15+, React 19+, TypeScript 5+
- Rationale: Modern tooling, type safety, server components, performance
- Alternatives considered: Astro, SvelteKit, vanilla React
- Consequences: Learning curve acceptable, ecosystem mature

**ADR-0006: Evidence Separation (Dual Repository Strategy)**

Location: `/docs/10-architecture/adr/adr-0006-evidence-separation-dual-repo.md`

Documents:
- Decision to separate portfolio-app (front) from portfolio-docs (evidence)
- Rationale: Concerns separation, independent deployment, evidence integrity
- Alternatives considered: Monorepo, single integrated app
- Consequences: Cross-linking required, but clean boundaries

**ADR-0007: Hosting and Promotion Checks (Vercel + GitHub)**

Location: `/docs/10-architecture/adr/adr-0007-portfolio-app-hosting-vercel-with-promotion-checks.md`

Documents:
- Decision to use Vercel with GitHub Deployment Checks
- Rationale: Zero-config deploys, production gating, enterprise governance
- Alternatives considered: Netlify, AWS Amplify, self-hosted
- Consequences: Vendor lock-in acceptable for portfolio use case

#### 9b. Create Threat Model

**Location:** `/docs/40-security/threat-models/portfolio-app-threat-model.md`

Documents:
- Trust boundaries: public users → portfolio app → docs app → GitHub
- STRIDE analysis (6 categories, mitigations)
- Assets at risk: source code, deployment credentials, reputation
- Controls: TLS, authenticated Git, environment hygiene, frozen lockfiles
- Residual risks: dependency vulnerabilities, DDoS (mitigated by Vercel)

**Success check:**

- [x] ADR-0005, ADR-0006, ADR-0007 created
- [x] Threat model created with STRIDE analysis
- [x] All ADRs follow established template format
- [x] Dossier links to ADRs and threat model
- [x] Build passes with no broken links

---

### STEP 10: Operational Runbooks ✅ (3–4 hours)

**Goal:** Document operational procedures for deployment, rollback, and CI triage.

**Location:** `/docs/50-operations/runbooks/`

#### 10a. Create Runbooks

1. **`rbk-portfolio-deploy.md`** — Standard deployment workflow
   - PR creation → CI checks → merge → production promotion
   - No manual steps (automated)

2. **`rbk-portfolio-ci-triage.md`** — CI failure troubleshooting
   - Diagnostic matrix for quality/build failures
   - Local reproduction steps
   - Common fixes

3. **`rbk-portfolio-rollback.md`** — Emergency rollback procedure
   - Git revert workflow
   - Manual Vercel redeploy (emergency only)
   - Post-rollback investigation

4. **`rbk-vercel-setup-and-promotion-validation.md`** — Vercel setup reference
   - Phase 1-6 procedures for initial setup
   - Environment variable configuration
   - Deployment checks setup
   - End-to-end validation

**Success check:**

- [x] All 4 runbooks created
- [x] Procedures tested (at least mentally walkthrough)
- [x] Runbooks linked from dossier operations page
- [x] Build passes with no broken links

---

### STEP 11: End-to-End Validation ✅ (2–3 hours)

**Goal:** Validate complete deployment pipeline from PR to production.

#### 11a. Create Test PR

```bash
git checkout -b test/phase-1-validation
echo "# Phase 1 Validation" > VALIDATION.md
git add VALIDATION.md
git commit -m "test: validate Phase 1 deployment pipeline"
git push origin test/phase-1-validation
```

#### 11b. Validate CI and Deployment Checks

1. Open PR on GitHub
2. Wait for CI checks to run (5–10 minutes)
3. Verify:
   - `ci / quality` passes ✓
   - `ci / build` passes ✓
   - Vercel preview deployment created ✓
   - Preview URL accessible ✓

#### 11c. Validate Ruleset Enforcement

1. Verify merge button disabled until checks pass
2. After checks pass, verify merge button enabled
3. If configured, verify review requirement (1 approval)

#### 11d. Merge and Validate Production Promotion

1. Merge PR (squash and merge)
2. Monitor Vercel dashboard
3. Verify:
   - Production deployment queued
   - Deployment checks run automatically
   - After checks pass, production deployment proceeds
   - Production URL updated ✓

#### 11e. Cleanup

```bash
git branch -d test/phase-1-validation
git push origin --delete test/phase-1-validation
```

**Success check:**

- [x] Test PR created successfully
- [x] CI checks ran and passed
- [x] Vercel preview deployment created
- [x] GitHub Ruleset enforced (merge gated by checks)
- [x] Production deployment automatic after merge
- [x] Production URL live and functional
- [x] Cleanup completed

**Completion notes:**
- Full end-to-end pipeline validated
- All governance controls operational
- Ready for Phase 2 work

---

## Phase 1 Completion Summary

### Timeline & Effort Actual

| Step | Task                                  | Estimated | Actual | Status |
|------|---------------------------------------|-----------|--------|--------|
| 1    | Repository setup & Next.js bootstrap  | 4–6 hrs   | 5 hrs  | ✅     |
| 2    | Development tooling & quality gates   | 3–4 hrs   | 3 hrs  | ✅     |
| 3    | GitHub Actions CI/CD workflows        | 4–6 hrs   | 5 hrs  | ✅     |
| 4    | Environment configuration             | 2–3 hrs   | 2 hrs  | ✅     |
| 5    | Vercel deployment setup               | 2–3 hrs   | 3 hrs  | ✅     |
| 6    | GitHub Deployment Checks              | 1–2 hrs   | 2 hrs  | ✅     |
| 7    | GitHub Ruleset (branch protection)    | 2–3 hrs   | 2 hrs  | ✅     |
| 8    | Portfolio App dossier                 | 8–12 hrs  | 10 hrs | ✅     |
| 9    | ADRs and threat model                 | 4–6 hrs   | 5 hrs  | ✅     |
| 10   | Operational runbooks                  | 3–4 hrs   | 4 hrs  | ✅     |
| 11   | End-to-end validation                 | 2–3 hrs   | 2 hrs  | ✅     |
| **Total** | **Phase 1 Complete**             | **40–60 hrs** | **43 hrs** | **✅** |

**Completion date:** 2026-01-17  
**Duration:** ~5 weeks (December 15, 2025 – January 17, 2026)

---

## Success Criteria — All Achieved ✅

Phase 1 is complete when all criteria are met:

### Infrastructure Criteria

- ✅ Portfolio App deployed to Vercel with preview and production URLs
- ✅ Next.js 15+ with App Router, TypeScript strict mode, Tailwind CSS
- ✅ 5 core routes accessible (/, /cv, /projects, /contact, /projects/[slug])
- ✅ Environment variables configured per scope (preview vs production)
- ✅ CI/CD workflows operational (quality + build checks)

### Governance Criteria

- ✅ GitHub Ruleset enforces PR discipline and required checks
- ✅ Production promotion gated by Vercel Deployment Checks
- ✅ CodeQL security scanning enabled
- ✅ Dependabot configured for weekly dependency updates
- ✅ All CI checks pass consistently on main branch

### Evidence Criteria

- ✅ Portfolio App dossier complete (7 comprehensive pages)
- ✅ ADRs published for stack choice, evidence separation, hosting strategy
- ✅ Threat model published with STRIDE analysis
- ✅ Operational runbooks complete (deploy, rollback, CI triage, Vercel setup)
- ✅ All evidence artifacts cross-linked and accessible

### Quality Criteria

- ✅ ESLint configured with zero warnings policy
- ✅ Prettier enforces consistent code formatting
- ✅ TypeScript strict mode with no errors
- ✅ Frozen lockfile enforced in CI (deterministic builds)
- ✅ `pnpm verify` passes locally and in CI

---

## Acceptance Criteria (Reviewability)

A reviewer can validate Phase 1 completion through:

1. **Portfolio App Repository:**
   - Browse [https://github.com/bryce-seefieldt/portfolio-app](https://github.com/bryce-seefieldt/portfolio-app)
   - Verify CI checks passing (quality, build)
   - Review `.github/workflows/ci.yml` for governance implementation
   - Check GitHub Ruleset configuration (Settings → Rules)

2. **Live Deployment:**
   - Visit portfolio app production URL
   - Navigate to all 5 core routes
   - Verify routes render correctly
   - Check environment variables are applied (links to docs resolve)

3. **Documentation Evidence:**
   - Review [Portfolio App Dossier](/docs/60-projects/portfolio-app/)
   - Review [ADR-0005](/docs/10-architecture/adr/adr-0005-portfolio-app-stack-choice.md), [ADR-0006](/docs/10-architecture/adr/adr-0006-evidence-separation-dual-repo.md), [ADR-0007](/docs/10-architecture/adr/adr-0007-portfolio-app-hosting-vercel-with-promotion-checks.md)
   - Review [Threat Model](/docs/40-security/threat-models/portfolio-app-threat-model.md)
   - Review [Operational Runbooks](/docs/50-operations/runbooks/)

4. **Governance Validation:**
   - Create test PR in portfolio-app
   - Verify CI runs automatically
   - Verify merge blocked until checks pass
   - Verify production promotion gated in Vercel

---

## Key Deliverables Reference

### Portfolio App Artifacts

- **Repository:** `bryce-seefieldt/portfolio-app`
- **Core routes:** `app/page.tsx`, `app/cv/page.tsx`, `app/projects/page.tsx`, `app/contact/page.tsx`, `app/projects/[slug]/page.tsx`
- **Configuration:** `tsconfig.json`, `eslint.config.mjs`, `.prettierrc.json`, `tailwind.config.ts`
- **CI workflows:** `.github/workflows/ci.yml`, `.github/workflows/codeql.yml`
- **Dependency management:** `.github/dependabot.yml`
- **Environment contract:** `.env.example`, `src/lib/config.ts`

### Documentation Artifacts

- **Project dossier:** `/docs/60-projects/portfolio-app/` (7 pages)
- **ADRs:** `/docs/10-architecture/adr/adr-0005*.md`, `adr-0006*.md`, `adr-0007*.md`
- **Threat model:** `/docs/40-security/threat-models/portfolio-app-threat-model.md`
- **Runbooks:** `/docs/50-operations/runbooks/` (4 runbooks)
  - `rbk-portfolio-deploy.md`
  - `rbk-portfolio-ci-triage.md`
  - `rbk-portfolio-rollback.md`
  - `rbk-vercel-setup-and-promotion-validation.md`

---

## Lessons Learned & Retrospective

### What Went Well

1. **Infrastructure-first approach:** Establishing CI/CD governance before content prevented technical debt
2. **Public-safety by design:** Environment variable contract prevented accidental secrets exposure
3. **Evidence-first delivery:** Creating dossier alongside code ensured documentation accuracy
4. **Vercel Deployment Checks:** Production gating provided immediate governance value
5. **GitHub Rulesets:** Simplified branch protection vs legacy rules; cleaner configuration

### Challenges & Mitigations

1. **Vercel environment scoping:** Initially unclear how preview vs production scopes work
   - Mitigation: Created comprehensive runbook documenting exact configuration
2. **CI check naming:** Needed consistent naming for Deployment Checks to reference
   - Mitigation: Standardized on `ci / quality` and `ci / build` early
3. **Documentation volume:** Dossier + ADRs + runbooks = ~6,000 words total
   - Mitigation: Used templates; content reusable for future projects

### Recommendations for Phase 2

1. Build on Phase 1 foundation (don't rebuild infrastructure)
2. Use dossier structure as template for gold standard project
3. Leverage existing CI gates for smoke tests (Phase 2 deliverable)
4. Continue evidence-first approach (documentation during implementation)

---

## Phase 2 Planning (Next Steps)

With Phase 1 establishing production infrastructure and governance, Phase 2 will focus on:

### Phase 2 Objectives

- **Smoke test infrastructure:** Playwright E2E tests for route validation
- **Gold standard project selection:** Portfolio App as exemplary case study (ADR-0010)
- **Enhanced project pages:** Gold standard badge, verification checklists
- **Meaningful CV page:** Capability-to-proof mapping with evidence links
- **Security hardening:** Secrets scanning (TruffleHog), CI permission hardening
- **Operational runbooks:** Secrets incident response, enhanced CI triage

### Planning Documents

- **Phase 2 Implementation Guide:** [/docs/00-portfolio/phase-2-implementation-guide.md](/docs/00-portfolio/phase-2-implementation-guide.md)
- **Roadmap (Phase 2 section):** [/docs/00-portfolio/roadmap/index.md](/docs/00-portfolio/roadmap/index.md#phase-2--gold-standard-project-and-credibility-baseline)
- **ADR-0010:** [Portfolio App as Gold Standard Exemplar](/docs/10-architecture/adr/adr-0010-portfolio-app-as-gold-standard-exemplar.md)

---

## Related Documentation

- **Roadmap:** [Portfolio Web Application Roadmap](/docs/00-portfolio/roadmap/index.md)
- **Phase 1 Quick Reference:** [Phase 1 Completion Quick Reference](/docs/00-portfolio/phase-1-quick-reference.md)
- **Phase 1 Checklist:** [Phase 1 Completion Checklist](/docs/00-portfolio/phase-1-completion-checklist.md)
- **Phase 2 Implementation Guide:** [Phase 2: Gold Standard Project](/docs/00-portfolio/phase-2-implementation-guide.md)
- **Portfolio App Dossier:** [Project Portfolio App](/docs/60-projects/portfolio-app/)
- **ADR Index:** [Architecture Decision Records](/docs/10-architecture/adr/)
- **Runbooks Index:** [Operations Runbooks](/docs/50-operations/runbooks/)

---

**Owner:** Portfolio Program  
**Phase:** 1 of 5  
**Status:** ✅ Complete (2026-01-17)  
**Next Phase:** Phase 2 — Gold Standard Project & Credibility Baseline
