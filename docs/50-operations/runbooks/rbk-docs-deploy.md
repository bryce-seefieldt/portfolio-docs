---
title: 'Runbook: Deploy Portfolio Docs App'
description: 'Procedure to deploy the Portfolio Docs App via PR workflow, including validation steps and rollback triggers.'
sidebar_position: 100
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
  - `pnpm`, `node` (local validation)- Environment variables:
  - Local: `.env.local` configured (see [Environment Variables Contract](https://github.com/bryce-seefieldt/portfolio-docs/blob/main/docs/_meta/env/portfolio-docs-env-contract.md))
  - Production: Variables set in Vercel dashboard- Preconditions:
  - Changes are on a feature branch
  - PR template completed, including “No secrets added”
  - Local build gate has passed

:::warning
Do not deploy changes that include secrets, internal endpoints, or sensitive logs/screenshots. If suspected, stop and treat as a security incident.
:::

## Procedure / Content

### What causes a production deployment?

Production deployments to the Portfolio Docs App are triggered by:

1. **Merge to `main`**: Any PR merged to the `main` branch automatically triggers a Vercel production deployment
2. **GitHub detects push**: Vercel webhook activates immediately
3. **Build starts**: Vercel runs `pnpm install --frozen-lockfile` then `pnpm build`
4. **Deployment Checks run**: GitHub Actions `ci / quality` and `ci / build` workflows execute
5. **Conditional domain assignment**: Vercel assigns production domain only if **both** checks pass

This means:

- Production deployments are **automatic** (not manual) once PR is merged
- Deployment **creation** and **promotion** are decoupled
- If checks fail, the deployment exists but remains **unpromoted** (site stays on previous version)

### 1) Pre-deploy validation (local)

From repository root:

```bash
# First time setup
cp .env.example .env.local
# Edit .env.local with your local values (http://localhost:3000 for development)

pnpm install
pnpm start
```

- Confirm sidebar/navigation is coherent.
- Confirm category landing pages behave correctly.

Then run **all quality gates** (required):

- Recommended: `pnpm verify`
- Faster iteration: `pnpm verify:quick` (skips the build gate; rerun full `pnpm verify` before merge)
- Manual equivalent:

```bash
pnpm format:write  # Auto-fix formatting
pnpm lint          # ESLint
pnpm typecheck     # TypeScript
pnpm format:check  # Prettier
pnpm build         # Docusaurus build
```

Expected outcome:

- All quality gates pass without errors or warnings.
- Build succeeds without broken links or structural errors.

### 2) Open PR (required)

- Ensure PR includes:
  - what changed
  - why
  - evidence: All quality gates passed (`pnpm verify`)
  - security statement: “No secrets added”
- If preview deployments are available:
  - validate the preview environment renders as expected.

### 3) Merge to `main`

- Merge only when **all CI checks pass** (`ci / quality` and `ci / build`).
- Prefer squash merge for clean history (recommended).

### 4) Confirm production deployment

After merge:

- Confirm production deployment completed successfully (hosting provider status UI).
- **Important:** Confirm **both** Deployment Checks are green (`ci / quality` and `ci / build`) before considering the release complete.
- Validate the site:
  - home/entry docs page renders
  - sidebar loads and navigation works
  - key sections (Portfolio, Projects) open without errors

### 5) Verify build artifact and pnpm version

To ensure deterministic builds and prevent toolchain-related regressions:

**Check environment variables in Vercel:**

1. Go to **Vercel Dashboard → Settings → Environment Variables**
2. Confirm production variables are set for both Production and Preview scopes:
   - `DOCUSAURUS_SITE_URL`
   - `DOCUSAURUS_BASE_URL`
   - `DOCUSAURUS_GITHUB_*`
   - `DOCUSAURUS_PORTFOLIO_APP_URL`
3. See [Portfolio Docs Environment Variables Contract](https://github.com/bryce-seefieldt/portfolio-docs/blob/main/docs/_meta/env/portfolio-docs-env-contract.md) for complete reference

**Check Vercel build logs:**

1. Go to **Vercel Dashboard → Deployments**
2. Open the latest deployment from `main`
3. Click **"View Build Logs"**
4. Confirm output shows:
   ```
   Enabling Corepack...
   Resolving corepack shim for pnpm@10.0.0...
   pnpm 10.0.0
   ```
5. Verify the pnpm version matches `package.json#packageManager`

**Verify build artifact correctness:**

- Output directory contains `build/` with expected static HTML/CSS/JS
- No build errors in logs
- No warnings about missing assets or broken links (these should fail the build)

### 6) Validate key routes

Perform spot-check navigation on production:

- [ ] Home page (`/`) loads
- [ ] Portfolio section (`/docs/portfolio` or equivalent) accessible
- [ ] Projects dossier (`/docs/projects`) accessible
- [ ] Architecture domain (`/docs/architecture`) with sidebar navigation works
- [ ] Operations runbooks load (`/docs/operations/runbooks`)

### 7) Roll forward or rollback decision

If post-deploy validation discovers issues:

**Option A: Roll forward (fix-forward, if minor)**

- Create a new PR with the fix
- Merge and redeploy once checks pass
- Use when: issue is isolated and quick to fix

**Option B: Rollback (if major or production-impacting)**

- Use the rollback runbook: `docs/50-operations/runbooks/rbk-docs-rollback.md`
- Revert the offending PR
- Redeploy once rollback PR merges
- Use when: site is broken, navigation corrupted, or sensitive content exposed

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

## Common Deployment Failures

This section documents CI and Vercel-specific deployment failures and how to diagnose and recover from them.

### Failure: Quality gate failures (lint, typecheck, format)

**Symptom:**

- `ci / quality` check fails in GitHub Actions
- PR cannot merge or deployment is blocked
- Error messages in CI logs about ESLint, TypeScript, or Prettier failures

**Likely cause:**

- Code violates ESLint rules (unused variables, incorrect React patterns)
- TypeScript compilation errors in config or components
- Code doesn't match Prettier formatting standards

**Diagnostics:**

1. Check GitHub Actions logs:
   - Go to PR → Checks → `ci / quality`
   - Identify which step failed (lint, typecheck, or format:check)

2. Reproduce locally:
   ```bash
   pnpm lint          # Check ESLint
   pnpm typecheck     # Check TypeScript
   pnpm format:check  # Check Prettier
   ```

**Fix:**

**For lint failures:**

```bash
pnpm lint:fix      # Auto-fix where possible
pnpm lint          # Verify remaining issues
# Manually fix remaining ESLint errors
git add .
git commit -m "fix: resolve linting issues"
```

**For typecheck failures:**

```bash
pnpm typecheck     # See TypeScript errors
# Fix type errors in source files
# Use @ts-expect-error with justification only for edge cases
git add .
git commit -m "fix: resolve type errors"
```

**For format failures:**

```bash
pnpm format:write  # Auto-format all files
git add .
git commit -m "style: apply prettier formatting"
```

See [Testing](docs/60-projects/portfolio-docs-app/05-testing.md) for quality gate details.

### Failure: Output directory mismatch (404 errors or missing pages)

**Symptom:**

- Site deploys successfully but returns 404 for routes that exist locally
- Pages are missing or routing is broken in production

**Likely cause:**

- Vercel Output Directory is not set to `build/` (where Docusaurus outputs)
- Vercel is serving a different directory, missing the compiled site

**Diagnostics:**

- Verify locally: `pnpm build` produces `build/` directory with `index.html` and assets
- In Vercel Dashboard:
  - Go to project settings → Build & Development
  - Confirm "Output Directory" is set to `build`

**Fix:**

```
Vercel Project Settings:
  Build Command: pnpm build
  Output Directory: build
  Install Command: pnpm install --frozen-lockfile
```

See [Vercel Configure a build](https://vercel.com/docs/builds/configure-a-build) for details.

See [Build Determinism](docs/60-projects/portfolio-docs-app/03-deployment.md#build-contract-and-determinism) in the deployment dossier for more context.

### Failure: pnpm lockfile drift or version mismatch

**Symptom:**

- Build passes locally but fails in Vercel with "dependency not found" or "version conflict" errors
- Vercel build logs show pnpm version different from expected
- Errors like: "could not resolve operator @ …" or similar lockfile-related failures

**Likely cause:**

- `pnpm-lock.yaml` is out of sync with `package.json`
- Local pnpm version differs from Vercel's pinned version
- Dependencies were updated locally but lockfile not committed

**Diagnostics:**

1. Check Vercel build logs:
   - Vercel Dashboard → Deployments → failing deployment → View Build Logs
   - Look for pnpm version output: `pnpm X.X.X`
   - Compare to `package.json#packageManager` pinned version

2. Reproduce locally:
   ```bash
   pnpm --version  # Should match package.json#packageManager
   pnpm install --frozen-lockfile
   pnpm build
   ```

**Fix:**

**Option A: Lockfile drift (dependencies changed)**

```bash
# Locally
pnpm install
# This updates pnpm-lock.yaml to match package.json

# Verify
pnpm build  # Must pass locally

# Commit and push
git add pnpm-lock.yaml package.json
git commit -m "deps: update dependencies"
git push
# Vercel redeploys with updated lockfile
```

**Option B: Corepack/pnpm version mismatch**

```bash
# Verify Corepack pin
grep packageManager package.json
# Expected: "packageManager": "pnpm@10.0.0"

# Enable Corepack locally if needed
corepack enable
corepack install
pnpm --version  # Should now match

# Verify and rebuild
pnpm install --frozen-lockfile
pnpm build
```

See [Vercel Package Managers](https://vercel.com/docs/package-managers) and [Build Determinism](docs/60-projects/portfolio-docs-app/03-deployment.md#build-contract-and-determinism) in the deployment dossier for details.

### Failure: Missing build logs or build doesn't start

**Symptom:**

- Deployment shows no build output or minimal logs
- "Build started" but no actual build output appears
- Deployment status unclear (no error message)

**Likely cause:**

- Vercel "Ignored Build Step" misconfiguration
- Build preconditions violated (e.g., branch filter blocking build)
- Vercel webhook or Git integration issue

**Diagnostics:**

1. In Vercel Dashboard:
   - Go to project settings → Git
   - Confirm "Production Branch" is `main`
   - Check for "Ignored Build Steps" (should be empty)

2. In Vercel Dashboard → Deployments:
   - Click the deployment
   - Look for build status and any error messages

**Fix:**

- **Do not use Ignored Build Steps** for this repository initially
- Keep the build pipeline transparent and predictable
- If build doesn't start:
  - Verify branch name and protection rules
  - Confirm Vercel webhook is active in GitHub settings
  - Redeploy manually from Vercel Dashboard as temporary recovery
  - Create a runbook/postmortem if issue repeats

See [Vercel Troubleshooting Build Errors](https://vercel.com/docs/deployments/troubleshoot-a-build) for more details.

## Failure modes / Troubleshooting

- Build passes locally but fails in CI:
  - verify toolchain versions; rerun `pnpm install` cleanly; confirm lockfile integrity
- Broken links introduced:
  - remove premature links; replace with plain-text path references until targets exist
- Routing/base path mismatch:
  - treat as breaking change; rollback; record an ADR if changing routing is required

## References

- Portfolio Docs App deployment model: `docs/60-projects/portfolio-docs-app/deployment.md`
- Hosting ADR: `docs/10-architecture/adr/adr-0003-hosting-vercel-with-preview-deployments.md`
- Rollback runbook: `docs/50-operations/runbooks/rbk-docs-rollback.md`
- Broken link triage runbook: `docs/50-operations/runbooks/rbk-docs-broken-links-triage.md`
