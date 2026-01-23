---
title: 'Stage 3.4 — ADRs & Documentation Updates (App)'
description: 'Updates Portfolio App copilot instructions and configuration to reflect Phase 3 Stage 3.4 architectural decisions and patterns.'
tags:
  [
    portfolio,
    roadmap,
    planning,
    phase-3,
    stage-3.4,
    app,
    documentation,
    adr,
  ]
---

# Stage 3.4: ADRs & Documentation Updates — App Implementation

**Type:** Documentation / Configuration Update  
**Phase:** Phase 3 — Scaling & Governance  
**Stage:** 3.4  
**Linked Issue:** [stage-3-4-docs-issue.md](/docs/00-portfolio/roadmap/issues/stage-3-4-docs-issue.md)  
**Duration Estimate:** 1–2 hours  
**Assignee:** GitHub Copilot / Engineering Lead  
**Created:** 2026-01-22  
**Status:** Ready to execute

---

## Overview

This stage updates the Portfolio App repository configuration and copilot instructions to reflect Phase 3 architectural decisions (data-driven registry, evidence linking strategy) documented in companion ADRs created in the docs repository (Stage 3.4 docs issue).

The app implementation is minimal for this stage because most Phase 3 decisions are architectural/documentation concerns. This issue covers copilot instruction updates and any minor config changes needed to support reviewers understanding the registry and evidence patterns.

**Why this matters:** Clear, up-to-date copilot instructions ensure future contributors maintain the data-driven registry discipline and evidence-first linking patterns established in Phase 3.

## Objectives

- Update `.github/copilot-instructions.md` with Phase 3 patterns and ADR references
- Document registry schema patterns and validation expectations
- Provide clear guidance on evidence link construction using `docsUrl()` and related helpers
- Link to companion ADRs (0011, 0012) in both repos for architectural context

---

## Scope

### Files to Update

1. **`.github/copilot-instructions.md`** — Refresh copilot guidance
   - Add "Phase 3 Implementation Patterns" section
   - Document registry YAML structure and slug rules
   - Explain evidence link construction helpers and env-first URL building
   - Link to ADR-0011 (registry decision) and ADR-0012 (cross-repo linking)
   - Update section: "Architecture Overview" with Phase 3 context
   - Add new section: "Registry Patterns & Evidence Linking" with examples

2. **`README.md`** (optional) — If Phase 3 milestone requires highlight
   - Add reference to Stage 3.4 documentation
   - Link to registry schema guide and testing reference
   - Update "What This App Does" if necessary to reflect data-driven architecture

### Files to NOT Update

- No code changes needed (Phase 3 code is complete from Stages 3.1–3.3)
- No new dependencies
- No package.json or vitest/playwright config changes
- No CI workflow changes (already updated in Stage 3.3)

---

## Implementation Tasks

### Phase 1: Copilot Instructions Update (1–1.5 hours)

#### Tasks

- [x] **Review ADRs from docs stage (3.4-docs)**
  - Details: Wait for companion docs issue PRs to merge; review ADR-0011 and ADR-0012
  - Files: Reference [portfolio-docs/docs/10-architecture/adr/adr-0011-data-driven-project-registry.md](https://github.com/bryce-seefieldt/portfolio-docs/blob/main/docs/10-architecture/adr/adr-0011-data-driven-project-registry.md)

- [x] **Add "Phase 3 Implementation Patterns" section to copilot instructions**
  - Location: `.github/copilot-instructions.md` after "Architecture Overview" section
  - Content:
    - Brief intro to Phase 3 data-driven registry
    - Link to ADR-0011 and ADR-0012 in portfolio-docs
    - Reference to Stage 3.1–3.3 implementations
  - Example structure:

    ```markdown
    ## Phase 3: Data-Driven Registry & Evidence Linking

    **Overview:** Stage 3.1 introduced a YAML-backed project registry (see `src/data/projects.yml`) validated by Zod in `src/lib/registry.ts`. Stage 3.2 added reusable components (`EvidenceBlock`, `VerificationBadge`, `BadgeGroup`) for evidence display. Stage 3.3 added comprehensive unit and E2E tests. This pattern enables adding projects at scale without code changes.

    **Decision references:**
    - ADR-0011: [Data-Driven Registry Decision](https://bns-portfolio-docs.vercel.app/docs/architecture/adr/adr-0011-data-driven-project-registry)
    - ADR-0012: [Cross-Repo Documentation Linking](https://bns-portfolio-docs.vercel.app/docs/architecture/adr/adr-0012-cross-repo-documentation-linking)
    ```

- [x] **Document registry YAML patterns**
  - Location: New subsection "Registry Patterns & Project Structure"
  - Content:
    - YAML schema overview
    - Slug format and uniqueness rules
    - Evidence link structure (dossier, threat model, ADRs, runbooks, GitHub)
    - Example valid project entry
    - Common mistakes and how to avoid them

- [x] **Document evidence link construction**
  - Location: New subsection "Evidence Link Construction"
  - Content:
    - Explanation of `docsUrl()`, `githubUrl()`, `docsGithubUrl()` helpers
    - Environment variable contract (NEXT_PUBLIC_DOCS_BASE_URL, NEXT_PUBLIC_GITHUB_URL, etc.)
    - When to use relative vs. absolute URLs
    - Examples:
      - ✅ `docsUrl("portfolio/roadmap")` → resolves to `https://bns-portfolio-docs.vercel.app/docs/portfolio/roadmap`
      - ✅ `githubUrl("portfolio-app")` → resolves to `https://github.com/bryce-seefieldt/portfolio-app/portfolio-app` (if env set)
      - ✅ `docsGithubUrl("blob/main/src/lib/registry.ts")` → resolves to docs repo blob URL

- [x] **Add registry validation reference**
  - Location: Under "Registry Patterns & Project Structure"
  - Content:
    - Reference `src/lib/__tests__/registry.test.ts` for validation rules
    - Link to testing guide in portfolio-docs: `/docs/reference/testing-guide`
    - Note about build-time validation: "Registry is validated at build time via `pnpm build`"

#### Success Criteria for Phase 1

- [x] Copilot instructions updated with Phase 3 context
- [x] All sections include working links to portfolio-docs ADRs
- [x] Examples are copy/paste safe and accurate
- [x] Registry schema patterns clearly documented
- [x] Evidence link construction helpers explained with examples

---

### Phase 2: README Update & Validation (0.5 hours)

#### Tasks

- [x] **Add Phase 3 reference to README (optional)**
  - Content: Add bullet under "What This App Does" or "Architecture" section
  - Example: `- Data-driven project registry (YAML + TypeScript validation); see [Registry Guide](https://bns-portfolio-docs.vercel.app/docs/reference/registry-schema-guide)`

- [x] **Build and verify no broken links**
  - Command: `pnpm build` (local)
  - Expected: Next.js build succeeds; no TypeScript errors
  - Linting: `pnpm lint` (should pass; no new issues)

- [x] **Verify file consistency**
  - Check: All helper functions referenced in copilot instructions actually exist in `src/lib/config.ts`
  - Check: All test patterns reference actual test files in `src/lib/__tests__/`
  - Check: All links to portfolio-docs follow canonical URL patterns

#### Success Criteria for Phase 2

- [x] README updated with Phase 3 reference (if applicable)
- [x] `pnpm lint` and `pnpm typecheck` pass
- [x] Links to portfolio-docs follow correct format
- [x] No broken references to internal files

---

## Acceptance Criteria

This stage is complete when:

- [x] `.github/copilot-instructions.md` includes Phase 3 section with ADR links
- [x] Registry patterns documented with examples
- [x] Evidence link construction helpers explained with examples
- [x] All internal code references are accurate
- [x] All links to portfolio-docs ADRs are valid
- [x] README updated (if applicable)
- [x] `pnpm lint`, `pnpm typecheck`, `pnpm build` all pass locally
- [x] PR approved by engineering lead
- [x] Companion docs issue (Stage 3.4 docs) is merged before merging this app issue

---

## Cross-Repository Dependencies

This stage depends on:

- **portfolio-docs Stage 3.4 issue completion:** ADR-0011 and ADR-0012 must be published in docs before this app issue can add accurate links
- **Companion issue:** [stage-3-4-docs-issue.md](/docs/00-portfolio/roadmap/issues/stage-3-4-docs-issue.md)

**Merge order:** Docs PRs must merge to `main` first; then app issue can reference published URLs and create its PR.

---

## Definition of Done

This stage is complete and ready to merge when:

- ✅ **Content Complete:** Copilot instructions updated with Phase 3 patterns and no TODOs
- ✅ **Accurate:** All helper function references match actual code in `src/lib/config.ts`
- ✅ **Well-Structured:** New sections follow copilot instructions style and format
- ✅ **Links Working:** All internal file references and portfolio-docs links are valid
- ✅ **No Secrets:** No tokens, keys, or sensitive data added
- ✅ **Builds Clean:** `pnpm lint`, `pnpm typecheck`, `pnpm build` all pass
- ✅ **Companion Merged:** Docs issue (Stage 3.4 docs) is merged to main
- ✅ **PR Approved:** Reviewed and approved by engineering lead
- ✅ **Merged to main:** PR closed with "Closes #X" keyword

---

## Notes & References

- This is a lightweight documentation-only stage for the app repo; most Phase 3 work is in the docs repo
- Timing: This app issue can be created now but should await docs issue completion before implementation to ensure ADR links are valid
- Review order: Docs PRs should merge first; then app issue references published ADR URLs

---

## Related Issues & Links

- **Companion docs issue:** [Stage 3.4: ADRs & Documentation — Documentation](/docs/00-portfolio/roadmap/issues/stage-3-4-docs-issue.md)
- **Parent phase:** [Phase 3 Implementation Guide](/docs/00-portfolio/roadmap/phase-3-implementation-guide.md)
- **Related ADRs (being created in docs issue):**
  - ADR-0011: Data-Driven Project Registry
  - ADR-0012: Cross-Repo Documentation Linking
