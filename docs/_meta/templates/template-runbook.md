---
title: 'Template: Runbook'
description: 'Standard runbook template for operational procedures with validation and rollback guidance.'
tags: [meta, template, operations, runbook, governance]
---

# Template: Runbook

## Purpose

Use this template to document an operational procedure that must be:

- repeatable
- safe
- verifiable
- recoverable (rollback included)

Runbooks are production-grade procedures written for a stressed operator.

## Scope

### Use when

- deploying, rolling back, or changing runtime configuration
- triaging incidents or restoring service
- executing maintenance tasks with user-visible impact

### Do not use when

- documenting a concept (use an overview doc)
- listing commands without a procedure (use Reference)

## Prereqs / Inputs

- System / service:
- Environment(s): Preview | Staging | Production
- Required access:
- Required tools:
- Change window / risk level:
- Preconditions:
- Stakeholders / comms path (public-safe):

```md
:::warning
If you do not have the required access or validation signal, stop and escalate per the incident model.
:::
```

## Procedure / Content

### 1) Confirm context

- Confirm target environment:
- Confirm current version/state:
- Confirm health signals are stable:

### 2) Execute procedure

Provide step-by-step instructions. Each step must include:

- command(s)
- expected output or validation signal

Example:

```bash
# Example command placeholder
echo "Replace with real command"
```

Expected outcome:

```bash
<describe expected output / system behavior>
```

### 3) Validate success

Validation must include at least one of:

- functional check (user-visible behavior)
- log/metric signal check
- deployment status check
- smoke test

## Validation / Expected outcomes

- Primary validation:
- Secondary validation:
- Time to observe stabilization:
- Acceptance criteria:

If validation fails, proceed to rollback immediately unless explicitly risk-accepted.

## Rollback / Recovery

### Rollback trigger conditions

- What symptoms require rollback?
- What signals indicate unacceptable risk?

### Rollback procedure

- Step-by-step rollback instructions
- Validation after rollback

## Failure modes / Troubleshooting

List common failure modes:

- Symptom:
  - Likely cause:
  - Diagnostic steps:
  - Fix / mitigation:

- Symptom:
  - Likely cause:
  - Diagnostic steps:
  - Fix / mitigation:

## References

- Related architecture decisions:
- Related CI/CD pipeline docs:
- Related alerts/dashboards (public-safe references):
- Related security notes:
