---
title: 'Runbook: Set Up Vercel Deployment with Promotion Checks'
description: 'Step-by-step procedure to connect portfolio-app to Vercel, configure environment variables, set up GitHub Deployment Checks, and validate production promotion gating.'
sidebar_position: 5
tags: [operations, runbook, vercel, deployment, cicd, github-checks, governance]
---

## Purpose

Provide a deterministic procedure to:

1. Connect the `portfolio-app` repository to a Vercel project
2. Configure environment variables across environments (development, preview, production)
3. Set up GitHub Deployment Checks to gate production promotion on CI checks
4. Validate end-to-end that preview deployments work and production is gated correctly

This runbook implements the decision in [ADR-0007: Host Portfolio App on Vercel with Promotion Gated by GitHub Checks](../../../10-architecture/adr/adr-0007-portfolio-app-hosting-vercel-with-promotion-checks.md).

## Scope

### Use when

- First-time Vercel project setup for portfolio-app
- Reconfiguring environment variables or deployment gating
- Troubleshooting promotion checks or preview deployments

### Do not use when

- performing routine deployments (see [rbk-portfolio-deploy.md](./rbk-portfolio-deploy.md))
- rolling back a release (see [rbk-portfolio-rollback.md](./rbk-portfolio-rollback.md))
- triaging CI failures (see [rbk-portfolio-ci-triage.md](./rbk-portfolio-ci-triage.md))

## Prereqs / Inputs

### Access & Accounts

- Vercel account with permission to create/configure projects
- GitHub account with admin access to `portfolio-app` repository
- DNS access (if configuring custom domain; for MVP, skip)

### Prerequisites

- `portfolio-app` repository exists and is public on GitHub
- `portfolio-app` is on `main` branch with recent commits
- Portfolio Docs App is deployed to Vercel (at least preview access)
- CI workflows in `portfolio-app/.github/workflows/` are live and executing

### Key constants (from documentation)

| Item | Value | Reference |
|------|-------|-----------|
| **Required CI checks** | `ci / quality`, `ci / build` | [CI workflow](../../../07-reference/portfolio-app-config-reference.md) |
| **Environment variables** | See [Environment Variable Contract](../../../_meta/env/portfolio-app-env-contract.md) | `.env.example` in repo |
| **Docs base URL (local dev)** | `http://localhost:3001` | Portfolio Docs local default |
| **Documentation repo URL** | (URL of portfolio-docs Vercel deployment) | To be determined during setup |

## Procedure / Content

### Phase 1: Connect portfolio-app to Vercel

#### Step 1.1: Create or access Vercel project

**From Vercel Dashboard:**

1. Go to [vercel.com/dashboard](https://vercel.com/dashboard)
2. Click **"Add New"** → **"Project"**
3. Select **"Import Git Repository"**
4. Search for and select **`bryce-seefieldt/portfolio-app`** (or your fork)
5. Click **"Import"**

:::info
If the repo is not listed, ensure:
- Your GitHub account is connected to Vercel (check **Settings** → **Git Integrations**)
- The repository is public
:::

#### Step 1.2: Configure build settings

On the **"Import Project"** page, configure:

| Setting | Value | Notes |
|---------|-------|-------|
| **Framework Preset** | Next.js | Auto-detected from `next.config.ts` |
| **Build Command** | `pnpm build` | Uses pnpm (per package.json) |
| **Output Directory** | `.next` | Default for Next.js |
| **Install Command** | `pnpm install --frozen-lockfile` | Matches CI determinism requirement |
| **Node Version** | `20.x` | Must match `.nvmrc` in repo |

:::warning
**IMPORTANT:** Set **Install Command** to `pnpm install --frozen-lockfile` to enforce determinism (matching CI contract in [ADR-0008](../../../10-architecture/adr/adr-0008-portfolio-app-ci-quality-gates.md)).
:::

#### Step 1.3: Complete project creation

1. Click **"Deploy"**
2. Wait for initial deployment to complete (typically 2–5 minutes)
3. After successful deploy, you will see:
   - ✅ Preview URL (e.g., `https://portfolio-app-git-main.vercel.app`)
   - ✅ Production URL (e.g., `https://portfolio-app.vercel.app`)

**Outcome:** Vercel project is connected and initial deployment is complete.

---

### Phase 2: Configure environment variables

#### Step 2.1: Determine environment variable values

Before configuring Vercel, gather the following URLs:

| Variable | Local Dev | Preview | Production | Example |
|----------|-----------|---------|------------|---------|
| `NEXT_PUBLIC_DOCS_BASE_URL` | `http://localhost:3001` | `https://portfolio-docs-preview.vercel.app` OR `https://preview-docs.yourdomain.com` | `https://docs.yourdomain.com` OR `https://yourdomain.com/docs` | See below |
| `NEXT_PUBLIC_SITE_URL` | (optional) | `https://portfolio-app-git-main.vercel.app` | `https://portfolio.yourdomain.com` (if using custom domain) | See below |
| `NEXT_PUBLIC_GITHUB_URL` | (same across environments) | `https://github.com/bryce-seefieldt` | `https://github.com/bryce-seefieldt` | — |
| `NEXT_PUBLIC_LINKEDIN_URL` | (same across environments) | `https://www.linkedin.com/in/your-handle/` | `https://www.linkedin.com/in/your-handle/` | — |
| `NEXT_PUBLIC_CONTACT_EMAIL` | (same across environments) | `your-email@example.com` | `your-email@example.com` | — |

**For NEXT_PUBLIC_DOCS_BASE_URL, decide your strategy:**

**Option A: Subdomain (recommended for clarity)**
```
Preview: https://portfolio-docs-git-preview.vercel.app
Production: https://docs.yourdomain.com
```

**Option B: Path-based (simpler DNS)**
```
Production: https://yourdomain.com/docs
```

For now, **use Vercel's default preview URLs** and finalize domain strategy later.

#### Step 2.2: Add environment variables to Vercel

**In Vercel Dashboard:**

1. Open **portfolio-app** project
2. Navigate to **Settings** → **Environment Variables**

**Add variables with correct environment scope:**

##### Preview (PR branches)

1. Click **"Add New"** for each variable:

| Name | Value | Environment Scope |
|------|-------|-------------------|
| `NEXT_PUBLIC_DOCS_BASE_URL` | Portfolio Docs preview URL (e.g., `https://portfolio-docs-git-preview.vercel.app`) | **Preview** |
| `NEXT_PUBLIC_SITE_URL` | (leave empty or use Vercel preview URL) | **Preview** |
| `NEXT_PUBLIC_GITHUB_URL` | Your GitHub profile URL | **Preview** |
| `NEXT_PUBLIC_LINKEDIN_URL` | Your LinkedIn profile URL | **Preview** |
| `NEXT_PUBLIC_CONTACT_EMAIL` | Your public contact email | **Preview** |

##### Production (`main`)

1. Click **"Add New"** for each variable:

| Name | Value | Environment Scope |
|------|-------|-------------------|
| `NEXT_PUBLIC_DOCS_BASE_URL` | Final docs URL (subdomain or path-based) | **Production** |
| `NEXT_PUBLIC_SITE_URL` | Your portfolio domain (e.g., `https://portfolio.yourdomain.com`) | **Production** |
| `NEXT_PUBLIC_GITHUB_URL` | Your GitHub profile URL | **Production** |
| `NEXT_PUBLIC_LINKEDIN_URL` | Your LinkedIn profile URL | **Production** |
| `NEXT_PUBLIC_CONTACT_EMAIL` | Your public contact email | **Production** |

:::tip
**Deployment Trigger:** After adding/modifying environment variables, you must redeploy:
1. Go to **Deployments** tab
2. Find the most recent deployment
3. Click **"…"** → **"Redeploy"**
4. Wait for build to complete with new variables
:::

**Outcome:** Environment variables are configured per scope and deployments will use them on next build.

---

### Phase 3: Set up GitHub Deployment Checks (Production Promotion Gating)

This phase implements the decision in [ADR-0007](../../../10-architecture/adr/adr-0007-portfolio-app-hosting-vercel-with-promotion-checks.md) to gate production promotion on `ci / quality` and `ci / build` passing.

#### Step 3.1: Enable Deployment Checks in Vercel

**In Vercel Dashboard:**

1. Open **portfolio-app** project
2. Navigate to **Settings** → **Git** (or **Deployments** → **Git**)
3. Scroll to **"Deployment Checks"** section
4. Toggle **"Enable Deployment Checks"** to **ON**

#### Step 3.2: Import required GitHub checks

With Deployment Checks enabled, you can now import GitHub checks:

1. Click **"Add Check"** (or similar button, depending on Vercel UI version)
2. Select **"GitHub Checks"**
3. From the list, select:
   - ✅ `ci / quality`
   - ✅ `ci / build`
4. Set environment scope:
   - ✅ **Production** (so preview deployments are not gated)
5. Click **"Save"** or **"Add Check"**

:::warning
**CRITICAL:** Ensure both checks are assigned to **Production** only. Preview deployments should NOT be blocked by these checks (they should run regardless to allow early feedback).
:::

#### Step 3.3: Verify Vercel Deployment Check configuration

After saving, you should see:

```
Production Deployment Checks:
✓ ci / quality (required)
✓ ci / build (required)
```

**Outcome:** Vercel will now require `ci / quality` and `ci / build` to pass before promoting any `main` branch deployment to production.

---

### Phase 4: Configure GitHub Ruleset (Optional but Recommended)

This phase adds an additional safeguard: GitHub branch protection rules to prevent merge to `main` if CI checks don't pass.

#### Step 4.1: Create GitHub Ruleset

**In GitHub:**

1. Navigate to **portfolio-app** repository
2. Go to **Settings** → **Rules** → **Rulesets**
3. Click **"New ruleset"** → **"New branch ruleset"**
4. Configure:

| Setting | Value |
|---------|-------|
| **Ruleset name** | `main-protection` |
| **Enforcement** | **Active** |
| **Target branches** | Targeting rule: `Branch name is` → `main` |

#### Step 4.2: Add required checks to ruleset

1. In the ruleset editor, scroll to **"Require status checks to pass before merging"**
2. Click **"Add checks"**
3. Select:
   - ✅ `ci / quality`
   - ✅ `ci / build`
4. Click **"Save"**

#### Step 4.3: Additional protections (optional)

Add these for enterprise rigor:

- ✅ **Require pull request reviews before merging** (Require 1 approval)
- ✅ **Dismiss stale pull request approvals when new commits are pushed**
- ✅ **Block force pushes**
- ✅ **Block deletions**

**Outcome:** GitHub ruleset prevents merge to `main` unless CI checks pass and PR is approved.

---

### Phase 5: End-to-End Validation

#### Step 5.1: Create test PR

**From your local environment:**

```bash
cd portfolio-app

# Create and switch to a test branch
git checkout -b test/vercel-setup

# Make a trivial change (e.g., comment in README)
echo "# Test PR for Vercel setup validation" >> TEST_VERCEL_SETUP.md

# Commit and push
git add TEST_VERCEL_SETUP.md
git commit -m "test: validate Vercel setup with test PR"
git push origin test/vercel-setup
```

#### Step 5.2: Open PR and verify GitHub checks run

**On GitHub:**

1. Navigate to **portfolio-app** → **Pull Requests**
2. Click **"New Pull Request"**
3. Base: `main`, Compare: `test/vercel-setup`
4. Create PR

**Monitor the PR:**

- ⏳ Wait 1–2 minutes for GitHub Actions to start
- ✅ Confirm you see checks running:
  - `ci / quality`
  - `ci / build`
  - CodeQL (optional)

:::info
If checks don't appear after 3 minutes, verify:
- `.github/workflows/ci.yml` exists in repo
- Workflow triggers on `pull_request` event
- No syntax errors in workflow file
:::

#### Step 5.3: Verify Vercel preview deployment

**On the PR:**

1. Scroll to **"Deployments"** section
2. You should see **"Vercel"** with a preview URL (e.g., `https://portfolio-app-git-test-*.vercel.app`)
3. Click the preview URL to open the deployment
4. **Validate:**
   - ✅ Site loads without errors
   - ✅ Navigation works (visit `/cv`, `/projects`, `/contact`)
   - ✅ Evidence links in content point to correct docs URL (should match `NEXT_PUBLIC_DOCS_BASE_URL` for preview)

#### Step 5.4: Verify CI checks pass and GitHub checks are green

**On the PR:**

1. Scroll to **"Checks"** tab (if available) or look at PR status
2. Wait for all checks to complete (typically 5–10 minutes)
3. Confirm:
   - ✅ `ci / quality` → **PASS**
   - ✅ `ci / build` → **PASS**
   - ✅ CodeQL (if configured) → **PASS**

#### Step 5.5: Attempt merge and verify it succeeds

**On the PR:**

1. Click **"Merge pull request"** (if green) OR verify the button is enabled
2. Select **"Squash and merge"** or **"Create a merge commit"**
3. Complete the merge

**Expected outcome:** Merge succeeds because all checks passed.

#### Step 5.6: Monitor production promotion

**After merge:**

1. Navigate to **Vercel** → **portfolio-app** → **Deployments**
2. You should see two deployments:
   - A **Production** deployment (promoted from `main`)
   - The **Preview** deployment (from the test PR, now closed)
3. Click the **Production** deployment
4. Verify:
   - ✅ Status: **READY** (all checks passed before promotion)
   - ✅ Environment variables are set (check **Inspection** panel)
   - ✅ Production URL is live with updated content

#### Step 5.7: Verify production domain works

**Validate production:**

1. Open the production URL (e.g., `https://portfolio-app.vercel.app`)
2. Confirm:
   - ✅ Site loads
   - ✅ Navigation works
   - ✅ Evidence links use `NEXT_PUBLIC_DOCS_BASE_URL` for production scope

**Outcome:** End-to-end validation confirms:
- ✅ Preview deployments work on PRs
- ✅ CI checks gate merge to `main`
- ✅ Production promotion is automatic after checks pass
- ✅ Environment variables are correct per scope

---

### Phase 6: Clean up and document

#### Step 6.1: Delete test PR branch

```bash
cd portfolio-app

# Delete local branch
git branch -d test/vercel-setup

# Delete remote branch
git push origin --delete test/vercel-setup
```

#### Step 6.2: Document your environment

Update the team documentation with your actual URLs:

**In portfolio-docs (e.g., update or create a section in `deployment.md` or a new file):**

```markdown
## Production URLs (2026-01-16)

- **Portfolio App Production:** https://portfolio-app.vercel.app
- **Portfolio App Preview:** https://portfolio-app-git-*.vercel.app (dynamic per PR)
- **Portfolio Docs Production:** https://docs.yourdomain.com
- **Portfolio Docs Preview:** https://portfolio-docs-git-*.vercel.app (dynamic per PR)

### Environment Variables Configured

| Variable | Preview | Production |
|----------|---------|------------|
| `NEXT_PUBLIC_DOCS_BASE_URL` | https://portfolio-docs-git-preview.vercel.app | https://docs.yourdomain.com |
| `NEXT_PUBLIC_SITE_URL` | (auto-generated) | https://portfolio.yourdomain.com |
| `NEXT_PUBLIC_GITHUB_URL` | https://github.com/your-handle | https://github.com/your-handle |
| ... | ... | ... |
```

#### Step 6.3: Mark deployment as complete

**In portfolio-docs dossier:**

Update the status line in [`03-deployment.md`](../../60-projects/portfolio-app/03-deployment.md):

```markdown
Status: Live — CI quality/build gates with frozen installs; **Vercel preview + production promotion with Deployment Checks** (validated 2026-01-16).
```

**Outcome:** Production setup is documented and team has a reference for environment URLs and configuration.

---

## Troubleshooting

### Vercel waits indefinitely for checks

**Symptoms:**
- PR preview deploys fine
- Merge to `main` succeeds
- Production deployment stays in "Waiting for checks" state

**Root causes & fixes:**

1. **Checks not running on `push` to `main`**
   - Verify `.github/workflows/ci.yml` has `push: [main]` trigger
   - Check CI workflow logs for failures

2. **Check names don't match**
   - Ensure `ci.yml` has jobs named exactly `quality` and `build` (case-sensitive)
   - Vercel imports checks as `ci / quality` and `ci / build`

3. **Deployment Checks not enabled in Vercel**
   - Go back to **Settings** → **Git** → **Deployment Checks** and ensure **ON**

### Preview deployment fails but CI checks pass

**Root causes:**

1. **pnpm version mismatch**
   - Vercel uses specified `packageManager` from `package.json`
   - Ensure both CI and Vercel use `pnpm@10.0.0` (or same version)

2. **Environment variables missing or incorrect**
   - Verify `NEXT_PUBLIC_DOCS_BASE_URL` is set for Preview scope in Vercel
   - Check Vercel deployment logs for build errors

3. **Node version mismatch**
   - Confirm Vercel uses Node 20.x (set in **Settings** → **Node Version**)

### Evidence links are broken in preview

**Symptoms:**
- Links to `/docs` return 404 in preview

**Root causes:**

1. **`NEXT_PUBLIC_DOCS_BASE_URL` points to wrong URL**
   - For preview, must point to preview docs URL (e.g., portfolio-docs preview on Vercel)
   - Check Vercel environment variables → Preview scope

2. **Portfolio Docs preview is not deployed**
   - Ensure portfolio-docs Vercel project has preview deployments enabled
   - Create a test PR in portfolio-docs to generate a preview URL

---

## Success Criteria

✅ After completing all phases:

- [ ] Vercel project created and connected to GitHub
- [ ] Environment variables configured for preview and production
- [ ] GitHub Deployment Checks imported and active
- [ ] GitHub Ruleset created to protect `main` branch
- [ ] Test PR validated:
  - [ ] Preview deployment created
  - [ ] CI checks run and pass
  - [ ] Merge succeeds
  - [ ] Production promotion automatic after checks
- [ ] Production domain verified
- [ ] Documentation updated with URLs and configuration
- [ ] Team notified of live status

---

## Related artifacts

- [ADR-0007: Portfolio App Hosting on Vercel](../../../10-architecture/adr/adr-0007-portfolio-app-hosting-vercel-with-promotion-checks.md)
- [Portfolio App Deployment Dossier](../../60-projects/portfolio-app/03-deployment.md)
- [Portfolio App Config Reference](../../../70-reference/portfolio-app-config-reference.md)
- [Portfolio App Environment Contract](../../../_meta/env/portfolio-app-env-contract.md)
- [CI Workflow](../../../07-reference/portfolio-app-config-reference.md)
