---
title: 'Runbook: Environment Rollback'
description: 'Procedures for rolling back failed promotions and recovering from deployment issues across staging and production.'
sidebar_position: 2
tags: [runbook, deployment, rollback, incident, operations, phase-4, stage-4-1]
---

## Overview

Rollback quickly and safely when a staging or production deployment fails validation or causes incidents.

## Triggers

- Post-deploy health checks fail
- Critical regressions discovered during smoke tests
- Elevated error rates or user impact observed

## Rollback Options

1. **Git Revert (preferred; ~3–5 min)**
   - Revert the offending commit(s) on `main`
   - Push; let required checks pass
   - Promote the previous good build to production

2. **Vercel UI Rollback (~2–5 min)**
   - In Vercel, select the last known good deployment
   - Re-deploy that build to staging/production
   - Verify health checks

3. **Emergency Block + Fix (~5–15 min)**
   - Temporarily block promotion
   - Hotfix critical issues in a short-lived branch
   - Merge; re-run promotion gates; deploy

## Post-Incident

- Document the incident cause and remediation
- Add tests to prevent recurrence
- Update runbooks if steps changed

## Validation

- Previous build is serving in affected environment
- Health checks and smoke tests pass
- Error rates return to baseline

## References

- Promotion runbook: `docs/50-operations/runbooks/rbk-portfolio-environment-promotion.md`
- ADR: `docs/10-architecture/adr/adr-0013-multi-environment-deployment.md`
- CI/CD overview: `docs/30-devops-platform/ci-cd-pipeline-overview.md`
