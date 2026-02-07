---
title: 'Portfolio Versioning Policy'
description: 'Semantic versioning rules and release expectations for the portfolio program.'
sidebar_position: 7
tags: [portfolio, governance, policy, versioning, release-notes]
---

## Purpose

Define a stable versioning strategy so reviewers can interpret change scope quickly and consistently.

## Scope

### In scope

- Portfolio-level release tags (vX.Y.Z)
- Release cadence and required artifacts
- Rules for Major, Minor, and Patch changes

### Out of scope

- App or docs package versioning (handled in repo tooling)

## Prereqs / Inputs

- Governance implementation guide
- Release notes index
- ADR-0017 (portfolio versioning and lifecycle)

## Policy

### Versioning model

Use semantic versioning (SemVer): `vMAJOR.MINOR.PATCH`.

### Version bump rules

- **Major:** Material scope changes, IA restructuring, or governance model shifts.
- **Minor:** New project added with full evidence or significant portfolio capability expansion.
- **Patch:** Corrections, link fixes, or documentation clarifications with no new scope.

### Release cadence

- As-needed releases, but no change that meets Minor or Major criteria ships without a release note.
- Patch releases can be bundled if they are purely maintenance.

### Required artifacts per release

- Release note entry in `/docs/00-portfolio/release-notes/`
- Links to evidence artifacts (dossiers, ADRs, runbooks) when affected
- Update to roadmap status if a major milestone is completed

### Tagging guidance

- Tag releases on both `portfolio-app` and `portfolio-docs` when portfolio-wide governance changes occur.
- Use consistent tags (e.g., `v1.1.0`) across repos for reviewer clarity.

## Examples

- **v2.0.0:** major IA restructure or new governance model
- **v1.1.0:** new project with full dossier and runbooks
- **v1.0.1:** link corrections, typo fixes, minor clarifications

## Validation / Expected outcomes

- Reviewers can interpret change scope from the version number
- Release notes remain current and easy to navigate

## Failure modes / Troubleshooting

- **Version drift:** enforce release notes before tagging
- **Ambiguous change scope:** document rationale in release note summary

## References

- Release notes: [/docs/00-portfolio/release-notes/index.md](/docs/00-portfolio/release-notes/index.md)
- Roadmap: [/docs/00-portfolio/roadmap/index.md](/docs/00-portfolio/roadmap/index.md)
- ADR-0017: [/docs/10-architecture/adr/adr-0017-portfolio-versioning-and-lifecycle.md](/docs/10-architecture/adr/adr-0017-portfolio-versioning-and-lifecycle.md)
