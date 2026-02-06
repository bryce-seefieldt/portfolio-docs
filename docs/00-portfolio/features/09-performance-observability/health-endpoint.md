---
title: 'Feature: Health Endpoint'
description: 'Health and status endpoint for operational visibility.'
sidebar_position: 3
tags: [portfolio, features, observability, health]
---

## Purpose

- Feature name: Health endpoint
- Why this feature exists: Provide a simple signal for service health and diagnostic metadata.

## Scope

### In scope

- health endpoint response codes
- healthy, degraded, and unhealthy states

### Out of scope

- external monitoring dashboards
- alerting integrations

## Prereqs / Inputs

- health endpoint implemented in the app

## Procedure / Content

### Feature summary

- Feature name: Health endpoint
- Feature group: Performance and observability
- Technical summary: Returns structured health status with appropriate HTTP codes.
- Low-tech summary: A simple URL that says whether the site is healthy.

### Feature in action

- Where to see it working: `/api/health` in the deployed app.

### Confirmation Process

#### Manual

- Steps: Open `/api/health` and review the response body.
- What to look for: Status field and expected HTTP code.
- Artifacts or reports to inspect: None.

#### Tests

- Unit tests: [`/portfolio-app/src/lib/__tests__/observability.test.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/__tests__/observability.test.ts)
- E2E tests: [`/portfolio-app/tests/e2e/routes.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/routes.spec.ts) (health endpoint coverage).

### Potential behavior if broken or misconfigured

- Health endpoint returns incorrect status codes.
- Response body missing expected fields.

### Long-term maintenance notes

- Keep health signal aligned with operational requirements.

### Dependencies, libraries, tools

- Next.js App Router
- React

### Source code references (GitHub URLs)

- [`/portfolio-app/src/app/api/health/route.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/api/health/route.ts)

### ADRs

- None.

### Runbooks

- [`/50-operations/runbooks/rbk-portfolio-service-degradation.md`](/docs/50-operations/runbooks/rbk-portfolio-service-degradation.md)

### Additional internal references

- [`/30-devops-platform/observability-health-checks.md`](/docs/30-devops-platform/observability-health-checks.md)

### External reference links

- https://nextjs.org/docs/app/building-your-application/routing/route-handlers

## Validation / Expected outcomes

- Health endpoint returns expected status and payload.

## Failure modes / Troubleshooting

- Incorrect responses: update handler logic and rerun tests.

## References

- None.
