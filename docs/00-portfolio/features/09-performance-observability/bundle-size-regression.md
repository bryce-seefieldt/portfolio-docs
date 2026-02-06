---
title: 'Feature: Bundle Size Regression Detection'
description: 'CI enforcement of bundle size thresholds.'
sidebar_position: 2
tags: [portfolio, features, performance, bundle]
---

## Purpose

- Feature name: Bundle size regression detection
- Why this feature exists: Prevent unreviewed increases in JavaScript size.

## Scope

### In scope

- bundle size baseline tracking
- CI failure on threshold breach

### Out of scope

- runtime caching strategies
- health checks

## Prereqs / Inputs

- performance baseline documented
- build output available for comparison

## Procedure / Content

### Feature summary

- Feature name: Bundle size regression detection
- Feature group: Performance and observability
- Technical summary: CI compares build output against baseline and fails on threshold breaches.
- Low-tech summary: Stops the app from getting slow without notice.

### Feature in action

- Where to see it working: CI build step on PRs.

### Confirmation Process

#### Manual

- Steps: Run the build and compare bundle size to baseline.
- What to look for: CI fails when size exceeds threshold.
- Artifacts or reports to inspect: CI build logs and baseline reference.

#### Tests

- Unit tests: None specific.
- E2E tests: None.

### Potential behavior if broken or misconfigured

- Baseline missing or outdated.
- Threshold too lax or too strict.

### Long-term maintenance notes

- Update baseline after intentional performance changes.

### Dependencies, libraries, tools

- Node.js
- pnpm

### Source code references (GitHub URLs)

- [`/portfolio-app/package.json`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/package.json)

### ADRs

- None.

### Runbooks

- [`/50-operations/runbooks/rbk-portfolio-performance-optimization.md`](/docs/50-operations/runbooks/rbk-portfolio-performance-optimization.md)

### Additional internal references

- [`/70-reference/performance-optimization-guide.md`](/docs/70-reference/performance-optimization-guide.md)

### External reference links

- https://nextjs.org/docs/app/building-your-application/optimizing

## Validation / Expected outcomes

- CI fails when bundle size exceeds the threshold.

## Failure modes / Troubleshooting

- False positives: update baseline and rerun.

## References

- None.
