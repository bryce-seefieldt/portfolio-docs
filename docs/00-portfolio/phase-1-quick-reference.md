---
title: 'Phase 1 Completion: Quick Reference Card'
description: 'One-page executive summary of Phase 1 admin tasks with links, estimated times, and success validation.'
sidebar_position: 0
tags: [portfolio, phase-1, quick-reference, deployment, admin-tasks]
---

## 🚀 Phase 1 Final Push: Admin Tasks Only

**Status:** Portfolio App code is 100% complete. Deployment to Vercel (admin tasks) is the final blocker for Phase 1 completion.

**Goal:** Deploy to Vercel with production promotion checks and branch protection gated by CI.

**Total Time:** ~60–90 minutes | **Complexity:** Medium | **Risk:** Low (all changes are additive; no production data involved)

---

## 📋 5 Admin Tasks (in order)

| #     | Task                                                   | Time      | Links                                                                                                                                                                                                                                | Status |
| ----- | ------------------------------------------------------ | --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------ |
| **1** | Connect portfolio-app to Vercel                        | 10–15 min | [Runbook Phase 1](/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md#phase-1-connect-portfolio-app-to-vercel)                                                                                                 | ⏳     |
| **2** | Configure environment variables (preview + production) | 10–15 min | [Runbook Phase 2](/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md#phase-2-configure-environment-variables)                                                                                                 | ⏳     |
| **3** | Set up GitHub Deployment Checks                        | 5–10 min  | [Runbook Phase 3](/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md#phase-3-set-up-github-deployment-checks-production-promotion-gating)                                                                     | ⏳     |
| **4** | Configure GitHub Ruleset for `main` branch             | 10–15 min | [Ruleset Guide](/docs/70-reference/portfolio-app-github-ruleset-config.md) OR [Runbook Phase 4](/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md#phase-4-configure-github-ruleset-optional-but-recommended) | ⏳     |
| **5** | Validate end-to-end (test PR + production promotion)   | 15–20 min | [Runbook Phase 5 & 6](/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md#phase-5-end-to-end-validation)                                                                                                       | ⏳     |

---

## 🎯 Critical Constants (Copy-Paste Ready)

```
Portfolio App Repo:  bryce-seefieldt/portfolio-app

Required CI Checks:  ci / quality
                     ci / build

Environment Variables (NEXT_PUBLIC_ prefix = client-visible):

  Required:
    NEXT_PUBLIC_DOCS_BASE_URL = [preview/production docs URL]

  Recommended:
    NEXT_PUBLIC_SITE_URL = [your portfolio domain]
    NEXT_PUBLIC_GITHUB_URL = https://github.com/your-handle
    NEXT_PUBLIC_LINKEDIN_URL = https://www.linkedin.com/in/your-handle/
    NEXT_PUBLIC_CONTACT_EMAIL = your-email@example.com

GitHub Ruleset Name:  main-protection
Target Branch:        main
Enforcement:          Active

GitHub Ruleset Rules:
  ✓ Required checks: ci / quality, ci / build
  ✓ PR review required: 1 approval
  ✓ Dismiss stale reviews: ON
  ✓ Block force-push: ON
  ✓ Block deletions: ON
```

---

## ✅ Pre-Flight Checklist

Before starting, verify:

- [ ] You have **admin access** to `bryce-seefieldt/portfolio-app` GitHub repo
- [ ] You have a **Vercel account** (free tier is sufficient)
- [ ] You know your **documentation app URL** (where `/docs` will be)
- [ ] You know your **GitHub profile URL** (public)
- [ ] CI workflow (`.github/workflows/ci.yml`) is live in the repo
- [ ] You have 60–90 minutes uninterrupted time

---

## 🔧 The Workflow (High Level)

### Step 1: Vercel Project Setup (10–15 min)

```
1. Go to vercel.com/dashboard
2. "Add New" → "Project" → import bryce-seefieldt/portfolio-app
3. Configure build settings:
   - Install: pnpm install --frozen-lockfile
   - Build: pnpm build
   - Node: 20.x
4. Click "Deploy"
5. Wait 2–5 minutes for initial build
6. Confirm: Preview URL + Production URL exist ✅
```

**Result:** Vercel project connected and deployed.

---

### Step 2: Environment Variables (10–15 min)

```
In Vercel Settings → Environment Variables:

Preview scope:
  NEXT_PUBLIC_DOCS_BASE_URL = https://portfolio-docs-preview.vercel.app
  NEXT_PUBLIC_GITHUB_URL = https://github.com/your-handle
  NEXT_PUBLIC_LINKEDIN_URL = https://www.linkedin.com/in/your-handle/
  NEXT_PUBLIC_CONTACT_EMAIL = your-email@example.com

Production scope:
  NEXT_PUBLIC_DOCS_BASE_URL = https://docs.yourdomain.com
  NEXT_PUBLIC_GITHUB_URL = https://github.com/your-handle
  NEXT_PUBLIC_LINKEDIN_URL = https://www.linkedin.com/in/your-handle/
  NEXT_PUBLIC_CONTACT_EMAIL = your-email@example.com

After saving, redeploy the latest commit to apply changes.
```

**Result:** Environment variables set per scope; deployments use correct values.

---

### Step 3: GitHub Deployment Checks (5–10 min)

```
In Vercel Settings → Git → Deployment Checks:

1. Enable "Deployment Checks" (toggle ON)
2. Click "Add Check" → "GitHub Checks"
3. Select: ci / quality, ci / build
4. Scope: Production only (so preview is not blocked)
5. Save

Verify: Vercel shows both checks as required for Production.
```

**Result:** Production promotion is now gated by `ci / quality` and `ci / build`.

---

### Step 4: GitHub Ruleset (10–15 min)

```
In GitHub → Settings → Rules → Rulesets:

1. Click "New ruleset" → "New branch ruleset"
2. Name: main-protection
3. Enforcement: Active
4. Target: Branch name is "main"
5. Add required status checks: ci / quality, ci / build
6. Add PR review requirement: 1 approval
7. Enable: Dismiss stale reviews, Block force-push, Block deletions
8. Create

Verify: Ruleset shows as "Active" for main branch.
```

**Result:** `main` branch is protected; merge requires passing checks + approval.

---

### Step 5: End-to-End Validation (15–20 min)

```bash
# Local: Create a test PR
git checkout -b test/vercel-setup
echo "# Test" > TEST_VERCEL_SETUP.md
git add TEST_VERCEL_SETUP.md
git commit -m "test: validate Vercel setup"
git push origin test/vercel-setup

# GitHub: Open PR
# → Check that CI runs (wait 5–10 min)
# → Check that Vercel preview deploys
# → Click preview URL and validate site loads
# → Verify merge button is enabled (if checks pass) or disabled (if not)
# → Merge PR (Squash and merge)

# Vercel: Monitor production promotion
# → Check that Production deployment was created
# → Confirm status is READY (checks passed)
# → Open production URL and validate

# Local: Cleanup
git branch -d test/vercel-setup
git push origin --delete test/vercel-setup
```

**Result:** E2E validation confirms preview → merge → production promotion works.

---

## 📊 Success Criteria (How to Know It Worked)

✅ **All of these must be true:**

1. Vercel project exists and has both preview + production URLs
2. Environment variables are set for preview and production scopes
3. Vercel shows Deployment Checks required for production
4. GitHub ruleset exists and is Active for `main` branch
5. GitHub Ruleset requires `ci / quality` and `ci / build` before merge
6. GitHub Ruleset requires 1 PR approval before merge
7. Test PR created and CI checks ran
8. Test PR created a preview deployment
9. Test PR could be merged only after checks passed
10. After merge, production deployed automatically without manual promotion
11. Production URL is live and functional

**If all 11 are true → Phase 1 is complete and validated! 🎉**

---

## 🆘 Quick Troubleshooting

| Problem                                | Quick Fix                                                         | Full Guide                                                                                                                       |
| -------------------------------------- | ----------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| Vercel waits for checks indefinitely   | Verify `ci.yml` runs on `push: [main]` and check names are exact  | [Runbook](/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md#vercel-waits-indefinitely-for-checks)        |
| Preview deployment fails               | Verify Node version and pnpm version match (Node 20, pnpm 10.0.0) | [Runbook](/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md#preview-deployment-fails-but-ci-checks-pass) |
| Evidence links broken in preview       | Verify `NEXT_PUBLIC_DOCS_BASE_URL` is set for Preview scope       | [Runbook](/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md#evidence-links-are-broken-in-preview)        |
| Merge button disabled when checks pass | Verify ruleset is **Active** (not Evaluate/Disabled)              | [Ruleset Guide](/docs/70-reference/portfolio-app-github-ruleset-config.md#merge-button-stays-disabled-even-after-checks-pass)    |
| CI checks don't appear in PR           | Wait 3 min; check `.github/workflows/ci.yml` exists and is valid  | [Runbook](/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md#github-checks-not-running)                   |

---

## 📚 Reference Documents

All details here (no other docs needed):

- **Full Procedures:** [rbk-vercel-setup-and-promotion-validation.md](/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md) (6 phases, all steps)
- **GitHub Ruleset Setup:** [portfolio-app-github-ruleset-config.md](/docs/70-reference/portfolio-app-github-ruleset-config.md) (detailed + validation)
- **Full Checklist:** [phase-1-completion-checklist.md](./phase-1-completion-checklist.md) (master task list)
- **Deployment Policy:** [Portfolio App Deployment Dossier](/docs/60-projects/portfolio-app/03-deployment.md)
- **ADR-0007:** [Vercel + Promotion Checks](/docs/10-architecture/adr/adr-0007-portfolio-app-hosting-vercel-with-promotion-checks.md)

---

## 🎯 Next After Phase 1 Complete

Once all 11 success criteria are met:

1. ✅ Update `phase-1-completion-checklist.md` with actual URLs
2. ✅ Commit: `docs: mark Phase 1 complete with live Vercel + checks`
3. 🚀 Begin Phase 2: Select exemplar project for "gold standard" case study

See [roadmap.md](./roadmap.md#phase-2--gold-standard-project-and-credibility-baseline) for Phase 2 details.

---

## 💬 Questions?

Refer to:

- Detailed procedure: [rbk-vercel-setup-and-promotion-validation.md](/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md)
- Troubleshooting section in same runbook
- GitHub Ruleset guide (if GitHub-specific)
- ADR-0007 (if design questions)
