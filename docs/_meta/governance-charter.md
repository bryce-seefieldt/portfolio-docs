---
title: 'Documentation Governance Charter'
description: 'Canonical governance charter for policy tiering, enforcement mapping, and anti-drift controls in portfolio-docs.'
tags:
  [
    governance,
    policy,
    docs-as-code,
    quality-gates,
    security,
    operations,
    architecture,
  ]
---

# Purpose

Define a stable governance contract for documentation policy so `portfolio-docs` can evolve quickly without policy drift.

# Scope

This charter governs:

- canonical policy authoring (`.github/copilot-instructions.md`)
- contributor process definitions (`CONTRIBUTING.md`, PR templates)
- internal templates under `docs/_meta/templates/`
- non-invasive policy consistency checks

This charter does not replace project execution plans (phase/stage delivery content).

# Governance Tier Model

## Tier A: Mandatory Controls

Tier A content is non-negotiable and must be enforceable.

- publication safety (no secrets, no sensitive internal data)
- merge quality gates and build integrity
- security and incident-response obligations
- evidence traceability requirements

A Tier A requirement must map to at least one enforcement path:

- CI workflow gate
- local verification script
- PR template checklist
- required reviewer check

## Tier B: Authoring Standards

Tier B defines consistency and readability.

- front matter requirements by scope
- linking standards for internal docs, cross-repo links, and source links
- diagram standards for architecture/process artifacts
- information architecture and navigation hygiene

Tier B can evolve without ADR unless it changes Tier A enforcement behavior.

## Tier C: Temporal Delivery Guidance

Tier C captures time-bound delivery guidance.

- phase/stage implementation details
- sprint-specific instructions
- temporary migration notes

Tier C content belongs in roadmap pages and issue documents, not canonical policy sections.

# Source-of-Truth Mapping

Primary sources:

- Canonical policy: `.github/copilot-instructions.md`
- Contributor workflow: `CONTRIBUTING.md`
- PR evidence contract: `.github/PULL_REQUEST_TEMPLATE.md`
- Authoring templates: `docs/_meta/templates/`
- Non-invasive drift checks: `scripts/policy-consistency-check.sh`

# Policy Authoring Rules

- Avoid duplicate normative statements across files.
- If duplication is necessary, designate one source-of-truth and mark others as mirrors.
- Never keep contradictory examples in canonical docs.
- Treat examples as executable guidance; examples must reflect current workflow reality.

# Enforcement Contract

For each requirement tagged as MUST:

1. identify owner
2. identify enforcement mechanism
3. define expected evidence
4. define rollback/remediation path when violated

# Change Control

## When to update charter-linked policy

- new CI checks or renamed jobs
- changes to build/release gates
- changes to linking or docs IA conventions
- new evidence artifact classes

## Required update set for policy-affecting changes

Update in one PR:

- `.github/copilot-instructions.md`
- `CONTRIBUTING.md`
- `.github/PULL_REQUEST_TEMPLATE.md`
- affected template files under `docs/_meta/templates/`
- policy check rules (if drift detection should change)

# Drift Prevention

- Run `pnpm policy:check` locally before PR.
- Treat warnings as triage-required, even when non-blocking.
- Use `pnpm policy:check:strict` when validating high-risk governance updates.

# Review Cadence

- quarterly governance consistency review
- post-incident policy consistency review
- phase-end review for Tier C cleanup from canonical policy files

# Definition of Governance Done

A governance update is complete when:

- policy text is internally consistent
- contributor docs and PR template reflect active checks
- templates align with canonical authoring rules
- policy checker warnings are triaged or resolved
