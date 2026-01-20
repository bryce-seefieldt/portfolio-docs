---
title: 'Portfolio Docs: Overview'
description: 'What the Portfolio Docs App is, why it exists, and what it proves — plus the minimum viable enterprise outcomes and evidence expectations.'
sidebar_position: 1
collapsible: true
collapsed: true
tags: [projects, documentation, docusaurus, governance, portfolio]
---

## Purpose

This page frames the Portfolio Docs App as a portfolio-quality deliverable: a public documentation platform that demonstrates enterprise-grade process, governance, and operational maturity.

It answers:

- What is this system?
- Why is it built this way?
- What outcomes are required to claim “enterprise-grade”?
- What evidence artifacts must exist to support those claims?

## Scope

### In scope

- product framing and success criteria
- non-functional requirements (NFRs)
- quality and governance expectations
- evidence map (what artifacts should exist and where)

### Out of scope

- detailed Docusaurus configuration (covered in `architecture.md` and `deployment.md`)
- security threat enumeration (covered in `security.md`)

## Prereqs / Inputs

- Docusaurus project scaffolded and runnable locally (`pnpm start`)
- Root docs landing page exists (`docs/index.md`)
- Portfolio domain exists and is categorized (`docs/00-portfolio/`)
- Projects domain exists (`docs/60-projects/`) with category metadata

## Procedure / Content

## System definition

The Portfolio Docs App is a Docusaurus site that publishes a structured, version-controlled documentation corpus for:

- the portfolio web application (primary product)
- supporting demo projects (secondary artifacts)
- enterprise evidence artifacts (ADRs, threat models, runbooks, postmortems)
- engineering, DevOps, security, and operations standards

### Why Docusaurus

Docusaurus is well-suited because it supports:

- Markdown-first authoring at scale
- hierarchical, filesystem-driven navigation
- versioned documentation patterns (optional, if adopted later)
- strong developer experience for building a polished public site
- environment-driven configuration for portability across deployment environments

### Environment Variable Support

The Portfolio Docs App is configured to support local, preview, and production environments through environment variables:

- **`DOCUSAURUS_SITE_URL`**: Base URL (production: Vercel domain; local: `http://localhost:3000`)
- **`DOCUSAURUS_BASE_URL`**: Subpath (default: `/`)
- **`DOCUSAURUS_GITHUB_ORG`**, **`DOCUSAURUS_GITHUB_REPO_DOCS`**, **`DOCUSAURUS_GITHUB_REPO_APP`**: GitHub links
- **`DOCUSAURUS_PORTFOLIO_APP_URL`**: Cross-repository linking to portfolio-app

**Setup:**
- Local development: Copy `.env.example` to `.env.local` and configure for local testing
- Production: Set variables in Vercel dashboard
- See [Environment Variables Contract](https://github.com/bryce-seefieldt/portfolio-docs/blob/main/docs/_meta/env/portfolio-docs-env-contract.md) for complete reference

## Success criteria

### Minimum viable enterprise outcomes

The documentation system must be able to demonstrate:

1. **Governance**
   - PR-only merges to `main`
   - explicit contribution rules and page shape standards
   - consistent navigation and taxonomy

2. **Quality gates**
   - `pnpm build` must succeed prior to merge (broken links fail the build)
   - consistent formatting and lint discipline for Markdown

3. **Security hygiene**
   - no secrets committed
   - dependency/supply chain risk posture documented and enforced
   - content injection risks controlled (especially if MDX is used)

4. **Operational readiness**
   - deterministic deploy and rollback procedures
   - recoverability from repository state (Git is the system of record)
   - predictable maintenance (dependency updates, link rot management)

### Non-functional requirements (NFRs)

- **Reliability:** site build is deterministic; deployment is repeatable
- **Maintainability:** scale to large doc sets without manual sidebar curation
- **Usability:** clear “start here” path for reviewers; consistent doc structure
- **Security:** public-safe content only; enforceable SDLC controls
- **Traceability:** decisions and changes produce durable artifacts (ADRs, release notes)

## Evidence map (what must exist)

The Portfolio Docs App should eventually be supported by these artifacts:

- ADRs (architecture decisions)
  - example topics: Docusaurus choice, nav strategy, hosting strategy, quality gates
  - location: `docs/10-architecture/adr/`

- Threat model (docs platform threat surface)
  - location: `docs/40-security/threat-models/`

- Runbooks (operations)
  - deploy, rollback, broken-link triage
  - location: `docs/50-operations/runbooks/`

- Pipeline overview and quality gates
  - location: `docs/30-devops-platform/ci-cd/`

- Release notes for the documentation system
  - location: `docs/00-portfolio/release-notes/`

## Validation / Expected outcomes

At a minimum:

- `pnpm start` launches the site locally and renders sidebar navigation coherently
- `pnpm build` succeeds consistently
- A reviewer can:
  - understand purpose and structure within 2 minutes from `docs/index.md`
  - navigate to “Projects → Documentation App” and see a coherent dossier
  - find evidence artifacts by domain section (even if some are early stubs)

## Failure modes / Troubleshooting

- **Over-documentation too early:** page volume grows without evidence → prioritize core artifacts and validation procedures first.
- **Governance drift:** inconsistent structure or naming → enforce templates and PR checklists.
- **Navigation entropy:** too many folders without hubs → require `_category_.json` and `index.md` hubs for durable sections.

## References

- Dossier hub: `docs/60-projects/portfolio-docs-app/index.md`
- Style and taxonomy (internal-only): `docs/_meta/doc-style-guide.md`, `docs/_meta/taxonomy-and-tagging.md`
- Core navigation entry: `docs/index.md`
