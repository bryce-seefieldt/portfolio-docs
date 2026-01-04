---
title: "Template: Threat Model"
description: "Threat model template aligned to practical secure SDLC: assets, entry points, trust boundaries, threats, mitigations, and validation."
tags: [meta, template, security, threat-model, sdlc]
---
# Template: Threat Model
## Purpose

Use this template to capture a practical threat model that supports:
- secure architecture decisions
- enforceable SDLC controls
- security testing and validation
- incident readiness and monitoring

Threat models must drive action, not just documentation.

## Scope

### Use when
- introducing/changing authentication, sessions, or identity flows
- integrating third-party services or external APIs
- changing data storage or data flows
- changing deployment environment or edge controls (headers, CDN rules)

### Do not use when
- documenting generic security guidance unrelated to a concrete system boundary

## Prereqs / Inputs

- System / component:
- Owner:
- Date:
- Status: Draft | Reviewed | Approved
- Architecture references (file names / sections):
- Known constraints:

## System overview

### Assets to protect
List assets explicitly (examples):
- user identity/session tokens
- source code integrity
- build pipeline integrity
- configuration integrity
- availability and uptime
- any stored data (even if minimal)

### Trust boundaries
Describe where trust changes. Examples:
- browser → edge/CDN → app runtime
- app runtime → third-party API
- CI runner → artifact registry → deployment target

### Entry points
List entry points:
- web routes and APIs
- webhook endpoints
- authentication endpoints
- admin/config endpoints
- build/deploy triggers

## Threat analysis

Use a simple STRIDE-like structure (or your preferred structure) but keep it actionable.

For each threat:
- Threat:
- Asset impacted:
- Attack scenario:
- Impact:
- Likelihood:
- Existing mitigations:
- Gaps:
- Required controls:
- Validation steps:

Example structure:

### Threat 1: <short name>
- **Threat:**  
- **Asset impacted:**  
- **Scenario:**  
- **Impact:**  
- **Likelihood:**  
- **Mitigations:**  
- **Gaps:**  
- **Controls required:**  
- **Validation:**  

Repeat for all meaningful threats.

## Mitigation plan and SDLC controls

### Enforceable controls
List controls that should be automated or required:
- code review requirements
- dependency scanning rules
- secrets detection policy
- build integrity / provenance expectations
- security headers configuration
- auth/session hardening expectations

### Residual risk
State any accepted risks and the justification:
- Risk:
- Why accepted:
- Mitigation/monitoring:
- Review date:

## Validation / Expected outcomes

- How to validate controls exist and work:
- What evidence artifacts should be produced:
- What alerts/monitoring should exist (public-safe description):

## Failure modes / Troubleshooting

- Control failure symptoms:
- How to detect:
- What to do immediately:
- Escalation path (public-safe):

## References

- Related ADRs (by file name):
- Related runbooks (by file name):
- Related security testing notes (by file name):