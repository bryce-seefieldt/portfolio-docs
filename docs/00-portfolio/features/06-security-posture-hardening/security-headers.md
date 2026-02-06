---
title: 'Feature: Security Headers'
description: 'OWASP-aligned security headers and CSP enforcement.'
sidebar_position: 1
tags: [portfolio, features, security, headers]
---

## Purpose

- Feature name: Security headers
- Why this feature exists: Reduce browser attack surface and enforce safe content execution.

## Scope

### In scope

- CSP enforcement with nonces
- X-Frame-Options and X-Content-Type-Options
- referrer and permissions policies

### Out of scope

- dependency scanning (covered in supply chain features)
- secrets scanning (covered in secrets hygiene)

## Prereqs / Inputs

- security headers configured in the app
- CSP nonce handling enabled

## Procedure / Content

### Feature summary

- Feature name: Security headers
- Feature group: Security posture and hardening
- Technical summary: Sets strict security headers and CSP to reduce XSS and clickjacking risk.
- Low-tech summary: Adds browser safety rules to block unsafe scripts and framing.

### Feature in action

- Where to see it working: Any deployed route, inspect response headers.

### Confirmation Process

#### Manual

- Steps: Run `curl -I` against a deployed URL and inspect headers.
- What to look for: CSP present, X-Frame-Options and X-Content-Type-Options set, referrer policy set.
- Artifacts or reports to inspect: Deployment logs or header validation output.

#### Tests

- Unit tests: [`/portfolio-app/src/lib/__tests__/security.test.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/__tests__/security.test.ts)
- E2E tests: None specific.

### Potential behavior if broken or misconfigured

- CSP missing or too permissive.
- Inline scripts blocked due to missing nonce configuration.

### Long-term maintenance notes

- Review CSP quarterly and after adding scripts.
- Re-verify header values after framework upgrades.

### Dependencies, libraries, tools

- Next.js App Router
- React
- Helmet-like header configuration

### Source code references (GitHub URLs)

- [`/portfolio-app/next.config.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/next.config.ts)
- [`/portfolio-app/src/lib/security-headers.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/security-headers.ts)

### ADRs

- None.

### Runbooks

- None.

### Additional internal references

- [`/40-security/portfolio-app-security-controls.md`](/docs/40-security/portfolio-app-security-controls.md)
- [`/40-security/security-policies.md`](/docs/40-security/security-policies.md)

### External reference links

- https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP
- https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers
- https://owasp.org/www-project-secure-headers/

## Validation / Expected outcomes

- Security headers present on all routes.
- CSP enforces script and style sources.

## Failure modes / Troubleshooting

- Missing headers: confirm configuration and redeploy.
- CSP violations: update nonce strategy or CSP directives.

## References

- None.
