---
title: 'Portfolio App: Operations'
description: 'Operational posture for the Portfolio App: deploy/rollback expectations, maintenance cadence, and recovery assumptions for a public portfolio service.'
sidebar_position: 6
tags: [projects, operations, runbooks, reliability, maintenance, portfolio]
---

## Purpose

Document how the Portfolio App is operated like a production service:

- deploy/rollback readiness
- maintenance and dependency update discipline
- recovery posture (Git as system of record)
- operational credibility for reviewers

## Scope

### In scope

- required runbooks and minimum content
- maintenance cadence
- recovery posture and DR assumptions
- operational ownership model

### Out of scope

- vendor-specific account details
- incident postmortems (separate artifact type)

## Prereqs / Inputs

- CI/CD exists and deploys from `main`
- Vercel preview/prod deployments are functioning
- quality gates are enforced in CI and (optionally) promotion checks

## Procedure / Content

## Operational model

### Service definition

The Portfolio App is a public web application hosted on Vercel, deployed from GitHub with PR governance.

### Ownership

Owner: portfolio maintainer.
Responsibilities:

- keep build and deploy deterministic
- maintain evidence links and documentation integrity
- keep dependencies current and safe
- respond to regressions promptly with rollback capability

### Release gates (CI)

- CI is a hard release gate. Merges and promotions must not proceed if required checks fail.
- Required checks (by contract): `ci / quality`, `ci / build`.
- Quality runs `pnpm lint`, `pnpm format:check`, `pnpm typecheck`; Build runs `pnpm build` with frozen lockfile installs.
- If CI fails: follow the CI triage runbook: [docs/50-operations/runbooks/rbk-portfolio-ci-triage.md](docs/50-operations/runbooks/rbk-portfolio-ci-triage.md).

## Required runbooks (minimum viable)

Create under `docs/50-operations/runbooks/`:

1. **Deploy Portfolio App**
   - trigger (merge to `main`)
   - validation steps (routes, critical pages)
   - promotion checks verification

2. **Rollback Portfolio App**
   - rollback triggers
   - revert procedure
   - production validation

3. **Build/CI triage**
   - quality gate failures (lint/format/typecheck)
   - build failures

- required-checks missing/not selectable in ruleset → ensure checks exist and have executed recently on PRs and on pushes to `main`
- runbook: [docs/50-operations/runbooks/rbk-portfolio-ci-triage.md](docs/50-operations/runbooks/rbk-portfolio-ci-triage.md)

4. **Publication incident response (recommended)**
   - accidental publication of sensitive info
   - immediate containment and recovery

## Maintenance cadence (recommended)

### Weekly / bi-weekly

- review Dependabot PRs and merge with validation evidence
- verify a subset of key routes and `/docs` links remain correct
- update “in progress” project pages and evidence links

### Monthly

- review site performance and accessibility basics
- verify security posture assumptions remain accurate
- refresh any “proof links” to avoid drift

## Recovery posture (DR assumptions)

- Git repository is the system of record.
- Recovery mechanism:
  - revert to last known good commit on `main`
  - redeploy
- Hosting fallback:
  - if hosting failure occurs, redeploy to alternative target (document if adopted)

## Validation / Expected outcomes

- deploy and rollback are documented and repeatable
- regressions are addressed via deterministic procedures
- dependency posture remains current and reviewable
- documentation remains aligned with reality

## Failure modes / Troubleshooting

- broken `/docs` evidence links:
  - treat as regression; fix and document in release notes if material
- repeated CI failures:
  - adjust developer workflow; enforce format and lint pre-commit if beneficial
- production routing issues:
  - rollback quickly; document root cause and corrective actions

## Branch governance and promotion discipline

- Ruleset: `main-protection` (update name here if your org uses a different ruleset identifier).
- Enforces:
  - PRs required to merge to `main` (no direct pushes)
  - required checks must pass: `ci / quality`, `ci / build`
  - no force-push to `main`
  - prevent branch deletion
- Why it exists:
  - reproducibility (deterministic, verifiable releases)
  - auditability (traceable PR evidence and checks)
  - safety (prevents accidental/promiscuous promotion to production)

## References

- Deployment dossier: `docs/60-projects/portfolio-app/deployment.md`
- Testing dossier: `docs/60-projects/portfolio-app/testing.md`
- Runbooks index: [docs/50-operations/runbooks/index.md](docs/50-operations/runbooks/index.md)
- CI triage runbook: [docs/50-operations/runbooks/rbk-portfolio-ci-triage.md](docs/50-operations/runbooks/rbk-portfolio-ci-triage.md)
- Postmortem template (internal-only): `docs/_meta/templates/template-postmortem.md`
