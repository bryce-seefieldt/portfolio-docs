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
### 3) Choose rollback approach

#### Approach A: Git-based rollback (Source of Truth, Preferred)

Use Git as the system of record by reverting commits on `main`:

```bash
git revert <commit-sha>
```

If multiple commits are involved, revert them in reverse order, or revert the merge commit that introduced them.

If revert produces conflicts, resolve carefully and keep the rollback minimal.

**When to use this approach:**
- Default choice for any regression
- ensures audit trail and clean source history
- works for all failure types (broken links, routing changes, etc.)

**Special case: Package manager / toolchain regressions**

If the regression is caused by changes to package manager configuration or dependencies:
- Rollback still uses Git revert (revert the commit that changed `package.json` or lockfile)
- After rollback PR merges, Vercel redeploys from the corrected `main`
- Vercel will use the reverted `package.json#packageManager` and `pnpm-lock.yaml`
- Production will return to the prior working state

Example:
```bash
# If dependency update caused broken build
git revert <commit-that-updated-dependencies>
# Verify locally: pnpm install && pnpm build succeeds
# Merge rollback PR
# Vercel redeploys with prior working lockfile and pnpm version
```

#### Approach B: Vercel deployment-level rollback (Delivery Approach, Optional)

Vercel provides a "Rollback" button in the Deployments UI to revert to a prior deployment without modifying Git history:

1. Go to **Vercel Dashboard → Deployments**
2. Locate the last known good deployment
3. Click **"Rollback to this deployment"**
4. Vercel reassigns the production domain to the prior version

**When to use this approach:**
- Emergency: need fastest possible recovery, Git changes can follow
- Operational flexibility: temporary recovery while figuring out the fix

**Caveats:**
- Does not update `main` branch; fix must still be applied and merged later
- Creates potential drift between Git history and production state
- Use sparingly; prefer Git rollback for audit trail

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

## Deployment blocked? (Checks failed)

If Deployment Checks fail after merge, the deployment is created but remains **unpromoted**:

1. **Preferred:** Revert the offending PR on `main` (this runbook)
2. **Alternative:** Use Vercel rollback UI to temporarily restore prior version while reviewing the fix
3. Once rollback (or fix) is applied, Vercel redeploys and checks re-run
4. When checks pass, Vercel assigns production domain

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