---
title: "Runbook: Rollback Portfolio Docs App"
description: "Procedure to rollback a Portfolio Docs App deployment by reverting changes on main and validating recovery."
tags: [operations, runbook, rollback, incident-response, documentation]
---

## Purpose

Provide a deterministic rollback procedure for the Portfolio Docs App using Git as the system of record.

Rollback is designed to be:
- fast
- low-risk
- auditable via PR history
- verifiable via post-deploy checks

## Scope

### Use when
- deployment introduced broken navigation or rendering
- production route/base path changes broke URLs
- CI/hosting shows failed deployment after merge
- sensitive content may have been accidentally published (immediate rollback)

### Do not use when
- issue is purely local and not deployed (fix on branch and redeploy normally)

## Prereqs / Inputs

- Required access:
  - ability to create and merge rollback PRs to `main`
- Required tools:
  - `git`
- Inputs:
  - PR number or commit SHA introducing the regression
  - last known good state (prior commit or release)

:::danger
If rollback is due to possible sensitive publication, treat as a security incident:
- remove public exposure immediately
- rotate any exposed secrets if applicable
- document corrective actions (postmortem)
:::

## Procedure / Content

### 1) Identify rollback target
- Determine what changed:
  - locate the PR that introduced the regression
- Determine last known good state:
  - identify the commit immediately before the regression

### 2) Create a rollback branch
```bash
git checkout main
git pull
git checkout -b ops/docs-rollback-<short-reason>
```
Example:
```bash
git checkout -b ops/docs-rollback-broken-nav
```
### 3) Revert the offending change

Option A (preferred): revert the merge commit / PR commit(s):
```bash
git revert <commit-sha>
```
If multiple commits are involved, revert them in reverse order, or revert the merge commit that introduced them.

If revert produces conflicts, resolve carefully and keep the rollback minimal.

Do not “fix forward” in the rollback PR—only restore the last known good state.

### 4) Validate locally
```bash
pnpm install
pnpm build
```

Expected outcome:

- Build succeeds.

### 5) Open a rollback PR

Rollback PR must include:
- what is being reverted
- why (symptoms and impact)
- evidence: local pnpm build passed
- security statement: “No secrets added”

### 6) Merge rollback PR and verify redeploy
- Merge rollback PR into `main`
- Confirm hosting redeploys from updated main
- Perform post-rollback validation:
    - site loads
    - navigation works
    - key pages render

### 7) Follow-up (after stability restored)

- Decide whether to:
    - fix forward in a new PR, OR
    - document an ADR if the change was architectural, OR
    - write a postmortem if user impact occurred

## Validation / Expected outcomes

Rollback is successful when:
- production site is stable and renders correctly
- navigation is restored
- build gate passes
- the regression is removed from main

## Rollback / Recovery

Rollback procedure is itself the recovery mechanism. If rollback fails:
- revert further back to last known good commit
- temporarily disable risky features (e.g., remove MDX changes) via minimal reverts
- consider a hotfix PR only after stability is restored

## Failure modes / Troubleshooting

- Revert conflicts:
    - keep rollback minimal; avoid mixing fixes and rollback
    - if needed, revert the merge commit rather than individual commits
- Hosting does not redeploy:
    - manually trigger redeploy (if available)
    - confirm integration between repo and host is functioning
- Issue persists after rollback:
    - regression may be unrelated; reassess changes; escalate to incident response

## References

- Deploy runbook: `docs/50-operations/runbooks/rbk-docs-deploy.md`
- Broken links triage: `docs/50-operations/runbooks/rbk-docs-broken-links-triage.md`
- Postmortem template (internal-only): `docs/_meta/templates/template-postmortem.md`