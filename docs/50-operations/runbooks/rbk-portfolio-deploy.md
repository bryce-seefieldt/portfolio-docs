---
title: 'Runbook: Deploy Portfolio App'
description: 'Procedure to deploy the Portfolio App with PR previews, staging validation, CI quality gates, and production promotion checks.'
sidebar_position: 4
tags: [operations, runbook, portfolio-app, deployment, vercel, cicd, staging]
---

## Purpose

Provide a deterministic deployment procedure for the Portfolio App that ensures:

- PR review and preview validation
- Staging validation in production-like environment
- CI gates are green before merge
- Production promotion is gated by imported checks
- Post-deploy validation is explicit

## Governance Context

This runbook assumes Vercel and GitHub governance are already configured per [rbk-vercel-setup-and-promotion-validation.md](./rbk-vercel-setup-and-promotion-validation.md). Key governance already in place:

- **Vercel Deployment Checks:** `ci / quality` and `ci / build` are required for production promotion
- **GitHub Ruleset:** `main-protection` and `staging-protection` require checks to pass and PR approval before merge
- **Environment Variables:** Configured per scope (preview, staging, and production)
- **Staging Domain:** `staging-bns-portfolio.vercel.app` mapped to `staging` branch

If governance has not been set up, see the [setup runbook](./rbk-vercel-setup-and-promotion-validation.md) first (~120 minutes including staging setup).

## Scope

### Use when

- Publishing any Portfolio App change to production
- Releasing routing/navigation updates
- Shipping new project pages or evidence link updates
- Validating changes in staging before production deployment

### Do not use when

- Experimenting locally without intent to deploy (use local validation only)
- Making documentation-only changes (portfolio-docs has separate workflow)

## Prereqs / Inputs

- Access:
  - ability to open PRs and merge to `main`
- Tools:
  - Node (20+), pnpm, git
- Preconditions:
  - change is on a feature branch
  - PR template includes “No secrets added”
  - local build and CI checks pass

:::warning
Do not deploy content that includes secrets, internal endpoints, or sensitive logs/screenshots.
If suspected, stop and treat as an incident.
:::

## Procedure / Content

### Pre-merge checklist (quick)

- Local validation passed (choose one approach):
  - **Comprehensive:** `pnpm verify` (auto-formats, runs all checks with detailed reporting)
  - **Individual:** `pnpm lint && pnpm format:check && pnpm typecheck && pnpm build`
- PR readiness:
  - PR template completed with security note (“No secrets added”)
  - Vercel preview exists and routes render (`/`, `/cv`, `/projects`, one project detail)
  - Evidence links to docs resolve
- CI governance:
  - Required checks green: `ci / quality`, `ci / build`
  - Branch ruleset active (e.g., `main-protection`) and required checks selected

### 1) Local preflight validation (required)

### 1) Local preflight validation (required)

**Recommended approach (comprehensive validation):**

```bash
pnpm install
pnpm verify  # Runs all 8 checks with detailed error reporting
```

This runs: environment check, auto-format, format validation, lint, typecheck, secret scanning, registry validation, build, and smoke tests.

**Alternative: Quick validation (skip tests):**

```bash
pnpm verify:quick  # Runs checks 1-7, skips smoke tests
```

**Alternative: Manual step-by-step:**

From repository root:

```bash
pnpm install
pnpm format:write      # Auto-fix formatting
pnpm lint              # ESLint (zero warnings)
pnpm typecheck         # TypeScript validation
pnpm registry:validate # Projects YAML schema check
pnpm build             # Production build
pnpm test              # Smoke tests (Playwright - 12 tests)
 # Secrets scanning runs in CI on PRs (TruffleHog). Local verify uses a lightweight pattern scan.
```

**Secrets scanning scope:**

- TruffleHog-based `secrets:scan` runs in CI on PRs and must pass.
- Local verification does not run TruffleHog; a lightweight pattern-based scan is included.
- Optional local opt-in: enable pre-commit (`pip install pre-commit && pre-commit install`) or install TruffleHog if you want to run `pnpm secrets:scan` manually.

Optional local preview:

```bash
pnpm dev
```

Expected outcome:

- all commands succeed with no errors.
- smoke tests: 12/12 passing (6 routes × 2 browsers)

### 2) Open a PR (required)

- PR must include:
  - what changed
  - why
  - evidence: local validation passed (verify script or manual commands)
  - security note: "No secrets added"
  - security note: “No secrets added”

### 3) Validate preview deployment

In the PR:

- confirm Vercel preview deployment exists
- validate critical routes:
  - `/` loads and primary CTA works
  - `/cv` renders correctly
  - `/projects` renders list
  - at least one `/projects/[slug]` renders and includes evidence links
- validate /docs links resolve correctly (path or subdomain)

### 4) Merge to `main`

- Merge only when all required GitHub checks are green:
  - `ci / quality`
  - `ci / test`
  - `ci / link-validation`
  - `ci / build`
- Use "Squash and merge" for clean history (recommended)

**Note:** Production deployment happens automatically from `main` after CI checks pass, but **staging validation is required** before considering production deployment complete.

### 5) Deploy to Staging

After merging to `main`, promote changes to staging for validation:

```bash
# Switch to staging branch
git checkout staging
git pull origin staging

# Merge main into staging
git merge main

# Push to trigger Vercel deployment to staging domain
git push origin staging
```

**Expected outcome:**

- Vercel deploys to `https://staging-bns-portfolio.vercel.app`
- CI checks run on staging branch
- Staging domain updates within 1-2 minutes

### 6) Validate Staging Deployment

**Manual validation (required):**

1. Open `https://staging-bns-portfolio.vercel.app` in browser
2. Verify critical paths:
   - [ ] Home page loads (`/`)
   - [ ] Navigation works (header, footer)
   - [ ] CV page renders (`/cv`)
   - [ ] Projects index renders (`/projects`)
   - [ ] At least one project detail page renders (e.g., `/projects/portfolio-app`)
   - [ ] Contact page renders (`/contact`)
3. Verify evidence links:
   - [ ] Click "View Documentation" or similar links
   - [ ] Verify links resolve to Documentation App
   - [ ] Check that project dossier links work
4. Check browser console:
   - [ ] No JavaScript errors
   - [ ] No failed network requests
   - [ ] No React warnings in console

**Automated validation (recommended):**

```bash
# Run Playwright smoke tests against staging
PLAYWRIGHT_TEST_BASE_URL=https://staging-bns-portfolio.vercel.app pnpm playwright test

# Or run specific test file
PLAYWRIGHT_TEST_BASE_URL=https://staging-bns-portfolio.vercel.app pnpm playwright test tests/smoke.spec.ts
```

**Expected outcome:**

- All manual checks pass
- Automated tests pass (if running)
- No console errors or broken links

**If staging validation fails:**

- Do NOT proceed to production validation
- See **Failure modes / Troubleshooting** section below
- Either fix forward with hotfix PR or rollback (see [rbk-portfolio-rollback.md](./rbk-portfolio-rollback.md))

### 7) Confirm Production Promotion

**Production is already deployed** because:

- Changes were merged to `main` in Step 4
- Vercel automatically deploys `main` branch after CI checks pass
- GitHub Deployment Checks ensure quality gates are met

**Validation steps:**

1. Navigate to Vercel dashboard → portfolio-app → Deployments
2. Find deployment from `main` branch
3. Verify:
   - [ ] Status: "Ready" (green checkmark)
   - [ ] Branch: `main`
   - [ ] Commit SHA matches your merged PR
   - [ ] Production domain assigned: `https://bns-portfolio.vercel.app`

### 8) Validate Production Deployment

**Manual validation (required after staging passes):**

1. Open `https://bns-portfolio.vercel.app` in browser
2. Verify same critical paths as staging:
   - [ ] Home, CV, Projects, Contact pages render
   - [ ] Evidence links resolve correctly
   - [ ] No console errors
3. **Compare with staging:**
   - [ ] Production behavior matches staging validation
   - [ ] No unexpected differences

**If production validation fails but staging passed:**

- Indicates environment-specific issue (check env vars)
- See **Failure modes / Troubleshooting** section

### 9) Env var verification (required)

Validate that the deployment environment is configured with the expected **public-safe** environment variables. This prevents broken evidence links and inconsistent metadata between Preview, Staging, and Production.

#### A) Verify Vercel environment variables (Preview + Staging + Production)

In Vercel Project Settings → Environment Variables, confirm these are present:

Required (recommended minimum):

- `NEXT_PUBLIC_DOCS_BASE_URL`

Recommended for production polish:

- `NEXT_PUBLIC_SITE_URL`
- `NEXT_PUBLIC_GITHUB_URL`
- `NEXT_PUBLIC_LINKEDIN_URL`

Optional:

- `NEXT_PUBLIC_CONTACT_EMAIL`

Expected outcome:

- Values are set for **Preview**, **Staging (as Preview)**, and **Production** (unless intentionally different)
- No sensitive values are stored in any `NEXT_PUBLIC_*` variable

**Note:** Staging uses Preview environment scope in Vercel because it's deployed from a non-main branch (`staging`).

- `NEXT_PUBLIC_SITE_URL`
- `NEXT_PUBLIC_GITHUB_URL`
- `NEXT_PUBLIC_LINKEDIN_URL`

Optional:

- `NEXT_PUBLIC_CONTACT_EMAIL`

Expected outcome:

- Values are set for **Preview** and **Production** (unless intentionally different).
- No sensitive values are stored in any `NEXT_PUBLIC_*` variable.

#### B) Verify runtime behavior in the deployed site

From the deployed environment (Preview or Production), validate behavior that depends on env:

- Documentation link(s) resolve correctly:
  - clicking “Docs” or “Evidence” navigates to the Documentation App host derived from `NEXT_PUBLIC_DOCS_BASE_URL`
- Profile links resolve correctly:
  - GitHub/LinkedIn links (if present) go to the configured destinations
- Optional mail link:
  - contact email (if configured) generates a correct `mailto:` link

If validation fails:

- treat this as a release-blocking configuration defect
- correct env vars in Vercel and trigger a new deployment (or redeploy from the same commit)
- re-run post-deploy validation steps

### 7) Post-deploy validation

Validate production:

- core routes load (same set as preview)
- evidence links to docs remain correct
- no broken images/assets

### 10) Record release evidence (recommended)

If change is material:

- Add/update a release note entry in Portfolio Docs App (portfolio program release notes)
- Update dossier pages if behavior changed
- Document any new evidence links or navigation changes

## Validation / Expected outcomes

Deployment is successful when:

- Staging validation passes (all critical paths work, no console errors)
- Production site renders correctly
- Production behavior matches staging
- Required checks are green
- Evidence links are correct
- No sensitive information is exposed

## Rollback / Recovery

Rollback if:

- Staging validation fails (fix or rollback before production impact)
- Production rendering is broken
- Critical routes 404
- `/docs` linking is broken materially
- Sensitive publication suspected
- Production behavior differs unexpectedly from staging

Primary rollback method:

1. Revert the offending PR on `main`:

   ```bash
   git checkout main
   git revert <commit-sha>
   git push origin main
   ```

2. Update staging to match:

   ```bash
   git checkout staging
   git pull origin staging
   git merge main
   git push origin staging
   ```

3. Validate rollback on both staging and production

For detailed rollback procedures, see [rbk-portfolio-rollback.md](./rbk-portfolio-rollback.md).

## Failure modes / Troubleshooting

### Staging validation fails

**Symptoms:**

- Console errors on staging
- Evidence links broken on staging
- Navigation doesn't work on staging

**Resolution:**

1. Do NOT proceed to production validation
2. Investigate the failure locally:
   ```bash
   git checkout staging
   git pull
   pnpm install
   pnpm verify
   ```
3. Choose fix strategy:
   - **Minor issue:** Create hotfix PR, merge to main, redeploy to staging
   - **Major issue:** Rollback main, update staging

### Staging passes but production fails

**Symptoms:**

- Staging works correctly
- Production has different behavior, errors, or broken links

**Likely causes:**

- Environment variable mismatch between Preview (staging) and Production
- Build artifact differs between deployments
- Caching issues

**Resolution:**

1. Compare environment variables in Vercel:
   - Settings → Environment Variables
   - Verify Preview and Production values match expectations
2. Check Vercel deployment details:
   - Verify both staging and production used same commit SHA
   - Check build logs for differences
3. Force redeploy production:
   - Vercel → Deployments → Find production deployment → "Redeploy"
4. If issue persists, rollback and investigate locally

- Preview succeeds but prod fails:
  - compare env settings; confirm check gating; rollback if needed
- Promotion stuck “waiting for checks”:
  - ensure CI runs on push to main; confirm check names match imported checks
- Broken evidence links:
  - treat as regression; fix forward or rollback depending on severity

## References

- Portfolio App dossier deployment: `docs/60-projects/portfolio-app/deployment.md`
- Hosting ADR: `docs/10-architecture/adr/adr-0007-portfolio-app-hosting-vercel-with-promotion-checks.md`
- Rollback runbook: `docs/50-operations/runbooks/rbk-portfolio-rollback.md`
- CI triage runbook: `docs/50-operations/runbooks/rbk-portfolio-ci-triage.md`
