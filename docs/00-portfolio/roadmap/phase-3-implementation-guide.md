---
title: 'Phase 3 Implementation Guide'
description: 'Step-by-step procedures for scaling the portfolio with a data-driven project registry, standardized evidence UI, and automated governance.'
sidebar_position: 3
tags: ['phase-3', 'implementation', 'registry', 'governance', 'testing']
---

# Phase 3 Implementation Guide — Repeatable Project Publishing Pipeline

**Phase:** Phase 3 (Scaling & Governance)  
**Estimated Duration:** 2–3 weeks (21–29 hours total)  
**Status:** Ready to execute  
**Last Updated:** 2026-01-20

## Purpose

This guide provides step-by-step instructions for implementing Phase 3 of the Portfolio Program: **Repeatable Project Publishing Pipeline**. Phase 3 enables adding projects at scale while maintaining enterprise governance, evidence standards, and automated link integrity.

## What Phase 3 Delivers

- **Data-driven registry:** YAML-backed project metadata with TypeScript validation
- **Standardized evidence UI:** Reusable components for linking dossiers, threat models, ADRs, runbooks
- **Comprehensive testing:** Unit tests (registry validation, slug rules), e2e tests (route rendering, link resolution)
- **Automated governance:** CI link validation, broken link detection, evidence integrity checks
- **ADRs and documentation:** Architecture decisions and updated dossiers explaining the new model
- **Operational runbooks:** Publishing checklist, maintenance procedures, troubleshooting guides

## Prerequisites

Before starting Phase 3, ensure:

- ✅ Phase 1 complete: Portfolio App deployed with CI gates and core routes
- ✅ Phase 2 complete: Gold standard project page, threat model, dossier, enhanced CV, security hardening
- ✅ Both repos on `main` branch, no uncommitted changes
- ✅ Vercel deployments active for both portfolio-app and portfolio-docs
- ✅ GitHub branch protections enforced
- ✅ Copilot instructions in both repos updated

## Implementation Stages Overview

### Stage 3.1: Data-Driven Registry & Validation (6–8 hours)

**What:** Create YAML-backed project registry with TypeScript validation.

**Key Files:**

- Create `src/data/projects.yml` (YAML format)
- Create `src/lib/registry.ts` (Zod schema + loader)
- Update `src/data/projects.ts` (typed export)

**Schema Design:**

- Project metadata: title, slug, category, tags, dates
- Tech stack with categories and rationale
- Key proofs demonstrating capabilities
- Evidence links: dossier, threat model, ADRs, runbooks, GitHub

**Validation Rules:**

- Slug format: `^[a-z0-9]+(?:-[a-z0-9]+)*$` (lowercase, hyphens, no spaces)
- Slug uniqueness: No duplicate slugs in registry
- Required fields: title, description, tech stack (≥1), proofs (≥1)
- URL validation: Evidence links must be valid URLs

**Deliverables:**

- Registry loader with build-time validation
- Type-safe exports for components
- Link construction helpers
- Package script for local validation

### Stage 3.2: EvidenceBlock Component & Badges (3–4 hours)

**What:** Create reusable React components for standardized evidence linking.

**Key Components:**

- `EvidenceBlock.tsx`: Renders dossier, threat model, ADRs, runbooks, GitHub links
- `VerificationBadge.tsx`: Badge types for docs availability, threat models, gold standard status
- BadgeGroup utility for multi-badge rendering

**Integration:**

- Update project pages to use `EvidenceBlock` and `BadgeGroup`
- Conditional badge rendering based on project evidence
- Responsive styling with Tailwind CSS

**Deliverables:**

- Reusable component library
- Integration into project detail pages
- Responsive design tested across devices

### Stage 3.3: Unit & E2E Tests (4–6 hours)

**What:** Add comprehensive test coverage for registry and link validation.

**Unit Tests (Vitest):**

- Registry schema validation (valid and invalid entries)
- Slug rule enforcement and deduplication
- Link construction helpers
- Tech stack parsing

**E2E Tests (Playwright):**

- Project page rendering
- Evidence link resolution
- Registry loading
- Smoke tests for all routes

**CI Integration:**

- Run tests before build in CI pipeline
- Fail build if tests fail
- Link validation as part of smoke tests

**Deliverables:**

- Unit test suite for registry
- E2E test suite for link validation
- Test coverage reporting
- CI integration

### Stage 3.4: ADRs & Documentation Updates (3–4 hours)

**What:** Document Phase 3 decisions and update dossiers.

**ADRs to Create:**

- ADR-0011: Data-Driven Registry Decision
  - Why YAML (readable, structured, standard)
  - Why type safety (catch errors at build time)
  - Why build-time validation (prevent broken links)
  - Migration path from current implementation

- ADR-0012: Cross-Repo Documentation Linking
  - Environment-first URL construction
  - Schema-based link validation
  - Bidirectional link assertions
  - Deployment synchronization strategy

**Documentation Updates:**

- Portfolio App dossier: Add "Data-Driven Registry" section to architecture page
- Registry Schema Guide: Reference page with examples
- Publishing Checklist: Step-by-step guide for adding projects
- Copilot Instructions: Update with registry patterns

**Deliverables:**

- Two comprehensive ADRs
- Updated dossier pages
- Reference guides
- Updated copilot instructions

### Stage 3.5: CI Link Validation & Runbooks (2–3 hours)

**What:** Add CI link checks and operational procedures.

**CI Enhancements:**

- Registry validation step in CI
- Link format checking
- Evidence URL verification
- Broken link detection in docs

**Runbooks to Create:**

- rbk-portfolio-project-publish.md: Complete publish procedure
  - Planning phase (30 min)
  - Registry entry creation (30 min)
  - Dossier creation (1–1.5 hours)
  - Link validation (30 min)
  - PR creation and review (30 min)
  - Post-publish verification (15 min)

- Troubleshooting Guide: Common issues and solutions
  - Invalid slug format
  - Broken dossier links
  - Evidence link issues
  - Registry validation failures

**Deliverables:**

- Enhanced CI configuration
- Operational runbooks
- Troubleshooting guide
- Team onboarding documentation

### Stage 3.6: Analytics & Social Metadata (2 hours)

**What:** Add tracking and social sharing enhancements.

**Metadata Enhancements:**

- Open Graph metadata for projects
- Twitter Card configuration
- Dynamic metadata generation per project
- Social preview images

**Analytics (Privacy-Safe):**

- Optional: Vercel Web Analytics or Plausible
- Track aggregate page views (no PII)
- Document privacy implications

**Deliverables:**

- Enhanced metadata in layout and pages
- Social sharing optimization
- Privacy-safe analytics setup
- Documentation of tracking approach

## Implementation Checklist

### Before Starting

- [ ] Phase 2 complete and verified
- [ ] Vercel deployments active
- [ ] GitHub protections configured
- [ ] Team alignment on Phase 3 goals
- [ ] Create Phase 3 milestone in both repos
- [ ] Create tracking issues per stage

### Stage 3.1 Checklist

- [ ] Design registry schema
- [ ] Create projects.yml with 2–3 examples
- [ ] Implement registry.ts loader
- [ ] Add Zod validation
- [ ] Update projects.ts to export from registry
- [ ] Test locally: `pnpm build`
- [ ] Create PR with registry implementation

### Stage 3.2 Checklist

- [ ] Create EvidenceBlock component
- [ ] Create VerificationBadge component
- [ ] Update project pages to use components
- [ ] Test responsive design
- [ ] Verify badges display correctly
- [ ] Create PR with component integration

### Stage 3.3 Checklist

- [ ] Setup Vitest config
- [ ] Write registry validation tests
- [ ] Write slug rule tests
- [ ] Write link construction tests
- [ ] Update Playwright smoke tests
- [ ] Add test scripts to package.json
- [ ] Wire into CI pipeline
- [ ] Create PR with test suite

### Stage 3.4 Checklist

- [ ] Draft ADR-0011: Registry Decision
- [ ] Draft ADR-0012: Cross-Repo Linking
- [ ] Update Portfolio App dossier architecture
- [ ] Create Registry Schema Guide
- [ ] Update Copilot Instructions
- [ ] Build and verify links
- [ ] Create PR with documentation

### Stage 3.5 Checklist

- [ ] Add registry validation to CI
- [ ] Add link format checking to CI
- [ ] Create publish runbook
- [ ] Create troubleshooting guide
- [ ] Test runbook procedures
- [ ] Update team docs
- [ ] Create PR with runbooks

### Stage 3.6 Checklist

- [ ] Enhance Next.js metadata
- [ ] Add Open Graph tags
- [ ] Add Twitter Card configuration
- [ ] Test social previews
- [ ] Setup analytics (if applicable)
- [ ] Document privacy approach
- [ ] Create PR with metadata updates

## Timeline & Resource Estimate

| Stage     | Task                   | Duration   | Status               |
| --------- | ---------------------- | ---------- | -------------------- |
| 3.1       | Registry & Validation  | 6–8h       | Ready                |
| 3.2       | EvidenceBlock & Badges | 3–4h       | Ready                |
| 3.3       | Unit & E2E Tests       | 4–6h       | Ready                |
| 3.4       | ADRs & Documentation   | 3–4h       | Ready                |
| 3.5       | CI & Runbooks          | 2–3h       | Ready                |
| 3.6       | Analytics & Metadata   | 2h         | Ready                |
| **Total** | **Phase 3**            | **21–29h** | **Ready to Execute** |

## Success Criteria

- ✅ Registry validates on every build
- ✅ All project pages render without TypeScript errors
- ✅ Unit tests: registry validation, slug rules, link construction
- ✅ E2E tests: route rendering, evidence link resolution
- ✅ CI enforces validation (build fails if registry invalid)
- ✅ ADRs document Phase 3 decisions clearly
- ✅ Dossiers updated with new model explanation
- ✅ Runbooks enable non-engineers to publish projects
- ✅ Publishing a project requires only: YAML edit + dossier creation (no code changes)
- ✅ All tests pass in CI; no broken links in production

## Reference Documentation

- [Roadmap — Phase 3](/docs/00-portfolio/roadmap/index.md)
- [Session Context — Phase 3 Ready](https://github.com/bryce-seefieldt/portfolio-docs/tree/main/.copilot/session-context.md)
- [ADR Index](/docs/10-architecture/adr/index.md)
- [Portfolio App Dossier](docs/60-projects/portfolio-app/index.md)
- [Reference Section](docs/70-reference/index.md)

## Next Steps After Phase 3

Once Phase 3 core is complete, consider:

1. **Project Filtering & Discovery** (2–3h): Add tags-based filtering to homepage
2. **Automated Health Checks** (1–2h): Scheduled CI job to verify all links remain valid
3. **CMS Integration** (4–6h): Optional headless CMS for project metadata (Phase 4 candidate)
4. **Analytics Dashboard** (2–3h): Track which projects get viewed most
5. **Capability-Based Search** (3–4h): Search projects by skill/technology demonstrated

## Notes

- Code samples and detailed procedures are documented in respective stage ADRs and runbooks
- Follow the checklist in order; each stage depends on previous stages
- Test locally before creating PRs
- Request review from engineering lead for architectural decisions (ADRs)
- All PRs must pass CI before merge (tests, linting, typecheck, build)
- Coordinate deployments: docs first, then app
