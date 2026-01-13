---
title: 'Portfolio App: Architecture'
description: 'Architecture of the Portfolio App: Next.js boundaries, content model, evidence-link strategy, and scalability patterns.'
sidebar_position: 2
tags: [projects, architecture, nextjs, typescript, content-model, portfolio]
---

## Purpose

Describe the Portfolio App architecture at a level that is:

- specific enough to guide implementation
- credible to enterprise reviewers
- maintainable as the portfolio expands

## Scope

### In scope

- framework choice and major boundaries (Next.js App Router)
- routing and information architecture for the app
- content model for projects and CV data
- integration pattern with Documentation App evidence pages

### Out of scope

- CI/CD implementation details (see `deployment.md`)
- security threat enumeration (see `security.md`)

## Prereqs / Inputs

- Next.js (App Router) + TypeScript baseline planned
- Hosting target: Vercel
- Evidence engine exists in Docusaurus and is publicly accessible at `/docs` or a subdomain

## Procedure / Content

## System boundaries

### Portfolio App responsibilities (“front-of-house”)

- provide a polished, fast, product-like UX
- present core narrative: value proposition, CV, projects, contact
- link to evidence artifacts hosted in Docusaurus
- avoid overloading the app with long-form governance docs (keep evidence in docs engine)

### Documentation App responsibilities (“evidence engine”)

- host deep technical documentation:
  - dossiers, ADRs, threat models, runbooks, postmortems
- provide traceability and enterprise governance narrative

## Routing and UX architecture (recommended vs current)

Note: Items marked (implemented) exist in Phase 1. Items marked (planned) are illustrative and not yet implemented.

- `/` — landing, “Start Here,” primary narrative (implemented)
- `/cv` — interactive CV (timeline + skill proof) (implemented)
- `/projects` — curated gallery (implemented)
- `/projects/[slug]` — project details (evidence links) (implemented)
- `/contact` — static contact method (no auth, no form initially) (implemented)
- `/labs` — experiments / prototypes / R&D notes (optional) (planned)
- `/security` — public security posture summary (high-level, safe) (planned)

## Content model (pragmatic and scalable)

### Principle: data-driven content, components for presentation

Use structured data for:

- project list and metadata
- CV timeline entries
- skills and capability proof links
- evidence links mapping to Docusaurus paths

Recommended initial approach (low complexity):

- store project metadata in structured files (JSON/YAML/TS objects)
- generate pages from the data model with stable slugs
- keep long-form writeups in Docusaurus, linked from project pages

### Evidence-link strategy

Each project entry should include:

- repo URL
- demo URL (if applicable)
- “Read the dossier” URL (Docusaurus path)
- optional: threat model / runbook links

Example evidence link types:

- dossier: `/docs/60-projects/<project>/`
- ADR: `/docs/10-architecture/adr/adr-xxxx-...`
- threat model: `/docs/40-security/threat-models/<project>-threat-model`
- runbooks: `/docs/50-operations/runbooks/`

## Component boundaries (recommended)

- `app/` routes:
  - route-level layout and metadata
- `components/`:
  - design system primitives and page-level components
- `content/` (or `data/`):
  - structured portfolio metadata and project definitions
- `lib/`:
  - utilities and helpers (data validation, slug generation)
- `public/`:
  - static assets with stable names
- `tests/`:
  - unit and e2e tests (phased)

## Repository structure (current)

Key paths and roles in the Portfolio App repo:

- `src/app/*` — App Router pages and layouts (implemented routes):
  - `/` — landing
  - `/cv` — interactive CV scaffold
  - `/projects` — project index
  - `/projects/[slug]` — project details
  - `/contact` — static contact surface
- `src/lib/config.ts` — public-safe configuration contract and helpers:
  - reads `NEXT_PUBLIC_*` env vars
  - provides `DOCS_BASE_URL`, `docsUrl(path)`, and `mailtoUrl()`
  - normalizes/validates public URLs
- `src/data/projects.ts` — project registry placeholder:
  - stable slugs, titles, summaries, tags, status
  - optional evidence link paths into the Documentation App (dossier, ADR index, threat models, runbooks)

## Routing and evidence-link strategy

- Documentation base URL is configured via environment variable `NEXT_PUBLIC_DOCS_BASE_URL`.
- The app centralizes this via `src/lib/config.ts` and the `docsUrl()` helper to build stable evidence links.
- Project pages should derive evidence links from `src/data/projects.ts` where possible to keep slugs and paths consistent with the Documentation App.
- This separation keeps the Portfolio App concise while ensuring every major claim links to verifiable evidence in the docs site.

## Scalability considerations

- adding projects should be “cheap”:
  - add metadata + assets + evidence links; page generates automatically
- avoid heavy dynamic backend early:
  - keep the system static-first; add APIs only via ADR
- keep performance strong:
  - minimize client-side JS; prefer server components where appropriate

## Validation / Expected outcomes

- New project pages can be added without re-architecting routing
- Evidence links are consistent and trustworthy
- The app remains fast and accessible
- Architecture is explainable in a concise diagram and ADR(s)

## Failure modes / Troubleshooting

- Content sprawl inside the app → move long-form content into Docusaurus
- Inconsistent slugs and broken project routes → enforce slug rules and add tests
- Evidence links break due to docs reorg → treat as breaking change; update references and release notes

## References

- Portfolio App dossier hub: `docs/60-projects/portfolio-app/index.md`
- Documentation App dossier: `docs/60-projects/portfolio-docs-app/`
- ADRs: `docs/10-architecture/adr/`
