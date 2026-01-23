---
title: 'Stage 3.5 — CI Link Validation & Runbooks (Docs)'
description: 'Create publish runbook and troubleshooting guide; document CI link validation, registry checks, and evidence URL verification for Phase 3.'
tags:
  [portfolio, roadmap, planning, phase-3, stage-3.5, docs, operations, runbook]
---

# Stage 3.5: CI Link Validation & Runbooks — Documentation

**Type:** Documentation / Runbook / Troubleshooting  
**Phase:** Phase 3 — Scaling & Governance  
**Stage:** 3.5  
**Linked Issue:** [stage-3-5-app-issue.md](/docs/00-portfolio/roadmap/issues/stage-3-5-app-issue.md)  
**Duration Estimate:** 2–3 hours  
**Assignee:** GitHub Copilot / Engineering Lead  
**Created:** 2026-01-23  
**Status:** Ready to execute

---

## Overview

This stage delivers the operational documentation for publishing projects under the Phase 3 governance model. It produces the end-to-end publish runbook, a troubleshooting guide, and CI linkage notes that explain how registry validation, link format checks, and evidence URL verification run in automation.

**Why this matters:** Consistent runbooks reduce operational risk and accelerate onboarding. Clear troubleshooting steps paired with CI artifacts ensure broken links, invalid slugs, or evidence gaps are resolved quickly.

## Objectives

- Publish a complete project publish runbook with timed phases and validation checkpoints
- Document CI link validation steps (registry, slug regex, evidence URLs, broken docs links)
- Create a troubleshooting guide for common Stage 3.5 failures (slug, dossier links, evidence URLs, registry validation)
- Cross-link runbooks to CI artifacts and companion app issue

---

## Scope

### Files to Create

1. **`docs/50-operations/runbooks/rbk-portfolio-project-publish.md`** — Publish runbook
   - Type: Runbook
   - Purpose: Step-by-step project publish procedure with timing, validation gates, and handoff steps
   - Audience: Operations and engineering during project onboarding

2. **`docs/50-operations/runbooks/troubleshooting-portfolio-publish.md`** — Troubleshooting guide
   - Type: Troubleshooting / Reference
   - Purpose: Quick fixes for invalid slugs, broken dossier/evidence links, registry validation failures, and CI link-check errors
   - Audience: On-call/maintainers responding to CI failures or post-publish issues

### Files to Update

1. **`docs/00-portfolio/roadmap/phase-3-implementation-guide.md`** — Stage 3.5 status
   - Update Stage 3.5 section to reference new runbooks and CI link validation artifacts

2. **`docs/00-portfolio/roadmap/issues/index.md`** (optional) — Add Stage 3.5 entries for navigation

3. **`.github/copilot-instructions.md`** (docs) — Note runbook locations and Stage 3.5 CI expectations if not already present

---

## Content Structure & Design

### Runbook: rbk-portfolio-project-publish.md

**Front Matter:**

```yaml
---
title: 'Runbook: Portfolio Project Publish'
description: 'End-to-end procedure for publishing a project with registry validation, evidence links, and CI link checks.'
sidebar_position: 10
tags: [runbook, operations, publishing, phase-3, registry]
---
```

**Outline:**

1. Purpose & Audience
2. Prerequisites (access, env vars, required scripts)
3. Steps with timing (planning, registry entry, dossier creation, link validation, PR/review, post-publish verification)
4. Validation checklist (registry:validate, links:check, build)
5. Expected outputs (links to CI artifacts, registry file updates)
6. Rollback/abort guidance

### Troubleshooting Guide: troubleshooting-portfolio-publish.md

**Front Matter:**

```yaml
---
title: 'Troubleshooting: Portfolio Publish & Link Validation'
description: 'Common errors and fixes for project publishing, registry validation, and link checks.'
sidebar_position: 11
tags: [troubleshooting, operations, publishing, links, registry, phase-3]
---
```

**Outline:**

1. How to read CI artifacts (link-validation job, Playwright reports)
2. Invalid slug format — cause, fix, validation command
3. Broken dossier/evidence links — cause, fix, validation command
4. Evidence URL verification failures — cause, fix, link formatting examples
5. Registry validation failures — cause, fix, schema references
6. Escalation and contact points

---

## Implementation Tasks

### Phase 1: Draft Runbook (0.75–1 hour)

- [ ] Add runbook file with front matter, purpose, prerequisites, and timed steps from Stage 3.5 outline
- [ ] Include validation checkpoints for `pnpm registry:validate`, `pnpm links:check`, and `pnpm build`
- [ ] Add post-publish verification checklist and rollback steps

### Phase 2: Troubleshooting Guide (0.75–1 hour)

- [ ] Add troubleshooting file with front matter and sections for slug, dossier link, evidence URL, and registry validation issues
- [ ] Map each issue to commands, expected outputs, and links to CI artifacts
- [ ] Provide sample error messages to search in CI logs

### Phase 3: Cross-References & Validation (0.5–1 hour)

- [ ] Update phase-3 guide Stage 3.5 section with links to the runbook and troubleshooting guide
- [ ] (Optional) Update issues index and copilot instructions with Stage 3.5 resources
- [ ] Run `pnpm build` to verify docs and links

---

## Acceptance Criteria

- Runbook and troubleshooting guide exist with completed front matter and clear, actionable steps
- Validation commands (`pnpm registry:validate`, `pnpm links:check`, `pnpm build`) are documented with expected outcomes
- CI artifact locations (from app repo) are referenced for failure analysis
- Phase 3 guide links to new documents; optional index updated if used for navigation
- `pnpm build` passes with no broken links or front-matter errors

---

## Definition of Done

- ✅ Runbook published with timing and validation checkpoints
- ✅ Troubleshooting guide covers slug, evidence links, and registry validation failures with fixes
- ✅ Cross-references added to Phase 3 guide (and index/copilot instructions if applicable)
- ✅ Docs build clean locally
- ✅ Companion app issue (Stage 3.5 app) referenced in PR description
- ✅ PR approved and merged to `main`
