---
title: 'Runbook: Portfolio App Deployment Failure'
description: 'Detect deployment failures and execute rollback procedures'
sidebar_position: 1
tags: [runbook, operations, deployment, rollback, incident-response]
---

# Runbook: Portfolio App Deployment Failure

## Quick Reference

| | |
|---|---|
| **Scenario** | New deployment failed or introduced breaking changes |
| **Severity** | High (SEV-2) — Service potentially broken or unavailable |
| **MTTR Target** | 5 minutes (rollback execution time) |
| **On-Call** | Yes — Notify immediately via Slack + PagerDuty |
| **Escalation** | VP Engineering if unable to rollback within 5 minutes |

---

## Overview

This runbook provides fast rollback procedures when a deployment fails or introduces critical bugs. The goal is to restore service within 5 minutes using either Vercel UI promotion or Git revert.

**When to use this runbook:**

- Deployment shows "Failed" status in Vercel dashboard
- Health endpoint returns 500 immediately after deployment
- Build logs show compilation/type errors
- All routes return 500 errors after deployment
- Users report complete site breakage

**When NOT to use this runbook:**

- Gradual degradation (use [service degradation runbook](./rbk-portfolio-service-degradation.md))
- Performance issues without errors (use [performance troubleshooting](./rbk-portfolio-performance-troubleshooting.md))
- Partial feature unavailability (use service degradation runbook)

---

## Failure Indicators

### How to Detect Deployment Failure

#### 1. Vercel Dashboard Indicators

**Build Failure (pre-deployment):**

- Deployment status: ❌ "Failed" (red X icon)
- Build logs contain error messages
- No production URL generated
- Previous deployment still live (good — no user impact yet)

**Runtime Failure (post-deployment):**

- Deployment status: ✅ "Ready" (green checkmark) BUT
- Health endpoint returns 500
- Routes return 500 errors
- Error logs spike immediately after deployment

#### 2. Automated Alerts

- Health check monitoring: Returns 500 status
- Error rate alert: >50% of requests return 5xx
- Uptime monitor: Site unresponsive or returns errors

#### 3. User Reports

- "Your site is completely broken"
- "I'm getting an error page on every link"
- "Portfolio app shows 'Something went wrong'"

#### 4. Manual Health Check

```bash
# Test health endpoint
curl -s https://portfolio-app.vercel.app/api/health

# If returns {"status":"unhealthy","error":"..."}
# OR if curl fails with connection error
# → Deployment failure confirmed
```

---

## Response Procedure

### Phase 1: Triage (1 minute)

**Objective:** Confirm deployment failure and identify last known good deployment.

#### Step 1: Check Vercel Deployments Page

1. Go to [Vercel Deployments](https://vercel.com/bryce-seefieldts-projects/portfolio-app/deployments)
2. Identify most recent deployment
3. Check status:
   - ❌ Red X = Build failed (good — not deployed yet)
   - ✅ Green checkmark = Build succeeded (check if runtime error)

#### Step 2: Verify Health Endpoint

```bash
# Test production health
curl -s https://portfolio-app.vercel.app/api/health | jq '.'

# Possible outcomes:
# 1. {"status":"healthy"} → False alarm, deployment is fine
# 2. {"status":"unhealthy","error":"..."} → Confirmed runtime failure
# 3. Connection timeout/error → Confirmed deployment failure
```

**Decision tree:**

| Health Check Result | Action |
|---------------------|--------|
| Returns `status: "healthy"` | **STOP.** Deployment is fine. Investigate other cause. |
| Returns `status: "unhealthy"` (500) | **Continue to rollback** (runtime failure) |
| Connection timeout or DNS error | **Continue to rollback** (deployment completely broken) |
| Returns `status: "degraded"` (503) | Use [service degradation runbook](./rbk-portfolio-service-degradation.md) instead |

#### Step 3: Identify Last Known Good Deployment

In Vercel Deployments page:

1. Scroll down to find most recent deployment with green checkmark ✅
2. **Verify it's truly good:** Click deployment → Click "Visit" → Test health endpoint
3. Note the commit SHA and deployment URL

```bash
# Example: Verify previous deployment is healthy
curl -s https://portfolio-app-<unique-id>.vercel.app/api/health | jq '.status'

# Expected: "healthy"
```

#### Step 4: Assess Failure Type

**Build Failure (preferred — no user impact):**

- Build logs show TypeScript errors, lint failures, or missing dependencies
- Deployment never went live
- Previous deployment still serving traffic
- **Impact:** None (broken code never deployed)

**Runtime Failure (user-impacting):**

- Build succeeded but application crashes at startup
- Health endpoint returns 500 or times out
- Routes return "Application Error" page
- **Impact:** High (users see broken site)

---

### Phase 2: Immediate Containment (1 minute)

**Objective:** Prevent further deployments and notify team.

#### Step 1: Halt Deployments

Post to deployment channel immediately:

```
🛑 DEPLOYMENT HOLD

Reason: Deployment failure detected (INC-20260126-002)
Affected: portfolio-app production
Status: ROLLING BACK
ETA: 5 minutes

DO NOT merge or push to main until all-clear posted.
```

#### Step 2: Notify Incident Channel

Post to Slack `#incidents`:

```
🔴 INCIDENT: Portfolio App Deployment Failure

Incident ID: INC-20260126-002
Severity: SEV-2 (High)
Started: 2026-01-26 15:45 UTC
Impact: Complete service unavailability
Assigned: @oncall-engineer

Action: Executing rollback to last known good deployment
MTTR Target: 5 minutes
Next update: 2 minutes
```

---

### Phase 3: Execute Rollback (2–3 minutes)

**Objective:** Restore service by promoting last known good deployment or reverting code.

Two rollback options available (choose fastest):

#### Option 1: Vercel UI Rollback (FASTEST — Recommended)

**When to use:** Runtime failure; previous deployment still exists in Vercel

**Steps:**

1. Go to [Vercel Deployments](https://vercel.com/bryce-seefieldts-projects/portfolio-app/deployments)
2. Find last known good deployment (verified in Phase 1, Step 3)
3. Click on that deployment row
4. Click **"Promote to Production"** button (top right)
5. Confirm: "Yes, promote this deployment"
6. Wait for promotion to complete (~30 seconds)
7. **Verify immediately:**
   ```bash
   curl -s https://portfolio-app.vercel.app/api/health | jq '.status'
   # Expected: "healthy"
   ```

**MTTR:** ~2 minutes (navigate UI + promote + verify)

**Pros:**

- Fastest method (no code changes)
- Instant rollback (30 seconds)
- No Git history pollution

**Cons:**

- Requires Vercel dashboard access
- Doesn't fix underlying code issue (still needs separate fix)

#### Option 2: Git Revert Rollback (Fallback)

**When to use:**

- Vercel UI rollback unavailable
- Need to permanently revert broken commit from Git history
- Build failure (no deployment to promote)

**Steps:**

```bash
# 1. Identify broken commit
git log --oneline | head -5

# Example output:
# abc1234 (HEAD -> main) feat: add broken feature  ← This is broken
# def5678 docs: update README                     ← Last known good
# ghi9012 feat: performance improvements

# 2. Revert the broken commit
git revert abc1234 --no-edit

# This creates a new commit that undoes abc1234

# 3. Push revert commit
git push origin main

# 4. Wait for Vercel auto-deploy (~2 minutes)
# Monitor deployment: https://vercel.com/bryce-seefieldts-projects/portfolio-app/deployments

# 5. Verify health check
curl -s https://portfolio-app.vercel.app/api/health | jq '.status'
# Expected: "healthy"
```

**MTTR:** ~3–4 minutes (revert + push + Vercel deploy + verify)

**Pros:**

- Fixes code permanently (revert commit stays in history)
- Works even if Vercel UI unavailable
- Clear audit trail in Git

**Cons:**

- Slower than Vercel UI promotion
- Requires Git command line access
- Pollutes Git history with revert commits

---

### Phase 4: Verification (1–2 minutes)

**Objective:** Confirm rollback was successful and service is fully restored.

#### Verification Checklist

- [ ] **Health check returns 200 (healthy):**
  ```bash
  curl -s https://portfolio-app.vercel.app/api/health | jq '.status'
  # Expected: "healthy"
  ```

- [ ] **Vercel Deployments shows latest as "Ready":**
  - Green checkmark ✅ on most recent deployment
  - No error logs in function logs

- [ ] **Homepage accessible (no 500s):**
  ```bash
  curl -I https://portfolio-app.vercel.app/ | grep HTTP
  # Expected: HTTP/2 200
  ```

- [ ] **Projects page loads:**
  ```bash
  curl -I https://portfolio-app.vercel.app/projects | grep HTTP
  # Expected: HTTP/2 200
  ```

- [ ] **No new errors in logs (last 2 minutes):**
  - Check Vercel Dashboard → Functions → Logs
  - Filter: Last 2 minutes
  - Search: "error" (should be empty or only historical)

#### All-Clear Notification

Once all checks pass, post to incident and deployment channels:

```
✅ RESOLVED: Portfolio App Deployment Failure

Incident ID: INC-20260126-002
Resolution Time: 4 minutes (MTTR target: 5 min ✓)
Rollback Method: Vercel UI promotion to deployment <deployment-id>
Root Cause: [TBD — pending investigation]

Status: All routes operational, health check returns 200
Impact: 4 minutes complete service unavailability
Deployments: UNFROZEN — normal deployments can resume

Next Steps: Root cause investigation and fix (async)
Postmortem: Scheduled for 2026-01-27 10:00 UTC
```

---

## Post-Failure Investigation (Async, within 2 hours)

**Objective:** Understand what went wrong and prevent recurrence.

### Step 1: Examine Build Logs

For build failures:

1. Go to [Vercel Deployments](https://vercel.com/bryce-seefieldts-projects/portfolio-app/deployments)
2. Click failed deployment
3. Click "Building" tab → View build logs
4. Search for error keywords: `error`, `Error:`, `failed`, `FAILED`

**Common error patterns:**

| Error Message | Root Cause | Prevention |
|---------------|------------|------------|
| `TS2304: Cannot find name 'X'` | TypeScript type error | Add pre-commit `pnpm typecheck` |
| `Module not found: Can't resolve 'X'` | Missing dependency | Run `pnpm install` before commit |
| `ESLint: X errors, Y warnings` | Linting failure | Add pre-commit `pnpm lint` |
| `Out of memory` | Build too large or infinite loop | Investigate bundle size or build script |

### Step 2: Examine Broken Commit

```bash
# View files changed in broken commit
git show <broken-commit-sha> --stat

# Review actual code changes
git show <broken-commit-sha>

# Identify suspicious changes
```

**Root cause categories:**

1. **Code Issue:** Syntax error, missing import, logic error causing crash
2. **Dependency Issue:** Missing or conflicting package, version incompatibility
3. **Environment Issue:** Missing environment variable, changed config
4. **Tooling Issue:** TypeScript version, Next.js version, build tool issue

### Step 3: Reproduce Locally

```bash
# Check out broken commit
git checkout <broken-commit-sha>

# Install dependencies
pnpm install

# Try to build
pnpm build

# Expected: Same error as Vercel build

# If build succeeds locally but fails in Vercel:
# → Environment difference (Node version, env vars, etc.)
```

---

## Implement Fix & Redeploy (Async)

### Step 1: Fix the Issue

Create a fix branch:

```bash
# Return to main (which now has rollback)
git checkout main
git pull

# Create fix branch
git checkout -b fix/deployment-failure-<issue-number>

# Implement fix (e.g., fix TypeScript error)
# Edit files...

# Test locally
pnpm verify

# Expected: All checks pass
```

### Step 2: Commit and Push

```bash
# Commit fix
git add .
git commit -m "fix: resolve deployment failure - <brief description>

Root cause: <explanation>
Fix: <what was changed>

Refs: INC-20260126-002"

# Push fix branch
git push origin fix/deployment-failure-<issue-number>
```

### Step 3: Create PR and Get Review

```bash
# Create PR via GitHub CLI
gh pr create \
  --title "fix: resolve deployment failure - <description>" \
  --body "## Problem
Deployment failed due to <root cause>.

## Solution
<fix description>

## Testing
- [x] pnpm verify passes
- [x] Build succeeds locally
- [x] Health check tested

## Incident Reference
Refs: INC-20260126-002

## Reviewers
@team-lead" \
  --label "bug,hotfix,incident-followup"
```

**PR requirements:**

- All CI checks must pass (pnpm lint, typecheck, build)
- Code review approved by team lead
- Test evidence included in PR description

### Step 4: Merge and Deploy

```bash
# Once approved, merge PR
gh pr merge --squash --delete-branch

# Vercel auto-deploys on merge to main
# Monitor deployment progress
```

### Step 5: Verify Fix Deployed

```bash
# Wait ~2 minutes for deployment

# Check health
curl -s https://portfolio-app.vercel.app/api/health | jq '.'

# Verify fix is live (check commit SHA)
curl -s https://portfolio-app.vercel.app/api/health | jq '.commit'

# Expected: Shows new commit SHA (not rollback commit)
```

---

## Postmortem (Within 24 hours)

**Template:** [`docs/_meta/templates/template-postmortem.md`](https://github.com/bryce-seefieldt/portfolio-docs/tree/main/docs/_meta/templates/template-postmortem.md)

**Required preventive actions examples:**

1. **Action:** Add `pnpm typecheck` to required CI checks (if TypeScript error)
2. **Action:** Add pre-commit hook to run `pnpm lint` (if linting error)
3. **Action:** Add automated health check after deployment (Vercel Deployment Checks)
4. **Action:** Add build test step before merge (GitHub Actions)

---

## Common Deployment Failures & Quick Fixes

### Failure 1: TypeScript Type Error

**Build log:**

```
Error: src/app/page.tsx:25:10 - error TS2304: Cannot find name 'Project'.
```

**Cause:** Missing type import or typo in type name  
**Prevention:** Add `pnpm typecheck` to CI required checks  
**Quick fix:** Add missing import, fix typo, redeploy

### Failure 2: Missing Dependency

**Build log:**

```
Error: Module not found: Can't resolve '@/lib/new-module'
```

**Cause:** Imported module not installed in package.json  
**Prevention:** Always run `pnpm install <package>` before using  
**Quick fix:** `pnpm install <package>`, commit lockfile, redeploy

### Failure 3: Environment Variable Missing

**Runtime error in logs:**

```json
{
  "level": "error",
  "message": "Config error",
  "context": {"error": "NEXT_PUBLIC_NEW_VAR is not defined"}
}
```

**Cause:** New env var referenced in code but not set in Vercel  
**Prevention:** Document env var requirements in PR, verify in deployment checklist  
**Quick fix:** Add env var in Vercel settings, redeploy

---

## Escalation

| Duration | Action | Notify |
|----------|--------|--------|
| **0–5 min** | Execute rollback (this runbook) | On-call engineer only |
| **5–15 min** | Escalate if rollback fails | VP Engineering via Slack + PagerDuty |
| **>15 min** | Full team escalation | All team + CEO (if customer-facing) |

---

## Tools & References

### Quick Commands

```bash
# Health check
curl -s https://portfolio-app.vercel.app/api/health | jq '.'

# Git revert
git revert <commit-sha> --no-edit && git push

# View deployment logs (requires Vercel CLI)
vercel logs <deployment-url>

# Check latest deployment status
vercel ls | head -5
```

### External Links

- [Vercel Deployments](https://vercel.com/bryce-seefieldts-projects/portfolio-app/deployments)
- [Observability Documentation](https://github.com/bryce-seefieldt/portfolio-docs/tree/main/docs/60-projects/portfolio-app/08-observability.md)

### Related Runbooks

- [Service Degradation Recovery](./rbk-portfolio-service-degradation.md)
- [General Incident Response](./rbk-portfolio-incident-response.md)

---

**Last Updated:** 2026-01-26  
**Maintained By:** Portfolio Operations Team  
**Review Schedule:** After each deployment failure + quarterly
