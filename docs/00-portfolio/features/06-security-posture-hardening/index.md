---
title: 'Security Posture and Hardening'
description: 'Governance for security-related features and controls.'
sidebar_position: 6
tags: [portfolio, features, security, sdlc]
---

## Purpose

Define how security posture features are documented and validated.

## Scope

### In scope

- security headers and CSP
- secrets hygiene and scanning
- supply chain controls and policy features

### Out of scope

- incident procedures (see runbooks in 50-operations)

## Prereqs / Inputs

- Security policies and threat models exist

## Procedure / Content

- Use the standard feature page fields and include validation steps.

### Governance focus

- security headers and CSP must be verified in deployed environments
- secrets hygiene must be enforced by CI and local checks
- dependency and supply-chain controls must be documented with MTTR targets

## Validation / Expected outcomes

- Controls are enforced and verifiable.

## Failure modes / Troubleshooting

- Controls exist only in prose: add automation or checks.

## References

- Feature catalog governance: [docs/00-portfolio/features/index.md](../index.md)
