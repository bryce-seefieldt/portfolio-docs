---
title: 'Documentation and Governance Integration'
description: 'Governance for features that integrate documentation and evidence workflows.'
sidebar_position: 10
tags: [portfolio, features, documentation, governance]
---

## Purpose

Define how documentation and governance integration features are documented and validated.

## Scope

### In scope

- evidence linking and reviewer pathways
- governance integration touchpoints in the app

### Out of scope

- dossier content (see 60-projects)

## Prereqs / Inputs

- Documentation system governance exists

## Procedure / Content

- Use the standard feature page fields and include validation steps.

### Governance focus

- evidence links must use the configured docs base URL
- cross-links should prioritize ADRs, runbooks, and reference docs
- reviewer guidance must remain consistent across app and docs

## Validation / Expected outcomes

- Evidence is discoverable and consistent across the app and docs.

## Failure modes / Troubleshooting

- Evidence links go stale: add validation steps and update references.

## References

- Feature catalog governance: [docs/00-portfolio/features/index.md](../index.md)
