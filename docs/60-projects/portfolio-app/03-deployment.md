---
title: 'Portfolio App: Deployment'
description: 'Deployment model for the Portfolio App: CI quality gates, Vercel environments, production promotion checks, and rollback posture.'
sidebar_position: 3
tags: [projects, deployment, cicd, vercel, github-actions, governance]
---

**Status:** ✅ **Phase 4 COMPLETE (2026-01-24)** — Three-tier deployment model (Preview → Staging → Production) with staging domain mapping; CI quality/build/test gates; Vercel Deployment Checks; GitHub Ruleset protection on main and staging branches (see [rbk-vercel-setup-and-promotion-validation.md](/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md) and [rbk-portfolio-deploy.md](/docs/50-operations/runbooks/rbk-portfolio-deploy.md)).

## Purpose

Define how the Portfolio App is built and deployed with enterprise-grade governance:

- CI quality gates before merge
- preview environments for PR validation
- production promotion gated on checks
- simple rollback via Git as system of record

## Deployment Model Summary

The Portfolio App deployment model consists of three distinct operational phases:

### Phase 1: Setup (One-Time, Admin Tasks)

**When:** Initial Vercel project configuration and GitHub governance setup

**What:** Establish the governance infrastructure:

- Connect repository to Vercel
- Configure environment variables (preview, staging, and production scopes)
- Import GitHub Deployment Checks into Vercel
- Create GitHub Ruleset for branch protection (main and staging)
- Map staging domain to staging branch

**Document:** [rbk-vercel-setup-and-promotion-validation.md](docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md) (7 phases, ~120 minutes including staging setup)

### Phase 2: Staging Validation (Before Production)

**When:** After merging changes to `main`, before production deployment

**What:** Validate in production-like environment:

- Merge main to staging branch
- Vercel deploys to staging domain (`staging-bns-portfolio.vercel.app`)
- Manual validation of critical flows
- Run smoke tests against staging URL
- Confirm evidence links and navigation work

**Document:** [rbk-portfolio-deploy.md](docs/50-operations/runbooks/rbk-portfolio-deploy.md) (includes staging validation steps)

### Phase 3: Production Deployment (Repeated)

**When:** After successful staging validation

**What:** Promote validated changes to production:

- Production deployment from `main` is automatic (already deployed when merged)
- Vercel Deployment Checks ensure CI gates pass before production promotion
- Post-deployment validation on production domain
- If issues found: rollback via Git revert

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

The Portfolio App operates across three tiers, each serving a distinct purpose in the validation and deployment pipeline:

### Preview (PR branches)

- **Purpose:** Feature validation and PR review
- **Trigger:** Automatic on PR creation
- **Domain:** Auto-generated Vercel URL per PR (e.g., `portfolio-app-git-feat-xyz.vercel.app`)
- **Validation:**
  - Reviewers validate routing, rendering, and functionality
  - Evidence links to Documentation App are verified
  - CI checks run automatically

### Staging (`staging` branch)

- **Purpose:** Pre-production validation in production-like environment
- **Trigger:** Manual merge from `main` to `staging`
- **Domain:** `https://staging-bns-portfolio.vercel.app`
- **Validation:**
  - Full smoke test suite against staging URL
  - Evidence link resolution and navigation flow verification
  - Performance and accessibility spot checks
  - Manual exploratory testing for critical paths

### Production (`main` branch)

- **Purpose:** Live public site serving end users
- **Trigger:** Automatic promotion after CI checks pass (Vercel Deployment Checks)
- **Domain:** `https://bns-portfolio.vercel.app` (production domain)
- **Protection:**
  - GitHub Deployment Checks gate promotion (`ci / quality`, `ci / link-validation`, `ci / build`)
  - GitHub Ruleset requires PR approval and passing checks before merge
  - Rollback via Git revert to last known good state

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

**`NEXT_PUBLIC_SITE_URL`**

- Canonical site URL used for social metadata (Open Graph/Twitter) and absolute links
- Required for correct social previews; set to the production domain
- Example: `https://portfolio.yourdomain.com`
```

### Optional variables (recommended for production)

**`NEXT_PUBLIC_GITHUB_URL`**

- Public GitHub profile or repo URL
- Example: `https://github.com/your-handle`

**`NEXT_PUBLIC_LINKEDIN_URL`**

- Public LinkedIn profile URL
- Example: `https://www.linkedin.com/in/your-handle/`

**`NEXT_PUBLIC_CONTACT_EMAIL`**

- Public contact email (appears as mailto link; no form)
- Example: `contact@yourdomain.com`

**Analytics**

- Vercel Web Analytics requires no additional environment variables (enabled via `<Analytics />` in `layout.tsx`).

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
  - E2E tests (pnpm test:e2e - 58 tests across Chromium, Firefox)
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

- 58 test cases across 2 browsers (Chromium, Firefox)
- Routes tested: `/`, `/cv`, `/projects`, `/contact`, `/projects/[slug]`
- 404 handling for unknown routes and invalid slugs
- Health + metadata endpoints: `/api/health`, `/robots.txt`, `/sitemap.xml`
- Evidence link rendering and accessibility on `/projects/portfolio-app`
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

## Staging Deployment Workflow

**Purpose:** Validate changes in a production-like environment before exposing them to end users.

### When to use staging

- Before any production deployment
- When validating evidence link changes
- After major dependency updates
- For exploratory testing of new features
- When validating cross-browser compatibility

### Local → Staging → Production Sequence

#### 1. Local Development

```bash
# Create feature branch
git checkout main && git pull
git checkout -b feat/your-feature

# Make changes and validate locally
pnpm verify  # Or: pnpm verify:quick during development (skips performance checks and all tests)

# Commit and push
git commit -am "feat: description"
git push origin feat/your-feature
```

#### 2. PR Review and Preview

- Open PR targeting `main`
- Vercel creates preview deployment automatically
- Review preview URL and validate changes
- Ensure all CI checks pass (`ci / quality`, `ci / test`, `ci / link-validation`, `ci / build`)
- Get PR approval

#### 3. Merge to Main

```bash
# Merge PR via GitHub UI (squash and merge recommended)
# Or via CLI:
gh pr merge <pr-number> --squash
```

#### 4. Deploy to Staging

```bash
# Switch to staging branch
git checkout staging
git pull origin staging

# Merge main into staging
git merge main
# Alternative: rebase for cleaner history
# git rebase main

# Push to trigger staging deployment
git push origin staging
```

**What happens:**

- Vercel deploys to `https://staging-bns-portfolio.vercel.app`
- CI checks run on staging branch
- Staging domain updates to latest deployment

#### 4. Validate on Staging

**Manual validation checklist:**

- [ ] Open `https://staging-bns-portfolio.vercel.app`
- [ ] Home page loads without errors (`/`)
- [ ] Navigation works (header, footer links)
- [ ] Critical routes render (`/cv`, `/projects`, `/contact`)
- [ ] At least one project detail page renders (`/projects/[slug]`)
- [ ] Evidence links resolve to Documentation App
- [ ] No console errors in browser DevTools
- [ ] Mobile responsiveness check (resize browser or use DevTools)

**Optional: Automated smoke tests against staging:**

```bash
# Run Playwright tests against staging URL
PLAYWRIGHT_TEST_BASE_URL=https://staging-bns-portfolio.vercel.app pnpm test:e2e

# Or run specific test suite
PLAYWRIGHT_TEST_BASE_URL=https://staging-bns-portfolio.vercel.app pnpm test:e2e:single
```

#### 5. Promote to Production

Only after staging validation passes:

```bash
# Merge staging to main to promote to production
git checkout main
git pull origin main
git merge staging
git push origin main
```

**What happens:**

- Vercel automatically deploys to `https://bns-portfolio.vercel.app`
- CI checks run on main branch
- Production domain updates to latest deployment

#### 6. Validate Production

After production deployment, verify critical flows match staging validation:

- [ ] Open `https://bns-portfolio.vercel.app`
- [ ] Validate same routes and flows as staging
- [ ] Confirm evidence links and navigation work
- [ ] Check browser console for errors

### Staging Validation Failures

If staging validation reveals issues:

**Option 1: Quick Fix (minor issues)**

```bash
# Create hotfix branch from main
git checkout main
git checkout -b fix/staging-issue

# Fix the issue, validate locally
pnpm verify

# Push and create PR
git push origin fix/staging-issue
# Create PR, get approval, merge to main

# Redeploy to staging
git checkout staging
git pull origin staging
git merge main
git push origin staging
```

**Option 2: Rollback (major issues)**

```bash
# Revert the problematic PR on main
git checkout main
git revert <commit-sha>
git push origin main

# Update staging
git checkout staging
git pull origin staging
git merge main
git push origin staging
```

See [rbk-portfolio-rollback.md](/docs/50-operations/runbooks/rbk-portfolio-rollback.md) for detailed rollback procedures.

### Staging Branch Maintenance

**Keep staging synchronized with main:**

- Merge `main` to `staging` after every production deployment
- Do not commit directly to `staging`
- Staging should always be ahead of or equal to main (never diverge)

**Weekly sync (recommended):**

```bash
git checkout staging
git pull origin staging
git merge main  # Should be fast-forward if staging is current
git push origin staging
```

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
