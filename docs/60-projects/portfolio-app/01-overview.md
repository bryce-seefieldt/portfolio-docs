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

---

## Executive Summary

The Portfolio App is a production TypeScript web application that serves as an interactive CV and project showcase, intentionally designed to demonstrate enterprise-grade engineering discipline. Built with Next.js and deployed on Vercel with comprehensive CI/CD governance, it proves competency across modern web development, security hygiene, operational maturity, and evidence-first documentation practices.

Key value: Not just a portfolio site—a working exemplar of how senior engineers build, secure, operate, and document production systems.

## Key Metrics (Phase 2 Baseline)

- **Lines of code:** ~500 (application), ~200 (tests)
- **Routes:** 5 core routes (/, /cv, /projects, /contact, /projects/[slug])
- **CI checks:** 4 required (quality, secrets-scan, build w/smoke tests, CodeQL)
- **Test coverage:** 100% route coverage (Playwright smoke tests - 12 tests)
- **Deployment frequency:** On every merge to main (automatic)
- **Mean time to rollback:** ~1 minute (Git revert + CI)
- **Quality gates:** Lint, format, typecheck, secrets scan, build, smoke tests (all enforced)
- **Dependencies:** ~17 production, ~15 dev (Dependabot weekly updates)

## What This Project Proves

### Technical Competency

- Modern full-stack web development (Next.js 15+, React 19+, TypeScript 5+)
- Component-driven architecture with App Router
- Responsive design with Tailwind CSS
- Evidence-first UX (deep links to documentation)

### Engineering Discipline

- CI quality gates (ESLint max-warnings=0, Prettier, TypeScript strict)
- Automated smoke testing (Playwright multi-browser)
- Secrets scanning (CI gate via TruffleHog; optional pre-commit; local verify uses a lightweight pattern scan)
- Frozen lockfile installs (deterministic builds)
- PR-only merge discipline (GitHub Ruleset enforcement)

### Security Awareness

- Public-safe by design (no secrets, internal endpoints, or auth)
- CodeQL + Dependabot enabled (supply chain hardening)
- Least-privilege CI permissions (scoped per job)
- Environment variable hygiene (documented, validated)
- Secrets incident response runbook

### Operational Maturity

- Deploy/rollback runbooks (tested and documented)
- CI triage procedures (deterministic troubleshooting)
- Secrets incident response (5-phase procedure)
- Vercel production promotion gating (required checks)
- Evidence-based release notes

### Documentation Excellence

- Complete dossier (7 comprehensive pages)
- ADRs for durable decisions (hosting, CI gates, testing strategy, gold standard choice)
- Threat model (STRIDE analysis with 12 threat scenarios)
- Operational runbooks (deploy, secrets incident, CI triage, rollback)
