---
title: 'Runbook: Portfolio App Secrets Incident Response'
description: 'Deterministic procedure for responding to suspected secrets publication or exfiltration in the Portfolio App.'
sidebar_position: 7
tags: [operations, runbook, portfolio-app, incident-response, security, secrets]
---

## Purpose

Provide a fast and reproducible procedure to respond to suspected secrets publication or exfiltration in the Portfolio App, aligning with threat model incident response procedures.

This is a **"stop-the-line" incident** requiring immediate action to:

- Contain exposure
- Audit what was leaked
- Rotate compromised credentials
- Prevent recurrence

## Governance Context

This runbook implements the threat model's [Incident Response / Suspected secret publication](/docs/40-security/threat-models/portfolio-app-threat-model.md#incident-response) procedure. All actions assume:

- GitHub Actions logs are retained and auditable
- Vercel deployments are immutable and traceable to Git commits
- Git is the system of record for rollback and audit

Related runbooks:

- [rbk-portfolio-rollback.md](./rbk-portfolio-rollback.md) — fast revert using Git
- [rbk-portfolio-ci-triage.md](./rbk-portfolio-ci-triage.md) — CI failure investigation

## Scope

### Use when

- **Suspected hardcoded secrets:** A developer discovers (or suspects) a secret (API key, token, password) was committed to the repository
- **Suspected publication:** A secret may have been published in a PR, commit message, env var log, or Vercel log
- **Detected by scanning:** The secrets scanning gate (CI, pre-commit, or manual scan) detects a leak
- **Third-party report:** An external party reports a suspected leak

### Do not use when

- The issue is unrelated to secrets (use relevant operational runbooks or incident procedures)

## Severity Levels

| Level        | Definition                                                     | Response Time | Examples                                                                          |
| ------------ | -------------------------------------------------------------- | ------------- | --------------------------------------------------------------------------------- |
| **Critical** | High-value secret exposed to public repo or logs               | **≤5 min**    | API tokens, deployment credentials, private SSH keys                              |
| **High**     | Moderate-value secret exposed; limited public visibility       | **≤30 min**   | Internal service URLs, personal email addresses, staging credentials              |
| **Medium**   | Low-value secret or limited exposure; internal-only visibility | **≤2 hrs**    | Public URLs, version numbers, generic comments containing "password" but no value |

## Prereqs / Inputs

- Access:
  - Ability to create and merge rollback PRs to `main`
  - Access to GitHub Actions logs
  - Access to Vercel deployment logs
- Tools:
  - git, pnpm, curl (for verification)
- Context:
  - Suspected secret details (what was leaked, when, where)
  - Affected systems (if known)

## Procedure / Content

### Phase 0: Triage (≤5 min)

Determine severity and containment strategy.

#### 0a) Identify and assess the leak

1. **What was leaked?**
   - Hardcoded secret (API key, token, password, SSH key)?
   - Internal URL or service endpoint?
   - Personal information (email, phone)?
   - Misconfigured env var logging?

2. **Where was it exposed?**
   - Committed to Git repository (check `git log --all -p | grep "SECRET"` locally)
   - Visible in PR or GitHub UI?
   - In CI logs (GitHub Actions, Vercel)?
   - In deployed artifact or public site?
   - Duration of exposure?

3. **Assess severity:**
   - **Critical:** High-value credential (deployment token, prod DB password) + public exposure → Proceed to **Phase 1: Emergency Contain (≤5 min)**
   - **High:** Moderate credential (staging API key) + limited exposure → **Phase 1: Emergency Contain (≤30 min)**
   - **Medium:** Low-value secret or limited exposure → **Phase 1: Emergency Contain (≤2 hrs)**

#### 0b) Notify (if needed)

- **Critical:** Immediately notify owner/team
- **High:** Notify team within 15 min
- **Medium:** Document incident; notify at next sync

---

### Phase 1: Emergency Contain (≤5 min for Critical)

**Goal:** Stop the leak; make the secret inaccessible.

#### 1a) Immediate actions (do these first)

**For leaked API keys, tokens, or deployment credentials:**

1. **Rotate the credential immediately** (if you have access):

   ```bash
   # Example: Vercel API token rotation
   # 1. Go to https://vercel.com/account/tokens
   # 2. Find the leaked token
   # 3. Revoke it immediately
   # 4. Generate a new token
   # 5. Update GitHub Secrets with the new token
   ```

2. **Revoke access if applicable:**
   - GitHub: Rotate PAT tokens, revoke SSH keys
   - Vercel: Revoke deployment tokens
   - Third-party services: Revoke leaked API keys

3. **If deployed to production:** Immediately rollback using [rbk-portfolio-rollback.md](./rbk-portfolio-rollback.md)
   ```bash
   git checkout main
   git pull
   git log --oneline main | head -20  # Find last known good commit
   git checkout -b ops/portfolio-secrets-incident-rollback
   git revert <leaked-commit-sha>  # Revert the offending commit
   git push origin ops/portfolio-secrets-incident-rollback
   # Open PR, wait for checks, merge
   ```

---

### Phase 2: Investigation (5–30 min)

**Goal:** Determine scope, timeline, and exposure duration.

#### 2a) Identify the leak source

1. **Check Git history:**

   ```bash
   git log --all -p -- src/ | grep -i "SECRET\|TOKEN\|KEY\|PASSWORD"
   git log --all --name-status | grep -E ".env|secrets|config"
   ```

2. **Check CI logs:**
   - GitHub Actions: Navigate to PR or commit in GitHub → Actions tab
   - Look for steps that printed env vars or config
   - Note timestamps

3. **Check Vercel logs:**
   - Vercel dashboard → Deployment → Logs
   - Verify whether prod or preview deployed with leaked secret

#### 2b) Timeline of exposure

1. **When was it committed?**

   ```bash
   git log --all --oneline --grep="<commit-message>" | head -5
   ```

2. **When was it deployed?**
   - Check Vercel deployment history
   - Cross-reference with GitHub Actions run

3. **How long was it publicly visible?**
   - From deployment time to now
   - Was it in a PR or only in `main`?

#### 2c) What was potentially accessed?

- **If API key leaked:** Query service logs for suspicious access during exposure window
- **If deployment token leaked:** Check Vercel deployment history for unauthorized deploys
- **If GitHub token leaked:** Check GitHub Actions logs for unexpected runs

---

### Phase 3: Remediation (15–60 min)

**Goal:** Remove the leak; update systems; prevent recurrence.

#### 3a) Remove the secret from Git history

⚠️ **Important:** Simply committing a removal is not enough. The secret remains in Git history.

**Option 1: Use `git filter-repo` (recommended for large repos)**

```bash
# Install git-filter-repo if not present
pip install git-filter-repo

# Remove the file from all history
git filter-repo --path .env.local --invert-paths

# Or remove specific patterns
git filter-repo --replace-text <(echo 'SECRET_KEY=abc123==>SECRET_KEY=REMOVED')

# Force-push (requires repository admin access)
git push --force-all
```

⚠️ **Warning:** Force-pushing rewrites history. All collaborators must update local clones.

**Option 2: Commit a removal (if secret already rotated)**

```bash
# If the secret is already rotated/invalidated, a normal commit is acceptable
git rm .env.local  # or edit .env.local to remove the value
git commit -m "fix: remove leaked secret from .env.local (already rotated)"
git push origin main
```

#### 3b) Rotate all potentially exposed credentials

1. **GitHub Secrets:** Update with new values
2. **Vercel Environment Variables:** Update and redeploy
3. **Third-party services:** Rotate API keys, tokens, etc.

#### 3c) Update `.env.example` to prevent recurrence

Ensure `.env.example` does NOT contain real values:

```bash
# Verify .env.example has no real secrets
cat .env.example | grep -i "SECRET\|TOKEN\|KEY" || echo "✓ No real secrets in .env.example"
```

#### 3d) Audit `.gitignore`

Ensure sensitive files are ignored:

```bash
# Verify .env.local is gitignored
grep ".env.local\|.env.*.local" .gitignore || echo "⚠️ Warning: .env.local not in .gitignore"
```

---

### Phase 4: Validation (5–10 min)

**Goal:** Confirm the leak is contained and systems are healthy.

#### 4a) Verify the secret is no longer in Git

```bash
git log --all -p | grep "SECRET_KEY=abc123" || echo "✓ Secret not found in history"
```

#### 4b) Verify CI is passing with new credentials

```bash
# Push a test commit to main
git log --oneline main | head -1  # Note the commit
# Check GitHub Actions workflow status
# Verify CI/CD jobs complete successfully
```

#### 4c) Verify Vercel deployment is healthy

```bash
curl -I https://<portfolio-domain>/
# Confirm 200 OK, no 500 errors
```

#### 4d) Verify environment variables

```bash
# Check Vercel dashboard: Settings → Environment Variables
# Confirm no real secrets are visible in plaintext
```

---

### Phase 5: Post-Incident Postmortem (30 min–1 hr)

**Goal:** Document what happened and prevent recurrence.

#### 5a) Create a postmortem document

Create `docs/_meta/postmortem-YYYY-MM-DD-secrets-incident.md`:

```markdown
# Postmortem: Secrets Incident — YYYY-MM-DD

## Timeline

- **HH:MM UTC:** Secret committed to repository
- **HH:MM UTC:** Deployed to production (or caught by scanning)
- **HH:MM UTC:** Incident detected/reported
- **HH:MM UTC:** Rollback completed
- **HH:MM UTC:** Credential rotated
- **HH:MM UTC:** History rewritten/cleaned

## What went wrong?

- Developer accidentally committed `.env.local` or hardcoded a secret
- Pre-commit hook was not active / not catching the secret
- CI secrets scanning was not yet enabled (if Phase 2 enhancement not complete)
- Manual review missed the secret in PR

## Impact

- Credential type: [e.g., Vercel API token]
- Duration of exposure: [e.g., 15 minutes]
- Potential unauthorized access: [e.g., one deployment made during exposure]

## Fixes Applied

1. ✅ Credential rotated immediately
2. ✅ Commit reverted / history cleaned
3. ✅ Pre-commit hook enabled locally
4. ✅ CI secrets scanning gate added
5. ✅ Team trained on secrets handling

## Prevention

### Short-term (done)

- [ ] Pre-commit hook enabled (`git config core.hooksPath .git/hooks`)
- [ ] CI secrets scanning gate enabled (TruffleHog in workflow)
- [ ] Team notified; best practices refreshed

### Medium-term (Phase 2+)

- [ ] Add GitHub's native secrets scanning (if not already enabled)
- [ ] Rotate all long-lived tokens to short-lived / OIDC
- [ ] Review and tighten `.env.example` and `.gitignore`

### Long-term (Phase 3+)

- [ ] Centralized secrets management (e.g., AWS Secrets Manager)
- [ ] Automated secret rotation policies

## Lessons Learned

- **What we did well:** Detected quickly; rotated immediately
- **What we could improve:** Pre-commit hook should have caught this; manual review process could include a checklist

## Owner

- Incident lead: [name]
- Date: YYYY-MM-DD
- Status: Closed (date)
```

#### 5b) Update threat model (if needed)

If the incident reveals a new threat or mitigation gap, update [portfolio-app-threat-model.md](/docs/40-security/threat-models/portfolio-app-threat-model.md):

1. Add the threat if not already covered
2. Document new mitigations
3. Update next-review date

#### 5c) Update runbooks

1. Add this scenario to runbook if it's not clear
2. Clarify decision points or procedures
3. Update timelines based on actual incident

#### 5d) Close the incident

1. Mark postmortem as closed
2. Update Issue #24 (Phase 2 planning) if relevant
3. Consider ADR if policy changes needed

---

## Escalation & Support

### Cannot rotate the credential?

- **GitHub token:** Contact GitHub Support
- **Vercel token:** Contact Vercel Support
- **Third-party API key:** Contact the service provider immediately

### Uncertain if the secret was truly exposed?

- Assume it was exposed (conservatively assume worst-case)
- Rotate immediately; investigate after

### Need help?

- Refer to threat model: [Incident Response](/docs/40-security/threat-models/portfolio-app-threat-model.md#incident-response)
- Refer to rollback runbook: [rbk-portfolio-rollback.md](./rbk-portfolio-rollback.md)
- Consult team / escalate if severity is unclear

---

## Checklists

### Critical Incident Checklist (≤5 min)

- [ ] Triage: Confirmed severity = Critical
- [ ] Rotate credential immediately
- [ ] Rollback deployment (if deployed)
- [ ] Notify team
- [ ] Proceed to Investigation phase

### Investigation Checklist (5–30 min)

- [ ] Identified what was leaked
- [ ] Identified when/where it was exposed
- [ ] Confirmed timeline of exposure
- [ ] Checked for unauthorized access

### Remediation Checklist (15–60 min)

- [ ] Removed secret from Git history
- [ ] Rotated all affected credentials
- [ ] Updated `.env.example`
- [ ] Verified `.gitignore`
- [ ] CI/CD passing with new credentials

### Validation Checklist (5–10 min)

- [ ] Secret not found in `git log`
- [ ] CI is passing
- [ ] Vercel deployment is healthy
- [ ] Environment variables updated

### Postmortem Checklist (30 min–1 hr)

- [ ] Postmortem document created
- [ ] Timeline documented
- [ ] Root cause identified
- [ ] Fixes applied and validated
- [ ] Prevention measures recorded
- [ ] Team trained / notified
- [ ] Incident closed

---

## References

- Threat Model: [Incident Response](/docs/40-security/threat-models/portfolio-app-threat-model.md#incident-response)
- Rollback Runbook: [rbk-portfolio-rollback.md](./rbk-portfolio-rollback.md)
- CI Triage Runbook: [rbk-portfolio-ci-triage.md](./rbk-portfolio-ci-triage.md)
- Phase 2 Implementation: [phase-2-implementation-guide.md](/docs/00-portfolio/roadmap/phase-2-implementation-guide.md)
