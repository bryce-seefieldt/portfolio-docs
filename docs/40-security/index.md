---
title: 'Security Posture and Secure SDLC'
description: 'Threat models, secure SDLC controls, supply chain hygiene, and security evidence practices that demonstrate a security-first delivery process.'
sidebar_position: 5
tags: [security, sdlc, threat-model, supply-chain, sast, sca, sbom]
---

## Purpose

This section defines the security program for the portfolio web app and demo projects. It is written to demonstrate that security is integrated into planning, implementation, and operations—not appended later.

It includes:

- threat modeling and trust boundary clarity
- secure SDLC controls as enforceable gates
- supply chain and dependency risk management
- security testing evidence and remediation discipline
- privacy and data minimization principles

## Scope

### In scope

- threat models (system-specific and supply-chain)
- secure SDLC controls: reviews, scanning, secrets policy, release gates
- security testing: SAST/SCA, dependency audits, security headers
- provenance evidence expectations (SBOM and build integrity posture)
- privacy posture: data classification, retention, PII policy (public-safe)

### Out of scope

- operational runbooks (belongs in `50-operations/`)
- CI/CD mechanics (belongs in `30-devops-platform/`) except where security gates are defined

## Security model and documentation standards

### Threat models

Threat models are required when:

- introducing or changing auth/session/security boundaries
- introducing new external integrations
- modifying data flows or storage characteristics
- changing deployment, hosting, or edge security headers

Threat models must include:

- assets and trust boundaries
- entry points and threat scenarios
- mitigations and residual risk
- validation steps (how to confirm controls work)

### Secure SDLC controls (must be enforceable)

Define controls in terms of:

- what is required (policy)
- how it is checked (automation / CI gates)
- what happens on failure (block merge, require exception, etc.)
- who can approve exceptions and how they are tracked

### Security evidence

Treat evidence as a first-class deliverable:

- publish sanitized summaries where safe
- never publish sensitive outputs (credentials, internal endpoints)
- document how evidence is produced and how frequently it is refreshed

## Validation and expected outcomes

Security docs are “correct” when:

- planning decisions have corresponding threat model and control updates
- controls are enforceable and described as such
- security checks are repeatable and outputs are explainable

## Failure modes and troubleshooting

- **Policy without enforcement:** a control exists only in prose → implement a CI gate or tracking mechanism.
- **Security drift:** dependencies update without review → document update policy and enforce it in CI.
- **Over-sharing:** evidence contains sensitive info → redact, summarize, or omit.

## References

Security posture changes must be reflected in:

- ADRs (`10-architecture/adr/`) when architectural impact exists
- pipeline documentation (`30-devops-platform/`) when enforcement is automated
- runbooks (`50-operations/`) if incidents, alerts, or response procedures change
