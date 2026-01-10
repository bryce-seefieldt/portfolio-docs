---
title: 'Portfolio App: Deployment'
description: 'Deployment model for the Portfolio App: CI quality gates, Vercel environments, production promotion checks, and rollback posture.'
sidebar_position: 3
tags: [projects, deployment, cicd, vercel, github-actions, governance]
---

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

- CI governance ADR (create): `docs/10-architecture/adr/`
- Ops runbooks (to create): `docs/50-operations/runbooks/`
- Documentation App deployment governance: `docs/60-projects/portfolio-docs-app/deployment.md`
