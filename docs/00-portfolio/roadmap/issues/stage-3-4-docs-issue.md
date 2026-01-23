---
title: 'Stage 3.4 — ADRs & Documentation Updates (Docs)'
description: 'Create ADRs for Phase 3 decisions, update dossiers, and publish reference guides for data-driven registry and cross-repo linking.'
tags:
  [
    portfolio,
    roadmap,
    planning,
    phase-3,
    stage-3.4,
    docs,
    documentation,
    adr,
  ]
---

# Stage 3.4: ADRs & Documentation Updates — Documentation

**Type:** Documentation / ADR / Reference  
**Phase:** Phase 3 — Scaling & Governance  
**Stage:** 3.4  
**Linked Issue:** [stage-3-4-app-issue.md](/docs/00-portfolio/roadmap/issues/stage-3-4-app-issue.md)  
**Duration Estimate:** 3–4 hours  
**Assignee:** GitHub Copilot / Engineering Lead  
**Created:** 2026-01-22  
**Status:** Ready to execute

---

## Overview

This stage formalizes Phase 3 architectural and linking decisions through two comprehensive ADRs, updates the Portfolio App dossier with Phase 3 implementation details, and publishes a registry schema reference guide for future contributors.

While Stages 3.1–3.3 implemented the data-driven registry, evidence components, and tests, this stage documents **why** these patterns exist, **how** they should be maintained, and **what** new patterns future projects must follow.

**Why this matters:** Enterprise credibility requires durable decision records. These ADRs ensure Phase 3 patterns persist beyond initial implementation and provide a reference frame for Phase 4+ planning.

## Objectives

- Document Phase 3 registry decision and trade-offs (ADR-0011)
- Document cross-repo linking strategy and environment-first URL construction (ADR-0012)
- Update Portfolio App dossier with Phase 3 architecture and implementation details
- Create registry schema reference guide for contributors
- Ensure all docs build cleanly and links are validated

---

## Scope

### Files to Create

1. **`docs/10-architecture/adr/adr-0011-data-driven-project-registry.md`** — Architecture Decision Record
   - Type: ADR
   - Purpose: Document why we chose YAML + Zod for project registry; explain validation strategy
   - Audience: Architects, engineers evaluating Phase 3 decisions
   - Sections:
     - Problem Statement (why registry needed)
     - Decision (YAML + TypeScript validation)
     - Rationale (readability, type safety, build-time validation)
     - Consequences (enables scaling, requires schema changes)
     - Alternatives (hardcoded array, JSON, database)
     - Implementation reference (Stage 3.1–3.3)
     - Success criteria (no broken links in production, easy project addition)

2. **`docs/10-architecture/adr/adr-0012-cross-repo-documentation-linking.md`** — Architecture Decision Record
   - Type: ADR
   - Purpose: Document environment-first URL construction and bidirectional linking strategy
   - Audience: Architects, engineers linking across repos
   - Sections:
     - Problem Statement (different domains, env flexibility)
     - Decision (environment variables + helper functions)
     - Rationale (portability, consistency, decoupling)
     - Consequences (requires env setup, URL patterns consistent)
     - Alternatives (hardcoded URLs, relative paths)
     - Implementation reference (config.ts helpers, Stage 3.1–3.2)
     - Success criteria (links resolve in all environments, no hardcoded domains)

3. **`docs/70-reference/registry-schema-guide.md`** — Reference Guide
   - Type: Reference / Guide
   - Purpose: Complete registry schema documentation with examples
   - Audience: Contributors adding projects, developers maintaining registry
   - Sections:
     - Purpose & Overview
     - Schema Definition (all fields, types, constraints)
     - Validation Rules (slug format, uniqueness, required fields)
     - Examples (valid and invalid entries)
     - Field Descriptions (what each field means, constraints)
     - Common Mistakes & Fixes
     - Link Examples (how evidence links map to docs paths)
     - Testing the Registry (`pnpm registry:validate`)
     - FAQ

### Files to Update

1. **`docs/60-projects/portfolio-app/02-architecture.md`** — Architecture page
   - Update section: "Data-Driven Registry (Stage 3.1)"
   - Add content:
     - YAML registry overview and location
     - TypeScript validation via Zod
     - Link to ADR-0011 for decision context
     - Brief explanation of slug rules and evidence structure
     - Link to registry schema guide for detailed reference

2. **`docs/60-projects/portfolio-app/05-testing.md`** — Testing page
   - Update section: "Unit Tests (Stage 3.3)"
   - Add content:
     - Registry validation tests location and purpose
     - Coverage expectations
     - Link to testing guide in reference section
   - Update section: "E2E Tests (Stage 3.3)"
     - Evidence link resolution tests

3. **`docs/60-projects/portfolio-app/index.md`** — Dossier overview
   - Add brief mention of Phase 3 in "Capabilities" or "Key Deliverables" section
   - Link to ADR-0011 and ADR-0012 in Architecture/Decisions section

4. **`.github/copilot-instructions.md`** (portfolio-docs) — Copilot guidance
   - Add "Phase 3 Decision References" section near top
   - Link to ADR-0011 and ADR-0012
   - Explain when to reference these ADRs
   - Note about data-driven registry patterns

---

## Content Structure & Design

### ADR-0011: Data-Driven Registry Decision

**Front Matter:**
```yaml
---
title: 'ADR-0011: Data-Driven Project Registry'
description: 'Architectural decision to use YAML-backed, type-validated project registry for scalable project publishing.'
sidebar_position: 11
tags: [adr, architecture, phase-3, registry, data-driven]
---
```

**Outline:**

#### Section 1: Problem Statement
- Current state: Projects defined in hardcoded TypeScript
- Pain points: Adding projects requires code changes, testing, PR review; not scalable
- Trigger: Phase 3 objective to enable publishing at scale

#### Section 2: Decision
- Use YAML for project metadata (`src/data/projects.yml`)
- Validate with Zod schema (`src/lib/registry.ts`)
- Build-time validation prevents invalid registries in production

#### Section 3: Rationale
- YAML is human-readable, minimal syntax
- Zod provides type safety and runtime validation
- Build-time validation catches errors early
- Patterns established in Phase 3 Stages 3.1–3.3 (tested, working)

#### Section 4: Consequences
- **Positive:** Easy project addition (YAML only), no code changes, validated at build time
- **Negative:** New contributors must learn schema, requires validation script, schema migrations needed if fields change

#### Section 5: Alternatives
- Hardcoded array: Rejected—requires code changes
- JSON: Rejected—less readable than YAML
- Database: Rejected—too complex for this stage, not needed for static site

#### Section 6: Implementation
- Implementation guide: [Phase 3 Implementation Guide](/docs/00-portfolio/roadmap/phase-3-implementation-guide.md)
- Schema reference: [Registry Schema Guide](/docs/70-reference/registry-schema-guide.md)
- Related components: EvidenceBlock, VerificationBadge (Stage 3.2)

---

### ADR-0012: Cross-Repo Documentation Linking

**Front Matter:**
```yaml
---
title: 'ADR-0012: Cross-Repo Documentation Linking Strategy'
description: 'Environment-first URL construction for portable, consistent linking across portfolio-app and portfolio-docs.'
sidebar_position: 12
tags: [adr, architecture, phase-3, linking, cross-repo, environment-variables]
---
```

**Outline:**

#### Section 1: Problem Statement
- Current state: Links between portfolio-app and portfolio-docs are partially hardcoded
- Pain points: URLs brittle if domain changes, inconsistent patterns, difficult to test locally vs. production
- Trigger: Phase 3 requires scalable evidence linking across repos

#### Section 2: Decision
- Environment-first URL construction via helpers (docsUrl, githubUrl, docsGithubUrl)
- Helpers resolve NEXT_PUBLIC_* env vars at build time
- Enables local dev, CI, and production to use different URLs

#### Section 3: Rationale
- Portability: Same code works locally, in CI, and in production
- Consistency: All links follow same pattern
- Decoupling: Repos don't need to know each other's production domains
- Tested: Unit tests verify fallbacks when env vars missing

#### Section 4: Consequences
- **Positive:** Links portable, consistent, testable
- **Negative:** Requires env setup, slightly more complex than hardcoded URLs, .env.local required locally

#### Section 5: Alternatives
- Hardcoded URLs: Rejected—brittle, not portable
- Relative paths: Rejected—only works within same domain, doesn't help cross-repo
- Runtime config: Rejected—too dynamic for static site generation

#### Section 6: Implementation
- Config module: `src/lib/config.ts`
- Tests: `src/lib/__tests__/config.test.ts`, `src/lib/__tests__/linkConstruction.test.ts`
- Environment contract: `.env.example`
- Portfolio-app dossier: Architecture section

---

### Registry Schema Guide

**Front Matter:**
```yaml
---
title: 'Registry Schema Guide'
description: 'Complete reference for Portfolio App project registry YAML schema, validation rules, and examples.'
sidebar_position: 1
tags: [reference, registry, schema, portfolio-app]
---
```

**Outline:**

#### Section 1: Purpose & Overview
- Registry location and format
- Who uses it (contributors, CI, build system)
- Why it matters (enables scalable project publishing)

#### Section 2: Complete Schema
```typescript
// Show Zod schema structure with all fields, types, constraints
```

#### Section 3: Field Reference
- slug (required): Unique identifier; format `^[a-z0-9]+(?:-[a-z0-9]+)*$`
- title (required): Project name
- summary (required): Short proof-focused summary
- description: Long-form description
- category: Project classification (fullstack, frontend, backend, etc.)
- tags: Technology and skill tags
- startDate, endDate: Project timeline
- status: featured, active, archived
- links: Repo, demo, docs URLs
- evidence: Links to dossier, threat model, ADRs, runbooks
- tech: Technology stack with categories and rationale
- proofs: Key capabilities demonstrated

#### Section 4: Validation Rules
- Slug format and uniqueness enforcement
- Required fields
- URL validation
- Error messages and recovery

#### Section 5: Examples
- ✅ Valid project entry (well-formed)
- ❌ Invalid entries (with explanations of what's wrong and how to fix)

#### Section 6: Link Examples
- How to structure evidence links
- docsUrl patterns for dossier paths
- githubUrl patterns for repo links

#### Section 7: Testing & Validation
- Running `pnpm registry:validate` locally
- CI validation in build pipeline
- Common validation errors and fixes

---

## Implementation Tasks

### Phase 1: ADR Creation (1.5–2 hours)

#### Tasks

- [x] **Draft ADR-0011: Data-Driven Registry Decision**
  - File: `docs/10-architecture/adr/adr-0011-data-driven-project-registry.md`
  - Include all sections listed above
  - Link to Stage 3.1 implementation guide
  - Reference registry schema guide
  - Explain Zod schema benefits

- [x] **Draft ADR-0012: Cross-Repo Documentation Linking**
  - File: `docs/10-architecture/adr/adr-0012-cross-repo-documentation-linking.md`
  - Include all sections listed above
  - Show docsUrl, githubUrl examples
  - Explain environment variable contract
  - Reference config.ts helpers

- [x] **Add both ADRs to ADR index**
  - File: `docs/10-architecture/adr/index.md` (if it exists) or `_category_.json`
  - Add links to ADR-0011 and ADR-0012

#### Success Criteria for Phase 1

- [x] Both ADRs complete with all sections
- [x] Examples are accurate and tested
- [x] Links to implementation and guides are valid
- [x] Front matter complete (title, description, tags, sidebar_position)
 [x]

### Phase 2: Dossier & Reference Updates (1–1.5 hours)

#### Tasks

- [x] **Create registry schema guide**
  - File: `docs/70-reference/registry-schema-guide.md`
  - Include complete schema with all fields
  - Add validation rules and examples
  - Link to testing procedures
  - Reference ADR-0011

- [x] **Update Portfolio App dossier**
  - File: `docs/60-projects/portfolio-app/02-architecture.md`
  - Add "Data-Driven Registry (Stage 3.1)" subsection
  - Explain YAML + Zod approach
  - Link to ADR-0011 and registry schema guide

- [x] **Update Portfolio App testing page**
  - File: `docs/60-projects/portfolio-app/05-testing.md`
  - Add registry validation test description
  - Link to testing guide in reference

- [x] **Update Portfolio App dossier overview**
  - File: `docs/60-projects/portfolio-app/index.md`
  - Add Phase 3 to key deliverables
  - Link to ADRs in Architecture section

#### Success Criteria for Phase 2

- [x] Registry schema guide is comprehensive and examples are correct
- [x] Dossier pages updated with Phase 3 context
- [x] All links to ADRs are valid
- [x] Examples are copy/paste safe

---

### Phase 3: Copilot Instructions & Validation (0.5–1 hour)

#### Tasks

- [x] **Update copilot instructions**
  - File: `.github/copilot-instructions.md` (portfolio-docs)
  - Add "Phase 3 Decision References" section
  - Link to ADR-0011 and ADR-0012
  - Explain when to reference them

- [x] **Build and verify**
  - Command: `pnpm build`
  - Expected: No broken links, no build errors
  - Link check: Verify all internal links resolve

- [x] **Validate cross-references**
  - Check: ADRs link to each other bidirectionally
  - Check: Dossier links to ADRs
  - Check: Schema guide is referenced by ADRs and dossier

#### Success Criteria for Phase 3

- [x] `pnpm build` passes with no errors
- [x] All links are valid and bidirectional
- [x] No broken internal references

---

## Testing & Validation

### Content Validation

- [x] ADR-0011: All sections complete; examples accurate
- [x] ADR-0012: All sections complete; URL construction examples valid
- [x] Registry schema guide: Schema matches actual Zod schema in `src/lib/registry.ts`
- [x] Dossier updates: Reflect actual Phase 3 implementation

### Build Validation

- [x] `pnpm build` passes locally
- [x] No broken links in output
- [x] All internal links resolve to actual files

### Accuracy Checks

- [x] All helper function names match code (`docsUrl`, `githubUrl`, `docsGithubUrl`)
- [x] All file paths in examples are correct
- [x] Environment variable names match CI workflow and `.env.example`
- [x] ADR numbering is sequential and follows convention

---

## Acceptance Criteria

This stage is complete when:

- [x] ADR-0011 created and published with all sections
- [x] ADR-0012 created and published with all sections
- [x] Registry schema guide created with examples and validation rules
- [x] Portfolio App dossier updated with Phase 3 content
- [x] All internal links are bidirectional and valid
- [x] `pnpm build` passes with no broken links
- [x] No placeholder text or "TODO" items
- [x] Front matter complete on all pages (title, description, tags, sidebar_position)
- [x] All code examples are accurate and tested
- [x] Cross-references to portfolio-app code are correct
- [x] PR approved by engineering lead
- [x] PR merged with "Closes #X" keyword

---

## Definition of Done

This stage is complete and ready to deploy when:

- ✅ **Content Complete:** All ADRs, guides, and dossier updates finished with no TODOs
- ✅ **Accurate:** ADRs verified against actual implementation (Stages 3.1–3.3)
- ✅ **Well-Structured:** Follows ADR template and style guide; clear sections
- ✅ **Examples Included:** Code examples and schema excerpts are correct
- ✅ **Links Working:** All internal and cross-repo links resolve in build
- ✅ **Bidirectional:** Related docs link to each other (ADRs ↔ dossier ↔ schema guide)
- ✅ **Style Consistent:** Matches portfolio docs style; formatting correct
- ✅ **Front Matter Complete:** Title, description, tags, sidebar_position on all pages
- ✅ **No Secrets:** No tokens, keys, or sensitive data
- ✅ **Builds Clean:** `pnpm build` passes; no warnings or errors
- ✅ **Reviewed:** Engineering lead reviewed ADRs for accuracy and clarity
- ✅ **Merged to main:** PR closed and visible in published docs

---

## Cross-Repository Integration

### Dependencies on Portfolio-App

- App must have Stage 3.1–3.3 complete (registry, components, tests) before this docs stage
- Examples in ADRs and schema guide reference actual files in portfolio-app
- Registry schema in guide must match `src/lib/registry.ts` Zod schema

### Connection to Portfolio-App Issue (3.4-app)

- Docs issue completes first; merges to main
- App issue then references published ADR URLs in copilot instructions update
- App issue should merge after docs PRs are live

---

## References & Related Issues

- **Companion app issue:** [Stage 3.4: ADRs & Documentation — App Implementation](/docs/00-portfolio/roadmap/issues/stage-3-4-app-issue.md)
- **Parent guide:** [Phase 3 Implementation Guide](/docs/00-portfolio/roadmap/phase-3-implementation-guide.md)
- **Predecessor stages:**
  - Stage 3.1: Data-Driven Registry (complete)
  - Stage 3.2: Evidence Components (complete)
  - Stage 3.3: Unit & E2E Tests (complete)
- **Related templates:**
  - `docs/_meta/templates/template-adr.md`
  - `docs/_meta/templates/template-reference-guide.md`

---

## Notes & Assumptions

- Assumes portfolio-app Stages 3.1–3.3 are merged and working
- Assumes ADRs are durable design records (not implementation guides)
- Assumes registry schema in `src/lib/registry.ts` is stable (only minor updates expected)
- Timeline assumes sequential completion: docs issue → docs PRs → app issue → app PR

---

## Review Checklist (for Reviewer)

- [x] ADRs follow ADR template and portfolio style
- [x] Decisions are well-justified and consequences clearly explained
- [x] Alternatives section is thorough
- [x] Examples are accurate and match actual code
- [x] Registry schema guide is comprehensive and correct
- [x] Dossier updates reflect Phase 3 accurately
- [x] All internal links are valid
- [x] No secrets or sensitive data
- [x] ADRs are numbered correctly and sequentially
