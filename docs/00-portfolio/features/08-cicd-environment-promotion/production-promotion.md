---
title: 'Feature: Production Promotion'
description: 'Required checks and deployment checks before production.'
sidebar_position: 3
tags: [portfolio, features, cicd, production]
---

## Purpose

- Feature name: Production promotion
- Why this feature exists: Ensure production deploys only after required checks pass.

## Scope

### In scope

- required GitHub checks
- Vercel deployment checks
- production domain promotion

### Out of scope

- rollback procedures
- staging validation

## Prereqs / Inputs

- required checks configured in GitHub rulesets
- Vercel deployment checks enabled

## Procedure / Content

### Feature summary

- Feature name: Production promotion
- Feature group: CI/CD and environment promotion
- Technical summary: Production deployment is gated by CI checks and deployment checks.
- Low-tech summary: Only verified builds can reach production.

### Feature in action

- Where to see it working: Merge to `main` with required checks passing.

### Confirmation Process

#### Manual

- Steps: Merge a PR to `main`, verify checks pass, confirm deployment status.
- What to look for: Required checks satisfied, Vercel marks deployment ready.
- Artifacts or reports to inspect: GitHub checks, Vercel deployment status.

#### Tests

- Unit tests: None specific.
- E2E tests: [`/portfolio-app/tests/e2e/routes.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/routes.spec.ts) (route coverage only).

### Potential behavior if broken or misconfigured

- Production deploys without required checks.
- Checks fail but deployment still proceeds.

### Long-term maintenance notes

- Keep required check names stable.
- Reconfirm deployment checks after CI changes.

### Dependencies, libraries, tools

- GitHub Actions
- Vercel

### Source code references (GitHub URLs)

- [`/portfolio-app/.github/workflows/ci.yml`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/.github/workflows/ci.yml)

### ADRs

- [`/10-architecture/adr/adr-0013-multi-environment-deployment.md`](/docs/10-architecture/adr/adr-0013-multi-environment-deployment.md)

### Runbooks

- [`/50-operations/runbooks/rbk-portfolio-deploy.md`](/docs/50-operations/runbooks/rbk-portfolio-deploy.md)
- [`/50-operations/runbooks/rbk-portfolio-rollback.md`](/docs/50-operations/runbooks/rbk-portfolio-rollback.md)

### Additional internal references

- [`/30-devops-platform/ci-cd-pipeline-overview.md`](/docs/30-devops-platform/ci-cd-pipeline-overview.md)

### External reference links

- https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches
- https://vercel.com/docs/deployments/deployment-checks

## Validation / Expected outcomes

- Production promotion only occurs after checks pass.

## Failure modes / Troubleshooting

- Checks bypassed: update rulesets and deployment checks.

## References

- None.
