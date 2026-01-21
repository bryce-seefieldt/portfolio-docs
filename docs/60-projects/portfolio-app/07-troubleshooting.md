---
title: 'Portfolio App: Troubleshooting'
description: 'Common Portfolio App failure modes and deterministic fixes: CI failures, routing issues, preview/prod drift, and evidence-link regressions.'
sidebar_position: 7
tags: [projects, troubleshooting, nextjs, vercel, ci, operations]
---

## Purpose

Provide an operator-oriented troubleshooting guide for the most likely failure modes of the Portfolio App.

This page is a project-specific summary; authoritative procedures live in runbooks.

## Scope

### In scope

- CI quality failures (lint/format/typecheck)
- build failures (`pnpm build`)
- routing/base path and domain issues
- preview vs production drift
- broken evidence links to `/docs`

### Out of scope

- vendor outages requiring account-level remediation (document separately if needed)
- security incidents (handled via incident response + postmortems)

## Prereqs / Inputs

- ability to run local tooling:
  - `pnpm verify` or `pnpm verify:quick` (recommended)
  - individual commands: `pnpm lint`, `pnpm format:check`, `pnpm typecheck`, `pnpm build`
- access to CI logs (GitHub Actions)
- access to hosting deployment logs (Vercel)

## Procedure / Content

## Symptom: CI quality job fails (lint/format/typecheck)

### Likely causes

- formatting drift
- lint rule violations
- TypeScript config mismatch or unsafe typing changes

### 1) Reproduce locally (required)

**Recommended approach:**

```bash
pnpm install
pnpm verify:quick  # Fast validation with detailed error reporting
```

**Alternative: Individual commands:**

On the same branch:

```bash
pnpm install
pnpm lint
pnpm format:check
pnpm typecheck
```

- if any command fails locally: fix directly
  - use `pnpm format:write` for formatting issues (or let `pnpm verify` auto-fix)
  - for lint errors: inspect output and fix violations
  - for type errors: fix or adjust `tsconfig.json` if legitimately needed
    Follow: runbook(s) under docs/50-operations/runbooks/

## Symptom: `pnpm build` fails

### Likely causes

- Next.js build errors due to invalid imports or TS errors
- environment assumptions leaking into build
- misconfigured route segments or metadata

### Fix

- reproduce locally:

```bash
pnpm build
```

- fix root cause and re-run build until deterministic success

## Symptom: Preview works but production fails

### Likely causes

- differing environment variables or settings between preview and production
- inconsistent Node/pnpm versions
- cached artifacts or misconfigured build settings

### Fix

- confirm toolchain pinning (Node and pnpm)
- confirm Vercel build settings align with repo scripts
- compare preview/prod logs and ensure checks are required for promotion

## Symptom: `pnpm secrets:scan` fails or is skipped

### Likely causes

- TruffleHog CLI binary not installed (most common)
- TruffleHog not in system PATH
- Actual secrets detected in codebase (rare, but critical)

### Fix

**TruffleHog not installed:**

The `pnpm secrets:scan` script requires the TruffleHog CLI binary (not available via npm).

```bash
# macOS
brew install trufflesecurity/trufflehog/trufflehog

# Linux
# 1. Download: https://github.com/trufflesecurity/trufflehog/releases/
# 2. Extract: tar -xzf trufflehog_*_linux_x86_64.tar.gz
# 3. Install: sudo mv trufflehog /usr/local/bin/

# Verify installation
which trufflehog
trufflehog --version
```

**TruffleHog not in PATH:**

After installation, ensure it's executable and in your PATH:

```bash
# Check if it's discoverable
which trufflehog

# If not found, add to PATH or move to /usr/local/bin
sudo mv trufflehog /usr/local/bin/
chmod +x /usr/local/bin/trufflehog
```

**Alternative: Use pre-commit hook:**

If you prefer not to install the binary separately, use the pre-commit hook for automatic scanning on every commit:

```bash
pip install pre-commit
pre-commit install
```

This will run TruffleHog automatically before each commit.

**Real secrets detected:**

If TruffleHog finds verified credentials:

1. **Stop immediately** — do not commit
2. **Remove the secret** from code and `.env` files
3. **Rotate the credential** (if already committed to history)
4. **Clean Git history** (if needed):
   ```bash
   # Use git-filter-repo or BFG Repo-Cleaner
   # See: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository
   ```

## Symptom: Root domain works but `/docs` links break

### Likely causes

- docs hosted on subdomain but links assume `/docs`
- docs moved or restructured
- docs base path changed

### Fix

- standardize docs URL strategy:
  - `/docs` path vs docs subdomain
- treat base path changes as breaking changes:
  - update all evidence links
  - update dossier documentation and release notes

## Validation / Expected outcomes

- failures are reproducible locally
- fixes are minimal and auditable
- CI returns to green and production promotion resumes
- evidence links remain consistent and trustworthy

## Failure modes / Troubleshooting

- repeated failures due to inconsistent local tooling:
  - document and enforce toolchain versions
- “fix by disabling checks”:
  - unacceptable; fix root causes or rollback

## References

- Portfolio App dossier hub: `docs/60-projects/portfolio-app/index.md`
- Testing and gates: `docs/60-projects/portfolio-app/testing.md`
- Deployment governance: `docs/60-projects/portfolio-app/deployment.md`
- Runbooks index: `docs/50-operations/runbooks/index.md`
