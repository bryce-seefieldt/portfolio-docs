---
title: 'ADR-0011: Data-Driven Project Registry'
description: 'Adopt a YAML-backed, Zod-validated project registry with environment-aware URL construction as the single source of truth for portfolio projects.'
sidebar_position: 11
tags:
  [
    architecture,
    adr,
    registry,
    portfolio-app,
    governance,
    data-model,
    validation,
  ]
---

## Purpose

Document the decision to replace hardcoded project metadata with a YAML-backed registry that is validated at build time and consumed by the Portfolio App with type safety and environment-aware link construction.

## Scope

- Portfolio App data model and project metadata sourcing
- Validation and governance for project slugs, evidence links, and URLs
- Environment-aware link construction for documentation and GitHub references
- Excludes: moving the registry to a database or CMS (explicitly deferred)

## Prereqs / Inputs

- Decision date: 2026-01-20
- Status: Accepted
- Related work: Portfolio App Stage 3.1 (registry & validation)
- Dependencies: `js-yaml`, `zod`, `tsx`, environment variables (`NEXT_PUBLIC_*`)

## Decision Record

### Problem Statement

The Portfolio App stored project metadata in static TypeScript objects, making it error-prone to scale, difficult to validate, and brittle for evidence-link governance. Broken links or malformed slugs could ship undetected, and adding projects required code changes instead of data updates.

### Decision

Adopt a YAML-backed registry (`src/data/projects.yml`) validated by Zod in `src/lib/registry.ts`, with:

- Build-time validation that fails fast on invalid entries
- Slug format enforcement and duplicate detection
- Environment-aware URL construction (docs, GitHub) via interpolation
- Type-safe exports for components (`Project`, `EvidenceLinks`, `TechStackItem`)
- CLI validation/listing scripts (`pnpm registry:validate`, `pnpm registry:list`)

### Rationale

- YAML is human-readable and diff-friendly for contributors
- Zod provides runtime validation aligned with TypeScript types
- Build-time validation prevents broken links from shipping
- Environment-first link construction avoids hardcoded URLs and supports preview/production
- Data-driven model lets new projects be added without code changes

### Consequences

**Positive**

- Single source of truth; fewer drift points between docs and app
- Early failure for invalid slugs/URLs; safer releases
- Easier project additions (edit YAML + dossier) with type-safe consumption

**Negative / managed**

- Slight build overhead (~tens of ms for YAML parse + validation)
- Contributors must follow schema rules; validation will block if violated

### Implementation

- Registry file: `src/data/projects.yml` (with `metadata` header)
- Loader: `src/lib/registry.ts` (Zod schemas, interpolation, helpers)
- Types and helpers exported via `src/data/projects.ts`
- Scripts: `registry:validate`, `registry:list`
- Environment variables (public-safe): `NEXT_PUBLIC_DOCS_BASE_URL`, `NEXT_PUBLIC_GITHUB_URL`, `NEXT_PUBLIC_DOCS_GITHUB_URL`, `NEXT_PUBLIC_SITE_URL`

Example schema slice (Zod):

```ts
const ProjectSchema = z
  .object({
    slug: z.string().regex(/^[a-z0-9]+(?:-[a-z0-9]+)*$/),
    title: z.string().min(1),
    summary: z.string().min(10),
    category: z.enum([
      'fullstack',
      'frontend',
      'backend',
      'devops',
      'data',
      'mobile',
      'other',
    ]),
    tags: z.array(z.string()).min(1),
    status: z.enum(['featured', 'active', 'archived', 'planned']),
    evidence: EvidenceSchema.optional(),
  })
  .strict();
```

### Related Decisions

- [ADR-0005](adr-0005-portfolio-app-stack-nextjs-ts.md) — Stack choice (Next.js + TS + Tailwind)
- [ADR-0008](adr-0008-portfolio-app-ci-quality-gates.md) — CI quality gates and deterministic builds
- [ADR-0010](adr-0010-portfolio-app-as-gold-standard-exemplar.md) — Gold standard exemplar definition

### Alternatives Considered

1. Hardcoded TypeScript objects (current state)

- Pros: zero dependencies, fast access
- Cons: no validation, higher drift risk, code changes for data updates

2. JSON registry

- Pros: machine-friendly
- Cons: less readable for contributors; same validation story as YAML; no advantage over YAML here

3. Database or headless CMS

- Pros: rich querying, editorial workflows
- Cons: overkill for static portfolio needs; adds infra, auth, hosting, and secret management; higher maintenance

4. GitHub API as source of truth

- Pros: no separate data file
- Cons: requires auth for private data; does not capture evidence links or structured proofs; unstable for deterministic builds

### Migration Path

1. Create `projects.yml` with at least two entries (portfolio-app, portfolio-docs-app)
2. Implement loader with Zod validation and slug uniqueness checks
3. Add environment-aware interpolation for docs/GitHub URLs
4. Replace static exports in `src/data/projects.ts` with validated loader outputs
5. Add scripts: `registry:validate`, `registry:list`
6. Update dossiers and reference docs to describe the model
7. Add tests (Stage 3.3) to guard slug/URL rules

### Success Criteria

- Build fails on invalid registry entries (slug/URL/schema violations)
- App pages render using registry data without TypeScript errors
- Evidence links resolve via environment-aware helpers
- Adding a project requires only: edit YAML + add dossier (no code changes)
- CI enforces registry validation before merge

### References

- Portfolio App implementation: `src/lib/registry.ts`, `src/data/projects.yml`, `src/data/projects.ts`
- Validation scripts: `pnpm registry:validate`, `pnpm registry:list`
- Environment config: `src/lib/config.ts`
