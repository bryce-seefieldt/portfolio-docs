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

## Routing and UX architecture (recommended)

- `/` — landing, “Start Here,” primary narrative
- `/cv` — interactive CV (timeline + skill proof)
- `/projects` — curated gallery
- `/projects/[slug]` — project details (evidence links)
- `/labs` — experiments / prototypes / R&D notes (optional)
- `/security` — public security posture summary (high-level, safe)
- `/contact` — static contact method (no auth, no form initially)

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
