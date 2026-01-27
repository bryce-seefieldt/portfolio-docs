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

## Deployment & Environments (Stage 4.1)

- **Environment tiers:** preview (auto) → staging (manual) → production (manual)
- **Promotion gates:** manual workflows validate env, registry, build, tests
- **Immutable builds:** same artifact promoted; avoids environment drift
- **Evidence:** ADR-0013 and runbooks document the flow and rollback

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

### Evidence-First Component Library (Stage 3.2)

The Portfolio App introduces a reusable component library for standardized evidence linking:

- **EvidenceBlock.tsx** renders project evidence artifacts (dossiers, threat models, ADRs, runbooks) in a responsive grid, enabling reviewers to verify completeness at a glance.
- **VerificationBadge.tsx** displays status indicators (docs-available, threat-model-complete, gold-standard-status, adr-complete) to signal evidence quality.
- **BadgeGroup.tsx** conditionally aggregates multiple evidence badges for quick scanning.

Together, these components embed evidence verification into the user experience, making "show your work" a visual, interactive expectation rather than a hidden link hunt.

See [Architecture — Evidence Visualization Layer](/docs/60-projects/portfolio-app/02-architecture.md#evidence-visualization-layer-stage-32) for full details.

### Security Posture Hardening (Stage 4.4)

Stage 4.4 extends the portfolio app's security posture with OWASP-recommended HTTP security headers, Content Security Policy enforcement, threat model extension to cover deployment and runtime risks, and formal dependency audit policy. This demonstrates security-first delivery discipline.

**Key implementations:**

- OWASP security headers (X-Frame-Options, X-Content-Type-Options, CSP) configured in `next.config.ts`
- Content Security Policy with `default-src 'self'` to prevent XSS
- Environment variable security contract (no secrets in `NEXT_PUBLIC_*`)
- Threat model v2 covering deployment, runtime, and supply chain threats
- Formal dependency vulnerability audit policy with MTTR targets

See [Security Hardening Documentation](/docs/60-projects/portfolio-app/09-security-hardening.md) for implementation details.

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

- **Lines of code:** ~500 (application), ~600 (tests: 70+ unit tests, 12 E2E tests)
- **Routes:** 5 core routes (/, /cv, /projects, /contact, /projects/[slug])
- **CI checks:** 5 required (quality, secrets-scan, test, build, CodeQL)
- **Test coverage:** 70+ unit tests (≥80% coverage), 12 E2E tests (100% route coverage)
- **Deployment frequency:** On every merge to main (automatic)
- **Mean time to rollback:** ~1 minute (Git revert + CI)
- **Quality gates:** Lint, format, typecheck, registry validation, unit tests, E2E tests, secrets scan, build (all enforced)
- **Dependencies:** ~17 production, ~15 dev (Dependabot weekly updates)

## Performance Metrics (Phase 4 Stage 4.2)

- **Build time:** ~3.5s (TypeScript compile + static generation)
- **Bundle size:** 27.8 MB total JavaScript (CI enforces 10% growth threshold)
- **Static generation:** All project pages pre-rendered at build time with 1-hour ISR
- **Cache strategy:** HTTP Cache-Control headers (max-age=3600, stale-while-revalidate=86400)
- **Core Web Vitals targets:** LCP < 2.5s, FID < 100ms, CLS < 0.1
- **Performance baseline:** Documented in [portfolio-app/docs/performance-baseline.md](https://github.com/bryce-seefieldt/portfolio-app/blob/main/docs/performance-baseline.md)
- **Monitoring:** Vercel Analytics dashboard for real-world Core Web Vitals data

## What This Project Proves

### Technical Competency

- Modern full-stack web development (Next.js 15+, React 19+, TypeScript 5+)
- Component-driven architecture with App Router
- Responsive design with Tailwind CSS
- Evidence-first UX (deep links to documentation)
- Performance optimization (static generation with ISR, HTTP caching, bundle size regression detection)

### Engineering Discipline

- CI quality gates (ESLint max-warnings=0, Prettier, TypeScript strict)
- Automated unit testing (Vitest: 70+ tests for registry, links, slugs)
- Automated E2E testing (Playwright: 12 multi-browser smoke tests)
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

## Quality Standards (Stage 3.3)

### Testing Strategy

The Portfolio App implements a comprehensive testing pyramid:

- **Unit tests (Vitest):** 70+ tests covering registry validation, link construction, and slug validation
- **E2E tests (Playwright):** 12 multi-browser smoke tests verifying all routes and evidence links
- **Coverage targets:** ≥80% for `src/lib/` (utility functions), 100% route coverage for E2E
- **CI integration:** Tests run on every PR and merge; failures block deployment

See [Testing Guide](/docs/reference/testing-guide) for comprehensive patterns, setup, and troubleshooting. Implementation details available in [Testing — Phase 3](/docs/60-projects/portfolio-app/05-testing.md#phase-3-unit-tests-implemented--stage-33).

### Code Quality Gates

All required checks must pass before merge (GitHub Ruleset enforcement):

1. **Lint:** ESLint with `max-warnings=0` (zero-tolerance linting)
2. **Format:** Prettier with auto-format enforcement
3. **Type safety:** TypeScript strict mode (no `any`)
4. **Build:** Next.js compilation succeeds
5. **Unit tests:** Vitest suite passes + ≥80% coverage thresholds met
6. **E2E tests:** Playwright tests pass across Chromium, Firefox (12 tests)
7. **Secrets:** TruffleHog scans with `--only-verified` flag
8. **Supply chain:** CodeQL + Dependabot for dependency hygiene

### CI/CD Pipeline

The GitHub Actions workflow orchestrates quality gates with job dependencies:

```
quality (lint, format, typecheck)
  ↓
secrets-scan (TruffleHog --only-verified)
  ↓
test (unit tests + E2E tests)
  ├─ pnpm test:unit (70+ Vitest tests)
  └─ pnpm playwright test (12 E2E tests)
  ↓
build (Next.js compile + Vercel deploy)
```

All jobs must pass; failures block subsequent stages. Tests are separated into distinct steps for clarity:

- **Unit tests** validate data integrity, link construction, and slug validation
- **E2E tests** validate route rendering, evidence link resolution, and component behavior

See [CI/CD Pipeline Overview](/docs/devops-platform/ci-cd-pipeline-overview) for detailed job configuration and troubleshooting.

### Evidence of Quality

- **Public CI visibility:** All checks displayed on PR and commit
- **Test artifacts:** Coverage reports and E2E traces available in CI logs
- **Release notes:** Every deployment includes documented changes and impact
- **Runbooks:** CI failure triage, secrets incident response, and deploy procedures
