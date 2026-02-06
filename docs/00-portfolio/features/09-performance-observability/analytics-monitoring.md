---
title: "Feature: Analytics Monitoring"
description: "Vercel Web Analytics and performance monitoring."
sidebar_position: 4
tags: [portfolio, features, observability, analytics]
---

## Purpose

- Feature name: Analytics monitoring
- Why this feature exists: Track real-world usage and performance without collecting PII.

## Scope

### In scope

- Vercel Web Analytics
- high-level Core Web Vitals monitoring

### Out of scope

- custom event tracking
- user-specific analytics

## Prereqs / Inputs

- Vercel Analytics enabled
- analytics component included in layout

## Procedure / Content

### Feature summary

- Feature name: Analytics monitoring
- Feature group: Performance and observability
- Technical summary: Uses Vercel Analytics to collect aggregate page view and performance data.
- Low-tech summary: A privacy-safe dashboard for basic traffic and performance signals.

### Feature in action

- Where to see it working: Vercel Analytics dashboard and deployed routes.

### Confirmation Process

#### Manual

- Steps: Open the analytics dashboard and confirm data appears after page views.
- What to look for: Page view counts and performance metrics.
- Artifacts or reports to inspect: Vercel Analytics dashboard.

#### Tests

- Unit tests: None specific.
- E2E tests: None.

### Potential behavior if broken or misconfigured

- Analytics data missing due to disabled component.
- Metrics unavailable due to Vercel configuration.

### Long-term maintenance notes

- Reconfirm analytics settings after layout changes.

### Dependencies, libraries, tools

- Vercel Analytics
- Next.js App Router

### Source code references (GitHub URLs)

- [`/portfolio-app/src/app/layout.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/layout.tsx)

### ADRs

- None.

### Runbooks

- None.

### Additional internal references

- [`/30-devops-platform/observability-health-checks.md`](/docs/30-devops-platform/observability-health-checks.md)

### External reference links

- https://vercel.com/docs/analytics

## Validation / Expected outcomes

- Analytics data appears for production traffic.

## Failure modes / Troubleshooting

- No data: verify analytics component and Vercel settings.

## References

- None.
