---
title: 'Portfolio App: Security'
description: 'Security posture for the Portfolio App: threat surface, enforceable SDLC controls, and public-safe content and deployment practices.'
sidebar_position: 4
tags: [projects, security, sdlc, supply-chain, web, portfolio]
---

Status: **Live — Baseline security controls** — Dependabot + CodeQL + public-safe env policy + comprehensive threat model (STRIDE).

## Purpose

Document the Portfolio App security posture as a public-facing site without authentication.

The security objective is to demonstrate credible enterprise practices:

- safe-publication discipline
- dependency and supply chain hygiene
- CI integrity
- practical web hardening where appropriate
- comprehensive threat analysis and mitigation

## Scope

### In scope

- threat surface summary (public site, no auth)
- enforceable SDLC controls
- public-safe publication rules
- recommended hardening measures (balanced with practicality)

### Out of scope

- exhaustive threat enumeration (moved to dedicated threat model)
- private vendor configuration and secrets

---

## Threat Model Reference

**Comprehensive threat analysis:** See [Threat Model: Portfolio App](/docs/40-security/threat-models/portfolio-app-threat-model.md)

The dedicated threat model uses the **STRIDE** methodology to enumerate threats across six categories:

- **S**poofing (Identity)
- **T**ampering (Data Integrity)
- **R**epudiation (Accountability)
- **I**nformation Disclosure (Confidentiality)
- **D**enial of Service (Availability)
- **E**levation of Privilege (Authorization)

For each threat, the model documents:

- scenario and impact
- likelihood and risk
- implemented mitigations
- validation procedures

**Status:** Live and aligned with baseline and extended recommended controls.

---

## Prereqs / Inputs

- PR governance and CI quality gates exist
- dependency update policy exists (Dependabot + review)
- “no secrets” policy is enforced across repos and documentation

## Procedure / Content

## Threat surface summary

### Primary risks

- supply chain compromise (dependencies, build scripts)
- accidental publication of sensitive material (tokens, internal endpoints, private logs)
- content injection via unsafe MDX or untrusted embeds
- availability risks (routing misconfig, base path errors)
- defacement risks (malicious PR if governance fails)

### Explicitly reduced risks (by design)

- no authentication → reduced session/token handling complexity
- no contact form initially → reduced spam/abuse backend surface
- static-first content → reduced data injection surface

## Enforceable SDLC controls (baseline)

### PR-only merges to `main`

- All changes via PR, with review discipline.

### CI gates

- lint + format check + typecheck + build must pass.

### Dependency hygiene

- Dependabot PRs reviewed and merged with evidence.
- Major upgrades require additional scrutiny.

### Secrets hygiene

- No secrets committed.
- Treat any suspected leak as an incident:
  - revert, rotate, postmortem.

### MDX minimization

- Markdown-first.
- MDX treated as code; minimal usage.

## Recommended hardening measures (pragmatic)

- set security headers appropriately (CSP where practical)
- avoid inline scripts and unsafe external embeds
- ensure no sensitive runtime env vars leak to client
- keep public logs minimal and non-sensitive

## Baseline security posture

### Supply chain controls

- Dependabot policy: weekly updates for npm and GitHub Actions.
- Grouped update strategy for production/dev dependencies; majors intentionally excluded by default and reviewed separately.
- Evidence: Dependabot configuration in the app repository.

### Static analysis

- CodeQL workflow enabled on PRs, pushes to `main`, and a weekly scheduled run.
- Scope: JavaScript/TypeScript.
- Evidence: CodeQL workflow in the app repository.

### Public-safe config policy

- `NEXT_PUBLIC_*` variables are client-visible and must not contain secrets or sensitive endpoints.
- Public configuration is centralized in the app at `src/lib/config.ts` with helpers for docs URLs and mailto links.
- Internal-only details of the env contract are tracked in: `docs/_meta/env/portfolio-app-env-contract.md` (plain-text path; keep internal to avoid public leakage).

## Validation / Expected outcomes

- no secrets in repo history
- CI gates prevent broken or unsafe changes from merging
- dependency posture is actively maintained and documented
- public site content is safe and professional

## Failure modes / Troubleshooting

- accidental sensitive publication:
  - remove immediately, revert, rotate, postmortem
- dependency vulnerability discovered:
  - patch/upgrade via PR, validate build, document impact
- unsafe embed introduced:
  - remove; introduce governance rule to prevent recurrence

## References

- Threat models: `docs/40-security/threat-models/portfolio-app-threat-model.md`
- Secure SDLC documentation: `docs/40-security/`
- Operations and incident response: `docs/50-operations/`

---

## Public-Safety Rules (Enforced)

### Analytics privacy stance

- Vercel Web Analytics is used for aggregate page views only; no cookies and no PII are collected.
- No additional environment variables are required; instrumentation is via `<Analytics />` in `src/app/layout.tsx`.
- Data collected: page URL and count metrics only; no IPs, names, or user identifiers.
- If analytics are not desired, remove the component and redeploy; no data will be collected.

### Environment Variables

- ✅ All `NEXT_PUBLIC_*` variables are client-visible by design
- ✅ No secrets in any `NEXT_PUBLIC_*` variable
- ✅ `.env.example` documents all required variables
- ✅ Local `.env.local` gitignored

**Validation procedure:**

```bash
# Check for secrets in env vars
grep -r "NEXT_PUBLIC.*SECRET\|NEXT_PUBLIC.*KEY\|NEXT_PUBLIC.*TOKEN" src/
# Should return: no results

# Local secret hygiene (lightweight):
# The local verification script runs a pattern-based scan (no TruffleHog).
# CI runs the full `secrets:scan` stage using TruffleHog on PRs.
# To opt-in locally, use pre-commit or install TruffleHog, but it's not required.
```

**Secrets scanning scope:**

- Local verification does NOT run TruffleHog. A lightweight pattern scan is included.
- The TruffleHog-based `secrets:scan` runs in CI on PRs and must pass.
- Optional local opt-in:
  - **Pre-commit**: `pip install pre-commit && pre-commit install` (runs TruffleHog on commits)
  - **Manual**: Install TruffleHog CLI if you want to run `pnpm secrets:scan` locally
    - **macOS**: `brew install trufflesecurity/trufflehog/trufflehog`
    - **Linux**: Download from [GitHub releases](https://github.com/trufflesecurity/trufflehog/releases/), extract, and add to PATH

### Dependencies

- ✅ CodeQL scanning (JS/TS) on PR + weekly schedule
- ✅ Dependabot weekly updates (grouped, majors excluded)
- ✅ Frozen lockfile in CI (`pnpm install --frozen-lockfile`)

### CI/CD Pipeline

- ✅ Least-privilege permissions (scoped per job)
- ✅ Secrets scanning gate (TruffleHog, PR-only in CI)
- ✅ Required checks before merge (quality, secrets-scan, build, CodeQL)

## Security Controls (Baseline)

| Control                  | Status       | Evidence                                                                                                                |
| ------------------------ | ------------ | ----------------------------------------------------------------------------------------------------------------------- |
| Secrets scanning (CI)    | ✅ Enforced  | [ci.yml](https://github.com/bryce-seefieldt/portfolio-app/blob/main/.github/workflows/ci.yml)                           |
| Pre-commit secrets scan  | ✅ Available | [.pre-commit-config.yaml](https://github.com/bryce-seefieldt/portfolio-app/blob/main/.pre-commit-config.yaml)           |
| Least-privilege CI perms | ✅ Enforced  | [ci.yml job permissions](https://github.com/bryce-seefieldt/portfolio-app/blob/main/.github/workflows/ci.yml#L19-L22)   |
| CodeQL scanning          | ✅ Enforced  | [codeql.yml](https://github.com/bryce-seefieldt/portfolio-app/blob/main/.github/workflows/codeql.yml)                   |
| Dependabot updates       | ✅ Enabled   | [dependabot.yml](https://github.com/bryce-seefieldt/portfolio-app/blob/main/.github/dependabot.yml)                     |
| Threat model             | ✅ Complete  | [portfolio-app-threat-model.md](/docs/40-security/threat-models/portfolio-app-threat-model.md)                          |
| Incident response        | ✅ Ready     | [rbk-portfolio-secrets-incident.md](/docs/50-operations/runbooks/rbk-portfolio-secrets-incident.md)                     |
| Unit tests               | ✅ Enforced  | [src/lib/**tests**/](https://github.com/bryce-seefieldt/portfolio-app/tree/main/src/lib/__tests__) (70+ tests)          |
| E2E tests                | ✅ Enforced  | [tests/e2e](https://github.com/bryce-seefieldt/portfolio-app/tree/main/tests/e2e)                                       |
| Frozen lockfiles         | ✅ Enforced  | [ci.yml build step](https://github.com/bryce-seefieldt/portfolio-app/blob/main/.github/workflows/ci.yml)                |
| PR template              | ✅ Active    | [PULL_REQUEST_TEMPLATE.md](https://github.com/bryce-seefieldt/portfolio-app/blob/main/.github/PULL_REQUEST_TEMPLATE.md) |

### Code Scanning

- ✅ CodeQL enabled (JavaScript/TypeScript)
- ✅ Runs on every push to main and PR
- ✅ Scans for: SQL injection, XSS, path traversal, hardcoded secrets

### Supply Chain Security

- ✅ Dependabot enabled (weekly updates, grouped by type)
- ✅ Major version updates excluded (manual review required)
- ✅ Lockfile formatting automated (prevents CI failures)
- ✅ Frozen lockfile installs in CI (`pnpm install --frozen-lockfile`)

### PR Security Checklist

Every PR must confirm:

- [ ] No secrets added
- [ ] No sensitive endpoints added
- [ ] Environment variables documented in `.env.example`
- [ ] CodeQL scan passes
- [ ] Secrets scan passes

## Security Hardening

Comprehensive hardening documentation: [Portfolio App Security Controls](../../40-security/portfolio-app-security-controls.md)

Covers:

- OWASP security headers (X-Frame-Options, X-Content-Type-Options, CSP)
- Content Security Policy configuration and rationale
- Environment variable security contract
- Dependency audit policy and MTTR targets
- Implementation checklists

## Known Limitations & Accepted Risks

### Out of Scope (Intentional)

- No authentication: Public portfolio, no user accounts.
- No backend processing: Static content, no server-side logic.
- No database: No persistent user data or state.
- No contact form backend: Email link only (prevents spam/abuse surface).

### Residual Risks (Acceptable)

- Dependency vulnerabilities: Mitigated by Dependabot + CodeQL.
- DDoS: Mitigated by Vercel's edge network.
- Content injection: Not applicable (static content, no UGC).
