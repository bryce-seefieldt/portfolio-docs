---
title: 'Runbooks'
description: 'Operational procedures for portfolio systems: deploy, rollback, maintenance, incident response, and deterministic troubleshooting—written for repeatability under pressure.'
sidebar_position: 1
tags: [operations, runbook, reliability, incident-response, governance]
---

## Purpose

This section contains **runbooks**: operational procedures written to be executed reliably under time pressure.

Runbooks demonstrate enterprise operational maturity by ensuring that:

- critical procedures are documented and repeatable
- success criteria and validation are explicit
- rollback and recovery are first-class
- failure modes and troubleshooting are captured systematically

## Scope

### In scope

- deployment and rollback procedures
- incident response playbooks and triage flows
- maintenance operations (dependency updates, planned changes)
- deterministic troubleshooting for common failure modes

### Out of scope

- architecture rationale (belongs in ADRs)
- security threat enumeration (belongs in threat models)
- reference-only command lists (belongs in `70-reference/`)

## Prereqs / Inputs

A runbook author should know:

- what system is affected and which environment(s) are in scope
- what access is required (without publishing sensitive details)
- what "success" looks like and how it is verified
- what constitutes failure and when rollback is required

Supporting artifacts that runbooks should reference (by path):

- project dossier(s): `docs/60-projects/`
- ADRs: `docs/10-architecture/adr/`
- threat models: `docs/40-security/threat-models/`
- CI/CD docs: `docs/30-devops-platform/ci-cd/`

---

## For Runbook Authors: Creating & Maintaining Runbooks

### How to Create a Runbook

1. **Create a branch**
   - Suggested: `ops/runbook-<system>-<task>`

2. **Create the runbook file**
   - Naming convention: `rbk-<system>-<task>.md`
   - Example: `rbk-docs-deploy.md`

3. **Use the runbook template**
   - Template location: `docs/_meta/templates/template-runbook.md` (internal-only)
   - Mandatory sections:
     - prerequisites
     - step-by-step procedure
     - validation
     - rollback / recovery
     - failure modes / troubleshooting

4. **Author for "stressed operator" reality**
   - avoid long prose
   - prefer numbered steps
   - each command includes expected outcome
   - destructive steps use warning/danger admonitions

5. **Validate**
   - where applicable, run the procedure in a safe environment (or simulate locally)
   - run `pnpm build` before PR

6. **Open a PR**
   - include what/why/evidence/no-secrets statement

### Runbook Quality Standards

A runbook is acceptable only if:

- it can be followed without guessing
- validation steps are concrete (not "looks good")
- rollback is as explicit as deploy
- it states what to do if prerequisites are not met (stop/escalate)

### Maintaining Runbooks

Update runbooks when:

- pipeline steps change
- deployment mechanics change
- monitoring/alerts change
- new failure modes are discovered (add to troubleshooting section)

**Validation criteria:** Operations documentation is effective when:

- deploy and rollback are routine, not heroic
- common failures are fixed quickly with deterministic steps
- PRs include evidence that runbooks remain accurate

**Common failure modes:**

- **Runbooks become stale:** treat as a defect; update as part of the change PR.
- **Overly generic runbooks:** add system- and environment-specific validation signals.
- **No rollback:** unacceptable for production-impacting procedures.

---

## For On-Call Engineers: Using Runbooks

### What is a Runbook?

A **runbook** is a documented operational procedure that provides:

- **Clear steps** to diagnose and resolve specific problems
- **MTTR targets** (Mean Time To Recovery) for each scenario
- **Escalation paths** when standard procedures don't resolve the issue
- **Decision trees** to guide responders through complex scenarios
- **Command examples** that are copy-paste ready

### When to Use Runbooks

Runbooks should be your first reference during:

- **Active incidents** — Quick resolution procedures with MTTR targets
- **Deployments** — Standard and emergency deployment procedures
- **Troubleshooting** — Systematic diagnosis of performance or functionality issues
- **Maintenance** — Routine operational tasks and health checks

### How to Use Runbooks During an Incident

1. **Identify the scenario** — Match symptoms to runbook using the [Incident Response Handbook](/docs/50-operations/incident-response/incident-handbook.md)
2. **Follow steps sequentially** — Don't skip steps unless explicitly told to
3. **Track progress** — Check off completed steps, note timestamps
4. **Escalate when indicated** — Follow escalation procedures if MTTR target missed
5. **Update the incident channel** — Post progress every 5–10 minutes
6. **Document learnings** — Note any deviations from runbook for postmortem

---

## Runbook Catalog

### Deployment Runbooks

| Runbook                                                                  | Purpose                                | MTTR Target | Severity     |
| ------------------------------------------------------------------------ | -------------------------------------- | ----------- | ------------ |
| **[Deployment Failure Recovery](./rbk-portfolio-deployment-failure.md)** | Detect and rollback failed deployments | 5 minutes   | SEV-2 (High) |

**When to use:**

- Deployment shows "Failed" status in Vercel
- All routes return 500 immediately after deployment
- Build logs show compilation errors
- Need to roll back to previous deployment

### Incident Response Runbooks

| Runbook                                                                         | Purpose                                                           | MTTR Target | Severity       |
| ------------------------------------------------------------------------------- | ----------------------------------------------------------------- | ----------- | -------------- |
| **[General Incident Response Framework](./rbk-portfolio-incident-response.md)** | Framework for all incidents (severity levels, triage, postmortem) | Varies      | All            |
| **[Service Degradation](./rbk-portfolio-service-degradation.md)**               | Diagnose and resolve performance/availability issues              | 10 minutes  | SEV-3 (Medium) |

**When to use:**

- Health endpoint returns 503 (degraded) or 500 (unhealthy)
- Users report slow pages or errors
- Error rate spikes in Vercel logs
- Partial feature unavailability
- Any incident not covered by specific runbooks

### Performance Runbooks

| Runbook                                                                           | Purpose                                       | MTTR Target     | Severity       |
| --------------------------------------------------------------------------------- | --------------------------------------------- | --------------- | -------------- |
| **[Performance Optimization](./rbk-portfolio-performance-optimization.md)**       | Proactive performance tuning and optimization | N/A (proactive) | —              |
| **[Performance Troubleshooting](./rbk-portfolio-performance-troubleshooting.md)** | Diagnose and fix performance problems         | 30 minutes      | SEV-3 (Medium) |

**When to use:**

- Pages load slowly (>3 seconds) but no errors
- Bundle size exceeds baseline (>30MB)
- Build time exceeds baseline (>4 seconds)
- Core Web Vitals degradation
- Proactive performance improvement initiatives

### Security Incident Runbooks

| Runbook                                                                              | Purpose                                                        | MTTR Target              | Severity         |
| ------------------------------------------------------------------------------------ | -------------------------------------------------------------- | ------------------------ | ---------------- |
| **[Dependency Vulnerability Response](./rbk-portfolio-dependency-vulnerability.md)** | Detect, triage, and remediate CVEs in npm dependencies         | Critical: 24h, High: 48h | SEV-2 (High)     |
| **[Secrets Incident Response](./rbk-portfolio-secrets-incident.md)**                 | Contain and investigate suspected secret leaks or exfiltration | Critical: ≤5min          | SEV-1 (Critical) |

**When to use:**

- CVE alert or security advisory on a dependency
- Suspected credentials, tokens, or API keys committed to repo
- Third-party report of potential vulnerability
- Detected by secrets scanning or security audit

### Operational Readiness

| Document                                                                                  | Purpose                                         | Audience                    |
| ----------------------------------------------------------------------------------------- | ----------------------------------------------- | --------------------------- |
| **[Observability & Monitoring](/docs/30-devops-platform/observability-health-checks.md)** | Health checks, logging, monitoring architecture | Developers, DevOps, On-call |

---

## Incident Response Handbook

For severity guidance, quick selectors, and operational patterns, use the incident handbook:

- [Incident Response Handbook](/docs/50-operations/incident-response/incident-handbook.md)
