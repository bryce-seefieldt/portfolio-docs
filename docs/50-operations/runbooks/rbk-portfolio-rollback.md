---
title: 'Runbook: Rollback Portfolio App'
description: 'Procedure to rollback a Portfolio App deployment using Git revert and verification steps, with escalation guidance for suspected sensitive publication.'
sidebar_position: 5
tags: [operations, runbook, portfolio-app, rollback, incident-response]
---

## Purpose

Provide a deterministic rollback method for the Portfolio App that is:

- fast
- auditable
- reproducible
- aligned to Git as the system of record

## Scope

### Use when

- production deployment caused regression or outage
- routing/base path errors break navigation or assets
- evidence links break materially
- CI gates were bypassed or a dangerous change slipped through
- suspected sensitive publication (immediate rollback)

### Do not use when

- the issue is local-only and not deployed

## Prereqs / Inputs

- Access:
  - ability to create and merge rollback PRs to `main`
- Inputs:
  - offending PR number or commit SHA
  - last known good deployment/commit reference
- Tools:
  - git, pnpm

:::danger
If rollback is due to possible sensitive publication:

- remove public exposure immediately (revert)
- rotate any exposed secrets if applicable
- write a postmortem with corrective actions
  :::

## Procedure / Content

### 1) Identify rollback target

- Find the PR that introduced the regression.
- Identify last known good state (commit prior to merge).

### 2) Create rollback branch

```bash
git checkout main
git pull
git checkout -b ops/portfolio-rollback-<short-reason>
```

### 3) Revert the offending commit(s)

Preferred: revert the merge commit or specific commit SHA:

```bash
git revert <commit-sha>
```

If conflicts occur:

- keep rollback minimal
- do not “fix forward” in the rollback PR

### 4) Validate locally

```bash
pnpm install
pnpm lint
pnpm format:check
pnpm typecheck
pnpm build
```

Expected outcome:

- all checks pass.

### 5) Open rollback PR

Rollback PR must include:

- what is being reverted
- why (impact and symptoms)
- evidence: build passed
- security note: “No secrets added”

CI is the release gate: do not bypass required checks. The rollback PR must pass `ci / quality` and `ci / build` before production promotion.

### 6) Merge rollback PR and confirm production recovery

- Merge rollback PR to `main`.
- Confirm Vercel production promotion completes after checks pass.
- Validate production:
  - `/`, `/cv`, `/projects`, one project page
  - evidence links to docs

### 7) Follow-up

After stability is restored:

- create a fix-forward PR if needed
- update runbooks if procedure gaps were discovered
- write a postmortem if user impact or security risk occurred

## Validation / Expected outcomes

Rollback is successful when:

- production routes render correctly
- promotion checks are green
- regression is removed from `main`
- evidence links work

## Rollback / Recovery

If rollback fails to restore service:

- revert further back to the last known good commit
- reduce scope: remove risky changes (routing/headers) first
- escalate to incident response and write a postmortem

## Failure modes / Troubleshooting

- Revert conflicts:
  - revert merge commit instead of individual commits when possible
- Promotion stuck:
  - ensure CI checks exist for the main commit; confirm imported check names
- Persistent issues after rollback:
  - regression may be in hosting config or external dependency; reassess and document

## References

- Deploy runbook: `docs/50-operations/runbooks/rbk-portfolio-deploy.md`
- CI triage runbook: `docs/50-operations/runbooks/rbk-portfolio-ci-triage.md`
- Postmortem template (internal-only): `docs/_meta/templates/template-postmortem.md`
