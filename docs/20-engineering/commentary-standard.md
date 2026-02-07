---
title: 'Self-Documenting Code Commentary Guide'
description: 'Deep dive guidance for writing, reviewing, and maintaining high-value code commentary.'
sidebar_position: 3
tags: [engineering, standards, commentary, documentation, portfolio-app]
---

## Purpose

Help engineers write code comments that explain intent, constraints, and risk without repeating what the code already says. This guide also defines how reviewers evaluate commentary quality and how teams prevent comment drift.

## Core principles (non-negotiable)

1. Explain why, not what. Code already shows what happens; comments must capture rationale, constraints, and tradeoffs.
2. Document invariants and contracts. Preconditions, postconditions, assumptions, and expected failure modes.
3. Make risk visible. Security boundaries, trust assumptions, data classification, and safe defaults must be explicit.
4. Keep comments actionable. A good comment helps a future change decision (what cannot change, what to verify, where to look).
5. Prefer local clarity over narrative. Long explanations belong in ADRs or docs; code comments should be concise pointers.

## Anti-goals

- Do not narrate syntax or restate obvious code behavior.
- Do not embed long essays in source files.
- Do not add comment blocks that will drift without maintenance.
- Do not use comments to justify technical debt without a plan.

## Comment taxonomy (standard tags)

Use consistent tags so comments are scannable in reviews and diffs.

- RATIONALE: why this is implemented this way
- ASSUMPTION: what must remain true for correctness
- SECURITY: trust boundary, validation, authn/authz, secrets handling
- PERF: caching, memoization, rendering strategy, size tradeoffs
- A11Y: keyboard, ARIA, contrast, reduced motion
- FAILURE MODE: how errors surface, what breaks, how to detect
- OPS: logging, metrics, runtime expectations, deploy constraints

Recommended format:

```ts
// RATIONALE: ...
// ASSUMPTION: ...
// SECURITY: ...
// PERF: ...
// A11Y: ...
// FAILURE MODE: ...
// OPS: ...
```

## Where comments belong

### 1) Decision boundaries

Comment when a developer could reasonably ask:

- Why is it done this way?
- What must remain true?
- What breaks if I change this?
- Is there a security or compliance implication?
- Is there a performance tradeoff?

### 2) Input boundaries and trust transitions

If data crosses a trust boundary, comment the validation expectation and failure mode.

```ts
// SECURITY: `slug` originates from a route param (untrusted). Validate/normalize before use.
```

### 3) Cross-cutting constraints

When a decision affects multiple files, capture the big why in docs and link in code.

```ts
// RATIONALE: Constrained by ADR-0008 (CI check naming stability).
// See: /docs/10-architecture/adr/adr-0008-portfolio-app-ci-quality-gates.md
```

### 4) Non-obvious language features

If advanced type tricks, complex generics, or unusual patterns are used, add intent.

```ts
// RATIONALE: Branded type prevents mixing user-provided strings with validated IDs.
type ProjectSlug = string & { readonly __brand: 'ProjectSlug' };
```

## How to write high-value comments

### Keep them short and specific

Target one to three short lines. If a comment becomes a paragraph, move it to docs and leave a link.

### Make it testable

Prefer commentary that suggests validation:

```ts
// FAILURE MODE: If this cache key changes, metadata can become inconsistent across routes.
// Validate: run pnpm build and confirm canonical URLs remain stable.
```

### Use the language of risk and constraints

- Must for invariants
- Avoid for hazards
- Assume for environmental conditions

### Tie commentary to user intent

UI and UX commentary should describe the user goal, not the component mechanics.

```tsx
// RATIONALE: Collapsed by default to keep the landing page scannable for recruiters.
// A11Y: Toggle must remain keyboard accessible and announce expanded state.
```

## Comment density guidelines

- Low complexity: no comments
- Medium complexity: 1-3 short comments
- High complexity: short local comments + link to ADR or doc

If a file has more than 15-20 lines of commentary, refactor or move narrative to docs.

## File-type specific guidance

### TypeScript (.ts)

Use TSDoc/JSDoc for exported APIs and shared utilities.

Minimum for public APIs:

- one-line summary
- non-obvious parameter/return semantics
- invariants/constraints
- failure modes
- references (if architectural)

```ts
/**
 * Resolves the public base URL used for canonical links and metadata.
 *
 * RATIONALE: Compute this once to keep metadata consistent across runtime contexts
 * (local dev, preview, production) and to avoid relying on request headers.
 *
 * SECURITY: Must not trust unvalidated headers (host / x-forwarded-host) for canonical URL.
 * FAILURE MODE: Incorrect base URL can break SEO and future OIDC callback URLs.
 */
export function getPublicBaseUrl(): string {
  // ...
}
```

### React / Next.js (.tsx)

#### Client vs server components

If a file is a client component, comment why:

```tsx
'use client';
// RATIONALE: Client component required for interactive state + event handlers.
// PERF: Keep client surface minimal; pass serialized props from server when possible.
```

#### Data fetching and caching

Comment the caching strategy and why it is chosen:

```tsx
// PERF: This route is static by default; content changes are deployed via CI.
// If we add a CMS later, adopt revalidate + cache tags.
```

#### Accessibility

Custom interaction patterns must include A11Y notes.

```tsx
// A11Y: Ensure focus is trapped while modal is open; restore focus on close.
```

### CSS / Tailwind

Prefer comments that explain token usage, theming constraints, or reduced-motion support.

```css
/* RATIONALE: Tokens remain centralized to prevent theme drift between app + docs. */
/* A11Y: Respect prefers-reduced-motion for animations/transitions. */
@media (prefers-reduced-motion: reduce) {
  .animated {
    transition: none;
    animation: none;
  }
}
```

### Tests (unit)

Tests are commentary. Make test titles behavioral. Comment only for regressions or non-obvious setup.

```ts
// REGRESSION: This failed when registry interpolation removed trailing slashes.
it('guards against invalid project slugs', () => {
  // Arrange / Act / Assert
});
```

### E2E tests

E2E should read like acceptance criteria; include triage breadcrumbs for flaky flows.

```ts
// RATIONALE: Validates the recruiter path remains functional after layout changes.
// ASSUMPTION: Base URL is set via PLAYWRIGHT_BASE_URL or defaults to localhost.
// FAILURE MODE: Broken nav links are a high-severity regression.
// OPS: If this fails in CI only, capture trace + screenshot; confirm preview readiness.
```

### YAML workflows

Comment the workflow purpose and non-obvious flags.

```yaml
# PURPOSE: CI quality gates for lint/typecheck/tests to protect main and staging.
# RATIONALE: Check names must remain stable because rulesets and deployment checks reference them.

jobs:
  quality:
    name: ci / quality
    steps:
      # RATIONALE: --frozen-lockfile ensures deterministic installs.
      - run: pnpm install --frozen-lockfile
```

### JSON

JSON does not support comments. Document behavior in adjacent README.md or use jsonc if supported.

## Review checklist (comment quality)

Reviewers should ask:

- Does commentary explain why or just restate the code?
- Are security and trust boundaries called out?
- Are there invariants and failure modes for risky logic?
- Are links to ADRs/docs provided for cross-cutting decisions?
- Will the comment still be true after a refactor?

Reject changes when:

- a non-obvious decision has no rationale comment
- a security-sensitive boundary is unannotated
- tests are unclear about behavior
- comments are so long they belong in docs

## Maintenance and drift prevention

1. Update comments in the same PR as code changes. If a comment can be wrong, it must be touched.
2. Prefer small, local comments. Narrative belongs in ADRs or docs.
3. Treat comments as code. If you would fix a bug, you should fix a stale comment.
4. Use links for durability. If you cannot explain it in two lines, link to the decision record.

## Validation / expected outcomes

This standard is successful when:

- reviewers can identify rationale and constraints without reading commit history
- code reviews surface fewer why questions
- security and performance boundaries are explicit and auditable
- commentary remains short, current, and tied to concrete decisions

## References

- Engineering standards: `/docs/20-engineering/index.md`
- Commentary examples appendix: `/docs/70-reference/commentary-examples.md`
- Architecture decisions: `/docs/10-architecture/adr/index.md`
- Security posture: `/docs/40-security/index.md`
- Testing strategy: `/docs/60-projects/portfolio-app/05-testing.md`
- CI/CD governance: `/docs/30-devops-platform/ci-cd-pipeline-overview.md`
