---
title: 'Portfolio Docs Hardening Implementation Plan'
description: 'Plan to harden the Docusaurus-based docs platform with CI audit gates, security headers, and publication safety controls.'
sidebar_position: 7
tags: [security, hardening, docusaurus, supply-chain, sdlc]
---

## Purpose

Define a bounded, docs-specific hardening plan for the Portfolio Docs app that mirrors the program's security posture without relying on Next.js middleware.

## Scope

### In scope

- CI dependency audit gating and visibility logging
- Host-level security headers (CSP + OWASP baseline)
- Publication safety rules (no secrets, no internal endpoints)
- MDX usage controls
- Documentation updates (policies, runbooks, testing guidance)

### Out of scope

- Next.js middleware/proxy controls (not applicable)
- CSRF protections (no mutation endpoints)
- Server-side rate limiting (unless new serverless routes are added)

## Preconditions

- CI pipeline is enforced on PRs and `main`.
- Hosting provider supports response headers (Vercel preferred).
- Documentation of risk tracking is available (risk register).

## Implementation Plan

### Phase 1: Audit Gate + Visibility (CI)

**Goal:** block high/critical vulnerabilities while logging lower-severity advisories.

**Actions:**

- Add `pnpm audit --audit-level=high` as a CI gate.
- Add a non-blocking `pnpm audit --audit-level=low` step for visibility.
- Document the rule: lower-severity findings require a ticket or risk register entry if they persist.

**Validation:**

- CI fails on high/critical advisories.
- CI logs lower-severity advisories for review.

### Phase 2: Host-Level Security Headers

**Goal:** enforce browser-side protections for a static site.

**Actions:**

- Configure hosting headers for CSP and OWASP baseline headers:
  - `Content-Security-Policy`
  - `X-Frame-Options`
  - `X-Content-Type-Options`
  - `Referrer-Policy`
  - `Permissions-Policy`
  - `Strict-Transport-Security`
- Keep CSP strict; allow only required origins (Docusaurus, analytics if enabled).
- Avoid inline scripts when possible; prefer hashes if inline scripts are required.

**Validation:**

- `curl -I` confirms headers on preview + production.
- No console CSP violations in normal page load.

### Phase 3: Publication Safety Controls

**Goal:** prevent accidental disclosure in public docs.

**Actions:**

- Reinforce "no secrets" and "public-safe only" policy in contributor docs.
- Keep secrets scanning enabled and documented.
- Require explicit review for MDX (treat as code).

**Validation:**

- PR templates and contributor guidance include the safety checklist.
- CI secrets scan passes on PRs.

### Phase 4: Governance + Documentation

**Goal:** ensure policy is durable and reviewable.

**Actions:**

- Publish ADR-0019 for docs hardening baseline.
- Update security policies to differentiate Docusaurus vs Next.js controls.
- Update runbooks for dependency vulnerabilities and header verification.

**Validation:**

- ADR linked from security index and portfolio-docs security page.
- Runbooks reference the audit posture and header checks.

## Risks and Mitigations

- **CSP too strict:** mitigate by iterating with report-only in dev and using CSP hashes where needed.
- **Audit noise:** mitigate by triaging lower-severity advisories and tracking them explicitly.
- **Docs drift:** mitigate by tying changes to ADRs and updating the risk register.

## Evidence Checklist

- [ ] CI audit gate configured (high/critical)
- [ ] CI audit visibility step configured (low/medium logging)
- [ ] Headers verified with `curl -I` in preview + prod
- [ ] Security policies updated to reflect docs posture
- [ ] Risk register updated if exceptions persist

## References

- ADR-0019: [/docs/10-architecture/adr/adr-0019-portfolio-docs-hardening-baseline.md](/docs/10-architecture/adr/adr-0019-portfolio-docs-hardening-baseline.md)
- Security policies: [/docs/40-security/security-policies.md](/docs/40-security/security-policies.md)
- Risk register: [/docs/40-security/risk-register.md](/docs/40-security/risk-register.md)
- Security index: [/docs/40-security/](/docs/40-security/index.md)
