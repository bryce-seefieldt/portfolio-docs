---
title: 'Templates Guide and Definitions of Done'
description: 'How to use documentation templates in this repository, including when to use each artifact type and the minimum Definition of Done (DoD) required for acceptance.'

tags: [meta, templates, governance, definition-of-done, documentation]
---

# Templates Guide and Definitions of Done

## Purpose

This document defines:

- when to use each template in `docs/_meta/templates/`
- the minimum **Definition of Done (DoD)** for each artifact type
- quality gates and review expectations so that humans and AI agents can contribute consistently

These templates are not optional. They enforce enterprise-level structure, traceability, and operational/security readiness.

## Scope

### In scope

- ADRs (Architecture Decision Records)
- Runbooks (Operational procedures)
- Threat models (Security analysis tied to a system boundary)
- Postmortems (Incident analysis and corrective action tracking)

### Out of scope

- general page writing rules (see `docs/_meta/doc-style-guide.md`)
- taxonomy and tagging rules (see `docs/_meta/taxonomy-and-tagging.md`)

## Template inventory

### Phase Planning & Delivery Templates

These templates enforce planning discipline and create traceable, measurable work across phases:

#### **1. Phase Implementation Guide** (`template-phase-implementation-guide.md`)

**Purpose:** Master plan for a phase that coordinates both app and docs delivery.

**When to use:**

- Creating the detailed execution plan for a new phase (e.g., "Phase 3 Implementation Guide")
- Scope: entire phase, both repositories, all stages
- Creates single source of truth for phase sequencing, dependencies, and success criteria

**Key sections:**

- Prerequisites and phase readiness verification
- Sequential steps OR parallel stages (choose one approach)
- Implementation tasks with phase-specific sequencing
- Testing strategy per stage
- Checklist for start/during/end of phase
- Effort estimates and total duration

**Output:** Published in `docs/00-portfolio/` as `phase-[X]-implementation-guide.md`

**How it works:**

1. Read at kickoff to align team on scope and sequencing
2. Reference throughout phase to ensure tasks are tracked
3. Update after phase completion with actual effort and lessons learned

---

#### **2. Phase Stage App Issue** (`template-phase-stage-app-issue.md`)

**Purpose:** GitHub issue template for app/code implementation work within a phase stage.

**When to use:**

- Creating an issue for app code work (e.g., "Stage 3.1: Data-Driven Registry — App Implementation")
- Scope: app repository (`portfolio-app`), specific stage
- Linked to a companion docs stage issue

**Key sections:**

- Overview and objectives for the stage
- Files to create, update, remove
- Design specifications (data model, API signatures, validation rules)
- Implementation tasks broken into sequential phases
- Testing strategy (unit, integration, E2E)
- Acceptance criteria with measurable outcomes

**Output:** Created as GitHub issue in `portfolio-app` repository

**How it works:**

1. Copy template as issue body when creating the GitHub issue
2. Fill required sections before marking "Ready for Development"
3. Link to companion docs stage issue in "Linked Issues"
4. Reference this issue in PR commit messages and PR description
5. Verify all acceptance criteria before marking complete

---

#### **3. Phase Stage Docs Issue** (`template-phase-stage-docs-issue.md`)

**Purpose:** GitHub issue template for documentation/analysis work within a phase stage.

**When to use:**

- Creating an issue for docs work (e.g., "Stage 3.1: Data-Driven Registry — Documentation")
- Scope: docs repository (`portfolio-docs`), specific stage
- Linked to a companion app stage issue

**Key sections:**

- Overview and objectives for the documentation deliverable
- Files to create and update
- Document type and template (ADR, runbook, reference guide, etc.)
- Content structure and outline
- For ADRs: problem statement, decision, rationale, consequences, alternatives
- For guides: audience, prerequisites, key concepts, examples
- Success criteria and verification steps

**Output:** Created as GitHub issue in `portfolio-docs` repository

**How it works:**

1. Copy template as issue body when creating the GitHub issue
2. Fill required sections before marking "Ready for Development"
3. Link to companion app stage issue in "Linked Issues"
4. Reference this issue in PR commit messages and PR description
5. Verify all acceptance criteria before marking complete

---

#### **4. Generic GitHub Issue** (`template-github-issue-generic.md`)

**Purpose:** General-purpose GitHub issue template for standalone work NOT related to phase stages.

**When to use:**

- Creating issues for ad-hoc work, urgent fixes, improvements, or one-off tasks
- Scope: repository-agnostic; can be used in `portfolio-app` or `portfolio-docs`
- NOT tied to a phase stage

**Supported types:**

- Bug reports (with reproduction steps)
- Feature requests (with problem statement)
- Enhancements/improvements
- Documentation (single-page updates)
- Refactoring
- Maintenance
- Other

**Key sections:**

- Description (with type-specific subsections)
- Scope (in/out of scope clarity)
- Acceptance criteria (checkboxes)
- Files affected
- Proposed solution (optional, for complex issues)
- Testing strategy (manual and automated)
- Effort estimate with task breakdown
- Dependencies and blocking relationships
- Checklists (before starting, during, before PR, etc.)
- Resolution documentation (filled in when complete)

**Output:** Created as GitHub issue in either repository

**How it works:**

1. Copy template as issue body when creating the GitHub issue
2. Keep only sections relevant to the issue type
3. Provide clear acceptance criteria
4. Reference this issue in PR commit messages
5. Fill in "Resolution" section before closing

---

### Documentation & Architecture Templates

- `template-adr.md` — Architecture Decision Records
- `template-runbook.md` — Operational procedures
- `template-threat-model.md` — Security analysis
- `template-postmortem.md` — Incident retrospectives
- `template-project-dossier/` — Complete project documentation (8-file structure)

Recommended conventions:

- Copy the template into the correct target directory.
- Fill all required sections.
- Remove placeholder text and “TBD” items unless explicitly tracked as planned work.

---

## How Templates Work Together: The Phase Delivery Workflow

### Anatomy of a Phase

A phase is delivered as an **integrated unit** across both repositories:

```
Phase N
├── Phase Implementation Guide (docs/00-portfolio/)
│   └── Master plan, sequencing, prerequisites, success criteria
│
├── Stage N.1
│   ├── App Stage Issue (portfolio-app)
│   │   └── Code/implementation work
│   └── Docs Stage Issue (portfolio-docs)
│       └── Documentation/analysis work
│
├── Stage N.2
│   ├── App Stage Issue
│   └── Docs Stage Issue
│
└── Stage N.3 (if applicable)
    ├── App Stage Issue
    └── Docs Stage Issue
```

### Workflow: Creating and Tracking a Phase

#### Step 1: Phase Planning

1. **Create Phase Implementation Guide** (published in `docs/00-portfolio/`)
   - Defines phase scope, sequencing, prerequisites
   - Lists all stages and their dependencies
   - Contains effort estimates and success criteria
   - Reference: `template-phase-implementation-guide.md`

2. **Communicate phase plan**
   - Link to implementation guide in team channels
   - Review plan for feasibility and dependencies
   - Confirm team alignment on sequencing

#### Step 2: Stage Planning (Before Work Starts)

For each stage, create two linked issues:

1. **Create App Stage Issue** (in `portfolio-app`)
   - Title: `Stage X.Y: [Title] — App Implementation`
   - Reference: `template-phase-stage-app-issue.md`
   - Link to companion docs stage issue
   - Acceptance criteria tied to code deliverables

2. **Create Docs Stage Issue** (in `portfolio-docs`)
   - Title: `Stage X.Y: [Title] — Documentation`
   - Reference: `template-phase-stage-docs-issue.md`
   - Link to companion app stage issue
   - Acceptance criteria tied to documentation/analysis deliverables

#### Step 3: Execution (During Work)

**For App Implementation:**

- Check out feature branch from app stage issue
- Implement code per design/architecture in issue body
- Add tests per testing strategy section
- Verify all acceptance criteria met
- Create PR referencing the app stage issue

**For Documentation:**

- Check out feature branch from docs stage issue
- Create/update documentation per content outline
- Link to relevant ADRs, runbooks, threat models as specified
- Verify all acceptance criteria met
- Create PR referencing the docs stage issue

#### Step 4: Verification (Before Merge)

**For both repositories:**

- [ ] All acceptance criteria complete and verified
- [ ] Companion repository work is also complete (or on track)
- [ ] Required CI checks passing
- [ ] Security statement confirmed ("No secrets added")
- [ ] PR reviewed and approved
- [ ] Both PRs merged and deployments successful

#### Step 5: Phase Completion

1. **Update Phase Implementation Guide**
   - Record actual effort vs. estimate
   - Document any scope changes
   - Capture lessons learned
   - Note any issues that blocked progress

2. **Create Phase Release Notes** (if significant changes)
   - Summarize what was delivered
   - Link to all stage issues and PRs
   - Highlight breaking changes (if any)

---

## When NOT to Use Phase Templates

These scenarios use **Generic GitHub Issue** template instead:

- **Urgent fixes:** security patches, production bugs (use generic issue)
- **One-off improvements:** performance tweaks, refactoring (use generic issue)
- **Ad-hoc documentation:** single-page updates, style guide clarifications (use generic issue)
- **Maintenance:** dependency upgrades, toolchain updates (use generic issue)

**Key difference:** Generic issues are tracked independently; phase stage issues are tracked as part of a coordinated phase delivery.

---

## Global rules (apply to all artifact types)

### Required front matter

All artifacts must have valid front matter with:

- `title`
- `description`
- `tags` (including the domain tag: `architecture` / `operations` / `security`)

### Standard section shape

Artifacts must maintain the repository’s standard shape:

1. Purpose
2. Scope
3. Prereqs / Inputs
4. Procedure / Content
5. Validation / Expected outcomes
6. Failure modes / Troubleshooting
7. References

Templates may add sections, but should not remove these headings.

### Public safety (non-negotiable)

Artifacts must not contain:

- secrets/tokens/private keys
- internal hostnames/private IPs
- raw logs with identifiers
- proprietary or sensitive details that should not be public

### Build hygiene

- Do not add markdown links to files that do not exist yet.
- The site must pass `pnpm build` before merge.

### PR expectations

Each PR must include:

- What changed
- Why
- Evidence (`pnpm build` passed)
- Security statement (“No secrets added”)

---

## ADR (Architecture Decision Record)

### When to use

Create an ADR when you:

- introduce or change core stack components (framework, hosting model, identity/auth, persistence)
- materially change system boundaries, trust boundaries, or data flows
- adopt/replace major platform capabilities (CI/CD gates, observability stack, deployment strategy)
- introduce a security control that has architectural implications

Do **not** create ADRs for:

- small refactors with no lasting implications
- purely editorial doc changes
- reversible experiments with no architectural consequences (use a short proposal note instead)

### Where it lives

- Primary: `docs/10-architecture/adr/`

### Naming convention

- `adr-0001-short-title.md`

### Minimum Definition of Done (ADR)

An ADR is complete only if it includes:

- **Context**: what problem and constraints exist
- **Decision**: clear statement of what is chosen
- **Alternatives considered**: at least 2 (or explicitly state why not applicable)
- **Consequences**: explicit tradeoffs, including operational and security impacts
- **Validation**: how success will be measured/verified
- **Failure modes + rollback/mitigation**: what can go wrong and what to do
- **References**: related architecture pages and impacted domains (security/runbooks/pipeline docs)

Quality checks:

- No implementation-level secrets
- Consequences include at least one operational and one security consideration (or explicitly “not applicable”)

---

## Runbook

### When to use

Create a runbook for any procedure that:

- an operator must execute under time pressure (deploy, rollback, triage)
- changes production-like state (config changes, dependency changes)
- is required to restore service or validate health

Do **not** use runbooks for:

- conceptual explanations
- raw command lists without a procedure (use Reference)
- one-off tasks that will never recur (unless it is likely to recur later)

### Where it lives

- Primary: `docs/50-operations/runbooks/`

### Naming convention

- `rbk-<system>-<task>.md`
  - e.g., `rbk-portfolio-deploy.md`, `rbk-portfolio-rollback.md`

### Minimum Definition of Done (Runbook)

A runbook is complete only if it includes:

- **Prereqs**: required access, tools, environment, and preconditions
- **Procedure**: step-by-step, copy/paste-safe commands
- **Validation**: explicit success checks (logs/metrics/smoke tests)
- **Rollback/Recovery**: explicit rollback triggers and a full rollback procedure
- **Failure modes**: common symptoms, causes, diagnostics, fixes
- **References**: relevant pipeline docs, architecture notes, and security considerations

Quality checks:

- Destructive steps have `:::warning` or `:::danger` admonitions
- Validation steps are executable and unambiguous
- Rollback is at least as detailed as deploy steps

---

## Threat Model

### When to use

Create or update a threat model when you:

- add/modify authentication/session handling
- introduce a new external integration or API boundary
- change data storage or data movement
- change deployment model (edge/CDN/headers) or runtime trust boundaries
- change CI/build integrity approach (supply chain posture)

Do **not** use threat models for:

- generic security advice without a defined system boundary
- purely theoretical risks unrelated to the service

### Where it lives

- Primary: `docs/40-security/threat-models/` (or `docs/40-security/` if you keep a single model)

### Naming convention

- `<system>-threat-model.md`
  - e.g., `portfolio-app-threat-model.md`

### Minimum Definition of Done (Threat Model)

A threat model is complete only if it includes:

- **System overview**: what is in scope, what is out of scope
- **Assets**: explicit list of what must be protected
- **Trust boundaries**: explicit boundary description
- **Entry points**: explicit list of external inputs and triggers
- **Threats**: concrete scenarios with impact/likelihood and mitigations
- **Controls required**: at least one enforceable SDLC control if applicable
- **Validation**: how mitigations are tested/verified
- **Residual risk**: explicit accepted risks with review notes (or “none”)

Quality checks:

- Threats are tied to entry points and assets (no free-floating lists)
- Mitigations are actionable, not vague
- Validation includes at least one reproducible check or evidence artifact expectation

---

## Postmortem

### When to use

Create a postmortem when:

- users experienced an outage, security event, or correctness issue
- a deploy required rollback or caused a material regression
- manual intervention was required to restore service or integrity
- monitoring/alerting failed to detect a meaningful issue in time

Do **not** use postmortems for:

- issues caught before user impact and resolved without incident response
- purely editorial documentation issues (use a normal PR note)

### Where it lives

- Primary: `docs/50-operations/incident-response/postmortems/`

### Naming convention

- `pm-YYYY-MM-DD-short-title.md`

### Minimum Definition of Done (Postmortem)

A postmortem is complete only if it includes:

- **Executive summary**: what happened, impact, duration, detection method
- **Timeline**: key events with timestamps and actions taken
- **Impact**: who/what was affected (public-safe)
- **Root cause**: primary cause + contributing factors
- **What went well / poorly**: honest operational assessment
- **Corrective actions**: owner, priority, due date, verification method
- **Validation**: how we confirm the issue is prevented or mitigated
- **References**: related PR/release/runbook/threat model (public-safe references)

Quality checks:

- Action items are verifiable (not “improve monitoring” without specifics)
- Postmortem is blameless and process-oriented
- Sensitive details are redacted/summarized appropriately

---

## Minimum acceptance checklist (quick reference)

Use this as a final scan before opening a PR:

- [ ] Correct template used for artifact type
- [ ] Front matter present (`title`, `description`, `tags`)
- [ ] Standard headings preserved
- [ ] No secrets or sensitive internals included
- [ ] Commands (if any) are fenced with language and copy/paste safe
- [ ] Validation steps present and actionable
- [ ] Rollback included for operational procedures
- [ ] References included (architecture/security/ops/cicd as relevant)
- [ ] `pnpm build` passes locally
- [ ] PR includes: what/why/evidence/no-secrets statement

## Troubleshooting

### “Where should this go?”

- Decisions → ADR
- How to do something safely and repeatedly → Runbook
- Security analysis tied to a boundary → Threat model
- User-impacting incident retrospective → Postmortem

### “This feels too heavy for a small change.”

Use the lightest artifact that still preserves traceability:

- small decision with lasting impact → ADR
- one operational action you might repeat → Runbook
- new entry point / integration → Threat model update
- any user impact incident → Postmortem
- planning a major multi-week development initiative → Phase Implementation Guide

---

## Phase Implementation Guide

### When to use

- You are planning a major development phase (e.g., Phase 2, Phase 3)
- The phase spans 2–4 weeks and includes multiple deliverables
- You need to coordinate work across multiple files/components
- You want to document the roadmap, timeline, and success criteria clearly

### What it contains

The template provides a standardized structure for planning phases that includes:

1. **Executive Overview:** Phase purpose, duration, deliverables
2. **Prerequisites:** Conditions that must be met before starting
3. **Implementation Structure:** Choice of two approaches:
   - **Sequential Steps:** For linear, cumulative work (e.g., Phase 2)
   - **Modular Stages:** For independent, parallel-capable work (e.g., Phase 3)
4. **Implementation Checklists:** Organized by step/stage with verification items
5. **Timeline & Resources:** Breakdown of hours and dependencies
6. **Success Criteria:** Clear, measurable indicators of completion
7. **Risk Mitigation:** Known risks and mitigation strategies
8. **Deployment & Communication:** Sequencing and review gates
9. **Troubleshooting & References:** Common issues and related docs

### Definition of Done (Phase Implementation Guide)

A Phase Implementation Guide is complete when:

- ✅ **Title & metadata:** Clear phase title, estimated duration, status, last updated date
- ✅ **Purpose & scope:** Executive summary explaining what problem the phase solves
- ✅ **Deliverables:** Bulleted list of tangible outputs (code, docs, tests, runbooks)
- ✅ **Prerequisites:** Checklist of conditions that must be met before starting
- ✅ **Implementation details:** Each step/stage includes goal, scope, action items, and success checks
- ✅ **Checklists:** Organized by step/stage with verifiable tasks
- ✅ **Timeline table:** Estimated hours per step/stage, total duration
- ✅ **Success criteria:** Measurable indicators that phase is complete
- ✅ **Risk mitigation:** Known risks and planned responses
- ✅ **References & next steps:** Links to related docs, ADRs, runbooks, and upcoming phases
- ✅ **No broken links:** All cross-references validate in local build
- ✅ **No secrets:** No tokens, private keys, or sensitive details
- ✅ **Deployment section:** Clear sequencing for rolling out phase changes
- ✅ **Revision history:** Starting version, dates, authors recorded

### How to use the template

1. Copy `template-phase-implementation-guide.md` to the appropriate location:

   ```
   docs/00-portfolio/phase-[x]-implementation-guide.md
   ```

2. Replace all `[X]` placeholders with actual phase number and details

3. Choose **one approach:**
   - **Sequential Steps:** For phases where each step builds on prior work
   - **Modular Stages:** For phases with independent deliverables

4. For each step/stage:
   - Document the goal and scope
   - List all action items and substeps
   - Include code examples or configurations
   - Specify files to create/modify
   - Add success verification items

5. Fill in the checklists, timeline, and success criteria

6. Document risks and mitigation strategies

7. Link to any new ADRs, runbooks, or threat models created during the phase

8. Run `pnpm build` to verify no broken links before PR

### Example usage

See existing examples:

- [Phase 2 Implementation Guide](/docs/00-portfolio/phase-2-implementation-guide.md) — Sequential steps approach
- [Phase 3 Implementation Guide](/docs/00-portfolio/phase-3-implementation-guide.md) — Modular stages approach

See existing examples:

- [Phase 2 Implementation Guide](/docs/00-portfolio/phase-2-implementation-guide.md) — Sequential steps approach
- [Phase 3 Implementation Guide](/docs/00-portfolio/phase-3-implementation-guide.md) — Modular stages approach

Both follow this template structure and serve as reference implementations.

---

## GitHub Issue Templates (for Phase Stages)

### Overview

GitHub issues are the primary tracking mechanism for individual stages within a phase. Each stage should be documented as an issue using the appropriate template:

- **App Implementation Issues** → Use `template-phase-stage-app-issue.md`
- **Documentation Issues** → Use `template-phase-stage-docs-issue.md`

These templates ensure:

- Clear objectives and deliverables
- Comprehensive task breakdowns with checklists
- Acceptance criteria that define "done"
- Test strategy and verification steps
- Cross-linking between related work
- Effort estimation and progress tracking

### When to Use App Issue Template

**Use `template-phase-stage-app-issue.md` when:**

- You are implementing a feature or stage in `portfolio-app`
- The work involves code changes (components, utilities, configuration)
- You need to track implementation, testing, and deployment
- The stage involves creating/updating TypeScript/React files

**Typical Stage Names:**

- "Stage 3.1: Data-Driven Project Registry & Validation"
- "Stage 3.2: EvidenceBlock Component & Badges"
- "Stage 3.3: Unit & E2E Tests"

**What the App Issue Template includes:**

- Overview and objectives
- Scope (files to create/update, dependencies)
- Design & architecture (data models, function signatures)
- Implementation tasks broken into sequential phases
- Testing strategy (unit, integration, E2E)
- Acceptance criteria (code quality gates)
- Performance and security considerations
- Effort breakdown and troubleshooting

### When to Use Docs Issue Template

**Use `template-phase-stage-docs-issue.md` when:**

- You are creating documentation (ADRs, guides, runbooks)
- The work involves content creation in `portfolio-docs`
- You need to track writing, review, and publication
- The stage involves creating markdown files

**Typical Stage Names:**

- "Stage 3.1: ADR-0011 & Registry Schema Documentation"
- "Stage 3.4: ADRs & Documentation Updates"
- "Stage 3.5: CI Link Validation & Runbooks"

**What the Docs Issue Template includes:**

- Overview and objectives
- Scope (files to create/update)
- Content structure and design (outlines, examples)
- Decision documentation (if ADR)
- Reference material documentation (if guide)
- Operational documentation (if runbook)
- Implementation tasks broken into sequential phases
- Acceptance criteria (content quality gates)
- Definition of Done checklist
- Coordination with implementation work

### How to Use These Templates

#### 1. Choose the Correct Template

Determine if the stage is primarily **app implementation** or **documentation**:

- Mostly code? → Use **App Issue** template
- Mostly documentation? → Use **Docs Issue** template
- Both equally? → Create TWO linked issues (one for each template)

#### 2. Create a GitHub Issue

In the appropriate repo (`portfolio-app` or `portfolio-docs`):

1. Click **"New Issue"**
2. Click **"Use a template"** (if configured) or paste the template content
3. Fill in all placeholder sections (`[X]`, `[description]`, etc.)

#### 3. Link Related Issues

If there are parallel app and docs issues for the same stage:

- **In the App issue:** Add link to Docs issue under "Related Issues"
- **In the Docs issue:** Add link to App issue under "Related Issues"

Example:

```markdown
## Related Issues

- Parent issue: [Link to Phase X Implementation Guide]
- Related docs issue: [Link to STAGE-X.Y-DOCS-ISSUE]
- Blocks: [What issues does this unblock]
```

#### 4. Fill Out All Required Sections

Key sections to prioritize:

- **Overview:** What is being delivered
- **Objectives:** Specific, measurable goals
- **Scope:** What's in/out; files to create/update
- **Implementation Tasks:** Broken into phases with checkboxes
- **Acceptance Criteria:** Definition of done
- **Effort Breakdown:** Hours estimate

#### 5. Keep the Issue Updated

As you work:

- [ ] Check off tasks as you complete them
- [ ] Update status in the issue description or comments
- [ ] Link PRs that implement the issue work
- [ ] Document blockers or delays

#### 6. Verify Completion

Before marking the issue done:

- [ ] All tasks checked off
- [ ] All acceptance criteria met
- [ ] All related PRs merged
- [ ] Tests/builds passing
- [ ] Links/cross-references verified
- [ ] Documentation complete
- [ ] Reviewer approved

### Example Issues Using These Templates

**App Implementation Example:**

See [STAGE-3.1-APP-ISSUE.MD](/docs/00-portfolio/STAGE-3.1-APP-ISSUE.MD) for a complete example of the App Issue template in use for portfolio-app Stage 3.1.

**Documentation Example:**

See [STAGE-3.1-DOCS-ISSUE.md](/docs/00-portfolio/STAGE-3.1-DOCS-ISSUE.md) for a complete example of the Docs Issue template in use for portfolio-docs Stage 3.1.

### Definition of Done (GitHub Issues)

An issue using these templates is complete when:

✅ **For App Issues:**

- All implementation phases complete
- All tasks checked off
- All tests passing (`pnpm verify`)
- All acceptance criteria met
- Code reviewed and approved
- PRs merged to `main`
- Related docs issue updated (if applicable)

✅ **For Docs Issues:**

- All documentation phases complete
- All content written (no TODOs)
- Build verified (`pnpm build` passes)
- All links working
- Technical accuracy verified
- Related docs updated
- Docs reviewed and approved
- PRs merged to `main`
- Related implementation issue linked

### Issue Linking & Coordination

**Linking Pattern for Phase Stages:**

```
Phase X Implementation Guide (parent)
  ├── STAGE-X.1-APP-ISSUE (linked to STAGE-X.1-DOCS-ISSUE)
  │   └── Blocks: STAGE-X.2-APP-ISSUE, STAGE-X.2-DOCS-ISSUE (if sequential)
  ├── STAGE-X.1-DOCS-ISSUE (linked to STAGE-X.1-APP-ISSUE)
  │   └── Depends on: STAGE-X.1-APP-ISSUE (if docs document implementation)
  ├── STAGE-X.2-APP-ISSUE
  │   └── Depends on: STAGE-X.1-APP-ISSUE (if sequential)
  └── [Additional stages...]
```

### Best Practices

1. **Create issues early:** Create all stage issues when the Phase is kicked off
2. **Link bidirectionally:** If there's an app and docs issue, link both ways
3. **Update regularly:** Add comments for progress, blockers, learnings
4. **Link PRs:** Reference the issue in PR descriptions (`Closes #123`)
5. **Close on completion:** Close issue when all PRs merged and verified
6. **Leave comments:** Document any learnings or gotchas in issue comments

---

## References

This document is authoritative for artifact usage and DoD enforcement across the repository.

## References

This document is authoritative for artifact usage and DoD enforcement across the repository.
