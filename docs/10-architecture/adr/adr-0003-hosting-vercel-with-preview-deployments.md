---
title: "ADR-0003: Host Portfolio Docs App on Vercel with Preview Deployments"
description: "Decision to host the Docusaurus documentation site on Vercel, enabling PR preview deployments and main-branch production publishing."
sidebar_position: 3
tags: [architecture, adr, hosting, deployment, vercel, cicd]
---

## Purpose

Record the decision to host the Portfolio Docs App on **Vercel** with preview deployments for pull requests and production deploys from `main`.

## Scope

### Use when
- selecting the public hosting strategy for the documentation platform
- defining the deployment experience that supports review and quality gates

### Do not use when
- changing small build commands or minor CI tweaks unless they affect hosting posture

## Prereqs / Inputs

- Decision owner(s): Portfolio maintainer
- Date: 2026-01-06
- Status: Accepted
- Related risks:
  - misconfiguration leading to broken routing or base path confusion
  - deployment drift between preview and production
  - accidental exposure of sensitive data via build logs (must avoid)

## Decision Record

### Title
ADR-0003: Host Portfolio Docs App on Vercel with Preview Deployments

### Context

The Portfolio Docs App must be publicly accessible and demonstrate:

- professional delivery workflows
- PR-based review with preview capability
- stable production publishing from `main`
- simple rollback through Git history

We prefer free or low-cost hosting suitable for a public portfolio, while still conveying enterprise delivery discipline.

### Decision

Host the Portfolio Docs App on **Vercel**, configured to:

- deploy preview builds for PR branches (review environment)
- deploy production from `main` (published environment)
- enforce the build contract:
  - `pnpm install`
  - `pnpm build`

The primary rollback mechanism is reverting changes on `main` and redeploying.

### Alternatives considered

1. **GitHub Pages**
   - Pros:
     - free static hosting; simple
     - aligns well with static site workflows
   - Cons:
     - preview deployments are less seamless
     - can require additional base path considerations
   - Why not chosen:
     - Vercel offers a stronger “enterprise delivery feel” via PR previews.

2. **Netlify**
   - Pros:
     - strong static hosting; preview deployments supported
   - Cons:
     - comparable to Vercel; preference depends on existing workflow
   - Why not chosen:
     - Vercel selected to align with common modern full-stack portfolio hosting patterns.

3. **Self-hosting (VM/container)**
   - Pros:
     - maximum control
   - Cons:
     - operational overhead not justified for a docs site at this stage
     - distracts from the portfolio program’s primary objectives
   - Why not chosen:
     - disproportionate operational complexity for the value delivered.

### Consequences

- Positive consequences:
  - PR previews support high-quality doc review and reduce merge risk
  - Production publishes from `main`, matching enterprise “source of truth” discipline
  - Rollback is straightforward: revert PR → redeploy
  - Hosting is well-aligned with modern developer portfolio expectations

- Negative consequences / tradeoffs:
  - Hosting behavior is vendor-dependent
  - Must avoid documenting sensitive hosting configuration details publicly
  - Must ensure route base path decisions are made early and kept consistent

- Operational impact:
  - Deploy/rollback runbooks required
  - Build failures block deploy; triage process required

- Security impact:
  - No secrets in repo; minimize sensitive environment variables
  - CI/log outputs must avoid leaking identifiers
  - Dependency/supply chain and PR integrity remain key threats

### Implementation notes (high-level)

- Decide and document `routeBasePath` strategy early (docs at `/` vs `/docs`).
- Configure Vercel build:
  - install: `pnpm install`
  - build: `pnpm build`
- Configure PR previews:
  - reviewers validate navigation, rendering, and key pages prior to merge.
- Ensure runbooks exist:
  - deploy
  - rollback
  - broken-link triage

## Validation / Expected outcomes

- PR branches produce a preview deployment suitable for review
- `main` publishes production docs deterministically
- Rollback can be executed quickly via Git revert + redeploy
- Deployments do not expose secrets, internal endpoints, or sensitive logs

## Failure modes / Troubleshooting

- Base path mismatch between local and hosting:
  - mitigation: keep a stable routeBasePath decision; document it.
- Preview/prod drift:
  - mitigation: same build command and env settings; validate via `pnpm build`.
- Hosting outage:
  - mitigation: redeploy; consider fallback hosting if required for continuity.

## References

- Deployment dossier page: `docs/60-projects/portfolios-docs-app/deployment.md`
- Operations runbooks: `docs/50-operations/runbooks/`
- DevOps platform docs: `docs/30-devops-platform/`
