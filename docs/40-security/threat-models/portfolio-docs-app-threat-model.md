---
title: 'Threat Model: Portfolio Docs App'
description: 'Threat model for the Docusaurus documentation platform, focused on supply chain risk, CI integrity, public content safety, and deployment surface controls.'
sidebar_position: 1
tags: [security, threat-model, sdlc, supply-chain, documentation, projects]
---

## Purpose

Define a practical threat model for the Portfolio Docs App to guide:

- secure architecture decisions
- enforceable SDLC controls
- CI and dependency hygiene
- incident readiness for accidental publication risk

This threat model is designed to be actionable and verifiable.

## Scope

### Use when

- changing documentation platform tooling, plugins, or build chain
- changing hosting/deployment model
- introducing MDX interactivity or external embedded content
- changing contributor workflow and PR policies

### Do not use when

- documenting generic security best practices not tied to this system boundary

## Prereqs / Inputs

- System / component: Portfolio Docs App (Docusaurus static site + CI + hosting)
- Owner: Portfolio maintainer
- Date: 2026-01-06
- Status: Draft (ready for review)
- Architecture references:
  - `docs/60-projects/portfolio-docs-app/architecture.md`
  - ADRs: `docs/10-architecture/adr/`
- Known constraints:
  - Public site; must not expose secrets or internal endpoints
  - Must remain maintainable and contributor-friendly

## System overview

### Assets to protect

- **Source integrity**: docs content and configuration under version control
- **Build integrity**: build output must reflect reviewed source changes
- **Pipeline integrity**: CI must not execute unsafe behaviors or leak sensitive info
- **Publication safety**: avoid publishing secrets, private endpoints, sensitive logs
- **Availability**: documentation site should remain accessible (portfolio reputation risk)
- **Trustworthiness**: ensure documentation is consistent, not tampered with, and reviewable

### Trust boundaries

- Contributor workstation (VS Code/WSL2) → Git provider (PR)
- PR branch → CI runner/build system
- CI build output → hosting provider deployment
- Public internet → hosted documentation site (read-only access)

### Entry points

- Pull requests (primary change entry point)
- Dependency updates (transitive risk entry point)
- CI workflows and build scripts
- Hosting configuration changes
- MDX components (if introduced)
- External embeds (images, scripts, if ever allowed—avoid by default)

## Threat analysis

### Threat 1: Malicious dependency / supply chain compromise

- **Threat:** A dependency (direct or transitive) is compromised and executes malicious code during build.
- **Asset impacted:** Build integrity, pipeline integrity, publication safety
- **Scenario:** A compromised package runs post-install scripts or modifies build artifacts.
- **Impact:** High (could exfiltrate secrets, tamper output, undermine trust)
- **Likelihood:** Medium (supply chain attacks are plausible in Node ecosystems)
- **Mitigations:**
  - lockfile discipline (`pnpm-lock.yaml` committed)
  - PR review for dependency changes
  - dependency audit checks in CI
  - minimize plugin sprawl
- **Gaps:**
  - additional provenance/SBOM controls may be added later
- **Controls required:**
  - enforce dependency update policy and review gates
- **Validation:**
  - CI runs dependency audit; dependency PRs reviewed; build remains deterministic

### Threat 2: Malicious PR content attempting to introduce unsafe behavior

- **Threat:** A PR introduces MDX/JS that performs unsafe client-side actions or embeds untrusted content.
- **Asset impacted:** Trustworthiness, publication safety, user safety
- **Scenario:** MDX embeds scripts or unsafe components, causing client-side risk.
- **Impact:** Medium–High (depends on content; reputational impact is high)
- **Likelihood:** Low–Medium (depends on contributor model; still relevant)
- **Mitigations:**
  - default to Markdown; restrict MDX usage
  - PR review and CI build gate
  - limit custom components; treat MDX as “code”
- **Gaps:**
  - formal MDX review checklist not yet enforced (recommended)
- **Controls required:**
  - MDX minimization policy + review checklist
- **Validation:**
  - PR template requires “No risky embeds” statement; build passes; reviewer confirms MDX usage is justified

### Threat 3: Accidental publication of secrets or sensitive internal information

- **Threat:** A contributor pastes tokens, keys, internal endpoints, or sensitive screenshots into docs. Also: environment variables containing secrets are misconfigured in Vercel.
- **Asset impacted:** Publication safety, trustworthiness
- **Scenario 1:** A page includes an API key or internal hostname, becomes publicly accessible after deploy.
- **Scenario 2:** A production environment variable is hardcoded with a secret or internal endpoint.
- **Impact:** High (credential compromise, privacy breach, reputational damage)
- **Likelihood:** Medium (very common operational failure mode)
- **Mitigations:**
  - explicit policy: no secrets, no internal endpoints
  - environment variables contract: public-safe variables only (see [Portfolio Docs Environment Variables Contract](https://github.com/bryce-seefieldt/portfolio-docs/blob/main/docs/_meta/env/portfolio-docs-env-contract.md))
  - `.env.local` is gitignored; production vars set in Vercel dashboard only
  - PR checklist with "No secrets added" 
  - secrets scanning (pre-commit and/or CI) recommended
  - keep internal scaffolding in `docs/_meta/` and avoid publishing raw logs
- **Gaps:**
  - CI-based secret scanning may not be implemented yet (should be)
- **Controls required:**
  - secrets scanning gate + environment variable security review + incident response plan
- **Validation:**
  - scanning runs; manual review confirms environment variables are public-safe; incident runbook exists

### Threat 4: CI workflow compromise or unsafe execution context

- **Threat:** CI executes untrusted code with elevated access or leaks sensitive logs.
- **Asset impacted:** Pipeline integrity, build integrity
- **Scenario:** A workflow uses overly broad permissions; logs expose environment details.
- **Impact:** High
- **Likelihood:** Low–Medium
- **Mitigations:**
  - principle of least privilege for CI permissions
  - avoid long-lived secrets for docs builds when possible
  - sanitize logs; avoid printing env values
- **Gaps:**
  - CI permissions hardening may be incremental
- **Controls required:**
  - documented CI permissions model; review workflow changes as security-sensitive
- **Validation:**
  - workflow permissions reviewed; no secret values printed in logs; builds remain reproducible

### Threat 5: Deployment misconfiguration (routing/base path) causing broken site or confusing URLs

- **Threat:** Misconfigured base paths break navigation or produce unexpected public routing.
- **Asset impacted:** Availability, trustworthiness
- **Scenario:** routeBasePath mismatch causes broken links or missing pages in production.
- **Impact:** Medium
- **Likelihood:** Medium (common with static sites)
- **Mitigations:**
  - decide routeBasePath early; document it as a standard
  - require `pnpm build` and PR preview validation
  - rollback runbook exists
- **Gaps:**
  - routeBasePath governance may be incomplete early on
- **Controls required:**
  - ADR-required change control for routing/base path changes
- **Validation:**
  - preview verified; production verified; rollback tested

## Mitigation plan and SDLC controls

### Enforceable controls (minimum)

- PR-only merges to `main`
- `pnpm build` must pass in CI
- dependency changes require review
- secrets scanning recommended as a gate
- MDX minimized; MDX changes treated like code
- routeBasePath changes require ADR and explicit review

### Residual risk

- Residual risk: dependency supply chain cannot be reduced to zero
  - Mitigation: audit/update cadence + review discipline
  - Review cadence: monthly posture review or on major changes

## Validation / Expected outcomes

- CI reliably blocks broken builds and structural errors
- No secrets or internal endpoints are present in public docs
- Dependency changes are reviewed and validated
- MDX usage is controlled and justified
- Deployment routing remains stable and documented

## Failure modes / Troubleshooting

- Suspected sensitive publication:
  - remove content immediately (revert PR)
  - rotate exposed secrets if applicable
  - create a postmortem and corrective actions
- Vulnerable dependency discovered:
  - patch/upgrade via PR
  - validate build
  - document the change and its implications

## References

- Portfolio Docs App dossier:
  - `docs/60-projects/portfolio-docs-app/security.md`
  - `docs/60-projects/portfolio-docs-app/deployment.md`
- Templates guide (internal-only): `docs/_meta/templates/README.md`
- ADRs for platform decisions: `docs/10-architecture/adr/`
- Runbooks (deploy/rollback/triage): `docs/50-operations/runbooks/`
