---
title: 'Phase 6 Implementation Guide: Capstone, Evolution & Long-Term Signal'
description: 'Define how the portfolio evolves without undermining credibility, including versioning, inclusion criteria, and deprecation policy.'
sidebar_position: 6
tags: ['phase-6', 'implementation', 'planning', 'governance']
---

# Phase 6 Implementation Guide - Capstone, Evolution & Long-Term Signal

**Phase:** Phase 6 (Governance and longevity)  
**Estimated Duration:** 10-14 hours (3-4 hours/week assuming 3-4 weeks)  
**Status:** Ready to Execute  
**Last Updated:** 2026-02-05

## Purpose

Phase 6 defines how the portfolio stays credible over time. It formalizes what is allowed, how changes are introduced, and how older work is retired so the portfolio signals judgment, not noise.

## What Phase 6 Delivers

- **Inclusion criteria:** Clear rules for what does and does not belong in the portfolio.
- **Versioning strategy:** A consistent portfolio versioning and release cadence model.
- **Deprecation and archival policy:** Rules and procedures for retiring work without breaking evidence links.
- **Change intake workflow:** A lightweight governance flow for new additions.
- **Maintenance posture guidance:** Expectations for updates, stability windows, and review triggers.

---

## Prerequisites

Before starting Phase 6, ensure:

- ✅ Phase 5 complete and verified
- ✅ v1.0.0 tagged for app and docs
- ✅ Reviewer guide and evidence audit checklist published
- ✅ Known limitations documented and linked from portfolio hubs
- ✅ Runbooks updated for current deployment behavior

**Verification checklist:**

```bash
# From portfolio-app
pnpm verify

# From portfolio-docs
pnpm verify
```

---

## Implementation Overview

### Two approaches to Phase 6 structure:

**Option A: Sequential Steps (recommended)**

- Use this for governance work that builds on prior decisions
- Recommended because inclusion criteria should guide versioning, which informs change intake

**Option B: Parallel Stages**

- Use this only if policy owners and implementation owners are separate teams
- Requires additional review coordination to prevent conflicting guidance

---

## APPROACH A: Sequential Steps Implementation

### STEP 1: Define inclusion criteria and exclusions (3-4 hours)

**Goal:** Establish explicit rules for what belongs in the portfolio and what does not.

**Scope:**

- ✅ In scope: eligibility criteria, exclusion list, evidence requirements
- ❌ Out of scope: adding new projects or modifying existing project content

**Prerequisites:**

- Phase 5 reviewer guide available
- Evidence audit checklist available

#### 1a. Draft the inclusion criteria

Create a policy doc that defines acceptance rules for new additions.

**Files to create/modify:**

- [ ] `docs/00-portfolio/portfolio-eligibility-criteria.md` (new)
- [ ] `docs/00-portfolio/reviewer-guide.md` (update summary link)

#### 1b. Define explicit exclusions

Document what does not belong (ex: speculative demos, incomplete evidence, high-risk domains without runbooks).

#### 1c. Add evidence minimums

Specify the minimum evidence requirements for any new project entry.

**Success check:**

- [ ] Inclusion criteria and exclusion rules published
- [ ] Reviewer guide references the criteria
- [ ] PR created with title: `docs: add portfolio eligibility criteria`

**Related documentation:**

- See: [Reviewer Guide](/docs/00-portfolio/reviewer-guide.md)
- Reference: [Evidence Audit Checklist](/docs/70-reference/evidence-audit-checklist.md)

---

### STEP 2: Define versioning and lifecycle policy (3-5 hours)

**Goal:** Set a stable portfolio versioning and lifecycle model that reviewers can trust.

**Scope:**

- ✅ In scope: portfolio versioning policy, ADR, deprecation guidance
- ❌ Out of scope: changing deployment pipelines or CI workflows

**Prerequisites:**

- Step 1 completed

#### 2a. Create the versioning policy

Define the portfolio versioning approach (semantic versioning or calendar-based) and release cadence.

**Example policy snippet:**

```text
Versioning model: SemVer
- Major: material scope change or structural IA changes
- Minor: new project added with full evidence
- Patch: corrections, link fixes, or documentation clarifications
Release cadence: as-needed, with release notes required for Minor+ changes
```

**Files to create/modify:**

- [ ] `docs/00-portfolio/portfolio-versioning-policy.md` (new)
- [ ] `docs/10-architecture/adr/adr-00xx-portfolio-versioning.md` (new)

#### 2b. Define deprecation and archival policy

Create guidance for retiring projects or documents while preserving evidence integrity.

**Files to create/modify:**

- [ ] `docs/00-portfolio/portfolio-archival-policy.md` (new)
- [ ] `docs/50-operations/runbooks/rbk-portfolio-archival.md` (new)

**Success check:**

- [ ] Versioning policy published and linked from roadmap hub
- [ ] ADR created and referenced in the policy
- [ ] Deprecation and archival policy published
- [ ] PR created with title: `docs: define portfolio versioning and archival policy`

**Related documentation:**

- See: [Roadmap](/docs/00-portfolio/roadmap/index.md)
- Reference: [ADR Index](/docs/10-architecture/adr/index.md)

---

### STEP 3: Operationalize change intake (3-5 hours)

**Goal:** Create a lightweight, repeatable change intake process that enforces the new rules.

**Scope:**

- ✅ In scope: change intake checklist, reviewer impact checks, release note guidance
- ❌ Out of scope: adding new features or projects

**Prerequisites:**

- Steps 1-2 completed

#### 3a. Create a change intake checklist

Define the steps required for any new project or major portfolio change.

**Files to create/modify:**

- [ ] `docs/00-portfolio/portfolio-change-intake.md` (new)
- [ ] `docs/00-portfolio/release-notes/index.md` (update guidance link)

#### 3b. Update runbooks and hubs

Ensure the new change intake process is discoverable from core hubs.

#### 3c. Record Phase 6 completion

Add a release note entry documenting the Phase 6 governance update.

**Success check:**

- [ ] Change intake checklist published and linked from portfolio hubs
- [ ] Release note entry created for Phase 6
- [ ] Local verification: `pnpm verify` passes
- [ ] PR created with title: `docs: operationalize portfolio change intake`

**Related documentation:**

- See: [Release Notes](/docs/00-portfolio/release-notes/index.md)
- Reference: [Runbooks](/docs/50-operations/runbooks/index.md)

---

## Implementation Checklist

### Pre-Implementation

- [ ] Phase 5 verified and on `main` branch
- [ ] v1.0.0 tags exist for app and docs
- [ ] Reviewers agree on Phase 6 scope and intent
- [ ] Create tracking issues per step
- [ ] Review and approve this implementation guide
- [ ] Schedule mid-phase and end-phase reviews

### Step 1 Checklist

- [ ] Draft inclusion criteria
- [ ] Document explicit exclusions
- [ ] Add evidence minimums
- [ ] Update reviewer guide with links
- [ ] PR created and reviewed

### Step 2 Checklist

- [ ] Publish versioning policy
- [ ] Create ADR for versioning and lifecycle
- [ ] Publish archival policy and runbook
- [ ] Update roadmap hub links
- [ ] PR created and reviewed

### Step 3 Checklist

- [ ] Publish change intake checklist
- [ ] Update release notes index
- [ ] Add Phase 6 release note entry
- [ ] Local verification: `pnpm verify` passes
- [ ] PR created and reviewed

### Post-Implementation

- [ ] All PRs merged to `main`
- [ ] All CI checks passing
- [ ] Deployments successful (docs, then app if needed)
- [ ] Phase 6 release note published
- [ ] Portfolio hubs updated with governance links
- [ ] Phase 7 planning initiated or archived as optional

---

## Timeline & Resource Estimate

| Step/Stage | Task                                  | Duration   | Status    | Notes |
| ---------- | ------------------------------------- | ---------- | --------- | ----- |
| 1          | Inclusion criteria and exclusions     | 3-4h       | Ready     | -     |
| 2          | Versioning and lifecycle policy       | 3-5h       | Ready     | -     |
| 3          | Change intake and release note update | 3-5h       | Ready     | -     |
| **Total**  | **Phase 6 Complete**                  | **10-14h** | **Ready** | -     |

**Resource allocation:**

- **Personnel:** Portfolio owner: 3-4 hours/week
- **Dependencies:** None external; internal alignment required
- **Risk factors:** Over-constraining scope or under-documenting change gates

---

## Success Criteria

Phase 6 is complete when:

- ✅ Inclusion and exclusion criteria are published and linked from the roadmap
- ✅ Versioning and deprecation policies are documented with ADR support
- ✅ Change intake checklist is discoverable and used for new work
- ✅ Release note entry documents Phase 6 completion
- ✅ All tests pass locally: `pnpm verify`
- ✅ Documentation updated and links verified

---

## Acceptance Criteria (Reviewability)

A reviewer can validate Phase 6 completion through:

- **Governance:** Clear rules for additions, exclusions, and retirement
- **Quality:** Policies and ADRs consistent with existing governance style
- **Documentation:** Portfolio hubs link to criteria, versioning, and change intake
- **Operations:** Archival runbook provides step-by-step guidance
- **Testing:** Link integrity and verification remain green

---

## Implementation Artifacts

### Documentation Deliverables

- [ ] `docs/00-portfolio/portfolio-eligibility-criteria.md`: inclusion and exclusion rules
- [ ] `docs/00-portfolio/portfolio-versioning-policy.md`: portfolio versioning strategy
- [ ] `docs/00-portfolio/portfolio-archival-policy.md`: deprecation and archival expectations
- [ ] `docs/00-portfolio/portfolio-change-intake.md`: change intake checklist
- [ ] `docs/50-operations/runbooks/rbk-portfolio-archival.md`: archival procedure runbook
- [ ] `docs/10-architecture/adr/adr-00xx-portfolio-versioning.md`: ADR for lifecycle policy
- [ ] Release note entry documenting Phase 6

### Testing Deliverables

- [ ] Documentation link integrity verified
- [ ] `pnpm verify` passes in portfolio-docs

---

## Key Architecture Decisions

Document any durable decisions that warrant ADRs:

- **Decision 1:** Adopt semantic versioning for portfolio releases
  - **Rationale:** Clear signal for reviewers and easy to interpret change scope
  - **Alternative considered:** Date-based releases (less clear for impact)
  - **Implications:** Release notes required for Minor+ changes

---

## Dependency Graph & Sequencing

```
Step 1: Inclusion and exclusions
  -> Step 2: Versioning and lifecycle policy
    -> Step 3: Change intake and release notes
```

---

## Risk Mitigation

| Risk                        | Likelihood | Impact | Mitigation                                 |
| --------------------------- | ---------- | ------ | ------------------------------------------ |
| Criteria too restrictive    | Med        | Med    | Review with stakeholders before publishing |
| Policy drift over time      | Med        | High   | Require annual review of governance docs   |
| Broken links after archival | Low        | High   | Archive with redirects and link checks     |

---

## Communication & Coordination

### Review Gates

- **Mid-phase review:** After Step 2
  - Participants: portfolio owner, reviewer advocate
  - Artifacts: inclusion criteria, versioning policy, ADR draft

- **End-of-phase review:** After Step 3
  - Participants: portfolio owner
  - Artifacts: change intake checklist, release note, updated hubs

### Deployment Sequence

1. Merge all docs PRs to `main`
2. Deploy portfolio-docs
3. Verify production links and navigation
4. Publish release note

---

## Tooling & Scripts

**Available commands:**

```bash
# Local verification
pnpm verify                    # Full verification (format, lint, typecheck, secrets, registry, build, performance, tests)

# For portfolio-docs
pnpm build
pnpm start
```

---

## Reference Documentation

- [Roadmap - Phase 6](/docs/00-portfolio/roadmap/index.md)
- [Reviewer Guide](/docs/00-portfolio/reviewer-guide.md)
- [Evidence Audit Checklist](/docs/70-reference/evidence-audit-checklist.md)
- [ADR Index](/docs/10-architecture/adr/index.md)
- [Runbooks Index](/docs/50-operations/runbooks/index.md)

---

## Troubleshooting

### Common Issues

**Issue: Policy conflicts with existing guidance**

- **Cause:** Overlap with Phase 5 review procedures
- **Fix:** Align with reviewer guide and ensure consistent terminology

**Issue: Archival policy breaks evidence links**

- **Cause:** Removing files without redirects or index updates
- **Fix:** Add an archival index entry and verify links before merge

---

## Next Steps After Phase 6

Once Phase 6 is complete, consider:

1. **Maintenance cadence** (2-4h/quarter): scheduled review of policies and links
2. **Optional portfolio additions** (as needed): only when criteria are met
3. **Annual evidence refresh** (4-6h/year): verify core claims and update release notes

---

## Phase Completion Verification

**Completion sign-off:**

- [ ] All implementation steps complete
- [ ] All PRs merged to `main`
- [ ] All CI checks passing
- [ ] Documentation updated and published
- [ ] Release note published
- [ ] Governance links verified

**Date completed:** [YYYY-MM-DD]  
**Completed by:** [Name/Team]  
**Retrospective notes:** [Link to retrospective document or notes]

---

## Revision History

| Date       | Author | Version | Changes                     |
| ---------- | ------ | ------- | --------------------------- |
| 2026-02-05 | Team   | 1.0     | Initial Phase 6 guide draft |

---

**Document Status:** Draft  
**Last Reviewed:** 2026-02-05  
**Next Review:** As needed
