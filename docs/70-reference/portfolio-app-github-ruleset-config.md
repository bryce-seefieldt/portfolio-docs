---
title: 'GitHub Ruleset Configuration for Portfolio App'
description: 'Step-by-step guide to configure GitHub branch protection rulesets for portfolio-app main branch, enforcing CI checks and PR reviews.'
sidebar_position: 2
tags: [reference, github, rulesets, branch-protection, governance, cicd]
---

## Overview

This guide configures GitHub branch protection **rulesets** to enforce:

- Required CI checks (`ci / quality`, `ci / build`) before merge
- Required PR review
- Block force-push and branch deletion
- Automatic stale review dismissal

This implements the governance model described in [ADR-0008: Portfolio App CI Quality Gates](../../../10-architecture/adr/adr-0008-portfolio-app-ci-quality-gates.md).

## Prerequisites

- Admin access to `bryce-seefieldt/portfolio-app` repository
- CI workflows (`ci.yml`) already deployed and executing
- Understanding of GitHub ruleset concepts (vs. legacy branch protection)

## Step-by-Step Configuration

### Step 1: Navigate to Rulesets

**In GitHub:**

1. Go to `portfolio-app` repository
2. Navigate to **Settings** (top navigation)
3. In left sidebar, find **"Rules"** → **"Rulesets"**
4. Click **"New ruleset"** → **"New branch ruleset"**

### Step 2: Name and Enable the Ruleset

| Field | Value |
|-------|-------|
| **Ruleset name** | `main-protection` |
| **Enforcement** | **Active** (not disabled or in "evaluate" mode) |

### Step 3: Define Target Branch

**Targeting rules:**

1. Click **"Add targeting rule"** (if not already present)
2. Select:
   - **Operator:** `Branch name is`
   - **Value:** `main`
3. Confirm the target shows: `Branch name matches main`

:::info
This ensures the ruleset applies only to the `main` branch. Other branches remain unrestricted for experimentation.
:::

### Step 4: Add Required Status Checks

**In the ruleset editor:**

1. Scroll to **"Require status checks to pass before merging"**
2. Click **"Add checks"**
3. From the dropdown list, select:
   - ✅ `ci / quality`
   - ✅ `ci / build`
4. Leave **"Require branches to be up to date before merging"** **ON** (recommended)

:::warning
If checks don't appear in the dropdown, ensure:
- The CI workflow (`ci.yml`) has been executed at least once
- Check names in the workflow match exactly: `name: quality` and `name: build`
- The latest commit on `main` has successful check results
:::

**Outcome:** Both checks must be green before merge is allowed.

### Step 5: Add Require Pull Request Review

**In the ruleset editor:**

1. Scroll to **"Require pull request reviews before merging"**
2. Click to enable
3. Configure:

| Setting | Value | Notes |
|---------|-------|-------|
| **Required reviewers** | `1` | At minimum, one approval required |
| **Require code owners review** | (optional) | Disable for now; can add later with CODEOWNERS file |
| **Dismiss stale reviews** | **ON** | Auto-dismiss approvals when new commits are pushed |
| **Require review from code owner** | (optional) | Disable |

**Outcome:** At least one reviewer must approve before merge.

### Step 6: Add Block Force-Push and Deletions (Optional but Recommended)

These prevent accidental or malicious damage:

1. Scroll to **"Restrict who can push to matching branches"** (optional)
   - Can restrict to specific roles; for MVP, skip and rely on other protections

2. Enable **"Block force pushes"**
   - Prevents overwriting history

3. Enable **"Block deletions"**
   - Prevents accidental `git push --delete origin main`

**Outcome:** `main` branch is immutable except through PR merges.

### Step 7: Review and Save

**Before saving, verify:**

- [ ] Ruleset name: `main-protection`
- [ ] Enforcement: **Active**
- [ ] Target: `main` branch
- [ ] Required checks: `ci / quality` and `ci / build`
- [ ] PR review required: 1 approval
- [ ] Stale review dismissal: **ON**
- [ ] Force-push blocked: **ON**
- [ ] Deletions blocked: **ON**

Click **"Create"** to save the ruleset.

**Outcome:** Ruleset is now active. All merges to `main` must satisfy these rules.

## Validation

### Test 1: Verify checks are required

1. Create a test PR (any branch to `main`)
2. Make a trivial change (e.g., update README)
3. Push and open PR on GitHub
4. **Expected result:**
   - PR shows "Waiting for status checks" status check
   - Merge button is **disabled** until checks pass
   - After checks pass, merge button is **enabled**

### Test 2: Verify review is required

1. With a test PR (checks passing)
2. Attempt to merge without any approvals
3. **Expected result:**
   - Merge button is **disabled** with message: "This branch requires at least 1 approval"
4. Request review from another user or use your own account (if not author)
5. Approve the PR
6. **Expected result:**
   - Merge button is now **enabled**

### Test 3: Verify force-push is blocked

1. Locally, attempt to force-push to `main`:
   ```bash
   git push --force origin main
   ```
2. **Expected result:**
   - Push is rejected: `remote: error: GH006: Protected branch update failed`

### Test 4: Verify stale review dismissal

1. With an approved PR (1 approval)
2. Push another commit to the PR branch
3. **Expected result:**
   - Approval is automatically dismissed
   - PR shows "Changes requested since last review" or "Review required"
   - Merge button is disabled again until new approval

## Troubleshooting

### Merge button stays disabled even after checks pass

**Possible causes:**

1. **Checks not actually passing:**
   - Click the checks tab and verify both `ci / quality` and `ci / build` show green ✅

2. **Ruleset not active:**
   - Go to **Settings** → **Rules** → **Rulesets**
   - Verify `main-protection` shows **Enforcement: Active** (not "Evaluate" or "Disabled")

3. **Check names don't match:**
   - In ruleset, verify the imported checks match exactly: `ci / quality`, `ci / build`
   - In workflow, verify job names are exactly `quality` and `build`

4. **Other rulesets conflicting:**
   - Check if there are multiple rulesets targeting `main`
   - Consolidate into a single ruleset or ensure they align

### Force-push still works

**Cause:** Ruleset is in "Evaluate" mode or is disabled.

**Fix:**
- Go to **Settings** → **Rules** → **Rulesets**
- Click `main-protection`
- Set **Enforcement** to **Active**
- Save

### "This branch has 1 rules preventing it from being merged"

**Diagnosis:** One of the required rules is not satisfied.

**Steps:**
1. Read the full error message to see which rule failed
2. Common causes:
   - CI checks not passing → wait for checks or fix errors
   - Review not approved → request review and get approval
   - Branch not up to date → click "Update branch" in PR

---

## Related Artifacts

- [ADR-0008: Portfolio App CI Quality Gates](../../../10-architecture/adr/adr-0008-portfolio-app-ci-quality-gates.md)
- [ADR-0007: Portfolio App Hosting on Vercel](../../../10-architecture/adr/adr-0007-portfolio-app-hosting-vercel-with-promotion-checks.md)
- [Vercel Setup Runbook](../../../50-operations/runbooks/rbk-vercel-setup-and-promotion-validation.md)
- [Portfolio App Deployment Dossier](../../../60-projects/portfolio-app/03-deployment.md)
- [GitHub Rulesets Documentation](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets)

---

## Quick Reference

**To update or delete this ruleset later:**

1. Go to **Settings** → **Rules** → **Rulesets**
2. Click on `main-protection`
3. Make changes or click **"Delete ruleset"**
4. Save or confirm deletion

**To temporarily disable (not recommended):**

1. Click `main-protection`
2. Set **Enforcement** to **Disabled** or **Evaluate**
3. Save

(Re-enable after testing or debugging.)
