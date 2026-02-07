---
title: 'Stage 4.4 — Security Posture Deepening (Docs)'
description: 'Documentation for security hardening, threat model extension, risk register, and dependency audit policy'
tags:
  [
    portfolio,
    roadmap,
    planning,
    phase-4,
    stage-4.4,
    documentation,
    security,
    threat-model,
    runbooks,
  ]
---

> **Archive notice:** Archived 2026-02-06. This issue is retained for historical traceability only.
> See release note: /docs/00-portfolio/release-notes/20260206-portfolio-roadmap-issues-archived.md

# Stage 4.4: Security Posture Deepening — Documentation

**Type:** Documentation / ADR / Runbooks / Threat Model  
**Phase:** Phase 4 — Enterprise-Grade Platform Maturity  
**Stage:** 4.4  
**Linked Issue:** stage-4.4-app-issue  
**Duration Estimate:** 4–6 hours  
**Assignee:** [TBD]

---

## Overview

Extend the portfolio app's threat model to cover deployment surface and runtime misconfiguration threats, document the HTTP security headers and Content Security Policy implementation with rationale, formalize the dependency vulnerability audit policy, create the risk register documenting accepted risks and mitigations, and enhance incident runbooks with security-specific procedures. This documentation provides the team with a complete security posture picture: threats, mitigations, policies, and operational procedures for incident response.

## Objectives

- Create threat model extension (v2) covering deployment and runtime threats
- Document all OWASP-recommended security headers and CSP policy
- Create formal dependency vulnerability audit policy and workflow
- Create risk register documenting residual risks and accepted mitigations
- Create/enhance runbooks for dependency vulnerability incidents
- Enhance existing secrets incident runbook with latest best practices
- Provide team with clear security governance and operational procedures

---

## Scope

### Files to Create

1. **`docs/40-security/threat-models/portfolio-app-threat-model-v2.md`** — Extended threat model covering deployment and runtime
   - Type: Threat Model / Security Analysis
   - Purpose: Document threats specific to deployment environment and runtime misconfiguration
   - Audience: Security reviewers, architects, DevOps engineers
   - Sections: Overview, STRIDE analysis for deployment surface, runtime threats, attack trees, mitigations

2. **`docs/40-security/risk-register.md`** — Risk register documenting accepted risks and mitigations
   - Type: Risk Management / Registry
   - Purpose: Track known security risks, their severity, mitigations, and acceptance status
   - Audience: Security team, leadership, auditors
   - Sections: Risk inventory table, residual risk analysis, risk acceptance matrix, review schedule

3. **`docs/50-operations/runbooks/rbk-portfolio-dependency-vulnerability.md`** — Dependency vulnerability incident response runbook
   - Type: Runbook / Operational Procedure
   - Purpose: Guide team through responding to dependency vulnerabilities (CVEs, audit findings)
   - Audience: Security engineer, DevOps, development team
   - MTTR target: 24 hours for high/critical, 2 weeks for medium, 4 weeks for low
   - Sections: Detection, triage, assessment, remediation, verification, postmortem

4. **`docs/60-projects/portfolio-app/09-security-hardening.md`** — Security implementation and configuration guide
   - Type: Architecture / Implementation Reference
   - Purpose: Document security headers, CSP policy, environment variables, public-safe configuration
   - Audience: Developers, security reviewers, maintainers
   - Sections: Security headers overview, CSP policy with rationale, environment variables, configuration examples, testing procedures

5. **`docs/40-security/security-policies.md`** — Formal security policies and procedures (NEW or may be existing)
   - Type: Policy / Governance
   - Purpose: Document security policies for the portfolio app and broader portfolio program
   - Audience: Development team, security team, leadership
   - Sections: Dependency audit policy, vulnerability disclosure, incident response, security headers policy

### Files to Update

1. **`docs/50-operations/runbooks/rbk-portfolio-secrets-incident.md`** — Enhance existing secrets runbook
   - Add section: Latest OWASP secret detection guidance
   - Add section: Prevention strategies (environment variable discipline, automated scanning)
   - Update recovery procedures with latest best practices
   - Reference new dependency vulnerability runbook for related scenarios
   - Add postmortem template and lessons learned section

2. **`docs/60-projects/portfolio-app/01-overview.md`** — Update dossier overview
   - Add reference to Stage 4.4 security enhancements in timeline or status section
   - Link to security hardening documentation (new `09-security-hardening.md`)
   - Update security posture summary: "OWASP headers configured, CSP enforced, threat model extended"

3. **`docs/60-projects/portfolio-app/02-architecture.md`** — Add security architecture section
   - Add section: "Security Architecture & Threat Model"
   - Link to threat model v2 document
   - Diagram showing security layers (headers, CSP, environment validation)
   - Reference links to risk register and security policies

4. **`docs/60-projects/portfolio-app/06-operations.md`** — Add security operations section
   - Add section: "Security Operations & Incident Response"
   - Link to dependency vulnerability runbook
   - Link to enhanced secrets incident runbook
   - Reference security policies document

5. **`docs/40-security/index.md`** (Security domain hub) — Update navigation
   - Add links to new threat model v2, risk register, security policies
   - Update intro to reference Stage 4.4 enhancements
   - Ensure new security documents appear in sidebar

6. **`docs/50-operations/runbooks/README.md`** — Update runbooks index
   - Add entry for dependency vulnerability runbook
   - Update existing entries if needed
   - Add security runbooks section

---

## Content Structure & Design

### Document 1: Threat Model Extension (`portfolio-app-threat-model-v2.md`)

**Type:** Threat Model / STRIDE Analysis

**Front Matter:**

```yaml
---
title: 'Portfolio App Threat Model v2 — Deployment & Runtime Security'
description: 'Extended threat model covering deployment surface and runtime misconfiguration threats'
sidebar_position: 3
tags: [security, threat-model, deployment, runtime, stride]
---
```

**Content Outline:**

#### Section 1: Executive Summary

**Purpose:** Quick overview of threat landscape for stakeholders

- Threat model scope: Deployment environment and runtime execution
- Key threats addressed: Configuration drift, dependency compromise, deployment misconfiguration, performance abuse, secrets in logs
- Residual risks: Infrastructure compromise (Vercel), CDN supply chain, browser XSS (mitigated by CSP)
- Mitigations: Environment validation, dependency audit policy, CSP headers, structured logging

#### Section 2: STRIDE Analysis for Deployment Surface

**Purpose:** Systematically identify threats across deployment pipeline

Create table for each STRIDE category covering deployment surface:

| Category              | Threat                             | Asset                | Impact                            | Likelihood | Mitigation                                       |
| --------------------- | ---------------------------------- | -------------------- | --------------------------------- | ---------- | ------------------------------------------------ |
| **Spoofing**          | Unauthorized deployment            | Deployment pipeline  | Malicious code in production      | Low        | GitHub branch protection, required reviews       |
| **Tampering**         | Build artifact modification        | Docker image, npm    | Code integrity compromised        | Low        | Signed commits, immutable builds, Vercel signing |
| **Repudiation**       | Denied deployment action           | Deployment logs      | No audit trail                    | Low        | GitHub Actions logs, Vercel deployment history   |
| **Information Disc.** | Secrets exposed in deployment logs | Logs, environment    | Credential compromise             | Medium     | Log scrubbing, structured logging, audit policy  |
| **Denial of Service** | Broken deployment (config error)   | Infrastructure       | Service downtime                  | Medium     | Staging validation, health checks, runbooks      |
| **Elevation of Priv** | Misuse of deployment permissions   | GitHub, Vercel creds | Unauthorized access to production | Low        | Least-privilege IAM, branch protection           |

#### Section 3: Runtime Threat Analysis

**Purpose:** Identify threats during app execution

| Threat Category       | Threat                              | Asset            | Attack                             | Impact                                  | Mitigation                                      |
| --------------------- | ----------------------------------- | ---------------- | ---------------------------------- | --------------------------------------- | ----------------------------------------------- |
| **Config Drift**      | Env var misconfiguration            | Environment      | Wrong URLs/config deployed         | Major (broken links, leaked debug info) | Config validation, environment promotion gates  |
| **Dependency Vuln**   | Malicious/vulnerable transitive dep | node_modules     | Code execution at build or runtime | Critical (RCE potential)                | Audit policy, lockfile integrity, scanning      |
| **CSP Violation**     | Inline script/style bypassed        | Browser security | XSS attack succeeds                | High (XSS payload execution)            | CSP enforcement, monitoring violations          |
| **Performance Abuse** | DDoS or resource exhaustion         | Server resources | Service degradation or outage      | Medium (user impact)                    | Rate limiting (future), health checks           |
| **Secrets in Logs**   | Sensitive data logged and exfil'd   | Logs             | Credential/key compromise          | Critical (infrastructure access)        | Structured logging, log scrubbing, scanning     |
| **Unhandled Error**   | App crash with stack trace          | Error pages      | Info leakage, DoS                  | Low-Medium (info leak, poor UX)         | Error boundary components, graceful degradation |

#### Section 4: Residual Risks (Accepted)

**Purpose:** Document risks that are acknowledged and accepted by the team

- **Vercel infrastructure compromise:** Accepted risk; trust Vercel's security controls
- **Supply chain attacks on CDN/npm:** Accepted risk; mitigated by dependency audit and lockfile integrity
- **Browser 0-day enabling XSS:** Accepted risk; mitigated by CSP and framework security updates
- **Insider threat (malicious dev):** Accepted risk; mitigated by code review, audit logs, least-privilege access

#### Section 5: Mitigation Summary

**Purpose:** Overview of all deployed mitigations

| Threat Category  | Mitigations                                                                              |
| ---------------- | ---------------------------------------------------------------------------------------- |
| **Secrets**      | TruffleHog scanning, structured logging, `.env` discipline, SAST checks                  |
| **Dependencies** | Dependabot auto-updates, lockfile integrity, `pnpm audit` policy, CVE monitoring         |
| **Config**       | Environment variable validation, `.env.example` documentation, promotion gates           |
| **Deployment**   | Branch protection, required reviews, immutable builds, health checks, staging validation |
| **Runtime**      | CSP headers, error boundaries, structured logging, health endpoints                      |
| **XSS**          | CSP policy, framework security, automated dependency scanning, input validation          |

---

### Document 2: Risk Register (`portfolio-app-risk-register.md`)

**Type:** Risk Management / Registry

**Front Matter:**

```yaml
---
title: 'Portfolio App Security Risk Register'
description: 'Tracking of known security risks, mitigations, and acceptance status'
sidebar_position: 2
tags: [security, risk-management, governance, accepted-risks]
---
```

**Content Outline:**

#### Section 1: Overview

**Purpose:** Explain the risk register and review process

- What is a risk register? (Inventory of known risks, assessment, mitigations)
- Why it matters: Demonstrates informed security posture, enables risk-based decisions
- Review schedule: Quarterly review, post-incident updates
- Risk scoring: Likelihood × Impact = Risk Level (Low/Medium/High/Critical)

#### Section 2: Risk Inventory Table

**Format:** Comprehensive table of known risks

| ID  | Risk Description               | Category   | Likelihood | Impact   | Level      | Mitigation                                  | Status       | Review Date    |
| --- | ------------------------------ | ---------- | ---------- | -------- | ---------- | ------------------------------------------- | ------------ | -------------- |
| R1  | Dependency vulnerability (CVE) | Dependency | Medium     | High     | **High**   | Dependabot monitoring, lockfile integrity   | Mitigated    | Quarterly      |
| R2  | Config drift (env var error)   | Deployment | Medium     | High     | **High**   | Validation, promotion checklist, runbooks   | Mitigated    | Quarterly      |
| R3  | Secrets accidentally logged    | Operations | Low        | Critical | **High**   | TruffleHog scan, structured logging         | Mitigated    | Quarterly      |
| R4  | CSP bypass (unsafe-inline)     | Security   | Low        | High     | **Medium** | CSP monitoring, script hash future upgrade  | Accepted\*   | Post-Stage-4.4 |
| R5  | Vercel infrastructure breach   | External   | Very Low   | Critical | **Medium** | Trust Vercel, least-privilege access        | **Accepted** | Quarterly      |
| R6  | npm supply chain attack        | External   | Low        | Critical | **Medium** | Lockfile integrity, package audit           | **Accepted** | Quarterly      |
| R7  | Browser 0-day XSS              | External   | Very Low   | Critical | **Low**    | CSP, framework updates, dependency scanning | **Accepted** | Quarterly      |
| R8  | Insider threat (malicious dev) | Internal   | Very Low   | Critical | **Low**    | Code review, audit logs, least-privilege    | **Accepted** | Quarterly      |

\*Asterisk indicates Stage 4.4 newly identified or re-assessed risk

#### Section 3: Risk Acceptance Justification

**Purpose:** Explain why certain risks are accepted

**For CSP `unsafe-inline` trade-off (R4):**

- Risk: `unsafe-inline` for scripts weakens XSS protection
- Mitigation: Necessary for Next.js framework; CSP still provides defense-in-depth
- Accepted because: Benefit (working app) > Cost (CSP weakening). Future: Consider nonces/hashes.
- Review: Post-Stage-4.5 assess whether external scripts added (would trigger nonce upgrade)

**For External Risks (R5, R6, R7, R8):**

- Risks accepted because: Out of direct control or cost of mitigation prohibitive
- Strategy: Assume-breach mentality; focus on detection and response (runbooks, monitoring)

#### Section 4: Residual Risk Summary

**Purpose:** Show net security posture after mitigations

- **Critical risks remaining:** 0 (all mitigated or accepted at acceptable level)
- **High risks remaining:** 2 (R1, R2, R3 with active mitigations)
- **Medium risks remaining:** 3 (R4, R5, R6 accepted)
- **Low risks remaining:** 2 (R7, R8 accepted)

**Overall posture:** Enterprise-grade with clear mitigations for high risks and documented acceptance for external/low-likelihood risks.

---

### Document 3: Dependency Vulnerability Runbook (`rbk-portfolio-dependency-vulnerability.md`)

**Type:** Runbook / Operational Procedure

**Front Matter:**

```yaml
---
title: 'Runbook: Dependency Vulnerability Response'
description: 'Procedures for responding to CVEs and vulnerabilities in npm dependencies'
sidebar_position: 4
tags: [runbook, security, dependencies, incident-response, cve]
---
```

**Content Outline:**

#### Section 1: Overview

**Purpose:** Explain scope and objectives

- What is a dependency vulnerability? (CVE in transitive or direct dependency)
- Examples: Malicious npm package, security flaw in library, deprecated API with no fix
- Objectives: Detect quickly, assess risk, remediate or accept
- MTTR targets: Critical: 24h, High: 48h, Medium: 2 weeks, Low: 4 weeks

#### Section 2: Detection

**Purpose:** How vulnerabilities are discovered

**Automated detection:**

- Dependabot weekly scans and auto-creates PRs
- GitHub security alerts
- `pnpm audit` in CI/CD (`pnpm quality` includes optional audit check)

**Manual detection:**

- Developer runs `pnpm audit` locally
- Security review process finds suspicious dependency

**Response:** Triage ticket created with CVE ID, package name, severity

#### Section 3: Triage (1h)

**Purpose:** Quickly assess severity and decide course of action

**Steps:**

1. **Gather information**
   - Get CVE ID and description
   - Review CVSS score (9.0+ = critical, 7-8 = high, etc.)
   - Check affected versions in lock file
   - Determine if vulnerable code path is reachable in portfolio app (e.g., if vuln in optional dependency not used)

2. **Assess impact**
   - Does vulnerability apply to this app? (e.g., RCE in build-time tool vs runtime library)
   - What's the blast radius? (build-only, runtime, client-side)
   - Can it be exploited realistically?

3. **Categorize**
   - **Critical:** RCE, auth bypass, data breach risk → immediate fix or disable feature
   - **High:** Significant security flaw, likely exploitable → fix within 48h
   - **Medium:** Moderate risk, harder to exploit → fix within 2 weeks
   - **Low:** Minor issue, edge case → fix in next dependency cycle

**Outcome:** Decision documented (fix now, fix soon, accept risk, disable feature)

#### Section 4: Remediation

**Purpose:** Fix or mitigate the vulnerability

**Option 1: Update the package**

```bash
# Check available updates
npm info [package] versions

# Update if patch available
pnpm add [package]@latest

# Run tests to ensure no breaking changes
pnpm quality
pnpm test:e2e
```

**Option 2: Replace the package**

- If no fix available and vulnerability is critical, find alternative package
- Example: Vulnerable version of express → switch to fastify
- Timeline: Depends on refactoring complexity

**Option 3: Accept risk**

- If update breaks app or risk is acceptable (low severity + hard to exploit)
- Document acceptance in risk register
- Create ticket for future review

**Option 4: Disable feature**

- If feature is non-essential and vulnerable
- Example: Analytics library with security flaw → disable analytics temporarily
- Timeline: Re-enable after fix is available

**Output:** PR created with updated lock file, test results, and explanation

#### Section 5: Verification

**Purpose:** Confirm vulnerability is fixed

**Steps:**

1. **Verify fix in PR**
   - PR includes updated lock file
   - `pnpm audit` shows vulnerability gone
   - All tests pass

2. **Review for new vulnerabilities**
   - Update may introduce new issues
   - Check `pnpm audit` for any new findings

3. **Deploy to staging**
   - Merge to staging branch
   - Monitor health check endpoint
   - Review logs for anomalies

4. **Deploy to production**
   - Promote from staging to production
   - Monitor for 24h

**Success:** Vulnerability fixed, no new issues, tests passing

#### Section 6: Postmortem (Async)

**Purpose:** Learn and improve processes

**Questions to answer:**

- How did we detect this vulnerability? (Dependabot, manual scan, incident report)
- Was our MTTR within target? (If not, what blocked us?)
- Did the fix cause any issues?
- Could we have prevented this? (Earlier updates, stricter audit policy)

**Actions:** Update runbook, improve automation, adjust audit schedule

---

### Document 4: Security Hardening Implementation (`09-security-hardening.md`)

**Type:** Architecture / Implementation Reference

**Front Matter:**

```yaml
---
title: 'Security Hardening: Implementation & Configuration'
description: 'OWASP security headers, CSP policy, environment variables, and security configuration for portfolio app'
sidebar_position: 9
tags: [security, headers, csp, configuration, implementation]
---
```

**Content Outline:**

#### Section 1: Security Headers Overview

**Purpose:** Explain why and what each header does

- Overview of HTTP security headers (OWASP Top 10)
- Headers implemented: X-Frame-Options, X-Content-Type-Options, X-XSS-Protection, Referrer-Policy, Permissions-Policy, CSP
- Configuration location: `next.config.ts` headers() function
- Testing: `curl -I https://portfolio.example.com/`

#### Section 2: Content Security Policy (CSP) Deep Dive

**Purpose:** Document CSP configuration and trade-offs

- What is CSP? (Browser security mechanism, prevents XSS)
- Portfolio app policy: `default-src 'self'` + exceptions for analytics
- Why each directive matters (script-src, style-src, img-src, connect-src)
- Trade-offs: `unsafe-inline` necessary for Next.js; future upgrade path with nonces
- Testing CSP: Browser DevTools Console for violations
- Monitoring: Log CSP violations to Vercel console

#### Section 3: Environment Variables & Public-Safe Config

**Purpose:** Document configuration contract

- What is NEXT*PUBLIC*\*? (Exposed to browser, must be public-safe)
- Variables documented in `.env.example`
- Security rule: **No secrets in environment variables**
- Examples: SITE_URL (public), DOCS_BASE_URL (public), never: API_KEY, DB_PASSWORD

#### Section 4: Examples & Testing

**Purpose:** Provide working examples and validation procedures

**Testing security headers locally:**

```bash
pnpm dev
curl -I http://localhost:3000/
# Should see all 6 security headers in response
```

**Testing CSP:**

```bash
# Load app in browser
# DevTools → Network tab → click any request
# Response Headers section should include Content-Security-Policy header
# Console tab should have no CSP violations
```

---

### Document 5: Security Policies (`docs/40-security/security-policies.md`)

**Type:** Policy / Governance

**Front Matter:**

```yaml
---
title: 'Security Policies & Governance'
description: 'Formal security policies for the portfolio app and platform'
sidebar_position: 1
tags: [security, policy, governance, procedures]
---
```

**Content Outline:**

#### Section 1: Dependency Audit Policy

**Purpose:** Formal policy for dependency management

**Policy statement:**

> The portfolio app uses a strict dependency audit and update policy to minimize vulnerability risk. All direct and transitive dependencies are scanned weekly via Dependabot. Critical and High vulnerabilities are remediated within 48 hours. Medium vulnerabilities are fixed within 2 weeks. Low vulnerabilities are addressed in regular dependency cycles.

**Procedures:**

- Weekly: Dependabot creates PRs for available updates
- On CVE alert: Triage within 1h, remediate per MTTR targets
- Monthly: Review `pnpm audit` results
- Quarterly: Update this policy based on lessons learned

**Ownership:** Development team (all PRs), DevOps (Dependabot configuration)

#### Section 2: Secrets Management Policy

**Purpose:** Prevent credential leaks

**Policy:**

- No secrets in source code, environment files, or logs
- All secrets stored in Vercel dashboard only
- Use TruffleHog scanning in CI to detect leaks
- Use structured logging to avoid accidental secret logging
- Incident protocol: See `rbk-portfolio-secrets-incident.md`

#### Section 3: Security Headers Policy

**Purpose:** Enforce HTTP security headers

**Policy:**

- All responses must include OWASP-recommended headers
- CSP enforced with `default-src 'self'`
- Headers configured in `next.config.ts` and validated in CI
- Trade-offs documented: `unsafe-inline` accepted for Next.js with plan to upgrade

#### Section 4: Incident Response Policy

**Purpose:** Clear procedures for security incidents

**Triage:** 15 minutes to assess severity and notify team
**Containment:** 30 minutes to implement immediate fixes (disable feature, rollback)
**Investigation:** 24 hours to understand root cause
**Recovery:** 24-48 hours to fully resolve and restore service
**Postmortem:** 1 week to document lessons and implement preventive controls

**Runbooks:** See `rbk-portfolio-*.md` for detailed procedures

---

## Success Criteria

**Threat Model & Risk Register:**

- [ ] Threat model v2 extends original with deployment and runtime threats
- [ ] STRIDE analysis covers all attack surfaces comprehensively
- [ ] Risk register documents all known risks with severity and mitigations
- [ ] Residual risks are identified and accepted by team
- [ ] Risk register reviewed and signed off

**Security Hardening Documentation:**

- [ ] Security hardening guide explains all headers and CSP
- [ ] CSP trade-offs documented with rationale and future upgrade path
- [ ] Environment variable security contract documented in `.env.example`
- [ ] Configuration examples provided and tested

**Dependency Vulnerability Runbook:**

- [ ] Runbook covers detection, triage, remediation, verification steps
- [ ] MTTR targets defined (24h critical, 48h high, 2w medium, 4w low)
- [ ] Decision tree for update vs. accept vs. disable
- [ ] Postmortem procedure included

**Runbook Enhancements:**

- [ ] Secrets incident runbook enhanced with latest best practices
- [ ] All runbooks linked from operations index
- [ ] Runbook templates consistent across all procedures

**Dossier & Navigation Updates:**

- [ ] Portfolio app dossier references new security documentation
- [ ] Security domain index includes all new documents
- [ ] Runbook index updated with new procedures
- [ ] All links functional and tested

**Team & Stakeholder Buy-in:**

- [ ] Team reviewed threat model and risk register
- [ ] Team understands dependency vulnerability procedures
- [ ] Team aware of accepted risks and mitigation strategies
- [ ] Security policies documented and acknowledged

**Validation:**

- [ ] All Markdown files build without errors
- [ ] Links to related documents functional
- [ ] Code examples provided and validated
- [ ] Diagrams render correctly in Docusaurus

---

## Related Implementation

- App implementation issue: `stage-4.4-app-issue` (security headers, CSP, env vars)
- Threat model extension: New v2 document covering deployment/runtime
- Risk register: New document tracking risks and mitigations
- Security policies: Formal governance documented
- Runbooks: Enhanced dependency and secrets incident response

---

## Notes & Timeline

**Phase 4 Context:**

- Stage 4.1 (Multi-Environment): Complete — Three-tier deployment model operational
- Stage 4.2 (Performance): Deferred — Lower priority; can be addressed in Stage 4.5
- Stage 4.3 (Observability): Complete — Health checks and structured logging operational
- **Stage 4.4 (Security):** In planning — Threat model extension, risk register, dependency audit policy

**Estimated Duration:** 4–6 hours (documentation writing and review)

**Post-Stage-4.4 Roadmap:**

- Stage 4.5 (UX & Content): Enhanced case studies, contact form, interactive features
- Continue with Phase 5 if planning expands beyond current scope

**Security Review Cadence:**

- Risk register reviewed quarterly
- Threat model updated post-incident or when architecture changes
- Dependency audit policy reviewed annually
- Security policies enforced continuously with automated checks
