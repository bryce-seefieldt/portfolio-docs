---
title: "Feature: Staging Promotion"
description: "Manual staging validation before production promotion."
sidebar_position: 2
tags: [portfolio, features, cicd, staging]
---

## Purpose

- Feature name: Staging promotion
- Why this feature exists: Validate production-like behavior before final release.

## Scope

### In scope

- staging branch deployment
- staging validation steps

### Out of scope

- production rollback procedures
- preview deployments

## Prereqs / Inputs

- staging branch configured
- staging domain configured in Vercel

## Procedure / Content

### Feature summary

- Feature name: Staging promotion
- Feature group: CI/CD and environment promotion
- Technical summary: Changes merged to staging deploy to a production-like environment for validation.
- Low-tech summary: A safe checkpoint before production.

### Feature in action

- Where to see it working: staging domain after merging to the `staging` branch.

### Confirmation Process

#### Manual

- Steps: Merge to staging, open the staging URL, validate core routes.
- What to look for: Staging routes render correctly and evidence links resolve.
- Artifacts or reports to inspect: Staging validation notes and CI logs.

#### Tests

- Unit tests: None specific.
- E2E tests: [`/portfolio-app/tests/e2e/routes.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/routes.spec.ts) (route coverage only).

### Potential behavior if broken or misconfigured

- Staging deploy fails or points to the wrong branch.
- Validation skipped before production.

### Long-term maintenance notes

- Keep staging domain and branch in sync.
- Update validation checklist as routes evolve.

### Dependencies, libraries, tools

- Vercel
- GitHub Actions

### Source code references (GitHub URLs)

- [`/portfolio-app/.github/workflows/ci.yml`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/.github/workflows/ci.yml)

### ADRs

- [`/10-architecture/adr/adr-0013-multi-environment-deployment.md`](/docs/10-architecture/adr/adr-0013-multi-environment-deployment.md)

### Runbooks

- [`/50-operations/runbooks/rbk-portfolio-deploy.md`](/docs/50-operations/runbooks/rbk-portfolio-deploy.md)
- [`/50-operations/runbooks/rbk-portfolio-environment-promotion.md`](/docs/50-operations/runbooks/rbk-portfolio-environment-promotion.md)

### Additional internal references

- [`/30-devops-platform/ci-cd-pipeline-overview.md`](/docs/30-devops-platform/ci-cd-pipeline-overview.md)

### External reference links

- https://vercel.com/docs/deployments/overview

## Validation / Expected outcomes

- Staging is validated before production promotion.

## Failure modes / Troubleshooting

- Staging drift: re-sync staging branch and redeploy.

## References

- None.
