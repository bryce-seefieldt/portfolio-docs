---
title: 'Feature: Local Verification Workflow'
description: 'Single-command local verification for quality and tests.'
sidebar_position: 4
tags: [portfolio, features, testing, verification]
---

## Purpose

- Feature name: Local verification workflow
- Why this feature exists: Provide a repeatable local check that mirrors CI expectations.

## Scope

### In scope

- `pnpm verify` and `pnpm verify:quick`
- environment checks and registry validation

### Out of scope

- CI configuration details
- deployment validation

## Prereqs / Inputs

- pnpm installed
- repo dependencies installed

## Procedure / Content

### Feature summary

- Feature name: Local verification workflow
- Feature group: Testing and quality gates
- Technical summary: Runs a curated set of checks for linting, formatting, builds, and tests.
- Low-tech summary: A one-command local checklist to catch issues before CI.

### Feature in action

- Where to see it working: `pnpm verify` in the app repo.

### Confirmation Process

#### Manual

- Steps: Run `pnpm verify` and review output.
- What to look for: All steps pass and summary reports success.
- Artifacts or reports to inspect: Local output logs.

#### Tests

- Unit tests: See unit testing feature for coverage.
- E2E tests: See end-to-end testing feature for coverage.

### Potential behavior if broken or misconfigured

- Verification script skips steps due to missing tools.
- Local checks drift from CI checks.

### Long-term maintenance notes

- Keep `pnpm verify` aligned with CI gates.
- Update documentation when steps change.

### Dependencies, libraries, tools

- pnpm
- Node.js

### Source code references (GitHub URLs)

- [`/portfolio-app/package.json`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/package.json)

### ADRs

- None.

### Runbooks

- [`/50-operations/runbooks/rbk-portfolio-ci-triage.md`](/docs/50-operations/runbooks/rbk-portfolio-ci-triage.md)

### Additional internal references

- [`/70-reference/testing-guide.md`](/docs/70-reference/testing-guide.md)

### External reference links

- https://pnpm.io/cli/run

## Validation / Expected outcomes

- Local verification passes and mirrors CI checks.

## Failure modes / Troubleshooting

- Missing tools: reinstall dependencies and rerun.

## References

- None.
