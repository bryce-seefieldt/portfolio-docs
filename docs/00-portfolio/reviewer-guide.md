---
title: 'Reviewer Guide'
description: 'A fast, evidence-first path to validate the portfolio in under 15 minutes.'
sidebar_position: 4
tags: [portfolio, review, evidence, governance]
---

## Purpose

Provide a concise, reviewer-first path to validate the portfolio quickly while keeping links to deeper evidence.

## Scope

### In scope

- Portfolio App overview and evidence links
- Documentation App dossier and governance artifacts
- Testing, security, and operations evidence

### Out of scope

- Deep feature walkthroughs
- Implementation detail beyond evidence validation

## Prereqs / Inputs

- Access to the Portfolio App and Documentation App
- A modern browser

## Procedure / Content

### Fast path (10–15 minutes)

1. **Portfolio App overview**
   - Visit the homepage and skim the reviewer callout.
   - Open the CV: `/cv` for scope and seniority signals.

2. **Project evidence**
   - Open the Portfolio App project page: `/projects/portfolio-app`.
   - Follow evidence links to dossier, ADRs, and runbooks.

3. **Dossier validation**
   - Read the Portfolio App dossier entry page:
     - [/docs/60-projects/portfolio-app/index.md](/docs/60-projects/portfolio-app/index.md)

4. **Security & operations**
   - Threat model index: [/docs/40-security/threat-models/index.md](/docs/40-security/threat-models/index.md)
   - Runbooks index: [/docs/50-operations/runbooks/index.md](/docs/50-operations/runbooks/index.md)

5. **Testing & CI evidence**
   - Testing guide: [/docs/70-reference/testing-guide.md](/docs/70-reference/testing-guide.md)
   - CI overview: [/docs/30-devops-platform/ci-cd-pipeline-overview.md](/docs/30-devops-platform/ci-cd-pipeline-overview.md)

## Validation / Expected outcomes

- The portfolio narrative aligns with documented evidence.
- Evidence links resolve and are current.
- CI/testing posture is explicit and verifiable.

## Failure modes / Troubleshooting

- **Links fail:** check for doc path drift or build errors.
- **Claims unverified:** consult the evidence audit checklist.

## References

- Evidence audit checklist: [/docs/70-reference/evidence-audit-checklist.md](/docs/70-reference/evidence-audit-checklist.md)
- Roadmap: [/docs/00-portfolio/roadmap/index.md](/docs/00-portfolio/roadmap/index.md)
