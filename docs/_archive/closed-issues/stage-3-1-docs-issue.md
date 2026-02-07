---
title: 'Stage 3.1 — ADR-0011 & Registry Schema Documentation (Docs)'
description: 'Documents the registry decision (ADR-0011) and publishes a comprehensive Registry Schema Guide with rationale, validation rules, and examples.'
tags: [portfolio, roadmap, planning, phase-3, stage-3.1, docs, adr, reference]
---

# Stage 3.1: ADR-0011 & Registry Schema Documentation

https://github.com/bryce-seefieldt/portfolio-docs/issues/42

## Overview

Document the decision to adopt a data-driven project registry and create reference documentation for the registry schema. This provides the architectural context and usage guidance for the registry implementation in portfolio-app.

## Objectives

- Record the architectural decision to use YAML-backed registry
- Document rationale, alternatives considered, and consequences
- Create reference guide for registry schema
- Update dossier with registry explanation

## Scope

### Files to Create

1. **`docs/10-architecture/adr/adr-0011-data-driven-project-registry.md`**
   - ADR documenting registry decision
   - Why YAML over JSON/database/hardcoded
   - Why type safety and build-time validation
   - Schema design rationale
   - Migration path from current implementation

2. **`docs/70-reference/registry-schema-guide.md`**
   - Complete schema reference with examples
   - Field-by-field documentation
   - Validation rules explained
   - Example registry entries (2-3 samples)
   - Common patterns and best practices

### Files to Update

3. **`docs/60-projects/portfolio-app/02-architecture.md`**
   - Add "Data-Driven Registry" subsection
   - Explain registry loader and validation flow
   - Link to ADR-0011 and schema guide
   - Document benefits (scalability, type safety, link integrity)

4. **`.github/copilot-instructions.md`** (both repos)
   - Add registry patterns and examples
   - Update URL construction rules
   - Document evidence link structure

## Implementation Summary (Completed)

- **ADR-0011** published with full 11-section structure (decision: YAML + Zod + env placeholders)
- **Registry Schema Guide** published with field reference, validation rules, 4 validated YAML examples, troubleshooting
- **Architecture dossier** updated (Data-Driven Registry subsection, loader flow, benefits, references to ADR-0011 and schema guide)
- **Copilot instructions** updated in both repos with registry templates, ownership, and validation scripts
- **Validation:** `pnpm build` (docs) ✅ with 0 errors/warnings/broken links; all cross-links resolve
- **Coordination:** Aligned with portfolio-app PR #24 (registry implementation) and commit fb96e99 in portfolio-docs

## ADR-0011 Structure

### Sections Required

1. **Status:** Accepted
2. **Date:** 2026-01-20
3. **Problem Statement**
   - Current state: hardcoded project metadata
   - Pain points: manual sync, no validation, error-prone scaling
   - Risk: broken links, inconsistent structure

4. **Decision**
   - YAML-backed registry with Zod validation
   - Build-time validation (fail fast)
   - Type-safe exports for components
   - Environment-first URL construction

5. **Rationale**
   - Why YAML (readable, structured, standard)
   - Why type safety (catch errors early)
   - Why build-time validation (prevent broken links in production)
   - Why reject alternatives (JSON, database, CMS, hardcoded)

6. **Consequences**
   - Positive: single source of truth, scalable, validated
   - Negative (managed): YAML parsing adds ~50ms to build, developer must update registry

7. **Implementation**
   - Key components (registry.ts, projects.yml, loader)
   - Validation rules (slug format, uniqueness, required fields)
   - Evidence link structure

8. **Related Decisions**
   - Links to ADR-0005 (Stack Choice)
   - Links to ADR-0008 (CI Quality Gates)
   - Links to ADR-0010 (Gold Standard Exemplar)

9. **Alternatives Considered**
   - JSON registry (less readable)
   - Database (overkill, adds complexity)
   - Hardcoded TypeScript (current; doesn't scale)
   - GitHub API (requires auth, doesn't capture metadata)

10. **Migration Path**
    - Create projects.yml with 2-3 entries
    - Implement loader and validation
    - Update routes and components
    - Add unit tests
    - Wire into CI

11. **Success Criteria**
    - Registry validates on every build
    - All project pages render
    - Link validation catches broken URLs
    - Adding project = edit YAML + create dossier (no code)

## Registry Schema Guide Structure

### Sections Required

1. **Purpose & Overview**
   - What the registry is
   - Why it exists
   - Who should use it

2. **Schema Reference**
   - Field-by-field documentation
   - Required vs optional fields
   - Data types and constraints
   - Validation rules

3. **Evidence Link Structure**
   - Dossier links
   - Threat model links
   - ADR links (array format)
   - Runbook links (array format)
   - GitHub repo links

4. **Examples**
   - Minimal project entry
   - Complete project entry (gold standard)
   - Multi-ADR project
   - Project with no evidence (valid case)

5. **Validation Rules**
   - Slug format: `^[a-z0-9]+(?:-[a-z0-9]+)*$`
   - Uniqueness enforcement
   - Required field checks
   - URL validation

6. **Best Practices**
   - How to choose a slug
   - Writing effective descriptions
   - Structuring tech stack
   - Crafting key proofs

7. **Common Patterns**
   - Gold standard projects
   - Ongoing vs completed projects
   - Evidence-light projects (early stage)

8. **Troubleshooting**
   - Common validation errors
   - How to fix invalid slugs
   - Broken link debugging

## Implementation Tasks

### Phase 1: ADR-0011 (2-3 hours)

- [x] Create `docs/10-architecture/adr/adr-0011-data-driven-project-registry.md`
- [x] Write all 11 required sections (see structure above)
- [x] Include code examples for schema
- [x] Link to related ADRs (0005, 0008, 0010)
- [x] Add front matter (title, description, tags, sidebar_position)
- [x] Follow established ADR format and style

### Phase 2: Registry Schema Guide (2-3 hours)

- [x] Create `docs/70-reference/registry-schema-guide.md`
- [x] Document all schema fields with types
- [x] Provide 2-3 complete examples
- [x] Explain validation rules in detail
- [x] Add troubleshooting section
- [x] Include best practices
- [x] Add front matter and tags

### Phase 3: Dossier Update (1 hour)

- [x] Update `docs/60-projects/portfolio-app/02-architecture.md`
- [x] Add "Data-Driven Registry (Phase 3)" subsection under "Components"
- [x] Explain registry loader flow
- [x] Document benefits (type safety, validation, scalability)
- [x] Link to ADR-0011 and schema guide

### Phase 4: Copilot Instructions Update (30 min)

- [x] Update `.github/copilot-instructions.md` in portfolio-app
- [x] Add registry patterns section
- [x] Document evidence link structure
- [x] Provide YAML template example
- [x] Update `.github/copilot-instructions.md` in portfolio-docs
- [x] Add cross-repo linking examples with registry

### Phase 5: Build & Validation (30 min)

- [x] Run `pnpm build` in portfolio-docs
- [x] Verify no broken links
- [x] Check ADR renders correctly
- [x] Check schema guide renders with examples
- [x] Verify dossier update integrates smoothly
- [x] Test cross-links between ADR, schema guide, and dossier

## Acceptance Criteria

- [x] ADR-0011 follows established format
- [x] ADR clearly explains rationale and alternatives
- [x] Schema guide is comprehensive and actionable
- [x] Schema guide includes 2-3 complete examples
- [x] Dossier architecture section updated
- [x] Copilot instructions include registry patterns
- [x] `pnpm build` succeeds with 0 broken links
- [x] All cross-references resolve correctly
- [x] Documentation is reviewer-ready (no TODOs, placeholders)

## Testing

### Manual Testing

```bash
# Build docs
cd portfolio-docs
pnpm build

# Check for broken links
# Should see 0 errors

# Verify ADR navigation
# Navigate to ADR index, find ADR-0011

# Verify schema guide
# Navigate to Reference section, find Registry Schema Guide

# Test cross-links
# Click links between ADR, schema guide, dossier
# All should resolve correctly
```

### Review Checklist

- [x] ADR is complete (no placeholders)
- [x] Schema examples are valid YAML
- [x] Validation rules match implementation (portfolio-app registry.ts)
- [x] All internal links resolve
- [x] Front matter is complete
- [x] Tags are appropriate
- [x] Sidebar positioning is correct

## Dependencies

- **Depends on:** Portfolio-App Stage 3.1 (registry implementation)
  - ADR documents the implementation
  - Schema guide mirrors actual schema in registry.ts
  - Timing: Can draft in parallel, but finalize after implementation

## Notes

- This documentation is the "contract" for the registry
- Schema guide will be referenced by contributors when adding projects
- ADR-0011 sets precedent for future content model decisions
- Keep examples synchronized with actual projects.yml

## Related Issues

- Depends on: Portfolio-App Stage 3.1 (Registry Implementation)
- Blocks: Stage 3.5 (Publish Runbook - references schema guide)
- Related: ADR-0012 (Cross-Repo Linking - future stage)

## Estimate

**3-4 hours total**

- ADR-0011: 2-3 hours
- Schema Guide: 2-3 hours
- Dossier Update: 1 hour
- Copilot Instructions: 30 min
- Build & Validation: 30 min

## Milestone

Phase 3 — Repeatable Project Publishing

## Labels

`documentation`, `phase-3`, `adr`, `reference`
