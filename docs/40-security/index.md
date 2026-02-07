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

## React2Shell Hardening Program

Use these documents to plan and govern React2Shell-class hardening work:

- Implementation guide: [/docs/40-security/react2shell-hardening-implementation-guide.md](/docs/40-security/react2shell-hardening-implementation-guide.md)
- ADR-0018: [/docs/10-architecture/adr/adr-0018-react2shell-hardening-baseline.md](/docs/10-architecture/adr/adr-0018-react2shell-hardening-baseline.md)

## Portfolio Docs Hardening Program

- Implementation plan: [/docs/40-security/portfolio-docs-hardening-implementation-plan.md](/docs/40-security/portfolio-docs-hardening-implementation-plan.md)
- ADR-0019: [/docs/10-architecture/adr/adr-0019-portfolio-docs-hardening-baseline.md](/docs/10-architecture/adr/adr-0019-portfolio-docs-hardening-baseline.md)

## Security Posture Deepening

**New Documentation:**

- **[Threat Model v2](/docs/40-security/threat-models/portfolio-app-threat-model-v2.md)** — Extended threat model covering deployment surface and runtime misconfiguration risks with STRIDE analysis, residual risks, and mitigation summary
- **[Risk Register](/docs/40-security/risk-register.md)** — Inventory of known security risks with severity, mitigations, and acceptance status; quarterly review schedule
- **[Security Policies & Governance](/docs/40-security/security-policies.md)** — Formal policies for dependency audit, secrets management, security headers, and incident response

**Operational & Implementation References:**

- **[Security Hardening Implementation](/docs/60-projects/portfolio-app/04-security.md)** — OWASP security headers, CSP policy, environment variable security, and testing procedures
- **[Dependency Vulnerability Runbook](/docs/50-operations/runbooks/rbk-portfolio-dependency-vulnerability.md)** — Procedures for detecting, triaging, and remediating CVEs with MTTR targets
- **[Secrets Incident Runbook](/docs/50-operations/runbooks/rbk-portfolio-secrets-incident.md)** — Deterministic response to suspected secret leaks or exfiltration

**Portfolio App Dossier References:**

- [Overview — Security Posture Hardening](/docs/60-projects/portfolio-app/01-overview.md#security-posture-hardening-stage-44)
- [Architecture — Security References](/docs/60-projects/portfolio-app/02-architecture.md#out-of-scope)
- [Operations — Security Monitoring](/docs/60-projects/portfolio-app/06-operations.md#security-operations--incident-response-stage-44)
