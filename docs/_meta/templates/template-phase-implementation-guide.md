---
title: 'Phase [X] Implementation Guide: [Phase Title & Tagline]'
description: '[1–2 sentence summary of what Phase X delivers and why it matters]'
sidebar_position: 5
tags: ['phase-[x]', 'implementation', 'planning', 'governance']
---

# Phase [X] Implementation Guide — [Phase Title & Concise Objective]

**Phase:** Phase [X] ([Category: e.g., "Foundation", "Hardening", "Scaling"])  
**Estimated Duration:** [Total hours] ([hours/week] assuming [weeks])  
**Status:** [Ready to Execute | In Progress | Blocked]  
**Last Updated:** [YYYY-MM-DD]

## Purpose

[2–3 sentence executive summary of Phase X's purpose, scope, and strategic value. What problem does it solve? Why is it essential?]

## What Phase [X] Delivers

- **Deliverable 1:** [Brief description of tangible output]
- **Deliverable 2:** [Brief description of tangible output]
- **Deliverable 3:** [Brief description of tangible output]
- **[Additional deliverables as needed]**

---

## Prerequisites

Before starting Phase [X], ensure:

- ✅ Phase [X-1] complete and verified
- ✅ [Specific tool/environment requirement]
- ✅ [Team alignment or decision required]
- ✅ [Any resource or access requirements]
- ✅ [Integration points with existing systems]

**Verification checklist:**

```bash
# Run these commands to confirm readiness
[command to verify phase X-1 state]
[command to verify environment setup]
[command to verify integration points]
```

---

## Implementation Overview

### Two approaches to Phase [X] structure:

**Option A: Sequential Steps (for linear, cumulative work)**

- Use this for phases where each step builds directly on the previous
- Example: Phase 2 (each step adds capabilities to the app)

**Option B: Parallel Stages (for modular, independent work)**

- Use this for phases with distinct deliverables that can proceed in parallel
- Example: Phase 3 (registry, components, tests can be worked on independently)

---

## APPROACH A: Sequential Steps Implementation

### STEP 1: [Step Title] ([X–Y hours])

**Goal:** [What is the goal of this step? Measurable and specific.]

**Scope:**

- ✅ In scope: [what's included]
- ❌ Out of scope: [what's not included]

**Prerequisites:**

- [Prerequisite 1]
- [Prerequisite 2]

#### 1a. [Substep Name]

[Description and instructions for substep A]

**Example code/configuration:**

```[language]
[code example or configuration]
```

**Files to create/modify:**

- [ ] `path/to/file.ts` (new | update)
- [ ] `path/to/file.md` (new | update)

#### 1b. [Substep Name]

[Description and instructions for substep B]

#### 1c. [Additional substeps as needed]

**Success check:**

- [ ] [Verifiable outcome 1]
- [ ] [Verifiable outcome 2]
- [ ] PR created with title: `[Conventional commit type]: [description]`

**Related documentation:**

- See: [Link to relevant dossier page or ADR]
- Reference: [Link to reference docs]

---

### STEP 2: [Step Title] ([X–Y hours])

[Follow the same structure as STEP 1]

---

### STEP 3: [Additional steps as needed]

[Follow the same structure]

---

## APPROACH B: Modular Stages Implementation

### Stage [X].1: [Stage Title] ([X–Y hours])

**What:** [One-sentence description of the deliverable]

**Key Files/Components:**

- Create/Modify: `path/to/file.ts`
- Create/Modify: `path/to/component.tsx`

**Design Specifications:**

[Key design decisions, schema, or architecture for this stage]

```typescript
// Example schema or interface
[code example]
```

**Validation Rules:**

- Rule 1: [Specific validation requirement]
- Rule 2: [Specific validation requirement]

**CI Integration:**

[How this stage integrates with CI/CD pipeline]

**Deliverables:**

- ✅ [Tangible output 1]
- ✅ [Tangible output 2]
- ✅ Tests added to CI pipeline

**Success check:**

- [ ] [Verifiable outcome 1]
- [ ] [Verifiable outcome 2]
- [ ] PR created with title: `[Conventional commit type]: [description]`

---

### Stage [X].2: [Stage Title] ([X–Y hours])

[Follow the same structure as Stage X.1]

---

### Stage [X].3: [Additional stages as needed]

[Follow the same structure]

---

## Implementation Checklist

### Pre-Implementation

- [ ] Phase [X-1] verified and on `main` branch
- [ ] Team alignment on Phase [X] scope and timeline
- [ ] Create GitHub milestone: "Phase [X]" in both repos
- [ ] Create tracking issues per step/stage
- [ ] Review and approve this implementation guide
- [ ] Schedule review points (mid-phase, end-of-phase)

### [Step/Stage 1] Checklist

- [ ] [Subtask 1]
- [ ] [Subtask 2]
- [ ] [Subtask 3]
- [ ] Local verification: `pnpm verify` passes
- [ ] PR created and reviewed
- [ ] PR merged to `main`

### [Step/Stage 2] Checklist

- [ ] [Subtask 1]
- [ ] [Subtask 2]
- [ ] [Subtask 3]
- [ ] Local verification: `pnpm verify` passes
- [ ] PR created and reviewed
- [ ] PR merged to `main`

### [Additional Step/Stage Checklists as needed]

### Post-Implementation

- [ ] All PRs merged to `main`
- [ ] All CI checks passing
- [ ] Deployments successful (docs, then app)
- [ ] Phase [X] milestone closed
- [ ] Release notes created and published
- [ ] Team retrospective scheduled
- [ ] Phase [X+1] planning initiated

---

## Timeline & Resource Estimate

| Step/Stage | Task                   | Duration | Status    | Notes |
| ---------- | ---------------------- | -------- | --------- | ----- |
| [1]        | [Task name]            | 6–8h     | Ready     | —     |
| [2]        | [Task name]            | 3–4h     | Ready     | —     |
| [3]        | [Task name]            | 4–6h     | Ready     | —     |
| **Total**  | **Phase [X] Complete** | **21h**  | **Ready** | —     |

**Resource allocation:**

- **Personnel:** [Role]: [Hours/week]
- **Dependencies:** [External task or resource needed]
- **Risk factors:** [Known constraints or risks]

---

## Success Criteria

Phase [X] is complete when:

- ✅ [Measurable success criterion 1]
- ✅ [Measurable success criterion 2]
- ✅ [Measurable success criterion 3]
- ✅ All tests pass locally: `pnpm verify`
- ✅ All CI checks pass on `main`
- ✅ Deployments successful and production verified
- ✅ Documentation updated and links verified
- ✅ Runbooks tested and team trained

---

## Acceptance Criteria (Reviewability)

A reviewer can validate Phase [X] completion through:

- **Functionality:** [Feature can be demonstrated]
- **Quality:** [Code meets standards: lint, format, typecheck pass]
- **Documentation:** [Dossier/ADRs/runbooks updated as needed]
- **Testing:** [Unit/E2E tests added; coverage adequate]
- **Operations:** [Deployment procedures tested; rollback documented]

---

## Implementation Artifacts

### Code Deliverables

- [ ] [File path]: [Description]
- [ ] [File path]: [Description]
- [ ] [File path]: [Description]

### Documentation Deliverables

- [ ] New ADR: [ADR Title]
- [ ] Updated dossier pages: [List pages]
- [ ] New runbook: [Runbook title]
- [ ] Updated CONTRIBUTING.md with new guidance
- [ ] Release notes entry

### Testing Deliverables

- [ ] Unit tests in `src/__tests__/`
- [ ] E2E tests in `tests/e2e/`
- [ ] CI pipeline updated with new validation
- [ ] Test coverage: [Expected threshold]%

---

## Key Architecture Decisions

Document any durable decisions that warrant ADRs:

- **Decision 1:** [Brief statement]
  - **Rationale:** [Why this choice?]
  - **Alternative considered:** [What else was evaluated?]
  - **Implications:** [What does this enable/constrain?]

---

## Dependency Graph & Sequencing

[If stages/steps can run in parallel, document the dependency graph]

```
Step 1: Foundation
  ├→ Step 2: Feature A
  ├→ Step 3: Feature B
  └→ Step 4: Testing & Integration (depends on 2 & 3)
```

[Or for parallel stages:]

```
Stage 1.1 (Registry)     Stage 1.2 (Components)     Stage 1.3 (Tests)
    ↓                          ↓                            ↓
All stages can proceed in parallel; Stage 1.4 (CI Integration) depends on all.
```

---

## Risk Mitigation

| Risk                 | Likelihood | Impact | Mitigation                                     |
| -------------------- | ---------- | ------ | ---------------------------------------------- |
| [Risk description]   | High/Med   | High   | [Mitigation strategy]                          |
| [Risk description]   | Low        | High   | [Mitigation strategy]                          |
| [Coordination delay] | Med        | Med    | Schedule reviews; use async-friendly practices |

---

## Communication & Coordination

### Review Gates

- **Mid-phase review:** After [Step/Stage X]
  - Participants: [Roles]
  - Artifacts: [Code PR, documentation draft]

- **End-of-phase review:** After all steps/stages complete
  - Participants: [Roles]
  - Artifacts: [Release notes, dossier update, deployment evidence]

### Deployment Sequence

1. Merge all PRs to `main` branch
2. Deploy `portfolio-docs` first (if doc-only changes)
3. Deploy `portfolio-app` second (if app changes)
4. Verify production deployments
5. Publish release notes

---

## Tooling & Scripts

**Available commands:**

```bash
# Local verification
pnpm verify                    # Full verification (format, lint, typecheck, secrets, registry, build, performance, tests)
pnpm verify:quick              # Fast iteration (skips performance checks and all tests; still runs build)

# Performance analysis
pnpm analyze:bundle            # Generate bundle size report (ANALYZE=true pnpm build)
pnpm analyze:build             # Time the production build locally

# Individual checks
pnpm lint                       # ESLint
pnpm format:write              # Auto-format
pnpm format:check              # Verify formatting
pnpm typecheck                 # TypeScript validation
pnpm build                      # Production build
pnpm test                       # E2E/unit tests

# For portfolio-docs
pnpm build                      # Docusaurus build
pnpm start                      # Local dev server
```

---

## Reference Documentation

- [Roadmap — Phase [X]]([link])
- [Architecture Decision Records (ADRs)](/docs/10-architecture/adr/index.md)
- [Project Dossier Template](/docs/_meta/templates/template-project-dossier/)
- [Runbook Template](/docs/_meta/templates/template-runbook.md)
- [Threat Model Template](/docs/_meta/templates/template-threat-model.md)

---

## Troubleshooting

### Common Issues

**Issue: [Error message or symptom]**

- **Cause:** [Root cause]
- **Fix:** [Step-by-step resolution]

**Issue: [Error message or symptom]**

- **Cause:** [Root cause]
- **Fix:** [Step-by-step resolution]

---

## Next Steps After Phase [X]

Once Phase [X] is complete, consider:

1. **[Next Phase Name]** ([Estimated hours]): [Brief description]
2. **[Optional enhancement]** ([Estimated hours]): [Brief description]
3. **[Optional enhancement]** ([Estimated hours]): [Brief description]

---

## Notes & Assumptions

- [Assumption 1: e.g., "Assumes Node.js 20+ available"]
- [Assumption 2: e.g., "Assumes pnpm 10 via Corepack"]
- [Design constraint: e.g., "Must maintain backward compatibility with..."]
- [Risk: e.g., "Dependent on Vercel deployment availability"]

---

## Phase Completion Verification

**Completion sign-off:**

- [ ] All implementation steps/stages complete
- [ ] All PRs merged to `main`
- [ ] All CI checks passing
- [ ] Deployments verified in production
- [ ] Documentation updated and published
- [ ] Team trained on new procedures
- [ ] Retrospective completed
- [ ] Phase [X+1] planning scheduled

**Date completed:** [YYYY-MM-DD]  
**Completed by:** [Name/Team]  
**Retrospective notes:** [Link to retrospective document or notes]

---

## Revision History

| Date       | Author | Version | Changes                       |
| ---------- | ------ | ------- | ----------------------------- |
| 2026-01-20 | Team   | 1.0     | Initial template and planning |
| [Date]     | [Name] | [Ver]   | [Description of changes]      |

---

**Document Status:** [Draft | In Review | Approved | Deprecated]  
**Last Reviewed:** [Date]  
**Next Review:** [Date or "As needed"]
