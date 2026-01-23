---
title: 'Portfolio App: Deployment'
description: 'Deployment model for the Portfolio App: CI quality gates, Vercel environments, production promotion checks, and rollback posture.'
sidebar_position: 3
tags: [projects, deployment, cicd, vercel, github-actions, governance]
---

**Status:** ✅ **Phase 1 COMPLETE (2026-01-17)** — CI quality/build gates with frozen installs; Vercel preview + production promotion with Deployment Checks configured; GitHub Ruleset protects main branch (see [rbk-vercel-setup-and-promotion-validation.md](/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md) and [portfolio-app-github-ruleset-config.md](/docs/70-reference/portfolio-app-github-ruleset-config.md)).

## Purpose

Define how the Portfolio App is built and deployed with enterprise-grade governance:

- CI quality gates before merge
- preview environments for PR validation
- production promotion gated on checks
- simple rollback via Git as system of record

## Deployment Model Summary

The Portfolio App deployment model consists of two distinct phases:

### Phase 1: Setup (One-Time, Admin Tasks)

**When:** Initial Vercel project configuration and GitHub governance setup

**What:** Establish the governance infrastructure:

- Connect repository to Vercel
- Configure environment variables (preview + production scopes)
- Import GitHub Deployment Checks into Vercel
- Create GitHub Ruleset for branch protection

**Document:** [rbk-vercel-setup-and-promotion-validation.md](docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md) (6 phases, ~100 minutes)

### Phase 2: Steady-State Operations (Repeated)

**When:** Making code changes, deploying, triaging CI failures, rolling back

**What:** Operate within established governance:

- Create PR with code changes
- Validate preview deployment
- Merge when CI checks pass (GitHub Ruleset enforces this)
- Production promotion automatic after checks pass (Vercel Deployment Checks enforce this)
- If needed: triage CI failures or rollback

**Documents:**

- Deploy: [rbk-portfolio-deploy.md](docs/50-operations/runbooks/rbk-portfolio-deploy.md)
- CI Triage: [rbk-portfolio-ci-triage.md](docs/50-operations/runbooks/rbk-portfolio-ci-triage.md)
- Rollback: [rbk-portfolio-rollback.md](docs/50-operations/runbooks/rbk-portfolio-rollback.md)

## Scope

### In scope

- CI/CD contract (scripts and checks)
- environment strategy (preview vs production)
- domain strategy (root domain for Portfolio App)
- production promotion gating (Vercel Deployment Checks)
- rollback strategy

### Out of scope

- vendor-specific secrets or account identifiers
- incident response details (see `operations.md` and postmortems)

## Prereqs / Inputs

- GitHub repository with PR-only merges to `main`
- Vercel project connected to GitHub
- A stable Node/pnpm toolchain (pinned via packageManager recommended)
- Documentation App deployed separately at `/docs` or docs subdomain

## Procedure / Content

## Environments

### Preview (PR branches)

- Every PR should generate:
  - a Vercel preview deployment URL
  - passing GitHub checks
- Reviewers validate:
  - routing, rendering, performance basics
  - evidence links to `/docs` are correct

### Production (`main`)

- `main` is the published production branch.
- Production domains are assigned only after required checks pass (see below).

## Environment variable configuration

### Required variables (all environments)

**`NEXT_PUBLIC_DOCS_BASE_URL`**

- Documentation App base URL for evidence links
- Must be set in all environments (local, preview, production)

Examples by environment:

```bash
# Local development (docs running on localhost:3001)
NEXT_PUBLIC_DOCS_BASE_URL=http://localhost:3001

# Preview deployments (Vercel preview URL or dedicated preview docs domain)
NEXT_PUBLIC_DOCS_BASE_URL=https://portfolio-docs-git-preview-branch.vercel.app

# Production (final docs domain)
NEXT_PUBLIC_DOCS_BASE_URL=https://docs.yourdomain.com
# OR path-based:
NEXT_PUBLIC_DOCS_BASE_URL=https://yourdomain.com/docs
```

### Optional variables (recommended for production)

**`NEXT_PUBLIC_SITE_URL`**

- Canonical site URL for metadata and absolute links
- Example: `https://portfolio.yourdomain.com`

**`NEXT_PUBLIC_GITHUB_URL`**

- Public GitHub profile or repo URL
- Example: `https://github.com/your-handle`

**`NEXT_PUBLIC_LINKEDIN_URL`**

- Public LinkedIn profile URL
- Example: `https://www.linkedin.com/in/your-handle/`

**`NEXT_PUBLIC_CONTACT_EMAIL`**

- Public contact email (appears as mailto link; no form)
- Example: `contact@yourdomain.com`

### Variable validation

- All `NEXT_PUBLIC_*` variables are **client-visible**
- **Never** place secrets, tokens, or sensitive endpoints in these variables
- Missing required variables should degrade gracefully (app links to `/docs` by default)

### Setting variables in Vercel

1. Navigate to Vercel project → Settings → Environment Variables
2. Add variables for each environment scope:
   - **Production**: final public URLs
   - **Preview**: preview/staging URLs
   - **Development**: optional (can use `.env.local`)
3. Redeploy after variable changes to apply

## CI contract (GitHub Actions)

### Minimum required checks

1. **Quality gate** (`ci / quality`)
   - Auto-format step (Dependabot PRs only)
   - lint (ESLint)
   - format check (Prettier)
   - typecheck (TypeScript)
2. **Test gate** (`ci / test`)
   - Unit tests (pnpm test:unit - 70+ Vitest tests)
   - Coverage validation (≥80% for src/lib/)
   - E2E tests (pnpm playwright test - 12 tests across Chromium, Firefox)
3. **Build gate** (`ci / build`)
   - Next.js build must succeed
   - Vercel deployment initiated

**Status:** Unit tests implemented in Stage 3.3 (PR #XX, merged 2026-01-22). E2E tests implemented in Phase 2 (PR #10, merged 2026-01-17).

### Test coverage

**Unit Tests (Vitest):**

- 70+ test cases covering registry, slug helpers, link construction
- Files tested: `src/lib/__tests__/registry.test.ts`, `slugHelpers.test.ts`, `config.test.ts`
- Coverage target: ≥80% for all `src/lib/` modules
- Runtime: ~5 seconds
- CI integration: Tests run in `ci / test` job before build

**E2E Tests (Playwright):**

- 12 test cases across 2 browsers (Chromium, Firefox)
- Routes tested: `/`, `/cv`, `/projects`, `/contact`, `/projects/[slug]`
- Evidence link resolution validation
- Component rendering validation (EvidenceBlock, BadgeGroup)
- Responsive design verification (mobile, tablet, desktop)
- Runtime: ~10 seconds
- CI integration: Tests run in `ci / test` job after unit tests

### Dependabot automation

**Status:** Implemented in PR #15 (merged 2026-01-19).

- Auto-format step runs only for Dependabot PRs
- Prevents lockfile formatting failures
- Conditional execution: `if: ${{ github.actor == 'dependabot[bot]' }}`
- Workflow permissions: `contents: write` (allows auto-commits)

### Principle

The Portfolio App should never merge changes that:

- break build
- fail unit or E2E tests
- drift formatting standards
- introduce type errors
- fail coverage thresholds
- violate documented governance requirements

## Pre-deployment governance (required)

- Check names must remain stable and match the branch ruleset and any deployment checks:
  - `ci / quality`
  - `ci / build`
- These checks must run on PRs and on pushes to `main` so they are selectable as required and usable by Vercel promotion checks later.
- Deterministic installs are required in CI (`pnpm install --frozen-lockfile`). Changing dependency graphs must be intentional and reviewed.

## Vercel promotion governance

### Deployment checks

Enable Vercel “Deployment Checks” by importing GitHub checks and requiring them before promotion.

Recommended required checks:

- `ci / quality`
- `ci / build`

Outcome:

- Vercel creates a deployment, but production domains are not assigned until checks pass.

## Rollback posture

### Primary rollback mechanism: Git revert

- Revert the offending PR on `main`
- Redeploy from corrected `main`

### Secondary rollback mechanism: hosting rollback

- If using hosting rollback features, document and test the procedure.
- Prefer Git-based rollback for traceability and portfolio credibility.

## Validation / Expected outcomes

- PR previews exist for review
- PR merges are blocked unless CI checks pass
- Production promotion is blocked unless required checks pass
- Rollback is deterministic and documented

## Failure modes / Troubleshooting

- Vercel waits indefinitely for checks:
  - ensure CI runs on `push` to `main` and check names are stable
- Preview differs from production:
  - ensure build commands and environment variables are consistent
- Broken `/docs` links:
  - treat as breaking change; update evidence links and release notes

## Quick Decision Tree: Which Runbook Do I Need?

| Scenario                                                | Runbook                                                                                                                                          | Time    |
| ------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ | ------- |
| **First time setting up Vercel and GitHub checks**      | [rbk-vercel-setup-and-promotion-validation.md](docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md)                         | ~90 min |
| **Making a code change and deploying to production**    | [rbk-portfolio-deploy.md](docs/50-operations/runbooks/rbk-portfolio-deploy.md)                                                                   | ~15 min |
| **CI check failed (lint/format/typecheck/build)**       | [rbk-portfolio-ci-triage.md](docs/50-operations/runbooks/rbk-portfolio-ci-triage.md)                                                             | ~10 min |
| **Need to rollback production**                         | [rbk-portfolio-rollback.md](docs/50-operations/runbooks/rbk-portfolio-rollback.md)                                                               | ~10 min |
| **Need to configure environment variables after setup** | See [Phase 2 in setup runbook](docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md#phase-2-configure-environment-variables) | ~15 min |

## References

- CI governance ADR: `docs/10-architecture/adr/adr-0008-portfolio-app-ci-quality-gates.md`
- Vercel hosting ADR: `docs/10-architecture/adr/adr-0007-portfolio-app-hosting-vercel-with-promotion-checks.md`
- Vercel setup runbook: `docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md`
- Portfolio deploy runbook: `docs/50-operations/runbooks/rbk-portfolio-deploy.md`
- Portfolio rollback runbook: `docs/50-operations/runbooks/rbk-portfolio-rollback.md`
- CI triage runbook: `docs/50-operations/runbooks/rbk-portfolio-ci-triage.md`
- Documentation App deployment governance: `docs/60-projects/portfolio-docs-app/03-deployment.md`
