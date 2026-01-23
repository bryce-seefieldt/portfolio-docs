---
title: 'Portfolio Docs: Operations'
description: 'How the Portfolio Docs App is operated: deploy/rollback posture, maintenance cadence, ownership model, and recovery assumptions.'
sidebar_position: 6
tags: [projects, operations, runbooks, reliability, maintenance]
---

## Purpose

This page documents how to operate the Portfolio Docs App like a production service:

- deploy and rollback expectations
- maintenance workflows (dependency updates, link rot prevention)
- recovery posture (Git as system of record)
- operational ownership model appropriate for a portfolio program

## Scope

### In scope

- operational procedures at a high level
- required runbooks and their minimum content
- maintenance cadence and responsibilities
- recovery and DR assumptions suitable for a static docs platform

### Out of scope

- step-by-step runbook procedures (these should live in `docs/50-operations/runbooks/`)
- vendor-specific hosting details containing sensitive information

## Prereqs / Inputs

- CI/CD exists and can deploy from `main`
- local production build (`pnpm build`) is deterministic
- publication safety policy is enforced

## Procedure / Content

## Operational model

### Service definition

The Portfolio Docs App is a public static documentation site with:

- content stored in Git
- builds producing a static deployable artifact
- hosting publishing the built output

### Ownership

- “Owner” is the portfolio maintainer.
- Operational responsibilities include:
  - ensuring build integrity
  - maintaining navigation consistency
  - preventing sensitive data publication
  - keeping dependencies and platform posture current

## Required runbooks (minimum viable)

Create these runbooks under `docs/50-operations/runbooks/`:

1. Deploy runbook
   - describes how deployment happens (trigger, validation, expected outcome)
2. Rollback runbook
   - describes rollback triggers and how to revert safely
3. Broken-link triage runbook
   - describes how to identify and fix link failures quickly
4. Publication incident runbook (recommended)
   - describes response to accidental sensitive publication

Runbooks must include:

- prerequisites and access requirements
- step-by-step procedure
- validation
- rollback and failure modes

### Existing runbooks (Stage 3.5 — Portfolio App publication governance)

The Portfolio Docs App hosts operational runbooks for the Portfolio App project publication workflow:

- **[Project Publish Runbook](../../50-operations/runbooks/rbk-portfolio-project-publish.md)**: 6-phase procedure for safely publishing new portfolio projects
  - Covers Planning → Registry Entry → Dossier Update → Link Validation → PR/Review → Post-Publish
  - Validation signals: `pnpm registry:validate`, `pnpm links:check`, `pnpm build`
  - Time-boxed: 3 hours total (~30m per phase)
  - Includes rollback and abort procedures

- **[Troubleshooting Guide](../../50-operations/runbooks/rbk-troubleshooting-portfolio-publish.md)**: Diagnostic guide for project-publication failures
  - 5 common failure modes: invalid slugs, broken dossier links, missing evidence URLs, schema validation, CI flakiness
  - Each includes root cause analysis, specific diagnostic commands, and fixes
  - References playwright-report artifacts from CI link-validation job for debugging

## Maintenance cadence (recommended)

### Weekly / bi-weekly

- review dependency update signals (as applicable)
- review open documentation “TBD” items and convert to tracked work
- ensure navigation remains coherent as content expands

### Monthly

- check for link rot (external links) and update where necessary
- refresh governance pages (if any are public) and ensure they reflect reality

### On-demand

- immediately respond to any accidental publication risk (treat as incident)

## Recovery posture (DR/BCP for docs platform)

This is a low-complexity DR model:

- System of record: Git repository
- Recovery method:
  - revert to last known good commit on `main`
  - redeploy from `main`

If hosting fails:

- redeploy to alternative static hosting target using the same build output

## Validation / Expected outcomes

Operations posture is acceptable when:

- deploy and rollback are documented and repeatable
- site can be restored from repository state quickly
- routine maintenance prevents drift (link rot, outdated governance)
- sensitive publication incidents have a defined response path

## Failure modes / Troubleshooting

- **Broken build blocks deploy:** use triage runbook; fix or revert.
- **Navigation becomes inconsistent:** enforce `_category_.json` rule; reorganize with minimal disruption and document changes.
- **Accidental sensitive content published:** remove immediately, revert history as needed, rotate exposed secrets if applicable, and document corrective actions.

## References

- Deployment model: `docs/60-projects/portfolio-docs-app/deployment.md`
- Security posture: `docs/60-projects/portfolio-docs-app/security.md`
- Operations domain: `docs/50-operations/`
- Runbook template (internal-only): `docs/_meta/templates/template-runbook.md`
