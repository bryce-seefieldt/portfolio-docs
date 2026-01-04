---
title: "Portfolio Narrative and Program Artifacts"
description: "Curated, recruiter-friendly documentation that frames the portfolio as a product and links to deeper technical evidence across architecture, DevOps, security, and operations."
sidebar_position: 1
tags: [portfolio, product, roadmap, release-notes, governance]
---

## Purpose

This section provides the **high-signal portfolio narrative**: what the portfolio is, what it proves, and how a reviewer should explore the evidence. It is intentionally written to be legible for both technical and non-technical audiences.

This is the “front door” to the documentation program.

## Scope

### In scope
- product brief / “why this exists”
- capability map: a mapping of features and artifacts to demonstrable skills
- roadmap: planned work presented as deliverable increments
- release notes: what changed, why it matters, and how to validate
- reviewer guidance: how to evaluate the portfolio and linked projects

### Out of scope
- implementation detail (belongs in architecture/engineering/devops/security/ops)
- raw technical “notes” without context or a narrative purpose

## Audience

- primary: recruiters, hiring managers, cross-functional stakeholders
- secondary: engineers who want a guided path to technical depth

## What belongs here

Use this section to:
- provide an executive summary of the portfolio web app and the demo ecosystem
- explain how the documentation is organized and why it signals maturity
- highlight proof points with references to deeper sections (without duplicating them)

## Standard page shape for this section

Every page in `00-portfolio/` should include:
1. Purpose and intended reader
2. What the reader should learn / evaluate
3. Summary of evidence artifacts (by section name + file path reference)
4. Next steps (where to go deeper)

## Required artifacts to create early

Recommended initial files (create these first):
- `product-brief.md` — one-page narrative of the product and its differentiators
- `capabilities-map.md` — “proof matrix” mapping skills → artifacts → evidence
- `roadmap.md` — a living plan for delivery increments and maturity milestones
- `release-notes/` — versioned release notes (e.g., v0.1.0, v0.2.0)

## Portfolio writing guidelines (strict)

- Write for clarity and credibility; avoid buzzwords without evidence.
- Prefer bullet points over long paragraphs.
- Make claims only when there is documentation evidence elsewhere.
- Use consistent language:
  - “portfolio web app” = the primary product
  - “demo projects” = supporting exemplars
  - “evidence artifacts” = ADRs, runbooks, threat models, pipeline checks

## Validation and quality expectations

A portfolio narrative page is “good” when:
- a reviewer can understand the scope in < 2 minutes
- it links (conceptually) to the correct domain sections for verification
- it does not contain implementation detail that belongs elsewhere

## Failure modes and troubleshooting

Common problems:
- **Overloaded narrative:** too much technical detail → move it to the correct domain and summarize here.
- **Unverifiable claims:** statements not backed by artifacts → add a capability map entry and create the missing artifact.
- **Timeline drift:** roadmap not matching actual releases → update roadmap and release notes in the same PR.

## References

Operational rule: any change that impacts product claims must also update:
- capability map and/or roadmap and/or release notes
