---
title: 'ADR-0010: Portfolio App as Gold Standard Exemplar Project'
status: 'accepted'
date: 2026-01-17
sidebar_position: 1.0
tags:
  [adr, architecture, portfolio-program, exemplar, quality-baseline]
---

# ADR-0010: Portfolio App as Gold Standard Exemplar Project

## Context

The exemplar milestone of the Portfolio Program (see [roadmap](/docs/00-portfolio/roadmap/index.md)) requires selecting one exemplary project to demonstrate senior-level engineering discipline. This project will serve as the template and quality bar for all future portfolio entries.

Candidate projects were evaluated:

| Criterion                                 | Portfolio App         | Portfolio Docs    | Past Project          | Mini-Demo                 |
| ----------------------------------------- | --------------------- | ----------------- | --------------------- | ------------------------- |
| **Already deployed & operational**        | ✅ Yes                | ✅ Yes            | ⚠️ Maybe              | ❌ No                     |
| **Governance trail (baseline documented)** | ✅ Complete           | ✅ Strong         | ⚠️ Partial            | ❌ None                   |
| **Scope (manageable)**                    | ✅ ~500 LOC           | ⚠️ Large codebase | ⚠️ Varies             | ✅ Defined                |
| **Real-world complexity**                 | ✅ Moderate           | ✅ High           | ⚠️ Varies             | ⚠️ Artificial             |
| **Establishes clear precedent**           | ✅ Next steps obvious | ⚠️ Less clear     | ❌ Hard to generalize | ❌ Limited transfer value |

## Decision

**Portfolio App** is selected as the gold standard exemplar project.

This means:

- Portfolio App becomes the reference implementation for professional engineering discipline
- All future portfolio projects must meet or exceed this quality bar
- The dossier structure, threat model approach, and runbook patterns established for portfolio-app become the standard template
- The exemplar milestone will comprehensively document and test portfolio-app; subsequent expansion will add additional projects following the same approach

## Rationale

1. **Already deployed and operational**
  - Baseline complete (Vercel + GitHub Checks deployed, live evidence accessible)
   - Live production deployment validates governance model
   - No backfill work to "make production-ready"

2. **Complete governance trail from the baseline**
   - ADRs exist (ADR-0007, ADR-0008)
   - Threat model started (can be expanded with STRIDE analysis)
   - Deployment dossier created (can be comprehensive)
   - CI/CD governance established and proven in practice
   - Release notes document decisions and changes

3. **Manageable scope for the exemplar milestone**
   - ~500 lines of application code
   - 5 core routes (not overwhelming)
   - Clear intent: evidence-first UX + links to docs
   - Complex enough to be credible, small enough to document thoroughly

4. **Real-world complexity without overwhelming detail**
   - Modern stack: Next.js + TypeScript + Vercel
   - Enterprise governance: GitHub Rulesets, Deployment Checks, CI gates
   - Security considerations: public-safe design, secrets management, threat modeling
   - Operations patterns: deploy/rollback/triage procedures
   - Real deployment challenges (URLs, env vars, preview vs production)

5. **Sets clear precedent for subsequent expansion**
   - Dossier structure becomes template (other projects follow same 10 sections)
   - Threat model approach (STRIDE analysis) becomes standard
   - Runbook pattern (deploy/triage/rollback) becomes repeatable
   - Testing strategy (Playwright smoke tests → unit → e2e) becomes baseline
   - Review checklist becomes clear and verifiable

6. **Demonstrates multiple disciplines in one project**
   - Frontend engineering (Next.js, React, TypeScript, responsive design)
   - Infrastructure (Vercel, GitHub, domain setup)
   - Security (threat modeling, public-safe design, secrets management)
   - Operations (CI/CD governance, deployments, rollback)
   - DevOps (GitHub Actions, Vercel Deployment Checks, branch protection)
   - Documentation (dossier, ADRs, runbooks)

## What the gold standard project proves

A senior engineer reviewing **portfolio-app** should conclude:

> "This person demonstrates professional-grade engineering discipline across multiple domains:
> clear architecture aligned to business intent,
> security awareness embedded in design,
> enterprise-grade CI/CD governance,
> operational readiness with repeatable procedures,
> and comprehensive evidence-first documentation."

**Specific evidence points:**

- ✅ **Architecture is clear and intentional**
  - Evidence: Dossier (Section II: Architecture) explains design goals, technology choices, data flow
  - Links to: ADRs (decisions), codebase (structure), README (local dev setup)

- ✅ **Security is thoughtfully designed**
  - Evidence: Threat model with STRIDE analysis documents threats, mitigations, residual risks
  - Links to: No secrets in code, CodeQL scanning, Dependabot enabled, PR template enforcement

- ✅ **Deployment is governed and safe**
  - Evidence: CI quality gates + Deployment Checks + GitHub Rulesets prevent unsafe changes
  - Links to: GitHub Actions workflows (ci/quality, ci/build), Vercel configuration, runbook

- ✅ **Operations are documented and repeatable**
  - Evidence: Runbooks for deploy, CI triage, rollback with step-by-step procedures
  - Links to: Real procedures tested and proven (baseline deployment completed)

- ✅ **Testing is automated and integrated in CI**
  - Evidence: Smoke tests (100% route coverage) run on every PR + merge
  - Links to: Playwright configuration, CI workflow, local test commands

- ✅ **Evidence links are comprehensive and verifiable**
  - Evidence: Project detail page links to dossier, threat model, ADRs, runbooks
  - Links all resolve correctly; broken link detection in CI prevents regressions

## Consequences

### Positive

- **Quality bar is set:** Future projects have a clear, achievable standard to meet
- **Documentation becomes scalable:** Dossier + threat model + runbooks template can be repeated
- **Pattern library grows:** Each project adds examples of solutions (security, testing, operations)
- **Evidence-first approach proven:** Reviewers can validate engineering posture through artifacts
- **Expansion is accelerated:** Second project will be faster because template exists

### Challenges

- **Portfolio App requires exemplar investment** (~19–32 hours)
  - Comprehensive dossier (10 sections, ~4000 words)
  - Threat model with STRIDE analysis
  - Three operational runbooks
  - Smoke test infrastructure (Playwright)
  - Enhanced project detail page with gold standard badge
  - Meaningful CV page with capability-to-proof mapping

- **All future projects must meet this bar**
  - Cannot add projects without dossier + threat model + runbooks
  - May slow down portfolio growth initially
  - Acceptable trade-off: quality over quantity

- **Retrospective documentation required**
  - Some baseline decisions already made; must be documented in ADRs
  - Threat model exists at high level; must be detailed with STRIDE analysis
  - Runbooks exist conceptually; must be written and tested

## Alternatives considered

### 1. Portfolio Docs App

**Rationale:** Also deployed, demonstrates ops maturity for Docusaurus platform  
**Rejected because:**

- Larger codebase (harder to document comprehensively in the exemplar milestone)
- Less diverse skill showcase (documentation platform, not full app)
- Roadmap suggests portfolio-app is the "face" of the program

### 2. Past project (if public/shareable)

**Rationale:** More complex real-world example  
**Rejected because:**

- No governance trail (no ADRs, threat models, runbooks written before)
- Maintenance burden (may not be active or current)
- Harder to establish future precedent (one-off case vs. repeatable pattern)

### 3. Mini-demonstration project (written as part of the exemplar milestone)

**Rationale:** Can be designed specifically to showcase capabilities  
**Rejected because:**

- Artificial scope and constraints (not "real" engineering challenge)
- Harder for reviewers to trust (custom-built vs. lived experience)
- Still requires same documentation effort; no advantage

### 4. Multiple smaller projects in the exemplar milestone

**Rationale:** Faster coverage, more portfolio entries  
**Rejected because:**

- Spreads effort too thin; none get comprehensive documentation
- Harder to establish quality bar (conflicting standards)
- Better to "go deep" on one project, then "scale" in subsequent expansion

## Implementation

**Location:** [Implementation Guide](/docs/00-portfolio/roadmap/phase-2-implementation-guide.md)

**Exemplar deliverables for portfolio-app:**

1. **STEP 2:** Smoke test infrastructure (Playwright) — ~3–5 hours
2. **STEP 3:** Comprehensive project dossier (10 sections) — ~4–6 hours
3. **STEP 4:** Threat model (STRIDE analysis) — ~2–3 hours
4. **STEP 5:** Operational runbooks (deploy, triage, rollback) — ~2–4 hours
5. **STEP 6:** ADR for testing strategy — ~1–2 hours
6. **STEP 7:** Enhanced project detail page (gold standard badge) — ~2–3 hours
7. **STEP 8:** Meaningful CV page (capability-to-proof mapping) — ~2–3 hours
8. **STEP 9:** Release note — ~1–2 hours
9. **STEP 10:** PR creation and end-to-end verification — ~1–2 hours

**Total effort:** ~19–32 hours (2–4 weeks at 10–15 hrs/week)

**Timeline:**

- **Week 1:** STEPS 1–2 (project decision + smoke tests)
- **Week 2:** STEPS 3–5 (dossier + threat model + runbooks)
- **Week 3:** STEPS 6–10 (ADR + CV + project page + release note + validation)

## Success metrics (post-implementation)

After implementation completes, verify:

- ✅ **Coverage:** 100% of core routes accessible; clear evidence trails for each
- ✅ **Clarity:** Each route explains what it proves about engineering discipline
- ✅ **Automation:** Smoke tests validate all core routes on every merge
- ✅ **Credibility:** Senior engineer can validate posture through this one project
- ✅ **Repeatability:** Structure clear enough to repeat for next project without chaos
- ✅ **Linked:** All evidence links resolve (dossier → threat model → ADRs → runbooks → code)

## Related documents

- [Implementation Guide](/docs/00-portfolio/roadmap/phase-2-implementation-guide.md) — step-by-step procedures
- [Foundation Release Notes](/docs/00-portfolio/release-notes/20260117-portfolio-app-phase-1-complete.md) — baseline completion status
- [Portfolio Roadmap](/docs/00-portfolio/roadmap/index.md) — program-level planning
- [ADR-0007: Vercel + Promotion Checks](/docs/10-architecture/adr/adr-0007-portfolio-app-hosting-vercel-with-promotion-checks.md) — deployment decisions
- [ADR-0008: CI Quality Gates](/docs/10-architecture/adr/adr-0008-portfolio-app-ci-quality-gates.md) — CI governance decisions
