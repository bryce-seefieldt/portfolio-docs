---
title: 'Portfolio App Phase 1 Completion Checklist'
description: 'Master checklist for completing Phase 1 validation: Vercel deployment, environment configuration, GitHub Deployment Checks, branch protection, and end-to-end testing.'
sidebar_position: 1
tags: [portfolio, roadmap, phase-1, checklist, deployment, governance]
---

## Purpose

This checklist coordinates the final **admin tasks** required to complete **Phase 1** of the Portfolio App program:

- ✅ Portfolio App foundation code is complete
- ✅ CI/CD governance is in place
- ⏳ **PENDING:** Vercel deployment + production promotion checks (this checklist)
- ⏳ **PENDING:** GitHub branch protection + ruleset configuration
- ⏳ **PENDING:** End-to-end validation

Upon completion, Phase 1 will be fully validated and ready for Phase 2.

---

## Overview: What This Accomplishes

| Item                         | Accomplishment                                                         | Owner    | Duration  |
| ---------------------------- | ---------------------------------------------------------------------- | -------- | --------- |
| **1. Vercel Connection**     | Connect portfolio-app repo to Vercel; enable preview + production      | Admin    | 10–15 min |
| **2. Environment Variables** | Configure `NEXT_PUBLIC_DOCS_BASE_URL` and optional vars per scope      | Admin    | 10–15 min |
| **3. Deployment Checks**     | Import GitHub checks into Vercel; gate production promotion            | Admin    | 5–10 min  |
| **4. GitHub Ruleset**        | Create branch protection ruleset for `main` with required checks       | Admin    | 10–15 min |
| **5. E2E Validation**        | Create test PR, validate preview, merge, validate production promotion | Engineer | 15–20 min |
| **6. Documentation**         | Update docs with live URLs and deployment status                       | Engineer | 5–10 min  |

**Total time: ~60–90 minutes**

---

## Quick Links to Procedures

| Step                         | Procedure                                                                                                                                                                                |
| ---------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **1. Connect to Vercel**     | [Vercel Setup Runbook](/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md) — Phase 1                                                                              |
| **2. Configure Env Vars**    | [Vercel Setup Runbook](/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md) — Phase 2                                                                              |
| **3. Set Deployment Checks** | [Vercel Setup Runbook](/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md) — Phase 3                                                                              |
| **4. GitHub Ruleset**        | [GitHub Ruleset Config](/docs/70-reference/portfolio-app-github-ruleset-config.md) + [Vercel Runbook Phase 4](/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md) |
| **5. E2E Validation**        | [Vercel Setup Runbook](/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md) — Phase 5                                                                              |
| **6. Documentation**         | [Vercel Setup Runbook](/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md) — Phase 6                                                                              |

---

## Checklist: Admin Tasks

### Phase 1: Vercel Connection

**Objective:** Connect `portfolio-app` to Vercel and enable preview + production deployments.

**Procedure:** See [Vercel Setup Runbook, Phase 1](/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md#phase-1-connect-portfolio-app-to-vercel).

**Checklist:**

- [ ] Vercel account accessed
- [ ] Project created: **`portfolio-app`** (imported from GitHub)
- [ ] Build settings configured:
  - [ ] Framework: **Next.js**
  - [ ] Build Command: **`pnpm build`**
  - [ ] Output Directory: **`.next`**
  - [ ] Install Command: **`pnpm install --frozen-lockfile`**
  - [ ] Node Version: **`20.x`**
- [ ] Initial deployment successful
- [ ] Preview URL generated (e.g., `https://portfolio-app-git-main.vercel.app`)
- [ ] Production URL assigned (e.g., `https://portfolio-app.vercel.app`)

**Outcome:** Vercel project deployed. Moving to environment configuration.

---

### Phase 2: Environment Variables

**Objective:** Configure `NEXT_PUBLIC_*` variables for preview and production scopes.

**Procedure:** See [Vercel Setup Runbook, Phase 2](/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md#phase-2-configure-environment-variables).

**Pre-setup:**

- [ ] Determine `NEXT_PUBLIC_DOCS_BASE_URL` values:
  - [ ] Preview value (e.g., portfolio-docs preview Vercel URL)
  - [ ] Production value (e.g., docs subdomain or path)
- [ ] Gather optional vars:
  - [ ] GitHub profile URL
  - [ ] LinkedIn profile URL
  - [ ] Contact email

**Environment Variable Configuration:**

**Preview scope:**

- [ ] `NEXT_PUBLIC_DOCS_BASE_URL` = [preview docs URL]
- [ ] `NEXT_PUBLIC_SITE_URL` = (optional, can be empty)
- [ ] `NEXT_PUBLIC_GITHUB_URL` = [your GitHub URL]
- [ ] `NEXT_PUBLIC_LINKEDIN_URL` = [your LinkedIn URL]
- [ ] `NEXT_PUBLIC_CONTACT_EMAIL` = [your email]

**Production scope:**

- [ ] `NEXT_PUBLIC_DOCS_BASE_URL` = [production docs URL]
- [ ] `NEXT_PUBLIC_SITE_URL` = [your portfolio domain]
- [ ] `NEXT_PUBLIC_GITHUB_URL` = [your GitHub URL]
- [ ] `NEXT_PUBLIC_LINKEDIN_URL` = [your LinkedIn URL]
- [ ] `NEXT_PUBLIC_CONTACT_EMAIL` = [your email]

**Post-setup:**

- [ ] Variables saved in Vercel
- [ ] Redeploy triggered to apply changes
- [ ] Build completed successfully

**Outcome:** Environment variables configured per scope. Moving to deployment checks.

---

### Phase 3: Vercel Deployment Checks

**Objective:** Import GitHub CI checks and gate production promotion on their success.

**Procedure:** See [Vercel Setup Runbook, Phase 3](/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md#phase-3-set-up-github-deployment-checks-production-promotion-gating).

**Checklist:**

- [ ] Vercel **Deployment Checks** feature enabled
- [ ] GitHub checks imported and configured:
  - [ ] `ci / quality` added (Production scope)
  - [ ] `ci / build` added (Production scope)
- [ ] Both checks marked as **required** for production
- [ ] Configuration saved

**Verification:**

- [ ] Vercel shows: `Production Deployment Checks: ci / quality, ci / build`

**Outcome:** Production promotion now gated by CI checks. Moving to GitHub ruleset.

---

### Phase 4: GitHub Ruleset

**Objective:** Create GitHub branch protection ruleset for `main` enforcing CI checks and PR review.

**Procedure:** See [GitHub Ruleset Configuration](/docs/70-reference/portfolio-app-github-ruleset-config.md) or [Vercel Setup Runbook, Phase 4](/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md#phase-4-configure-github-ruleset-optional-but-recommended).

**Checklist:**

**Ruleset Creation:**

- [ ] Ruleset name: **`main-protection`**
- [ ] Enforcement: **Active**
- [ ] Target branch: **`main`**

**Required Rules:**

- [ ] Status checks required:
  - [ ] `ci / quality`
  - [ ] `ci / build`
- [ ] Require branches up to date: **ON**
- [ ] Pull request review required: **1 approval**
- [ ] Dismiss stale reviews: **ON**
- [ ] Block force pushes: **ON**
- [ ] Block deletions: **ON**

**Post-creation:**

- [ ] Ruleset shows as **Active**
- [ ] GitHub no longer shows legacy branch protection (if was present)

**Outcome:** `main` branch is now protected by ruleset. Moving to E2E validation.

---

### Phase 5: End-to-End Validation

**Objective:** Validate that PR preview deployments work, CI checks run, GitHub checks gate merge, and production promotion is automatic.

**Procedure:** See [Vercel Setup Runbook, Phase 5](/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md#phase-5-end-to-end-validation).

**Step 5.1: Create Test PR**

- [ ] Local branch created: `test/vercel-setup`
- [ ] Test file added: `TEST_VERCEL_SETUP.md`
- [ ] Commit pushed to GitHub
- [ ] PR opened targeting `main`

**Optional: Validate locally before pushing (recommended)**

Run comprehensive validation:

```bash
pnpm verify
```

Or run checks individually:

```bash
pnpm format:write  # Auto-fix formatting
pnpm lint          # Check linting
pnpm typecheck     # Check TypeScript
pnpm build         # Validate build
```

**Step 5.2: Verify GitHub Checks**

- [ ] CI workflow triggered (wait 1–2 min)
- [ ] Checks visible on PR:
  - [ ] `ci / quality` running/passed
  - [ ] `ci / build` running/passed
  - [ ] CodeQL (if configured)
- [ ] All checks passed (green ✅)

**Step 5.3: Verify Vercel Preview Deployment**

- [ ] Vercel deployment visible on PR (in **Deployments** section)
- [ ] Preview URL generated
- [ ] Preview site loads without errors
- [ ] Navigation works (visit `/cv`, `/projects`, `/contact`)
- [ ] Evidence links point to correct docs URL (from `NEXT_PUBLIC_DOCS_BASE_URL` preview scope)

**Step 5.4: Verify Merge is Blocked (if not all checks passed)**

- [ ] If checks were not yet passing, merge button is disabled
- [ ] Error message explains missing status checks or review

**Step 5.5: Verify Merge is Allowed (after checks pass)**

- [ ] All checks now passed
- [ ] Merge button is enabled
- [ ] Merge PR (use "Squash and merge" or "Create a merge commit")

**Step 5.6: Verify Production Promotion**

- [ ] After merge, check Vercel **Deployments**
- [ ] New **Production** deployment created
- [ ] Production deployment status: **READY** (not waiting for checks)
- [ ] Environment variables applied correctly (check Vercel deployment logs)

**Step 5.7: Verify Production Domain**

- [ ] Open production URL (e.g., `https://portfolio-app.vercel.app`)
- [ ] Site loads and renders correctly
- [ ] Navigation works
- [ ] Evidence links use production docs URL

**Cleanup:**

- [ ] Delete test PR branch locally and remotely
  ```bash
  git branch -d test/vercel-setup
  git push origin --delete test/vercel-setup
  ```

**Outcome:** E2E validation confirms all deployment + promotion mechanics work correctly.

---

### Phase 6: Documentation

**Objective:** Update portfolio-docs with live URLs, environment configuration, and completion status.

**Procedure:** See [Vercel Setup Runbook, Phase 6](/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md#phase-6-clean-up-and-document).

**Checklist:**

**Document Vercel URLs:**

- [ ] Create or update a deployment reference doc with:
  - [ ] Portfolio App production URL
  - [ ] Portfolio App preview URL pattern
  - [ ] Portfolio Docs production URL
  - [ ] Portfolio Docs preview URL pattern

**Update Deployment Dossier:**

- [ ] Edit `docs/60-projects/portfolio-app/03-deployment.md`
- [ ] Update status line to reflect live Vercel + checks
- [ ] Verify all environment variable examples use actual values

**Update Roadmap:**

- [ ] Edit `docs/00-portfolio/roadmap.md`
- [ ] Update Phase 1 acceptance criteria (mark as ✅)
- [ ] Confirm Phase 2 planning can proceed

**Commit & Push:**

- [ ] Create branch: `docs/phase-1-deployment-complete`
- [ ] Commit changes: `docs: mark Phase 1 deployment complete with Vercel + checks`
- [ ] Push and merge to `main`

**Outcome:** All documentation reflects live Phase 1 status.

---

## Success Criteria

✅ **Phase 1 is COMPLETE as of 2026-01-17**

- [x] Vercel project connected and initial deployment successful
- [x] Environment variables configured for preview and production
- [x] GitHub Deployment Checks gate production promotion
- [x] GitHub Ruleset protects `main` branch
- [x] Test PR validated:
  - [x] Preview deployment works
  - [x] CI checks run and pass
  - [x] Merge is allowed only when checks pass
  - [x] Production promotion automatic after merge
  - [x] Production domain live and functional
- [x] Documentation updated with URLs and status
- [x] All team members notified of live status

---

## Troubleshooting Quick Links

| Issue                                | Troubleshooting Section                                                                                                                       |
| ------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------- |
| Vercel waits indefinitely for checks | [Vercel Setup Runbook](/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md#vercel-waits-indefinitely-for-checks)        |
| Preview deployment fails             | [Vercel Setup Runbook](/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md#preview-deployment-fails-but-ci-checks-pass) |
| Evidence links broken                | [Vercel Setup Runbook](/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md#evidence-links-are-broken-in-preview)        |
| Merge button disabled unexpectedly   | [GitHub Ruleset Config](/docs/70-reference/portfolio-app-github-ruleset-config.md#merge-button-stays-disabled-even-after-checks-pass)         |
| Force-push still works               | [GitHub Ruleset Config](/docs/70-reference/portfolio-app-github-ruleset-config.md#force-push-still-works)                                     |

---

## Related Artifacts

- [Vercel Setup Runbook](/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md) — Complete procedures
- [GitHub Ruleset Configuration](/docs/70-reference/portfolio-app-github-ruleset-config.md) — Detailed GitHub setup
- [Portfolio App Deployment Dossier](/docs/60-projects/portfolio-app/03-deployment.md) — Governance policy
- [ADR-0007: Vercel + Promotion Checks](/docs/10-architecture/adr/adr-0007-portfolio-app-hosting-vercel-with-promotion-checks.md)
- [ADR-0008: CI Quality Gates](/docs/10-architecture/adr/adr-0008-portfolio-app-ci-quality-gates.md)
- [Portfolio App Roadmap](/docs/00-portfolio/roadmap.md)
