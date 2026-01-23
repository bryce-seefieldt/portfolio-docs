---
title: 'Stage 3.5 — CI Link Validation & Runbooks (App)'
description: 'Add registry validation, link format checks, evidence URL verification, and broken link detection to portfolio-app CI.'
tags: [portfolio, roadmap, planning, phase-3, stage-3.5, app, ci, validation]
---

# Stage 3.5: CI Link Validation & Runbooks — App Implementation

**Type:** Feature / CI Enhancement  
**Phase:** Phase 3 — Scaling & Governance  
**Stage:** 3.5  
**Linked Issue:** [stage-3-5-docs-issue.md](/docs/00-portfolio/roadmap/issues/stage-3-5-docs-issue.md)  
**Duration Estimate:** 2–3 hours  
**Assignee:** GitHub Copilot / Engineering Lead  
**Created:** 2026-01-23  
**Status:** Ready to execute

---

## Overview

This stage hardens the portfolio-app CI pipeline to block merges when registry entries, evidence links, or documentation URLs are malformed. It adds explicit registry validation, link format enforcement, and broken-link detection so the publish runbook has reliable automation to lean on.

**Why this matters:** Publishing new projects must be safe-by-default. CI should fail fast for invalid slugs, missing evidence links, or broken docs URLs, providing actionable logs for the operations runbook and troubleshooting guide.

## Objectives

- Add a dedicated registry validation step in CI (slug rules, required fields, evidence URLs)
- Enforce link format and slug regex in CI (lowercase, hyphenated, no spaces)
- Detect broken evidence links and docs URLs via automated smoke/link checks
- Surface CI artifacts (reports) that the runbook and troubleshooting guide can reference

---

## Scope

### Files to Update

1. **`.github/workflows/ci.yml`** — Add `link-validation` job
   - Run `pnpm install` with cache, then `pnpm registry:validate` and `pnpm links:check`
   - Fail on slug violations, missing evidence URLs, or unreachable docs links
   - Upload Playwright/link-check report on failure for runbook troubleshooting

2. **`package.json`** — Add/align scripts
   - `registry:validate`: schema + evidence URL validation
   - `links:check`: headless smoke/link check (reuse Playwright tests or add lightweight checker)
   - Wire `verify`/CI scripts to call these before build

3. **`README.md`** (optional) — Document new CI gates and scripts
   - Brief usage notes for local validation
   - Point to operations runbook in docs repo

### Files to NOT Touch

- No runtime code changes expected (registry + components are stable from Stages 3.1–3.3)
- No dependency additions unless a lightweight link-checker is required (prefer existing tests)

---

## Implementation Tasks

### Phase 1: Scripts & Local Validation (0.5–1 hour)

- [ ] Confirm or add `registry:validate` script that runs schema/slug/evidence URL checks
- [ ] Add `links:check` script that exercises evidence links (reuse Playwright smoke tests if present)
- [ ] Ensure scripts fail on:
  - Non-matching slug regex `^[a-z0-9]+(?:-[a-z0-9]+)*$`
  - Missing dossier/threat model/ADR/runbook/GitHub evidence URLs where required
  - HTTP 4xx/5xx on docs URLs
- [ ] Run scripts locally and capture expected outputs for CI reference

### Phase 2: CI Wiring (1 hour)

- [ ] Update `.github/workflows/ci.yml` to add `link-validation` job
  - Install deps with cache
  - Run `pnpm registry:validate` and `pnpm links:check`
  - Upload HTML/JSON report artifacts on failure
  - Make `build` depend on `link-validation`
- [ ] Ensure CI matrix covers Node version used in repo and Playwright (if applicable)

### Phase 3: Verification & Handoff (0.5–1 hour)

- [ ] Run full pipeline locally: `pnpm lint`, `pnpm test`, `pnpm registry:validate`, `pnpm links:check`, `pnpm build`
- [ ] Document failure modes and where reports are stored (for use in docs troubleshooting guide)
- [ ] Open PR with CI updates; link companion docs issue

---

## Acceptance Criteria

- CI includes `link-validation` job that runs before build and fails on slug or evidence URL violations
- `registry:validate` and `links:check` scripts exist and fail fast with actionable errors
- Playwright/link-check artifacts uploaded on CI failure and referenced in runbook
- Local commands succeed: `pnpm lint`, `pnpm test`, `pnpm registry:validate`, `pnpm links:check`, `pnpm build`
- Companion docs issue for runbook/troubleshooting is referenced and aligned

---

## Definition of Done

- ✅ CI workflow updated and green on branch
- ✅ Scripts documented (README or inline comments) and runnable locally
- ✅ Broken evidence links or invalid slugs cause CI failure with clear messaging
- ✅ Reports/artifacts available for operations team during incident triage
- ✅ Companion docs issue (Stage 3.5 docs) acknowledged in PR description
- ✅ PR approved and merged to `main`
