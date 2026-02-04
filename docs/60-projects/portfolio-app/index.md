---
title: 'Project Dossier: Portfolio App'
description: 'Enterprise-grade TypeScript portfolio web application (Next.js) serving as an interactive CV and a platform to showcase verified project evidence.'
sidebar_position: 0
tags: [projects, portfolio, nextjs, typescript, devops, security, operations]
---

## Dossier Contents

- [Overview](01-overview.md)
- [Architecture](02-architecture.md)
- [Deployment](03-deployment.md)
- [Security](04-security.md)
- [Testing](05-testing.md)
- [Operations](06-operations.md)
- [Troubleshooting](07-troubleshooting.md)

## Purpose

This dossier documents the **Portfolio App**: a production-quality TypeScript web application that serves as:

- an **interactive CV** and professional public landing experience
- a platform to showcase **projects** (Python, Java, C++, etc.) with strong evidence and reproducibility
- a working exemplar of **enterprise SDLC**, including CI quality gates, security hygiene, and operational readiness

The Portfolio App is intentionally paired with the **Portfolio Documentation App (Docusaurus)**, which serves as the evidence engine for deep technical documentation, governance artifacts, and operational procedures.

## Scope

### In scope

- architecture and content model for the Portfolio App
- deployment model and release governance (Vercel + checks)
- quality gates (lint/format/typecheck/build; tests phased)
- security posture for a public site with no authentication
- operations posture: runbooks, troubleshooting, DR assumptions

### Out of scope

- authentication/authorization (explicitly deferred)
- contact form and backend services (deferred; static contact mechanism only)
- complex data stores (initially static content / lightweight data sources)

## Prereqs / Inputs

- Portfolio program documentation system exists (Docusaurus)
- GitHub repository for Portfolio App with PR discipline and CI gates
- Hosting: Vercel (preview + production), with production on the root domain
- Docs hosting: Documentation App on `/docs` or a docs subdomain

## Procedure / Content

### Dossier structure (this folder)

- `overview.md` — product framing, scope, NFRs, evidence map
- `architecture.md` — system design, content model, component boundaries
- `deployment.md` — CI/CD contract, environments, release governance, domains
- `security.md` — threat surface and enforceable controls (public-safe)
- `testing.md` — quality gate definitions and test strategy (phased)
- `operations.md` — runbooks, maintenance cadence, recovery assumptions
- `troubleshooting.md` — common failure modes and deterministic fixes

### Relationship to the Documentation App

- Portfolio App: “front-of-house” product experience (fast, polished)
- Documentation App: “enterprise evidence engine” (ADRs, threat models, runbooks, dossiers)

Portfolio App must link to evidence pages for each project:

- “Read the dossier”
- “See the threat model”
- “View runbooks / release notes”

## Current State

- Route skeleton implemented: `/`, `/cv`, `/projects`, `/projects/[slug]`, `/contact`.
- CI gates enforced: `ci / quality` and `ci / build` with required checks and frozen lockfile installs.
- Evidence artifacts complete: ADRs, threat model, runbooks, and dossier pages updated through Phase 4.
- Observability and operational readiness documented with health checks and MTTR runbooks.
- UX/SEO/theming upgrades documented with references and decision records.

## Evidence map (review-first)

- ADRs: [/docs/10-architecture/adr/](/docs/10-architecture/adr/)
- Threat model: [/docs/40-security/threat-models/portfolio-app-threat-model-v2.md](/docs/40-security/threat-models/portfolio-app-threat-model-v2.md)
- Runbooks: [/docs/50-operations/runbooks/index.md](/docs/50-operations/runbooks/index.md)
- CI/CD governance: [/docs/30-devops-platform/ci-cd-pipeline-overview.md](/docs/30-devops-platform/ci-cd-pipeline-overview.md)

## See also (appendices)

- [Appendix: Progress & completion log](/docs/60-projects/portfolio-app/appendix-progress.md)
- [Appendix: Metrics & quality signals](/docs/60-projects/portfolio-app/appendix-metrics.md)

## Reviewer path

- Open the Portfolio App repo and inspect CI workflows (`ci`, CodeQL, Dependabot) for required checks and naming stability.
- Review PR discipline and branch protection/ruleset settings to confirm required checks are enforced.
- Validate build determinism locally with `pnpm lint`, `pnpm format:check`, `pnpm typecheck`, `pnpm build` (frozen lockfile).
- Follow evidence links from the app into this dossier, ADR index, threat model, and runbooks to confirm traceability.
- **Review the [Threat Model](/docs/40-security/threat-models/portfolio-app-threat-model.md)** to understand security assumptions and mitigations across STRIDE categories.

## Validation / Expected outcomes

- A reviewer can understand value, role, and proof within 2 minutes
- The app is deployable with reproducible builds and CI gating
- Every showcased project links to documented evidence and reproducible steps
- Governance artifacts exist and are maintained as the app evolves

## Failure modes / Troubleshooting

- Broken deployments due to routing/base path mismatch → see `deployment.md` + runbooks
- Build failures due to lint/format/typecheck drift → see `testing.md`
- Content drift / stale project pages → enforce release notes and dossier updates

## References

- Documentation App (evidence engine): `docs/60-projects/portfolio-docs-app/`
- ADRs: `docs/10-architecture/adr/`
- Threat models: `docs/40-security/threat-models/`
- Runbooks: `docs/50-operations/runbooks/`
- Release notes: `docs/00-portfolio/release-notes/`
