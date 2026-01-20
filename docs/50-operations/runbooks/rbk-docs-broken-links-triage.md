---
title: 'Runbook: Broken Links Triage for Portfolio Docs App'
description: 'Procedure to diagnose and fix pnpm build failures caused by broken internal links, missing doc IDs, or category link mismatches.'
sidebar_position: 3
tags: [operations, runbook, troubleshooting, documentation, quality-gates]
---

## Purpose

Provide a fast, deterministic procedure to fix **broken link** and **doc ID** issues that block the Portfolio Docs App build (`pnpm build`).

This runbook is optimized for:

- minimizing downtime in the docs delivery pipeline
- maintaining navigation integrity
- preventing repeated recurrence through governance rules

## Scope

### Use when

- `pnpm build` fails due to:
  - broken internal Markdown links
  - missing referenced doc IDs
  - category link targets that do not exist

### Do not use when

- links are external and optional (handle via a separate external link policy if adopted)
- the failure is not link-related (use general troubleshooting)

## Prereqs / Inputs

- Required tools:
  - `pnpm`
  - `git`
- Inputs:
  - build output showing the file and missing link target
  - the intended target page or intended navigation behavior

:::note
This repository prefers avoiding links to pages that do not exist yet. Use plain-text path references until the target is created.
:::

## Procedure / Content

### 0) Check for quality gate failures first

Before assuming link issues, check if the failure is from quality gates:

**If CI shows `ci / quality` failure:**

- The issue is likely lint, typecheck, or formatting, **not** broken links
- See [Quality gate failures](./rbk-docs-deploy.md#failure-quality-gate-failures-lint-typecheck-format) in the deploy runbook
- Diagnosis:
  ```bash
  pnpm lint          # Check ESLint
  pnpm typecheck     # Check TypeScript
  pnpm format:check  # Check Prettier
  ```

**If CI shows `ci / build` failure,** proceed with link triage below.

### 1) Check for toolchain-related failures

Before assuming link issues, verify package manager consistency and environment variables:

**If you recently changed dependencies or pnpm version:**

1. Confirm Corepack pin in `package.json`:

   ```bash
   grep packageManager package.json
   # Should output: "packageManager": "pnpm@10.0.0"
   ```

2. Verify local pnpm matches the pin:

   ```bash
   pnpm --version  # Should output: 10.0.0
   ```

   If it does not match, enable Corepack locally:

   ```bash
   corepack enable
   corepack install
   pnpm --version  # Should now match
   ```

3. Verify environment variables are configured:

   ```bash
   # Check .env.local exists
   [ -f .env.local ] && echo ".env.local exists" || echo "ERROR: .env.local missing"
   
   # Check required variables
   grep DOCUSAURUS_SITE_URL .env.local || echo "Missing DOCUSAURUS_SITE_URL"
   ```

  See [Environment Variables Contract](https://github.com/bryce-seefieldt/portfolio-docs/blob/main/docs/_meta/env/portfolio-docs-env-contract.md) for complete reference.

4. Clean install and rebuild:
   ```bash
   rm -rf node_modules pnpm-lock.yaml
   pnpm install
   pnpm build
   ```

If the build now passes, the issue was toolchain or environment-related, not link-related. Proceed to documenting the fix in a PR.

### 2) Reproduce the failure locally

```bash
pnpm build
```

Capture:

- the failing file path
- the missing target (URL, doc ID, or path)
- the error type (missing file vs invalid doc id vs anchor)

**Expected behavior:** `pnpm build` fails deterministically on broken links. This is intentional and by design.

### 2) Classify the failure type

#### Type A: Link points to a file that does not exist

Common symptoms:

- markdown link to `./some-page.md` or `/docs/...` that doesn’t exist

Action:

- Decide whether the target should exist now.
  - If yes: create the target file (with front matter and page shape).
  - If no: remove the link and replace with a plain-text path reference.

#### Type B: Category link target does not exist

Common symptoms:

- `_category_.json` `link.type: "doc"` points to an id that is missing

Action:

- Confirm the id matches an existing doc path under `docs/`:
  - Example: `id: "00-portfolio/index"` requires `docs/00-portfolio/index.md` to exist.

- Fix either:
  - the `_category_.json` id, or
  - create the missing `index.md`.

#### Type C: Anchor link missing within a page

Common symptoms:

- link to #some-heading that is not present after edits

Action:

- Confirm the heading exists and matches the anchor produced by Markdown rendering.
- Fix by:
  - restoring heading, or
  - updating the anchor link to match current heading.

### 3) Apply the minimal fix

Best practices:

- minimal diff
- do not mix unrelated content changes with triage
- avoid refactors during incident triage unless required to resolve the break

### 4) Validate fix locally

```bash
pnpm build
```

Expected outcome:

- build succeeds with no link or structural errors

Optionally verify in preview:

```bash
pnpm start
```

- click the affected navigation area
- confirm the link now resolves

### 4b) Interpret Vercel build logs (if failure occurred in CI/Vercel)

If the issue was discovered in Vercel (not locally), review the build logs:

1. Go to **Vercel Dashboard → Deployments**
2. Locate the failed deployment from `main`
3. Click **"View Build Logs"**
4. Look for the error output:
   - **Link error**: will show missing file path or doc ID
   - **Pnpm error**: will show version mismatch or lockfile issue
   - **Category error**: will show invalid `_category_.json` reference

5. Compare error to local reproduction:
   - If `pnpm build` fails locally with the same error: fix locally, commit, push
   - If local build succeeds: environment mismatch → check Vercel pnpm version, Node version, or environment variables

**Example error interpretation:**

```
[ERROR] File not found: ../some-missing-page.md (referenced in 10-architecture/index.md:42)
```

Action: fix the reference in `10-architecture/index.md` line 42 or create the missing file

**Note:** A failed `pnpm build` is expected to block production promotion. This is the intended safety gate. The deployment is created but remains unpromoted; resolve the failure and either:

- Fix forward: create new PR with the fix, merge, redeploy
- Rollback: revert the PR, redeploy

### 5) Commit and PR (if required)

- Create a branch:
  - `ops/docs-fix-broken-links-<short-reason>` or `docs/fix-links-<topic>`
- PR must include:
  - what broke
  - why it broke (root cause)
  - evidence: `pnpm build` passed
  - security statement: “No secrets added”

### 6) Prevent recurrence (governance follow-up)

If the same link failure pattern repeats, add one of:

- a contributor rule (“no links to uncreated pages”)
- a checklist item in PR template
- a lint rule (if adopted)

## Validation / Expected outcomes

- `pnpm` build succeeds locally and in CI
- navigation and category landing behavior works as intended
- the change set is minimal and auditable

## Rollback / Recovery

If the fix introduces unexpected navigation changes:

- revert the triage PR (use rollback runbook)
- re-apply a narrower fix

## Failure modes / Troubleshooting

- Fix-forward creates new broken links:
  - `run pnpm` build after each small change
- Reorg causes widespread breakage:
  - split into multiple PRs; consider stable slugs for critical pages
- Category ordering becomes confusing:
  - ensure position and labels exist in `_category_.json`; keep ordering deterministic

## References

- Testing and build gate: `docs/60-projects/portfolio-docs-app/testing.md`
- Deploy runbook: `docs/50-operations/runbooks/rbk-docs-deploy.md`
- Rollback runbook: `docs/50-operations/runbooks/rbk-docs-rollback.md`
- Documentation style guide (internal-only): `docs/_meta/doc-style-guide.md`
