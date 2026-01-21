# Stage [X].[Y]: [Stage Title] — App Implementation

**Type:** Feature / Enhancement / Implementation  
**Phase:** Phase [X] — [Phase Name]  
**Stage:** [X].[Y]  
**Linked Issue:** [Link to corresponding docs issue if applicable]  
**Duration Estimate:** [X–Y hours]  
**Assignee:** [Who is responsible]

---

## Overview

[2–3 sentence executive summary of what this stage delivers and why it matters. What problem does it solve? What capability does it enable?]

## Objectives

- [Objective 1: Specific and measurable]
- [Objective 2: Specific and measurable]
- [Objective 3: Specific and measurable]

---

## Scope

### Files to Create

1. **`path/to/file-name.ts`** — [Brief description of purpose and responsibility]
   - [Key responsibility 1]
   - [Key responsibility 2]

2. **`path/to/component.tsx`** — [Brief description]
   - [Key responsibility 1]
   - [Key responsibility 2]

3. **[Additional files as needed]**

### Files to Update

1. **`path/to/existing-file.ts`** — [What changes and why]
   - [Specific update 1]
   - [Specific update 2]

2. **`package.json`** — [What changes: scripts, dependencies, config]
   - Add dependency: `[package-name]`
   - Add/update script: `[script-name]`

3. **`tsconfig.json`** (if applicable) — [What config changes]
   - [Specific config change]

4. **[Additional files as needed]**

### Dependencies to Add

- `[package-name]` — [Brief description of why this dependency is needed]
- `@types/[package-name]` — [TypeScript types for the dependency]
- `[dev-only-package]` (dev) — [Brief description]

### Dependencies to Remove

- `[old-package]` — [Why it's no longer needed]

---

## Design & Architecture

### System Overview

[Diagram or high-level description of how this stage fits into the overall system architecture]

```
[ASCII diagram or Mermaid flowchart showing data flow, components, or architecture]
```

### Data Model / Schema (if applicable)

Define the primary data structures for this stage:

```typescript
// Example TypeScript interface or type
interface [PrimaryType] {
  field1: string;        // Purpose and constraints
  field2: number;        // Purpose and constraints
  field3?: boolean;      // Optional; purpose
}

// Example or validation schema using Zod
const schema = z.object({
  field1: z.string().min(3),
  field2: z.number().positive(),
});
```

### Key Design Decisions

1. **Decision 1:** [Brief statement of what was chosen and why]
   - Rationale: [Why this approach over alternatives]
   - Alternative considered: [What else was evaluated]

2. **Decision 2:** [Brief statement]
   - Rationale: [Why this approach]
   - Alternative considered: [What else was evaluated]

### API / Function Signatures

Document key functions or components that will be created:

```typescript
// Example: Core function signature
export function [functionName](param1: Type1, param2: Type2): ReturnType {
  // Purpose: [What this function does]
  // Params:
  //   - param1: [Description]
  //   - param2: [Description]
  // Returns: [Description]
}

// Example: React component
export function [ComponentName](props: [PropsType]): JSX.Element {
  // Purpose: [What this component renders]
  // Props: [Description of expected props]
}
```

---

## Validation Rules & Constraints

[Specific rules that must be enforced by this stage]

1. **[Rule Name]:** `[Format or constraint]`
   - Example valid: `[example-valid-input]`
   - Example invalid: `[example-invalid-input]`
   - Error handling: [What happens when violated]

2. **[Rule Name]:** [Description]
   - Enforcement: [Where/how this is checked]
   - Error message: [What user sees if violated]

3. **[Additional rules as needed]**

---

## Implementation Tasks

Break the work into concrete, sequential phases with clear deliverables.

### Phase 1: [Phase Name] ([X–Y hours])

[Description of what this phase accomplishes]

#### Tasks

- [ ] [Task 1: Specific, actionable]
  - Details: [Any important context or steps]
  - Files: `path/to/file.ts`

- [ ] [Task 2: Specific, actionable]
  - Details: [Any important context]
  - Files: `path/to/component.tsx`

- [ ] [Subtask 2a: If breaking down further]
  - Code example:
    ```typescript
    // Brief code snippet showing expected approach
    ```

- [ ] [Additional tasks]

#### Success Criteria for This Phase

- [ ] [Verifiable outcome 1]
- [ ] [Verifiable outcome 2]
- [ ] [Verifiable outcome 3]

---

### Phase 2: [Phase Name] ([X–Y hours])

[Description of what this phase accomplishes]

#### Tasks

- [ ] [Task 1: Specific, actionable]
  - Details: [Any important context]
  - Files: `path/to/file.ts`

- [ ] [Task 2: Specific, actionable]
  - Dependencies: [Does this depend on Phase 1 tasks?]

- [ ] [Additional tasks]

#### Success Criteria for This Phase

- [ ] [Verifiable outcome 1]
- [ ] [Verifiable outcome 2]

---

### Phase 3: [Additional phases as needed]

[Follow the same structure]

---

## Testing Strategy

### Unit Tests

- [ ] [Test case 1: What to test]
  - Location: `src/__tests__/[module].test.ts`
  - Coverage: [What scenarios to cover]

- [ ] [Test case 2]
  - Test for: [What behavior]
  - Edge cases: [Boundary conditions to test]

### Integration Tests

- [ ] [Integration test 1]
  - Scenario: [What system interaction to test]
  - Expected: [What should happen]

### E2E / Manual Testing

- [ ] [E2E test 1: User-facing behavior]
  - Steps: [Step-by-step reproduction]
  - Expected result: [What the user should see]

### Test Commands

```bash
# Unit tests for this stage
pnpm test -- [module-name]

# Build verification
pnpm build

# Type checking
pnpm typecheck

# Linting
pnpm lint

# Local verification (recommended before PR)
pnpm verify
```

---

## Acceptance Criteria

This stage is complete when:

- [ ] [Criterion 1: Functionality works as designed]
- [ ] [Criterion 2: All code is type-safe]
- [ ] [Criterion 3: All tests pass]
- [ ] [Criterion 4: Performance meets expectations]
- [ ] [Criterion 5: All files follow code style guidelines]
- [ ] `pnpm verify` passes (lint, format, typecheck, build all succeed)
- [ ] No TypeScript errors: `pnpm typecheck`
- [ ] No ESLint violations: `pnpm lint`
- [ ] Code is formatted: `pnpm format:check`
- [ ] All tests pass: `pnpm test`
- [ ] Production build succeeds: `pnpm build`

---

## Code Quality Standards

All code must meet:

- **TypeScript:** Strict mode enabled; no `any` types unless documented
- **Linting:** ESLint with Next.js preset; max-warnings=0
- **Formatting:** Prettier; single quotes, semicolons, 2-space indent
- **Documentation:** All functions have JSDoc comments; complex logic explained
- **Testing:** Unit tests for utilities; E2E tests for routes
- **Security:** No hardcoded secrets; environment variables for configuration

---

## Deployment & CI/CD

### CI Pipeline Integration

- [ ] Tests added to CI workflow
- [ ] Linting step added (if new rules)
- [ ] Build verification added (if new build step)
- [ ] Deployment artifacts configured (if applicable)

### Environment Variables / Configuration

[If this stage requires new environment variables or config]

```env
# Add to .env.local for local development
NEXT_PUBLIC_[VAR_NAME]=[example-value]
[PRIVATE_VAR]=[example-value]
```

Documentation: See `.env.example` for complete list.

### Rollback Plan

[If applicable: How to quickly revert this stage]

- Quick rollback: [Git revert command or branching strategy]
- Data migration rollback: [Any data concerns]
- Config rollback: [Any config concerns]

---

## Dependencies & Blocking

### Depends On

- [ ] [Issue/task that must complete first]
- [ ] [Issue/task that must complete first]

### Blocks

- [ ] [Subsequent issue/task]
- [ ] [Subsequent issue/task]

### Related Work

- Related issue: [Link to related issue]
- Related documentation: [Link to related docs]

---

## Performance & Optimization Considerations

[If performance is a concern for this stage]

- **Target metrics:** [What performance targets should be met]
- **Profiling:** [How to measure; tools to use]
- **Optimization strategies:** [Known optimizations to consider]
- **Trade-offs:** [Any performance vs. maintainability tradeoffs]

---

## Security Considerations

[Security implications of this stage]

- [ ] No secrets hardcoded
- [ ] Environment variables properly escaped
- [ ] Input validation implemented
- [ ] CORS/auth considerations addressed
- [ ] Dependency vulnerabilities checked: `npm audit`

---

## Effort Breakdown

| Phase     | Task                 | Hours    | Notes              |
| --------- | -------------------- | -------- | ------------------ |
| 1         | [Task name]          | 2–3h     | [Any constraints]  |
| 1         | [Task name]          | 1–2h     | [Any constraints]  |
| 2         | [Task name]          | 2–3h     | [Any constraints]  |
| **Total** | **[Stage complete]** | **6–8h** | **[Dependencies]** |

---

## Success Verification Checklist

Before marking this stage complete:

- [ ] All Phase 1 tasks complete
- [ ] All Phase 2 tasks complete
- [ ] All Phase 3 tasks complete (if applicable)
- [ ] All acceptance criteria met
- [ ] All tests passing
- [ ] Code review approved
- [ ] PR merged to `main`
- [ ] Documentation updated (if applicable)

---

## Troubleshooting & Known Issues

### Common Issues & Fixes

**Issue: [Error message or symptom]**

- **Cause:** [Root cause]
- **Fix:** [Step-by-step resolution]
- **Prevention:** [How to avoid in future]

**Issue: [Error message or symptom]**

- **Cause:** [Root cause]
- **Fix:** [Step-by-step resolution]

### Debugging Tips

- [Debugging technique 1 with command]
- [Debugging technique 2 with command]
- [Common gotchas and how to spot them]

---

## Documentation Requirements

By the time this stage is complete:

- [ ] Code has JSDoc comments for exported functions
- [ ] Complex logic has inline comments
- [ ] README.md updated (if user-facing change)
- [ ] CONTRIBUTING.md updated (if development workflow change)
- [ ] API documentation updated (if applicable)
- [ ] Environment variable documentation complete

---

## Notes & Assumptions

- [Assumption 1: e.g., "Assumes React 19+ available"]
- [Assumption 2: e.g., "Assumes TypeScript 5+ compiler"]
- [Design constraint: e.g., "Must work with existing component library"]
- [Risk: e.g., "Dependent on external API availability"]

---

## Related Issues

- Parent issue: [Link to Stage overview or Phase implementation guide]
- Related docs issue: [Link to STAGE-X.Y-DOCS-ISSUE if applicable]
- Blocks: [What issues does this unblock]
- Depends on: [What issues must complete first]

---

## Review Checklist (for Reviewer)

- [ ] Code achieves stated objectives
- [ ] All tests pass and coverage is adequate
- [ ] No TypeScript errors
- [ ] Code follows style guidelines
- [ ] Performance is acceptable
- [ ] Documentation is clear and complete
- [ ] No secrets or sensitive data exposed
- [ ] PR description is clear
- [ ] Commit messages follow conventions

---

## Completion Verification

- [ ] All phases complete
- [ ] All acceptance criteria met
- [ ] All tests passing: `pnpm test`
- [ ] All quality gates pass: `pnpm verify`
- [ ] Code reviewed and approved
- [ ] PR merged to `main`
- [ ] Deployment successful (if applicable)
- [ ] Production verified (if applicable)

**Date Completed:** [YYYY-MM-DD]  
**Completed By:** [Name/GitHub handle]

---

## Post-Implementation Notes

[Any learnings, gotchas, or notes for future stages]

- [Learning 1]
- [Learning 2]
- [Suggestion for improvement]

---

**Milestone:** [Phase X — Phase Name]  
**Labels:** `enhancement`, `phase-[x]`, `[stage-focus]`, `implementation`  
**Priority:** [High / Medium / Low]
