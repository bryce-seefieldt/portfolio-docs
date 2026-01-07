---
title: '<New-Project>: Troubleshooting'
description: 'Common failure modes and deterministic fixes: build failures, broken links, category issues, routing confusion, and MDX errors.'
sidebar_position: 7
tags: [projects, troubleshooting, operations]
---

## Purpose

This page provides a practical, operator-oriented troubleshooting guide for common failures.

The intent is to reduce time-to-fix and standardize responses to predictable problems.

## Scope

### In scope

- local dev failures (`pnpm start`, build issues)
- broken link failures during `pnpm build`
- routing and base path confusion


### Out of scope

- hosting vendor incidents requiring account-level access (document separately if needed)
- security incident handling (see operations incident response area)

## Prereqs / Inputs

- Ability to run:
  - `pnpm start`
  - `pnpm build`


## Procedure / Content

## Symptom: `pnpm start` fails to run

### Likely causes

- dependencies not installed
- Node/pnpm version mismatch
- corrupted local workspace state

### Diagnostics

```bash
pnpm -v
node -v
pnpm install
```

### Fix

Reinstall dependencies:

```bash
pnpm install
```

- If persistent, clear local caches carefully (avoid destructive actions unless necessary) and re-run install.


## Validation / Expected outcomes

Troubleshooting is effective when:

- contributors can diagnose failures quickly from build output
- fixes are deterministic and documented
- recurring failures lead to improved governance (templates, lint rules, runbooks)

## Vercel Deployment Failure Modes

When the site builds successfully locally but fails in production (Vercel), refer to the deployment runbook for diagnostics and recovery:

## Failure modes / Troubleshooting

- **“Fix by disabling checks”**: never weaken `pnpm build` gate to “make it pass.” Fix the root cause or revert.
- **Silent drift**: if the fix becomes common, convert it into a runbook entry or governance rule.

## References

- Quality gates: `docs/60-projects/<new-project>/testing.md`
- Navigation governance: `docs/60-projects/<new-project>/architecture.md`
- Operations posture: `docs/60-projects/<new-project>/operations.md`
- Runbook template (internal-only): `docs/_meta/templates/template-runbook.md`
