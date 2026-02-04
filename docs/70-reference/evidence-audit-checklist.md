---
title: 'Evidence Audit Checklist'
description: 'Checklist for validating that portfolio claims map to verifiable artifacts across code and documentation.'
sidebar_position: 9
tags: [evidence, validation, checklist, portfolio, review]
---

## Purpose

Provide a repeatable, evidence-first checklist to validate claims across the Portfolio App and Documentation App.

## Scope

### In scope

- Portfolio App claims about SDLC, security, testing, and operations
- Documentation App claims about governance artifacts and traceability
- Evidence links in dossiers, ADRs, threat models, and runbooks

### Out of scope

- New feature development
- Deep refactors unrelated to evidence validation

## Prereqs / Inputs

- Access to both repositories (`portfolio-app`, `portfolio-docs`)
- Deployed docs site and app URLs (or local builds)
- CI status for recent PRs

## Procedure / Content

### 1) Portfolio App claims (fast validation)

- [ ] Homepage narrative matches actual capabilities (no speculative claims)
- [ ] Project summaries align with registry metadata
- [ ] Evidence links on `/projects/portfolio-app` resolve to docs

**Evidence to verify:**

- Portfolio App dossier: [/docs/60-projects/portfolio-app/index.md](/docs/60-projects/portfolio-app/index.md)
- ADR index: [/docs/10-architecture/adr/index.md](/docs/10-architecture/adr/index.md)
- Threat models: [/docs/40-security/threat-models/index.md](/docs/40-security/threat-models/index.md)
- Runbooks: [/docs/50-operations/runbooks/index.md](/docs/50-operations/runbooks/index.md)

### 2) Testing and CI claims

- [ ] CI gate names match documentation
- [ ] E2E and unit test counts align with dossier metrics
- [ ] `pnpm verify`/`pnpm test:e2e` references are accurate

**Evidence to verify:**

- CI pipeline overview: [/docs/30-devops-platform/ci-cd-pipeline-overview.md](/docs/30-devops-platform/ci-cd-pipeline-overview.md)
- Testing guide: [/docs/70-reference/testing-guide.md](/docs/70-reference/testing-guide.md)
- Portfolio App testing dossier: [/docs/60-projects/portfolio-app/05-testing.md](/docs/60-projects/portfolio-app/05-testing.md)

### 3) Security and operations claims

- [ ] Threat model references current controls
- [ ] Runbooks reflect current deploy/rollback behavior
- [ ] No secrets or internal endpoints are documented

**Evidence to verify:**

- Security dossier: [/docs/60-projects/portfolio-app/04-security.md](/docs/60-projects/portfolio-app/04-security.md)
- Threat models: [/docs/40-security/threat-models/index.md](/docs/40-security/threat-models/index.md)
- Runbooks: [/docs/50-operations/runbooks/index.md](/docs/50-operations/runbooks/index.md)

### 4) Documentation integrity

- [ ] Dossier pages match required structure
- [ ] Links are bidirectional and build passes
- [ ] Roadmap and release notes match current status

**Evidence to verify:**

- Roadmap: [/docs/00-portfolio/roadmap/index.md](/docs/00-portfolio/roadmap/index.md)
- Release notes: [/docs/00-portfolio/release-notes/index.md](/docs/00-portfolio/release-notes/index.md)
- Dossier contract: [/docs/60-projects/index.md](/docs/60-projects/index.md)

## Validation / Expected outcomes

- Evidence links resolve without 404s
- Claims are traceable to artifacts
- CI and testing references are accurate

## Failure modes / Troubleshooting

- **Broken links:** fix paths or update references to current doc locations
- **Outdated claims:** edit narrative or update evidence artifacts
- **CI mismatch:** update docs to match `.github/workflows` and scripts

## References

- Roadmap: [/docs/00-portfolio/roadmap/index.md](/docs/00-portfolio/roadmap/index.md)
- Testing guide: [/docs/70-reference/testing-guide.md](/docs/70-reference/testing-guide.md)
- Dossier template: [/docs/\_meta/templates/template-project-dossier/](https://github.com/bryce-seefieldt/portfolio-docs/tree/main/docs/_meta/templates/template-project-dossier/)
