---
title: "Feature: Preview Deployments"
description: "Automatic PR preview environments for validation."
sidebar_position: 1
tags: [portfolio, features, cicd, deployments]
---

## Purpose

- Feature name: Preview deployments
- Why this feature exists: Give reviewers a safe environment to validate changes before production.

## Scope

### In scope

- automatic preview deployments on PRs
- environment-scoped public URLs

### Out of scope

- staging promotion workflow
- production rollbacks

## Prereqs / Inputs

- Vercel connected to the repo
- GitHub Actions checks configured

## Procedure / Content

### Feature summary

- Feature name: Preview deployments
- Feature group: CI/CD and environment promotion
- Technical summary: PR branches deploy to preview environments with Vercel-managed URLs.
- Low-tech summary: Every PR gets a temporary site to review.

### Feature in action

- Where to see it working: Open any PR and review the Vercel preview URL.

### Confirmation Process

#### Manual

- Steps: Open a PR, click the preview URL, and validate core routes.
- What to look for: Preview site renders correctly and matches the PR changes.
- Artifacts or reports to inspect: Vercel deployment status and GitHub check results.

#### Tests

- Unit tests: None specific.
- E2E tests: [`/portfolio-app/tests/e2e/routes.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/routes.spec.ts) (route coverage only).

### Potential behavior if broken or misconfigured

- Preview deployments fail to build.
- Preview URL is missing or inaccessible.

### Long-term maintenance notes

- Keep preview checks aligned with CI gates.
- Validate environment variables are scoped correctly.

### Dependencies, libraries, tools

- Vercel
- GitHub Actions

### Source code references (GitHub URLs)

- [`/portfolio-app/.github/workflows/ci.yml`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/.github/workflows/ci.yml)

### ADRs

- [`/10-architecture/adr/adr-0013-multi-environment-deployment.md`](/docs/10-architecture/adr/adr-0013-multi-environment-deployment.md)

### Runbooks

- [`/50-operations/runbooks/rbk-portfolio-deploy.md`](/docs/50-operations/runbooks/rbk-portfolio-deploy.md)

### Additional internal references

- [`/30-devops-platform/ci-cd-pipeline-overview.md`](/docs/30-devops-platform/ci-cd-pipeline-overview.md)

### External reference links

- https://vercel.com/docs/deployments/preview-deployments

## Validation / Expected outcomes

- Preview deployments are available for every PR.

## Failure modes / Troubleshooting

- Missing previews: verify Vercel integration and build logs.

## References

- None.
