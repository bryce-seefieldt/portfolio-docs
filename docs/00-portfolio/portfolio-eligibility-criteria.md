---
title: 'Portfolio Eligibility Criteria'
description: 'Rules for what belongs in the portfolio and the minimum evidence required for inclusion.'
sidebar_position: 6
tags: [portfolio, governance, policy, eligibility, evidence]
---

## Purpose

Define clear rules for what belongs in the portfolio, what does not, and the minimum evidence required to keep reviewer trust high.

## Scope

### In scope

- New projects, case studies, or major portfolio additions
- Updates that materially change the portfolio narrative
- Changes that affect evidence, governance, or operational claims

### Out of scope

- Minor copy edits that do not change meaning
- Routine maintenance (typos, formatting, link fixes)

## Prereqs / Inputs

- Reviewer guide
- Evidence audit checklist
- Roadmap phase status

## Procedure / Content

### Inclusion criteria (must meet all)

- **Evidence-first:** Claims are backed by dossier, ADR, runbook, or threat model evidence.
- **Public-safe:** No secrets, internal endpoints, or sensitive operational detail.
- **Reviewer value:** The item strengthens evaluation of senior-level engineering judgment.
- **Operational clarity:** If the change introduces operational impact, a runbook exists.

### Explicit exclusions (do not include)

- Speculative demos without evidence backing
- Incomplete work without validation or clear constraints
- High-risk domains without corresponding runbooks or threat models
- Projects that cannot be maintained without breaking evidence links

### Evidence minimums (baseline)

- Dossier entry or dossier update when the change is material
- ADR when the change is a durable architectural or governance decision
- Threat model update when trust boundaries or entry points change
- Runbook when operational procedure is introduced or modified
- Release note entry for any portfolio-wide governance change

### Eligibility checklist (quick gate)

- [ ] Meets inclusion criteria and does not violate exclusions
- [ ] Evidence minimums satisfied and linked
- [ ] Reviewer path updated if the change is material
- [ ] Release note planned or created (if required)

## Validation / Expected outcomes

- Reviewer can trace each claim to evidence
- Portfolio remains cohesive and does not accumulate noise
- Evidence links remain current and build-safe

## Failure modes / Troubleshooting

- **Scope creep:** enforce exclusions and require evidence minimums before merging
- **Weak evidence:** pause inclusion until evidence artifacts are complete

## References

- Reviewer guide: [/docs/00-portfolio/reviewer-guide.md](/docs/00-portfolio/reviewer-guide.md)
- Evidence audit checklist: [/docs/70-reference/evidence-audit-checklist.md](/docs/70-reference/evidence-audit-checklist.md)
- Roadmap: [/docs/00-portfolio/roadmap/index.md](/docs/00-portfolio/roadmap/index.md)
