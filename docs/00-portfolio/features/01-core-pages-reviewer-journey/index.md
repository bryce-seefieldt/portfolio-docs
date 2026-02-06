---
title: 'Core Pages and Reviewer Journey'
description: 'Governance for core page features and the primary reviewer flow.'
sidebar_position: 1
tags: [portfolio, features, core-pages, reviewer-journey]
---

## Purpose

Define how core page features are documented and validated. This group covers the main reviewer flow across the landing page, CV, projects, project details, and contact pages.

## Scope

### In scope

- page-level UX and navigation expectations
- reviewer flow and evidence discovery steps
- interaction patterns that influence evaluation speed

### Out of scope

- underlying infrastructure or security controls (see other groups)

## Prereqs / Inputs

- Feature inventory is current
- Route structure matches the app implementation

## Procedure / Content

### What belongs here

- features that define the primary reviewer journey
- page content behaviors and information hierarchy
- evidence discovery and validation guidance

### Governance focus

- landing page must include a clear reviewer path and evidence callouts
- each core page must expose evidence links or explain why they are absent
- avoid navigation dead-ends in the reviewer flow

### Feature page requirements

Each feature page must include the required feature fields as defined in the Features index.

## Validation / Expected outcomes

- A reviewer can follow the intended journey without ambiguity.
- Each page has clear evidence or verification paths.

## Failure modes / Troubleshooting

- Reviewer path is unclear or buried: add callouts or navigation cues.
- Evidence links are missing: add and validate with the docs site.

## References

- Feature catalog governance: [docs/00-portfolio/features/index.md](../index.md)
