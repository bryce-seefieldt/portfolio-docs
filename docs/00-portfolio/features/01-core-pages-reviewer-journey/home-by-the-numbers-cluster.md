---
title: 'Feature: Home By-the-Numbers Cluster'
description: 'Module 03 banked inset instrument cluster for quantified evidence.'
sidebar_position: 8
tags: [portfolio, features, core-pages, home, instrumentation]
---

## Purpose

- Feature name: Home by-the-numbers cluster (Module 03)
- Why this feature exists: Present key career and engineering metrics in a scannable instrument-style panel.

## Scope

### In scope

- four inset banks (enterprise delivery, scale/automation, career, craft)
- readable text values for each stat
- decorative instrument wrappers (seven-segment, nixie, gauge, bar, lamps)

### Out of scope

- live data feeds
- site-wide count-up or needle animation system

## Procedure / Content

### Feature summary

- Technical summary: Server-rendered bank and stat data mapped into inset panel cards with decorative instrument classes.
- Low-tech summary: The section turns résumé metrics into a compact dashboard while keeping every value readable as text.

### Confirmation Process

#### Manual

- Steps: Open `/`, scroll to Module 03, inspect all four banks at desktop and mobile widths.
- What to look for: No overlap between labels/values, every stat readable without relying on visual gauges.

#### Tests

- E2E tests: [`/portfolio-app/tests/e2e/evidence-links.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/evidence-links.spec.ts)

### Source code references (GitHub URLs)

- [`/portfolio-app/src/components/home/ByTheNumbersCluster.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/home/ByTheNumbersCluster.tsx)
- [`/portfolio-app/src/app/globals.css`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/globals.css)
- [`/portfolio-app/src/app/page.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/page.tsx)

## References

- [`/20-engineering/design-system/index.md`](/20-engineering/design-system/index.md)
