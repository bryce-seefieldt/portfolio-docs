---
title: 'Testing and Quality Gates'
description: 'Governance for testing strategy and quality gate features.'
sidebar_position: 7
tags: [portfolio, features, testing, quality]
---

## Purpose

Define how testing and quality gate features are documented and validated.

## Scope

### In scope

- unit and E2E testing features
- CI gate behaviors and thresholds

### Out of scope

- environment promotion (see CI/CD group)

## Prereqs / Inputs

- Testing guide and CI pipeline docs exist

## Procedure / Content

- Use the standard feature page fields and include validation steps.

### Governance focus

- local verification should mirror CI gates
- coverage thresholds must be stated and enforced
- E2E coverage must include core routes and evidence links
- unit test coverage scope must include all source modules, excluding tests and setup-only files

## Validation / Expected outcomes

- Tests are reproducible and gates enforce quality.

## Failure modes / Troubleshooting

- Gate failures are ignored: update governance and runbooks.

## References

- Feature catalog governance: [docs/00-portfolio/features/index.md](../index.md)
