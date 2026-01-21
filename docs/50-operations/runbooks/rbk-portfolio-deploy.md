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

## Governance Context

This runbook assumes Vercel and GitHub governance are already configured per [rbk-vercel-setup-and-promotion-validation.md](./rbk-vercel-setup-and-promotion-validation.md). Key governance already in place:

- **Vercel Deployment Checks:** `ci / quality` and `ci / build` are required for production promotion
- **GitHub Ruleset:** `main-protection` requires both checks to pass and 1 PR approval before merge
- **Environment Variables:** Configured per scope (preview and production)

If governance has not been set up, see the [setup runbook](./rbk-vercel-setup-and-promotion-validation.md) first (~90 minutes).

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

### Pre-merge checklist (quick)

- Local validation passed (choose one approach):
  - **Comprehensive:** `pnpm verify` (auto-formats, runs all checks with detailed reporting)
  - **Individual:** `pnpm lint && pnpm format:check && pnpm typecheck && pnpm build`
- PR readiness:
  - PR template completed with security note (“No secrets added”)
  - Vercel preview exists and routes render (`/`, `/cv`, `/projects`, one project detail)
  - Evidence links to docs resolve
- CI governance:
  - Required checks green: `ci / quality`, `ci / build`
  - Branch ruleset active (e.g., `main-protection`) and required checks selected

### 1) Local preflight validation (required)

### 1) Local preflight validation (required)

**Recommended approach (comprehensive validation):**

```bash
pnpm install
pnpm verify  # Runs all 8 checks with detailed error reporting
```

This runs: environment check, auto-format, format validation, lint, typecheck, secret scanning, registry validation, build, and smoke tests.

**Alternative: Quick validation (skip tests):**

```bash
pnpm verify:quick  # Runs checks 1-7, skips smoke tests
```

**Alternative: Manual step-by-step:**

From repository root:

```bash
pnpm install
pnpm format:write      # Auto-fix formatting
pnpm lint              # ESLint (zero warnings)
pnpm typecheck         # TypeScript validation
pnpm registry:validate # Projects YAML schema check
pnpm build             # Production build
pnpm test              # Smoke tests (Playwright - 12 tests)
 # Secrets scanning runs in CI on PRs (TruffleHog). Local verify uses a lightweight pattern scan.
```

**Secrets scanning scope:**

- TruffleHog-based `secrets:scan` runs in CI on PRs and must pass.
- Local verification does not run TruffleHog; a lightweight pattern-based scan is included.
- Optional local opt-in: enable pre-commit (`pip install pre-commit && pre-commit install`) or install TruffleHog if you want to run `pnpm secrets:scan` manually.

Optional local preview:

```bash
pnpm dev
```

Expected outcome:

- all commands succeed with no errors.
- smoke tests: 12/12 passing (6 routes × 2 browsers)

### 2) Open a PR (required)

- PR must include:
  - what changed
  - why
  - evidence: local validation passed (verify script or manual commands)
  - security note: "No secrets added"
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

Additionally confirm branch ruleset enforcement is active (e.g., `main-protection`) and that these checks are configured as Required in the ruleset. If Required checks are not selectable in GitHub, ensure they have executed recently on PRs and on pushes to `main`.

### 6) Env var verification (required)

Validate that the deployment environment is configured with the expected **public-safe** environment variables. This prevents broken evidence links and inconsistent metadata between Preview and Production.

#### A) Verify Vercel environment variables (Preview + Production)

In Vercel Project Settings → Environment Variables, confirm these are present:

Required (recommended minimum):

- `NEXT_PUBLIC_DOCS_BASE_URL`

Recommended for production polish:

- `NEXT_PUBLIC_SITE_URL`
- `NEXT_PUBLIC_GITHUB_URL`
- `NEXT_PUBLIC_LINKEDIN_URL`

Optional:

- `NEXT_PUBLIC_CONTACT_EMAIL`

Expected outcome:

- Values are set for **Preview** and **Production** (unless intentionally different).
- No sensitive values are stored in any `NEXT_PUBLIC_*` variable.

#### B) Verify runtime behavior in the deployed site

From the deployed environment (Preview or Production), validate behavior that depends on env:

- Documentation link(s) resolve correctly:
  - clicking “Docs” or “Evidence” navigates to the Documentation App host derived from `NEXT_PUBLIC_DOCS_BASE_URL`
- Profile links resolve correctly:
  - GitHub/LinkedIn links (if present) go to the configured destinations
- Optional mail link:
  - contact email (if configured) generates a correct `mailto:` link

If validation fails:

- treat this as a release-blocking configuration defect
- correct env vars in Vercel and trigger a new deployment (or redeploy from the same commit)
- re-run post-deploy validation steps

### 7) Post-deploy validation

Validate production:

- core routes load (same set as preview)
- evidence links to docs remain correct
- no broken images/assets

### 8) Record release evidence (recommended)

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
