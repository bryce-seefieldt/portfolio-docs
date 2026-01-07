---
title: 'Project Dossier: <New Project>'
description: '<Project Description>'
sidebar_position: 0
tags: [projects]
---

## Dossier Contents

- [Overview](01-overview.md)
- [Architecture](02-architecture.md)
- [Deployment](03-deployment.md)
- [Security](04-security.md)
- [Testing](05-testing.md)
- [Operations](06-operations.md)
- [Troubleshooting](07-troubleshooting.md)

## Purpose

## Scope

### In scope

### Out of scope

## Prereqs / Inputs

## Procedure / Content

### Dossier structure (this folder)

### Where supporting enterprise artifacts live

This dossier references and depends on domain-level artifacts:

- ADRs: `docs/10-architecture/adr/`
- Threat models: `docs/40-security/threat-models/`
- Runbooks: `docs/50-operations/runbooks/`
- Pipeline and platform docs: `docs/30-devops-platform/`
- Style and taxonomy (internal-only): `docs/_meta/`

## Validation / Expected outcomes

This dossier is considered “complete enough for first publication” when:

- the dossier pages exist and follow the standard page shape
- the docs site builds successfully (`pnpm build`)
- navigation is coherent:
  - category metadata exists at `docs/60-projects/<new-project>/_category_.json`
  - this hub page is the category landing page
- claims in these pages map to concrete governance/pipeline/security/ops artifacts (even if some artifacts are initially stubbed)

## Failure modes / Troubleshooting

- Dossier pages drift into general policy (belongs in domain sections) → refactor content into the appropriate domain and keep dossier as project-specific summary.
- The dossier becomes marketing-only → add validation procedures and operational/security evidence.
- The dossier references artifacts that do not exist yet → remove links, add path references, and create the missing artifacts via tracked work.

## References

- Project dossier standard: `docs/60-projects/index.md`
- Documentation governance and templates (internal-only): `docs/_meta/`
- Required domain references (create/maintain as needed):
  - ADRs: `docs/10-architecture/adr/`
  - Threat models: `docs/40-security/threat-models/`
  - Runbooks: `docs/50-operations/runbooks/`
  - CI/CD overview: `docs/30-devops-platform/ci-cd/`
