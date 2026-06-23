---
title: 'Portfolio App Environment Variable Contract'
description: 'Internal-only contract documenting required and optional environment variables for the Portfolio App, including public-safe handling rules.'
tags: [meta, env, portfolio-app, contract, configuration, public-safety]
---

## Purpose

Define the canonical environment variable contract for the **Portfolio App** (Next.js + TypeScript). This is an internal-only reference to ensure consistent local development, CI, and hosting configuration while preserving public-safety requirements.

## Public-safety rules (non-negotiable)

- All variables prefixed with `NEXT_PUBLIC_` are **client-exposed** and must be treated as publicly readable.
- Never place secrets, tokens, internal hostnames, private endpoints, or sensitive values in `NEXT_PUBLIC_*` variables.
- Secret values must remain server-only and must not be referenced in client components.
- If sensitive publication is suspected, treat it as an incident: revert, rotate, postmortem.

## Variable inventory

### Required (recommended minimum)

#### `NEXT_PUBLIC_DOCS_BASE_URL`

**Purpose:** Base URL for the Documentation App evidence engine.  
**Examples:**

- Local development: `http://localhost:3001`
- Preview deployments: `https://bns-portfolio-docs.vercel.app/docs`
- Production (path-based): `https://bryce.seefieldt.ca/docs`

**Fallback behavior:** If unset, the app defaults to `"/docs"`. This is only correct if documentation is truly served at that path.

**Used by:** `DOCS_BASE_URL` and `docsUrl()` helper.

**Note on `/docs` routing:** The Portfolio App serves `/docs/*` via Vercel edge-layer rewrites in `vercel.json` — not via an env var. `NEXT_PUBLIC_DOCS_BASE_URL` controls how evidence links are constructed in the browser; the actual request routing to `bns-portfolio-docs.vercel.app` is handled separately at the edge. Do not set `DOCS_UPSTREAM_URL` in Vercel — it is deprecated and unused.

### Optional (recommended for production polish)

#### `NEXT_PUBLIC_SITE_URL`

**Purpose:** Canonical site URL for metadata/canonical links.  
**Example:** `https://yourdomain.com`  
**Behavior:** If unset, the app does not guess a production domain.

#### `NEXT_PUBLIC_GITHUB_BASE_URL`

**Purpose:** Public link to GitHub profile or org (used for profile-facing links in page UI).  
**Example:** `https://github.com/<handle>`

#### `NEXT_PUBLIC_GITHUB_URL`

**Purpose:** Public repository base URL (used for repo-path link construction helpers).  
**Example:** `https://github.com/<handle>/<repo>`

#### `NEXT_PUBLIC_LINKEDIN_URL`

**Purpose:** Public link to LinkedIn profile.  
**Example:** `https://www.linkedin.com/in/<handle>/`

#### `NEXT_PUBLIC_CONTACT_EMAIL`

**Purpose:** Optional email address used only for `mailto:` links (no form).  
**Example:** `you@domain.com`  
**Guidance:** If unset, prefer GitHub/LinkedIn as the contact surface.

### Hosting-provided (do not set manually)

#### `VERCEL_ENV`

**Purpose:** Deployment environment hint provided by Vercel.  
**Values:** `production`, `preview`, `development`  
**Guidance:** Do not set locally; treat as informational only (e.g., optional banners/diagnostics).

## File locations and lifecycle

### Portfolio App repo

- Commit: `./.env.example` (contains blanks and guidance only)
- Do not commit: `./.env.local`
- Local development:
  - copy `.env.example` → `.env.local`
  - fill in non-sensitive values

### Vercel configuration

Set environment variables in Vercel Project Settings for:

- Preview environment (to match behavior in PR previews)
- Production environment (canonical URLs)

Minimum recommended in Vercel:

- `NEXT_PUBLIC_DOCS_BASE_URL` (e.g., `https://bryce.seefieldt.ca/docs` for production)
- `NEXT_PUBLIC_SITE_URL` (e.g., `https://bryce.seefieldt.ca`)
- `NEXT_PUBLIC_GITHUB_BASE_URL`
- `NEXT_PUBLIC_GITHUB_URL`
- `NEXT_PUBLIC_LINKEDIN_URL`
- Optional: `NEXT_PUBLIC_CONTACT_EMAIL`

> **Do not set** `DOCS_UPSTREAM_URL` — this variable is deprecated. The `/docs` reverse-proxy rewrite is now handled by `vercel.json` at the Vercel edge layer with no env var dependency.

## CI determinism (required)

To keep builds reproducible and trustworthy:

- CI installs MUST use a frozen lockfile:

  ```bash
  pnpm install --frozen-lockfile
  ```

- Commit lockfile updates deliberately in a PR with rationale when dependency graphs change.
- Before opening a PR, run the local quality contract:

  ```bash
  pnpm lint && pnpm format:check && pnpm typecheck && pnpm build
  ```

## Validation

A configuration is considered valid when:

- Portfolio App loads locally without runtime errors
- Links to Documentation App resolve correctly in preview and production
- No sensitive values exist in `NEXT_PUBLIC_*` variables
- CI checks pass and production promotion is gated as required (where configured)

## References

- Portfolio App config module: `portfolio-app/src/lib/config.ts`
- Portfolio App dossier (Deployment): `docs/60-projects/portfolio-app/03-deployment.md`
- Portfolio App dossier (Security): `docs/60-projects/portfolio-app/04-security.md`
- Runbooks:
  - Deploy: `docs/50-operations/runbooks/rbk-portfolio-deploy.md`
  - CI triage: `docs/50-operations/runbooks/rbk-portfolio-ci-triage.md`
  - Rollback: `docs/50-operations/runbooks/rbk-portfolio-rollback.md`
