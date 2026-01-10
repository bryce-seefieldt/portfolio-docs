---
title: 'Runbook: Deploy Portfolio App'
description: 'Procedure to deploy the Portfolio App with PR previews, CI quality gates, and promotion checks before production release.'
sidebar_position: 4
tags: [operations, runbook, portfolio-app, deployment, vercel, cicd]
---

## Purpose

Provide a deterministic deployment procedure for the Portfolio App that ensures:

- PR review and preview validation
- CI gates are green before merge
- production promotion is gated by imported checks
- post-deploy validation is explicit

## Scope

### Use when

- publishing any Portfolio App change
- releasing routing/navigation updates
- shipping new project pages or evidence link updates

### Do not use when

- experimenting locally without intent to merge (use local validation only)

## Prereqs / Inputs

- Access:
  - ability to open PRs and merge to `main`
- Tools:
  - Node (20+), pnpm, git
- Preconditions:
  - change is on a feature branch
  - PR template includes “No secrets added”
  - local build and CI checks pass

:::warning
Do not deploy content that includes secrets, internal endpoints, or sensitive logs/screenshots.
If suspected, stop and treat as an incident.
:::

## Procedure / Content

### 1) Local preflight validation (required)

From repository root:

```bash
pnpm install
pnpm lint
pnpm format:check
pnpm typecheck
pnpm build
```

Optional local preview:

```bash
pnpm dev
```

Expected outcome:

- all commands succeed with no errors.

### 2) Open a PR (required)

- PR must include:
  - what changed
  - why
  - evidence: local commands ran successfully (at minimum pnpm build)
  - security note: “No secrets added”

### 3) Validate preview deployment

In the PR:

- confirm Vercel preview deployment exists
- validate critical routes:
  - `/` loads and primary CTA works
  - `/cv` renders correctly
  - `/projects` renders list
  - at least one `/projects/[slug]` renders and includes evidence links
- validate /docs links resolve correctly (path or subdomain)

### 4) Merge to `main`

- merge only when all required GitHub checks are green:
  - `ci / quality`
  - `ci / build`

### 5) Confirm production promotion gating

After merge:

- open Vercel deployment details
- confirm production promotion is gated until imported checks pass:
  - `ci / quality`
  - `ci / build`

Expected outcome:

- production domains are assigned only after checks pass.

### 6) Post-deploy validation

Validate production:

- core routes load (same set as preview)
- evidence links to docs remain correct
- no broken images/assets

### 7) Record release evidence (recommended)

If change is material:

- add/update a release note entry in Portfolio Docs App (portfolio program release notes)
- update dossier pages if behavior changed

## Validation / Expected outcomes

Deployment is successful when:

- production site renders correctly
- required checks are green
- evidence links are correct
- no sensitive information is exposed

## Rollback / Recovery

Rollback if:

- production rendering is broken
- critical routes 404
- `/docs` linking is broken materially
- sensitive publication suspected

Primary rollback method:

- revert the offending PR on main and redeploy (see rollback runbook).

## Failure modes / Troubleshooting

- Preview succeeds but prod fails:
  - compare env settings; confirm check gating; rollback if needed
- Promotion stuck “waiting for checks”:
  - ensure CI runs on push to main; confirm check names match imported checks
- Broken evidence links:
  - treat as regression; fix forward or rollback depending on severity

## References

- Portfolio App dossier deployment: `docs/60-projects/portfolio-app/deployment.md`
- Hosting ADR: `docs/10-architecture/adr/adr-0007-portfolio-app-hosting-vercel-with-promotion-checks.md`
- Rollback runbook: `docs/50-operations/runbooks/rbk-portfolio-rollback.md`
- CI triage runbook: `docs/50-operations/runbooks/rbk-portfolio-ci-triage.md`
