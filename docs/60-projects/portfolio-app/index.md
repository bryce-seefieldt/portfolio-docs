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

### Current State (Phase 3, Stage 6)

- ✅ **Route skeleton**: 5 core routes implemented and fully tested
- ✅ **CI quality gates**: lint, format, typecheck, secrets-scan, registry validation, unit tests, E2E tests, build (all enforced)
- ✅ **Unit test coverage**: 70+ Vitest tests (registry validation, slug helpers, link construction) with ≥80% code coverage
- ✅ **E2E test coverage**: 12 Playwright tests across Chromium, Firefox (100% route coverage + evidence link validation)
- ✅ **Comprehensive testing**: verify script with 11-step validation workflow (perf budgets + tests); verify:quick for fast iteration (skips performance checks and all tests)
- ✅ **Secrets scanning**: CI gate via TruffleHog (PR-only); optional pre-commit hook. Local verify uses lightweight pattern scan.
- ✅ **Security hardening**: Least-privilege CI permissions, CodeQL, Dependabot
- ✅ **Deployment governance**: Vercel promotion gated by required checks (quality, test, build)
- ✅ **Dossier enhancement**: All 7 pages updated to gold standard (Phase 2)
  - Executive summary, key metrics, "what this proves" framework
  - Comprehensive tech stack table with 16+ dependencies
  - Mermaid flow diagrams for request routing
  - Security controls table with 10+ enforced controls
- ✅ **Testing documentation**: Complete testing guide, architecture section, operations guidance (Stage 3.3)
- ✅ **Threat model**: Complete STRIDE analysis with 12 threat scenarios
- ✅ **Incident response**: Secrets incident runbook (5-phase procedure)
- ✅ **Enhanced project page**: Complete (Priority 3 - gold standard badge with verification checklist)
  - GoldStandardBadge component with amber theme
  - Conditional rendering for portfolio-app slug
  - 4 comprehensive sections: What This Proves, Verification Checklist, Deep Evidence, Tech Stack
  - Enhanced Callout component with type="info" support
- ✅ **Meaningful CV page**: Complete (Priority 4 - capability-to-proof timeline mapping)
  - Evidence-first timeline structure with 2 entries
  - 17 total key capabilities mapped to 9 proof links
  - Each role links to dossiers, threat models, runbooks, ADRs, CI workflows, test suites
  - Evidence Hubs section for comprehensive navigation
- ✅ **Link validation in CI**: Complete (Stage 3.5 - evidence URL integrity assurance)
  - New `link-validation` CI job running after quality checks, before build
  - Validates registry schema via `pnpm registry:validate`
  - Validates all evidence links via `pnpm links:check` (Playwright-based, 12 checks)
  - Build gate: promotion depends on link-validation success
  - Playwright artifacts retained 7 days for troubleshooting
  - Local validation: `pnpm verify` includes link validation as Step 9
- ✅ **Project publication runbooks**: Complete (Stage 3.5 - operational governance)
  - Project Publish Runbook (`rbk-portfolio-project-publish.md`): 6-phase, time-boxed procedure (3 hours)
    - Planning → Registry Entry → Dossier Update → Link Validation → PR/Review → Post-Publish
    - Validation signals: registry:validate, links:check, pnpm build
    - Includes rollback and abort procedures
  - Troubleshooting Guide (`troubleshooting-portfolio-publish.md`): 5 common failure modes with actionable fixes
    - Invalid slugs, broken dossier links, missing evidence URLs, schema validation, CI flakiness
    - Maps each to specific pnpm commands and expected outputs
    - References playwright-report artifacts for debugging
- ✅ **Social metadata & analytics**: Complete (Stage 3.6)
  - Open Graph + Twitter Cards configured globally and per project (site-wide defaults + generateMetadata per slug)
  - Vercel Web Analytics integrated (privacy-safe, no cookies/PII); access via Vercel Analytics tab
  - Metadata unit tests added (19 tests) covering OG/Twitter defaults, URL construction, fallbacks, special characters
  - Social metadata reference guide published; dossier updated with analytics and metadata context
- ✅ **Observability & Operational Readiness**: Complete (Stage 4.3)
  - **Health Check Endpoint**: `/api/health` returns 200/503/500 with status, projectCount, environment metadata
  - **Structured Logging**: JSON logs via `src/lib/observability.ts` (log(), logError()) integrated into error boundaries
  - **Observability Architecture**: Complete reference documentation ([Observability & Health Checks](/docs/30-devops-platform/observability-health-checks.md)) covering health checks, logging, failure modes, monitoring integration
  - **Operational Runbooks**: 3 comprehensive procedures with MTTR targets
    - [General Incident Response](../../50-operations/runbooks/rbk-portfolio-incident-response.md) — Framework for all incidents (severity levels, triage, postmortem)
    - [Service Degradation](../../50-operations/runbooks/rbk-portfolio-service-degradation.md) — Diagnose and resolve performance/availability issues (MTTR: 10 min)
    - [Deployment Failure Recovery](../../50-operations/runbooks/rbk-portfolio-deployment-failure.md) — Detect and rollback failed deployments (MTTR: 5 min)

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
