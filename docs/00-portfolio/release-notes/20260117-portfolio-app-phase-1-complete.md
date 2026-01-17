---
title: 'Release Notes: Portfolio App Phase 1 Complete (Baseline + Production Deployment + Governance)'
description: 'Phase 1 completion of the Portfolio App including app skeleton, evidence-first UX, deterministic CI quality gates, Vercel deployment infrastructure, production promotion checks, and branch governance.'
tags:
  [
    release-notes,
    portfolio-app,
    phase-1,
    deployment,
    governance,
    vercel,
    github-checks,
  ]
date: 2026-01-17
---

# Release Notes: Portfolio App Phase 1 Complete (Baseline + Production Deployment + Governance)

## Summary

Phase 1 of the Portfolio App is now complete. The Portfolio App is a production-quality, public-facing Next.js + TypeScript application deployed to Vercel with evidence-first UX, deterministic build posture, and enterprise-grade delivery governance. The app provides stable navigation surfaces for reviewers, enforces CI quality gates, supply-chain hygiene, protected mainline workflows, and production promotion gated by GitHub checks.

**Status:** ✅ **Phase 1 Complete** (2026-01-17)

**Deployment:** App is live at production domain with preview deployments per PR, automatic promotion to production upon successful checks, and rollback capability via Git.

---

## Highlights

- A complete front-of-house application skeleton with stable routes and reviewer-oriented content, live and accessible
- Centralized, public-safe configuration with documentation integration contract (`NEXT_PUBLIC_*` environment variables)
- **Deterministic CI quality gates** with stable check naming (`ci / quality`, `ci / build`) for governance and promotion workflows
- **Vercel deployment infrastructure** with preview environments per PR and production promotion gated by GitHub Deployment Checks
- **GitHub Ruleset protection** on `main` branch enforcing required checks, PR reviews, and preventing force-push/deletion
- **Production promotion workflow**: Automatic progression from PR → preview deployment → CI checks → production deployment
- Baseline supply-chain controls (CodeQL scanning + Dependabot dependency automation)
- Comprehensive runbooks and governance documentation for operations teams

---

## Added

### Application surface (routes and UX)

- Landing page (`/`) as evidence-first entry point:
  - Reviewer "fast path" guidance
  - Curated links into Documentation App evidence hubs
- Interactive CV skeleton (`/cv`) with structured capability sections and evidence links
- Projects listing (`/projects`) with featured entries and scalable registry
- Project detail route (`/projects/[slug]`) using standard "proof + evidence links" shape
- Contact page (`/contact`) with static contact methods (no backend; reduced surface area)

### Configuration and evidence-link contract

- Centralized public-safe configuration (`src/lib/config.ts`):
  - Reads only `NEXT_PUBLIC_*` variables (client-visible)
  - Stable helpers for evidence links (`docsUrl()`) and mail links (`mailtoUrl()`)
- Environment variable contract:
  - `.env.example` documents required/optional keys with public-safety guidance
  - Local development uses `.env.local` (not committed)
- Committed to git for reproducibility

### Project registry

- Minimal project registry to support scalable content:
  - `src/data/projects.ts` defines `Project` and `EvidenceLinks` types
  - Featured project entries with stable slugs and evidence paths

### Deployment infrastructure (Phase 1)

- **Vercel project setup**:
  - Connected `bryce-seefieldt/portfolio-app` repository to Vercel
  - Configured preview deployments per PR (auto-generated URLs)
  - Configured production deployment on `main` (custom domain)

- **Environment variable scoping** (Vercel):
  - Preview scope: `NEXT_PUBLIC_DOCS_BASE_URL`, `NEXT_PUBLIC_SITE_URL`, etc.
  - Production scope: Same variables with production values
  - Both scopes configured and deployed

- **GitHub Deployment Checks integration**:
  - Vercel configured as GitHub Deployment Check provider
  - Checks `ci / quality` and `ci / build` required before production promotion
  - Deployment Checks set to "blocking" (production waits for checks)
  - Preview deployments are immediate (checks don't gate preview)

- **GitHub Ruleset protection** (`main-protection`):
  - PR required before merge
  - Required checks: `ci / quality` and `ci / build`
  - Force-push blocked
  - Branch deletion prevented
  - Conversation resolution required (recommended baseline)

### Operational runbooks and documentation

- **Vercel Setup Runbook** (`rbk-vercel-setup-and-promotion-validation.md`):
  - 6-phase complete procedure for Vercel + GitHub Checks deployment
  - Detailed URL discovery guidance (preview vs production, stable preview strategies)
  - Vercel UI navigation notes and Deployment Checks configuration
  - 11 troubleshooting scenarios with solutions

- **GitHub Ruleset Configuration Guide** (`portfolio-app-github-ruleset-config.md`):
  - Step-by-step GitHub Ruleset setup with validation tests
  - Troubleshooting for common issues

- **Portfolio App Deployment Dossier** (`03-deployment.md`):
  - Governance model and deployment flow definition
  - Phase 1 (Setup) and Phase 2 (Operations) separation
  - Rollback procedures and incident response

- **Phase 1 Completion Checklist** (`phase-1-completion-checklist.md`):
  - 6 admin tasks with time estimates and validation sections
  - 11-point success criteria (all complete)
  - Troubleshooting quick reference

- **Phase 1 Quick Reference Card** (`phase-1-quick-reference.md`):
  - 1-page executive summary with copy-paste instructions
  - Decision table with task times and links
  - Validation checklist

### Repository documentation

- README updated with:
  - Local development commands with correct toolchain
  - Links to governance and runbooks
  - Deployment status (live and functional)

---

## Changed

### Developer workflow and quality enforcement

- Standardized local command contract:
  - `pnpm lint` (ESLint + Prettier check)
  - `pnpm format:check` (Prettier verification)
  - `pnpm typecheck` (TypeScript strict mode)
  - `pnpm build` (Next.js production build)

- Formatting configuration for modern ecosystems:
  - Prettier uses ESM (`prettier.config.mjs`)
  - Tailwind class sorting plugin enabled

- Linting via ESLint CLI (Next.js no longer provides `next lint` in modern versions)

---

## Governance and Security Baselines

### Continuous Integration (CI) quality gates

- GitHub Actions CI with stable check names:
  - `ci / quality` (lint + format check + typecheck)
  - `ci / build` (production build; depends on quality gate)
- Deterministic installs:
  - `pnpm install --frozen-lockfile` enforced in CI
  - Same lock behavior as Vercel builds

### Deployment workflow

- **Preview deployments**:
  - Automatic on every PR
  - Auto-generated URLs
  - No check gating (immediate)
  - Rollback: Delete PR

- **Production deployments**:
  - Automatic only after merge to `main`
  - Gated by GitHub Deployment Checks (`ci / quality`, `ci / build` must pass)
  - Custom domain
  - Rollback: Revert commit and redeploy via Git

### Branch governance

- `main` branch protected via GitHub Rulesets:
  - PR required before merge
  - Required checks enforced (`ci / quality`, `ci / build`)
  - Force-push blocked
  - Branch deletion prevented
  - Conversation resolution required

### Supply-chain automation

- CodeQL scanning:
  - Enabled for JavaScript/TypeScript
  - Runs on PRs and `main`
  - Scheduled periodic scans enabled

- Dependabot automation:
  - Weekly cadence for dependencies and GitHub Actions
  - Patch/minor updates grouped
  - Major updates excluded by default (reduces unplanned churn)

### PR discipline

- PR template enforces:
  - Change summary and rationale
  - Evidence checklist (local commands + CI)
  - "No secrets added" declaration
  - Documentation impact checklist (dossier, ADR, threat model, runbooks where applicable)

---

## Verification (Phase 1 Success Criteria — All Complete ✅)

The Phase 1 release is valid when:

- ✅ Vercel project connected and initial deployment successful
- ✅ Environment variables configured for preview and production
- ✅ GitHub Deployment Checks gate production promotion
- ✅ GitHub Ruleset protects `main` branch
- ✅ Test PR validated:
  - ✅ Preview deployment works
  - ✅ CI checks run and pass
  - ✅ Merge is allowed only when checks pass
  - ✅ Production promotion automatic after merge
  - ✅ Production domain live and functional
- ✅ Documentation updated with URLs and status
- ✅ All team members notified of live status

---

## Known Limitations (Intentional)

- No authentication system
- No backend contact form (static contact links only)
- Project registry remains static and minimal by design (intended to evolve into richer data-driven model)
- Deeper technical artifacts (decisions, threat models, runbooks) maintained in Documentation App (linked from Portfolio App)
- No smoke tests yet (planned for Phase 2)

---

## Architecture & Governance References

- [ADR-0007: Portfolio App Hosting on Vercel with Promotion Checks](/docs/10-architecture/adr/adr-0007-portfolio-app-hosting-vercel-with-promotion-checks.md)
- [ADR-0008: Portfolio App CI Quality Gates](/docs/10-architecture/adr/adr-0008-portfolio-app-ci-quality-gates.md)
- [Portfolio App Deployment Dossier](/docs/60-projects/portfolio-app/03-deployment.md)
- [Vercel Setup Runbook](/docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md)
- [GitHub Ruleset Configuration Guide](/docs/70-reference/portfolio-app-github-ruleset-config.md)

---

## Phase 2 Planning (Next Increments)

With Phase 1 complete and production deployment validated, Phase 2 will focus on:

- Implement smoke tests (and later unit/e2e tests) as phased gates
- Expand project registry and complete one "gold standard" project page with full evidence trail
- Add enhanced observability (logging, metrics, alerting for production deployment)
- Implement content-driven features (dynamic project data, richer capability evidence)
- Consider authentication for future "member-only" content paths
