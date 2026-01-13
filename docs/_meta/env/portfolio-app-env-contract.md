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

- Path strategy: `https://yourdomain.com/docs`
- Subdomain strategy: `https://docs.yourdomain.com`

**Fallback behavior:** If unset, the app defaults to `"/docs"`. This is only correct if documentation is truly served at that path.

**Used by:** `DOCS_BASE_URL` and `docsUrl()` helper.

### Optional (recommended for production polish)

#### `NEXT_PUBLIC_SITE_URL`

**Purpose:** Canonical site URL for metadata/canonical links.  
**Example:** `https://yourdomain.com`  
**Behavior:** If unset, the app does not guess a production domain.

#### `NEXT_PUBLIC_GITHUB_URL`

**Purpose:** Public link to GitHub profile or org.  
**Example:** `https://github.com/<handle>`

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

- `NEXT_PUBLIC_DOCS_BASE_URL`
- `NEXT_PUBLIC_SITE_URL`
- `NEXT_PUBLIC_GITHUB_URL`
- `NEXT_PUBLIC_LINKEDIN_URL`
- Optional: `NEXT_PUBLIC_CONTACT_EMAIL`

## Validation

A configuration is considered valid when:

- Portfolio App loads locally without runtime errors
- Links to Documentation App resolve correctly in preview and production
- No sensitive values exist in `NEXT_PUBLIC_*` variables
- CI checks pass and production promotion is gated as required (where configured)

## References

- Portfolio App config module: `../portfolio/portfolio-app/src/lib/config.ts`
- Portfolio App dossier (Deployment): `docs/60-projects/portfolio-app/deployment.md`
- Portfolio App dossier (Security): `docs/60-projects/portfolio-app/security.md`
