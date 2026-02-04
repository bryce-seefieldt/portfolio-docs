---
title: 'Known Limitations'
description: 'Explicit, public-safe constraints and intentional omissions for the portfolio program.'
sidebar_position: 5
tags: [portfolio, limitations, governance, transparency]
---

## Purpose

Document known limitations and intentional omissions to keep expectations clear and reviewer trust high.

## Scope

### In scope

- Portfolio App and Documentation App constraints
- Public-safety limitations
- Deferred features and planned exclusions

### Out of scope

- Private infrastructure details
- Future feature commitments without approved roadmap

## Prereqs / Inputs

- Phase 5 implementation guide
- Current roadmap and release notes

## Procedure / Content

### Product surface limitations

- No authentication or user accounts
- No backend contact form (static contact surface only)
- No private or sensitive content hosted in either app

### Governance and operational constraints

- CI check names must remain stable to preserve rulesets and promotion gating
- Documentation must remain public-safe and non-sensitive

### Evidence model constraints

- All major claims must link to a dossier, ADR, threat model, or runbook
- Evidence must remain current; stale links are treated as defects

### Planned exclusions (intentional)

- CMS integration (deferred; requires ADR + threat model update)
- Analytics beyond privacy-safe instrumentation
- Complex backend services or data stores

## Validation / Expected outcomes

- Reviewers can see what is intentionally omitted
- Documentation and roadmap remain aligned with constraints

## Failure modes / Troubleshooting

- **Limitations unclear:** update this page and cross-link from release notes
- **Scope creep:** add new exclusions or update the roadmap before implementation

## References

- Roadmap: [/docs/00-portfolio/roadmap/index.md](/docs/00-portfolio/roadmap/index.md)
- Release notes: [/docs/00-portfolio/release-notes/index.md](/docs/00-portfolio/release-notes/index.md)
- Phase 5 guide: [/docs/00-portfolio/roadmap/phase-5-implementation-guide.md](/docs/00-portfolio/roadmap/phase-5-implementation-guide.md)
