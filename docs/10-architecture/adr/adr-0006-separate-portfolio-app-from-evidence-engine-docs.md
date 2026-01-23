---
title: 'ADR-0006: Separate Portfolio App from Docs App'
description: 'Decision to keep the Portfolio App focused on a polished product experience and use the Docusaurus Documentation App as the enterprise evidence engine.'
sidebar_position: 6
tags:
  [
    architecture,
    adr,
    portfolio-app,
    documentation,
    information-architecture,
    governance,
  ]
---

## Purpose

Record the decision to maintain a strict separation of concerns between:

- the **Portfolio App** as the public-facing product experience, and
- the **Documentation App (Docusaurus)** as the enterprise evidence engine hosting dossiers, ADRs, threat models, runbooks, and postmortems.

## Scope

### In scope

- content ownership boundaries (what lives in the Portfolio App vs docs)
- navigation and linking strategy between the two properties
- governance implications for scaling content and credibility

### Out of scope

- final URL strategy details (subdomain vs /docs) beyond compatibility requirements
- implementation details of project content ingestion (JSON/YAML/MDX)—handled by Portfolio App architecture doc and follow-on ADRs as needed

## Prereqs / Inputs

- Decision owner(s): Portfolio maintainer
- Date: 2026-01-10
- Status: Proposed (accept when Portfolio App links to docs are implemented)
- Related artifacts:
  - Portfolio App dossier: `docs/60-projects/portfolio-app/`
  - Portfolio Docs App dossier: `docs/60-projects/portfolio-docs-app/`

## Decision Record

### Title

ADR-0006: Separate Portfolio App (Front-of-House) from Documentation App (Evidence Engine)

### Context

The portfolio program requires both:

- a high-quality user experience for reviewers, and
- deep technical evidence demonstrating enterprise engineering discipline.

Combining full enterprise documentation inside the Portfolio App risks:

- bloating the app UX
- duplicating documentation platform capabilities
- creating maintenance overhead and inconsistent governance
- mixing “marketing surface” with “operational truth”

The Documentation App is already designed as a docs-as-code system with strict governance, templates, and operational artifacts.

### Decision

Adopt the following separation model:

#### Portfolio App (Front-of-House)

Owns:

- concise narrative and UX
- interactive CV and project highlights
- project cards and short summaries
- stable links to evidence artifacts in Documentation App

Constraints:

- keep long-form governance docs out of the Portfolio App
- keep project pages focused on quick comprehension + proof links

#### Documentation App (Evidence Engine)

Owns:

- project dossiers (deep technical documentation)
- ADRs, threat models, runbooks, postmortems
- release notes and governance artifacts
- long-form technical explanations and diagrams

Constraints:

- templates and internal scaffolding remain internal (`docs/_meta/`)
- content is public-safe and operationally credible

#### Linking strategy (minimum)

Each Portfolio App project page must include:

- Repo link
- Demo link (if available)
- “Read the dossier” link
- Optional: “Threat model,” “Runbooks,” “Release notes” links

The docs URL must be configurable to support:

- docs at `/docs` OR
- docs at a docs subdomain

### Alternatives considered

1. **Single-site approach: put everything in Portfolio App**

- Pros: one codebase, single navigation
- Cons: reinvents docs platform features; higher maintenance; diluted enterprise evidence feel; harder governance
- Not chosen: Docusaurus already provides a superior docs-as-code evidence platform.

2. **Single-site approach: docs-only (no Portfolio App)**

- Pros: simplest; evidence is centralized
- Cons: weaker “product” signal; less polished experience for casual reviewers
- Not chosen: portfolio requires a “front-of-house” experience.

3. **Duplicate docs in both places**

- Pros: redundancy
- Cons: drift and inconsistency; credibility loss
- Not chosen: violates single source of truth.

### Consequences

#### Positive consequences

- Clear separation of concerns and maintainable scaling path
- Portfolio App remains fast, polished, and product-like
- Documentation remains governed, traceable, and enterprise-grade
- Evidence is centralized with consistent templates and review discipline

#### Negative consequences / tradeoffs

- Must maintain consistent cross-site linking and versioning
- Reviewers traverse two properties (mitigated by clear linking UX)
- Requires disciplined content boundaries to prevent drift

#### Operational impact

- Each material change in Portfolio App must update evidence docs where appropriate
- Release notes may need to capture changes that affect cross-links or routes

#### Security impact

- Reduces risk of accidentally publishing sensitive operational details in the Portfolio App UI
- Concentrates governance and safe-publication controls in the docs platform

### Implementation notes (high-level)

- Define a single canonical docs base URL in Portfolio App config (environment or build-time config).
- Add evidence link components in project pages:
  - “Read dossier”
  - “Security / threat model”
  - “Ops / runbooks”
- Update dossier templates and checklists so new projects follow the same evidence strategy.

## Validation / Expected outcomes

- Portfolio App pages link reliably to the correct docs locations.
- Long-form documentation remains exclusively in the Documentation App.
- Adding new projects requires:
  - Portfolio App metadata entry + evidence links
  - Documentation App project dossier folder and pages
- Governance artifacts remain consistent and discoverable.

## Failure modes / Troubleshooting

- Evidence link drift due to docs reorg:
  - treat as breaking; update links and release notes; consider stable slugs.
- Content duplication starts creeping into Portfolio App:
  - refactor content into docs; enforce boundary in PR review checklist.
- Docs base URL changes:
  - record via ADR; update both apps; verify with CI link checks if implemented.

## References

- Portfolio App dossier architecture: `docs/60-projects/portfolio-app/architecture.md`
- Documentation evidence engine: `docs/60-projects/portfolio-docs-app/index.md`
- Release notes domain: `docs/00-portfolio/release-notes/`
