---
title: 'Feature: Home Career Highlights Era Cards'
description: 'Module 04 channel-strip era cards summarizing four career movements.'
sidebar_position: 9
tags: [portfolio, features, core-pages, home]
---

## Purpose

- Feature name: Home career highlights era cards (Module 04)
- Why this feature exists: Make long-form career history scannable without collapsing to a generic timeline.

## Scope

### In scope

- four era cards (music/entertainment, enterprise publishing, pivot, enterprise IT/practice)
- responsive grid/stack behavior
- semantic card headings and list content

### Out of scope

- full biography narrative copy (Module 01)
- CV route detailed chronology

## Procedure / Content

### Feature summary

- Technical summary: Data-driven era card list rendered into raised panel cards with label tags and decorative indicator accents.
- Low-tech summary: Four cards summarize the long story at a glance and lead reviewers into CV/project detail pages.

### Confirmation Process

#### Manual

- Steps: Open `/`, review Module 04 at desktop and mobile widths.
- What to look for: Four cards remain readable, card text wraps cleanly, and no decorative element obscures content.

#### Tests

- Unit tests: [`/portfolio-app/src/app/__tests__/page.test.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/__tests__/page.test.tsx)

### Source code references (GitHub URLs)

- [`/portfolio-app/src/components/home/CareerEraCards.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/components/home/CareerEraCards.tsx)
- [`/portfolio-app/src/app/globals.css`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/globals.css)
- [`/portfolio-app/src/app/page.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/page.tsx)

## References

- [`/20-engineering/design-system/index.md`](/20-engineering/design-system/index.md)
