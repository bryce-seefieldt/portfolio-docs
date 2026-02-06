---
title: 'Feature Catalog'
description: 'Governance and index for portfolio-app feature documentation.'
sidebar_position: 3
tags: [portfolio, features, governance, evidence]
---

## Purpose

Provide a reviewer-friendly catalog of portfolio-app features with consistent, evidence-backed documentation. This section explains how feature pages are organized, what each page must contain, and how to validate claims.

## Scope

### In scope

- feature groups aligned to the feature inventory
- feature page governance and required fields
- validation expectations for each feature

### Out of scope

- project dossier content (see 60-projects)
- roadmap and issue tracking (see 00-portfolio/roadmap)

## Prereqs / Inputs

- Portfolio App feature inventory exists and is up to date
- ADRs, runbooks, and reference docs exist for cross-linking
- Feature owners follow the standard page shape

## Procedure / Content

### Feature groups

- [Core pages and reviewer journey](01-core-pages-reviewer-journey/index.md)
- [Evidence-first content model](02-evidence-first-content-model/index.md)
- [Navigation and UX polish](03-navigation-ux-polish/index.md)
- [Theming and accessibility](04-theming-accessibility/index.md)
- [SEO, metadata, and structured data](05-seo-metadata-structured-data/index.md)
- [Security posture and hardening](06-security-posture-hardening/index.md)
- [Testing and quality gates](07-testing-quality-gates/index.md)
- [CI/CD and environment promotion](08-cicd-environment-promotion/index.md)
- [Performance and observability](09-performance-observability/index.md)
- [Documentation and governance integration](10-docs-governance-integration/index.md)

### Feature page governance

Every feature page must follow the repository standard page shape:

1. Purpose
2. Scope
3. Prereqs / Inputs
4. Procedure / Content
5. Validation / Expected outcomes
6. Failure modes / Troubleshooting
7. References

In Procedure / Content, include the required feature fields:

- Feature name
- Feature group
- Technical summary
- Low-tech summary
- Feature in action
- Manual confirmation process
- Potential behavior if broken or misconfigured
- Long-term maintenance notes
- Dependencies, libraries, tools
- Source code references (GitHub URLs)
- ADRs
- Runbooks
- Additional internal references (exclude `/60-projects/portfolio-app`, `/00-portfolio`, `/roadmap`, and `/issues`)
- External reference links (official docs only)

Use the standard feature template at [docs/\_meta/template/template-feature-details.md](https://github.com/bryce-seefieldt/portfolio-docs/tree/main/docs/_meta/template/template-feature-details.md) when creating new feature pages.

## Validation / Expected outcomes

- Each feature page is easy to audit within 2 to 5 minutes.
- Claims on each feature page are supported by references or validation steps.
- Feature groups remain aligned with the feature inventory and roadmap.

## Failure modes / Troubleshooting

- Feature pages read like marketing: add validation steps and concrete evidence.
- Claims lack references: add ADRs, runbooks, or reference docs.
- Stale feature descriptions: update in the same PR as the app change.

## References

- Feature inventory: [docs/60-projects/portfolio-app/feature-inventory.md](docs/60-projects/portfolio-app/feature-inventory.md)
- Documentation system governance: [docs/index.md](docs/index.md)
