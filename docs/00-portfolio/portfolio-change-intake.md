---
title: 'Portfolio Change Intake Checklist'
description: 'Governance checklist for adding new portfolio content or making major changes.'
sidebar_position: 9
tags: [portfolio, governance, checklist, change-control]
---

## Purpose

Provide a repeatable intake process that enforces evidence requirements and protects reviewer trust.

## Scope

### In scope

- New projects or case studies
- Major narrative or IA changes
- Governance policy updates

### Out of scope

- Minor typo fixes or formatting changes

## Prereqs / Inputs

- Portfolio eligibility criteria
- Evidence audit checklist
- Roadmap and release notes index

## Intake checklist

### 1) Eligibility and scope

- [ ] Meets eligibility criteria
- [ ] Does not violate explicit exclusions
- [ ] Scope is documented and aligned to roadmap phase

### 2) Evidence minimums

- [ ] Dossier entry updated or created
- [ ] ADR created if decision is durable
- [ ] Threat model updated if trust boundary changes
- [ ] Runbook added if operational procedure changes

### 3) Reviewer impact

- [ ] Reviewer guide updated if new reviewer path is needed
- [ ] Evidence links added or updated
- [ ] Claims are traceable and public-safe

### 4) Release readiness

- [ ] Release note planned or created
- [ ] Versioning policy applied (major/minor/patch)
- [ ] Link integrity verified

## Validation / Expected outcomes

- Changes are intentional, evidence-backed, and reviewer-friendly
- Governance artifacts stay synchronized with implementation

## Failure modes / Troubleshooting

- **Missing evidence:** block merge until artifacts are added
- **Unclear scope:** update roadmap or defer change

## References

- Eligibility criteria: [/docs/00-portfolio/portfolio-eligibility-criteria.md](/docs/00-portfolio/portfolio-eligibility-criteria.md)
- Evidence audit checklist: [/docs/70-reference/evidence-audit-checklist.md](/docs/70-reference/evidence-audit-checklist.md)
- Release notes: [/docs/00-portfolio/release-notes/index.md](/docs/00-portfolio/release-notes/index.md)
