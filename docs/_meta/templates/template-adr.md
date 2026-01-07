---
title: 'Template: Architecture Decision Record (ADR)'
description: 'Standard ADR template to document decision context, alternatives, consequences, and follow-ups.'
tags: [meta, template, architecture, adr, governance]
---

# Template: Architecture Decision Record (ADR)

## Purpose

Use this template to capture an architectural decision so it is:

- reviewable and traceable
- auditable over time
- linked to security, operations, and delivery implications

## Scope

### Use when

- choosing or changing the core stack (framework, hosting, auth, persistence)
- modifying trust boundaries or data flows
- introducing a new platform component, CI gate, or security control with architectural impact

### Do not use when

- documenting a reversible experiment with no lasting implications (use a short proposal note instead)

## Prereqs / Inputs

- Decision owner(s):
- Date:
- Status: Proposed | Accepted | Superseded | Deprecated
- Related work items (optional identifiers):
- Related risks (optional):

## Decision Record

### Title

ADR-XXXX: <Decision Title>

### Context

- What problem are we solving?
- What constraints exist (time, cost, compliance, platform)?
- What assumptions are we making?

### Decision

- State the decision clearly in one paragraph.
- Include key configuration choices that define the decision (high level; no secrets).

### Alternatives considered

List each alternative and why it was not chosen:

1. Alternative A
   - Pros:
   - Cons:
   - Why not chosen:

2. Alternative B
   - Pros:
   - Cons:
   - Why not chosen:

### Consequences

- Positive consequences:
- Negative consequences / tradeoffs:
- Operational impact:
- Security impact:
- Cost/complexity impact:

### Implementation notes (high-level)

- What changes are required?
- What gets removed or deprecated?
- What migration considerations exist?

## Validation / Expected outcomes

- How will we confirm the decision is successful?
- What metrics/signals should improve?
- What regression risks must be checked?

## Failure modes / Troubleshooting

- What can go wrong because of this decision?
- What are the rollback or mitigation options?
- How do we detect failures early?

## References

- Related architecture pages:
- Related threat model(s):
- Related runbook(s):
- Related CI/CD documentation:
