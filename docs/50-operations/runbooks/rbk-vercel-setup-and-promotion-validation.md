---
title: 'Runbook: Set Up Vercel Deployment with Promotion Checks'
description: 'Step-by-step procedure to connect portfolio-app to Vercel, configure environment variables, set up GitHub Deployment Checks, and validate production promotion gating.'
sidebar_position: 5
tags: [operations, runbook, vercel, deployment, cicd, github-checks, governance]
---

## Status

✅ **COMPLETED** (2026-01-17)

## Purpose

This runbook documents the setup procedure to:

1. Connect the `portfolio-app` repository to a Vercel project
2. Configure environment variables across environments (development, preview, production)
3. Set up GitHub Deployment Checks to gate production promotion on CI checks
4. Validate end-to-end that preview deployments work and production is gated correctly

This runbook implements the decision in [ADR-0007: Host Portfolio App on Vercel with Promotion Gated by GitHub Checks](docs/10-architecture/adr/adr-0007-portfolio-app-hosting-vercel-with-promotion-checks.md).

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

| Item                          | Value                                                                               | Reference                                                           |
| ----------------------------- | ----------------------------------------------------------------------------------- | ------------------------------------------------------------------- |
| **Required CI checks**        | `ci / quality`, `ci / build`                                                        | [CI workflow](/docs/70-reference/portfolio-app-config-reference.md) |
| **Environment variables**     | See Environment Variable Contract (`/docs/_meta/env/portfolio-app-env-contract.md`) | `.env.example` in repo                                              |
| **Docs base URL (local dev)** | `http://localhost:3001`                                                             | Portfolio Docs local default                                        |
| **Documentation repo URL**    | (URL of portfolio-docs Vercel deployment)                                           | To be determined during setup                                       |

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

| Setting              | Value                            | Notes                               |
| -------------------- | -------------------------------- | ----------------------------------- |
| **Framework Preset** | Next.js                          | Auto-detected from `next.config.ts` |
| **Build Command**    | `pnpm build`                     | Uses pnpm (per package.json)        |
| **Output Directory** | `.next`                          | Default for Next.js                 |
| **Install Command**  | `pnpm install --frozen-lockfile` | Matches CI determinism requirement  |
| **Node Version**     | `20.x`                           | Must match `.nvmrc` in repo         |

:::warning
**IMPORTANT:** Set **Install Command** to `pnpm install --frozen-lockfile` to enforce determinism (matching CI contract in [ADR-0008](../../../docs/10-architecture/adr/adr-0008-portfolio-app-ci-quality-gates.md)).
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

| Variable                    | Local Dev                  | Preview                                                                              | Production                                                     | Example   |
| --------------------------- | -------------------------- | ------------------------------------------------------------------------------------ | -------------------------------------------------------------- | --------- |
| `NEXT_PUBLIC_DOCS_BASE_URL` | `http://localhost:3001`    | `https://portfolio-docs-preview.vercel.app` OR `https://preview-docs.yourdomain.com` | `https://docs.yourdomain.com` OR `https://yourdomain.com/docs` | See below |
| `NEXT_PUBLIC_SITE_URL`      | (optional)                 | `https://portfolio-app-git-main.vercel.app`                                          | `https://portfolio.yourdomain.com` (if using custom domain)    | See below |
| `NEXT_PUBLIC_GITHUB_URL`    | (same across environments) | `https://github.com/bryce-seefieldt`                                                 | `https://github.com/bryce-seefieldt`                           | —         |
| `NEXT_PUBLIC_LINKEDIN_URL`  | (same across environments) | `https://www.linkedin.com/in/your-handle/`                                           | `https://www.linkedin.com/in/your-handle/`                     | —         |
| `NEXT_PUBLIC_CONTACT_EMAIL` | (same across environments) | `your-email@example.com`                                                             | `your-email@example.com`                                       | —         |

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

| Name                        | Value                                                                              | Environment Scope |
| --------------------------- | ---------------------------------------------------------------------------------- | ----------------- |
| `NEXT_PUBLIC_DOCS_BASE_URL` | Portfolio Docs preview URL (e.g., `https://portfolio-docs-git-preview.vercel.app`) | **Preview**       |
| `NEXT_PUBLIC_SITE_URL`      | (leave empty or use Vercel preview URL)                                            | **Preview**       |
| `NEXT_PUBLIC_GITHUB_URL`    | Your GitHub profile URL                                                            | **Preview**       |
| `NEXT_PUBLIC_LINKEDIN_URL`  | Your LinkedIn profile URL                                                          | **Preview**       |
| `NEXT_PUBLIC_CONTACT_EMAIL` | Your public contact email                                                          | **Preview**       |

##### Production (`main`)

1. Click **"Add New"** for each variable:

| Name                        | Value                                                            | Environment Scope |
| --------------------------- | ---------------------------------------------------------------- | ----------------- |
| `NEXT_PUBLIC_DOCS_BASE_URL` | Final docs URL (subdomain or path-based)                         | **Production**    |
| `NEXT_PUBLIC_SITE_URL`      | Your portfolio domain (e.g., `https://portfolio.yourdomain.com`) | **Production**    |
| `NEXT_PUBLIC_GITHUB_URL`    | Your GitHub profile URL                                          | **Production**    |
| `NEXT_PUBLIC_LINKEDIN_URL`  | Your LinkedIn profile URL                                        | **Production**    |
| `NEXT_PUBLIC_CONTACT_EMAIL` | Your public contact email                                        | **Production**    |

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

This phase implements the decision in [ADR-0007](../../10-architecture/adr/adr-0007-portfolio-app-hosting-vercel-with-promotion-checks.md) to gate production promotion on `ci / quality` and `ci / build` passing.

#### Step 3.1: Enable Deployment Checks in Vercel

**In Vercel Dashboard:**

1. Open **portfolio-app** project
2. Navigate to **Settings** → **Git** (or **Deployments** → **Git**)
3. Scroll to **"Deployment Checks"** section
4. Toggle **"Enable Deployment Checks"** to **ON**

#### Step 3.2: Import required GitHub checks

With Deployment Checks enabled, you can now import GitHub checks:

1. Click **"Add Check"** (or similar button, depending on Vercel UI version)
2. Select **"Import from GitHub"**
3. Vercel will offer two options:
   - **"Send workflow updates to Vercel"** — Vercel modifies your CI workflow (advanced)
   - **"Select Checks to Add"** — Manually select existing checks (recommended for MVP)

   **For MVP, choose "Select Checks to Add"** (simpler, doesn't modify your workflow)

4. From the list of available checks, select:
   - ✅ `ci / quality`
   - ✅ `ci / build`

   **If checks don't appear immediately:**
   - Toggle **"Show All Checks"** switch to ON (Vercel fetches all checks from GitHub)
   - Use the **"Search for GitHub Checks"** field to filter (type `ci / quality` or `ci / build`)
   - OR enter a **GitHub SHA** from a recent commit on `main` (copy from **Commits** tab in GitHub)

   **Note:** The SHA is only used to populate the list of available checks. Once you select checks by name, Vercel will monitor those check names on **all future commits**, not just that specific SHA. You can modify your CI workflow without updating Deployment Checks, as long as the job names (`quality` and `build`) remain the same.

   After checks appear, select both `ci / quality` and `ci / build`

5. Set environment scope:
   - ✅ **Production** (so preview deployments are not gated)
6. Click **"Save"** or **"Add Check"**

:::warning
**CRITICAL:** Ensure both checks are assigned to **Production** only. Preview deployments should NOT be blocked by these checks (they should run regardless to allow early feedback).
:::

#### Step 3.3: Verify Vercel Deployment Check configuration

After saving, navigate to **Settings** → **Deployment Checks** and verify you see:

```
ci / quality     | production | blocking
ci / build       | production | blocking
```

**What these labels mean:**

- **"production"** = Scope – checks only gate production deployments (preview PRs deploy immediately)
- **"blocking"** = Behavior – production promotion waits until checks pass

**Expected behavior:**

- ✅ Preview deployments (PRs) → Deploy immediately, checks run in parallel
- ✅ Production deployments (`main`) → Blocked until both checks pass
- ✅ If either check fails → Production promotion prevented

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

| Setting             | Value                                     |
| ------------------- | ----------------------------------------- |
| **Ruleset name**    | `main-protection`                         |
| **Enforcement**     | **Active**                                |
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

### Phase 6: Configure Staging Domain & Branch Mapping (Stage 4.1)

This phase adds a clear, reviewable staging tier using Vercel's branch/domain mapping while maintaining immutable builds.

#### Step 6.1: Create a protected `staging` branch

**In GitHub:**

1. Create `staging` branch from `main`:
   ```bash
   git checkout main && git pull
   git checkout -b staging
   git push origin staging
   ```
2. Protect `staging` with a ruleset similar to `main` (optional but recommended):
   - Require PR reviews
   - Require status checks (`ci / quality`, `ci / build`)
   - Block force pushes and deletions

#### Step 6.2: Map a staging domain to the `staging` branch

**In Vercel Dashboard:**

1. **First, add a custom domain to your project:**
   - Open **portfolio-app** → **Settings** → **Domains**
   - Click **"Add a domain"**
   - Enter your staging domain (e.g., `staging.portfolio.example.com`)
   - Configure DNS according to Vercel's instructions (CNAME or nameserver method)
   - Wait for the domain to be verified and assigned to production branch

2. **Then, reassign the domain to the `staging` branch:**
   - In **Settings** → **Domains**, locate the staging domain you just added
   - Click the **"Edit"** dropdown next to the domain
   - In the modal, find **"Connect to an environment"** section
   - Select **"Preview"** from the dropdown
   - In the **"Git Branch"** field, enter `staging`
   - Click **"Save"**

**Note:** The Domains section in Settings displays your project-level domain assignments. Each domain can be connected to either Production (main branch) or a specific branch in Preview environment.

Result: Deployments from the `staging` branch will now serve at the staging domain. Commits to other branches will continue to use auto-generated Vercel URLs.

#### Step 6.3: Environment variable strategy for staging

- Vercel sets `VERCEL_ENV=preview` for non-production deployments (including `staging`).
- Keep configuration environment-first using public-safe variables:
  - `NEXT_PUBLIC_SITE_URL` → set to staging domain under **Preview** scope
  - `NEXT_PUBLIC_DOCS_BASE_URL` → typically production docs; optionally a docs staging domain
- Do not hardcode environments in code. Our helpers treat environment hints as **diagnostics only**.

#### Step 6.4: Validate staging deployment

##### Part A: Trigger staging deployment

1. Merge changes to the `staging` branch (if not already done):
   ```bash
   git checkout staging
   git pull origin staging
   git merge main
   git push origin staging
   ```
2. Vercel will automatically deploy to the staging domain
3. Wait for the deployment to complete (monitor in Vercel dashboard)

##### Part B: Verify deployment and CI gates pass

Monitor the GitHub Actions CI workflow for the following gates (should all show ✅ PASS):

- **Environment validation** – Checks that all required env vars are defined
  - **Required vars:** `NEXT_PUBLIC_GITHUB_URL`, `NEXT_PUBLIC_DOCS_GITHUB_URL`, `NEXT_PUBLIC_SITE_URL`, `NEXT_PUBLIC_DOCS_BASE_URL`
  - ⚠️ **If this fails:** See **Troubleshooting** section → "CI workflow fails with missing environment variables"
- **Registry check** – Verifies build artifacts can be pushed
- **Build gate** – Compiles the application with `pnpm build`
- **Smoke tests** – Runs basic deployment health checks

**If any gate fails:**

- Click the failed step to view error logs
- See **Troubleshooting** section at end of runbook for specific errors
- Fix the issue locally, commit, push, and retry the workflow

**If all gates pass:** Move to Part C

##### Part C: Verify immutable artifact in Vercel

1. Go to your Vercel dashboard: https://vercel.com/dashboard
2. Click on **portfolio-app** project
3. Navigate to **Deployments** tab (top menu)
4. Look for a new deployment with:
   - **Status**: "Ready" (green checkmark)
   - **Branch**: `staging`
   - **URL**: Should be `https://staging-bns-portfolio.vercel.app` (or your custom staging domain)
5. Click on the deployment to open its details page
6. Look for **"Commit SHA"** (usually shown in the deployment info)
   - Note this SHA (e.g., `f6c1fa8`)
7. Go back to GitHub Actions workflow (from Part B) and find the **commit SHA** in the logs
   - It's typically printed in the workflow summary or build logs
8. **Verify**: Both SHAs should match exactly (this proves the artifact is immutable—same code deployed)

##### Part D: Validate staging domain

1. Open your staging domain in a browser: `https://staging-bns-portfolio.vercel.app`
2. **Verify the following:**
   - [ ] Site loads without errors (no blank page or 500 error)
   - [ ] **Navigation works**: Click through pages (`/cv`, `/projects`, `/contact`)
   - [ ] **Evidence links resolve**: Find a link to portfolio-docs in the content
     - Example: "View my architecture" or similar
     - Click the link and verify it opens the docs site correctly
   - [ ] **Canonical URL is correct**: Open browser DevTools (F12) → **Console** tab
     - Verify no red errors are shown
     - Check that `NEXT_PUBLIC_SITE_URL` in the page source reflects the staging domain
   - [ ] **Docs base URL is correct**: Any `/docs` links should point to your production docs URL
     - Verify by clicking a docs link and checking the resulting URL

**If validation fails:**

- Check that environment variables are correctly scoped in Vercel (Settings → Environment Variables)
- Verify DNS is configured if using a custom domain
- See **Troubleshooting** section

**If validation passes:** Move to Step 6.5 (Promote to production)

#### Step 6.5: Promote to production

1. Merge staging to main branch:
   ```bash
   git checkout main
   git pull origin main
   git merge staging
   git push origin main
   ```
2. Vercel will automatically deploy to production domain
3. Verify CI gates pass (env, registry, build, unit + smoke tests)
4. Monitor deployment in Vercel dashboard

**Outcome:** A clear staging tier exists via branch/domain mapping; staging is validated before production deployment.

---

### Phase 7: Clean up and document

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

- **Portfolio App Production:** https://bns-portfolio.vercel.app
- **Portfolio App Staging (Preview):** https://staging-bns-portfolio-vercel.app
- **Portfolio Docs Production:** https://bns-portfolio-docs.vercel.app
- **Portfolio Docs Preview:** https://bns-portfolio-docs-git-\*.vercel.app (dynamic per PR)

### Environment Variables Configured

| Variable                    | Preview                                          | Production                                       |
| --------------------------- | ------------------------------------------------ | ------------------------------------------------ |
| `NEXT_PUBLIC_DOCS_BASE_URL` | https://bns-portfolio-docs.vercel.app            | https://bns-portfolio-docs.vercel.app            |
| `NEXT_PUBLIC_SITE_URL`      | https://bns-portfolio.vercel.app                 | https://portfolio.yourdomain.com                 |
| `NEXT_PUBLIC_GITHUB_URL`    | https://github.com/bryce-seefieldt/portfolio-app | https://github.com/bryce-seefieldt/portfolio-app |
| ...                         | ...                                              | ...                                              |
```

#### Step 6.3: Mark deployment as complete

**In portfolio-docs dossier:**

Update the status line in [`03-deployment.md`](docs/60-projects/portfolio-app/03-deployment.md):

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

### GitHub checks not running

**Symptoms:**

- PR created but no CI checks appear after 3–5 minutes
- PR shows "Waiting for status to report" indefinitely

**Root causes & fixes:**

1. **CI workflow file syntax error**
   - Check `.github/workflows/ci.yml` for YAML formatting
   - Look for build errors in **Actions** tab

2. **Wrong trigger event**
   - Verify workflow triggers on `pull_request` event:
     ```yaml
     on:
       pull_request:
       push:
         branches: [main]
     ```

3. **Jobs not named correctly**
   - Ensure job IDs match what Vercel expects: `quality` and `build`
   - (They appear as `ci / quality` and `ci / build` in Vercel)

4. **GitHub Actions not enabled**
   - Go to repo **Settings** → **Actions** → **General**
   - Ensure **"Allow all actions and reusable workflows"** is selected

### CI workflow fails with missing environment variables

**Symptoms:**

- CI workflow fails on staging or main branch
- Error message: `Environment validation failed: Missing required variables`
- Specifically missing: `NEXT_PUBLIC_GITHUB_URL`, `NEXT_PUBLIC_DOCS_GITHUB_URL`

**Root cause:**

These variables must be defined in **GitHub repository settings** so the CI workflow can access them during builds.

**Fix:**

**Part 1: Add variables to GitHub repository**

1. Go to your **portfolio-app** GitHub repository
2. Click **Settings** (top menu)
3. In left sidebar, click **"Secrets and variables"** → **"Actions"**
4. Click **"New repository variable"** button (blue button, top right)
5. Add the following variables (one at a time):

| Name                          | Value                     | Example                                             |
| ----------------------------- | ------------------------- | --------------------------------------------------- |
| `NEXT_PUBLIC_GITHUB_URL`      | Your GitHub profile URL   | `https://github.com/bryce-seefieldt`                |
| `NEXT_PUBLIC_DOCS_GITHUB_URL` | Your docs repo GitHub URL | `https://github.com/bryce-seefieldt/portfolio-docs` |

**For each variable:**

- Click **"New repository variable"**
- Enter **Name** (exactly as shown above)
- Enter **Value** (your GitHub URLs)
- Click **"Add variable"**

**Part 2: Verify variables in Vercel (optional but recommended)**

If running workflows that deploy to Vercel, also add these to Vercel environment variables:

1. Go to Vercel dashboard → **portfolio-app** project
2. Navigate to **Settings** → **Environment Variables**
3. For each variable, click **"Add New"**:
   - Name: `NEXT_PUBLIC_GITHUB_URL` or `NEXT_PUBLIC_DOCS_GITHUB_URL`
   - Value: (same as GitHub)
   - Environment scope: **All Environments** (or **Preview** + **Production** separately if preferred)
4. Click **"Save"**

**Part 3: Verify .env.local for local development**

Ensure your local `.env.local` file has these variables:

```env
NEXT_PUBLIC_GITHUB_URL=https://github.com/bryce-seefieldt
NEXT_PUBLIC_DOCS_GITHUB_URL=https://github.com/bryce-seefieldt/portfolio-docs
```

**Part 4: Retry the workflow**

1. Go to **GitHub** → **Actions**
2. Click on the failed workflow run
3. Click **"Re-run jobs"** button (top right)
4. Monitor the logs for successful environment validation

**Expected result:** CI workflow should now pass the environment validation gate and proceed to build/smoke tests.

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

- [ADR-0007: Portfolio App Hosting on Vercel](docs/10-architecture/adr/adr-0007-portfolio-app-hosting-vercel-with-promotion-checks.md)
- [Portfolio App Deployment Dossier](/docs/60-projects/portfolio-app/03-deployment.md)
- [Portfolio App Config Reference](/docs/70-reference/portfolio-app-config-reference.md)
- Portfolio App Environment Contract (`/docs/_meta/env/portfolio-app-env-contract.md`)
- [CI Triage Runbook](/docs/50-operations/runbooks/rbk-portfolio-ci-triage.md)
