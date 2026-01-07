---
title: 'Template: Postmortem'
description: 'Blameless postmortem template for incidents with timelines, contributing factors, corrective actions, and verification.'
tags: [meta, template, operations, incident-response, postmortem]
---

# Template: Postmortem

## Purpose

Use this template to document an incident in a blameless, enterprise-style format that:

- improves system resilience and operations
- captures learnings for future prevention and faster response
- provides a transparent evidence trail for reliability maturity

## Scope

### Use when

- user-visible incident occurred (availability, security, correctness)
- deployment caused regression requiring rollback
- operational failure required manual intervention

### Do not use when

- issue was caught before reaching users and required no operational response (use a short incident note)

## Prereqs / Inputs

- Incident ID (optional):
- Date/time range (include timezone):
- Service/system:
- Severity:
- Primary responder:
- Stakeholders notified (public-safe):

## Executive summary

- What happened (1–3 sentences):
- User impact:
- Duration:
- Detection method (monitoring/user report/etc.):
- Root cause summary:

## Timeline

List key events with timestamps:

- YYYY-MM-DD HH:MM — Event
- YYYY-MM-DD HH:MM — Event
- YYYY-MM-DD HH:MM — Mitigation applied
- YYYY-MM-DD HH:MM — Recovery confirmed

## Impact

- Who was affected:
- What functionality was degraded/unavailable:
- Quantitative indicators (if available, public-safe):
- Workarounds available:

## Root cause analysis

### Primary cause

- Describe the primary cause clearly.

### Contributing factors

- Process gaps (e.g., missing checks, unclear runbook)
- Technical debt or complexity
- Monitoring/alerting gaps
- Documentation gaps

### What went well

- What worked in detection/response?

### What went poorly

- Where did the process or system fail?

## Corrective actions

Each action item must include:

- Action:
- Owner:
- Priority:
- Due date:
- Verification method:

Example:

| Action            | Owner    | Priority | Due date   | Verification               |
| ----------------- | -------- | -------: | ---------- | -------------------------- |
| Add CI gate for X | Platform |     High | YYYY-MM-DD | `pnpm build` + gate output |

## Validation / Expected outcomes

- How will we confirm the incident cannot repeat in the same way?
- What monitoring or alerts were added/changed?
- What runbooks or docs were updated?

## Failure modes / Troubleshooting

- What similar incidents might still occur?
- What new failure modes were introduced by the fix?
- How should responders detect those quickly?

## References

- Related PR(s) / release note(s) (public-safe references):
- Related runbook(s):
- Related ADR(s):
- Related threat model(s) (if applicable):
