---
title: "Threat Models"
description: "Actionable threat models for portfolio systems: assets, trust boundaries, entry points, risks, mitigations, and validation procedures aligned to secure SDLC controls."
sidebar_position: 1
tags: [security, threat-model, sdlc, governance, risk-management]
---

## Purpose

This section contains **threat models** for the portfolio program’s systems (documentation platform, portfolio app, demo services, CI/CD pipeline surfaces, and integrations).

Threat models are used to:

- identify assets and trust boundaries
- enumerate realistic attack scenarios
- define **enforceable controls** (preferably automated in CI/CD)
- define validation procedures and evidence expectations
- drive operational readiness (monitoring, incident response, runbooks)

Threat models are a cornerstone of demonstrating enterprise-grade security discipline in a public portfolio.

## Scope

### In scope
- system-specific threat models (one model per system boundary)
- security controls tied to architecture and pipeline gates
- mitigations with validation steps and evidence expectations
- residual risk statements and review cadence

### Out of scope
- generic security advice not tied to a concrete system
- operational “how-to” procedures (belongs in runbooks)
- incident retrospectives (belongs in postmortems)

## Prereqs / Inputs

To create or update a threat model, you should have:

- a defined system boundary (what is in scope/out of scope)
- at least one architecture overview or ADR relevant to the system
- a basic understanding of:
  - authentication and identity flows (if applicable)
  - data flows and storage (even if minimal)
  - deployment model and CI pipeline behavior

Recommended supporting artifacts:
- ADRs: `docs/10-architecture/adr/`
- Ops runbooks: `docs/50-operations/runbooks/`
- DevOps platform docs: `docs/30-devops-platform/`

## Procedure / Content

## How to create a new threat model

1. **Create a branch**
   - Suggested: `docs/threat-model-<system>`

2. **Create the model file**
   - Naming convention:
     - `<system>-threat-model.md`
   - Location:
     - `docs/40-security/threat-models/`

3. **Author using the threat model template**
   - Template location (internal-only):
     - `docs/_meta/templates/template-threat-model.md`
   - Requirements:
     - assets, trust boundaries, and entry points are explicit
     - each threat includes mitigations and validation steps
     - define enforceable SDLC controls (prefer CI gates) where applicable

4. **Add references**
   - Reference relevant ADRs and runbooks by path (avoid links to non-existent pages)

5. **Validate**
   - `pnpm build` must pass prior to PR
   - ensure the model is public-safe (no sensitive endpoints, no secrets)

6. **Open PR**
   - include what/why/evidence/no-secrets statement

## Threat model review and maintenance

### When to update
Update the relevant model when:
- trust boundaries change (new integrations, new hosting posture)
- auth/session behavior changes
- new data flows or storage are introduced
- CI permissions or build chain changes materially
- new externally reachable entry points are added

### Residual risk discipline
Every model must include:
- explicit residual risk statements (or “none identified”)
- a review cadence (e.g., quarterly or on major changes)

## Validation / Expected outcomes

Threat modeling is effective when:
- security controls are not merely described but **enforced**
- validation steps are reproducible
- changes to system boundaries trigger corresponding updates
- operational readiness improves (alerts/runbooks exist for key failure modes)

## Failure modes / Troubleshooting

- **Checklist theater:** threats listed without mitigations or validation → require enforceable controls and evidence expectations.
- **Overly theoretical:** risks not tied to entry points/assets → reframe around concrete scenarios.
- **Sensitive detail leakage:** internal endpoints or logs included → sanitize, summarize, and remove sensitive details.

## References

- Threat model template (internal-only): `docs/_meta/templates/template-threat-model.md`
- Documentation App threat model: `docs/40-security/threat-models/portfolio-docs-app-threat-model.md`
- Related domain artifacts:
  - ADRs: `docs/10-architecture/adr/`
  - Runbooks: `docs/50-operations/runbooks/`
