# 🎯 Phase 1 Admin Tasks: Complete Documentation Package

## Overview

You now have **complete, step-by-step documentation** for the final admin tasks to complete Phase 1 deployment. Everything is aligned with portfolio-docs governance and architecture requirements.

---

## 📦 What You Have

### **Quick Start (5–10 minutes)**

- **[phase-1-quick-reference.md](./portfolio-docs/docs/00-portfolio/phase-1-quick-reference.md)**
  - One-page executive summary
  - Copy-paste instructions for all 5 tasks
  - 11-point success validation checklist
  - Quick troubleshooting matrix

### **Detailed Procedures (20–30 minutes)**

- **[rbk-vercel-setup-and-promotion-validation.md](./portfolio-docs/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md)** — Main runbook
  - Phase 1: Connect portfolio-app to Vercel (10–15 min)
  - Phase 2: Configure environment variables (10–15 min)
  - Phase 3: Set up GitHub Deployment Checks (5–10 min)
  - Phase 4: Configure GitHub Ruleset (10–15 min)
  - Phase 5: End-to-end validation (15–20 min)
  - Phase 6: Documentation updates (5–10 min)
  - Troubleshooting for common issues

- **[portfolio-app-github-ruleset-config.md](./portfolio-docs/docs/70-reference/portfolio-app-github-ruleset-config.md)** — Reference guide
  - Detailed GitHub Ruleset setup
  - 4 validation tests
  - Troubleshooting

### **Master Checklist (5 min to scan)**

- **[phase-1-completion-checklist.md](./portfolio-docs/docs/00-portfolio/phase-1-completion-checklist.md)**
  - 6 phases with detailed checklists
  - Pre/post-setup validation for each phase
  - Success criteria
  - Links to all procedures

### **Implementation Guide (This Document)**

- **[PHASE_1_ADMIN_TASKS.md](./portfolio-docs/PHASE_1_ADMIN_TASKS.md)** — Comprehensive guide
  - Reading recommendations by use case
  - Recommended 60-minute execution plan
  - Pro tips and warnings
  - Complete directory of all docs

---

## 🎯 The 5 Admin Tasks (High Level)

| #     | Task                            | Time      | Result                                                  |
| ----- | ------------------------------- | --------- | ------------------------------------------------------- |
| **1** | Connect portfolio-app to Vercel | 10–15 min | Vercel project with preview + production URLs           |
| **2** | Configure environment variables | 10–15 min | NEXT*PUBLIC*\* vars set for preview + production        |
| **3** | Set up GitHub Deployment Checks | 5–10 min  | Production promotion gated by ci / quality + ci / build |
| **4** | Configure GitHub Ruleset        | 10–15 min | `main` branch protected; merge requires checks + review |
| **5** | E2E validation                  | 15–20 min | Validate PR → preview → merge → production promotion    |

**Total: 50–75 minutes execution time**

---

## ✅ Success Criteria (What "Done" Looks Like)

After completing all 5 tasks, verify **all 11 of these:**

1. ✅ Vercel project exists with preview + production URLs
2. ✅ Environment variables configured for preview and production scopes
3. ✅ Vercel Deployment Checks imports `ci / quality` and `ci / build`
4. ✅ GitHub Ruleset `main-protection` is Active
5. ✅ GitHub Ruleset requires both checks before merge
6. ✅ GitHub Ruleset requires 1 PR approval before merge
7. ✅ Test PR created; CI checks ran and passed
8. ✅ Test PR created Vercel preview deployment
9. ✅ Test PR merge was allowed only after checks passed
10. ✅ Production deployment automatic after merge (no manual promotion needed)
11. ✅ Production URL is live and functional

**All 11 checked → Phase 1 complete! 🎉**

---

## 🔧 How to Execute (Recommended Approach)

### **Step 0: Pre-Flight (5 minutes)**

- [ ] Read [phase-1-quick-reference.md](./portfolio-docs/docs/00-portfolio/phase-1-quick-reference.md)
- [ ] Verify:
  - [ ] You have Vercel account access
  - [ ] You have GitHub admin access to portfolio-app
  - [ ] You know your docs URL (where `/docs` will be)
  - [ ] You have 60–75 minutes uninterrupted

### **Step 1: Connect to Vercel (15 minutes)**

- [ ] Follow [Runbook Phase 1](./portfolio-docs/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md#phase-1-connect-portfolio-app-to-vercel)
- [ ] Expected result: Preview + Production URLs exist ✅

### **Step 2: Configure Env Vars (15 minutes)**

- [ ] Gather your actual URLs:
  - [ ] Docs preview URL
  - [ ] Docs production URL
  - [ ] Your GitHub profile URL
  - [ ] Your LinkedIn profile URL
  - [ ] Your contact email
- [ ] Follow [Runbook Phase 2](./portfolio-docs/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md#phase-2-configure-environment-variables)
- [ ] Expected result: Variables set for both scopes; deployments redeploy ✅

### **Step 3: GitHub Deployment Checks (10 minutes)**

- [ ] Follow [Runbook Phase 3](./portfolio-docs/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md#phase-3-set-up-github-deployment-checks-production-promotion-gating)
- [ ] Expected result: Vercel shows Deployment Checks required for production ✅

### **Step 4: GitHub Ruleset (15 minutes)**

- [ ] Option A (Detailed): [Ruleset Guide](./portfolio-docs/docs/70-reference/portfolio-app-github-ruleset-config.md)
- [ ] Option B (Runbook): [Runbook Phase 4](./portfolio-docs/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md#phase-4-configure-github-ruleset-optional-but-recommended)
- [ ] Expected result: Ruleset `main-protection` is Active ✅

### **Step 5: E2E Validation (25 minutes)**

- [ ] Follow [Runbook Phase 5 & 6](./portfolio-docs/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md#phase-5-end-to-end-validation)
- [ ] Key steps:
  - [ ] Create test PR
  - [ ] Verify CI checks run
  - [ ] Verify Vercel preview deploys
  - [ ] Verify merge is allowed when checks pass
  - [ ] Merge PR
  - [ ] Verify production deploys automatically
- [ ] Expected result: Full end-to-end validation ✅

### **Step 6: Verify Success (5 minutes)**

- [ ] Check all 11 success criteria from [phase-1-quick-reference.md](./portfolio-docs/docs/00-portfolio/phase-1-quick-reference.md#-success-criteria-how-to-know-it-worked)
- [ ] All 11 checked? **Phase 1 is complete! 🎉**

---

## 📚 Documentation Structure

```
portfolio-docs/
├── PHASE_1_ADMIN_TASKS.md ← You are here
├── docs/
│   ├── 00-portfolio/
│   │   ├── index.md ← Links to quick ref + checklist
│   │   ├── phase-1-quick-reference.md ← 1-page summary (START HERE)
│   │   ├── phase-1-completion-checklist.md ← Master checklist
│   │   └── roadmap.md ← Overall program plan
│   ├── 10-architecture/adr/
│   │   ├── adr-0007-portfolio-app-hosting-vercel.md ← Why Vercel + checks
│   │   └── adr-0008-portfolio-app-ci-quality-gates.md ← Why CI matters
│   ├── 50-operations/runbooks/
│   │   ├── index.md ← Lists all runbooks
│   │   └── rbk-vercel-setup-and-promotion-validation.md ← MAIN PROCEDURE
│   ├── 60-projects/portfolio-app/
│   │   └── 03-deployment.md ← Deployment policy
│   ├── 70-reference/
│   │   ├── portfolio-app-config-reference.md ← All configs
│   │   └── portfolio-app-github-ruleset-config.md ← Ruleset details
│   └── _meta/env/
│       └── portfolio-app-env-contract.md ← Env var requirements
└── portfolio-app/
    ├── .env.example ← Environment var template
    ├── .github/workflows/ci.yml ← CI check definitions
    └── src/lib/config.ts ← Config contract implementation
```

---

## 🔗 All Documentation Links

**Start Here:**

- [phase-1-quick-reference.md](./portfolio-docs/docs/00-portfolio/phase-1-quick-reference.md) ← **READ FIRST** (5 min)

**Main Procedures:**

- [rbk-vercel-setup-and-promotion-validation.md](./portfolio-docs/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md) ← **FOLLOW THIS** (all steps)
- [portfolio-app-github-ruleset-config.md](./portfolio-docs/docs/70-reference/portfolio-app-github-ruleset-config.md) ← **For GitHub Ruleset details**

**Master Checklist:**

- [phase-1-completion-checklist.md](./portfolio-docs/docs/00-portfolio/phase-1-completion-checklist.md) ← **Track your progress**

**Policy & Why:**

- [ADR-0007](./portfolio-docs/docs/10-architecture/adr/adr-0007-portfolio-app-hosting-vercel-with-promotion-checks.md) — Why Vercel + Deployment Checks
- [ADR-0008](./portfolio-docs/docs/10-architecture/adr/adr-0008-portfolio-app-ci-quality-gates.md) — Why CI governance matters
- [Portfolio App Deployment Dossier](./portfolio-docs/docs/60-projects/portfolio-app/03-deployment.md) — Governance policy
- [Environment Contract](./portfolio-docs/docs/_meta/env/portfolio-app-env-contract.md) — NEXT*PUBLIC*\* requirements

**Configuration Reference:**

- [Portfolio App Config Reference](./portfolio-docs/docs/70-reference/portfolio-app-config-reference.md) — All configuration files
- [.env.example](./portfolio-app/.env.example) — Environment variable template
- [ci.yml](./portfolio-app/.github/workflows/ci.yml) — CI workflow definition

---

## 🚨 Critical Constants (Copy-Paste These)

**Repository:**

```
bryce-seefieldt/portfolio-app
```

**Required CI Checks (must match exactly):**

```
ci / quality
ci / build
```

**GitHub Ruleset Configuration:**

```
Ruleset Name: main-protection
Target Branch: main
Enforcement: Active

Required Checks: ci / quality, ci / build
PR Review Required: 1 approval
Dismiss Stale Reviews: ON
Block Force-Push: ON
Block Deletions: ON
```

**Environment Variables to Configure (in Vercel):**

_Preview Scope:_

```
NEXT_PUBLIC_DOCS_BASE_URL = https://portfolio-docs-git-preview.vercel.app
NEXT_PUBLIC_SITE_URL = (optional)
NEXT_PUBLIC_GITHUB_URL = https://github.com/your-handle
NEXT_PUBLIC_LINKEDIN_URL = https://www.linkedin.com/in/your-handle/
NEXT_PUBLIC_CONTACT_EMAIL = your-email@example.com
```

_Production Scope:_

```
NEXT_PUBLIC_DOCS_BASE_URL = https://docs.yourdomain.com
NEXT_PUBLIC_SITE_URL = https://portfolio.yourdomain.com
NEXT_PUBLIC_GITHUB_URL = https://github.com/your-handle
NEXT_PUBLIC_LINKEDIN_URL = https://www.linkedin.com/in/your-handle/
NEXT_PUBLIC_CONTACT_EMAIL = your-email@example.com
```

---

## ⚠️ Key Warnings

1. **Check names are STABLE API:**
   - `ci / quality` and `ci / build` are used by Vercel and GitHub
   - Do NOT rename them without updating all references
   - See [ADR-0008](./portfolio-docs/docs/10-architecture/adr/adr-0008-portfolio-app-ci-quality-gates.md)

2. **NEXT*PUBLIC*\* variables are CLIENT-VISIBLE:**
   - Never place secrets, tokens, or private endpoints here
   - All values will be visible in browser client bundle
   - See [Environment Contract](./portfolio-docs/docs/_meta/env/portfolio-app-env-contract.md)

3. **GitHub Ruleset must be ACTIVE (not Evaluate):**
   - If it's in "Evaluate" mode, it won't actually block merges
   - Verify status after creation

4. **Frozen lockfile in CI is required:**
   - Install command must use `pnpm install --frozen-lockfile`
   - Ensures deterministic builds
   - Matches Node 20, pnpm 10.0.0 pinned versions

---

## 🆘 Troubleshooting Quick Links

| Issue                                | Link                                                                                                                                                             |
| ------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Vercel waits indefinitely for checks | [Runbook Troubleshooting](./portfolio-docs/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md#vercel-waits-indefinitely-for-checks)        |
| Preview deployment fails             | [Runbook Troubleshooting](./portfolio-docs/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md#preview-deployment-fails-but-ci-checks-pass) |
| Evidence links broken                | [Runbook Troubleshooting](./portfolio-docs/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md#evidence-links-are-broken-in-preview)        |
| Merge button disabled                | [Ruleset Troubleshooting](./portfolio-docs/docs/70-reference/portfolio-app-github-ruleset-config.md#merge-button-stays-disabled-even-after-checks-pass)          |
| Force-push still works               | [Ruleset Troubleshooting](./portfolio-docs/docs/70-reference/portfolio-app-github-ruleset-config.md#force-push-still-works)                                      |

---

## 📊 Time Budget

| Task                         | Time     | Cumulative     |
| ---------------------------- | -------- | -------------- |
| Pre-flight + quick reference | 5–10 min | 5–10 min       |
| Task 1: Vercel connection    | 15 min   | 20–25 min      |
| Task 2: Env vars             | 15 min   | 35–40 min      |
| Task 3: Deployment Checks    | 10 min   | 45–50 min      |
| Task 4: GitHub Ruleset       | 15 min   | 60–65 min      |
| Task 5: E2E validation       | 25 min   | 85–90 min      |
| Verify + buffer              | 5–10 min | **90–100 min** |

**Total: ~90–100 minutes (1.5 hours)**

---

## 🎓 What You'll Learn

By completing Phase 1 deployment, you'll understand:

- ✅ How to integrate GitHub with Vercel
- ✅ How to gate production with CI checks
- ✅ How to use GitHub Rulesets for branch protection
- ✅ How to manage environment variables per scope
- ✅ How to validate PR → preview → merge → production flow
- ✅ Enterprise-grade SDLC governance (in practice)

---

## 📝 After You Complete Phase 1

1. ✅ Verify all 11 success criteria
2. ✅ Commit: `docs: mark Phase 1 complete with live Vercel + checks` (in portfolio-docs)
3. ✅ Update [phase-1-quick-reference.md](./portfolio-docs/docs/00-portfolio/phase-1-quick-reference.md) with your actual URLs
4. 🚀 Begin [Phase 2: Gold Standard Project](./portfolio-docs/docs/00-portfolio/roadmap.md#phase-2--gold-standard-project-and-credibility-baseline)

**Phase 2** involves selecting an exemplar project and creating deep evidence artifacts for it (multiple ADRs, threat model, runbooks, release notes, etc.).

---

## ✨ TL;DR

1. **Read:** [phase-1-quick-reference.md](./portfolio-docs/docs/00-portfolio/phase-1-quick-reference.md) (5 min)
2. **Follow:** [rbk-vercel-setup-and-promotion-validation.md](./portfolio-docs/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md) (Phases 1–6)
3. **Validate:** All 11 success criteria from quick reference
4. **Done:** Phase 1 complete! 🎉

**Estimated time: 90–100 minutes**

---

**Next: [Phase 2 Planning](./portfolio-docs/docs/00-portfolio/roadmap.md#phase-2--gold-standard-project-and-credibility-baseline)**
