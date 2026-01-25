---
title: 'Runbooks'
description: 'Operational procedures for portfolio systems: deploy, rollback, maintenance, incident response, and deterministic troubleshooting—written for repeatability under pressure.'
sidebar_position: 1
tags: [operations, runbook, reliability, incident-response, governance]
---

## Purpose

This section contains **runbooks**: operational procedures written to be executed reliably under time pressure.

Runbooks demonstrate enterprise operational maturity by ensuring that:

- critical procedures are documented and repeatable
- success criteria and validation are explicit
- rollback and recovery are first-class
- failure modes and troubleshooting are captured systematically

## Scope

### In scope

- deployment and rollback procedures
- incident response playbooks and triage flows
- maintenance operations (dependency updates, planned changes)
- deterministic troubleshooting for common failure modes

### Out of scope

- architecture rationale (belongs in ADRs)
- security threat enumeration (belongs in threat models)
- reference-only command lists (belongs in `70-reference/`)

## Prereqs / Inputs

A runbook author should know:

- what system is affected and which environment(s) are in scope
- what access is required (without publishing sensitive details)
- what “success” looks like and how it is verified
- what constitutes failure and when rollback is required

Supporting artifacts that runbooks should reference (by path):

- project dossier(s): `docs/60-projects/`
- ADRs: `docs/10-architecture/adr/`
- threat models: `docs/40-security/threat-models/`
- CI/CD docs: `docs/30-devops-platform/ci-cd/`

## Procedure / Content

## How to create a runbook

1. **Create a branch**
   - Suggested: `ops/runbook-<system>-<task>`

2. **Create the runbook file**
   - Naming convention:
     - `rbk-<system>-<task>.md`
   - Example:
     - `rbk-docs-deploy.md`

3. **Use the runbook template**
   - Template location (internal-only):
     - `docs/_meta/templates/template-runbook.md`
   - Mandatory sections:
     - prerequisites
     - step-by-step procedure
     - validation
     - rollback / recovery
     - failure modes / troubleshooting

4. **Author for “stressed operator” reality**
   - avoid long prose
   - prefer numbered steps
   - each command includes expected outcome
   - destructive steps use warning/danger admonitions

5. **Validate**
   - where applicable, run the procedure in a safe environment (or simulate locally)
   - run `pnpm build` before PR

6. **Open a PR**
   - include what/why/evidence/no-secrets statement

## Runbook quality bar

A runbook is acceptable only if:

- it can be followed without guessing
- validation steps are concrete (not “looks good”)
- rollback is as explicit as deploy
- it states what to do if prerequisites are not met (stop/escalate)

## Runbook maintenance

Update runbooks when:

- pipeline steps change
- deployment mechanics change
- monitoring/alerts change
- new failure modes are discovered (add to troubleshooting section)

## Validation / Expected outcomes

Operations documentation is effective when:

- deploy and rollback are routine, not heroic
- common failures are fixed quickly with deterministic steps
- PRs include evidence that runbooks remain accurate

## Failure modes / Troubleshooting

- **Runbooks become stale:** treat as a defect; update as part of the change PR.
- **Overly generic runbooks:** add system- and environment-specific validation signals.
- **No rollback:** unacceptable for production-impacting procedures.

## References

- Runbook template (internal-only): `docs/_meta/templates/template-runbook.md`
- Documentation App runbooks:
  - `docs/50-operations/runbooks/rbk-docs-deploy.md`
  - `docs/50-operations/runbooks/rbk-docs-rollback.md`
  - `docs/50-operations/runbooks/rbk-docs-broken-links-triage.md`
- Portfolio App runbooks:
  - `docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md` (Vercel initial setup)
  - `docs/50-operations/runbooks/rbk-portfolio-deploy.md`
  - `docs/50-operations/runbooks/rbk-portfolio-rollback.md`
  - `docs/50-operations/runbooks/rbk-portfolio-ci-triage.md`
  - `docs/50-operations/runbooks/rbk-portfolio-secrets-incident.md` (Phase 2 enhancement: secrets incident response)
  - `docs/50-operations/runbooks/rbk-portfolio-project-publish.md` (Phase 3 Stage 3.5 publish procedure)
  - `docs/50-operations/runbooks/troubleshooting-portfolio-publish.md` (Stage 3.5 troubleshooting guide)
  - `docs/50-operations/runbooks/rbk-portfolio-environment-promotion.md` (Phase 4 Stage 4.1 environment promotion)
  - `docs/50-operations/runbooks/rbk-portfolio-environment-rollback.md` (Phase 4 Stage 4.1 environment rollback)
  - `docs/50-operations/runbooks/rbk-portfolio-performance-optimization.md` (Phase 4 Stage 4.2 performance monitoring & regression triage)
- ADRs: `docs/10-architecture/adr/`
- Threat models: `docs/40-security/threat-models/`
