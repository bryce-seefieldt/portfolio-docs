---
title: 'Portfolio App: Architecture'
description: 'Architecture of the Portfolio App: Next.js boundaries, content model, evidence-link strategy, and scalability patterns.'
sidebar_position: 2
tags: [projects, architecture, nextjs, typescript, content-model, portfolio]
---

## Purpose

Describe the Portfolio App architecture at a level that is:

- specific enough to guide implementation
- credible to enterprise reviewers
- maintainable as the portfolio expands

## Scope

### In scope

- framework choice and major boundaries (Next.js App Router)
- routing and information architecture for the app
- content model for projects and CV data
- integration pattern with Documentation App evidence pages

### Out of scope

- CI/CD implementation details (see `deployment.md`)
- security threat enumeration (see `security.md`)

## Prereqs / Inputs

- Next.js (App Router) + TypeScript baseline planned
- Hosting target: Vercel
- Evidence engine exists in Docusaurus and is publicly accessible at `/docs` or a subdomain

## Procedure / Content

## System boundaries

### Portfolio App responsibilities (“front-of-house”)

- provide a polished, fast, product-like UX
- present core narrative: value proposition, CV, projects, contact
- link to evidence artifacts hosted in Docusaurus
- avoid overloading the app with long-form governance docs (keep evidence in docs engine)

### Documentation App responsibilities (“evidence engine”)

- host deep technical documentation:
  - dossiers, ADRs, threat models, runbooks, postmortems
- provide traceability and enterprise governance narrative

## Routing and UX architecture (recommended vs current)

Note: Items marked (implemented) exist in Phase 1. Items marked (planned) are illustrative and not yet implemented.

- `/` — landing, “Start Here,” primary narrative (implemented)
- `/cv` — interactive CV (timeline + skill proof) (implemented)
- `/projects` — curated gallery (implemented)
- `/projects/[slug]` — project details (evidence links) (implemented)
- `/contact` — static contact method (no auth, no form initially) (implemented)
- `/labs` — experiments / prototypes / R&D notes (optional) (planned)
- `/security` — public security posture summary (high-level, safe) (planned)

## Content model (pragmatic and scalable)

### Principle: data-driven content, components for presentation

Use structured data for:

- project list and metadata
- CV timeline entries
- skills and capability proof links
- evidence links mapping to Docusaurus paths

Recommended initial approach (low complexity):

- store project metadata in structured files (JSON/YAML/TS objects)
- generate pages from the data model with stable slugs
- keep long-form writeups in Docusaurus, linked from project pages

### Evidence-link strategy

Each project entry should include:

- repo URL
- demo URL (if applicable)
- “Read the dossier” URL (Docusaurus path)
- optional: threat model / runbook links

Example evidence link types:

- dossier: `/docs/60-projects/<project>/`
- ADR: `/docs/10-architecture/adr/adr-xxxx-...`
- threat model: `/docs/40-security/threat-models/<project>-threat-model`
- runbooks: `/docs/50-operations/runbooks/`

## Component boundaries (recommended)

- `app/` routes:
  - route-level layout and metadata
- `components/`:
  - design system primitives and page-level components
- `content/` (or `data/`):
  - structured portfolio metadata and project definitions
- `lib/`:
  - utilities and helpers (data validation, slug generation)
- `public/`:
  - static assets with stable names
- `tests/`:
  - unit and e2e tests (phased)

## Repository structure (current)

Key paths and roles in the Portfolio App repo:

- `src/app/*` — App Router pages and layouts (implemented routes):
  - `/` — landing
  - `/cv` — interactive CV scaffold
  - `/projects` — project index
  - `/projects/[slug]` — project details
  - `/contact` — static contact surface
- `src/lib/config.ts` — public-safe configuration contract and helpers:
  - reads `NEXT_PUBLIC_*` env vars
  - provides `DOCS_BASE_URL`, `docsUrl(path)`, and `mailtoUrl()`
  - normalizes/validates public URLs
- `src/data/projects.ts` — project registry placeholder:
  - stable slugs, titles, summaries, tags, status
  - optional evidence link paths into the Documentation App (dossier, ADR index, threat models, runbooks)

## Routing and evidence-link strategy

- Documentation base URL is configured via environment variable `NEXT_PUBLIC_DOCS_BASE_URL`.
- The app centralizes this via `src/lib/config.ts` and the `docsUrl()` helper to build stable evidence links.
- Project pages should derive evidence links from `src/data/projects.ts` where possible to keep slugs and paths consistent with the Documentation App.
- This separation keeps the Portfolio App concise while ensuring every major claim links to verifiable evidence in the docs site.

## Component architecture and design system

### Principle: Utility-first composition

The Portfolio App uses **Tailwind CSS v4** with a utility-first approach to styling and component composition.

Reusable component primitives:

- `<Callout>` — styled content container for emphasis (announcements, warnings, key takeaways)
- `<Section>` — page section with title, optional subtitle, and consistent spacing/borders

Component organization:

- Route-level components: page.tsx files in `src/app/*`
- Layout components: `src/app/layout.tsx` (navigation, footer, metadata)
- Shared primitives: `src/components/*`

### Dark mode strategy

- System preference-based (uses `prefers-color-scheme` media query)
- No explicit toggle UI in Phase 1 (intentional minimalism)
- All components use Tailwind `dark:` variants for dark mode styling
- Future: consider explicit toggle with local storage (Phase 2+)

### Styling patterns

- Tailwind utility classes for all styling (no CSS modules or styled-components)
- Consistent design tokens: spacing, colors, borders, shadows
- Automatic class sorting via `prettier-plugin-tailwindcss`
- Responsive design: mobile-first with `sm:`, `md:`, `lg:` breakpoints

## Navigation and information architecture

### Top navigation

Fixed header with:

- Portfolio branding/logo (links to `/`)
- CV, Projects, Evidence (Docs), Contact
- Evidence link opens Documentation App in same/new tab

### Footer

- Social links: GitHub, LinkedIn (if configured)
- Documentation App link
- Enterprise evidence model statement

### Intentional omissions (Phase 1)

- No dark mode toggle (system preference only)
- No authentication or user accounts
- No search (deferred to docs app or Phase 3+)

## Metadata and SEO strategy

### Current approach

Metadata configured in `src/app/layout.tsx`:

- Title template: `"%s | Portfolio"` (appended to page-level titles)
- Description: concise value proposition
- `metadataBase`: intentionally `undefined` (deferred until production domain finalized)

### Future enhancements (Phase 2+)

- OpenGraph tags for social sharing
- Twitter card metadata
- Structured data (JSON-LD) for projects and CV
- Canonical URLs once domain is live

## Toolchain and runtime

### Node version policy

- Node 20 LTS (pinned in `.nvmrc`)
- Rationale: Deterministic builds, active LTS with security support
- Upgrade policy: Follow Node.js LTS schedule; document via ADR

### React Compiler

- Enabled via `next.config.ts` (`reactCompiler: true`)
- Automatic optimization of components and hooks
- See ADR-0009 for decision rationale and validation criteria

### Package manager

- pnpm 10 (pinned in `package.json` `packageManager` field)
- Deterministic installs with frozen lockfile in CI

## Scalability considerations

- adding projects should be "cheap":
  - add metadata + assets + evidence links; page generates automatically
- avoid heavy dynamic backend early:
  - keep the system static-first; add APIs only via ADR
- keep performance strong:
  - minimize client-side JS; prefer server components where appropriate
  - React Compiler optimizes re-renders automatically

## Validation / Expected outcomes

- New project pages can be added without re-architecting routing
- Evidence links are consistent and trustworthy
- The app remains fast and accessible
- Architecture is explainable in a concise diagram and ADR(s)

## Failure modes / Troubleshooting

- Content sprawl inside the app → move long-form content into Docusaurus
- Inconsistent slugs and broken project routes → enforce slug rules and add tests
- Evidence links break due to docs reorg → treat as breaking change; update references and release notes

## References

- Portfolio App dossier hub: `docs/60-projects/portfolio-app/index.md`
- Documentation App dossier: `docs/60-projects/portfolio-docs-app/`
- ADRs: `docs/10-architecture/adr/`

---

## Technology Stack (Complete Inventory)

### Core Framework

- Next.js: v16.1.3 (App Router, React Server Components, static optimization)
- React: v19.2.3 (concurrent features, automatic batching)
- TypeScript: v5+ (strict mode, noEmit for type-only checks)

### Styling & UI

- Tailwind CSS: v4 (utility-first, JIT compilation)
- @tailwindcss/postcss: v4 (CSS processing)
- CSS Modules: Built-in (component-scoped styles)

### Build & Development

- pnpm: v10.0.0 (fast, efficient, frozen lockfiles in CI)
- Next.js Compiler: SWC-based (Rust)
- React Compiler: babel-plugin-react-compiler v1.0.0 (optimization)

### Testing & Quality

- Playwright: v1.57.0 (E2E smoke tests, multi-browser)
- ESLint: v9 (flat config, Next.js presets, TypeScript integration)
- Prettier: v3.8.0 (code formatting, Tailwind plugin)
- wait-on: v9.0.3 (dev server readiness in CI)

### CI/CD & Governance

- GitHub Actions: Quality + build jobs
- Vercel: Preview + production deployments
- CodeQL: JavaScript/TypeScript security scanning
- Dependabot: Weekly dependency updates (grouped, majors excluded)

### Notable Decisions

- No authentication: Intentionally deferred (public portfolio)
- No database: Static content model (scalable via data files)
- No form backend: Contact via static methods (email link)
- Evidence links: Deep integration with Docusaurus documentation

## High-Level Request Flow

```
┌─────────────┐
│  Browser    │
└──────┬──────┘
  │ HTTPS GET /projects/portfolio-app
  ↓
┌─────────────────────┐
│   Vercel Edge       │ (CDN, SSL termination)
└──────┬──────────────┘
  │
  ↓
┌─────────────────────────────────────┐
│   Next.js App Router                │
│   - Route: /projects/[slug]         │
│   - Server Component (async params) │
│   - getProjectBySlug(slug)          │
│   - notFound() if missing           │
└──────┬──────────────────────────────┘
  │
  ↓
┌─────────────────────────────┐
│   Project Data (src/data/)  │
│   - PROJECTS array          │
│   - Static metadata         │
└──────┬──────────────────────┘
  │
  ↓
┌──────────────────────────────────┐
│   Component Rendering            │
│   - Section components           │
│   - Evidence links (to /docs)    │
│   - Tailwind styling             │
└──────┬───────────────────────────┘
  │
  ↓
┌──────────────────────┐
│   HTML Response      │ (static-optimized, RSC payload)
└──────────────────────┘
```

## Component Architecture

```
src/
├── app/ # Next.js App Router
│   ├── layout.tsx      # Root layout (global nav, metadata)
│   ├── page.tsx        # Landing page (/)
│   ├── cv/
│   │   └── page.tsx    # CV route
│   ├── projects/
│   │   ├── page.tsx    # Projects list
│   │   └── [slug]/
│   │       └── page.tsx# Dynamic project detail
│   └── contact/
│       └── page.tsx    # Contact page
├── components/         # Reusable components
│   ├── Section.tsx     # Content section wrapper
│   └── Callout.tsx     # Highlighted content blocks
├── data/
│   └── projects.ts     # Project registry (typed)
└── lib/
    └── config.ts       # Environment config helpers
```

## Scalability Patterns

Current (Phase 2):
- Static project data in TypeScript (typed, version-controlled)
- Manual content updates via code changes + PRs
- Evidence links hardcoded per project

Planned (Phase 3+):
- CMS or API-driven project data (Contentful, headless CMS)
- Automated evidence link validation
- Tag-based filtering and search
