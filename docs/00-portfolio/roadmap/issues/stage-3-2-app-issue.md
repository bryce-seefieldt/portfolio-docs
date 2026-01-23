---
title: 'Stage 3.2 — EvidenceBlock Components & Badges (App)'
description: 'Implements EvidenceBlock, VerificationBadge, and BadgeGroup components and integrates them into project pages with strict TypeScript and Tailwind styling.'
tags: [portfolio, roadmap, planning, phase-3, stage-3.2, app, implementation]
---

# Stage 3.2: EvidenceBlock Components & Badges — App Implementation

**Type:** Feature / Implementation  
**Phase:** Phase 3 — Scaling & Governance  
**Stage:** 3.2  
**Linked Issue:** [stage-3-2-docs-issue.md](/docs/00-portfolio/roadmap/issues/stage-3-2-docs-issue.md)  
**Duration Estimate:** 3–4 hours  
**Assignee:** GitHub Copilot / Engineering Lead  
**Created:** 2026-01-21  
**Status:** ✅ COMPLETE (2026-01-22)

---

## Overview

This stage introduces three reusable React components for standardized evidence linking on project pages. After Stage 3.1 (registry) completed successfully, we now make evidence visualization a first-class concern through dedicated, composable components.

The components—`EvidenceBlock`, `VerificationBadge`, and `BadgeGroup`—enable reviewers to quickly verify evidence artifact availability (dossiers, threat models, ADRs, runbooks) at a glance, improving the credibility signal of projects.

**Why this matters:** Evidence visibility is core to the portfolio's "gold standard" positioning. These components move evidence from buried links to prominent, visual, integrated presentation on project pages.

## Objectives

- Create three reusable React components for evidence visualization
- Integrate components into project detail pages (`/projects/[slug]`)
- Ensure responsive design across mobile, tablet, and desktop
- Maintain Tailwind CSS v4 styling consistency with dark mode support
- Pass TypeScript strict mode and ESLint checks
- Update project pages without breaking existing functionality

---

## Scope

### Files to Create

1. **`src/components/EvidenceBlock.tsx`** — Evidence artifact display card
   - Renders dossier, threat model, ADRs, runbooks, GitHub links in responsive grid
   - Props: `project: Project`, `className?: string`
   - Responsive grid: 1 col (mobile) → 2 cols (tablet) → 3 cols (desktop)
   - Placeholders for unavailable evidence categories

2. **`src/components/VerificationBadge.tsx`** — Status indicator badge
   - Props: `type: 'docs-available' | 'threat-model' | 'gold-standard' | 'adr-complete'`, `title?: string`
   - Each badge type has specific color scheme and icon
   - Includes hover effects and accessibility attributes (aria-label, title)
   - Styled with Tailwind border, background, text, and dark mode support

3. **`src/components/BadgeGroup.tsx`** — Multi-badge container
   - Props: `project: Project`, `className?: string`
   - Conditional rendering: show badge only if evidence is present
   - Responsive flex wrapping with gap spacing
   - Example: portfolio-app renders [Gold Standard] [Docs Available] [Threat Model]

### Files to Update

1. **`src/app/projects/[slug]/page.tsx`** — Project detail page
   - Import and integrate `EvidenceBlock` component
   - Place after "What This Project Proves" section
   - Import and integrate `BadgeGroup` component
   - Place in header area near project title (after GoldStandardBadge, before summary)
   - Ensure responsive layout remains clean on mobile

2. **`src/lib/config.ts`** (verify, no changes needed)
   - Ensure `docsUrl()` and `githubUrl()` helpers remain stable
   - These are already used by components for link construction

3. **`package.json`** (verify)
   - No new dependencies needed (use existing Tailwind, React, TypeScript)
   - Verify `@types/react` is present for component typing

---

## Design & Architecture

### System Overview

```
Project Registry (src/data/projects.yml)
        ↓
   Registry Loader (src/lib/registry.ts)
        ↓
   Project Data Type
        ↓
   Component Integration:
   ├─ EvidenceBlock → displays evidence links in grid
   ├─ VerificationBadge → renders individual badge
   └─ BadgeGroup → conditionally shows multiple badges
        ↓
   Project Page (/projects/[slug])
```

### Component Data Model

**EvidenceBlock Props:**

```typescript
interface EvidenceBlockProps {
  project: Project; // From registry
  className?: string; // Additional Tailwind classes
}

// Uses project.evidence to extract paths, then calls docsUrl()
// Renders grid of evidence categories (dossier, threat model, ADRs, runbooks, GitHub)
```

**VerificationBadge Props:**

```typescript
type BadgeType =
  | 'docs-available'
  | 'threat-model'
  | 'gold-standard'
  | 'adr-complete';

interface VerificationBadgeProps {
  type: BadgeType;
  title?: string; // Tooltip text
}

// Renders single badge with icon, label, and color scheme
```

**BadgeGroup Props:**

```typescript
interface BadgeGroupProps {
  project: Project; // From registry
  className?: string; // Additional Tailwind classes
}

// Analyzes project.evidence and renders appropriate badges
// Logic: show badge if corresponding evidence path exists
```

### Component Architecture Decisions

1. **Why separate components?**
   - `EvidenceBlock`: "What evidence exists?" (comprehensive reference)
   - `VerificationBadge`: "Is evidence complete?" (quick status check)
   - `BadgeGroup`: "Aggregate status" (header-level indicator)
   - Separation allows reuse in different contexts (future pages, indexes)

2. **Why functional components?**
   - Simpler testing, better tree-shaking, modern React patterns
   - Consistent with existing portfolio-app codebase (all pages use functional components)

3. **Why Tailwind for styling?**
   - Already used across portfolio-app (no new CSS framework dependency)
   - Responsive breakpoints align with existing grid system
   - Dark mode support via `dark:` modifier

4. **Why grid layout?**
   - Responsive and mobile-first (1 col → 2 → 3 matches Tailwind semantics)
   - Visual hierarchy matches portfolio-app design language
   - Scalable: easy to add more evidence categories in future

---

## Validation Rules & Constraints

1. **TypeScript Compliance:**
   - Strict mode: no implicit any, full type annotations
   - All props must be typed
   - Component return type: `JSX.Element` or `React.ReactNode` as appropriate

2. **Styling Rules:**
   - Tailwind classes only (no inline styles)
   - Dark mode: every color class must have `dark:` variant
   - Responsive: use `md:` and `lg:` breakpoints
   - No CSS modules or external CSS files

3. **Accessibility:**
   - All interactive elements (links) must be keyboard navigable
   - Badges should have aria-label or title attributes
   - Color must not be the only indicator; use icons/text in addition

4. **Evidence Link Validation:**
   - All links must use `docsUrl()` helper (for docs URLs)
   - GitHub links must use `githubUrl()` helper (if applicable)
   - No hardcoded URLs; env-based interpolation handled by registry

5. **Component Styling Constraints:**
   - Border radius: use Tailwind `rounded-lg` for cards, `rounded-full` for badges
   - Spacing: use Tailwind gap system (`gap-4`, `gap-3`, etc.)
   - Shadows: use `shadow`, `hover:shadow-md` for depth
   - Max width: components should be responsive (no fixed widths)

---

## Implementation Tasks

Break the work into concrete, sequential phases with clear deliverables.

### Phase 1: Component Scaffolding & Baseline (1.5–2 hours)

[Description: Scaffold three components with TypeScript interfaces and basic Tailwind structure]

#### Tasks

- [x] Create `src/components/EvidenceBlock.tsx`
  - Start with interface: `EvidenceBlockProps`
  - Render placeholder grid structure (3 cols on desktop, 1 on mobile)
  - Use Tailwind `grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4`
  - Files: `src/components/EvidenceBlock.tsx`

- [x] Create `src/components/VerificationBadge.tsx`
  - Define `BadgeType` union type
  - Create badge styling map: `type → (color, icon, label)`
  - Render single inline badge with icon, text, hover effects
  - Files: `src/components/VerificationBadge.tsx`

- [x] Create `src/components/BadgeGroup.tsx`
  - Define conditional badge logic: check evidence presence
  - Render flex container with VerificationBadge components
  - Files: `src/components/BadgeGroup.tsx`

- [x] Verify TypeScript compiles
  - Run: `pnpm typecheck`
  - No errors; all types properly inferred/explicit

- [x] Verify ESLint passes
  - Run: `pnpm lint`
  - No errors or warnings for new files

#### Success Criteria for This Phase

- [x] All three components defined with full TypeScript types
- [x] `pnpm typecheck` passes
- [x] `pnpm lint` passes (new files clean)
- [x] Components render without runtime errors (local dev verified)
- [x] All Tailwind classes are recognized (no purge warnings)

---

### Phase 2: Evidence Link Integration (1–1.5 hours)

[Description: Populate components with actual evidence data from registry]

#### Tasks

- [x] Implement `EvidenceBlock` content
  - Extract evidence from `project.evidence`
  - For each category (dossier, threat model, ADRs, runbooks, GitHub):
    - If present: render link using `docsUrl()` or `githubUrl()`
    - If absent: render placeholder ("Not available yet")
  - Use `evidenceLinks()` helper from `src/lib/registry.ts`
  - Files: `src/components/EvidenceBlock.tsx`

- [x] Implement `BadgeGroup` logic
  - Check presence: `project.evidence?.dossierPath`, `threatModelPath`, `adrIndexPath`, `isGoldStandard`
  - Map to badge types and render conditionally
  - Files: `src/components/BadgeGroup.tsx`

- [x] Test links locally
  - Run: `pnpm dev`
  - Navigate to `/projects/portfolio-app` and `/projects/portfolio-docs-app`
  - Verify evidence links are clickable and navigate correctly
  - Check dark mode (toggle in DevTools)

- [x] Verify no broken links
  - All `docsUrl()` calls resolve (use live docs deployment)
  - All `repoUrl` values from registry are valid

#### Success Criteria for This Phase

- [x] EvidenceBlock renders actual evidence links (no placeholders for portfolio-app)
- [x] BadgeGroup shows correct badges for both featured projects
- [x] All links navigate correctly (tested in dev)
- [x] Dark mode renders correctly for all badges and blocks
- [x] No console errors

---

### Phase 3: Page Integration & Responsive Testing (1–1.5 hours)

[Description: Integrate components into project detail pages and validate responsive design]

#### Tasks

- [x] Import and integrate `BadgeGroup` in `/projects/[slug]/page.tsx`
  - Add after `GoldStandardBadge` component (or as alternative if portfolio-app-specific)
  - Place in header section, before summary text
  - Pass `project` prop
  - Files: `src/app/projects/[slug]/page.tsx`

- [x] Import and integrate `EvidenceBlock` in `/projects/[slug]/page.tsx`
  - Add after "What This Project Proves" section
  - Pass `project` prop
  - Add explanatory text: "Evidence Trail — Verify completeness of supporting artifacts"
  - Files: `src/app/projects/[slug]/page.tsx`

- [x] Test responsive design (mobile-first)
  - Devices to test:
    - iPhone 12 (portrait, 390px wide)
    - iPad (portrait, 768px wide)
    - Desktop (1440px+)
  - Verify EvidenceBlock grid adapts correctly (1 → 2 → 3 cols)
  - Verify BadgeGroup wraps correctly on mobile
  - Verify no text overflow or styling breaks

- [x] Test page rendering
  - Run: `pnpm dev`
  - Navigate to `/projects/portfolio-app` and `/projects/portfolio-docs-app`
  - Verify badges and evidence block render without errors
  - Check page load time (no performance regression)

- [x] Test dark mode
  - DevTools: toggle dark mode
  - Verify all badges use `dark:` variants correctly
  - Check contrast ratios (accessibility)

#### Success Criteria for This Phase

- [x] Project pages render with BadgeGroup and EvidenceBlock integrated
- [x] Responsive design works on iPhone 12, iPad, desktop (verified in DevTools)
- [x] No layout shifts or broken styling
- [x] Dark mode renders correctly with proper contrast
- [x] Page performance unchanged (no new metrics degradation)

---

### Phase 4: Testing & Quality Gates (0.5–1 hour)

[Description: Verify all quality gates pass and components are production-ready]

#### Tasks

- [x] Run full quality suite
  - `pnpm lint` — no errors
  - `pnpm format:check` — consistent formatting
  - `pnpm typecheck` — strict TypeScript
  - `pnpm build` — Next.js build succeeds

- [x] Verify Playwright smoke tests still pass
  - Run: `pnpm build && pnpm playwright test`
  - All routes accessible
  - Evidence links resolvable in test environment

- [x] Code review checklist
  - [x] All components are pure (no side effects in render)
  - [x] Props are minimal and well-typed
  - [x] Components can be reused in other pages (no hard dependencies)
  - [x] No secrets or sensitive data in components
  - [x] Comments added for complex logic (if any)

- [x] Documentation checklist
  - [x] Components have JSDoc comments (optional but recommended)
  - [x] Component props documented (TypeScript provides this)
  - [x] Integration instructions clear in component usage

#### Success Criteria for This Phase

- [x] All quality checks pass: `pnpm lint`, `pnpm format:check`, `pnpm typecheck`, `pnpm build`
- [x] Playwright smoke tests pass (project pages load)
- [x] No TypeScript errors or ESLint warnings
- [x] Code is clean, reviewable, and maintainable

---

## Testing Strategy

### Manual Testing (Required Before PR)

- [x] Components render without TypeScript errors
- [x] Project pages display badges correctly
- [x] Evidence links are functional and navigate to correct docs pages
- [x] Responsive design verified on mobile (iPhone 12), tablet (iPad), desktop (1440px+)
- [x] Dark mode tested and verified
- [x] Hover effects work on badges and links
- [x] Page performance not degraded (web vitals stable)

### Automated Testing

**Playwright E2E Tests (existing smoke tests):**

- [x] `/projects/portfolio-app` loads successfully
- [x] `/projects/portfolio-docs-app` loads successfully
- [x] EvidenceBlock renders on page
- [x] BadgeGroup renders badges
- [x] Evidence links are present in DOM (use `.getByRole('link')`)

**TypeScript & Linting:**

- [x] No compile errors: `pnpm typecheck`
- [x] No lint warnings: `pnpm lint`
- [x] Formatting check: `pnpm format:check`

**Build Validation:**

- [x] Next.js build succeeds: `pnpm build`
- [x] Static export works (if configured)

### CI Integration

- All checks required for merge to `main`:
  - `ci / quality` (includes lint, format, typecheck)
  - `ci / build` (includes Next.js build + Playwright smoke tests)

---

## Acceptance Criteria

- [x] ✅ Three components created: `EvidenceBlock`, `VerificationBadge`, `BadgeGroup`
- [x] ✅ Components integrated into `/projects/[slug]` page
- [x] ✅ Responsive design working: mobile (1 col) → tablet (2 cols) → desktop (3 cols)
- [x] ✅ All evidence links functional and navigate correctly
- [x] ✅ Dark mode support verified (all colors use `dark:` variants)
- [x] ✅ TypeScript strict mode: zero errors
- [x] ✅ ESLint and Prettier: zero errors/warnings for new files
- [x] ✅ `pnpm build` succeeds deterministically
- [x] ✅ Playwright smoke tests pass
- [x] ✅ Feature branch created: `feat/stage-3-2-evidence-components`
- [x] ✅ PR #28 created and pushed: https://github.com/bryce-seefieldt/portfolio-app/pull/28
- [x] ✅ Awaiting CI validation before merge (companion docs PR #47 in parallel)

---

## Related Issues

- **Linked:** [stage-3-2-docs-issue.md](/docs/00-portfolio/roadmap/issues/stage-3-2-docs-issue.md) (companion documentation work)
- **Dependency:** stage-3-1-APP-ISSUE.md (completed) — registry must exist for this to consume
- **Reference:** Phase 3 Implementation Guide: [docs/00-portfolio/roadmap/phase-3-implementation-guide.md](/docs/00-portfolio/roadmap/phase-3-implementation-guide.md)

---

## Notes for Reviewers

**Component Reusability:**

These components are designed to be used beyond project pages. Future expansions might place badges on:

- Project index pages (list view)
- Evidence index pages (dossier hub)
- Portfolio homepage (featured projects preview)

**Styling Philosophy:**

Consistent with existing portfolio-app design:

- Tailwind 4 utility-first approach
- Dark mode via `dark:` modifier (no separate color schemes)
- Responsive grid system (mobile-first)
- Subtle animations (hover effects only; no forced transitions)

**Evidence Link Strategy:**

Components use existing helpers (`docsUrl()`, `githubUrl()`) to ensure:

- Links remain portable (environment-based)
- Changes to URL strategy require only config updates, not component changes
- Evidence paths maintained in single source of truth (`src/data/projects.yml`)

**Future Enhancements (Post-Stage 3.2):**

- Add badge tooltips explaining each evidence type
- Add visual indicators for "incomplete" evidence
- Add click-through analytics (optional, privacy-safe)
- Add keyboard navigation/focus states (optional enhancement)

---

## Success Metrics

After Stage 3.2 is complete:

1. **Functionality:** Project pages render evidence visually and consistently
2. **Usability:** Reviewers can verify evidence availability in < 10 seconds per project
3. **Code Quality:** All components pass strict TypeScript, ESLint, and build checks
4. **Maintainability:** Components are reusable; easy to add new evidence types
5. **Performance:** No regression in page load time or web vitals
6. **Accessibility:** Components keyboard-navigable, sufficient color contrast

---

## Deployment & Release

- **Branch:** feature branch off `main` (e.g., `feat/stage-3-2-evidence-components`)
- **PR checklist:**
  - Summary of what changed (3 new components, integration into project pages)
  - Rationale: evidence visibility improves credibility signal
  - Evidence: `pnpm lint`, `pnpm format:check`, `pnpm typecheck`, `pnpm build` all pass
  - Security: "No secrets added"
  - Closes: #[issue-number] (this issue)
  - Reference companion: [stage-3-2-docs-issue.md](/docs/00-portfolio/roadmap/issues/stage-3-2-docs-issue.md)

- **Merge:** Requires both CI checks to pass (`ci / quality`, `ci / build`)
- **Post-merge:** Vercel auto-deploys preview and production

---

## Reference Documentation

- **Phase 3 Implementation Guide:** [phase-3-implementation-guide.md](/docs/00-portfolio/roadmap/phase-3-implementation-guide.md#stage-32-evidenceblock-component--badges-34-hours)
- **Portfolio App Copilot Instructions:** Section 8 — Phase 3 Stage 3.2
- **Component Styling Reference:** Existing components (GoldStandardBadge.tsx, Section.tsx, Callout.tsx)
- **Registry Reference:** src/lib/registry.ts (Project type, evidenceLinks helper)
- **Config Reference:** src/lib/config.ts (docsUrl, githubUrl helpers)
