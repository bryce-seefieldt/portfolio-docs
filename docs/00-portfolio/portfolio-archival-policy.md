---
title: 'Portfolio Archival Policy'
description: 'Rules for deprecating and archiving portfolio content while preserving evidence integrity.'
sidebar_position: 8
tags: [portfolio, governance, policy, archival, lifecycle]
---

## Purpose

Define how portfolio content is deprecated and archived without breaking reviewer trust or evidence links.

## Scope

### In scope

- Project deprecation and archival
- Retiring documentation that is no longer representative
- Redirects and link integrity requirements

### Out of scope

- Deleting content without review
- Removing evidence artifacts that are still referenced

## Prereqs / Inputs

- Portfolio versioning policy
- Change intake checklist
- Archival runbook

## Policy

### Lifecycle states

- **Active:** Current, supported, and representative
- **Deprecated:** Still accessible but no longer actively updated
- **Archived:** Retired content preserved for historical traceability

### Deprecation triggers

- Project no longer represents current capabilities
- Evidence artifacts are incomplete or cannot be maintained
- Governance or scope changes make the content misleading

### Archival rules

- Archived content must remain accessible and linked
- Do not remove evidence referenced in release notes or dossiers
- Update indices to reflect archived status
- Add a release note entry when archiving is material

### Link integrity requirements

- No broken internal links after archival
- Use explicit archival notes instead of deleting pages

## Validation / Expected outcomes

- Reviewer trust is preserved through transparency
- Evidence remains traceable even for archived work

## Failure modes / Troubleshooting

- **Broken links:** add archival notes and update indexes before merge
- **Silent removal:** treat as a governance defect and revert

## References

- Portfolio versioning policy: [/docs/00-portfolio/portfolio-versioning-policy.md](/docs/00-portfolio/portfolio-versioning-policy.md)
- Change intake checklist: [/docs/00-portfolio/portfolio-change-intake.md](/docs/00-portfolio/portfolio-change-intake.md)
- Archival runbook: [/docs/50-operations/runbooks/rbk-portfolio-archival.md](/docs/50-operations/runbooks/rbk-portfolio-archival.md)
