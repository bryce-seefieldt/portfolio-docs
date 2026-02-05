---
title: 'Portfolio App Threat Model v2 — Deployment & Runtime Security'
description: 'Extended threat model covering deployment surface and runtime misconfiguration threats'
sidebar_position: 3
tags: [security, threat-model, deployment, runtime, stride]
---

## Executive Summary

Stage 4.4 extends the Portfolio App threat model to include deployment surface and runtime misconfiguration risks. Focus areas: configuration drift, dependency compromise, CSP bypass attempts, performance abuse, and secret exposure in logs. Residual risks (Vercel infrastructure, CDN/npm supply chain, browser 0-days) are documented and tracked in the risk register. Mitigations center on environment validation, dependency audit policy, OWASP security headers with CSP, and structured logging.

## STRIDE Analysis for Deployment Surface

| Category               | Threat                             | Asset                      | Impact                             | Likelihood | Mitigation                                                                                     |
| ---------------------- | ---------------------------------- | -------------------------- | ---------------------------------- | ---------- | ---------------------------------------------------------------------------------------------- |
| Spoofing               | Unauthorized deployment            | Deployment pipeline        | Malicious code in production       | Low        | Branch protection, required reviews, immutable deploys, Vercel audit logs                      |
| Tampering              | Build artifact modification        | Build output, npm packages | Compromised bundle served to users | Low        | Signed commits optional, frozen lockfile installs, Dependabot review, immutable Vercel deploys |
| Repudiation            | Denied deployment action           | Deployment logs            | No audit trail for changes         | Low        | GitHub Actions logs retained, Vercel deployment history                                        |
| Information Disclosure | Secrets exposed in deployment logs | Logs, environment          | Credential compromise              | Medium     | No secrets in env vars, log scrubbing, TruffleHog scanning, `.env.example` contract            |
| Denial of Service      | Broken deployment or config error  | Infrastructure             | Service downtime until rollback    | Medium     | Staging validation, health checks, rollback runbook                                            |
| Elevation of Privilege | Misuse of deployment permissions   | GitHub/Vercel credentials  | Unauthorized production access     | Low        | Least-privilege IAM, branch protection, review before merge                                    |

## Runtime Threat Analysis

| Threat Category   | Threat                          | Asset                | Attack                     | Impact   | Mitigation                                                                       |
| ----------------- | ------------------------------- | -------------------- | -------------------------- | -------- | -------------------------------------------------------------------------------- |
| Config Drift      | Env var misconfiguration        | Environment contract | Wrong URLs/config deployed | Major    | Env validation, promotion gates, `.env.example` guidance                         |
| Dependency Vuln   | Malicious/vulnerable dependency | Build/runtime        | RCE at build or runtime    | Critical | Dependabot, lockfile integrity, audit policy, new dependency runbook             |
| Framework RCE     | Deserialization exploit (R2S)   | Runtime surface      | Remote code execution      | Critical | Patch SLA, CSP nonce, strict input validation, CSRF, rate limiting               |
| CSP Violation     | Inline script/style bypass      | Browser security     | XSS payload executes       | High     | CSP with default-src 'self', limited script/style directives, monitor violations |
| Performance Abuse | DDoS or resource exhaustion     | Server resources     | Degraded UX/outage         | Medium   | CDN shielding (Vercel), rate limiting future, health checks                      |
| Secrets in Logs   | Sensitive data logged           | Logs                 | Credential/key compromise  | Critical | Structured logging, log scrubbing, secret scanning, no secrets in env vars       |
| Unhandled Error   | Crash with stack trace          | Error responses      | Info leak + downtime       | Medium   | Error boundaries, not-found and error routes, monitoring                         |

## Residual Risks (Accepted)

- Vercel infrastructure compromise: accepted; mitigated by vendor controls and immutable deploys
- CDN/npm supply chain attack: accepted; mitigated by lockfile integrity, audit policy, and review
- Browser 0-day enabling XSS: accepted; mitigated by CSP and framework updates
- Insider threat (malicious dev): accepted; mitigated by review, audit logs, least privilege

## Mitigation Summary

| Threat Category | Mitigations                                                                                   |
| --------------- | --------------------------------------------------------------------------------------------- |
| Secrets         | TruffleHog scanning, structured logging, environment contract (no secrets), `.env` discipline |
| Dependencies    | Dependabot updates, frozen lockfile installs, audit policy and runbook, CodeQL                |
| Config          | Environment validation, promotion gates, Stage 4.4 security headers/CSP                       |
| Deployment      | Branch protection, required checks, immutable deploys, staging validation                     |
| Runtime         | CSP nonce, OWASP headers, strict validation, CSRF, rate limiting, health checks               |
| XSS             | CSP, framework security defaults, no dangerous user input, monitoring                         |

## References and Validation

- Risk register: [docs/40-security/risk-register.md](docs/40-security/risk-register.md)
- Security policies: [docs/40-security/security-policies.md](docs/40-security/security-policies.md)
- Security hardening guide: [Security hardening dossier](/docs/60-projects/portfolio-app/04-security.md)
- Dependency vulnerability runbook: [docs/50-operations/runbooks/rbk-portfolio-dependency-vulnerability.md](docs/50-operations/runbooks/rbk-portfolio-dependency-vulnerability.md)
- Validate headers/CSP: `curl -I https://example.com/` and browser DevTools (no CSP violations)
