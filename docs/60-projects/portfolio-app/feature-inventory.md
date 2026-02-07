---
title: 'Portfolio App: Feature Inventory'
description: 'Guided tour of portfolio-app features sourced from roadmap, ADRs, runbooks, and implementation.'
sidebar_position: 10
tags: [projects, portfolio, features, guided-tour, nextjs]
---

## Purpose

Provide a single, reviewer-ready list of Portfolio App features and where each is implemented or documented. This is a guided tour that maps roadmap intent to concrete code, ADRs, and runbooks.

## Scope

### In scope

- user-facing features and UX behaviors
- evidence-first content model and components
- security, CI/CD, testing, and operational posture
- SEO, performance, and theming capabilities

### Out of scope

- full runbook procedures (link to runbooks instead)
- line-by-line code walk-throughs

---

## Guided tour: Features by capability

This inventory points to the detailed feature documentation in the portfolio features catalog.
Use these links as the canonical source for validation steps, test coverage, and evidence links.

- Core pages and reviewer journey: [/docs/00-portfolio/features/01-core-pages-reviewer-journey/index.md](/docs/00-portfolio/features/01-core-pages-reviewer-journey/index.md)
- Evidence-first content model: [/docs/00-portfolio/features/02-evidence-first-content-model/index.md](/docs/00-portfolio/features/02-evidence-first-content-model/index.md)
- Navigation and UX polish: [/docs/00-portfolio/features/03-navigation-ux-polish/index.md](/docs/00-portfolio/features/03-navigation-ux-polish/index.md)
- Theming and accessibility: [/docs/00-portfolio/features/04-theming-accessibility/index.md](/docs/00-portfolio/features/04-theming-accessibility/index.md)
- SEO, metadata, and structured data: [/docs/00-portfolio/features/05-seo-metadata-structured-data/index.md](/docs/00-portfolio/features/05-seo-metadata-structured-data/index.md)
- Security posture and hardening: [/docs/00-portfolio/features/06-security-posture-hardening/index.md](/docs/00-portfolio/features/06-security-posture-hardening/index.md)
- Testing and quality gates: [/docs/00-portfolio/features/07-testing-quality-gates/index.md](/docs/00-portfolio/features/07-testing-quality-gates/index.md)
- CI/CD and environment promotion: [/docs/00-portfolio/features/08-cicd-environment-promotion/index.md](/docs/00-portfolio/features/08-cicd-environment-promotion/index.md)
- Performance and observability: [/docs/00-portfolio/features/09-performance-observability/index.md](/docs/00-portfolio/features/09-performance-observability/index.md)
- Documentation and governance integration: [/docs/00-portfolio/features/10-docs-governance-integration/index.md](/docs/00-portfolio/features/10-docs-governance-integration/index.md)

---

## Roadmap-aligned planned features (not yet implemented)

These are explicitly documented as planned in the architecture and roadmap; keep this list current as items ship.

- Optional `/labs` and `/security` routes for experiments and public posture summaries in [Architecture](/docs/60-projects/portfolio-app/02-architecture.md#routing-and-ux-architecture-recommended-vs-current).
- Enhanced evidence analytics and link validation dashboards in [Architecture](/docs/60-projects/portfolio-app/02-architecture.md#future-extensions-post-stage-32).

## References

- Portfolio App dossier hub: [/docs/60-projects/portfolio-app/index.md](/docs/60-projects/portfolio-app/index.md)
- Architecture: [/docs/60-projects/portfolio-app/02-architecture.md](/docs/60-projects/portfolio-app/02-architecture.md)
- Security: [/docs/60-projects/portfolio-app/04-security.md](/docs/60-projects/portfolio-app/04-security.md)
- Testing: [/docs/60-projects/portfolio-app/05-testing.md](/docs/60-projects/portfolio-app/05-testing.md)
- Operations: [/docs/60-projects/portfolio-app/06-operations.md](/docs/60-projects/portfolio-app/06-operations.md)
