---
title: 'Portfolio App: Overview'
description: 'What the Portfolio App is, what it must prove, and how it will be evaluated by enterprise reviewers.'
sidebar_position: 1
tags: [projects, portfolio, product, evidence, governance, nextjs]
---

## Purpose

This page defines the Portfolio App as an enterprise-grade artifact: not only a personal website, but a working demonstration of:

- modern full-stack engineering (Next.js + TypeScript)
- delivery discipline (CI quality gates, PR governance)
- security hygiene (public-safe, supply chain posture, hardening)
- operational maturity (deploy/rollback readiness, troubleshooting)

## Scope

### In scope

- primary audiences and reviewer journey
- key outcomes and non-functional requirements (NFRs)
- evidence strategy and what “proof” means for this portfolio

### Out of scope

- detailed architecture diagrams (see `architecture.md`)
- operational procedures (see `operations.md` and runbooks)

## Prereqs / Inputs

- A public documentation system (Documentation App) that can host enterprise evidence
- A portfolio project strategy emphasizing verification-first artifacts (dossiers, ADRs, runbooks)
- Hosting target and domain strategy:
  - Portfolio App at root domain
  - Docs on `/docs` or a docs subdomain

## Procedure / Content

## Audience and reviewer journey

### Primary audiences

- Engineering leaders / hiring managers evaluating senior capability
- Staff/principal-level reviewers focused on architecture and operations maturity
- Security-minded reviewers assessing SDLC controls and hygiene
- Recruiters scanning for immediate fit and proof

### Reviewer journey (designed path)

1. **Landing page**: concise proposition + “Start Here”
2. **Interactive CV**: timeline, skills, impact, evidence links
3. **Projects**: curated list with “gold standard” project pages
4. **Evidence**: links into Docusaurus (dossiers, ADRs, threat models, runbooks)
5. **Operational credibility**: release notes, CI gates, deployment model

## Outcomes and success criteria

### Minimum viable outcomes (MVP)

- Fast, polished site with clear navigation
- `/cv` conveys “senior full-stack + enterprise” capability
- `/projects` contains at least one “gold standard” project case study
- Every project page includes:
  - what it is
  - what it demonstrates
  - repo/demo links
  - “Read the dossier” link to Docusaurus
- CI gating is enforced (quality + build)
- Vercel production promotion is gated on checks

### Non-functional requirements (NFRs)

- Performance: fast initial load; optimized images/assets; minimal JS
- Accessibility: semantic HTML, keyboard navigation, contrast compliance
- Maintainability: data-driven project pages; consistent layout components
- Reliability: deterministic builds; repeatable deploys; rollback readiness
- Security: strict no-secrets posture; dependency hygiene; hardened headers (as appropriate)

## Evidence strategy (“show, don’t tell”)

### Evidence must be concrete and reproducible

Every significant claim should map to one of:

- project dossier pages
- ADRs and architecture references
- threat models and SDLC controls
- runbooks and operational readiness
- release notes showing ongoing maintenance

### What the Portfolio App proves by existing

- Modern web engineering competency (Next.js, TS, UI patterns)
- Enterprise doc discipline (integrated evidence links)
- Delivery maturity (CI + promotion checks)
- Security awareness (safe content, hardening, dependency hygiene)

## Validation / Expected outcomes

- A third-party reviewer can quickly verify:
  - builds and quality gates exist
  - evidence artifacts exist and are coherent
  - operational documents match the implemented reality
- The site remains maintainable as the number of projects grows

## Failure modes / Troubleshooting

- Portfolio becomes “marketing-only” → add evidence links and reproducibility steps
- Too much content with no structure → enforce templates and taxonomy
- Drifting CI gates / stale runbooks → treat as defects; update as part of change PRs

## References

- Portfolio program overview: `docs/00-portfolio/index.md`
- Evidence engine dossier: `docs/60-projects/portfolio-docs-app/index.md`
- Templates (internal-only): `docs/_meta/templates/`
