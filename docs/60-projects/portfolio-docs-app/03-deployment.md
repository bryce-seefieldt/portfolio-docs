---
title: "Portfolio Docs: Deployment"
description: "Delivery model for the Portfolio Docs App: CI/CD contract, environments, hosting expectations, release discipline, and rollback posture."
sidebar_position: 3
tags: [projects, devops, cicd, deployment, vercel, github-actions]
---

## Purpose

This page documents how the Portfolio Docs App is built and deployed as a production-like service, including:

- the pipeline contract (what must run, what must pass)
- environment strategy (preview vs production)
- release discipline and versioned documentation updates
- rollback and recovery posture

## Scope

### In scope
- CI/CD stages and required checks
- hosting model (high-level, public-safe)
- preview deployments and PR workflow
- release notes discipline and what constitutes a “release”
- rollback posture and expected recovery steps

### Out of scope
- vendor-specific secrets, tokens, or account details
- deep security control detail (see `security.md`)
- operational runbook step-by-step commands (see `operations.md`)

## Prereqs / Inputs

- Docusaurus site builds locally:
  - `pnpm start`
  - `pnpm build`
- PR-only merge workflow to `main`
- A hosting target selected (e.g., Vercel) and connected via Git integration (public-safe assumption)
- Repository includes a CI workflow that runs at least the required gates

## Procedure / Content

## Delivery model (contract)

### Minimum pipeline contract (required)
Every PR must satisfy:

1. Install dependencies (deterministic)
2. Build docs site:
   - `pnpm build`
3. Enforce content quality checks (recommended):
   - Markdown lint
   - Format check
   - Optional link check beyond Docusaurus internal checks

The **build is the primary gate**: it must fail on broken links or invalid docs structure.

### Recommended CI workflow triggers
- On pull requests targeting `main`
- On pushes to `main` (to produce the deployable artifact)

## Environment strategy

### Preview environment (PR branches)
- Every PR should have a preview build/deployment where possible.
- Objective:
  - validate navigation, rendering, and content coherence before merge

### Production environment (`main`)
- `main` represents the published documentation.
- Deployment should be:
  - automatic on merge, or
  - manual with explicit release procedure (only if you need additional control)

## Hosting expectations (public-safe)

### Primary target: Vercel (recommended)
Vercel is well-suited for:
- static site hosting with fast global delivery
- branch preview deployments
- simple integration with GitHub PRs

(Do not document account identifiers, secrets, or private configuration.)

### Alternative target (fallback)
- GitHub Pages is a viable fallback for a pure static doc site.

## Release discipline

### What constitutes a “release” for docs?
Any meaningful change that affects:
- information architecture
- governance rules
- security posture documentation
- operational procedures
- public-facing portfolio claims

…should update release notes under:
- `docs/00-portfolio/release-notes/`

### Recommended release notes content
- what changed
- why it changed
- how to validate the change (review path and build verification)
- operational impact (if any)

## Rollback posture

### Rollback strategy (minimum viable)
- Primary rollback mechanism is **Git revert** of the offending PR on `main`.
- Production hosting should redeploy automatically from the corrected `main`.

### Rollback triggers
- broken site rendering
- navigation corruption
- accidental publication of sensitive content (treat as security incident)
- major factual correction required

## Validation / Expected outcomes

Deployment model is correct when:
- PRs cannot merge without a passing `pnpm build`
- preview builds are available or reproducible locally
- production publishes from `main` deterministically
- rollback is documented, simple, and fast

## Failure modes / Troubleshooting

- **Build passes locally but fails in CI:** environment mismatch → pin node/pnpm versions and document the expected toolchain.
- **Preview differs from production:** configuration drift → ensure build command and environment variables are consistent.
- **Broken links introduced:** Docusaurus build fails → fix links or remove premature references to uncreated pages.

## References

- CI/CD platform documentation: `docs/30-devops-platform/ci-cd/`
- Release discipline: `docs/00-portfolio/release-notes/`
- Operations runbooks for deploy/rollback: `docs/50-operations/runbooks/` (to be created)