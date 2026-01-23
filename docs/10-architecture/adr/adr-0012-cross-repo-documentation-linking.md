---
title: 'ADR-0012: Cross-Repo Documentation Linking Strategy'
description: 'Environment-first URL construction for portable, consistent linking across portfolio-app and portfolio-docs repositories.'
sidebar_position: 0012
tags:
  [
    adr,
    architecture,
    phase-3,
    linking,
    cross-repo,
    environment-variables,
    portability,
  ]
---

## Problem Statement

The Portfolio App and Portfolio Docs are separate repositories with independent deployments:

- **portfolio-app:** Next.js app hosted at `https://yourdomain.com` (or `http://localhost:3000` locally)
- **portfolio-docs:** Docusaurus site hosted at `https://docs.yourdomain.com` (or `http://localhost:3001/docs` locally)

Challenges arise when linking across repos:

1. **URL hardcoding:** Links to documentation are hardcoded in the app (e.g., `https://docs.yourdomain.com/docs/...`), making them fragile if domains change
2. **Environment variability:** Local development URLs differ from staging and production URLs; developers must edit files to test different environments
3. **Deployment dependencies:** The app must know the docs domain to render correct links; breaking deployments if the docs domain changes
4. **Testing complexity:** Unit tests cannot assume a specific domain; environment-based testing is inconsistent
5. **Portability:** If the portfolio is cloned/forked, hardcoded URLs become invalid; users must hunt for and update all references

**Trigger:** Phase 3 evidence-first architecture requires extensive cross-repo linking (dossier paths, ADRs, threat models, runbooks). A scalable, portable linking strategy is essential.

---

## Decision

Use **environment-first URL construction** with helper functions that resolve domains from environment variables:

### 1. Environment Variables (Build-Time)

Define public-safe environment variables in `.env.example` and CI/CD:

```
NEXT_PUBLIC_DOCS_BASE_URL=https://docs.yourdomain.com
NEXT_PUBLIC_GITHUB_URL=https://github.com/yourname
NEXT_PUBLIC_DOCS_GITHUB_URL=https://github.com/yourname/portfolio-docs
NEXT_PUBLIC_SITE_URL=https://yourdomain.com
```

**Public-safe rule:** Only prefix `NEXT_PUBLIC_*` variables are exposed to the client.

### 2. Helper Functions in `src/lib/config.ts`

Three helper functions resolve documentation links:

```typescript
// Constructs docs URL from path
docsUrl(path: string): string => `${DOCS_BASE_URL}/${path}`

// Constructs GitHub app repo URL
githubUrl(path: string): string => `${GITHUB_URL}/${path}`

// Constructs docs GitHub repo URL
docsGithubUrl(path: string): string => `${DOCS_GITHUB_URL}/${path}`
```

**Behavior:**

- If environment variable is set: returns fully qualified URL
- If environment variable is unset: returns placeholder (`"#"`) for testing

### 3. Registry Interpolation

Project registry (`src/data/projects.yml`) uses placeholders for evidence URLs:

```yaml
projects:
  - slug: portfolio-app
    evidence:
      dossierPath: projects/portfolio-app/
      github: '{GITHUB_URL}'
    repoUrl: '{GITHUB_URL}/portfolio-app'
```

Loader interpolates placeholders at build time:

```
{GITHUB_URL} → https://github.com/yourname (from env)
{DOCS_BASE_URL} → https://docs.yourdomain.com (from env)
```

### 4. Build-Time Validation

Environment variables are read once at build time; links are embedded in static HTML. No runtime overhead.

---

## Rationale

### Why environment variables?

- **Portable:** Same code works in local dev (`:3000`), staging (`staging.yourdomain.com`), and production (`yourdomain.com`)
- **Non-invasive:** No file edits required to deploy to different environments
- **Standard practice:** Environment-based configuration is the industry standard (Node.js, Next.js, AWS, Docker, etc.)
- **Secure:** Variables prefixed `NEXT_PUBLIC_*` are explicitly public-safe; no secrets leaked

### Why build-time resolution?

- **Zero runtime cost:** Links are resolved once during build; no lookup at request time
- **Deterministic:** Same build always produces same URLs
- **Testable:** Unit tests can mock environment variables and verify behavior
- **Static site optimized:** Aligns with static HTML generation (no runtime dynamic behavior)

### Why helper functions?

- **Consistency:** Single pattern for all cross-repo links
- **Maintainability:** Changing URL logic requires edit in one place (`src/lib/config.ts`)
- **Testability:** Functions are pure; unit tests validate behavior in isolation
- **Type safety:** TypeScript ensures all calls are correct

### Why registry placeholders?

- **Data-driven:** Projects need not import helpers; placeholders are part of data
- **Flexibility:** Project metadata can be added without understanding helper function contracts
- **Validation:** Zod schema validates placeholder format; prevents typos
- **Future-proof:** If linking strategy changes, update loader logic; registry schema stays stable

---

## Consequences

### Positive

✅ **Portable:** Same codebase works in local dev, CI, staging, and production without changes  
✅ **Testable:** Environment variables can be mocked in unit tests for consistent behavior  
✅ **Maintainable:** Link construction logic centralized in `src/lib/config.ts`  
✅ **Scalable:** New cross-repo links use same pattern; consistent URL construction  
✅ **Explicit:** Environment variables documented in `.env.example`; no guessing required  
✅ **Non-invasive:** Links work immediately on clone without secret setup (public-safe)  
✅ **Forked-friendly:** If portfolio is forked, users only need to update `.env` file

### Negative / Managed

❌ **Environment dependency:** CI/CD pipelines must set environment variables correctly  
❌ **Configuration brittleness:** Typos in env var names silently produce broken links  
❌ **Documentation burden:** Contributors must understand env variable contract

### Mitigation

- **CI/CD setup:** Document environment variables in `.env.example` and README; CI workflow sets variables
- **Configuration validation:** `pnpm verify` step validates that required env vars are present
- **Helper documentation:** Explain helpers in copilot-instructions.md with examples
- **Tests:** Unit tests verify helpers return correct URLs when env is set/unset

---

## Alternatives Considered

### 1. Hardcoded URLs (Current Approach)

```typescript
const docsBase = 'https://docs.yourdomain.com';
```

**Why rejected:**

- Not portable; different URLs required for local dev vs. production
- Requires file edits to test different environments
- Breaks if domains change; single point of failure
- Not suitable for forks/clones

### 2. Relative URLs

```
/docs/projects/portfolio-app/ (assumes same root domain)
```

**Why rejected:**

- Only works if docs served from same domain (e.g., `/docs` path)
- Does not work for subdomain setup (e.g., `docs.yourdomain.com`)
- Breaks cross-domain linking; not flexible enough

### 3. Runtime Configuration API

```typescript
const getConfig = async () => {
  const res = await fetch('/.config.json');
  return res.json();
};
```

**Why rejected:**

- Additional HTTP request for every page load
- Configuration not available at build time
- Incompatible with static site generation
- More complexity for zero benefit

### 4. Link Inference from DNS/Hostname

```typescript
const docsBase = new URL(process.env.SITE_URL).hostname.replace(
  /^(www\.)?/,
  'docs.'
);
```

**Why rejected:**

- Assumes naming convention; fragile
- Does not work if docs served on different domain structure
- Hidden logic; contributors confused about where URLs come from

### 5. Git Submodules / Monorepo

```
portfolio/
  apps/
    app/
    docs/
```

**Why rejected:**

- Combines two projects that should be separate
- Adds deployment complexity (both must deploy together)
- Less flexible for independent scaling
- Contradicts "evidence engine" design principle

---

## Implementation

### Phase 1: Environment-First Configuration (Stage 3.1)

- Created `src/lib/config.ts` with helpers `docsUrl()`, `githubUrl()`, `docsGithubUrl()`
- Exported constants: `DOCS_BASE_URL`, `GITHUB_URL`, `DOCS_GITHUB_URL`, `SITE_URL`
- Created `.env.example` documenting all public environment variables
- Updated `src/lib/registry.ts` to interpolate placeholders at load time
- Added CI workflow env vars in `.github/workflows/ci.yml`

**Key code:**

```typescript
// src/lib/config.ts
export const DOCS_BASE_URL = normalizeBaseUrl(
  env.NEXT_PUBLIC_DOCS_BASE_URL?.trim() || '/docs'
);
export const GITHUB_URL = asAbsoluteUrl(env.NEXT_PUBLIC_GITHUB_URL);

export function docsUrl(path: string): string {
  return `${DOCS_BASE_URL}/${path.replace(/^\/+/, '')}`;
}

export function githubUrl(path: string): string {
  return GITHUB_URL ? `${GITHUB_URL}/${path}` : '#';
}
```

### Phase 2: Evidence Links in Registry (Stage 3.1)

- Updated `src/data/projects.yml` to use placeholders (`{GITHUB_URL}`, `{DOCS_BASE_URL}`)
- Loader validates URLs after interpolation
- Evidence schema supports dossier, threat model, ADR, runbook paths

### Phase 3: Unit & E2E Tests (Stage 3.3)

- `src/lib/__tests__/config.test.ts`: 18 tests verifying `docsUrl()`, `githubUrl()` behavior with env vars set/unset
- `e2e/evidence-links.spec.ts`: 12 Playwright tests verifying evidence links resolve correctly
- CI workflow exports required variables for tests to pass

---

## Validation & Testing

### Build-Time Validation

When `pnpm build` runs:

1. `src/data/projects.yml` loaded
2. Environment variables read from `process.env`
3. Placeholders interpolated: `{GITHUB_URL}` → `https://github.com/...`
4. Registry validated by Zod
5. Helper functions embedded in bundle
6. If any links are invalid: Build fails with clear error

### Unit Tests

```typescript
describe('docsUrl', () => {
  it('returns docs URL when env is set', () => {
    process.env.NEXT_PUBLIC_DOCS_BASE_URL = 'https://docs.example.com';
    expect(docsUrl('projects/portfolio')).toBe(
      'https://docs.example.com/projects/portfolio'
    );
  });

  it('defaults to /docs when env is unset', () => {
    delete process.env.NEXT_PUBLIC_DOCS_BASE_URL;
    expect(docsUrl('projects/portfolio')).toBe('/docs/projects/portfolio');
  });
});
```

### E2E Tests

```typescript
test('evidence links resolve correctly', async ({ page }) => {
  await page.goto('/projects/portfolio-app');
  const docsLink = page.locator('a[href*="/docs/"]');
  await expect(docsLink).toHaveAttribute(
    'href',
    /https:\/\/(docs\.)?example\.com\/docs\//
  );
});
```

---

## Success Criteria

This decision is considered successful if:

- ✅ Links work in local dev without editing files
- ✅ Links work in CI with environment variables set
- ✅ Links work in production with production domains
- ✅ Unit tests verify helper functions return correct URLs
- ✅ E2E tests verify evidence links resolve
- ✅ Cloning the repo and updating `.env` makes all links portable
- ✅ Adding new cross-repo links follows same pattern
- ✅ No hardcoded domains in application code

---

## Related Documentation

- **Config Reference:** [src/lib/config.ts](https://github.com/bryce-seefieldt/portfolio-app/tree/main/src/lib/config.ts)
- **Environment Variables:** [.env.example](https://github.com/bryce-seefieldt/portfolio-app/tree/main/.env.example)
- **Registry Implementation:** [src/lib/registry.ts](https://github.com/bryce-seefieldt/portfolio-app/tree/main/src/lib/registry.ts)
- **Portfolio App Dossier:** [docs/60-projects/portfolio-app/index.md](docs/60-projects/portfolio-app/index.md)

### Related ADRs

- **ADR-0011:** [Data-Driven Project Registry](adr-0011-data-driven-project-registry.md)
- **ADR-0006:** [Separate Portfolio App from Evidence Engine](adr-0006-separate-portfolio-app-from-evidence-engine-docs.md)
- **ADR-0005:** [Stack Choice (Next.js + TypeScript)](adr-0005-portfolio-app-stack-nextjs-ts.md)

---

## Questions & Feedback

**Q: What if a domain has a non-standard path structure (e.g., `/portfolio/docs` instead of `/docs`)?**

A: Set `NEXT_PUBLIC_DOCS_BASE_URL=https://yourdomain.com/portfolio/docs` and all links will use that path. The helper function is flexible.

**Q: Can I hardcode fallback URLs if env vars are unset?**

A: No. The pattern uses placeholders (e.g., `"#"`) to make missing configuration explicit. This ensures broken links are obvious during testing, not silent failures in production.

**Q: What if the docs domain changes mid-deployment?**

A: Update the environment variable, redeploy, and all links immediately point to the new domain. No code changes required.

**Q: How do I test locally with staging docs URL?**

A: Set `NEXT_PUBLIC_DOCS_BASE_URL=https://staging-docs.yourdomain.com` in `.env.local` and run `pnpm build`. All links will use the staging domain.

**Q: Do I need to commit environment variables to version control?**

A: No. Commit `.env.example` (template) only. Each environment has its own `.env` file (local dev, CI, production). `.env.local` is in `.gitignore`.

---

## Author & Review

- **Date:** 2026-01-22
- **Author:** GitHub Copilot (Phase 3 Implementation)
- **Status:** Approved and documented
