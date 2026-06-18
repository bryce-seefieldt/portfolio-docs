---
title: 'ADR-0019: Portfolio Docs Hardening Baseline'
description: 'Adopt a lightweight hardening baseline for the Docusaurus-based Portfolio Docs app to reduce supply-chain and content injection risk.'
sidebar_position: 19
tags: [adr, architecture, security, hardening, docusaurus, supply-chain]
---

## Status

Accepted

## Problem Statement

The Portfolio Docs app is a public-facing Docusaurus site. It does not use Next.js, but it still carries supply-chain and content publication risk. We need a durable baseline for hardening controls that match the program's security posture without adopting Next.js-specific mechanisms.

## Decision

Adopt a docs-specific hardening baseline with the following controls:

- Enforce dependency audit gating on high/critical advisories in CI.
- Log lower-severity advisories for visibility and require a ticket or risk register entry if they persist.
- Apply security headers (CSP, XFO, nosniff, referrer policy, permissions policy, HSTS) at the hosting layer.
- Treat MDX as code and keep it to a minimum; require review for new MDX usage.
- Keep publication safety rules (no secrets, no internal endpoints) as enforceable SDLC policy.

### Decision amendment (2026-06-18)

Following repeated `pnpm audit --audit-level=high` failures in portfolio-docs verification, the dependency baseline was remediated without weakening gates:

- added targeted `pnpm.overrides` entries for vulnerable transitive chains in Docusaurus/webpack tooling (including `shell-quote`, `fast-uri`, `@babel/plugin-transform-modules-systemjs`, and `ws`)
- regenerated lockfile to ensure deterministic adoption of patched transitive versions
- retained strict blocking behavior for high/critical audit findings in verify/CI

This amendment clarifies that transitive override remediation is an approved hardening mechanism for docs-toolchain vulnerabilities when direct top-level upgrades are not immediately available.

## Rationale

- **Docusaurus is static but still exposed:** the primary risks are supply chain and accidental disclosure.
- **CI gates are enforceable and visible:** dependency audits and content checks fit the docs workflow.
- **Host-level headers are the right layer:** Docusaurus does not offer runtime middleware; hosting headers are the correct boundary.

## Consequences

### Positive

- Reduced risk of dependency-based compromise.
- Clear governance around lower-severity advisories.
- Explicit hardening posture for a non-Next.js system.

### Tradeoffs

- Additional CI steps and documentation overhead.
- CSP may require iterations if embedded scripts are introduced.

## Alternatives Considered

1. **No dedicated docs hardening**
   - Pros: zero overhead
   - Cons: security posture drift versus portfolio-app

2. **Full parity with Next.js controls**
   - Pros: consistency
   - Cons: impractical (no middleware/proxy in Docusaurus)

## Implementation Notes (High-Level)

- Configure hosting headers for CSP and baseline OWASP headers.
- Update CI to include audit gate (high/critical) and a non-blocking audit visibility step.
- Document a workflow for lower-severity advisories (ticket or risk register entry).
- Publish a docs-specific hardening implementation plan.

## Validation / Expected Outcomes

- CI fails on high/critical advisories; lower severities are logged.
- Security headers are verifiable via `curl -I` in preview and production.
- Documentation clearly distinguishes docs hardening from Next.js controls.

## References

- Docs hardening implementation plan: [/docs/40-security/portfolio-docs-hardening-implementation-plan.md](/40-security/portfolio-docs-hardening-implementation-plan.md)
- Security policies: [/docs/40-security/security-policies.md](/40-security/security-policies.md)
- React2Shell baseline ADR: [/docs/10-architecture/adr/adr-0018-react2shell-hardening-baseline.md](/10-architecture/adr/adr-0018-react2shell-hardening-baseline.md)
