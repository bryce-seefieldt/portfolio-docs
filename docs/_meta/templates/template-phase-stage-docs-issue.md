# Stage [X].[Y]: [Stage Title] — Documentation

**Type:** Documentation / ADR / Reference  
**Phase:** Phase [X] — [Phase Name]  
**Stage:** [X].[Y]  
**Linked Issue:** [Link to corresponding app implementation issue if applicable]  
**Duration Estimate:** [X–Y hours]  
**Assignee:** [Who is responsible]

---

## Overview

[2–3 sentence executive summary of what documentation/analysis this stage produces and why it matters. What architectural or operational context does it provide? What decisions does it record?]

## Objectives

- [Objective 1: Specific documentation deliverable]
- [Objective 2: Specific decision or guide to be recorded]
- [Objective 3: Specific audience benefit]

---

## Scope

### Files to Create

1. **`docs/[domain]/[filename].md`** — [Brief description of purpose and audience]
   - Type: [ADR | Runbook | Reference Guide | Threat Model | etc.]
   - Audience: [Who will use this: engineers, operators, reviewers, etc.]
   - Purpose: [What question does it answer or what decision does it document]

2. **`docs/[domain]/[another-file].md`** — [Brief description]
   - Type: [Document type]
   - Purpose: [What it documents]

3. **[Additional files as needed]**

### Files to Update

1. **`docs/60-projects/[project]/[dossier-page].md`** — [What changes and why]
   - Update section: [Which section is updated]
   - Reason: [Why this update is needed]

2. **`docs/_meta/templates/README.md`** (if creating new template) — [What template guidance is added]
   - Add guidance for: [What new template or pattern]

3. **`.github/copilot-instructions.md`** — [What instruction updates]
   - Add pattern for: [What development pattern to document]
   - Update guidance on: [What existing guidance to clarify]

4. **[Additional files as needed]**

---

## Content Structure & Design

### Document Type & Template

**Type:** [ADR | Runbook | Reference Guide | Threat Model | Release Notes | etc.]

**Template:** [If using an existing template from `docs/_meta/templates/`, reference it here]

**Front Matter:**

```yaml
---
title: '[Document Title]'
description: '[1–2 sentence summary]'
sidebar_position: [number]
tags: [tag1, tag2, tag3]
---
```

### Content Outline

[Detailed outline of the document structure and key sections]

#### Section 1: [Section Title]

**Purpose:** [What does this section accomplish]

**Key topics to cover:**

- [Topic 1]
- [Topic 2]
- [Topic 3]

**Examples to include:**

- [Example 1 with description]
- [Example 2 with description]

#### Section 2: [Section Title]

[Repeat for each major section]

### Code Examples & Diagrams

[List any code examples, diagrams, or visual content to include]

- Example 1: [Brief description and location where it appears]

  ```[language]
  [code snippet]
  ```

- Example 2: [Brief description]

  ```[language]
  [code snippet]
  ```

- Diagram 1: [Description of diagram to create]
  ```mermaid
  graph TD
    A --> B
  ```

---

## Decision Documentation (if ADR)

### Problem Statement

[What problem or decision prompted this ADR?]

- **Current state:** [How things work today]
- **Pain points:** [What problems or constraints exist]
- **Trigger:** [What event/decision motivated this ADR]

### Decision

[What is being decided?]

[Clear, concise statement of the decision made]

### Rationale

[Why this decision?]

1. **Why this approach over alternatives:**
   - [Reason 1]
   - [Reason 2]

2. **Alignment with existing decisions:**
   - Supports: [Related ADR or principle]
   - Consistent with: [Related architecture decision]

3. **Risk mitigation:**
   - [Risk 1 and how it's mitigated]
   - [Risk 2 and how it's mitigated]

### Consequences

**Positive consequences (enablers):**

- [What becomes possible]
- [What improves]
- [What is simplified]

**Negative consequences (tradeoffs):**

- [What is constrained]
- [What is made more complex]
- [What effort is required]
- [Mitigation strategy for each]

### Alternatives Considered

1. **Alternative A: [Name/Description]**
   - Pros: [Advantages]
   - Cons: [Disadvantages]
   - Why rejected: [Why not chosen]

2. **Alternative B: [Name/Description]**
   - Pros: [Advantages]
   - Cons: [Disadvantages]
   - Why rejected: [Why not chosen]

### Implementation & Integration

- **Related to:** [ADR, runbook, or component that implements this]
- **Integrated into:** [Which systems/processes use this decision]
- **Documentation:** [Where detailed implementation docs are]

### Success Criteria

[How will we know if this decision was right?]

- [ ] [Measurable success criterion 1]
- [ ] [Measurable success criterion 2]
- [ ] [Measurable success criterion 3]

---

## Reference Material Documentation (if Guide/Reference)

### Purpose & Audience

- **Audience:** [Who should read this]
- **Prerequisite knowledge:** [What readers should already know]
- **Use case:** [When would someone use this guide]

### Key Concepts

[Definitions and explanations of core concepts]

1. **Concept 1:** [Definition and explanation]
2. **Concept 2:** [Definition and explanation]

### Complete Reference

[Comprehensive reference material in a clear format]

- **Feature/Property 1:** [Description, constraints, examples]
- **Feature/Property 2:** [Description, constraints, examples]
- **Configuration Option 1:** [Valid values, defaults, examples]
- **Configuration Option 2:** [Valid values, defaults, examples]

### Usage Examples

[Practical examples showing how to use the concept/guide]

**Example 1: [Simple case]**

```
[Code or configuration example]
```

**Example 2: [Common case]**

```
[Code or configuration example]
```

**Example 3: [Advanced case]**

```
[Code or configuration example]
```

### Best Practices

- [Practice 1: Brief description]
- [Practice 2: Brief description]
- [Common pitfall and how to avoid it]

### Troubleshooting

**Issue: [Common problem]**

- **Cause:** [Root cause]
- **Solution:** [Step-by-step fix]

---

## Operational Documentation (if Runbook)

### Purpose

[What operation does this runbook document]

### Audience

[Who should perform this operation]

### Prerequisites / Setup

- [Prerequisite 1]
- [Tool/access requirement 1]
- [Environment requirement 1]

### Step-by-Step Procedure

1. **Step 1: [Action title]**
   - Detailed action: [What to do]
   - Command: `[command to run]`
   - Expected result: [What should happen]
   - Failure scenario: [If this goes wrong, ...]

2. **Step 2: [Action title]**
   - [Follow same format]

3. **[Additional steps]**

### Validation / Expected Outcomes

[How to verify the operation succeeded]

- [ ] [Check 1: What to verify]
- [ ] [Check 2: What to verify]
- [ ] [Check 3: What to verify]

### Rollback Procedure (if applicable)

[How to undo this operation if needed]

1. **Rollback Step 1:** [How to reverse the operation]
2. **Rollback Step 2:** [Next step in reversal]

### Troubleshooting

[Common issues and how to resolve them]

---

## Integration with Existing Docs

### Cross-References

- **Links to:** [Other docs that reference this new doc]
- **Referenced by:** [Other docs that this new doc references]
- **Update required in:** [Docs that need links added]

### Updates to Existing Pages

1. **Page: `docs/[path]/existing-page.md`**
   - Update section: [Which section]
   - Add link to: [New documentation]
   - Reason: [Why this link is added]

2. **Page: [Another existing page]**
   - [Similar format]

---

## Implementation Tasks

Break the work into concrete, sequential phases.

### Phase 1: [Phase Name] ([X–Y hours])

[Description of what this phase accomplishes]

#### Tasks

- [ ] [Task 1: Research or content gathering]
  - Details: [Any important context]
  - Sources: [Where to get information]

- [ ] [Task 2: Draft content]
  - File: `docs/[path]/[filename].md`
  - Outline complete: [Sections identified]

- [ ] [Task 3: Add examples/diagrams]
  - [Code examples created]
  - [Diagrams sketched or created]

- [ ] [Task 4: Initial review]
  - Self-review completed
  - Checked against template
  - Links verified (don't need to be live yet)

#### Success Criteria for This Phase

- [ ] Outline complete and approved
- [ ] Initial draft written
- [ ] Examples/diagrams identified or created
- [ ] Internal consistency checked

---

### Phase 2: [Phase Name] ([X–Y hours])

[Description of what this phase accomplishes]

#### Tasks

- [ ] [Task 1: Build verification]
  - File: [Which file to build/test]
  - Command: `pnpm build` in `portfolio-docs`
  - Result: [No broken links, no build errors]

- [ ] [Task 2: Cross-reference validation]
  - Check: [All links mentioned actually exist or are valid]
  - Fix: [Update links if docs referenced don't exist yet]

- [ ] [Task 3: Content review]
  - Technical accuracy: [Verify against actual implementation]
  - Style consistency: [Matches existing docs style]
  - Clarity: [Easy for target audience to understand]

- [ ] [Task 4: Update related docs]
  - Files updated: [List files that need links added]
  - Links added: [Verify bidirectional linking]

#### Success Criteria for This Phase

- [ ] Document builds without errors
- [ ] All links are valid or properly annotated
- [ ] Related docs updated with cross-references
- [ ] Content reviewed for accuracy and clarity

---

### Phase 3: [Additional phases as needed]

[Follow same structure]

---

## Acceptance Criteria

This stage is complete when:

- [ ] [Criterion 1: Content is complete and accurate]
- [ ] [Criterion 2: Follows established template/style guide]
- [ ] [Criterion 3: All sections have content (no TODOs)]
- [ ] [Criterion 4: Examples are clear and correct]
- [ ] [Criterion 5: Links are bidirectional and working]
- [ ] Document builds cleanly: `pnpm build` (no broken links)
- [ ] Front matter is complete (title, description, tags, sidebar_position)
- [ ] No placeholder text or "TBD" items (unless tracked as future work)
- [ ] Code examples are syntax-highlighted and runnable (where applicable)
- [ ] Related docs have been updated with cross-references
- [ ] Technical accuracy verified against implementation
- [ ] Content reviewed for clarity by target audience
- [ ] PR approved by reviewer

---

## Definition of Done

All documents are complete when:

- ✅ **Content Complete:** No TODOs or placeholders (unless explicitly tracked)
- ✅ **Accurate:** Verified against actual implementation/decision
- ✅ **Well-Structured:** Follows template; clear sections
- ✅ **Examples Included:** Code examples or diagrams as appropriate
- ✅ **Links Working:** All internal links resolve in build
- ✅ **Bidirectional:** Related docs link back to this content
- ✅ **Style Consistent:** Matches portfolio docs style guide
- ✅ **Front Matter Complete:** Title, description, tags, positioning
- ✅ **No Secrets:** No tokens, keys, or sensitive data
- ✅ **Build Verified:** `pnpm build` passes with 0 broken links
- ✅ **Reviewed:** Approved by technical reviewer
- ✅ **Merged:** PR merged to `main`

---

## Content Quality Standards

All documentation must meet:

- **Clarity:** Target audience can understand the content
- **Accuracy:** Content matches actual implementation/decision
- **Completeness:** All sections filled; no TODOs
- **Consistency:** Follows style guide; formatting is consistent
- **Maintainability:** Easy to update as implementation changes
- **Linkage:** Well-linked to related docs; bidirectional
- **Searchability:** Proper tags and keywords for discovery
- **Examples:** Practical, working examples where appropriate

---

## Coordination with Implementation

### Depends On

- [ ] [Implementation issue that provides context]
- [ ] [Other documentation that must exist first]

### Coordination

- **Created in parallel with:** [App/docs implementation issue]
- **Finalized after:** [Implementation is complete and verified]
- **Published with:** [Which PR or release]

### Synchronization

[How to keep docs in sync with implementation]

- [ ] Documentation reviewed after implementation complete
- [ ] Links to implementation are verified
- [ ] Examples match actual code
- [ ] ADRs reviewed by implementation owner

---

## Documentation Review Checklist

Before marking complete:

- [ ] Title and description are clear
- [ ] Front matter is complete
- [ ] All sections have content (no TODOs)
- [ ] Examples are accurate and clear
- [ ] Code examples are properly formatted
- [ ] Internal links are valid and bidirectional
- [ ] Style matches existing documentation
- [ ] Technical accuracy verified
- [ ] No secrets or sensitive data
- [ ] Build succeeds: `pnpm build`
- [ ] No broken links detected

---

## Effort Breakdown

| Phase     | Task                 | Hours    | Notes              |
| --------- | -------------------- | -------- | ------------------ |
| 1         | [Task name]          | 1–2h     | [Any constraints]  |
| 1         | [Task name]          | 1–2h     | [Any constraints]  |
| 2         | [Task name]          | 1–2h     | [Any constraints]  |
| 2         | [Task name]          | 1h       | [Any constraints]  |
| **Total** | **[Stage complete]** | **4–7h** | **[Dependencies]** |

---

## References & Templates

- **Template:** [Link to template used: ADR, Runbook, etc.]
- **Style Guide:** `docs/_meta/doc-style-guide.md`
- **Taxonomy:** `docs/_meta/taxonomy-and-tagging.md`
- **Related ADRs:** [Links to relevant existing ADRs]
- **Related Docs:** [Links to related documentation]

---

## Notes & Assumptions

- [Assumption 1: e.g., "Assumes reader has domain knowledge of X"]
- [Constraint 1: e.g., "Must remain public-safe for portfolio site"]
- [Design decision: e.g., "Prioritizes clarity over technical depth"]
- [Future work: e.g., "More detailed examples may be added in Phase X"]

---

## Related Issues

- Parent issue: [Link to Stage overview or Phase implementation guide]
- Related app issue: [Link to STAGE-X.Y-APP-ISSUE if applicable]
- Blocks: [What issues does this unblock]
- Depends on: [What issues must complete first]
- See also: [Other related issues or documentation]

---

## Review Checklist (for Reviewer)

- [ ] Content is technically accurate
- [ ] Content is clear for target audience
- [ ] All sections are complete (no TODOs)
- [ ] Examples are correct and helpful
- [ ] Links are valid and bidirectional
- [ ] Style matches existing documentation
- [ ] No secrets or sensitive data
- [ ] Front matter is complete
- [ ] Build verification passed
- [ ] PR description is clear

---

## Completion Verification

- [ ] All phases complete
- [ ] All acceptance criteria met
- [ ] All tasks checked off
- [ ] Content reviewed and approved
- [ ] Links verified in build: `pnpm build`
- [ ] Related docs updated
- [ ] PR merged to `main`

**Date Completed:** [YYYY-MM-DD]  
**Completed By:** [Name/GitHub handle]  
**Reviewed By:** [Reviewer name/GitHub handle]

---

## Post-Implementation Notes

[Any learnings or suggestions for future documentation phases]

- [Learning 1]
- [Learning 2]
- [Suggestion for improvement]

---

**Milestone:** [Phase X — Phase Name]  
**Labels:** `documentation`, `phase-[x]`, `[content-type]`, `[domain-tag]`  
**Priority:** [High / Medium / Low]
