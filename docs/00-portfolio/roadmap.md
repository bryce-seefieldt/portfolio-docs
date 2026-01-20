---
title: 'Portfolio Web Application Roadmap'
description: 'Enterprise-style roadmap for building the Portfolio App (Next.js/TypeScript) and its supporting evidence ecosystem (Docusaurus), with phased deliverables and governance artifacts.'
sidebar_position: 1
tags:
  [
    portfolio,
    roadmap,
    planning,
    nextjs,
    typescript,
    documentation,
    devops,
    security,
    operations,
  ]
---

## Purpose

This roadmap defines the **Portfolio Program** execution plan, centered on a high-grade **Portfolio App** (Next.js + TypeScript) and supported by the **Portfolio Documentation App** (Docusaurus) as the enterprise evidence engine.

It is written to:

- provide a realistic, staged delivery plan that produces reviewer-visible value early
- enforce an enterprise SDLC posture (docs-as-code, CI gates, traceability)
- define what artifacts must exist at each phase (dossiers, ADRs, threat models, runbooks, release notes)
- guide ongoing planning and implementation through a repeatable workflow

## Scope

### In scope

- Portfolio App product roadmap (features, IA, and UX)
- Documentation/Evidence roadmap (dossiers and enterprise artifacts)
- CI/CD and release governance roadmap
- Security and operational maturity roadmap

### Out of scope

- staffing models, budgets, or vendor procurement
- authentication and backend-heavy services (explicitly deferred early)

## Guiding principles

1. **Evidence-first delivery**
   - Every meaningful capability must have accompanying evidence artifacts (docs + governance).
2. **Small, high-quality increments**
   - Avoid broad refactors and large coupled changes.
3. **No broken links / no stale docs**
   - Builds fail on broken integrity conditions; fixes are required.
4. **Public-safe by design**
   - No secrets, internal endpoints, or sensitive operational detail leakage.
5. **Git is the system of record**
   - Release, rollback, and recovery center on traceable Git history and PR discipline.

## Program components

### A) Portfolio App (front-of-house)

A TypeScript-based web application that serves as:

- interactive CV
- curated project showcase
- entry point into enterprise evidence (links into docs app)

### B) Portfolio Documentation App (evidence engine)

A Docusaurus documentation platform that hosts:

- project dossiers
- ADRs
- threat models
- runbooks
- postmortems (when needed)
- release notes and governance policies

## Planning workflow (how this roadmap is executed)

For each phase or milestone:

1. **Create/Update plan docs first**
   - roadmap updates (this doc)
   - dossier updates for affected project
2. **Record major decisions**
   - ADRs for durable architectural or governance changes
3. **Assess security impact**
   - update threat model(s) if trust boundaries or entry points change
4. **Update operations readiness**
   - runbooks updated for deploy/rollback/triage changes
5. **Implement**
   - code changes via PR with CI gates
6. **Release + evidence**
   - release notes + links to PRs and deployed preview evidence

---

## Roadmap at-a-glance (phases)

- **Phase 0:** Baseline governance + evidence scaffolding (Docs App hardened)
- **Phase 1:** Portfolio App foundation (repo, CI, deployment, core routes)
- **Phase 2:** “Gold standard” content (one exemplary project + deep evidence)
- **Phase 3:** Scaling content model (repeatable project publishing pipeline)
- **Phase 4:** Reliability + security hardening (enterprise credibility upgrades)
- **Phase 5:** Advanced demonstrations (multi-language demos, platform proofs, eval-first artifacts)

Each phase includes:

- product deliverables
- evidence artifacts required
- acceptance criteria (“Definition of Done”)

---

## Phase 0 — Governance and evidence platform readiness (Docs App)

### Objective

Ensure the Documentation App is a credible enterprise evidence engine with strong SDLC controls and operational posture.

### Deliverables

- Docusaurus docs platform deployed publicly (Vercel) with preview + production
- CI gates enforced:
  - build integrity (broken links fail)
  - quality gates for docs app code/config (lint/format/typecheck if applicable)
- Deployment promotion gated by required GitHub checks
- Templates and internal governance (`docs/_meta/`) established and non-public

### Required evidence artifacts

- ADRs (already established for docs platform choices)
- Documentation App threat model
- Runbooks: deploy, rollback, broken link triage
- Postmortem template available

### Acceptance criteria

- `pnpm build` passes locally and in CI deterministically
- production promotion is blocked until checks pass
- runbooks exist and match real deployment behavior
- docs IA is stable and navigable with curated hubs

---

## Phase 1 — Portfolio App foundation (production-quality skeleton)

### Objective

Stand up the Portfolio App with enterprise-grade SDLC controls and a minimal, polished surface.

### Deliverables (Portfolio App repo)

- Next.js (App Router) + TypeScript app bootstrapped using pnpm
- Core routes (MVP):
  - `/` (landing)
  - `/cv` (interactive CV scaffold)
  - `/projects` (project index scaffold)
  - `/projects/[slug]` (project detail scaffold)
- Tooling and governance:
  - ESLint + Prettier + TypeScript `typecheck`
  - GitHub Actions workflows:
    - `ci / quality` (lint, format:check, typecheck)
    - `ci / build` (Next build)
    - CodeQL
  - Dependabot
- Vercel deployment:
  - preview deployments for PRs
  - production deployment from `main`
  - production promotion gated by checks

### Required evidence artifacts (Docs App)

- Portfolio App dossier (8 pages) — complete first-pass
- ADRs:
  - ADR-0005 stack choice
  - ADR-0006 evidence separation
  - ADR-0007 hosting/promotion checks
- Threat model:
  - `portfolio-app-threat-model.md`
- Runbooks:
  - deploy, rollback, CI triage for Portfolio App

### Acceptance criteria

- Portfolio App can be deployed and validated end-to-end with preview-to-prod governance
- CI gates are enforceable and stable (check names consistent)
- Routes render in preview and production
- Portfolio App pages include correct evidence-link placeholders to docs

---

## Phase 2 — “Gold standard” project and credibility baseline

### Objective

Create one exemplary project case study that sets the standard for all future portfolio entries.

### Deliverables (Portfolio App)

- 1 fully polished “gold standard” project page:
  - crisp summary (what it is, what it proves)
  - repo/demo links
  - evidence links to dossier, threat model, runbooks as applicable
  - screenshots/diagrams (public-safe)
- CV page becomes meaningful:
  - employment/impact timeline entries
  - capability-to-proof mapping (links to projects and evidence)

### Required evidence artifacts (Docs App)

- Project dossier for the chosen “gold standard” project:
  - overview, architecture, deployment, security, testing, operations, troubleshooting
  - dossier contract: 7 standard pages; Step 3 enhances these pages rather than creating a single monolithic document
- At least 1 ADR for a durable decision in that project
- Threat model (if project introduces meaningful surface)
- Runbooks (if project is deployed/operated)
- Release note entry recording the milestone

### Acceptance criteria

- A reviewer can validate senior-level engineering discipline through a single project:
  - “what, why, how”
  - security posture
  - operational readiness
  - reproducibility

### Phase 2 Recommended Controls (Hardening Enhancements)

Beyond baseline Phase 1, Phase 2 includes optional hardening controls that strengthen enterprise security posture:

#### Security Enhancements

1. **Secrets Scanning Gate (TruffleHog CI)**
   - Detect hardcoded secrets before merge
   - CI job: `secrets-scan` (required check)
   - Local hook: `pnpm secrets:scan`
   - Threat model alignment: Information Disclosure (T1) mitigation

2. **CI Permission Hardening (Least-Privilege)**
   - Replace global `permissions: contents: write` with job-specific permissions
   - Quality job: `contents: write`, `pull-requests: read` (Dependabot auto-format)
   - Build job: `contents: read` (read-only)
   - Threat model alignment: Tampering (T2), Elevation of Privilege (E1) mitigations

3. **Pre-commit Hooks (Local Secret Scanning)**
   - `.pre-commit-config.yaml`: TruffleHog hook for local commits
   - Setup: `pre-commit install` (one-time)
   - Threat model alignment: Information Disclosure (T1) prevention

#### Operational Enhancements

4. **Secrets Incident Response Runbook**
   - New: `rbk-portfolio-secrets-incident.md`
   - 5-phase procedure: Triage → Contain → Investigate → Remediate → Validate
   - Severity levels: Critical (≤5 min), High (≤30 min), Medium (≤2 hrs)
   - Threat model alignment: Incident Response procedures

5. **STRIDE Compliance Report**
   - New: `portfolio-app-stride-compliance-report.md`
   - Executive summary of all 12 threat mitigations
   - Control evidence mapping to source code and runbooks
   - Phase 2 enhancements documented and verified

#### Evidence Artifacts

- **CI Workflow:** `.github/workflows/ci.yml` (secrets-scan job + scoped permissions)
- **Local Scanning:** `.pre-commit-config.yaml` (TruffleHog hook)
- **Package Script:** `package.json` (`secrets:scan` script)
- **Incident Response:** `rbk-portfolio-secrets-incident.md` (complete runbook)
- **Compliance Report:** `portfolio-app-stride-compliance-report.md` (audit)

#### Implementation Status

- ✅ All Phase 2 recommended controls implemented (as of 2026-01-19)
- ✅ CI workflow updated with secrets scanning gate
- ✅ Permissions hardened to least-privilege per job
- ✅ Pre-commit hooks configured for local scanning
- ✅ Incident response runbook created
- ✅ STRIDE compliance report generated
- ✅ All controls integrated into PR workflow

## See [Phase 2 Implementation Guide — STEP 4a/4b](/docs/00-portfolio/phase-2-implementation-guide.md#step-4a-phase-2-security-enhancements-hardening-controls-23-hours) for detailed procedures.

## Phase 3 — Repeatable project publishing pipeline (scale without chaos)

### Objective

Make adding projects predictable, low-friction, and consistent with governance.

### Deliverables (Portfolio App)

- Data-driven project registry:
  - structured metadata (title, slug, tech, proofs, links)
  - consistent slug rules enforced by validation
- Project page template enhancements:
  - “evidence block” component that standardizes links
  - optional “verification badges” (e.g., Build Passing, Docs Available)
- Quality improvements:
  - add unit tests (Vitest) for content/slug validation
  - optionally add basic Playwright e2e smoke tests for core routes

### Required evidence artifacts (Docs App)

- Update Portfolio App dossier architecture and testing pages to reflect new model
- Runbook updates for publish/maintenance process
- ADR if content model changes materially (e.g., moving to MDX, CMS, or remote data)

### Acceptance criteria

- Adding a new project is a repeatable checklist:
  - add metadata + assets + evidence links
  - create dossier folder and pages
  - update release notes
- CI catches broken slugs/routes and basic regressions

---

## Phase 4 — Reliability, performance, and security hardening (enterprise maturity)

### Objective

Elevate the program from “professional” to “enterprise-grade,” with documented controls and verifiable posture.

### Deliverables (Portfolio App)

- Performance/accessibility hardening:
  - accessibility review and fixes on core routes
  - performance budget mindset; minimize client JS
- Security hardening:
  - refined headers posture (where appropriate)
  - secrets scanning gate (phase-in)
  - dependency audit policy improvements (phase-in)
- Operational maturity:
  - improved alerting/monitoring strategy (lightweight, public-safe)
  - more deterministic rollback guidance

### Required evidence artifacts (Docs App)

- Update Portfolio App threat model with new controls and residual risks
- Add runbooks for:
  - dependency vulnerability response
  - suspected sensitive publication incident response (if not already)
- Postmortem process exercised if an incident occurs
- ADR(s) for major hardening changes that affect architecture or governance

### Acceptance criteria

- Demonstrable controls beyond basics:
  - scanning
  - audited release process
  - mature incident handling documentation
- Operational readiness is credible and not aspirational

---

## Phase 5 — Advanced demonstrations and multi-language portfolio expansion

### Objective

Show depth and breadth across languages and disciplines while maintaining enterprise consistency.

### Deliverables

- Multiple projects across domains:
  - Python (automation, data, AI engineering, or platform tooling)
  - Java/C++ (systems or performance projects)
  - DevOps/SRE demonstrations (GitOps, DR/BCP, IaC, policy as code)
- Each project adheres to the same evidence standard:
  - dossier + ADR(s) + threat model (when relevant) + runbooks (when deployed)
- Portfolio App enhances discovery:
  - filtering/sorting projects by capability and proof type
  - “verification-first” display patterns

### Required evidence artifacts

- Project dossiers per project
- ADRs for significant cross-cutting platform decisions
- Security/ops artifacts scaled appropriately to each project

### Acceptance criteria

- The portfolio reads like a cohesive program, not a collection of unrelated demos.
- Evidence remains current and traceable across the entire system.

---

## Backlog (candidate enhancements)

These are explicitly not required to reach “enterprise credible,” but can be added when justified by value and governed by ADR:

- contact form (adds abuse surface → requires threat model update + runbooks)
- authentication (deferred; high governance overhead)
- content CMS integration (requires careful boundary and supply chain analysis)
- analytics instrumentation (must remain privacy-respecting and public-safe)
- automated link checking between Portfolio App and Docs App (optional gate)

---

## Governance: Definition of Done for roadmap milestones

A milestone is complete only when:

- Code is deployed and accessible in production
- CI checks are green and required checks are enforced
- Documentation updates are complete:
  - dossier updated
  - ADR(s) created/updated for durable decisions
  - threat model updated if surface changes
  - runbooks updated if operational procedures change
- Release notes entry exists for material changes
- Public-safety requirements are satisfied (“No secrets added”)

---

## References

- Portfolio App dossier: `docs/60-projects/portfolio-app/`
- Documentation App dossier: `docs/60-projects/portfolio-docs-app/`
- ADR index: `docs/10-architecture/adr/`
- Threat models index: `docs/40-security/threat-models/`
- Runbooks index: `docs/50-operations/runbooks/`
- Templates (internal-only): `docs/_meta/templates/`
