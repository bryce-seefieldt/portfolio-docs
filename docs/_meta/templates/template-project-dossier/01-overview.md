---
title: '<New Project>: Overview'
description: '<Project Overview Description>'
sidebar_position: 1
collapsible: true
collapsed: true
tags: [projects]
---

## Purpose

It answers:

- What is this system?
- Why is it built this way?
- What outcomes are required to claim “enterprise-grade”?
- What evidence artifacts must exist to support those claims?

## Scope

### In scope

- product framing and success criteria
- non-functional requirements (NFRs)
- quality and governance expectations
- evidence map (what artifacts should exist and where)

### Out of scope

- detailed configuration (covered in `architecture.md` and `deployment.md`)
- security threat enumeration (covered in `security.md`)

## Prereqs / Inputs

- Project scaffolded and runnable locally (`pnpm start`)
- Root docs landing page exists (`docs/index.md`)
- Portfolio domain exists and is categorized (`docs/00-portfolio/`)
- Projects domain exists (`docs/60-projects/`) with category metadata

## Procedure / Content

## System definition

### Why

## Success criteria

### Minimum viable enterprise outcomes

### Non-functional requirements (NFRs)

## Evidence map (what must exist)

Should eventually be supported by these artifacts:

- ADRs (architecture decisions)
  - example topics: Docusaurus choice, nav strategy, hosting strategy, quality gates
  - location: `docs/10-architecture/adr/`

- Threat model (docs platform threat surface)
  - location: `docs/40-security/threat-models/`

- Runbooks (operations)
  - deploy, rollback, broken-link triage
  - location: `docs/50-operations/runbooks/`

- Pipeline overview and quality gates
  - location: `docs/30-devops-platform/ci-cd/`

- Release notes for the documentation system
  - location: `docs/00-portfolio/release-notes/`

## Validation / Expected outcomes

At a minimum:

## Failure modes / Troubleshooting

## References

- Dossier hub: `docs/60-projects/<new-project>/index.md`
- Style and taxonomy (internal-only): `docs/_meta/doc-style-guide.md`, `docs/_meta/taxonomy-and-tagging.md`
- Core navigation entry: `docs/index.md`
