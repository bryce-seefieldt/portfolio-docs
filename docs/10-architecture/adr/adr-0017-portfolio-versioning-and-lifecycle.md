---
title: 'ADR-0017: Portfolio Versioning and Lifecycle Governance'
description: 'Adopt semantic versioning and explicit lifecycle policies for the portfolio program.'
sidebar_position: 17
tags: [adr, architecture, phase-6, governance, versioning, lifecycle]
---

## Problem Statement

The portfolio requires a clear and stable way to signal change scope over time. Without a versioning and lifecycle policy, reviewers cannot quickly interpret the impact of updates, and maintainers lack a consistent rule set for releasing and retiring content.

**Trigger:** Governance work calls for explicit inclusion criteria, deprecation rules, and a versioning strategy that preserves reviewer trust.

---

## Decision

Adopt semantic versioning (SemVer) for the portfolio program and define lifecycle states (active, deprecated, archived) with explicit release note requirements for any material change.

Key points:

- Portfolio releases use `vMAJOR.MINOR.PATCH` tags.
- Major, Minor, and Patch criteria are documented and enforced via release notes.
- Deprecation and archival actions require a release note entry and link integrity checks.

---

## Rationale

- **Reviewer clarity:** SemVer communicates scope and impact quickly.
- **Operational consistency:** Release notes provide audit trails for governance changes.
- **Lifecycle integrity:** Explicit deprecation rules prevent silent removal of evidence.

---

## Consequences

### Positive

- Clear signal for reviewers on portfolio change scope
- Predictable release process with traceable evidence
- Governance decisions are durable and auditable

### Tradeoffs

- Additional documentation overhead for release notes
- Requires discipline to keep versioning consistent

### Operational impact

- Release notes become mandatory for Minor and Major changes
- Link integrity checks required for archival actions

### Security impact

- No additional security exposure; policies reinforce public-safe constraints

---

## Alternatives Considered

1. **Date-based releases**
   - Pros: simple to apply
   - Cons: does not convey change scope
   - Why not chosen: reviewers cannot infer impact from date alone

2. **No formal versioning**
   - Pros: less overhead
   - Cons: inconsistent signals, weak auditability
   - Why not chosen: undermines governance goals for the baseline

---

## Implementation Notes (High-Level)

- Publish versioning and archival policies in `docs/00-portfolio/`.
- Add change intake checklist for governance enforcement.
- Add governance release note and update index links.

---

## Validation / Expected Outcomes

- Versioning rules are documented and applied to new releases.
- Release notes provide clear evidence for governance changes.
- Archival actions preserve link integrity.

---

## Failure Modes / Troubleshooting

- **Version drift:** add release note rationale and correct tags
- **Silent archival:** treat as governance defect and revert

---

## References

- Versioning policy: [/docs/00-portfolio/portfolio-versioning-policy.md](/docs/00-portfolio/portfolio-versioning-policy.md)
- Archival policy: [/docs/00-portfolio/portfolio-archival-policy.md](/docs/00-portfolio/portfolio-archival-policy.md)
- Change intake checklist: [/docs/00-portfolio/portfolio-change-intake.md](/docs/00-portfolio/portfolio-change-intake.md)
