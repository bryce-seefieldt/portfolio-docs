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
- instrument-honesty mapping (gauge/bar only where a ratio is meaningful; glyphs for non-quantifiable achievements)
- data-driven instrument rendering (needle angle and bar fill derive from per-stat ratios)

### Out of scope

- live data feeds
- site-wide count-up or needle animation system

## Procedure / Content

### Feature summary

- Technical summary: Server-rendered bank and stat data map into inset panel cards with instrument type metadata and optional ratio fields so gauges/bars encode values while non-quantifiable career achievements render as neutral glyph instruments.
- Low-tech summary: The section reads like a compact dashboard, but only uses measuring instruments when measurement is honest.

### Confirmation Process

#### Manual

- Steps: Open `/`, scroll to Module 03, inspect all four banks at desktop and mobile widths.
- What to look for: No duplicate value strings, gauges/bars visually encode their ratios, and career items (e.g., awards/education) render as glyph instruments rather than faux measurable dials.

#### Tests

- E2E tests: [`/portfolio-app/tests/e2e/evidence-links.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/evidence-links.spec.ts)
- Unit tests: [`/portfolio-app/src/components/__tests__/ByTheNumbersCluster.test.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/__tests__/ByTheNumbersCluster.test.tsx)

### Source code references (GitHub URLs)

- [`/portfolio-app/src/components/home/ByTheNumbersCluster.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/home/ByTheNumbersCluster.tsx)
- [`/portfolio-app/src/app/globals.css`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/globals.css)
- [`/portfolio-app/src/app/page.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/page.tsx)

## References

- [`/20-engineering/design-system/index.md`](/20-engineering/design-system/index.md)
