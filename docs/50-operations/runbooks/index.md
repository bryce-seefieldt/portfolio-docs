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

1. **Identify the scenario** — Match symptoms to runbook (see Quick Selector below)
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

### Operational Readiness

| Document                                                                              | Purpose                                         | Audience                    |
| ------------------------------------------------------------------------------------- | ----------------------------------------------- | --------------------------- |
| **[Observability & Monitoring](../../60-projects/portfolio-app/08-observability.md)** | Health checks, logging, monitoring architecture | Developers, DevOps, On-call |

---

## Quick Selector: Find Your Runbook

Match your scenario to the appropriate runbook:

| I'm seeing...                              | Use this runbook                                                                  |
| ------------------------------------------ | --------------------------------------------------------------------------------- |
| ❌ Deployment shows "Failed" in Vercel     | [Deployment Failure](./rbk-portfolio-deployment-failure.md)                       |
| ⚠️ Health endpoint returns 503             | [Service Degradation](./rbk-portfolio-service-degradation.md)                     |
| 🔴 All routes return 500                   | [Deployment Failure](./rbk-portfolio-deployment-failure.md)                       |
| 🐌 Pages load slowly (>3s) but no errors   | [Performance Troubleshooting](./rbk-portfolio-performance-troubleshooting.md)     |
| 📦 Bundle size too large (>30MB)           | [Performance Troubleshooting](./rbk-portfolio-performance-troubleshooting.md)     |
| ❓ Unclear incident, need framework        | [General Incident Response](./rbk-portfolio-incident-response.md)                 |
| 🔍 Want to understand monitoring setup     | [Observability Architecture](../../60-projects/portfolio-app/08-observability.md) |
| ⚡ Want to improve performance proactively | [Performance Optimization](./rbk-portfolio-performance-optimization.md)           |

---

## Severity-Based Quick Reference

### Critical Incident (SEV-1) — Immediate Response

**Symptoms:** Complete service outage, all users affected, all routes return 500

**Quick Steps:**

1. **Page on-call engineer + VP Engineering** (Slack + SMS + phone)
2. **Create incident channel:** `#incident-INC-YYYYMMDD-NNN`
3. **Execute runbook:** [Deployment Failure](./rbk-portfolio-deployment-failure.md) if recent deployment, otherwise [General Incident Response](./rbk-portfolio-incident-response.md)
4. **Post updates every 5 minutes**
5. **All-clear when resolved**
6. **Schedule postmortem within 24 hours**

**MTTR Target:** 15 minutes

### High Severity (SEV-2) — Urgent Response

**Symptoms:** Significant user impact, core features broken, partial outage

**Quick Steps:**

1. **Notify on-call engineer via Slack + PagerDuty**
2. **Execute runbook:** [Service Degradation](./rbk-portfolio-service-degradation.md) or [Deployment Failure](./rbk-portfolio-deployment-failure.md)
3. **Target resolution:** &lt;1 hour
4. **Post updates every 10 minutes**
5. **Schedule postmortem within 48 hours**

**MTTR Target:** 1 hour

### Medium Severity (SEV-3) — Normal Response

**Symptoms:** Minor user impact, slow performance, non-critical features unavailable

**Quick Steps:**

1. **Notify team lead via Slack**
2. **Create GitHub issue** to track
3. **Execute runbook:** [Service Degradation](./rbk-portfolio-service-degradation.md) or [Performance Troubleshooting](./rbk-portfolio-performance-troubleshooting.md)
4. **Investigate during business hours**
5. **No formal postmortem** (document learnings in issue)

**MTTR Target:** 4 hours

### Low Severity (SEV-4) — Low Priority

**Symptoms:** Cosmetic issues, documentation errors, non-user-facing problems

**Quick Steps:**

1. **Create GitHub issue** with appropriate label
2. **Fix during next sprint**
3. **No incident response required**

**MTTR Target:** 24 hours or next sprint

---

## Common Operational Patterns

### Error Detection Patterns

| Pattern                | Where to Look                   | What to Search For                      |
| ---------------------- | ------------------------------- | --------------------------------------- |
| **Deployment errors**  | Vercel Deployments → Build logs | `error`, `Error:`, `failed`, `FAILED`   |
| **Runtime errors**     | Vercel Functions → Logs         | `"level":"error"`, `500`, `timeout`     |
| **Performance issues** | Vercel Analytics                | Response time >3s, LCP >2.5s            |
| **Data issues**        | Health endpoint                 | `projectCount: 0`, `status: "degraded"` |

### Recovery Patterns

| Issue Category          | Recovery Method                  | Example                                 |
| ----------------------- | -------------------------------- | --------------------------------------- |
| **Deployment failure**  | Vercel UI rollback or Git revert | Promote previous deployment             |
| **Data corruption**     | Restore from backup commit       | `git show <commit>:file.yml > file.yml` |
| **Config issue**        | Revert environment variable      | Vercel Settings → Env Vars → Restore    |
| **Resource exhaustion** | Clear cache or scale up          | Vercel Cache → Clear All                |

### Verification Patterns

After any fix, always verify:

```bash
# 1. Health check returns 200
curl -s https://portfolio-app.vercel.app/api/health | jq '.status'

# 2. Routes are accessible
curl -I https://portfolio-app.vercel.app/ | grep HTTP

# 3. No errors in recent logs
# Check Vercel Dashboard → Functions → Logs (last 5 minutes)

# 4. Response times normal
time curl -s https://portfolio-app.vercel.app/projects > /dev/null
```

---

## Tools & Utilities

### Quick Commands

```bash
# Health check
curl -s https://portfolio-app.vercel.app/api/health | jq '.'

# Test route
curl -I https://portfolio-app.vercel.app/projects | grep HTTP

# View recent deployments (requires Vercel CLI)
vercel ls | head -10

# View logs (requires Vercel CLI)
vercel logs --follow

# Git rollback
git revert <commit-sha> --no-edit && git push
```

### External Dashboards

- **Vercel Dashboard:** https://vercel.com/bryce-seefieldts-projects/portfolio-app
- **Vercel Deployments:** https://vercel.com/bryce-seefieldts-projects/portfolio-app/deployments
- **Vercel Logs:** https://vercel.com/bryce-seefieldts-projects/portfolio-app/logs
- **Vercel Status:** https://www.vercel-status.com/
- **GitHub Repository:** https://github.com/bryce-seefieldt/portfolio-app

### Monitoring Integrations

- **UptimeRobot:** (to be configured)
- **PagerDuty:** (to be configured)
- **Slack Alerts:** `#incidents`, `#deployments`, `#alerts`

---

## Runbook Improvement & Feedback

### Review Schedule

- **After each use:** Document any deviations from procedure
- **After incidents:** Update with new learnings from postmortems
- **Quarterly:** Full review of all runbooks for accuracy and completeness
- **After platform changes:** Update commands/screenshots if Vercel UI changes

### Submitting Improvements

If you use a runbook and encounter issues:

- **Unclear steps:** Create GitHub issue to clarify
- **Missing steps:** Add to runbook and submit PR
- **Incorrect commands:** Test and correct in PR
- **MTTR targets not achievable:** Reassess and update target

**Template for runbook improvements:**

```bash
gh issue create \
  --title "Runbook improvement: [runbook-name]" \
  --body "Issue found: [description]

Suggested improvement: [what to change]

Context: Used during INC-YYYYMMDD-NNN" \
  --label "documentation,runbook,ops" \
  --assignee ops-team-lead
```

---

## Complete Runbook Index

### Documentation App Runbooks

- `docs/50-operations/runbooks/rbk-docs-deploy.md`
- `docs/50-operations/runbooks/rbk-docs-rollback.md`
- `docs/50-operations/runbooks/rbk-docs-broken-links-triage.md`

### Portfolio App Runbooks (All Phases)

**Phase 1–3:**

- `docs/50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md` — Vercel setup
- `docs/50-operations/runbooks/rbk-portfolio-deploy.md`
- `docs/50-operations/runbooks/rbk-portfolio-rollback.md`
- `docs/50-operations/runbooks/rbk-portfolio-ci-triage.md`
- `docs/50-operations/runbooks/rbk-portfolio-secrets-incident.md` — Phase 2 secrets incident response
- `docs/50-operations/runbooks/rbk-portfolio-project-publish.md` — Phase 3 Stage 3.5
- `docs/50-operations/runbooks/troubleshooting-portfolio-publish.md` — Phase 3 Stage 3.5
- `docs/50-operations/runbooks/rbk-portfolio-environment-promotion.md` — Phase 4 Stage 4.1
- `docs/50-operations/runbooks/rbk-portfolio-environment-rollback.md` — Phase 4 Stage 4.1

**Phase 4 Stage 4.2–4.3:**

- `docs/50-operations/runbooks/rbk-portfolio-performance-optimization.md` — Stage 4.2 proactive tuning
- `docs/50-operations/runbooks/rbk-portfolio-performance-troubleshooting.md` — Stage 4.2 troubleshooting
- `docs/50-operations/runbooks/rbk-portfolio-incident-response.md` — Stage 4.3 general framework
- `docs/50-operations/runbooks/rbk-portfolio-service-degradation.md` — Stage 4.3 degradation procedures
- `docs/50-operations/runbooks/rbk-portfolio-deployment-failure.md` — Stage 4.3 deployment failure recovery

### Related Documentation

- Runbook template: `docs/_meta/templates/template-runbook.md` (internal-only)
- ADRs: `docs/10-architecture/adr/`
- Threat models: `docs/40-security/threat-models/`
- Observability: `docs/60-projects/portfolio-app/08-observability.md`

---

**Last Updated:** 2026-01-26  
**Maintained By:** Portfolio Operations Team  
**Next Review:** 2026-04-26 (Quarterly)
