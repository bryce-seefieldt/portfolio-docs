---
title: 'Stage 3.2 — EvidenceBlock Components & Badges (Docs)'
description: 'Updates the Portfolio App dossier and architecture docs to explain the EvidenceBlock, VerificationBadge, and BadgeGroup components and ensure evidence consistency.'
tags: [portfolio, roadmap, planning, phase-3, stage-3.2, docs, documentation]
---

# Stage 3.2: EvidenceBlock Components & Badges — Documentation

**Type:** Documentation / Reference  
**Phase:** Phase 3 — Scaling & Governance  
**Stage:** 3.2  
**Linked Issue:** [stage-3-2-app-issue.md](/docs/00-portfolio/roadmap/issues/stage-3-2-app-issue.md)  
**Duration Estimate:** 2–3 hours  
**Assignee:** GitHub Copilot / Engineering Lead  
**Created:** 2026-01-21  
**Status:** ✅ COMPLETE (2026-01-22)

---

## Overview

This stage complements the app implementation ([stage-3-2-app-issue.md](/docs/00-portfolio/roadmap/issues/stage-3-2-app-issue.md)) by updating portfolio-docs with architecture explanations, ensuring evidence consistency, and documenting the component-driven evidence visualization approach.

While the app work creates three reusable React components (`EvidenceBlock`, `VerificationBadge`, `BadgeGroup`), this docs work ensures reviewers understand:

- **Why** components were introduced (evidence visibility as first-class concern)
- **How** components work (architecture, design decisions)
- **What** evidence is expected (updated dossiers)
- **Where** to look for component specs (copilot-instructions already updated)

**Why this matters:** Evidence documentation must stay in sync with code. Clear dossier updates and architectural explanations build reviewer confidence that the component layer is intentional and production-grade.

## Objectives

- Update Portfolio App dossier with Stage 3.2 component architecture section
- Ensure evidence artifact paths in dossier match registry (`src/data/projects.yml`)
- Document component design decisions and reusability patterns
- Verify ADRs and threat models remain aligned with new layer
- Maintain consistency between app code and evidence documentation
- Support future dossier readers in understanding component-driven evidence

---

## Scope

### Files to Create

None (all updates are to existing dossier structure)

### Files to Update

1. **`docs/60-projects/portfolio-app/01-overview.md`** — Overview page
   - Add brief mention of Stage 3.2 component introduction
   - Sentence-level context: "Stage 3.2 introduces a component library for standardized evidence linking"

2. **`docs/60-projects/portfolio-app/02-architecture.md`** — Architecture deep-dive
   - Create new subsection: "Evidence Visualization Layer (Stage 3.2)"
   - Document the three components: `EvidenceBlock`, `VerificationBadge`, `BadgeGroup`
   - Explain responsive design, dark mode support, styling approach
   - Link to copilot-instructions section with full component specs

3. **`docs/60-projects/portfolio-app/03-deployment.md`** (verify — no changes needed)
   - Ensure deployment steps remain unchanged (no new services or infrastructure)

4. **`docs/60-projects/portfolio-app/04-security.md`** (verify — no changes needed)
   - Review for any security implications of component layer
   - Expect: no new attack surface (components are presentational only)

5. **`docs/60-projects/portfolio-app/05-testing.md`** (verify and update if needed)
   - If E2E tests are mentioned, add brief note about component rendering tests
   - Expected tests: Playwright verifies project pages load with components

6. **`docs/10-architecture/adr/` (reference, no new ADRs for this stage)**
   - Existing ADR-0010 (Gold Standard Exemplar) remains primary reference
   - Note in dossier: "Components support gold-standard evidence visibility"

### Files to NOT Update

- Release notes: handled in post-implementation phase (separate task)
- Runbooks: no operational changes (no deploy/rollback implications)
- Threat model: no trust boundary changes (components are presentational only)

---

## Content Structure & Design

### Document Type & Template

**Type:** Dossier updates (not ADR, not threat model, not runbook)

**Audience:** Engineering leads, architects, code reviewers — people evaluating portfolio credibility

**Front Matter (existing dossier):**
Already present in each dossier page (title, description, sidebar_position, tags)

### Content Outline

#### 1. Update to `01-overview.md`

**Current State:** Overview page describes portfolio-app purpose and stack

**Addition:**
Add paragraph in the "Key Features" or "Architecture Highlights" section:

```markdown
#### Evidence-First Component Library (Stage 3.2)

The Portfolio App introduces a reusable component library for standardized evidence linking:

- **EvidenceBlock.tsx** renders project evidence artifacts (dossiers, threat models, ADRs, runbooks) in a responsive grid, enabling reviewers to verify completeness at a glance.
- **VerificationBadge.tsx** displays status indicators (docs-available, threat-model-complete, gold-standard-status, adr-complete) to signal evidence quality.
- **BadgeGroup.tsx** conditionally aggregates multiple evidence badges for quick scanning.

Together, these components embed evidence verification into the user experience, making "show your work" a visual, interactive expectation rather than a hidden link hunt.

See [Architecture — Evidence Visualization Layer](/docs/60-projects/portfolio-app/02-architecture.md#evidence-visualization-layer-stage-32) for full details.
```

#### 2. Comprehensive Update to `02-architecture.md`

**Current State:** Architecture page explains registry, config, routes, etc.

**Addition:** Create new subsection after registry section:

```markdown
### Evidence Visualization Layer (Stage 3.2)

#### Overview

After Stage 3.1 established a data-driven registry, Stage 3.2 makes evidence visualization a first-class architectural concern through three reusable React components. Rather than relegating evidence links to project footers or separate pages, components embed evidence discovery into the main project detail experience.

#### Component Architecture

**Three-Tier Component System:**
```

EvidenceBlock (render evidence grid)
↑
BadgeGroup (conditional badge aggregation)
↑
VerificationBadge (single badge + icon)
↑
Registry Data (Project.evidence)

````

**EvidenceBlock Component**

- **Purpose:** Comprehensive evidence reference
- **Renders:** Grid of evidence artifact links (dossier, threat model, ADRs, runbooks, GitHub repository)
- **Responsive:** 1 column (mobile) → 2 columns (tablet) → 3 columns (desktop)
- **Data Source:** `project.evidence` from YAML registry; URLs built using `docsUrl()` and `githubUrl()` helpers
- **Styling:** Tailwind CSS with `dark:` mode support, hover effects, rounded corners
- **Integration:** Placed after "What This Project Proves" section on `/projects/[slug]`
- **Use Case:** Reviewers need a single, trusted source to verify all evidence artifacts are present and linked

**VerificationBadge Component**

- **Purpose:** Quick status indicator
- **Badge Types:**
  - `gold-standard` → amber (indicates full Phase 2 completion with operational readiness)
  - `docs-available` → blue (dossier exists at docs URL)
  - `threat-model` → violet (threat model documented)
  - `adr-complete` → indigo (ADR index with decision records)
- **Data Source:** `project.isGoldStandard`, `project.evidence` presence flags
- **Styling:** Inline badges with icons, text labels, hover shadows
- **Integration:** Rendered by BadgeGroup in project header
- **Use Case:** Scanning multiple projects to identify which have complete evidence trails

**BadgeGroup Component**

- **Purpose:** Aggregate status visualization
- **Logic:** Analyzes project evidence; conditionally renders appropriate badges
- **Example Output (portfolio-app):**
  - Renders: `[Gold Standard]` `[Docs Available]` `[Threat Model]` `[ADR Complete]`
- **Data Source:** `project` object from registry
- **Styling:** Flex layout with responsive wrapping, gap spacing
- **Integration:** Placed in project header, after title
- **Use Case:** One-glance assessment of project documentation maturity

#### Design Decisions

1. **Why separate components instead of one monolithic "Evidence" component?**
   - **Reusability:** Each component solves a distinct UX problem; can be used independently
   - **Composition:** Future index pages might use `BadgeGroup` without `EvidenceBlock`
   - **Testability:** Smaller components easier to test in isolation
   - **Maintainability:** Changes to one concern don't cascade through entire component tree

2. **Why Tailwind CSS for styling?**
   - **Consistency:** All portfolio-app styling uses Tailwind; avoids CSS framework fragmentation
   - **Responsive:** Breakpoints (`md:`, `lg:`) align with existing grid system
   - **Dark Mode:** `dark:` modifier ensures night-mode readability
   - **Bundle Size:** Utility-first CSS with tree-shaking minimizes overhead

3. **Why responsive grid (3-column desktop)?**
   - **Scalability:** Three evidence categories (dossier, threat model, ADRs) fit naturally; supports future evidence types
   - **Visual Balance:** Matches portfolio-app grid philosophy across all pages
   - **Mobile-First:** Design starts at 1 column; progressively enhances

4. **Why build links from registry rather than hardcode?**
   - **Portability:** Registry is single source of truth; link changes update all pages
   - **Environment Awareness:** `docsUrl()` helper applies to dev/staging/production deployments
   - **Maintainability:** Adding new projects or changing evidence URLs requires registry edit only

#### Integration Pattern

Components are imported and used on project detail pages:

```typescript
// In src/app/projects/[slug]/page.tsx
import { EvidenceBlock } from '@/components/EvidenceBlock';
import { BadgeGroup } from '@/components/BadgeGroup';

// In JSX:
<BadgeGroup project={project} />           // Header
<EvidenceBlock project={project} />        // After "What This Proves"
````

Evidence data flow:

1. Registry loads from `src/data/projects.yml`
2. Registry is validated for slug uniqueness, URL validity, evidence link patterns
3. Components receive `Project` type (TypeScript)
4. Components extract `evidence` and `isGoldStandard` fields
5. Components call `docsUrl()` to interpolate environment-based links
6. Components render responsive, accessible UI

#### Maintainability & Future Enhancements

**Current Implementation (Stage 3.2):**

- Static badge rendering based on evidence presence
- Fixed evidence categories (dossier, threat model, ADRs, runbooks, GitHub)

**Future Enhancement Candidates (Post-Stage 3.2):**

- Tooltip explanations for each evidence type
- Visual indicators for "incomplete" or "outdated" evidence
- Badge counts (e.g., "4 ADRs") to signal depth
- Click-through analytics (optional, privacy-safe)
- Link validation dashboard (showing broken evidence links)
- Keyboard focus management and enhanced a11y
- Storybook integration for component library documentation

#### See Also

- **Component Specifications:** Portfolio App Copilot Instructions, Section 8 — [Phase 3 Stage 3.2](https://github.com/bryce-seefieldt/portfolio-app/blob/main/.github/copilot-instructions.md#8-phase-3-stage-32--evidenceblock-components)
- **Implementation Details:** [stage-3-2-app-issue.md](/docs/00-portfolio/roadmap/issues/stage-3-2-app-issue.md)
- **Registry Schema:** [docs/70-reference/registry-schema-guide.md](/docs/70-reference/registry-schema-guide.md)
- **Gold Standard:** [ADR-0010 — Gold Standard Exemplar](/docs/10-architecture/adr/adr-0010-portfolio-app-as-gold-standard-exemplar.md)

```

#### 3. Verification Pass for `03-deployment.md`, `04-security.md`, `05-testing.md`

**03-deployment.md:**
- [X] Verify deployment steps mention component build step (Next.js build compiles/bundles components)
- [X] No new deployment infrastructure needed (components are client-side only)
- [X] No required environment variable changes for components
- [X] Deployment URL strategy unchanged (components use existing `NEXT_PUBLIC_*` vars)

**04-security.md:**
- [X] Components accept `project` prop only (no external API calls)
- [X] Components render links; no form submission or authentication
- [X] No secrets embedded in component code or styling
- [X] Evidence links are validated by registry loader (trust already established)
- [X] Conclusion: Components add no new attack surface or trust boundaries

**05-testing.md:**
- [X] Add note: Playwright smoke tests verify project pages render correctly with components
- [X] Add note: Components styled with Tailwind; testing focuses on DOM presence and link accessibility, not visual regression
- [X] Manual testing: verify responsive design on mobile/tablet/desktop (covered in app issue)

---

## Decision Documentation

This stage does NOT require new ADRs. The component layer is an implementation detail of Stage 3.2; the decision to use "evidence-driven" design is already captured in ADR-0010 (Gold Standard Exemplar).

However, if reviewers ask:

**"Why is evidence visualization a component rather than inline HTML?"**

→ Rationale: Components enable reuse across future pages (index views, evidence dashboards), decouple styling from structure, and make the evidence intent explicit in code. Single Responsibility Principle: components render evidence; pages compose components.

---

## Reference Material Documentation

### Evidence Link Validation (Updated Dossier Checks)

**Pre-merge checklist for this stage:**

- [X] Portfolio App dossier contains no broken links
- [X] All evidence paths in dossier match `src/data/projects.yml` structure
  - Dossier should reference: projects/portfolio-app/ (path in registry)
  - Threat model should reference: security/threat-models/portfolio-app-threat-model (path in registry)
  - ADR index should reference: architecture/adr/ (standard path)
  - Runbooks should reference: operations/runbooks/ (standard path)
- [X] Registry validation passes: `pnpm registry:validate` (from portfolio-app repo)
- [X] Build succeeds: `pnpm build` (portfolio-docs)
- [X] No console warnings about missing evidence in project pages

### Audience Guidance

**For Code Reviewers:**
- Components are simple, presentational React
- No business logic or state management
- Props well-typed with TypeScript
- Styling uses existing Tailwind conventions

**For Architects:**
- Component layer supports future scaling (new evidence types, new pages)
- Evidence strategy remains registry-first (single source of truth)
- Environment-based linking maintains portability

**For Operations:**
- No new infrastructure or deployment steps
- No new environment variables
- Components fully static (no API calls, no backend dependencies)

---

## Success Criteria

- [x] ✅ Portfolio App dossier updated with Stage 3.2 component architecture section
- [x] ✅ Overview page mentions component library with link to detailed architecture
- [x] ✅ Architecture section explains all three components (VerificationBadge, BadgeGroup, EvidenceBlock)
- [x] ✅ Design decisions documented (why separate components, why Tailwind, why registry-first, why responsive grid)
- [x] ✅ All evidence links in dossier resolve to correct docs URLs
- [x] ✅ No broken internal links (build succeeds without warnings: `pnpm build` PASSED)
- [x] ✅ ADRs and threat model remain consistent (no contradictions)
- [x] ✅ Testing guidance verified (no updates needed)
- [x] ✅ Deployment documentation verified (no changes required)
- [x] ✅ Future enhancement candidates listed in Maintainability section
- [x] ✅ Feature branch created: `docs/stage-3-2-evidence-components`
- [x] ✅ PR #47 created and pushed: https://github.com/bryce-seefieldt/portfolio-docs/pull/47
- [x] ✅ Companion PR #28 (portfolio-app) in parallel for synchronized merge

---

## Related Issues

- **Linked:** [stage-3-2-app-issue.md](/docs/00-portfolio/roadmap/issues/stage-3-2-app-issue.md) (companion implementation)
- **Dependency:** stage-3-1-docs-issue.md (completed) — registry documentation published
- **Reference:** Phase 3 Implementation Guide: [docs/00-portfolio/roadmap/phase-3-implementation-guide.md](/docs/00-portfolio/roadmap/phase-3-implementation-guide.md#stage-32-evidenceblock-component--badges-34-hours)
- **Related ADR:** ADR-0010 — Gold Standard Exemplar

---

## Documentation Quality Standards

All updates must follow portfolio-docs authoring standards:

- [X] Front matter correct: title, description, tags, sidebar_position (if applicable)
- [X] Standard page shape: Purpose / Scope / Content / Links (architecture pages may vary)
- [X] No broken links: all relative links start with `/docs/`, include prefix numbers, include `.md`
- [X] All external links use full GitHub URLs or production deployment URLs
- [X] Tone: enterprise engineering organization (explicit, verifiable, no marketing)
- [X] Mermaid diagrams (if added): tested locally with `pnpm build && pnpm serve`
- [X] Build succeeds: `pnpm build` with no warnings
- [X] No secrets or sensitive information

---

## Implementation Order

1. Update `01-overview.md` (brief mention)
2. Create new subsection in `02-architecture.md` (comprehensive)
3. Verification pass: `03-deployment.md`, `04-security.md`, `05-testing.md`
4. Build and test locally: `pnpm build && pnpm serve`
5. Fix any broken links or styling issues
6. Create PR with all dossier updates

---

## Post-Implementation Tasks (Next Phase)

- [X] Create release note entry documenting Stage 3.2 completion
- [X] Add Stage 3.2 metrics to Phase 3 completion checklist (actual effort vs. estimate)
- [X] Plan Stage 3.3 (Unit & E2E Tests)

---

## Notes for Reviewers

**Scope Boundaries:**

This docs work is **intentionally limited** to dossier updates and verification. It does NOT include:
- New ADRs (Stage 3.2 is implementation, not architectural decision)
- New threat models (components add no new attack surface)
- New runbooks (no operational changes)
- New releases notes (handled separately post-implementation)

**Component Visibility in Docs:**

The components themselves are NOT documented in portfolio-docs (that would be redundant). Instead:
- Architecture page explains **why** components exist and **how** they're designed
- Copilot instructions in portfolio-app contain **full specs** (props, styling, behavior)
- GitHub issue ([stage-3-2-app-issue.md](/docs/00-portfolio/roadmap/issues/stage-3-2-app-issue.md)) contains **implementation tasks**

This keeps implementation details close to code and architecture explanations close to decision rationale.

**Evidence Consistency:**

Key invariant: All evidence paths mentioned in dossier must match registry structure in `src/data/projects.yml`. This stage maintains that invariant through verification tasks.

---

## Reference Documentation

- **Phase 3 Implementation Guide:** [phase-3-implementation-guide.md](/docs/00-portfolio/roadmap/phase-3-implementation-guide.md#stage-32-evidenceblock-component--badges-34-hours)
- **Portfolio App Dossier — Architecture:** [docs/60-projects/portfolio-app/02-architecture.md](/docs/60-projects/portfolio-app/02-architecture.md)
- **Registry Schema Guide:** [docs/70-reference/registry-schema-guide.md](/docs/70-reference/registry-schema-guide.md)
- **ADR-0010 — Gold Standard Exemplar:** [docs/10-architecture/adr/adr-0010-portfolio-app-as-gold-standard-exemplar](/docs/10-architecture/adr/adr-0010-portfolio-app-as-gold-standard-exemplar.md)
- **Copilot Instructions (Portfolio App):** Section 8 — Phase 3 Stage 3.2

```
