---
title: 'Security Risk Register'
description: 'Tracking of known security risks, mitigations, and acceptance status'
sidebar_position: 2
tags: [security, risk-management, governance, accepted-risks]
---

## Overview

The risk register documents known security risks, their severity, mitigations, and acceptance status. This demonstrates informed security posture and enables risk-based decisions. Quarterly reviews ensure the register remains current; post-incident updates capture new learnings.

**Risk Scoring:** Likelihood (Very Low / Low / Medium / High) × Impact (Low / Medium / High / Critical) = **Risk Level** (Low / Medium / High / Critical)

**Review Schedule:** Quarterly review + post-incident updates

## Risk Inventory

| ID  | Risk Description               | Category     | Likelihood | Impact   | Level      | Mitigation                                                | Status       | Review    |
| --- | ------------------------------ | ------------ | ---------- | -------- | ---------- | --------------------------------------------------------- | ------------ | --------- |
| R1  | Dependency vulnerability (CVE) | Supply Chain | Medium     | High     | **High**   | Dependabot monitoring, frozen lockfile, audit policy      | Mitigated    | Quarterly |
| R2  | Config drift (env var error)   | Deployment   | Medium     | High     | **High**   | Validation, promotion gates, `.env.example`               | Mitigated    | Quarterly |
| R3  | Secrets accidentally logged    | Operations   | Low        | Critical | **High**   | TruffleHog scan, structured logging, secrets runbook      | Mitigated    | Quarterly |
| R4  | CSP nonce misconfiguration     | Security     | Low        | High     | **Medium** | CSP nonce enforcement, header validation, CI checks       | Mitigated\*  | Post-4.4  |
| R5  | Vercel infrastructure breach   | External     | Very Low   | Critical | **Medium** | Trust Vercel controls, immutable deploys, least privilege | **Accepted** | Quarterly |
| R6  | npm/CDN supply chain attack    | External     | Low        | Critical | **Medium** | Lockfile integrity, audit policy, review                  | **Accepted** | Quarterly |
| R7  | Browser 0-day XSS              | External     | Very Low   | Critical | **Low**    | CSP, framework updates, dependency scanning               | **Accepted** | Quarterly |
| R8  | Insider threat (malicious dev) | Internal     | Very Low   | Critical | **Low**    | Code review, audit logs, least privilege                  | **Accepted** | Quarterly |
| R9  | Framework deserialization RCE  | Runtime      | Medium     | Critical | **High**   | Patch SLA, CSP nonce, strict validation, CSRF, rate limit | Mitigated    | Quarterly |

\*Asterisk indicates Stage 4.4 newly identified or re-assessed risk

## Risk Acceptance Justification

### R4: CSP Nonce Misconfiguration

**Risk:** Missing or incorrect CSP nonce could weaken script execution controls.

**Why Necessary:** Inline scripts are required for theme init and JSON-LD; nonce ensures safe execution.

**Mitigated Because:** CSP nonce is enforced in proxy and validated in header checks.

**Review:** Confirm header validation during quarterly reviews.

### R5–R8: External & Internal Risks

**Why Accepted:** Out of direct control (external) or prohibitive cost (internal). Strategy: assume-breach mentality; focus on detection and response (runbooks, audit logs, monitoring).

**Residual Posture:**

- No critical unmitigated risks
- High-risk mitigations are active and enforceable in CI
- Medium-risk acceptances have clear rationale and review schedules
- Low-risk acceptances are acceptable for this platform's threat model

## Residual Risk Summary

- **Critical risks remaining:** 0 (all mitigated or accepted at acceptable level)
- **High risks remaining:** 4 (R1, R2, R3, R9 with active mitigations in CI/runbooks)
- **Medium risks remaining:** 3 (R4, R5, R6 with documented acceptance)
- **Low risks remaining:** 2 (R7, R8 with documented acceptance)

**Overall posture:** Enterprise-grade with clear mitigations for high risks and documented acceptance for external/low-likelihood risks.

## Risk Tracking & Review

### Quarterly Review Checklist

- [ ] All mitigated risks: Is the mitigation still active? (e.g., Dependabot running, CSP headers present)
- [ ] All accepted risks: Has the threat landscape changed? (e.g., new 0-day, new attack technique)
- [ ] New risks: Have new vulnerabilities or threats been identified?
- [ ] Closed risks: Can any risks be removed from the register?

### Post-Incident Review Checklist

- [ ] Incident root cause documented
- [ ] Risk register updated with new/reclassified risks if applicable
- [ ] Runbook or mitigation updated to prevent recurrence
- [ ] Risk acceptance status reviewed

## References

- Threat model v2: [portfolio-app-threat-model-v2.md](./threat-models/portfolio-app-threat-model-v2.md)
- Security policies: [security-policies.md](./security-policies.md)
- Dependency vulnerability runbook: [rbk-portfolio-dependency-vulnerability.md](../50-operations/runbooks/rbk-portfolio-dependency-vulnerability.md)
- Secrets incident runbook: [rbk-portfolio-secrets-incident.md](../50-operations/runbooks/rbk-portfolio-secrets-incident.md)
