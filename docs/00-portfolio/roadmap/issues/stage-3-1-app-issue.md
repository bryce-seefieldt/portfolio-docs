---
title: 'Stage 3.1 — Data-Driven Project Registry & Validation (App)'
description: 'Implements a YAML-backed project registry with Zod validation and helper utilities to standardize project metadata and evidence links.'
tags:
  [portfolio, roadmap, planning, phase-3, stage-3.1, app, registry, validation]
---

# Stage 3.1: Data-Driven Project Registry & Validation

https://github.com/bryce-seefieldt/portfolio-app/issues/23#issue-3835851437

## Overview

Implement a YAML-backed project registry with TypeScript validation to enable scalable, low-error project publishing. This replaces hardcoded project metadata with a single source of truth that validates at build time.

## Objectives

- Create a structured, type-safe registry for all portfolio projects
- Enforce validation rules for slugs, evidence links, and required fields
- Provide helper functions for link construction and project lookup
- Enable zero-magic-string consumption in components

## Scope

### Files to Create

1. **`src/data/projects.yml`** - YAML registry (single source of truth)
   - Structured project metadata (title, slug, category, tags, dates)
   - Tech stack with categories and rationale
   - Key proofs demonstrating capabilities
   - Evidence links (dossier, threat model, ADRs, runbooks, GitHub)

2. **`src/lib/registry.ts`** - TypeScript loader and validation
   - Zod schema for project entries
   - Runtime validation
   - Type-safe loader function
   - Link construction helpers
   - Slug uniqueness enforcement

### Files to Update

3. **`src/data/projects.ts`** - Update to export from registry
   - Replace hardcoded data with registry loader
   - Export typed project array

4. **`package.json`** - Add validation scripts
   - `pnpm registry:validate` - Validate registry without building
   - `pnpm registry:list` - List all projects from registry

### Dependencies to Add

- `js-yaml` - YAML parsing
- `@types/js-yaml` - TypeScript types for YAML
- `zod` - Runtime schema validation (if not already installed)

## Schema Design

### Project Entry Structure

```yaml
- title: 'Project Title'
  slug: project-slug
  description: 'One-sentence description'
  category: [fullstack|frontend|backend|devops|data|mobile|other]
  tags: [list, of, tags]
  startDate: 'YYYY-MM'
  endDate: 'YYYY-MM' # Optional
  ongoing: true # Optional
  techStack:
    - name: Technology
      category: [language|framework|library|tool|platform]
      rationale: 'Why this tech was chosen'
  keyProofs:
    - 'What this project demonstrates'
  evidence:
    dossier: 'docs/60-projects/PROJECT_SLUG/'
    threatModel: 'docs/40-security/threat-models/PROJECT_SLUG-threat-model'
    adr:
      - title: 'ADR Title'
        url: 'docs/10-architecture/adr/adr-XXXX-decision'
    runbooks:
      - title: 'Runbook Title'
        url: 'docs/50-operations/runbooks/rbk-PROJECT_SLUG-action'
    github: 'https://github.com/bryce-seefieldt/PROJECT_SLUG'
  isGoldStandard: false
  goldStandardReason: 'Why this is gold standard (if applicable)'
```

## Validation Rules

1. **Slug Format:** `^[a-z0-9]+(?:-[a-z0-9]+)*$`
   - Lowercase only
   - Alphanumeric + hyphens
   - No spaces, underscores, or special characters
   - No consecutive hyphens

2. **Slug Uniqueness:** No duplicate slugs across all projects

3. **Required Fields:**
   - `title` (min 3 characters)
   - `slug` (valid format)
   - `description` (min 10 characters)
   - `category` (valid enum value)
   - `tags` (at least 1)
   - `startDate` (YYYY-MM format)
   - `techStack` (at least 1 item)
   - `keyProofs` (at least 1 item)

4. **Evidence Link Validation:**
   - All URLs must be valid
   - Dossier links should start with `docs/60-projects/`
   - Threat model links should include `threat-model`

## Implementation Tasks

### Phase 1: Schema & Loader (3-4 hours)

- [x] Install dependencies: `pnpm add js-yaml && pnpm add -D @types/js-yaml`
- [x] Create `src/lib/registry.ts` with:
  - [x] Zod schema definitions (`ProjectSchema`, `ProjectEvidenceSchema`, `TechStackItemSchema`)
  - [x] `loadProjectRegistry()` function
  - [x] `findProjectBySlug(slug: string)` function
  - [x] `validateEvidenceLinks()` function
- [x] Create link construction helpers:
  - [x] `constructDocsLink(pathname: string)` using `NEXT_PUBLIC_DOCS_BASE_URL`
  - [x] `constructGitHubLink(repo: string, path: string)` using `NEXT_PUBLIC_DOCS_GITHUB_URL`
- [x] Export TypeScript types for component consumption

### Phase 2: Registry Data (2 hours)

- [x] Create `src/data/projects.yml` with initial entries:
  - [x] Portfolio App project (current gold standard)
  - [x] Portfolio Docs project
  - [x] 1-2 placeholder projects for testing
- [x] Include metadata section with version and lastUpdated
- [x] Validate YAML syntax

### Phase 3: Integration (1-2 hours)

- [x] Update `src/data/projects.ts`:
  - [x] Import `loadProjectRegistry` from `@/lib/registry`
  - [x] Export `projects` constant from loader
  - [x] Export `Project` type for components
- [x] Add package.json scripts:
  - [x] `"registry:validate": "tsx scripts/validate-registry.ts"`
  - [x] `"registry:list": "tsx scripts/list-projects.ts"`
- [x] Create helper scripts in `scripts/` directory (optional) — _Uses CLI entrypoint in registry.ts_

### Phase 4: Testing & Validation (1-2 hours)

- [x] Test registry loading locally: `pnpm build`
- [x] Verify TypeScript compilation succeeds
- [x] Test project lookup by slug
- [x] Verify link construction helpers
- [x] Run validation script: `pnpm registry:validate`
- [x] Check for broken links or invalid entries

## Acceptance Criteria

- [x] Registry validates on load (build fails if invalid)
- [x] TypeScript types are exported and usable
- [x] All slugs are unique and follow format rules
- [x] Link construction is centralized and env-first
- [x] `pnpm build` succeeds with 0 TypeScript errors
- [x] At least 2 projects in registry (portfolio-app, portfolio-docs)
- [x] Evidence links are structured correctly
- [x] Package scripts enable local validation

## Testing

### Manual Testing

```bash
# Install dependencies
pnpm install

# Validate registry
pnpm registry:validate

# Build application (includes registry loading)
pnpm build

# Start dev server
pnpm dev

# Navigate to project pages
# Verify data loads from registry
```

### Validation Checks

- [x] No TypeScript errors during build
- [x] Project pages render with registry data
- [x] Slug validation catches invalid formats
- [x] Duplicate slug detection works
- [x] Link helpers construct correct URLs

## Notes

- This is a prerequisite for Stage 3.2 (EvidenceBlock component)
- Registry will be consumed by project detail pages
- Future stages will add unit tests for validation logic
- Keep registry entries public-safe (no secrets, internal endpoints)

## Related Issues

- Blocks: Stage 3.2 (EvidenceBlock component)
- Blocks: Stage 3.3 (Unit tests)
- Related: Portfolio-Docs ADR-0011 (Registry Decision)

## Estimate

**6-8 hours total**

- Schema & Loader: 3-4 hours
- Registry Data: 2 hours
- Integration: 1-2 hours
- Testing: 1-2 hours

## Milestone

Phase 3 — Repeatable Project Publishing

## Labels

`enhancement`, `phase-3`, `registry`, `governance`
