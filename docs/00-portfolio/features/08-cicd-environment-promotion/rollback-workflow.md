---
title: 'Feature: Rollback Workflow'
description: 'Git revert based rollback for production issues.'
sidebar_position: 4
tags: [portfolio, features, cicd, rollback]
---

## Purpose

- Feature name: Rollback workflow
- Why this feature exists: Provide a fast path to restore production when issues occur.

## Scope

### In scope

- Git revert based rollback
- post-rollback validation steps

### Out of scope

- incident response communications
- staging validation

## Prereqs / Inputs

- Git history intact
- production deploys from `main`

## Procedure / Content

### Feature summary

- Feature name: Rollback workflow
- Feature group: CI/CD and environment promotion
- Technical summary: Uses git revert to roll back to a known-good commit with CI validation.
- Low-tech summary: A quick way to undo a bad release.

### Feature in action

- Where to see it working: GitHub Actions runs on a revert PR or direct revert.

### Confirmation Process

#### Manual

- Steps: Revert the offending commit and verify CI passes.
- What to look for: Deployment returns to stable state, errors resolved.
- Artifacts or reports to inspect: CI logs and deployment status.

#### Tests

- Unit tests: None specific.
- E2E tests: [`/portfolio-app/tests/e2e/routes.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/routes.spec.ts) (route coverage only).

### Potential behavior if broken or misconfigured

- Rollback does not trigger a deployment.
- Revert commit introduces new conflicts.

### Long-term maintenance notes

- Ensure rollback runbook stays current.

### Dependencies, libraries, tools

- Git
- GitHub Actions
- Vercel

### Source code references (GitHub URLs)

- [`/portfolio-app/.github/workflows/ci.yml`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/.github/workflows/ci.yml)

### ADRs

- [`/10-architecture/adr/adr-0013-multi-environment-deployment.md`](/docs/10-architecture/adr/adr-0013-multi-environment-deployment.md)

### Runbooks

- [`/50-operations/runbooks/rbk-portfolio-rollback.md`](/docs/50-operations/runbooks/rbk-portfolio-rollback.md)

### Additional internal references

- [`/30-devops-platform/ci-cd-pipeline-overview.md`](/docs/30-devops-platform/ci-cd-pipeline-overview.md)

### External reference links

- https://git-scm.com/docs/git-revert

## Validation / Expected outcomes

- Rollbacks restore a stable deployment quickly.

## Failure modes / Troubleshooting

- Revert fails: resolve conflicts and rerun CI.

## References

- None.
