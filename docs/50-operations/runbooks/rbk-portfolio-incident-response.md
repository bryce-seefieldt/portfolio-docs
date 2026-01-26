---
title: 'Runbook: General Incident Response'
description: 'Framework for responding to any incident on portfolio platform'
sidebar_position: 3
tags: [runbook, operations, incident-response, framework, process]
---

# Runbook: General Incident Response

## Overview

This runbook provides a framework for responding to **any** incident affecting the portfolio platform. It defines severity levels, notification procedures, investigation phases, and postmortem processes applicable to all incident types.

**When to use this runbook:**

- Any incident not covered by specific runbooks (deployment failure, degradation)
- Security incidents
- Data integrity issues
- Multi-component failures
- Unclear or complex incidents requiring structured triage

---

## Severity Levels

| Severity | Definition | Response Time | Escalation | Example |
|----------|------------|---------------|------------|---------|
| **SEV-4** (Low) | Non-user-impacting; cosmetic bugs, documentation errors | &lt;24 hours | None | Typo in homepage text |
| **SEV-3** (Medium) | Users minimally affected; slow pages, minor features unavailable | &lt;4 hours | Team lead informed | Projects page slow (>5s) |
| **SEV-2** (High) | Significant user impact; broken features, data loss risk | &lt;1 hour | On-call engineer paged | Projects page returns 500 |
| **SEV-1** (Critical) | Complete outage; all users affected, revenue/reputation impact | Immediate | VP Eng + full team | All routes return 500 |

---

## Incident Classification

### How to Determine Severity

Ask these questions during initial triage:

#### Question 1: Are users blocked from core functionality?

- **Yes** → SEV-2 or SEV-1 (depending on scale)
- **No** → SEV-3 or SEV-4 (depending on visibility)

#### Question 2: How many users are affected?

- **All users** → SEV-1 (critical)
- **>50% of users** → SEV-2 (high)
- **&lt;50% of users** → SEV-3 (medium)
- **0 users (internal only)** → SEV-4 (low)

#### Question 3: Is there a workaround?

- **No workaround** → Increase severity by 1 level
- **Workaround available** → Keep current severity

### Example Classifications

| Scenario | Severity | Rationale |
|----------|----------|-----------|
| All routes return 500 | SEV-1 | Complete outage, all users blocked, no workaround |
| Projects page returns 404 | SEV-2 | Core feature broken, many users affected |
| Contact form email not sending | SEV-3 | Non-core feature, users can email directly (workaround) |
| Typo in CV page | SEV-4 | Cosmetic issue, no functional impact |
| Slow homepage (>5s load) | SEV-3 | Performance degradation, users can still access |
| Analytics not loading | SEV-4 | Non-user-facing feature, internal metrics only |

---

## Incident Notification & Escalation

### Who to Notify

| Severity | Notify | Channel | Urgency | Expected Response |
|----------|--------|---------|---------|-------------------|
| SEV-4 | Team lead | Slack #portfolio-updates | ASAP (business hours) | Acknowledge within 1 day |
| SEV-3 | On-call eng + Team lead | Slack #incidents | Within 15 min | Start investigation within 15 min |
| SEV-2 | On-call eng + VP Eng | Slack #incidents + PagerDuty page | Immediately | Start investigation within 5 min |
| SEV-1 | Full team + VP Eng + CEO | Slack #incidents + SMS + Phone | Immediately (wake up if needed) | All hands on deck; respond within 2 min |

### Notification Templates

#### SEV-1 (Critical)

```
🚨 CRITICAL INCIDENT: Portfolio App Complete Outage

Incident ID: INC-20260126-003
Severity: SEV-1 (CRITICAL)
Started: 2026-01-26 16:00 UTC
Impact: ALL ROUTES RETURN 500 - COMPLETE SERVICE OUTAGE
Assigned: @oncall-engineer
Incident Commander: @vp-eng

Action: ALL HANDS - Join #incident-INC-20260126-003
MTTR Target: 15 minutes
Next update: 2 minutes

@channel @here
```

#### SEV-2 (High)

```
🔴 HIGH SEVERITY INCIDENT: Projects Page Broken

Incident ID: INC-20260126-004
Severity: SEV-2 (High)
Started: 2026-01-26 16:00 UTC
Impact: Projects page returns 500, homepage working
Assigned: @oncall-engineer

Action: Investigating root cause
MTTR Target: 1 hour
Next update: 10 minutes
```

#### SEV-3 (Medium)

```
⚠️ INCIDENT: Performance Degradation

Incident ID: INC-20260126-005
Severity: SEV-3 (Medium)
Started: 2026-01-26 16:00 UTC
Impact: Slow page loads (>5s), all routes functional
Assigned: @oncall-engineer

Action: Investigating performance bottleneck
MTTR Target: 4 hours
Next update: 30 minutes
```

---

## Response Phases

### Phase 1: Triage (First 5 minutes)

**Objective:** Verify incident, assess scope, classify severity, notify stakeholders.

#### Step 1: Verify the Incident

- **Can you reproduce it?** Try accessing affected routes/features
- **How many users affected?** Check logs, analytics, user reports
- **What environment?** Production? Staging? Both?

#### Step 2: Assess Scope

- **What's broken?** Specific routes? All routes? Specific features?
- **What's still working?** Homepage? Other pages? Health endpoint?
- **When did it start?** Exact timestamp (helps identify deployments, env changes)

#### Step 3: Classify Severity

Use severity matrix above to classify as SEV-1, SEV-2, SEV-3, or SEV-4.

#### Step 4: Assign Incident Number

Format: `INC-YYYYMMDD-NNN`

Example: `INC-20260126-001`

#### Step 5: Open Incident Channel

**For SEV-1 and SEV-2 only:**

1. Create Slack channel: `#incident-INC-20260126-001`
2. Post initial assessment:
   - Incident number
   - Severity
   - Impact description
   - Assigned responder
   - Initial hypothesis (if any)

---

### Phase 2: Investigation (10–30 minutes)

**Objective:** Identify root cause through systematic diagnosis.

#### Step 1: Gather Context

**What changed recently?**

- Check recent deployments (last 24 hours)
- Check environment variable changes (Vercel settings)
- Check infrastructure status (Vercel status page)
- Check external dependencies (docs site, GitHub API)

**Timeline analysis:**

```bash
# When did it start?
# Example: Started at 15:30 UTC

# What happened at 15:30?
# Check Vercel deployments:
vercel ls | head -10

# Check Git commits:
git log --since="2 hours ago" --oneline

# Check recent env var changes:
# (View in Vercel dashboard → Settings → Environment Variables → Activity Log)
```

#### Step 2: Check Monitoring

- **Health endpoint:** `curl https://portfolio-app.vercel.app/api/health | jq '.'`
- **Vercel Logs:** Filter by time range (when incident started)
- **Error patterns:** Search logs for keywords related to symptom
- **Metrics:** Error rate, response time, resource usage

#### Step 3: Identify Root Cause

Follow specific runbooks if applicable:

| Symptom | Likely Runbook | Root Cause Category |
|---------|----------------|---------------------|
| All routes return 500 after deployment | [Deployment Failure](./rbk-portfolio-deployment-failure.md) | Deployment issue |
| Health endpoint returns 503 | [Service Degradation](./rbk-portfolio-service-degradation.md) | Data/config issue |
| Slow response times but no errors | [Performance Troubleshooting](./rbk-portfolio-performance-troubleshooting.md) | Performance issue |
| Security breach suspected | Security Incident Runbook (future) | Security issue |

**If no runbook applies:**

Categorize into:

- **Code issue:** Bug in application logic, missing error handling
- **Infrastructure issue:** Vercel platform problem, CDN issue
- **Data issue:** Database corruption, missing/invalid data
- **External dependency:** Third-party API down or slow
- **Configuration issue:** Wrong env var, misconfigured setting

#### Step 4: Assign Ownership

- Who owns the affected component?
- Who can implement the fix?
- Who needs to be involved in resolution?

---

### Phase 3: Mitigation & Resolution (5–60 minutes)

**Objective:** Fix the issue or implement temporary mitigation.

#### Option A: Temporary Mitigation (if full fix takes too long)

**Goal:** Reduce user impact while root cause fix is developed.

**Examples:**

- Serve cached/stale data instead of live data
- Disable broken feature temporarily
- Route users to fallback page
- Show graceful degradation message

#### Option B: Full Resolution

**Steps:**

1. **Develop fix** on fix branch
2. **Test locally:** `pnpm verify` must pass
3. **Get code review:** If SEV-1 and time-critical, skip review but document
4. **Deploy fix:** Merge to main, Vercel auto-deploys
5. **Monitor:** Watch logs for 10 minutes post-deployment
6. **Verify:** Health check returns 200, error rate returns to normal

---

### Phase 4: Communication

#### During Incident

Post updates every 5–10 minutes in `#incident-*` channel:

**Update format:**

```
[HH:MM] {STATUS}: {update message}
```

**Example updates:**

```
[15:35] INVESTIGATING: Found error in project loading, checking database
[15:40] IDENTIFIED: Root cause is corrupted projects.yml file
[15:45] MITIGATING: Deploying fix - restoring projects.yml from backup
[15:50] MONITORING: Fix deployed, watching error rate
[15:55] RESOLVED: Error rate back to normal, all routes operational
```

**Status keywords:**

- `INVESTIGATING` — Diagnosis in progress
- `IDENTIFIED` — Root cause found
- `MITIGATING` — Implementing fix
- `MONITORING` — Fix deployed, watching for regression
- `RESOLVED` — Issue fixed, service restored

#### After Incident (All-Clear)

Post in `#incidents` when fully resolved:

```
✅ RESOLVED: INC-20260126-001 - Portfolio App Degradation

Duration: 25 minutes (started 15:30, resolved 15:55 UTC)
Impact: Projects page unavailable, homepage operational
Root Cause: Corrupted projects.yml after merge conflict
Resolution: Restored projects.yml from commit abc1234

Postmortem: Scheduled for 2026-01-27 10:00 UTC
Attendees: @oncall-engineer, @team-lead, @developer-who-committed

Preventive Actions (tracked in GitHub):
- #123: Add registry validation to required CI checks
- #124: Add pre-commit hook for YAML syntax validation
```

---

## Postmortem Phase (Within 24 hours)

### Purpose

- Understand *why* the incident happened (not *who* to blame)
- Identify gaps in processes, testing, or monitoring
- Implement preventive controls to avoid recurrence
- Share learnings with team

### Postmortem Structure

**Template:** [`docs/_meta/templates/template-postmortem.md`](https://github.com/bryce-seefieldt/portfolio-docs/tree/main/docs/_meta/templates/template-postmortem.md)

#### Required Sections

1. **Incident Summary**
   - Incident ID, severity, duration, impact
   - Timeline of key events

2. **Root Cause Analysis**
   - What happened (technical description)
   - Why it happened (contributing factors)
   - Why it wasn't caught earlier (process/testing gaps)

3. **Resolution**
   - How was it fixed?
   - Who fixed it?
   - How long did it take?

4. **Preventive Actions**
   - What will prevent this from happening again?
   - Assigned owner for each action
   - Target completion date

5. **Lessons Learned**
   - What went well?
   - What could be improved?
   - Process or tool recommendations

### Conducting the Postmortem Meeting

**Attendees:** Responders, team lead, affected developers, observers

**Duration:** 30–60 minutes

**Agenda:**

1. **Timeline review** (10 min) — Walk through incident chronologically
2. **Root cause deep-dive** (15 min) — Why did this happen? Contributing factors?
3. **Five Whys exercise** (10 min) — Drill down to fundamental cause
4. **Preventive actions** (15 min) — Brainstorm what could have prevented this
5. **Action items** (10 min) — Assign owners, set deadlines

**Rules:**

- Blameless — Focus on systems, not individuals
- Fact-based — Use logs, timestamps, metrics
- Forward-looking — What can we improve?

---

## Follow-Up

### Preventive Controls

Implement actions identified in postmortem:

**Examples:**

1. **Technical controls:**
   - Add automated validation (e.g., `pnpm registry:validate` in CI)
   - Add health checks after deployment
   - Add error monitoring alerts

2. **Process improvements:**
   - Update runbooks with new learnings
   - Improve deployment checklist
   - Add testing requirements

3. **Monitoring enhancements:**
   - Add new alerts (e.g., error rate >5%)
   - Improve log visibility
   - Add custom metrics

### Track Preventive Actions

Create GitHub issues for each action:

```bash
gh issue create \
  --title "Add registry validation to CI (postmortem INC-20260126-001)" \
  --body "Prevent corrupted projects.yml from deploying." \
  --label "ci,enhancement,postmortem-followup" \
  --milestone "Phase 4.3" \
  --assignee oncall-engineer
```

### Team Training

- **Incident response drill** — Simulate incidents quarterly
- **Runbook review** — Update runbooks after each major incident
- **Lessons learned sharing** — Discuss in team meeting

---

## Severity-Based Quick Reference

### SEV-1 (Critical) — Immediate Response

1. **Page everyone:** VP Eng + full team (Slack + SMS + phone)
2. **Create incident channel:** `#incident-INC-YYYYMMDD-NNN`
3. **Assign incident commander:** VP Eng or senior engineer
4. **Execute relevant runbook:** Deployment failure or service degradation
5. **Post updates every 5 min**
6. **All-clear when resolved**
7. **Postmortem within 24 hours**

**MTTR Target:** 15 minutes

### SEV-2 (High) — Urgent Response

1. **Notify on-call engineer via PagerDuty**
2. **Create incident channel** (if multi-person response)
3. **Execute relevant runbook:** Service degradation, deployment failure
4. **Post updates every 10 min**
5. **Escalate to VP Eng if >1 hour**
6. **Postmortem within 48 hours**

**MTTR Target:** 1 hour

### SEV-3 (Medium) — Normal Response

1. **Notify team lead via Slack**
2. **Create GitHub issue** to track investigation
3. **Investigate during business hours**
4. **Fix within 4 hours** (or provide ETA)
5. **No formal postmortem** (document learnings in issue)

**MTTR Target:** 4 hours

### SEV-4 (Low) — Low Priority

1. **Create GitHub issue** with `bug` or `documentation` label
2. **Fix during next sprint**
3. **No incident response required**

**MTTR Target:** 24 hours (or next sprint)

---

## Tools & References

### Incident Management

- **Slack channels:** `#incidents`, `#portfolio-updates`
- **PagerDuty:** [portfolio-app on-call rotation](https://portfolio.pagerduty.com)
- **GitHub Issues:** [Incident tracking label](https://github.com/bryce-seefieldt/portfolio-app/labels/incident)

### Monitoring & Logs

- [Vercel Dashboard](https://vercel.com/bryce-seefieldts-projects/portfolio-app)
- [Health Endpoint](https://portfolio-app.vercel.app/api/health)
- [Vercel Status Page](https://www.vercel-status.com/)

### Related Runbooks

- [Service Degradation](./rbk-portfolio-service-degradation.md)
- [Deployment Failure](./rbk-portfolio-deployment-failure.md)
- [Performance Optimization](./rbk-portfolio-performance-optimization.md)
- [Performance Troubleshooting](./rbk-portfolio-performance-troubleshooting.md)
- [Observability Architecture](../../60-projects/portfolio-app/08-observability.md)

---

**Last Updated:** 2026-01-26  
**Maintained By:** Portfolio Operations Team  
**Review Schedule:** Quarterly + after each SEV-1 incident
