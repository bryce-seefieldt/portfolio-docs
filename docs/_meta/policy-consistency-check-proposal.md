---
title: 'Policy Consistency Check Proposal (Non-Invasive First)'
description: 'Proposal for warning-first automated governance drift detection before introducing hard enforcement.'
tags: [governance, automation, policy-check, ci, docs-as-code]
---

# Objective

Catch policy drift early without introducing immediate merge friction.

# Proposed Tool

Script: `scripts/policy-consistency-check.sh`

Modes:

- default: warning-only, exits `0`
- strict: exits non-zero when warnings exist (`--strict`)

Package scripts:

- `pnpm policy:check`
- `pnpm policy:check:strict`

Allowlist file:

- `scripts/policy-consistency-allowlist.txt` for approved, documented exceptions by rule category

# What the Check Covers (Phase 1)

1. Hardcoded production hosts in policy-sensitive docs and instruction files
2. Known legacy internal docs path shapes likely caused by prefix drift
3. Missing front matter in public docs pages (excluding internal `_meta` and `_archive`)
4. Temporal Phase/Stage language in canonical policy file

# Why Warning-Only First

- avoids blocking active work while standards are normalized
- creates visibility and triage habits
- allows rule tuning before introducing hard failures

# Recommended Rollout

## Phase 1 (Current)

- Add local script and package commands
- Use in PR review evidence as triage artifact
- Do not fail CI
- Add scoped allowlist support to reduce known false positives

## Phase 2 (After baseline cleanup)

- Add optional CI informational job (non-blocking)
- publish warning trend in PR notes

Status: `ci / policy-consistency` informational job has been added.

## Phase 3 (After 2-3 clean cycles)

- Enable strict mode for governance-impacting PRs
- optionally enforce strict mode on protected branches

# Triage Guidance

For each warning:

1. determine if it is true drift, approved exception, or false positive
2. if true drift: fix in same PR when low risk
3. if not fixed now: capture in remediation checklist issue with owner and due date

# Exit Criteria to Move to Strict Mode

- no high-severity policy contradictions open
- templates and contributor docs aligned with canonical policy
- warning volume stable and low across recent PRs
