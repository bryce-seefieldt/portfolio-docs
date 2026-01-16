# Phase 1 Completion: Admin Tasks Implementation Guide

## 📌 Overview

You now have **comprehensive documentation** for Phase 1 final deployment. This guide shows you what you have and how to use it.

---

## 🎯 What Phase 1 Completion Means

**Phase 1 code is 100% complete:**

- ✅ Portfolio App repository created with 5 core routes
- ✅ CI/CD governance with `ci / quality` and `ci / build` checks
- ✅ CodeQL + Dependabot configured
- ✅ Environment variable contract defined
- ✅ All evidence documentation complete (dossiers, ADRs, runbooks, threat models)

**Phase 1 deployment requires 5 admin tasks (this is what you're doing now):**

1. Connect portfolio-app to Vercel
2. Configure environment variables
3. Set up GitHub Deployment Checks
4. Configure GitHub Ruleset for `main` branch
5. Validate end-to-end

---

## 📚 Documentation You Have

### **For Quick Reference: Read FIRST**

- **[phase-1-quick-reference.md](./portfolio-docs/docs/00-portfolio/phase-1-quick-reference.md)**
  - ⏱️ 5-minute read
  - 📋 One-page exec summary
  - 🔑 Copy-paste instructions for all 5 tasks
  - ✅ 11-point success criteria
  - 🆘 Quick troubleshooting matrix
  - **START HERE if you're short on time**

### **For Detailed Procedures: Follow These**

1. **[rbk-vercel-setup-and-promotion-validation.md](./portfolio-docs/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md)**
   - ⏱️ 20–30 minute read
   - 📖 6 complete phases with all steps
   - 🔧 Environment variable configuration tables
   - ✅ Validation tests for each phase
   - 🆘 Troubleshooting section
   - **USE THIS for the main procedures (tasks 1–5)**

2. **[portfolio-app-github-ruleset-config.md](./portfolio-docs/docs/70-reference/portfolio-app-github-ruleset-config.md)**
   - ⏱️ 10 minute read
   - 📖 Detailed GitHub Ruleset setup
   - ✅ 4 validation tests
   - 🆘 Troubleshooting
   - **USE THIS for detailed GitHub Ruleset configuration (task 4)**

### **For Master Checklist: Tick Off Your Progress**

- **[phase-1-completion-checklist.md](./portfolio-docs/docs/00-portfolio/phase-1-completion-checklist.md)**
  - ⏱️ 5–10 minute scan
  - ✅ 6 phases with detailed checklists
  - 📋 Pre/post-setup validation for each phase
  - 🔗 Links to all procedures
  - **USE THIS to track what you've completed**

### **For Policy Reference: Understand the Why**

- **[ADR-0007: Vercel + Promotion Checks](./portfolio-docs/docs/10-architecture/adr/adr-0007-portfolio-app-hosting-vercel-with-promotion-checks.md)** — Decision rationale
- **[ADR-0008: CI Quality Gates](./portfolio-docs/docs/10-architecture/adr/adr-0008-portfolio-app-ci-quality-gates.md)** — CI governance rationale
- **[Portfolio App Deployment Dossier](./portfolio-docs/docs/60-projects/portfolio-app/03-deployment.md)** — Deployment policy document
- **[Environment Variable Contract](./portfolio-docs/docs/_meta/env/portfolio-app-env-contract.md)** — NEXT*PUBLIC*\* requirements

---

## 🚀 Recommended Reading Order (by Use Case)

### **If you have 10 minutes:**

1. Read: [phase-1-quick-reference.md](./portfolio-docs/docs/00-portfolio/phase-1-quick-reference.md)
2. Execute: Tasks 1–5 using copy-paste commands
3. Validate: Check the 11 success criteria
4. Done!

### **If you have 45 minutes:**

1. Read: [phase-1-quick-reference.md](./portfolio-docs/docs/00-portfolio/phase-1-quick-reference.md) (5 min)
2. Detailed procedures:
   - [rbk-vercel-setup-and-promotion-validation.md](./portfolio-docs/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md) — Phases 1–3 (15 min)
   - [portfolio-app-github-ruleset-config.md](./portfolio-docs/docs/70-reference/portfolio-app-github-ruleset-config.md) — Detailed ruleset setup (10 min)
   - [rbk-vercel-setup-and-promotion-validation.md](./portfolio-docs/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md) — Phases 5–6 (15 min)
3. Execute all tasks
4. Done!

### **If you want to understand the policy first:**

1. Read: [ADR-0007](./portfolio-docs/docs/10-architecture/adr/adr-0007-portfolio-app-hosting-vercel-with-promotion-checks.md) (why Vercel + checks)
2. Read: [ADR-0008](./portfolio-docs/docs/10-architecture/adr/adr-0008-portfolio-app-ci-quality-gates.md) (why CI checks matter)
3. Read: [Portfolio App Deployment Dossier](./portfolio-docs/docs/60-projects/portfolio-app/03-deployment.md) (policy doc)
4. Execute: [phase-1-quick-reference.md](./portfolio-docs/docs/00-portfolio/phase-1-quick-reference.md)
5. Done!

---

## 📊 5 Admin Tasks: At a Glance

| #     | Task                     | Docs                                                                                                                                                                             | Time      | What It Does                                                      |
| ----- | ------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- | ----------------------------------------------------------------- |
| **1** | Connect to Vercel        | [Runbook Phase 1](./portfolio-docs/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md#phase-1-connect-portfolio-app-to-vercel)                             | 10–15 min | Import repo, configure build settings, deploy                     |
| **2** | Configure env vars       | [Runbook Phase 2](./portfolio-docs/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md#phase-2-configure-environment-variables)                             | 10–15 min | Set `NEXT_PUBLIC_DOCS_BASE_URL` etc. for preview + production     |
| **3** | GitHub Deployment Checks | [Runbook Phase 3](./portfolio-docs/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md#phase-3-set-up-github-deployment-checks-production-promotion-gating) | 5–10 min  | Import `ci / quality` and `ci / build` to Vercel; gate production |
| **4** | GitHub Ruleset           | [Ruleset Guide](./portfolio-docs/docs/70-reference/portfolio-app-github-ruleset-config.md)                                                                                       | 10–15 min | Create `main-protection` ruleset; require checks + review         |
| **5** | E2E Validation           | [Runbook Phase 5 & 6](./portfolio-docs/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md#phase-5-end-to-end-validation)                                   | 15–20 min | Test PR → preview → merge → production promotion                  |

---

## ✅ Success Criteria (11-Point Validation)

After completing all 5 tasks, verify:

- [ ] 1. Vercel project exists with preview + production URLs
- [ ] 2. Environment variables set for preview and production scopes
- [ ] 3. Vercel Deployment Checks imports `ci / quality` and `ci / build`
- [ ] 4. GitHub Ruleset `main-protection` is Active
- [ ] 5. GitHub Ruleset requires both checks before merge
- [ ] 6. GitHub Ruleset requires 1 PR approval before merge
- [ ] 7. Test PR created; CI checks ran
- [ ] 8. Test PR created Vercel preview deployment
- [ ] 9. Test PR merge was allowed only after checks passed
- [ ] 10. Production deployment automatic after merge (no manual promotion needed)
- [ ] 11. Production URL is live and functional

**All 11 checked? Phase 1 is complete! 🎉**

---

## 🔗 Directory of All Docs

**Quick Reference:**

- `/portfolio-docs/docs/00-portfolio/phase-1-quick-reference.md` ← **START HERE**
- `/portfolio-docs/docs/00-portfolio/phase-1-completion-checklist.md`

**Detailed Procedures:**

- `/portfolio-docs/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md` ← **MAIN PROCEDURE**
- `/portfolio-docs/docs/70-reference/portfolio-app-github-ruleset-config.md` ← **GITHUB RULESET DETAILS**

**Governance & Policy:**

- `/portfolio-docs/docs/10-architecture/adr/adr-0007-portfolio-app-hosting-vercel-with-promotion-checks.md`
- `/portfolio-docs/docs/10-architecture/adr/adr-0008-portfolio-app-ci-quality-gates.md`
- `/portfolio-docs/docs/60-projects/portfolio-app/03-deployment.md`
- `/portfolio-docs/docs/_meta/env/portfolio-app-env-contract.md`

**Portfolio App Configuration:**

- `/portfolio-app/.env.example` ← Environment variable examples
- `/portfolio-app/.github/workflows/ci.yml` ← CI check definitions
- `/portfolio-app/src/lib/config.ts` ← Config contract (NEXT*PUBLIC*\* usage)

---

## 🎯 Execution Plan

### **Recommended Approach: 60 Minute Session**

```
Time | Activity | Where | Duration
-----|----------|-------|----------
0–10 | Read quick reference | phase-1-quick-reference.md | 10 min
10–25 | Task 1: Connect to Vercel | Runbook Phase 1 | 15 min
25–40 | Task 2: Env vars | Runbook Phase 2 | 15 min
40–50 | Task 3: Deployment Checks | Runbook Phase 3 | 10 min
50–65 | Task 4: GitHub Ruleset | Ruleset Guide | 15 min
65–90 | Task 5: E2E Validation | Runbook Phase 5 & 6 | 25 min
90–95 | Verify all 11 criteria | phase-1-quick-reference.md | 5 min
95–100 | Commit: "Phase 1 complete" | GitHub | 5 min
```

**After 100 minutes:** Phase 1 is complete and validated. 🎉

---

## 💡 Pro Tips

1. **Have these open side-by-side:**
   - Vercel dashboard (one tab)
   - GitHub repository (one tab)
   - Runbook or quick reference (another tab)

2. **Use the copy-paste sections** in the quick reference to avoid typos

3. **Don't skip the validation tests** — they confirm everything is working

4. **If something doesn't work:**
   - Check the troubleshooting section in the runbook first
   - Verify the constant values (check names, branch names, etc.)
   - Re-read the step to ensure you didn't miss anything

5. **Document as you go:**
   - Note your actual Vercel URLs
   - Write down your environment variable values
   - Take a screenshot of the GitHub Ruleset when it's created

---

## 🎓 What You'll Learn

By completing Phase 1 deployment, you'll have:

- ✅ A live web application on Vercel with preview deployments
- ✅ Production promotion gated by CI checks (enterprise-grade governance)
- ✅ GitHub branch protection with ruleset enforcement
- ✅ End-to-end understanding of PR → preview → merge → production flow
- ✅ Hands-on experience with:
  - Vercel project configuration
  - GitHub Deployment Checks
  - GitHub Rulesets
  - Environment variable management
  - CI/CD integration patterns

---

## 📞 If You Get Stuck

1. **Check the runbook troubleshooting section first** — most issues are covered
2. **Re-read the step** — sometimes a small detail was missed
3. **Verify constants** — check names, URLs, scopes, etc.
4. **Check CI logs** — if checks aren't running, look at `.github/workflows/ci.yml`
5. **Refer to the reference docs** (ADRs, dossier) to understand the policy

---

## 🎉 After Phase 1 Complete

Once all 11 success criteria are met:

1. Update this guide with your actual URLs
2. Commit: `docs: mark Phase 1 complete with live Vercel + checks`
3. Move to [Phase 2: Gold Standard Project](./portfolio-docs/docs/00-portfolio/roadmap.md#phase-2--gold-standard-project-and-credibility-baseline)

Phase 2 involves selecting an exemplar project and creating deep evidence artifacts for it (multiple ADRs, threat model, runbooks, etc.).

---

## 📋 Final Checklist Before You Start

- [ ] Read [phase-1-quick-reference.md](./portfolio-docs/docs/00-portfolio/phase-1-quick-reference.md) (5 min)
- [ ] Have Vercel account access
- [ ] Have GitHub admin access to portfolio-app
- [ ] Know your docs URL (where `/docs` will be)
- [ ] Have 60–90 minutes uninterrupted
- [ ] Have relevant docs open in tabs
- [ ] Ready to execute

**✅ All checked? Let's go! Start with [phase-1-quick-reference.md](./portfolio-docs/docs/00-portfolio/phase-1-quick-reference.md) →**

---

_Last updated: 2026-01-16 with full Phase 1 admin task documentation_
