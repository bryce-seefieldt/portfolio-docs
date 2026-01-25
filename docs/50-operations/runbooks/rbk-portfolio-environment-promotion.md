---
title: 'Runbook: Environment Promotion & Validation'
description: 'Procedures for promoting code from staging to production environments with validation gates and deployment checks.'
sidebar_position: 1
tags: [runbook, deployment, promotion, operations, phase-4, stage-4-1]
---

## Overview

Promote the Portfolio App across **staging** and **production** environments using Git-triggered deployments. This runbook is designed for reliability under pressure.

## Prerequisites

- Access to Vercel project settings (no secrets published here)
- Required CI checks passing (`ci / quality`, `ci / build`, `ci / link-validation`)
- Target domains configured for staging and production
- Confirm env contract: `pnpm env:validate` passes locally

## Promote to Staging

1. Create PR targeting `staging` branch (not `main`)
2. Wait for CI checks to pass on PR
3. Merge PR to `staging` branch
4. Vercel automatically deploys to staging domain
5. Monitor deployment in Vercel dashboard
6. Validate staging:
   - Load home, CV, projects, project detail pages
   - Verify evidence links resolve correctly
   - Confirm no console errors
   - Run smoke tests: `PLAYWRIGHT_TEST_BASE_URL=https://staging-bns-portfolio.vercel.app pnpm playwright test`

## Promote to Production

1. Ensure staging validation passed completely
2. Merge `staging` branch to `main`:
   ```bash
   git checkout main
   git pull origin main
   git merge staging
   git push origin main
   ```
3. Vercel automatically deploys to production domain
4. Monitor deployment in Vercel dashboard
5. Validate production health:
   - Homepage loads and navigation works
   - Evidence links resolve
   - No 4xx/5xx errors observed
   - Run production smoke tests if available

## Validation Checklist

- Same build artifact across staging and production (commit SHA matches)
- No hardcoded environment logic present
- Env variables set correctly for each tier
- CI checks green prior to promotion

## Troubleshooting

- **Failed env validation:** Set missing `NEXT_PUBLIC_*` variables in Vercel
- **Smoke tests fail:** Investigate in preview/staging; fix before production
- **Promotion drift:** Ensure deployment uses the same commit SHA; do not rebuild per environment

## References

- ADR: `docs/10-architecture/adr/adr-0013-multi-environment-deployment.md`
- Rollback runbook: `docs/50-operations/runbooks/rbk-portfolio-environment-rollback.md`
- CI/CD pipeline overview: `docs/30-devops-platform/ci-cd-pipeline-overview.md`
