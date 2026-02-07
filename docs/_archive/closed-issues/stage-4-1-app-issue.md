---
title: 'Stage 4.1 — Multi-Environment Deployment Strategy (App)'
description: 'Implement explicit preview/staging/production environment separation with immutable builds, environment-specific configuration via env vars, and deployment promotion workflows.'
tags:
  [
    portfolio,
    roadmap,
    planning,
    phase-4,
    stage-4-1,
    app,
    devops,
    deployment,
    environments,
  ]
---

> **Archive notice:** Archived 2026-02-06. This issue is retained for historical traceability only.
> See release note: /docs/00-portfolio/release-notes/20260206-portfolio-roadmap-issues-archived.md

# Stage 4.1: Multi-Environment Deployment Strategy — App Implementation

**Type:** Feature / Infrastructure  
**Phase:** Phase 4 — Enterprise-Grade Platform Maturity  
**Stage:** 4.1  
**Linked Issue:** [stage-4-1-docs-issue.md](stage-4-1-docs-issue.md)  
**Duration Estimate:** 2–3 hours  
**Assignee:** [Your name or team]

---

## Overview

Establish explicit environment separation (preview/staging/production) with immutable builds and environment-aware configuration. This foundational stage enables confident multi-tier deployments, eliminates "works locally but fails in production" surprises, and creates a promotion pipeline for code validation before reaching production users.

**Impact:** All subsequent Phase 4 stages depend on this multi-environment foundation to deploy and validate independently across tiers.

## Objectives

- Implement environment detection helpers in `src/lib/config.ts` to eliminate hardcoded environment-specific logic
- Configure `.env.example` and Vercel environment variables for preview/staging/production tiers
- Ensure build artifacts are immutable (same build deployed across all environments)
- Create GitHub Actions workflows for manual promotion to staging and production
- Establish promotion checklist and documented flow

---

## Scope

### Files to Create

1. **`src/lib/environment.ts`** — Centralized environment configuration and helpers
   - Re-exports from config.ts or aggregates environment detection
   - Provides strongly-typed environment helpers
   - No hardcoded values; all from env vars

### Files to Update

1. **`.env.example`** — Environment variable template for all tiers
   - Add all `NEXT_PUBLIC_*` variables with descriptions
   - Add private variables (if any)
   - Document which vars are required vs. optional
   - Note which vars differ per environment

2. **`src/lib/config.ts`** — Enhanced environment configuration (existing file, 318 lines)
   - Add `ENVIRONMENT` constant from `process.env.VERCEL_ENV`
   - Add helper functions: `isProduction()`, `isStaging()`, `isPreview()`, `isDevelopment()`
   - Document environment-aware URL construction
   - Ensure no hardcoded URLs or secrets

3. **`vercel.json`** — Vercel project configuration (create or update)
   - Define environment-specific build settings
   - Configure environment variables per deployment (if needed for edge functions, redirects)
   - Document preview/staging/production overrides

4. **`package.json`** — Update scripts and dependencies (if applicable)
   - Add env validation script: `env:validate`
   - Ensure TypeScript includes environment validation

5. **`.github/workflows/ci.yml`** — Existing CI workflow enhancement
   - Add environment variable validation step (after checkout)
   - Ensure `.env.example` is properly formatted
   - Verify no secrets are committed

6. **`next.config.ts`** — Configuration enhancement (if needed)
   - No changes required; confirm no hardcoded env-specific logic

### Dependencies to Add

- None; use existing Next.js environment variable support

### Dependencies to Remove

- None

---

## Design & Architecture

### Environment Model

```
┌─────────────────────────────────────────────────────────────┐
│ Git Push to PR                                              │
│ ↓                                                           │
│ Vercel Preview (Auto)                                      │
│ • VERCEL_ENV = preview                                     │
│ • CI gates must pass                                       │
│                                                             │
│ ↓ (Manual: Merge PR)                                       │
│                                                             │
│ Git Merge to main                                          │
│ ↓                                                           │
│ Staging (Manual promotion)                                 │
│ • VERCEL_ENV = staging                                     │
│ • Same build artifact as main                             │
│ • Smoke tests validate                                     │
│                                                             │
│ ↓ (Manual: Promote if ready)                              │
│                                                             │
│ Production (Manual promotion)                              │
│ • VERCEL_ENV = production                                  │
│ • Health checks post-deploy                               │
│ • Same build artifact, no rebuild                         │
└─────────────────────────────────────────────────────────────┘
```

### Environment Variable Architecture

**Client-side (visible to browser):**

- `NEXT_PUBLIC_SITE_URL` — Base URL for current environment
- `NEXT_PUBLIC_DOCS_BASE_URL` — URL to documentation site
- `NEXT_PUBLIC_GITHUB_URL` — GitHub repo base URL
- `NEXT_PUBLIC_DOCS_GITHUB_URL` — Docs repo base URL

**Server-side (Node.js only, not exposed to client):**

- `VERCEL_ENV` — Automatically set by Vercel; values: `preview`, `staging`, `production`, or unset (local)
- `VERCEL_GIT_COMMIT_SHA` — Commit SHA for immutable tagging

**Key Principle:** Build time uses same config across all environments. Runtime env vars are applied at deployment time, not build time.

### Immutability Pattern

1. **On commit to main:**
   - `pnpm build` runs (output is artifact)
   - Vercel builds once, caches artifact

2. **On promotion to staging:**
   - Same artifact deployed (no rebuild)
   - Environment variables applied at runtime
   - Example: `NEXT_PUBLIC_SITE_URL=https://staging.portfolio.example.com`

3. **On promotion to production:**
   - Same artifact deployed (no rebuild)
   - New environment variables applied at runtime
   - Example: `NEXT_PUBLIC_SITE_URL=https://portfolio.example.com`

**Benefit:** Eliminates "works in staging but fails in production" surprises caused by build-time differences.

### Key Design Decisions

1. **Decision: Manual promotion workflows instead of auto-promotion**
   - Rationale: Gives team explicit control; forces review/approval gate
   - Alternative: Auto-promote on main → staging → production (too risky for demos)
   - Why chosen: Balances safety with speed; easy to upgrade to auto later

2. **Decision: GitHub Actions for promotion instead of Vercel UI only**
   - Rationale: Auditable, version-controlled, reproducible
   - Alternative: Manual Vercel UI clicks (not auditable, error-prone)
   - Why chosen: Enables automation and dry-runs; team can reference workflow in docs

3. **Decision: Environment variables at runtime, not build time**
   - Rationale: Ensures identical builds across environments
   - Alternative: Rebuild for each environment (slower, less reliable)
   - Why chosen: Production-grade pattern; matches 12-factor app principles

---

## Implementation Tasks

### Phase 1: Environment Configuration Setup (1 hour)

#### Tasks

- [ ] **Update `.env.example` with all environment variables**
  - Details: Document all `NEXT_PUBLIC_*` and private vars used in the app
  - Include: `SITE_URL`, `DOCS_BASE_URL`, `GITHUB_URL`, `DOCS_GITHUB_URL` (at minimum)
  - Add descriptions for each variable
  - Note which are required vs. optional
  - Add environment-specific examples (e.g., # For production: `https://portfolio.example.com`)
  - Files: `.env.example`

- [ ] **Enhance `src/lib/config.ts` with environment detection helpers**
  - Details: Add constants and functions that don't exist yet
  - Add `ENVIRONMENT` constant: `process.env.VERCEL_ENV || 'development'`
  - Add functions: `isProduction()`, `isStaging()`, `isPreview()`, `isDevelopment()`
  - Export environment-aware URL helpers (already exists for SITE_URL, verify others)
  - Add TypeScript types for environment values
  - Files: `src/lib/config.ts`

- [ ] **Create or update `vercel.json` for environment configuration**
  - Details: Set up Vercel-specific settings for staging/production
  - If file doesn't exist, create with standard Next.js config
  - Optionally add `env` section if environment-specific redirects/rewrites needed
  - Document structure for team reference
  - Files: `vercel.json`

#### Success Criteria for Phase 1

- [ ] `.env.example` is complete with all vars and descriptions
- [ ] `src/lib/config.ts` has helper functions: `isProduction()`, `isStaging()`, `isPreview()`, `isDevelopment()`
- [ ] `vercel.json` exists and is valid JSON
- [ ] Local development works: `pnpm dev` runs with default values
- [ ] No TypeScript errors: `pnpm typecheck`
- [ ] No hardcoded URLs or environment-specific logic remaining in code

---

### Phase 2: CI Integration & Environment Validation (0.5–1 hour)

#### Tasks

- [ ] **Update `.github/workflows/ci.yml` to validate environment variables**
  - Details: Add step to validate `.env.example` syntax and completeness
  - Add step: Check `.env.example` is valid shell format
  - Add step: Verify no secrets are accidentally committed
  - Failure: CI should warn if env vars are missing or malformed
  - Files: `.github/workflows/ci.yml`

- [ ] **Create `src/lib/environment.ts` if additional abstraction needed**
  - Details: Optional file to centralize environment logic
  - Can re-export from config.ts or add env-specific helpers
  - Keep minimal; config.ts already handles most of it
  - Files: `src/lib/environment.ts` (optional)

#### Success Criteria for Phase 2

- [ ] Both promotion workflows exist and are syntactically valid
- [ ] Workflows can be manually triggered from GitHub Actions UI
- [ ] CI workflow validates env variables on each push
- [ ] No hardcoded Vercel project IDs or secrets in workflows
- [ ] Workflows reference official Vercel actions or documented APIs

---

### Phase 3: Verification & Documentation (0.5–1 hour)

#### Tasks

- [ ] **Test environment configuration locally**
  - Details: Verify local dev and build work with env vars
  - Steps:
    1. Run `pnpm dev` — should start with defaults
    2. Create `.env.local` with custom values
    3. Run `pnpm dev` again — should use custom values
    4. Run `pnpm build` — should succeed with defaults
    5. Verify `NEXT_PUBLIC_*` vars are injected into build
  - Files: None (manual testing)

- [ ] **Verify no hardcoded environment logic in codebase**
  - Details: Grep for environment-specific strings to ensure all use config.ts
  - Search for:
    - Hardcoded URLs (production, staging domain names)
    - `process.env` access outside of config.ts
    - `process.NODE_ENV` (should use ENVIRONMENT helper instead)
  - Fix any violations by moving to config.ts
  - Files: All source files under `src/`

- [ ] **Create promotion checklist documentation**
  - Details: Document manual steps for promoting to staging/production
  - Include: How to trigger workflow, what to monitor, rollback procedure
  - Link this to docs issue (ADR-0013 and runbook)
  - Files: Comments in workflows; referenced by runbook

#### Success Criteria for Phase 3

- [ ] Local dev works with defaults and custom env vars
- [ ] Production build includes environment variables correctly
- [ ] No hardcoded environment logic in source code
- [ ] Promotion workflows are documented for team

---

## Testing Strategy

### Unit Tests

- [ ] **Test `config.ts` environment helpers**
  - Location: `src/__tests__/config.test.ts`
  - Test cases:
    - `isProduction()` returns true when VERCEL_ENV=production
    - `isStaging()` returns true when VERCEL_ENV=staging
    - `isPreview()` returns true when VERCEL_ENV=preview
    - `isDevelopment()` returns true when VERCEL_ENV not set
    - Helper functions return correct values for all combinations
  - Coverage: 100% of environment detection logic

### Integration Tests

- [ ] **Test environment variables are applied correctly**
  - Location: `e2e/environment.spec.ts`
  - Test: Verify `/api/health` returns correct environment in response
  - Test: Verify page metadata includes correct `SITE_URL`
  - Verify on preview, staging, production (3 test runs with different env vars)

### Manual Testing

- [ ] **Verify staging deployment manually**
  - Steps:
    1. Merge changes to `staging` branch
    2. Monitor Vercel deployment dashboard for automatic deployment
    3. Once deployed, curl health endpoint and verify environment is "staging"
    4. Merge staging to main for production deployment

### Test Commands

```bash
# Unit tests for config
pnpm test -- config.test.ts

# Type checking
pnpm typecheck

# Linting (verify no hardcoded env logic)
pnpm lint

# Local dev verification
pnpm dev

# Build verification
pnpm build

# Full verification suite
pnpm verify
```

---

## Validation Rules & Constraints

1. **No hardcoded environment-specific logic in source code**
   - Format: All environment detection must use helpers from `src/lib/config.ts`
   - Example valid: `if (isProduction()) { /* ... */ }`
   - Example invalid: `if (process.env.NODE_ENV === 'production') { /* ... */ }`
   - Error handling: ESLint rule or manual review to enforce

2. **All URLs must use env vars from config.ts**
   - Format: `const url = \${SITE_URL}/path\`;`
   - Example valid: `${SITE_URL}/contact`
   - Example invalid: `https://portfolio.example.com/contact`
   - Error handling: Grep check in CI; manual review

3. **`NEXT_PUBLIC_*` variables must never contain secrets**
   - Format: Only public data in NEXT*PUBLIC*\* vars (URLs, API base paths, keys)
   - Example valid: `NEXT_PUBLIC_SITE_URL=https://portfolio.example.com`
   - Example invalid: `NEXT_PUBLIC_API_KEY=sk-xxxxx`
   - Error handling: Secret scanning in CI (if available)

4. **Build artifacts must be identical across environments**
   - Format: Same SHA in build output for preview, staging, production
   - Verification: `pnpm build` twice with same env vars → same output
   - Error handling: Build manifest comparison in deployment workflow

---

## Acceptance Criteria

This stage is complete when:

- [ ] `.env.example` documents all environment variables
- [ ] `src/lib/config.ts` has environment helpers (`isProduction()`, `isStaging()`, etc.)
- [ ] `vercel.json` is configured for staging/production overrides (if needed)
- [ ] `.github/workflows/ci.yml` validates environment variables
- [ ] Local dev works with default values: `pnpm dev`
- [ ] Local dev works with custom env vars: `.env.local` respected
- [ ] No hardcoded URLs or environment logic in source code
- [ ] Build succeeds locally: `pnpm build`
- [ ] `pnpm typecheck` passes with no errors
- [ ] `pnpm lint` passes with no warnings
- [ ] `pnpm verify` passes (all checks)
- [ ] Unit tests for config helpers pass
- [ ] E2E test verifies environment variables are applied correctly
- [ ] Promotion workflows can be manually triggered from GitHub UI
- [ ] PR created with title: `feat(devops): Stage 4.1 - Multi-environment deployment strategy`
- [ ] PR reviewed and approved
- [ ] PR merged to `main`

---

## Code Quality Standards

All code must meet:

- **TypeScript:** Strict mode enabled; no `any` types unless documented
- **Linting:** ESLint with Next.js preset; no environment-specific hardcoding
- **Formatting:** Prettier; consistent with existing codebase
- **Documentation:** JSDoc comments for new functions; README updated if needed
- **Testing:** Unit tests for helpers; E2E tests for integration
- **Security:** No secrets in source code; all config via env vars
- **Performance:** No additional runtime overhead from environment detection

---

## Deployment & CI/CD

### CI Pipeline Integration

- [ ] Existing CI tests all pass
- [ ] New environment validation step added to CI
- [ ] No new dependencies or build steps required
- [ ] Build time unchanged (no additional overhead)

### Environment Variables / Configuration

**Local Development (.env.local):**

```env
# Optional; defaults work without these
NEXT_PUBLIC_SITE_URL=http://localhost:3000
NEXT_PUBLIC_DOCS_BASE_URL=http://localhost:3001/docs
NEXT_PUBLIC_GITHUB_URL=https://github.com/your-user/portfolio-app
NEXT_PUBLIC_DOCS_GITHUB_URL=https://github.com/your-user/portfolio-docs
```

**Preview (Vercel Auto-Set):**

```env
# Auto-set by Vercel for PR deployments
VERCEL_ENV=preview
VERCEL_GIT_COMMIT_SHA=[commit SHA]
NEXT_PUBLIC_SITE_URL=https://portfolio-app-[pr-number].vercel.app
```

**Staging (Manual):**

```env
# Set in Vercel Project Settings > Staging environment
VERCEL_ENV=staging
NEXT_PUBLIC_SITE_URL=https://staging.portfolio.example.com
NEXT_PUBLIC_DOCS_BASE_URL=https://staging-docs.portfolio.example.com/docs
```

**Production (Manual):**

```env
# Set in Vercel Project Settings > Production environment
VERCEL_ENV=production
NEXT_PUBLIC_SITE_URL=https://portfolio.example.com
NEXT_PUBLIC_DOCS_BASE_URL=https://docs.portfolio.example.com/docs
```

Documentation: See `.env.example` for complete reference.

### Rollback Plan

- **Quick Rollback:** Revert to previous commit: `git revert [commit-sha]`
- **Workflow Rollback:** Re-run previous promotion workflow with older ref
- **Config Rollback:** Restore previous env vars in Vercel Project Settings
- **Zero-Downtime:** Staging can be rolled back without affecting production

---

## Dependencies & Blocking

### Depends On

- [ ] Phase 3 complete and merged to `main`
- [ ] Vercel project configured with preview/staging/production deployments

### Blocks

- [ ] Stage 4.2: Performance Optimization (can proceed in parallel after 4.1 env setup)
- [ ] Stage 4.3: Observability (depends on multi-env for health checks across tiers)
- [ ] Stage 4.4: Security (can proceed in parallel)
- [ ] Stage 4.5: UX & Content (can proceed in parallel)

### Related Work

- Related documentation issue: [stage-4-1-docs-issue.md](stage-4-1-docs-issue.md)
- Related ADR: ADR-0013 Multi-Environment Deployment Strategy (created in docs issue)
- Related runbook: Environment Promotion & Rollback (created in docs issue)

---

## Effort Breakdown

| Phase | Task                                 | Hours  | Notes                             |
| ----- | ------------------------------------ | ------ | --------------------------------- |
| 1     | Update `.env.example`                | 0.25h  | Document all vars                 |
| 1     | Enhance `src/lib/config.ts`          | 0.5h   | Add helpers                       |
| 1     | Create/update `vercel.json`          | 0.25h  | Vercel config                     |
| 2     | Create promotion workflows           | 0.75h  | 2 workflows + CI integration      |
| 2     | Test workflows and CI integration    | 0.5h   | Verify GitHub Actions             |
| 3     | Verify local and production behavior | 0.5h   | Manual testing                    |
| 3     | Document promotion checklist         | 0.25h  | Inline comments and workflow      |
| —     | **Total**                            | **3h** | **Includes buffer for debugging** |

---

## Success Verification Checklist

Before marking this stage complete:

- [ ] All Phase 1 tasks complete
- [ ] All Phase 2 tasks complete
- [ ] All Phase 3 tasks complete
- [ ] All acceptance criteria met
- [ ] All tests passing: `pnpm test`
- [ ] All quality gates pass: `pnpm verify`
- [ ] Code review approved
- [ ] PR merged to `main`
- [ ] Promotion workflows can be manually triggered and succeed

---

## Notes & Assumptions

- **Node.js 20+** assumed available; verify with `node --version`
- **pnpm 10** assumed; setup with `corepack enable`
- **Vercel project access** assumed for environment configuration
- **GitHub Actions** assumed available (already in place from Phase 1)
- **Existing CI/CD pipeline** assumed working (Phase 1+ infrastructure)
- **No external APM or monitoring** assumed for this stage (added in Stage 4.3)

---

## Related Issues

- **Parent:** Phase 4 Implementation Guide
- **Sibling (Docs):** [stage-4-1-docs-issue.md](stage-4-1-docs-issue.md)
- **Blocks:** Stages 4.2–4.5 (can proceed in parallel after 4.1 setup)
- **Related:** Phase 3 completion

---

## Review Checklist (for Reviewer)

- [ ] Implementation achieves stated objectives
- [ ] No hardcoded environment-specific logic in code
- [ ] Environment variables are properly documented
- [ ] Workflows are syntactically valid and executable
- [ ] Build artifacts are identical across environments (spot-check)
- [ ] Tests verify environment behavior
- [ ] No secrets or sensitive data exposed
- [ ] Documentation references are correct
- [ ] Changes follow code style and conventions

---

## Completion Verification

**Date Completed:** [YYYY-MM-DD]  
**Completed By:** [Name/GitHub handle]

- [ ] All phases complete
- [ ] All acceptance criteria met
- [ ] All tests passing: `pnpm test`
- [ ] All quality gates pass: `pnpm verify`
- [ ] Code reviewed and approved
- [ ] PR merged to `main`
- [ ] Promotion workflows tested manually

---

**Milestone:** Phase 4 — Enterprise-Grade Platform Maturity  
**Labels:** `enhancement`, `phase-4`, `stage-4-1`, `devops`, `implementation`, `infra`  
**Priority:** High
