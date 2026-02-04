---
title: 'Incident Response'
description: 'Governance and operating model for incidents across portfolio systems: severity, triage, communications, and postmortems.'
sidebar_position: 1
tags: [operations, incident-response, reliability, governance]
---

## Purpose

Define the **incident response governance model** for the portfolio platform. This section sets the minimum operating standard for detecting, triaging, communicating, and learning from incidents.

Incident response is treated as evidence of operational maturity: clear severity definitions, deterministic triage steps, and documented learning loops.

## Scope

### In scope

- severity definitions and escalation rules
- incident lifecycle: detect → triage → contain → recover → review
- communication expectations and update cadence
- postmortem and corrective action standards
- references to runbooks and operational evidence

### Out of scope

- detailed step-by-step procedures (use runbooks)
- architecture rationale (use ADRs)
- security threat enumeration (use threat models)

## Prereqs / Inputs

Incident responders should know:

- which system is affected and which environment(s) are in scope
- where to find logs/health checks for validation
- which runbook to execute for a given failure mode
- how to communicate status updates safely (public-safe only)

## Incident Lifecycle (Governance)

1. **Detect** — alert, report, or health check indicates failure
2. **Triage** — confirm impact and assign severity
3. **Contain** — stop the bleeding (rollback, disable, isolate)
4. **Recover** — restore service and validate health
5. **Review** — document root cause, corrective actions, and follow-ups

## Severity Model (Minimum Standard)

Severity must map to user impact and recovery urgency. Use the severity guidance in the handbook:

- [Incident Response Handbook](/docs/50-operations/incident-response/incident-handbook.md)

## Communications (Minimum Standard)

- **SEV-1/SEV-2:** updates every 5–10 minutes
- **SEV-3:** updates every 15–30 minutes
- **SEV-4:** issue tracker update only

Keep all communications public-safe and avoid sensitive operational detail.

## Required Artifacts

Incidents must reference:

- the executing runbook (for deterministic recovery)
- related ADRs (if the incident exposes a decision gap)
- related threat models (if security-relevant)

## References

- Runbook catalog: [/docs/50-operations/runbooks/index.md](/docs/50-operations/runbooks/index.md)
- Incident handbook: [/docs/50-operations/incident-response/incident-handbook.md](/docs/50-operations/incident-response/incident-handbook.md)
- Postmortem template: [/docs/_meta/templates/template-postmortem.md](/docs/_meta/templates/template-postmortem.md)
- Observability & health checks: [/docs/30-devops-platform/observability-health-checks.md](/docs/30-devops-platform/observability-health-checks.md)
