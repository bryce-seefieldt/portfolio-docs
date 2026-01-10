---
title: 'Threat Model: Portfolio App'
description: 'Threat model for the Portfolio App (Next.js): assets, trust boundaries, entry points, threats, mitigations, and validation aligned to enterprise SDLC controls.'
sidebar_position: 2
tags: [security, threat-model, portfolio-app, web, sdlc, supply-chain]
---

## Purpose

Define an actionable threat model for the **Portfolio App** to guide:

- secure architecture and content decisions
- enforceable SDLC controls in CI/CD
- safe-publication practices
- operational readiness and incident response

This model is written to be public-safe and verifiable.

## Scope

### In scope

- Portfolio App codebase, build chain, CI workflows, and deployment pipeline
- public-facing web surface (no authentication)
- content model (project metadata, evidence links)
- cross-site linking to the Documentation App

### Out of scope

- authentication/session threats (explicitly deferred)
- contact form and backend services (deferred)
- vendor account configuration details and secrets (never documented)

## Prereqs / Inputs

- Owner: portfolio maintainer
- Date: 2026-01-10
- Status: Draft (ready for review)
- Architecture references:
  - Portfolio App dossier: `docs/60-projects/portfolio-app/architecture.md`
  - ADRs: ADR-0005, ADR-0006, ADR-0007
- Operational references:
  - Runbooks: deploy/rollback/CI triage (this set)

## System overview

## Assets to protect

- **Source integrity**: repository content (app code, content metadata, config)
- **Build integrity**: deterministic build artifact from reviewed sources
- **Pipeline integrity**: CI workflows and permissions, dependency supply chain
- **Publication safety**: prevent accidental disclosure of secrets/sensitive info
- **Availability and UX trust**: site must be reliably accessible and correct
- **Reputation and credibility**: portfolio must remain trustworthy and tamper-resistant

## Trust boundaries

- Developer workstation → Git provider (PR)
- PR branch → CI runner (build/test/scan)
- CI output → Vercel deployment pipeline
- Public internet → Portfolio App (read-only access)

Cross-system boundary:

- Portfolio App → Documentation App (links only; no privileged integration)

## Entry points

- GitHub pull requests and commits (primary change vector)
- Dependency updates (Dependabot PRs)
- CI workflow changes (`.github/workflows/*`)
- Build scripts / postinstall hooks (supply chain vector)
- Public web surface:
  - request routing
  - rendered content
  - external embeds (should be minimized)

## Threat analysis

### Threat 1: Dependency / supply chain compromise

- **Scenario**: a compromised dependency executes malicious code during install/build.
- **Impact**: high (tampered build, exfiltration, reputational damage)
- **Likelihood**: medium
- **Mitigations**:
  - pin toolchain (Node/pnpm) and commit lockfile
  - Dependabot with review discipline
  - CodeQL and (optional) dependency auditing in CI
  - minimize dependencies and plugins
- **Validation**:
  - CI uses frozen lockfile install
  - dependency PRs require review + build evidence

### Threat 2: Malicious PR modifies CI or build pipeline

- **Scenario**: PR changes workflows to run untrusted actions or exfiltrate data.
- **Impact**: high
- **Likelihood**: low–medium (depends on collaborator model)
- **Mitigations**:
  - least-privilege workflow permissions
  - review required for workflow changes
  - protect `main` with required checks
- **Validation**:
  - workflow permissions are restricted
  - required checks cannot be bypassed for merge

### Threat 3: Accidental publication of sensitive information

- **Scenario**: secrets, internal endpoints, or sensitive logs get committed or displayed.
- **Impact**: high
- **Likelihood**: medium
- **Mitigations**:
  - explicit “no secrets” policy with PR checklist statement
  - secrets scanning (phase 2 recommended)
  - avoid embedding internal screenshots/logs in public content
- **Validation**:
  - PRs include “No secrets added”
  - postmortem procedure exists for suspected publication

### Threat 4: Content injection via unsafe rendering / MDX misuse

- **Scenario**: untrusted HTML/MDX leads to XSS or unsafe client behavior.
- **Impact**: medium–high
- **Likelihood**: low (if Markdown-first and MDX minimized)
- **Mitigations**:
  - treat MDX as code; restrict and review carefully
  - avoid `dangerouslySetInnerHTML`
  - avoid untrusted third-party embeds
- **Validation**:
  - code review policy flags MDX/component changes
  - CSP/hardening considered where practical

### Threat 5: Route/base path misconfiguration breaks availability or trust

- **Scenario**: deployment config causes 404s, broken assets, or mismatched docs links.
- **Impact**: medium
- **Likelihood**: medium
- **Mitigations**:
  - PR previews + production promotion checks
  - explicit runbooks for deploy/rollback
  - treat base path changes as breaking changes requiring ADR + release notes
- **Validation**:
  - preview validated before merge
  - promotion gated by `ci / quality` and `ci / build`

### Threat 6: Availability risks from excessive client payload or regressions

- **Scenario**: performance regression degrades UX and credibility.
- **Impact**: medium
- **Likelihood**: medium
- **Mitigations**:
  - performance budget mindset (lightweight UI)
  - basic e2e smoke tests (phase 3)
  - measured rollout via previews; rollback readiness
- **Validation**:
  - spot-check core routes
  - add performance checks later if warranted

## Mitigation plan and enforceable SDLC controls

### Minimum enforceable controls (Phase 1)

- PR-only merges to `main`
- CI checks required:
  - lint + format check + typecheck
  - build
- Vercel production promotion gated on imported checks
- Dependabot enabled; dependency PR review required
- No secrets policy with explicit PR checklist line item

### Recommended Phase 2 controls

- secrets scanning gate (CI)
- dependency auditing (CI) for high-severity advisories
- e2e smoke tests for key routes

## Residual risk

- Supply chain risk remains non-zero.
- Public sites always face reputational risk from errors/regressions.
- Mitigation is continuous: disciplined updates, scanning, and rollback readiness.

## Validation / Expected outcomes

- CI blocks unsafe or broken changes from merging
- production promotion is gated by checks
- no sensitive data is published
- runbooks and postmortem process are usable under pressure

## Failure modes / Troubleshooting

- If sensitive publication suspected:
  - revert immediately
  - rotate secrets if applicable
  - write a postmortem with corrective actions
- If promotion blocked:
  - follow CI triage runbook; fix forward or rollback

## References

- Portfolio App dossier:
  - `docs/60-projects/portfolio-app/security.md`
  - `docs/60-projects/portfolio-app/deployment.md`
- ADRs:
  - `docs/10-architecture/adr/adr-0005-portfolio-app-stack-nextjs-ts.md`
  - `docs/10-architecture/adr/adr-0006-separate-portfolio-app-from-evidence-engine-docs.md`
  - `docs/10-architecture/adr/adr-0007-portfolio-app-hosting-vercel-with-promotion-checks.md`
- Runbooks:
  - `docs/50-operations/runbooks/rbk-portfolio-deploy.md`
  - `docs/50-operations/runbooks/rbk-portfolio-rollback.md`
  - `docs/50-operations/runbooks/rbk-portfolio-ci-triage.md`
