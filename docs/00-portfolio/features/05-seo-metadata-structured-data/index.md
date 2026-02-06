---
title: 'SEO, Metadata, and Structured Data'
description: 'Governance for SEO, social metadata, and structured data features.'
sidebar_position: 5
tags: [portfolio, features, seo, metadata]
---

## Purpose

Define how SEO and metadata features are documented and validated.

## Scope

### In scope

- Open Graph and Twitter metadata
- structured data (JSON-LD)
- canonical URLs and robots directives

### Out of scope

- performance optimization details (see performance group)

## Prereqs / Inputs

- Metadata strategy ADR and reference guides exist

## Procedure / Content

- Use the standard feature page fields and include validation steps.

### Governance focus

- canonical URLs must resolve to the intended public domain
- Open Graph and Twitter metadata must render in previews
- JSON-LD must remain valid and reflect current site identity

## Validation / Expected outcomes

- Metadata renders as expected in previews.

## Failure modes / Troubleshooting

- Missing or incorrect tags: fix metadata source and re-test.

## References

- Feature catalog governance: [docs/00-portfolio/features/index.md](../index.md)
