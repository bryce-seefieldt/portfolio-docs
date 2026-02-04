---
title: 'Project Dossiers'
description: 'Standardized, repeatable project documentation packages for the portfolio app and each demo project, organized for fast review and deep technical validation.'
sidebar_position: 7
tags: [projects, portfolio, demos, documentation, delivery]
---

## Purpose

This section contains project-specific dossiers. Each dossier is a structured package that makes it easy for reviewers to evaluate:

- what the project is and why it exists
- how it is designed (architecture and decisions)
- how it is delivered (build/test/deploy)
- how it is secured (threat model, controls, security testing)
- how it is operated (runbooks, observability, recovery posture)

## Start here (reviewer path)

1. Portfolio App dossier: [/docs/60-projects/portfolio-app/index.md](/docs/60-projects/portfolio-app/index.md)
2. Portfolio Docs App dossier: [/docs/60-projects/portfolio-docs-app/index.md](/docs/60-projects/portfolio-docs-app/index.md)
3. Validate cross-cutting evidence:

- ADRs: [/docs/10-architecture/adr/index.md](/docs/10-architecture/adr/index.md)
- Threat models: [/docs/40-security/threat-models/index.md](/docs/40-security/threat-models/index.md)
- Runbooks: [/docs/50-operations/runbooks/index.md](/docs/50-operations/runbooks/index.md)
- Evidence checklist: [/docs/70-reference/evidence-audit-checklist.md](/docs/70-reference/evidence-audit-checklist.md)

## Scope

### In scope

- dossier-level documentation for:
  - the portfolio web app
  - each linked demo project
- consistent dossier conventions and required pages
- cross-cutting references to architecture/devops/security/ops domains

### Out of scope

- generic standards and policies (belong in top-level domains)
- ad-hoc notes not tied to an identifiable project outcome

## Project dossier contract (mandatory structure)

Every project dossier must include, at minimum, the following pages (names may vary but intent must remain):

- `overview` — purpose, user flows, non-functional requirements
- `architecture` — system shape, major components, key decisions (reference ADRs)
- `deployment` — how it is released and deployed, including rollback posture
- `security` — threat model summary + enforced controls + validation steps
- `testing` — what is tested, how to run, CI gates
- `operations` — runbooks and observability notes (or references to centralized runbooks)
- `troubleshooting` — common failures and fixes

If a project is intentionally minimal, explicitly state what is omitted and why.

## Evidence-first documentation rule

For each claim (performance, security, reliability, DX), include at least one of:

- a reproducible procedure to validate
- an artifact location (scan result summary, configuration evidence, test output)
- an ADR or runbook reference

This keeps dossiers credible and audit-friendly.

## Validation and expected outcomes

A dossier is “complete” when:

- a reviewer can understand the project in 2–5 minutes
- deeper detail exists for architecture/devops/security/ops validation
- build and deployment posture is clear (including rollback)
- security posture is explicitly documented (not implied)

## Failure modes and troubleshooting

- **Dossiers that read like marketing:** add concrete procedures and evidence artifacts.
- **Copy/paste duplicates across projects:** consolidate shared material into domain sections and reference it conceptually.
- **Unbounded growth:** enforce a stable dossier template; keep optional pages clearly labeled.

## References

Project dossiers must align with:

- architecture decisions (`10-architecture/`)
- engineering standards (`20-engineering/`)
- delivery platform (`30-devops-platform/`)
- security posture (`40-security/`)
- operational readiness (`50-operations/`)

Project Dossier Template:

- `docs/_meta/templates/template-project-dossier/`
