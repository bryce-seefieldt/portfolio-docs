---
title: "Feature: CI Quality Gates"
description: "Lint, format, typecheck, and audit gates enforced in CI."
sidebar_position: 1
tags: [portfolio, features, testing, quality]
---

## Purpose

- Feature name: CI quality gates
- Why this feature exists: Block merges that violate formatting, linting, or type safety standards.

## Scope

### In scope

- lint, format, and typecheck gates
- audit policy for high/critical vulnerabilities
- required checks naming stability

### Out of scope

- unit and E2E test execution (covered in separate features)
- deployment checks and promotion

## Prereqs / Inputs

- CI workflow configured for quality checks
- pnpm scripts for lint, format, and typecheck

## Procedure / Content

### Feature summary

- Feature name: CI quality gates
- Feature group: Testing and quality gates
- Technical summary: Enforces linting, formatting, typechecking, and audit policy on every PR.
- Low-tech summary: Prevents low-quality changes from merging.

### Feature in action

- Where to see it working: GitHub Actions checks on PRs and main.

### Confirmation Process

#### Manual

- Steps: Run `pnpm lint`, `pnpm format:check`, and `pnpm typecheck` locally.
- What to look for: Commands exit successfully with zero warnings.
- Artifacts or reports to inspect: CI job logs in GitHub Actions.

#### Tests

- Unit tests: None specific.
- E2E tests: None specific.

### Potential behavior if broken or misconfigured

- Checks not required due to renamed jobs.
- Lint or format drift allowed into main.

### Long-term maintenance notes

- Keep check names stable to avoid ruleset drift.
- Update documentation when scripts change.

### Dependencies, libraries, tools

- ESLint
- Prettier
- TypeScript
- pnpm

### Source code references (GitHub URLs)

- [`/portfolio-app/.github/workflows/ci.yml`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/.github/workflows/ci.yml)
- [`/portfolio-app/eslint.config.mjs`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/eslint.config.mjs)
- [`/portfolio-app/prettier.config.mjs`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/prettier.config.mjs)
- [`/portfolio-app/tsconfig.json`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tsconfig.json)

### ADRs

- None.

### Runbooks

- [`/50-operations/runbooks/rbk-portfolio-ci-triage.md`](/docs/50-operations/runbooks/rbk-portfolio-ci-triage.md)

### Additional internal references

- [`/70-reference/testing-guide.md`](/docs/70-reference/testing-guide.md)
- [`/30-devops-platform/ci-cd-pipeline-overview.md`](/docs/30-devops-platform/ci-cd-pipeline-overview.md)

### External reference links

- https://eslint.org/docs/latest/
- https://prettier.io/docs/en/
- https://www.typescriptlang.org/docs/

## Validation / Expected outcomes

- Quality checks run on every PR and block merge on failure.

## Failure modes / Troubleshooting

- Check name drift: update rulesets and documentation.
- Local failures: fix lint/format/type errors and re-run.

## References

- None.
