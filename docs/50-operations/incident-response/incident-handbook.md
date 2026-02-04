---
title: 'Incident Response Handbook'
description: 'Severity guidance, quick selectors, operational patterns, and runbook improvement standards for on-call responders.'
sidebar_position: 1
tags: [operations, incident-response, runbook, handbook, reliability]
---

## Purpose

Provide a consolidated incident response handbook that supports on-call responders with severity guidance, quick selectors, and operational patterns. This handbook complements the runbook catalog at [/docs/50-operations/runbooks](/docs/50-operations/runbooks/index.md).

## Scope

### In scope

- quick selectors to choose the right runbook
- severity-based response guidance
- operational patterns for detection, recovery, and verification
- tools and utilities used during response
- runbook improvement standards

### Out of scope

- step-by-step procedures (see runbooks)
- architecture rationale (see ADRs)

---

## Quick Selector: Find Your Runbook

Match your scenario to the appropriate runbook:

| I'm seeing...                              | Use this runbook                                                                                            |
| ------------------------------------------ | ----------------------------------------------------------------------------------------------------------- |
| ❌ Deployment shows "Failed" in Vercel     | [Deployment Failure](/docs/50-operations/runbooks/rbk-portfolio-deployment-failure.md)                      |
| ⚠️ Health endpoint returns 503             | [Service Degradation](/docs/50-operations/runbooks/rbk-portfolio-service-degradation.md)                    |
| 🔴 All routes return 500                   | [Deployment Failure](/docs/50-operations/runbooks/rbk-portfolio-deployment-failure.md)                      |
| 🐌 Pages load slowly (>3s) but no errors   | [Performance Troubleshooting](/docs/50-operations/runbooks/rbk-portfolio-performance-troubleshooting.md)    |
| 📦 Bundle size too large (>30MB)           | [Performance Troubleshooting](/docs/50-operations/runbooks/rbk-portfolio-performance-troubleshooting.md)    |
| ❓ Unclear incident, need framework        | [General Incident Response](/docs/50-operations/runbooks/rbk-portfolio-incident-response.md)                |
| 🔍 Want to understand monitoring setup     | [Observability & Health Checks](/docs/30-devops-platform/observability-health-checks.md)                    |
| ⚡ Want to improve performance proactively | [Performance Optimization](/docs/50-operations/runbooks/rbk-portfolio-performance-optimization.md)          |
| 🔐 CVE alert or dependency vulnerability   | [Dependency Vulnerability Response](/docs/50-operations/runbooks/rbk-portfolio-dependency-vulnerability.md) |
| 🚨 Suspected secret leak in repo           | [Secrets Incident Response](/docs/50-operations/runbooks/rbk-portfolio-secrets-incident.md)                 |

---

## Severity-Based Quick Reference

### Critical Incident (SEV-1) — Immediate Response

**Symptoms:** Complete service outage, all users affected, all routes return 500

**Quick Steps:**

1. **Page on-call engineer + VP Engineering** (Slack + SMS + phone)
2. **Create incident channel:** `#incident-INC-YYYYMMDD-NNN`
3. **Execute runbook:** [Deployment Failure](/docs/50-operations/runbooks/rbk-portfolio-deployment-failure.md) if recent deployment, otherwise [General Incident Response](/docs/50-operations/runbooks/rbk-portfolio-incident-response.md)
4. **Post updates every 5 minutes**
5. **All-clear when resolved**
6. **Schedule postmortem within 24 hours**

**MTTR Target:** 15 minutes

**If Secrets Incident:** Execute [Secrets Incident Response](/docs/50-operations/runbooks/rbk-portfolio-secrets-incident.md) immediately; MTTR ≤5 min for critical secrets

### High Severity (SEV-2) — Urgent Response

**Symptoms:** Significant user impact, core features broken, partial outage

**Quick Steps:**

1. **Notify on-call engineer via Slack + PagerDuty**
2. **Execute runbook:** [Service Degradation](/docs/50-operations/runbooks/rbk-portfolio-service-degradation.md) or [Deployment Failure](/docs/50-operations/runbooks/rbk-portfolio-deployment-failure.md)
3. **Target resolution:** less than 1 hour
4. **Post updates every 10 minutes**
5. **Schedule postmortem within 48 hours**

**MTTR Target:** 1 hour

**If Dependency CVE (High):** Execute [Dependency Vulnerability Response](/docs/50-operations/runbooks/rbk-portfolio-dependency-vulnerability.md); MTTR 48 hours

### Medium Severity (SEV-3) — Normal Response

**Symptoms:** Minor user impact, slow performance, non-critical features unavailable

**Quick Steps:**

1. **Notify team lead via Slack**
2. **Create GitHub issue** to track
3. **Execute runbook:** [Service Degradation](/docs/50-operations/runbooks/rbk-portfolio-service-degradation.md) or [Performance Troubleshooting](/docs/50-operations/runbooks/rbk-portfolio-performance-troubleshooting.md)
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
- **After incidents:** Update with new learnings from postmortem
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
- Observability: `docs/30-devops-platform/observability-health-checks.md`

---

**Last Updated:** 2026-02-04  
**Maintained By:** Portfolio Operations Team  
**Next Review:** 2026-05-04 (Quarterly)
