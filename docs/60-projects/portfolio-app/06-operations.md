---
title: 'Portfolio App: Operations'
description: 'Operational posture for the Portfolio App: deploy/rollback expectations, maintenance cadence, and recovery assumptions for a public portfolio service.'
sidebar_position: 6
tags: [projects, operations, runbooks, reliability, maintenance, portfolio]
---

## Purpose

Document how the Portfolio App is operated like a production service:

- deploy/rollback readiness
- maintenance and dependency update discipline
- recovery posture (Git as system of record)
- operational credibility for reviewers

## Scope

### In scope

- required runbooks and minimum content
- maintenance cadence
- recovery posture and DR assumptions
- operational ownership model

### Out of scope

- vendor-specific account details
- incident postmortems (separate artifact type)

## Prereqs / Inputs

- CI/CD exists and deploys from `main`
- Vercel preview/prod deployments are functioning
- quality gates are enforced in CI and (optionally) promotion checks

## Security Operations & Incident Response (Stage 4.4)

Security incidents follow structured runbooks for deterministic response:

**Runbooks:**

- **[Dependency Vulnerability Response](/docs/50-operations/runbooks/rbk-portfolio-dependency-vulnerability.md)** — Detect, triage, and remediate CVEs with MTTR targets (Critical: 24h, High: 48h, Medium: 2 weeks, Low: 4 weeks)
- **[Secrets Incident Response](/docs/50-operations/runbooks/rbk-portfolio-secrets-incident.md)** — Contain and investigate suspected secret leaks; rotate credentials; prevent recurrence

**Policies:**

- **[Security Policies & Governance](/docs/40-security/security-policies.md)** — Formal policies for dependency audit, secrets management, security headers, and incident response
- **[Risk Register](/docs/40-security/risk-register.md)** — Inventory of known risks with severity, mitigations, and acceptance status

**MTTR Targets & Escalation:**

If MTTR targets are at risk, escalate to team lead immediately. Document all incidents in postmortem template (see runbooks).

## Quick Reference: Three-Tier Deployment Workflow

**Local Development → PR Review → Staging Validation → Production**

| Phase                        | Branch                          | Action                                                                             | Validation                                                   |
| ---------------------------- | ------------------------------- | ---------------------------------------------------------------------------------- | ------------------------------------------------------------ |
| **1. Development**           | `feat/your-feature`             | Create feature branch, make changes, run `pnpm verify` locally                     | Pass local validation                                        |
| **2. PR Review**             | `feat/your-feature` → `staging` | Open PR targeting `staging` (not `main`), get approval                             | CI checks pass, Vercel preview works                         |
| **3. Merge to Staging**      | `staging`                       | Merge PR to staging branch                                                         | Auto-deploy to staging domain                                |
| **4. Staging Validation**    | `staging`                       | Manual validation of critical routes on `https://staging-bns-portfolio.vercel.app` | All routes load, evidence links work, no console errors      |
| **5. Promote to Production** | `staging` → `main`              | Merge staging to main (manual decision point)                                      | Auto-deploy to production `https://bns-portfolio.vercel.app` |

**Key Rules:**

- ✅ Always open PRs **targeting `staging` branch** (not `main`)
- ✅ **Staging validation is mandatory** before production is considered complete
- ✅ Production deploys automatically after CI passes on `main`
- ✅ Use hotfix PRs or rollback if staging validation fails
- ✅ Keep `staging` in sync with `main` (never commit directly to staging)

**Quick Validation Checklist (Post-Merge):**

```bash
# Automated smoke tests
PLAYWRIGHT_TEST_BASE_URL=https://staging-bns-portfolio.vercel.app pnpm playwright test

# Manual validation
open https://staging-bns-portfolio.vercel.app
# ✓ Home (/) loads without errors
# ✓ CV (/cv), Projects (/projects), Contact (/contact) render
# ✓ Project details load with evidence links
# ✓ DevTools Console: no JavaScript errors or failed network requests
```

**If Staging Validation Fails:**

- Do NOT proceed to production
- Create hotfix PR (targeting staging) or rollback (see [rbk-portfolio-rollback.md](../../50-operations/runbooks/rbk-portfolio-rollback.md))
- Validate staging again before promoting

## Procedure / Content

## Operational model

### Service definition

The Portfolio App is a public web application hosted on Vercel, deployed from GitHub with PR governance.

### Ownership

Owner: portfolio maintainer.
Responsibilities:

- keep build and deploy deterministic
- maintain evidence links and documentation integrity
- keep dependencies current and safe
- respond to regressions promptly with rollback capability

### Release gates (CI + Staging Validation)

- CI is a hard release gate. Merges and promotions must not proceed if required checks fail.
- Required checks (by contract): `ci / quality`, `ci / test`, `ci / build`, `ci / link-validation`.
- **Staging validation is required** after merge to main, before production is considered "live".
- Quality runs `pnpm lint`, `pnpm format:check`, `pnpm typecheck`

### Performance Monitoring (Phase 4 Stage 4.2)

**Bundle Size Regression Detection:** CI automatically tracks JavaScript bundle size after every build. If total JS exceeds baseline (27.8 MB) by >10%, the build fails and requires investigation before merge. This prevents unreviewed dependencies or code bloat from degrading performance.

**Core Web Vitals Monitoring:** Vercel Analytics dashboard (https://vercel.com/bryce-seefieldt/portfolio-app/analytics) tracks real-world performance metrics from production traffic:

- LCP (Largest Contentful Paint): Target < 2.5s
- FID (First Input Delay): Target < 100ms
- CLS (Cumulative Layout Shift): Target < 0.1

**Performance Baseline:** Build time (~3.5s), bundle size (27.8 MB), and Core Web Vitals targets documented in [portfolio-app/docs/performance-baseline.md](https://github.com/bryce-seefieldt/portfolio-app/blob/main/docs/performance-baseline.md).

**Operational Procedures:**

- Bundle analysis: `ANALYZE=true pnpm build` (visualize dependency composition)
- Build timing: `pnpm analyze:build` (measure compilation duration)
- Cache verification: `curl -I [URL] | grep Cache-Control` (confirm headers)
- Performance triage: See [rbk-portfolio-performance-optimization.md](../../50-operations/runbooks/rbk-portfolio-performance-optimization.md)

**Regression Thresholds:**

- Bundle size increase >10%: CI fails (requires justification or rollback)
- Build time increase >20%: Warning logged (investigate if sustained)
- LCP degradation >500ms: Manual investigation recommended
- CLS increase >0.05: Manual investigation recommended
- Test runs:
  - Unit tests: `pnpm test:unit` (70+ Vitest tests with ≥80% coverage validation)
  - E2E tests: `pnpm playwright test` (12 Playwright tests across Chromium, Firefox)
- Link validation runs (Stage 3.5):
  - Registry validation: `pnpm registry:validate` (checks project metadata schema)
  - Evidence link checks: `pnpm links:check` (Playwright smoke tests)
  - Produces playwright-report artifact on failure for diagnostic use
- Build runs `pnpm build` with frozen lockfile installs, then triggers Vercel deployment
- If CI fails: follow the CI triage runbook: [docs/50-operations/runbooks/rbk-portfolio-ci-triage.md](docs/50-operations/runbooks/rbk-portfolio-ci-triage.md).

### Staging Validation (Pre-Production Gate)

- Changes deployed to staging branch at `https://staging-bns-portfolio.vercel.app` for validation
- **Required before production is considered complete**
- Validation includes:
  - Manual smoke tests of critical routes (`/`, `/cv`, `/projects`, `/contact`)
  - Evidence link resolution verification
  - Browser console error checks
  - Optional automated Playwright tests via: `PLAYWRIGHT_TEST_BASE_URL=https://staging-bns-portfolio.vercel.app pnpm playwright test`
- If staging validation fails: fix via hotfix PR or rollback (see [rbk-portfolio-deploy.md](docs/50-operations/runbooks/rbk-portfolio-deploy.md))
- If staging passes: production deployment (on main) is already live and validated

### Monitoring and analytics

- Vercel Web Analytics is enabled for the Portfolio App; no cookies and no PII are collected.
- Access: Vercel project → Analytics tab (requires Vercel access, no extra env vars).
- Recommended checks after deploy:
  - Confirm page views register for `/`, `/projects`, and at least one project slug.
  - Verify no personally identifiable information is shown (aggregate metrics only).
- If analytics must be disabled temporarily, remove `<Analytics />` from `src/app/layout.tsx` and redeploy.

### Security Monitoring (Stage 4.4)

**Dependency Vulnerability Monitoring:**

- Dependabot scans weekly; PRs created for all available updates
- GitHub Security Alerts notify immediately of CVEs
- `pnpm audit` policy enforced in CI
- See [Dependency Vulnerability Runbook](/docs/50-operations/runbooks/rbk-portfolio-dependency-vulnerability.md) for response procedures

**Security Headers & CSP Monitoring:**

- Verify headers present: `curl -I https://production-domain.com/`
- Monitor CSP violations in browser console (DevTools)
- Review logs for unexpected external script/style injection attempts
- Quarterly review CSP policy; upgrade path to nonces/hashes documented

**Secrets Scanning:**

- TruffleHog runs in CI to detect leaked credentials
- Log scrubbing prevents secrets in output
- Pre-commit hooks recommended for local validation

### Pre-deploy local validation (developer workflow)

**Three-stage validation workflow:**

1. **Local** (before PR): `pnpm verify` on developer machine
2. **CI** (automatic): GitHub Actions validates on PR and main
3. **Staging** (after merge to main): Manual validation on production-like staging domain

#### Local development validation

Before committing changes or opening a PR, validate locally to catch CI failures early.

**Recommended approach (comprehensive with tests):**

```bash
pnpm verify
```

This runs the complete validation suite: environment check, auto-format, format validation, lint, typecheck, registry validation, build, unit tests, and E2E tests with detailed troubleshooting for failures. Mirrors CI workflow exactly.

**Fast approach (skip tests and performance checks):**

```bash
pnpm verify:quick
```

Runs environment check through build steps (skips performance verification, unit tests, and E2E tests) for rapid feedback during active development. Always run full `pnpm verify` before final push.

#### Staging validation (post-merge, pre-production)

After merging PR to main and deploying to staging:

**Automated validation:**

```bash
# Run Playwright smoke tests against staging domain
PLAYWRIGHT_TEST_BASE_URL=https://staging-bns-portfolio.vercel.app pnpm playwright test
```

**Manual validation checklist:**

1. Open `https://staging-bns-portfolio.vercel.app` in browser
2. Verify critical flows:
   - [ ] Home page loads (`/`)
   - [ ] CV page renders (`/cv`)
   - [ ] Projects page renders (`/projects`)
   - [ ] Contact page renders (`/contact`)
   - [ ] At least one project detail renders (`/projects/[slug]`)
3. Verify evidence links:
   - [ ] Links to Documentation App resolve
   - [ ] Project dossier links work
4. Browser validation:
   - [ ] Open DevTools Console
   - [ ] No JavaScript errors
   - [ ] No failed network requests

**Alternative approach (granular):**

```bash
pnpm format:write  # Fix formatting
pnpm lint          # Check linting
pnpm typecheck     # Check types
pnpm build         # Validate build
```

Run individual commands when debugging specific issues or during active development.

**Rationale:** Local validation reduces PR iteration cycles by catching failures before CI runs. The verify script provides a single-command workflow that matches CI behavior while offering better error reporting and automatic formatting fixes.

See [Testing: Local validation workflow](/docs/60-projects/portfolio-app/05-testing.md#local-validation-workflow-required) for detailed documentation of both approaches.

### Dependabot automation

- Dependabot PRs are auto-formatted in CI to prevent lockfile formatting failures
- Auto-format runs only when `github.actor == 'dependabot[bot]'`
- Human PRs require manual formatting to maintain developer discipline
- Configuration: `.prettierignore` excludes lockfiles; CI workflow has `contents: write` permission
- See PR #15 for implementation details

## Required runbooks (minimum viable)

Create under `docs/50-operations/runbooks/`:

1. **Deploy Portfolio App**
   - trigger (merge to `main`)
   - validation steps (routes, critical pages)
   - promotion checks verification

2. **Rollback Portfolio App**
   - rollback triggers
   - revert procedure
   - production validation

3. **Build/CI triage**
   - quality gate failures (lint/format/typecheck)
   - build failures

- required-checks missing/not selectable in ruleset → ensure checks exist and have executed recently on PRs and on pushes to `main`
- runbook: [docs/50-operations/runbooks/rbk-portfolio-ci-triage.md](docs/50-operations/runbooks/rbk-portfolio-ci-triage.md)

4. **Publication incident response (recommended)**
   - accidental publication of sensitive info
   - immediate containment and recovery

## Maintenance cadence (recommended)

### Weekly / bi-weekly

- review Dependabot PRs and merge with validation evidence
- verify a subset of key routes and `/docs` links remain correct
- update “in progress” project pages and evidence links

### Monthly

- review site performance and accessibility basics
- verify security posture assumptions remain accurate
- refresh any “proof links” to avoid drift

## Recovery posture (DR assumptions)

- Git repository is the system of record.
- Recovery mechanism:
  - revert to last known good commit on `main`
  - redeploy
- Hosting fallback:
  - if hosting failure occurs, redeploy to alternative target (document if adopted)

## Validation / Expected outcomes

- deploy and rollback are documented and repeatable
- regressions are addressed via deterministic procedures
- dependency posture remains current and reviewable
- documentation remains aligned with reality

## Failure modes / Troubleshooting

- broken `/docs` evidence links:
  - treat as regression; fix and document in release notes if material
- repeated CI failures:
  - adjust developer workflow; enforce format and lint pre-commit if beneficial
- production routing issues:
  - rollback quickly; document root cause and corrective actions

## Branch governance and promotion discipline

- Ruleset: `main-protection` (update name here if your org uses a different ruleset identifier).
- Enforces:
  - PRs required to merge to `main` (no direct pushes)
  - required checks must pass: `ci / quality`, `ci / build`
  - no force-push to `main`
  - prevent branch deletion
- Why it exists:
  - reproducibility (deterministic, verifiable releases)
  - auditability (traceable PR evidence and checks)
  - safety (prevents accidental/promiscuous promotion to production)

## References

- Deployment dossier: `docs/60-projects/portfolio-app/deployment.md`
- Testing dossier: `docs/60-projects/portfolio-app/testing.md`
- Runbooks index: [docs/50-operations/runbooks/index.md](docs/50-operations/runbooks/index.md)
- CI triage runbook: [docs/50-operations/runbooks/rbk-portfolio-ci-triage.md](docs/50-operations/runbooks/rbk-portfolio-ci-triage.md)
- Postmortem template (internal-only): `docs/_meta/templates/template-postmortem.md`
