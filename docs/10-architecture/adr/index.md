---
title: 'Architecture Decision Records (ADRs)'
description: 'Decision traceability for the portfolio program: why key architectural choices were made, what alternatives were considered, and how decisions are validated and operationalized.'
sidebar_position: 1
tags: [architecture, adr, governance, traceability, decision-making]
---

## Purpose

This section contains **Architecture Decision Records (ADRs)** for the portfolio program and its constituent projects.

ADRs provide durable decision traceability by documenting:

- **Context**: the problem, constraints, and assumptions
- **Decision**: what was chosen
- **Alternatives**: what else was considered and why it was not chosen
- **Consequences**: operational, security, and delivery impacts
- **Validation**: how the decision is proven successful and how regressions are detected

ADRs make the portfolio read like a real engineering organization: decisions are explicit, reviewable, and linked to evidence.

## Scope

### In scope

- technology and platform choices with lasting impact (frameworks, hosting, auth, CI gates)
- changes to trust boundaries, data flows, and integration patterns
- major documentation governance changes (IA, navigation, quality gates)
- security controls with architectural implications

### Out of scope

- minor refactors or changes with no long-term impact
- “how-to” procedures (these belong in runbooks and reference docs)
- security analysis without a concrete system boundary (belongs in threat models)

## Prereqs / Inputs

- ADR author understands:
  - the affected system boundary
  - what alternatives are realistically viable
  - operational and security implications of the decision
- Supporting artifacts may include:
  - architecture overviews (`docs/10-architecture/`)
  - threat models (`docs/40-security/threat-models/`)
  - runbooks (`docs/50-operations/runbooks/`)
  - CI/CD documentation (`docs/30-devops-platform/ci-cd/`)

## Procedure / Content

## How to add a new ADR (standard workflow)

1. **Create a branch**
   - Use a docs branch prefix:
     - `docs/adr-<short-title>`

2. **Pick the next ADR number**
   - Format: `adr-000X-short-title.md`
   - Keep numbers sequential.
   - Do not reuse numbers.

3. **Author using the ADR template**
   - Template location (internal-only):
     - `docs/_meta/templates/template-adr.md`
   - Mandatory expectations:
     - at least 2 alternatives considered (or explicitly justify why not applicable)
     - explicit operational impact and security impact (or "not applicable")

4. **Link to follow-on work**
   - If implementation work is required, document:
     - what must change
     - what must be validated
     - what runbooks/threat models must be created or updated

5. **Validate**
   - `pnpm build` must pass before PR.
   - No links to non-existent pages (use path references until created).

6. **Open a PR**
   - Include:
     - what/why
     - evidence: `pnpm build` passed
     - security note: "No secrets added"

## ADR lifecycle and statuses

Use one of:

- Proposed
- Accepted
- Superseded
- Deprecated

When superseding:

- create a new ADR that references the old one by file name
- update the old ADR status and add a pointer to the new ADR

## ADR quality bar (enterprise expectation)

A high-quality ADR is:

- specific and bounded (one decision per ADR)
- explicit about constraints and assumptions
- honest about tradeoffs
- tied to validation and operational reality
- safe for public consumption (no sensitive config, internal endpoints, or secrets)

## Validation / Expected outcomes

This ADR system is successful when:

- significant decisions are consistently captured as ADRs
- reviewers can trace "why we built it this way" without guesswork
- operational and security consequences are systematically addressed
- ADRs influence actual implementation and governance practices

## Failure modes / Troubleshooting

- **ADR sprawl:** too many trivial ADRs → raise the threshold; keep ADRs for durable decisions.
- **No validation:** decisions become opinion essays → require explicit validation steps and evidence artifacts.
- **Broken references:** ADR links cause build failures → avoid linking to non-existent pages.

## References

- ADR template (internal-only): `docs/_meta/templates/template-adr.md`
- Documentation App ADR examples: `docs/10-architecture/adr/adr-0001-adopt-docusaurus-for-portfolio-docs.md`
- Threat models: `docs/40-security/threat-models/`
- Runbooks: `docs/50-operations/runbooks/`

## Recent ADRs

- [ADR-0018: React2Shell Hardening Baseline](/docs/10-architecture/adr/adr-0018-react2shell-hardening-baseline.md)
- [ADR-0019: Portfolio Docs Hardening Baseline](/docs/10-architecture/adr/adr-0019-portfolio-docs-hardening-baseline.md)
