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
- Public-safe config contract in place via `NEXT_PUBLIC_*` envs and centralized helpers (see Portfolio App `src/lib/config.ts`).
- CI gates enforced: `ci / quality` (lint, format check, typecheck) → `ci / build` (Next build), frozen lockfile installs.
- CodeQL and Dependabot baselines present; branch protection/ruleset requires required checks before merge.

### Current State (Phase 2)

- ✅ **Route skeleton**: 5 core routes implemented and smoke-tested
- ✅ **CI quality gates**: lint, format, typecheck, secrets-scan, build with smoke tests (all enforced)
- ✅ **Smoke test coverage**: 100% routes (12 tests, Chromium + Firefox)
- ✅ **Secrets scanning**: TruffleHog CI gate + pre-commit hook configured
- ✅ **Security hardening**: Least-privilege CI permissions, CodeQL, Dependabot
- ✅ **Deployment governance**: Vercel promotion gated by required checks
- ✅ **Dossier enhancement**: All 7 pages updated to gold standard (Phase 2)
  - Executive summary, key metrics, "what this proves" framework
  - Comprehensive tech stack table with 16+ dependencies
  - Mermaid flow diagrams for request routing
  - Security controls table with 10+ enforced controls
- ✅ **Threat model**: Complete STRIDE analysis with 12 threat scenarios
- ✅ **Incident response**: Secrets incident runbook (5-phase procedure)
- 🟡 **Enhanced project page**: Planned (Priority 3 - gold standard badge)
- 🟡 **Meaningful CV page**: Planned (Priority 4 - capability-to-proof mapping)

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
