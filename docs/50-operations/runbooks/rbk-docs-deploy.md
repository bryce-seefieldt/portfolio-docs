---
title: "Runbook: Deploy Portfolio Docs App"
description: "Procedure to deploy the Portfolio Docs App via PR workflow, including validation steps and rollback triggers."
tags: [operations, runbook, deployment, documentation, devops]
---

## Purpose

Provide a deterministic, reviewable deployment procedure for the Portfolio Docs App that:

- ensures build integrity and navigation quality
- produces a validated public deployment
- includes clear rollback triggers and recovery steps

## Scope

### Use when
- publishing documentation changes to the public site
- releasing structural IA changes (categories, hubs, routing)
- shipping governance or operational content updates

### Do not use when
- validating a local change prior to PR (use `pnpm start` and `pnpm build` locally)

## Prereqs / Inputs

- Required access:
  - ability to open PRs and merge to `main` (per branch protection rules)
- Required tools:
  - `pnpm`, `node` (local validation)
- Preconditions:
  - Changes are on a feature branch
  - PR template completed, including “No secrets added”
  - Local build gate has passed

:::warning
Do not deploy changes that include secrets, internal endpoints, or sensitive logs/screenshots. If suspected, stop and treat as a security incident.
:::

## Procedure / Content

### 1) Pre-deploy validation (local)
From repository root:

```bash
pnpm install
pnpm start
```
- Confirm sidebar/navigation is coherent.
- Confirm category landing pages behave correctly.

Then run the hard gate:
```bash
pnpm build
```

Expected outcome:
- Build succeeds without broken links or structural errors.

### 2) Open PR (required)

- Ensure PR includes:
    - what changed
    - why
    - evidence: `pnpm build` passed
    - security statement: “No secrets added”
- If preview deployments are available:
    - validate the preview environment renders as expected.

### 3) Merge to `main`

- Merge only when CI checks pass.
- Prefer squash merge for clean history (recommended).

### 4) Confirm production deployment

After merge:

- Confirm production deployment completed successfully (hosting provider status UI).
- Validate the site:
    - home/entry docs page renders
    - sidebar loads and navigation works
    - key sections (Portfolio, Projects) open without errors

### 5) Post-deploy verification checklist

- Navigation:
    - “Start here” page loads\
    - category labels and ordering are correct
- Integrity:
    - no broken internal links discovered during spot-check
- Governance:
    - new folders include `_category_.json` (where applicable)
    - hub pages exist for top-level domains

## Validation / Expected outcomes

Deployment is successful when:
- production site is reachable and renders without errors
- navigation is coherent and matches the intended IA
- spot-check confirms no broken links and no sensitive content

## Rollback / Recovery
### Rollback trigger conditions

Rollback immediately if:
- site fails to render or navigation is broken
- critical pages are missing due to routing/base path errors
- sensitive content may have been published

### Rollback procedure

- Revert the offending PR on main (see rollback runbook):
    - `docs/50-operations/runbooks/rbk-docs-rollback.md`
- Confirm redeploy occurs from updated `main`.
- Re-validate production site.

## Failure modes / Troubleshooting

- Build passes locally but fails in CI:
    - verify toolchain versions; rerun `pnpm install` cleanly; confirm lockfile integrity
- Broken links introduced:
    - remove premature links; replace with plain-text path references until targets exist
- Routing/base path mismatch:
    - treat as breaking change; rollback; record an ADR if changing routing is required

## References

- Portfolio Docs App deployment model: docs/60-projects/portfolio-docs-app/deployment.md
- Hosting ADR: docs/10-architecture/adr/adr-0003-hosting-vercel-with-preview-deployments.md
- Rollback runbook: docs/50-operations/runbooks/rbk-docs-rollback.md
- Broken link triage runbook: docs/50-operations/runbooks/rbk-docs-broken-links-triage.md