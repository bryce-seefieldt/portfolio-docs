---
title: 'ADR-0018: React2Shell Hardening Baseline'
description: 'Adopt a defense-in-depth baseline for React/Next.js server surfaces after React2Shell-class vulnerabilities.'
sidebar_position: 18
tags: [adr, architecture, security, hardening, react2shell]
---

## Problem Statement

React2Shell-class vulnerabilities show that React/Next.js applications have backend-grade attack surfaces. Patching alone is not sufficient because deserialization flaws can recur. The portfolio app needs explicit, enforceable hardening controls and governance documentation to reduce blast radius and keep reviewer trust.

---

## Decision

Adopt a React2Shell hardening baseline that combines rapid patching with defense-in-depth controls:

- Patch React/Next.js quickly and enforce `pnpm audit` in CI.
- Add CSP nonce via proxy (formerly middleware) and enforce security headers.
- Validate all mutation inputs with Zod and avoid generic deserialization.
- Enforce CSRF protection and rate limiting on mutation endpoints.
- Update security documentation, threat model, and runbooks to reflect these controls.

---

## Rationale

- **Patch speed is necessary but insufficient:** framework flaws can recur.
- **Defense-in-depth reduces blast radius:** CSP, CSRF, and rate limiting mitigate exploitation impact.
- **Governance clarity improves durability:** documented protocols prevent drift over time.

---

## Consequences

### Positive

- Reduced risk of RCE and injection from framework-layer issues
- Clear guardrails for future development
- Auditable, reviewer-friendly security posture

### Tradeoffs

- Additional implementation and maintenance overhead
- CSP nonce and proxy require careful integration with Next.js

### Operational impact

- CI must enforce `pnpm audit` and security checks
- Runbooks updated for framework CVE response

### Security impact

- Stronger runtime containment and input boundaries
- Lower risk of exploitation in the event of future CVEs

---

## Alternatives Considered

1. **Patch-only response**
   - Pros: quick and minimal change
   - Cons: leaves the same class of risks exposed
   - Why not chosen: does not address defense-in-depth

2. **Disable server features entirely**
   - Pros: reduces server surface
   - Cons: not compatible with current Next.js architecture
   - Why not chosen: impractical and overly restrictive

---

## Implementation Notes (High-Level)

- Implement security headers and CSP nonce in `next.config.ts` and proxy.
- Add Zod validation, CSRF, and rate limiting for mutation routes.
- Update security policies, risk register, and threat model.
- Publish the implementation guide for React2Shell hardening.

---

## Validation / Expected Outcomes

- CSP headers and nonce verified in production
- Mutation endpoints reject invalid input and missing CSRF tokens
- `pnpm audit` blocks critical/high advisories in CI
- Docs build passes with updated governance artifacts

---

## Failure Modes / Troubleshooting

- **CSP breaks app rendering:** switch to report-only in dev and refine directives
- **Proxy regressions:** narrow matcher to app routes and static exclusions
- **Rate limiting false positives:** tune limits and add allowlist for health checks

---

## References

- React2Shell hardening guide: [/docs/40-security/react2shell-hardening-implementation-guide.md](/docs/40-security/react2shell-hardening-implementation-guide.md)
- Security policies: [/docs/40-security/security-policies.md](/docs/40-security/security-policies.md)
- Risk register: [/docs/40-security/risk-register.md](/docs/40-security/risk-register.md)
- Portfolio App security controls: [/docs/40-security/portfolio-app-security-controls.md](/docs/40-security/portfolio-app-security-controls.md)
