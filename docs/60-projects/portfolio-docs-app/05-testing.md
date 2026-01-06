---
title: "Portfolio Docs: Testing"
description: "Quality model for the Portfolio Docs App: build integrity, broken-link failures, lint/format gates, and reviewer-facing validation checks."
sidebar_position: 5
tags: [projects, testing, quality-gates, documentation, devops]
---

## Purpose

This page defines what “testing” means for a documentation platform and what quality gates must be satisfied to claim enterprise-level delivery discipline.

For this project, “tests” are primarily:
- deterministic build success
- link integrity
- content structure consistency
- formatting and lint discipline

## Scope

### In scope
- local validation commands and expected outcomes
- CI quality gates and what they protect
- definitions of “pass/fail” for docs changes

### Out of scope
- application unit testing (this is a docs site; tests are build/content-oriented)
- security scanning detail (covered in `security.md`)

## Prereqs / Inputs

- pnpm installed and dependencies resolvable
- Docusaurus site can start locally
- contributor follows page structure and front matter rules

## Procedure / Content

## Local validation workflow (required)

### 1) Live preview (developer feedback loop)
Run:
```bash
pnpm start
```

Use this to validate:
- navigation and sidebar structure
- category behavior (category clicks land correctly)
- rendering of admonitions, code blocks, and formatting

### 2) Production build gate (hard requirement)

Run:
```bash
pnpm build
```

This must be executed before opening a PR (and must pass in CI). The build gate protects:
- broken links
- invalid docs structure
- navigation errors that only appear at build time

## CI validation model (recommended baseline)

At minimum, CI should run:
1. `pnpm install`
2. `pnpm build`

Recommended additional checks:
- markdown lint (style and structure hygiene)
- format check (Prettier consistency)
- optional link-checker beyond Docusaurus (if you adopt external link validation later)

## What constitutes a test failure?

Examples:
- build fails due to broken internal links
- missing required front matter fields
- invalid MDX syntax (if using MDX)
- navigation inconsistencies introduced by missing _category_.json where required
- inconsistent page structure that violates governance rules (lint policies can enforce this progressively)

## Reviewer-facing validation checks

For any PR, the author should provide:
- confirmation that pnpm build passed
- a description of what navigation path reviewers should take
- any expected visual changes (if relevant)

## Validation / Expected outcomes

Quality gates are “working” when:
- contributors cannot merge content that breaks navigation or build
- reviewers can verify changes via preview/prod build outputs
- formatting and doc structure remain consistent over time

## Failure modes / Troubleshooting

- **Build failure due to broken links**: remove premature links; use path references until the target exists.
- **Lint rules become noisy**: adjust rules carefully and document governance changes as a controlled decision.
- **Formatting drift**: enforce formatting checks in CI and standardize editor settings.

## References

- Documentation style guide (internal-only): `docs/_meta/doc-style-guide.md`
- Contribution rules and PR checklists (repo root): `CONTRIBUTING.md` / `.github/PULL_REQUEST_TEMPLATE.md`
- Platform CI/CD docs: `docs/30-devops-platform/ci-cd/`