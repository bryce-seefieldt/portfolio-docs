---
title: "Operations, Runbooks, Incident Response, and DR/BCP"
description: "Operational procedures that treat the portfolio web app as a real service: runbooks, incident management, service ownership, and recovery planning."
sidebar_position: 6
tags: [operations, runbooks, incident-response, drbcp, reliability]
---

## Purpose

This section documents how the portfolio web app (and demos) are operated in a production-like manner. The goal is to demonstrate that you can **run** software, not just build it.

It includes:
- runbooks (deploy/rollback/triage/config changes)
- incident response practices and postmortems
- DR/BCP planning aligned to service impact
- operational checklists and validation steps

## Scope

### In scope
- runbooks with prerequisites, step-by-step procedures, validation, rollback
- incident response model: severity, comms, triage, escalation
- postmortem template and expectations (blameless, corrective actions)
- DR/BCP service impact analysis, RTO/RPO targets, recovery playbooks
- operational ownership: who does what, and where responsibilities live

### Out of scope
- CI/CD implementation detail (belongs in `30-devops-platform/`)
- threat model details (belongs in `40-security/`) except as operational references

## Runbook standards (mandatory format)

Every runbook must contain:
1. Purpose
2. Scope (when to use / when not to use)
3. Prereqs / Access requirements
4. Procedure (step-by-step)
5. Validation (how to confirm success)
6. Rollback / Recovery steps
7. Failure modes / Troubleshooting
8. References (related ADRs, alerts, dashboards, security notes)

Runbooks must be copy/paste safe and explicit about environment context.

## Incident response model (minimum viable enterprise)

Document:
- severity definition (SEV levels and impact criteria)
- triage process and initial containment guidance
- communications templates (public-safe)
- postmortem process: timeline, contributing factors, corrective actions

## DR/BCP expectations

Treat the portfolio app as a service:
- identify dependencies (hosting, DNS, CI/CD, third-party services)
- define recovery objectives (RTO/RPO) appropriate for a portfolio service
- document recovery playbooks and validation steps
- document “known hard failures” and mitigation/acceptance

## Validation and expected outcomes

Ops docs are “correct” when:
- a reviewer can deploy and rollback deterministically
- incident response steps are actionable and ordered
- recovery guidance exists for common dependency failures

## Failure modes and troubleshooting

- **Runbooks without validation:** procedures end without confirming success → add explicit checks.
- **Rollback missing:** deployment is documented but rollback is not → fix immediately.
- **IR is theoretical:** no severity model or comms plan → add minimal viable IR scaffolding.

## References

Operational changes must be synchronized with:
- CI/CD pipeline and environment documentation (`30-devops-platform/`)
- security controls and threat model impacts (`40-security/`)
- release notes for meaningful runtime changes (`00-portfolio/release-notes/`)
