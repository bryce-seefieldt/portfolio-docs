---
title: 'Runbook: Portfolio App Service Degradation'
description: 'Detect, diagnose, and resolve service degradation scenarios'
sidebar_position: 2
tags: [runbook, operations, troubleshooting, degradation, incident-response]
---

# Runbook: Portfolio App Service Degradation

## Quick Reference

|                 |                                                                |
| --------------- | -------------------------------------------------------------- |
| **Scenario**    | Application slow, features unavailable, users report issues    |
| **Severity**    | Medium (SEV-3) — Users affected, core functionality remains    |
| **MTTR Target** | 10 minutes (time to restore service)                           |
| **On-Call**     | Yes — Notify on-call engineer within 15 minutes                |
| **Escalation**  | Team lead (if persists >30 min) → VP Eng (if persists >1 hour) |

---

## Overview

This runbook guides you through detecting, diagnosing, and resolving **service degradation** — scenarios where the portfolio app is partially functional but experiencing performance issues or feature unavailability.

**Degradation vs. Outage:**

- **Degradation (this runbook):** Core routes work (homepage, CV, contact), but some features slow/broken
- **Outage:** All routes return 500 errors, complete service failure ([deployment failure runbook](./rbk-portfolio-deployment-failure.md))

**Typical degradation symptoms:**

- Health endpoint returns 503 (`status: "degraded"`)
- Specific routes timeout or return errors (e.g., `/projects` slow)
- Analytics not loading or stuck
- Median response time >3 seconds

---

## Trigger Detection

### How to Detect Degradation

Service degradation can be detected through multiple channels:

#### 1. Automated Alerts

- **Uptime monitor:** Health endpoint returns 503 status
- **Error rate spike:** Vercel Logs show >5% error rate (normally &lt;1%)
- **Response time degradation:** Median response >3s (normally &lt;1s)
- **Analytics alert:** Page load times exceed threshold

#### 2. User Reports

- Support channel (Slack `#support`, email): "Portfolio app is slow"
- Social media: "Your site isn't loading projects"
- Direct feedback: Contact form report

#### 3. Manual Checks

```bash
# Check health endpoint
curl -s https://portfolio-app.vercel.app/api/health | jq '.status'

# If output is "degraded" → Confirm degradation
# If output is "healthy" but slow → Measure response time
time curl -s https://portfolio-app.vercel.app/projects > /dev/null

# If >3 seconds → Performance degradation
```

#### 4. Vercel Dashboard

- Go to [Vercel Deployments](https://vercel.com/bryce-seefieldts-projects/portfolio-app/deployments)
- Check "Functions" tab for error rate spike
- Check "Logs" for recent 5xx errors or warnings

---

## Response Procedure

Follow these steps sequentially. Each phase has a time target to meet the 10-minute MTTR goal.

### Phase 1: Triage (1 minute)

**Objective:** Confirm degradation exists and assess initial scope.

#### Step 1: Verify the Issue

```bash
# Test health endpoint
curl -s https://portfolio-app.vercel.app/api/health | jq '.'

# Expected responses:
# - Healthy: {"status":"healthy", "projectCount": 8, ...}
# - Degraded: {"status":"degraded", "message":"No projects loaded", ...} (503)
# - Unhealthy: {"status":"unhealthy", "error":"...", ...} (500)
```

**Decision tree:**

- If `status: "unhealthy"` (500) → **STOP.** Use [deployment failure runbook](./rbk-portfolio-deployment-failure.md)
- If `status: "degraded"` (503) → **Continue to Step 2**
- If `status: "healthy"` (200) but user reports issues → **Continue to Step 3 (Performance check)**

#### Step 2: Check Environment Metadata

```bash
# Extract environment and commit info
curl -s https://portfolio-app.vercel.app/api/health | jq '{environment, commit, buildTime, projectCount}'

# Example output:
# {
#   "environment": "production",
#   "commit": "a2058c7",
#   "buildTime": "2026-01-26T15:20:00.000Z",
#   "projectCount": 0
# }
```

**Key observations:**

- `projectCount: 0` → Data loading issue (Category A: Data Issue)
- Recent `commit` (within last hour) → Recent deployment may be cause
- `environment: "preview"` instead of `"production"` → DNS/routing issue

#### Step 3: Assess Scope

Test key routes manually to determine which features are affected:

```bash
# Homepage (should always work)
curl -I https://portfolio-app.vercel.app/ | grep HTTP

# Projects list (may be slow/broken)
time curl -I https://portfolio-app.vercel.app/projects | grep HTTP

# Specific project page
curl -I https://portfolio-app.vercel.app/projects/portfolio-app | grep HTTP

# Contact page (static, should work)
curl -I https://portfolio-app.vercel.app/contact | grep HTTP
```

**Scope classification:**

| Routes Working                | Routes Broken              | Classification          | Action                               |
| ----------------------------- | -------------------------- | ----------------------- | ------------------------------------ |
| All routes except `/projects` | `/projects` timeouts       | Isolated degradation    | Continue to Investigation            |
| Homepage + Contact            | `/projects/*` return 500   | Partial outage          | Escalate to SEV-2; consider rollback |
| All routes slow (>5s)         | None (all eventually load) | Performance degradation | Continue to Investigation            |

#### Step 4: Initial Judgment

Based on triage, classify the degradation type:

- **Type A: Degraded (503 status)** → Data loading or resource issue → Skip to **Phase 2: Containment**
- **Type B: Slow but functional (200 status, >3s response)** → Performance degradation → Skip to **Phase 3: Investigation**
- **Type C: Intermittent errors** → Flaky dependency or caching issue → Skip to **Phase 3: Investigation**

---

### Phase 2: Containment (2 minutes)

**Objective:** Limit impact and notify stakeholders while investigating root cause.

#### Step 1: Notify Stakeholders

Post to incident channel (Slack `#incidents` or equivalent):

```
🔴 INCIDENT: Portfolio App Degradation

Status: INVESTIGATING
Severity: SEV-3 (Medium)
Incident ID: INC-20260126-001
Started: 2026-01-26 15:30 UTC
Impact: Projects page slow/unavailable, homepage working
Assigned: @oncall-engineer

Initial assessment: Health check returns 503, projectCount=0
Next update: 5 minutes
```

#### Step 2: Check for Recent Changes

Recent deployments or configuration changes are the most common cause of degradation.

**Check recent deployments:**

1. Go to [Vercel Deployments](https://vercel.com/bryce-seefieldts-projects/portfolio-app/deployments)
2. Note timestamp of most recent deployment
3. If deployed `<5` minutes ago → High likelihood it's the cause

**Decision:** Should you rollback now?

| Scenario                                     | Rollback Now?                                                                                                                   | Rationale                                                |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| Deployed &lt;5 min ago + instant degradation | **Yes** — Execute [deployment rollback](./rbk-portfolio-deployment-failure.md#option-1-vercel-ui-rollback-fastest--recommended) | High confidence deployment caused issue                  |
| Deployed >1 hour ago + gradual degradation   | **No** — Investigate first                                                                                                      | Deployment unlikely to be root cause                     |
| No recent deployment                         | **No** — Investigate                                                                                                            | External cause (env vars, dependencies, Vercel platform) |

#### Step 3: Check Environment Variable Changes

Recent environment variable changes can cause degradation:

1. Go to [Vercel Project Settings → Environment Variables](https://vercel.com/bryce-seefieldts-projects/portfolio-app/settings/environment-variables)
2. Check "Activity Log" for recent changes
3. If variables changed &lt;1 hour ago → Potential cause

**If env vars recently changed:**

```bash
# Verify required vars are present
# (Note: This requires Vercel CLI access)
vercel env ls --scope production

# Expected vars:
# - NEXT_PUBLIC_GITHUB_URL
# - NEXT_PUBLIC_DOCS_BASE_URL
# - NEXT_PUBLIC_SITE_URL
```

**Mitigation:** Revert env var to previous value if suspected cause, then redeploy.

---

### Phase 3: Investigation (3–5 minutes)

**Objective:** Identify root cause using logs and error patterns.

#### Step 1: Examine Vercel Logs

Access logs to find error patterns:

1. Go to [Vercel Dashboard → Portfolio App](https://vercel.com/bryce-seefieldts-projects/portfolio-app)
2. Click "Deployments" → Select latest deployment
3. Click "Functions" tab → View function logs
4. Filter by time: Last 10 minutes
5. Search for keywords: `error`, `fail`, `timeout`, `500`

**Look for structured logs from observability.ts:**

```json
{
  "timestamp": "2026-01-26T15:30:45.123Z",
  "level": "error",
  "message": "Failed to load projects",
  "context": {
    "slug": "portfolio-app",
    "error": "ENOENT: no such file or directory"
  },
  "environment": "production"
}
```

#### Step 2: Analyze Error Patterns

Categorize errors by pattern to identify root cause:

| Error Pattern                    | Likely Cause                            | Root Cause Category                 |
| -------------------------------- | --------------------------------------- | ----------------------------------- |
| `Cannot load PROJECTS registry`  | Empty or corrupted `projects.yml`       | **Category A: Data Issue**          |
| `NEXT_PUBLIC_* variable missing` | Environment variable not set            | **Category B: Configuration Issue** |
| `Timeout calling external API`   | Slow/unavailable external dependency    | **Category D: External Dependency** |
| `Out of memory` / `ETIMEDOUT`    | Resource exhaustion (CPU/memory limits) | **Category C: Resource Issue**      |
| `Module not found`               | Missing dependency or build failure     | **Category B: Configuration Issue** |

#### Step 3: Identify Root Cause Category

Based on error analysis, classify into one of four categories:

**Category A: Data Issue**

- **Symptoms:** `projectCount: 0`, "Cannot load projects registry"
- **Cause:** `src/data/projects.yml` missing, empty, or corrupted
- **Verification:** Check file in GitHub: `git show HEAD:src/data/projects.yml | head -20`

**Category B: Configuration Issue**

- **Symptoms:** `NEXT_PUBLIC_* variable missing`, "Config not found"
- **Cause:** Environment variables not set or incorrect values
- **Verification:** Check Vercel env vars in project settings

**Category C: Resource Issue**

- **Symptoms:** Timeouts, "Out of memory", slow response times across all routes
- **Cause:** Hitting Vercel Function concurrency/memory limits
- **Verification:** Check Vercel Function Analytics for resource usage spike

**Category D: External Dependency**

- **Symptoms:** Specific routes timeout, but others work; errors mentioning external URLs
- **Cause:** External API (docs site, GitHub API) is slow or down
- **Verification:** Test external endpoints: `curl -I https://external-api.example.com`

---

### Phase 4: Recovery (2–5 minutes)

**Objective:** Execute fix based on identified root cause category.

#### Fix for Category A: Data Issue

**Problem:** Projects registry (`src/data/projects.yml`) is missing, empty, or corrupted.

**Recovery steps:**

```bash
# 1. Verify file exists and has content
git show HEAD:src/data/projects.yml | head -20

# If file is missing or empty:
# 2. Identify last known good commit
git log --oneline -- src/data/projects.yml | head -5

# 3. Restore file from previous commit
git show <good-commit-sha>:src/data/projects.yml > src/data/projects.yml

# 4. Commit and deploy
git add src/data/projects.yml
git commit -m "fix: restore projects registry from <good-commit-sha>"
git push origin main

# 5. Wait for Vercel auto-deploy (~60 seconds)
# 6. Verify health check
curl -s https://portfolio-app.vercel.app/api/health | jq '.status'
# Expected: "healthy"
```

**MTTR:** ~3–5 minutes (identify good commit + restore + deploy)

#### Fix for Category B: Configuration Issue

**Problem:** Environment variables missing or incorrect.

**Recovery steps:**

1. Go to [Vercel Project Settings → Environment Variables](https://vercel.com/bryce-seefieldts-projects/portfolio-app/settings/environment-variables)
2. Check required variables are present:
   - `NEXT_PUBLIC_GITHUB_URL`: `https://github.com/bryce-seefieldt/portfolio-app`
   - `NEXT_PUBLIC_DOCS_BASE_URL`: `https://bns-portfolio-docs.vercel.app`
   - `NEXT_PUBLIC_SITE_URL`: `https://portfolio-app.vercel.app`
3. If missing: Add variable with correct value
4. If present but wrong: Edit variable value
5. **Important:** After changing env vars, trigger redeploy:
   - Go to Deployments → Latest deployment → Click "Redeploy"
   - Select "Use existing Build Cache: No" (force fresh build)
6. Wait for deployment (~2 minutes)
7. Verify health check returns 200

**MTTR:** ~5 minutes (diagnose + fix env var + redeploy)

#### Fix for Category C: Resource Issue

**Problem:** Hitting Vercel concurrency/memory limits.

**Short-term mitigation:**

```bash
# Clear CDN cache to reduce load
vercel domains --clear-cache portfolio-app.vercel.app

# Or via Vercel UI:
# Settings → Domains → portfolio-app.vercel.app → Clear Cache
```

**Long-term fix (if hitting limits consistently):**

- Verify Vercel plan has sufficient concurrency (Hobby: 10 concurrent, Pro: 100 concurrent)
- Check Function Analytics for memory/CPU usage trends
- If consistently hitting limits: Consider plan upgrade or performance optimization

**MTTR:** ~2 minutes (clear cache) or ~1 day (plan upgrade)

#### Fix for Category D: External Dependency

**Problem:** External API (docs site, GitHub, analytics) is slow or unavailable.

**Diagnosis:**

```bash
# Test docs site availability
curl -I https://bns-portfolio-docs.vercel.app/

# Test GitHub API
curl -I https://api.github.com/repos/bryce-seefieldt/portfolio-app

# If external service is down:
# Check status pages:
# - Vercel Status: https://www.vercel-status.com/
# - GitHub Status: https://www.githubstatus.com/
```

**Recovery:**

- **If external service is down:** Monitor for recovery; create issue with external team if persistent
- **If analytics down:** Acceptable degradation (non-critical); monitor for auto-recovery
- **Temporary workaround:** Implement fallback (serve stale data, skip external call) in future PR

**MTTR:** Depends on external service recovery (0 minutes if auto-recovers, hours if requires external team)

---

### Phase 5: Verification (1–2 minutes)

**Objective:** Confirm degradation is resolved and service is fully restored.

#### Verification Checklist

Execute all checks to confirm full recovery:

- [ ] **Health check returns 200:**

  ```bash
  curl -s https://portfolio-app.vercel.app/api/health | jq '.status'
  # Expected: "healthy"
  ```

- [ ] **Project count matches expected:**

  ```bash
  curl -s https://portfolio-app.vercel.app/api/health | jq '.projectCount'
  # Expected: 8 (or current project count)
  ```

- [ ] **Homepage loads (no 500s):**

  ```bash
  curl -I https://portfolio-app.vercel.app/ | grep "HTTP"
  # Expected: HTTP/2 200
  ```

- [ ] **Projects page loads and displays projects:**

  ```bash
  curl -s https://portfolio-app.vercel.app/projects | grep -i "project"
  # Expected: HTML content with project titles
  ```

- [ ] **No errors in Vercel Logs (last 5 minutes):**
  - Check Vercel Dashboard → Functions → Logs
  - Filter: Last 5 minutes
  - Search: "error" (should find 0 results)

- [ ] **Response times back to normal (&lt;1s median):**
  ```bash
  time curl -s https://portfolio-app.vercel.app/projects > /dev/null
  # Expected: &lt;1 second
  ```

#### All-Clear Notification

Once all checks pass, post to incident channel:

```
✅ RESOLVED: Portfolio App Degradation

Incident ID: INC-20260126-001
Resolution Time: 8 minutes (MTTR target: 10 min)
Root Cause: [Category A: Data Issue — projects.yml corrupted]
Fix Applied: [Restored projects.yml from commit abc1234]

Status: All routes operational, health check returns 200
Impact: 8 minutes partial unavailability of projects page
Next Steps: Postmortem scheduled for 2026-01-27 10:00 UTC

Postmortem: [Link to postmortem doc]
```

---

## Post-Incident Phase (Async, within 24 hours)

**Objective:** Document incident, identify preventive measures, share learnings.

### Step 1: Create Postmortem Document

Use the postmortem template to document the incident:

**Template location:** [`docs/_meta/templates/template-postmortem.md`](https://github.com/bryce-seefieldt/portfolio-docs/tree/main/docs/_meta/templates/template-postmortem.md)

**Required sections:**

1. **Incident Summary:**
   - Incident ID: `INC-20260126-001`
   - Severity: SEV-3 (Medium)
   - Duration: 8 minutes
   - Impact: Projects page unavailable, homepage operational

2. **Timeline:**
   - 15:30 UTC: Alert triggered (health check 503)
   - 15:31 UTC: On-call engineer notified
   - 15:33 UTC: Root cause identified (corrupted projects.yml)
   - 15:36 UTC: Fix deployed (restored from commit abc1234)
   - 15:38 UTC: Health check returns 200, service restored

3. **Root Cause Analysis:**
   - **What happened:** `projects.yml` file corrupted during merge conflict resolution
   - **Why it happened:** No automated validation of `projects.yml` syntax before deployment
   - **Why it wasn't caught:** CI checks didn't include `pnpm registry:validate` (added in Phase 3, but not enforced)

4. **Resolution:**
   - Restored `projects.yml` from previous working commit
   - Deployed fix via GitHub push
   - Verified health check and functionality

5. **Preventive Actions:**
   - [ ] **Action 1:** Add `pnpm registry:validate` to required CI checks (ETA: 2 days)
   - [ ] **Action 2:** Add pre-commit hook to validate `projects.yml` syntax (ETA: 1 week)
   - [ ] **Action 3:** Add automated health check after each deployment (Vercel Deployment Checks) (ETA: 2 weeks)

### Step 2: Implement Preventive Controls

Create GitHub issues for each preventive action:

```bash
# Example: Create issue for registry validation in CI
gh issue create --title "Add registry validation to required CI checks" \
  --body "Prevent corrupted projects.yml from deploying by enforcing pnpm registry:validate in CI. Ref: INC-20260126-001" \
  --label "ci,enhancement,postmortem-followup" \
  --milestone "Phase 4.3"
```

Assign owner and due date to each issue.

### Step 3: Share Learnings

1. Post postmortem summary to team channel (Slack `#portfolio-updates`)
2. Discuss in next team meeting: What went well? What can improve?
3. Update runbook if new learnings emerge (e.g., new error pattern discovered)

---

## Common Error Patterns & Quick Fixes

### Pattern 1: "Cannot load PROJECTS registry"

**Error in logs:**

```json
{
  "level": "error",
  "message": "Failed to load projects",
  "context": { "error": "Cannot read property 'length' of undefined" }
}
```

**Cause:** `projects.yml` missing or syntax error  
**Quick fix:** Restore from previous commit (see Category A recovery above)

### Pattern 2: "NEXT_PUBLIC_DOCS_BASE_URL is not defined"

**Error in logs:**

```json
{
  "level": "error",
  "message": "Config error",
  "context": { "error": "NEXT_PUBLIC_DOCS_BASE_URL is not defined" }
}
```

**Cause:** Missing environment variable  
**Quick fix:** Add env var in Vercel settings, redeploy (see Category B recovery above)

### Pattern 3: Slow Response Times (>5s)

**Symptom:** Health check returns 200, but pages take >5 seconds to load  
**Cause:** Bundle size increased, cold starts, or CDN cache miss  
**Quick fix:**

```bash
# Check bundle size
pnpm build | grep "Total Size"

# If >35MB, refer to performance troubleshooting:
# docs/50-operations/runbooks/rbk-portfolio-performance-troubleshooting.md
```

---

## Escalation Paths

### When to Escalate

| Duration      | Action                      | Notify                          |
| ------------- | --------------------------- | ------------------------------- |
| **0–15 min**  | Self-service (this runbook) | On-call engineer only           |
| **15–30 min** | Escalate to team lead       | Team lead via Slack             |
| **30–60 min** | Escalate to VP Engineering  | VP Eng via Slack + Email        |
| **>60 min**   | Full team escalation        | All team members + stakeholders |

### Escalation Contacts

- **On-call engineer:** Check current rotation in PagerDuty/Slack pinned message
- **Team lead:** @team-lead in Slack
- **VP Engineering:** vp.eng@example.com (email) + @vp-eng (Slack)

---

## Tools & References

### Quick Commands

```bash
# Health check
curl -s https://portfolio-app.vercel.app/api/health | jq '.'

# Test route response time
time curl -s https://portfolio-app.vercel.app/projects > /dev/null

# View recent Git commits
git log --oneline -10

# Restore file from previous commit
git show <commit-sha>:src/data/projects.yml > src/data/projects.yml

# Check Vercel deployment status (requires vercel CLI)
vercel ls
```

### External Links

- [Vercel Dashboard](https://vercel.com/bryce-seefieldts-projects/portfolio-app)
- [Vercel Deployments](https://vercel.com/bryce-seefieldts-projects/portfolio-app/deployments)
- [Vercel Logs](https://vercel.com/bryce-seefieldts-projects/portfolio-app/logs)
- [GitHub Repository](https://github.com/bryce-seefieldt/portfolio-app)
- [Observability & Health Checks](/docs/30-devops-platform/observability-health-checks.md)

### Related Runbooks

- [Deployment Failure Recovery](./rbk-portfolio-deployment-failure.md)
- [General Incident Response](./rbk-portfolio-incident-response.md)
- [Performance Troubleshooting](./rbk-portfolio-performance-troubleshooting.md)

---

## Appendix: Degradation Scenarios & Solutions

### Scenario 1: Projects Page Returns 404

**Symptoms:** `/projects` and `/projects/[slug]` return 404  
**Cause:** Static generation failed during build  
**Solution:** Check build logs for errors; redeploy if build succeeded but routes missing

### Scenario 2: Analytics Not Loading

**Symptoms:** Vercel Analytics/Speed Insights not visible on pages  
**Cause:** Analytics package disabled (paid feature on Hobby plan) or script blocked  
**Solution:** Acceptable degradation (non-critical feature); monitor for auto-recovery

### Scenario 3: All Routes Slow (>5s)

**Symptoms:** Every route takes >5 seconds to respond  
**Cause:** Cold start (Vercel Function idle >5 minutes) or bundle size increased  
**Solution:** Wait for warm-up (1-2 requests); if persists, check bundle size and optimize

---

**Last Updated:** 2026-01-26  
**Maintained By:** Portfolio Operations Team  
**Review Schedule:** Quarterly (or after each major incident)
