---
title: 'Portfolio Docs: Testing'
description: 'Quality model for the Portfolio Docs App: build integrity, broken-link failures, lint/format gates, and reviewer-facing validation checks.'
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

## Quality gate framework (CI + Local)

The Portfolio Docs App enforces a comprehensive quality gate framework that ensures enterprise-level delivery discipline through automated checks. All checks must pass before merging to `main` and before production deployment.

### Quality gates overview

| Gate          | Command             | What it validates                                 | When it runs   |
| ------------- | ------------------- | ------------------------------------------------- | -------------- |
| **Lint**      | `pnpm lint`         | Code quality, TypeScript/React best practices     | PR + main (CI) |
| **Typecheck** | `pnpm typecheck`    | TypeScript type safety in config and components   | PR + main (CI) |
| **Format**    | `pnpm format:check` | Code style consistency (Prettier)                 | PR + main (CI) |
| **Build**     | `pnpm build`        | Documentation integrity, broken links, navigation | PR + main (CI) |

All gates are enforced via GitHub Actions and must pass before:

1. PR approval (quality + build jobs)
2. Production promotion via Vercel Deployment Checks

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

### 2) Quality checks (before opening PR)

Run all quality gates locally:

```bash
pnpm lint          # ESLint: code quality
pnpm typecheck     # TypeScript: type safety
pnpm format:check  # Prettier: code style
```

If formatting issues are found:

```bash
pnpm format:write  # Auto-fix formatting
```

If lint issues are found:

```bash
pnpm lint:fix      # Auto-fix linting (where possible)
```

### 3) Production build gate (hard requirement)

Run:

```bash
pnpm build
```

This must be executed before opening a PR (and must pass in CI). The build gate protects:

- broken links
- invalid docs structure
- navigation errors that only appear at build time

## CI validation model (GitHub Actions)

The CI workflow (`.github/workflows/ci.yml`) runs two jobs on every PR and push to `main`:

### Job 1: `quality` (fast fail)

Runs in parallel, typically completes in < 2 minutes:

1. `pnpm install --frozen-lockfile`
2. `pnpm lint` (ESLint)
3. `pnpm typecheck` (TypeScript)
4. `pnpm format:check` (Prettier)

**Purpose:** Catch code quality issues early before expensive build operations.

### Job 2: `build` (hard integrity gate)

Runs independently, typically completes in < 5 minutes:

1. `pnpm install --frozen-lockfile`
2. `pnpm build` (Docusaurus build with broken link detection)

**Purpose:** Ensure documentation builds successfully and all links are valid.

Both jobs must pass for:

- PR merge approval
- Vercel production promotion (via Deployment Checks)

See ADR-0004 for rationale and governance details.

## Vercel Deployment Checks integration

Vercel is configured to require the following GitHub checks before promoting a deployment to production:

- `ci / quality`
- `ci / build`

This ensures that production deployments are only promoted when all quality gates pass.

See [Deployment](./03-deployment.md) for Vercel Deployment Checks configuration details.

## What constitutes a test failure?

Examples:

- **Lint failure**: Code violates ESLint rules (unused variables, incorrect React patterns, TypeScript issues)
- **Typecheck failure**: TypeScript compilation errors in config or components
- **Format failure**: Code doesn't match Prettier style (inconsistent spacing, quotes, line breaks)
- **Build failure**: Broken internal links, missing required front matter, invalid MDX syntax
- **Navigation failure**: Missing `_category_.json` or invalid category metadata
- **Structure failure**: Pages violate governance rules (standard page shape, front matter requirements)

## Tooling configuration

### ESLint configuration

Location: `eslint.config.mjs` (flat config format)

Enforces:

- TypeScript best practices
- React and React Hooks rules
- No console.log in production code (warnings)
- Unused variable detection

### Prettier configuration

Location: `.prettierrc.json`

Standards:

- Single quotes
- Semicolons required
- 2-space indentation
- 80-character line width
- LF line endings

### TypeScript configuration

Location: `tsconfig.json`

Extends: `@docusaurus/tsconfig`

Purpose: Type checking for config files and React components (not used for build compilation)

## Reviewer-facing validation checks

For any PR, the author should provide:

- confirmation that all quality gates passed (`pnpm lint && pnpm typecheck && pnpm format:check && pnpm build`)
- a description of what navigation path reviewers should take
- any expected visual changes (if relevant)
- evidence that CI checks passed (GitHub Actions status)

## Validation / Expected outcomes

Quality gates are “working” when:

- contributors cannot merge content that breaks navigation or build
- reviewers can verify changes via preview/prod build outputs
- formatting and doc structure remain consistent over time

## Failure modes / Troubleshooting

- **Lint failure**: Run `pnpm lint:fix` to auto-fix where possible; review ESLint errors and update code to comply
- **Typecheck failure**: Review TypeScript errors; update types or use `@ts-expect-error` with justification for edge cases
- **Format failure**: Run `pnpm format:write` to auto-format all files; commit the changes
- **Build failure due to broken links**: Remove premature links; use path references until the target exists; see [Broken Links Triage runbook](/docs/operations/runbooks/rbk-docs-broken-links-triage)
- **Lint rules become noisy**: Adjust rules carefully in `eslint.config.mjs` and document governance changes as a controlled decision (consider ADR if major change)
- **Formatting drift**: Enforce formatting checks in CI (already configured); ensure contributors run `pnpm format:write` before committing

## References

- ADR-0004: Expand CI and Deployment Quality Gates: [adr-0004-expand-ci-deploy-quality-gates.md](/docs/architecture/adr/adr-0004-expand-ci-deploy-quality-gates)
- Documentation style guide (internal-only): `docs/_meta/doc-style-guide.md`
- Contribution rules and PR checklists (repo root): `CONTRIBUTING.md` / `.github/PULL_REQUEST_TEMPLATE.md`
- Deployment model: [03-deployment.md](./03-deployment.md)
- Operations runbooks: [rbk-docs-deploy.md](/docs/operations/runbooks/rbk-docs-deploy)
