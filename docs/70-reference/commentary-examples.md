---
title: 'Commentary Examples (Portfolio App)'
description: 'Short, canonical examples of rationale-first commentary across code, tests, and workflows.'
sidebar_position: 20
tags: [reference, commentary, portfolio-app, examples]
---

## Purpose

Provide short, copy-ready examples that follow the code commentary standard for portfolio-app.

See the standard: /docs/20-engineering/commentary-standard.md

Notes:

- Tags should match the standard (RATIONALE, ASSUMPTION, SECURITY, PERF, A11Y, FAILURE MODE, OPS).
- Keep comments to 1-3 short lines unless linking to a doc/ADR.

## Scope

### In scope

- TypeScript and React examples
- unit and E2E test commentary
- GitHub Actions YAML commentary
- JSON documentation patterns

### Out of scope

- full narrative explanations (use ADRs or engineering docs instead)
- exhaustive style guides for each language

## Examples

### TypeScript: public API with rationale and security boundaries

```ts
/**
 * Resolves the public base URL used for canonical links and metadata.
 *
 * RATIONALE: Compute this once to keep metadata consistent across runtime contexts
 * (local dev, preview, production) and to avoid relying on request headers.
 *
 * SECURITY: Must not trust unvalidated headers (host / x-forwarded-host) for canonical URL.
 * FAILURE MODE: Incorrect base URL can break SEO and future OIDC callback URLs.
 */
export function getPublicBaseUrl(): string {
  // ...
}
```

### TypeScript: non-obvious types and input boundaries

```ts
// RATIONALE: This branded type prevents mixing user-provided strings with validated IDs.
type ProjectSlug = string & { readonly __brand: "ProjectSlug" };

// SECURITY: `slug` originates from the route param (untrusted input). Validate/normalize before use.
export function normalizeSlug(slug: string): ProjectSlug {
  // ...
}
```

### React: client boundary and UX intent

```tsx
"use client";
// RATIONALE: Client component required for interactive state + event handlers.
// PERF: Keep client surface minimal; pass serialized props from server when possible.

export function ExpandableSection() {
  // RATIONALE: Collapsed by default to keep the landing page scannable for recruiters.
  // A11Y: Toggle must remain keyboard accessible and announce expanded state via aria-expanded.
  return null;
}
```

### Vitest: regression and security commentary

```ts
// REGRESSION: This failed when registry interpolation removed trailing slashes.
// SECURITY: Ensure untrusted slugs never produce external redirects.
it("guards against invalid project slugs", () => {
  // Arrange / Act / Assert
});
```

### Playwright: acceptance criteria and triage breadcrumbs

```ts
// RATIONALE: Validates the recruiter path remains functional after layout changes.
// ASSUMPTION: Base URL is set via PLAYWRIGHT_BASE_URL or defaults to localhost.
// FAILURE MODE: Broken nav links are a high-severity portfolio regression.

// OPS: If this fails in CI only, capture trace + screenshot, confirm Vercel preview is ready.
// See runbook: /docs/50-operations/runbooks/rbk-ci-triage.md
```

### YAML: workflow-level rationale

```yaml
# PURPOSE: CI quality gates for lint/typecheck/tests to protect main and staging.
# RATIONALE: Check names must remain stable because GitHub rulesets and Vercel promotion checks reference them.

jobs:
  quality:
    name: ci / quality
    steps:
      # RATIONALE: --frozen-lockfile ensures deterministic installs and prevents hidden lock drift.
      - run: pnpm install --frozen-lockfile
```

### JSON: document alongside the config

```md
# README.md (same folder as JSON config)

## Purpose
This config defines the public-safe registry schema contract for portfolio-app.

## Validation
Validated by pnpm registry:validate in CI and during pnpm verify.
```

## Validation / expected outcomes

- Examples are short enough to copy into code without reformatting.
- Comments explain why, not what.
- Security and performance boundaries are explicit.

## References

- Code commentary standard: `/docs/20-engineering/commentary-standard.md`
- Engineering standards: `/docs/20-engineering/index.md`
