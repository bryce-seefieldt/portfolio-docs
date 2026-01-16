---
title: 'Portfolio App: Deployment'
description: 'Deployment model for the Portfolio App: CI quality gates, Vercel environments, production promotion checks, and rollback posture.'
sidebar_position: 3
tags: [projects, deployment, cicd, vercel, github-actions, governance]
---

Status: Live — CI quality/build gates with frozen installs; Vercel preview + production promotion with Deployment Checks configured (see [rbk-vercel-setup-and-promotion-validation.md](../../50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md)).

## Purpose

Define how the Portfolio App is built and deployed with enterprise-grade governance:

- CI quality gates before merge
- preview environments for PR validation
- production promotion gated on checks
- simple rollback via Git as system of record

## Scope

### In scope

- CI/CD contract (scripts and checks)
- environment strategy (preview vs production)
- domain strategy (root domain for Portfolio App)
- production promotion gating (Vercel Deployment Checks)
- rollback strategy

### Out of scope

- vendor-specific secrets or account identifiers
- incident response details (see `operations.md` and postmortems)

## Prereqs / Inputs

- GitHub repository with PR-only merges to `main`
- Vercel project connected to GitHub
- A stable Node/pnpm toolchain (pinned via packageManager recommended)
- Documentation App deployed separately at `/docs` or docs subdomain

## Procedure / Content

## Environments

### Preview (PR branches)

- Every PR should generate:
  - a Vercel preview deployment URL
  - passing GitHub checks
- Reviewers validate:
  - routing, rendering, performance basics
  - evidence links to `/docs` are correct

### Production (`main`)

- `main` is the published production branch.
- Production domains are assigned only after required checks pass (see below).

## Environment variable configuration

### Required variables (all environments)

**`NEXT_PUBLIC_DOCS_BASE_URL`**

- Documentation App base URL for evidence links
- Must be set in all environments (local, preview, production)

Examples by environment:

```bash
# Local development (docs running on localhost:3001)
NEXT_PUBLIC_DOCS_BASE_URL=http://localhost:3001

# Preview deployments (Vercel preview URL or dedicated preview docs domain)
NEXT_PUBLIC_DOCS_BASE_URL=https://portfolio-docs-git-preview-branch.vercel.app

# Production (final docs domain)
NEXT_PUBLIC_DOCS_BASE_URL=https://docs.yourdomain.com
# OR path-based:
NEXT_PUBLIC_DOCS_BASE_URL=https://yourdomain.com/docs
```

### Optional variables (recommended for production)

**`NEXT_PUBLIC_SITE_URL`**

- Canonical site URL for metadata and absolute links
- Example: `https://portfolio.yourdomain.com`

**`NEXT_PUBLIC_GITHUB_URL`**

- Public GitHub profile or repo URL
- Example: `https://github.com/your-handle`

**`NEXT_PUBLIC_LINKEDIN_URL`**

- Public LinkedIn profile URL
- Example: `https://www.linkedin.com/in/your-handle/`

**`NEXT_PUBLIC_CONTACT_EMAIL`**

- Public contact email (appears as mailto link; no form)
- Example: `contact@yourdomain.com`

### Variable validation

- All `NEXT_PUBLIC_*` variables are **client-visible**
- **Never** place secrets, tokens, or sensitive endpoints in these variables
- Missing required variables should degrade gracefully (app links to `/docs` by default)

### Setting variables in Vercel

1. Navigate to Vercel project → Settings → Environment Variables
2. Add variables for each environment scope:
   - **Production**: final public URLs
   - **Preview**: preview/staging URLs
   - **Development**: optional (can use `.env.local`)
3. Redeploy after variable changes to apply

## CI contract (GitHub Actions)

### Minimum required checks

1. **Quality gate**
   - lint (ESLint)
   - format check (Prettier)
   - typecheck (TypeScript)
2. **Build gate**
   - Next.js build must succeed

Optional later:

- unit tests
- e2e tests
- dependency auditing gates

### Principle

The Portfolio App should never merge changes that:

- break build
- drift formatting standards
- introduce type errors
- violate documented governance requirements

## Pre-deployment governance (required)

- Check names must remain stable and match the branch ruleset and any deployment checks:
  - `ci / quality`
  - `ci / build`
- These checks must run on PRs and on pushes to `main` so they are selectable as required and usable by Vercel promotion checks later.
- Deterministic installs are required in CI (`pnpm install --frozen-lockfile`). Changing dependency graphs must be intentional and reviewed.

## Vercel promotion governance

### Deployment checks

Enable Vercel “Deployment Checks” by importing GitHub checks and requiring them before promotion.

Recommended required checks:

- `ci / quality`
- `ci / build`

Outcome:

- Vercel creates a deployment, but production domains are not assigned until checks pass.

## Rollback posture

### Primary rollback mechanism: Git revert

- Revert the offending PR on `main`
- Redeploy from corrected `main`

### Secondary rollback mechanism: hosting rollback

- If using hosting rollback features, document and test the procedure.
- Prefer Git-based rollback for traceability and portfolio credibility.

## Validation / Expected outcomes

- PR previews exist for review
- PR merges are blocked unless CI checks pass
- Production promotion is blocked unless required checks pass
- Rollback is deterministic and documented

## Failure modes / Troubleshooting

- Vercel waits indefinitely for checks:
  - ensure CI runs on `push` to `main` and check names are stable
- Preview differs from production:
  - ensure build commands and environment variables are consistent
- Broken `/docs` links:
  - treat as breaking change; update evidence links and release notes

## References

- CI governance ADR: `docs/10-architecture/adr/adr-0008-portfolio-app-ci-quality-gates.md`
- Vercel hosting ADR: `docs/10-architecture/adr/adr-0007-portfolio-app-hosting-vercel-with-promotion-checks.md`
- Vercel setup runbook: `docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md`
- Portfolio deploy runbook: `docs/50-operations/runbooks/rbk-portfolio-deploy.md`
- Portfolio rollback runbook: `docs/50-operations/runbooks/rbk-portfolio-rollback.md`
- CI triage runbook: `docs/50-operations/runbooks/rbk-portfolio-ci-triage.md`
- Documentation App deployment governance: `docs/60-projects/portfolio-docs-app/03-deployment.md`
