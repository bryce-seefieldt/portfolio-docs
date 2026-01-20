---
title: 'Portfolio Docs: Security'
description: 'Security posture for the Portfolio Docs App: threat surface, enforceable SDLC controls, supply chain hygiene, and public publication safety.'
sidebar_position: 4
tags: [projects, security, sdlc, supply-chain, documentation, governance]
---

## Purpose

This page documents the security posture of the Portfolio Docs App as a public-facing system. Even though it is “just documentation,” it still has meaningful security concerns:

- supply chain risk (dependencies)
- CI integrity and build provenance
- risk of publishing sensitive information
- content injection risks (especially if MDX is used)
- deployment surface configuration (headers, caching behaviors)

## Scope

### In scope

- threat surface summary
- required SDLC controls and enforcement model
- publication safety rules (“no secrets” discipline)
- security validation procedures appropriate for a docs platform

### Out of scope

- exhaustive threat enumeration (belongs in a dedicated threat model document)
- vendor-specific security configuration containing sensitive details

## Prereqs / Inputs

- Repo governance: PR-only merges to `main`
- CI pipeline exists and runs `pnpm build`
- Publication safety rules are enforced culturally and via tooling where possible
- The docs content model is understood (filesystem-driven docs; `_meta` internal-only)

## Procedure / Content

## Threat surface summary

### Supply chain and dependency risk

- The Portfolio Docs App depends on Node packages (Docusaurus and plugins).
- Risks include:
  - compromised dependencies
  - vulnerable transitive packages
  - malicious updates introduced via automation without review

### CI pipeline integrity

- The build pipeline produces the deployable artifact.
- Risks include:
  - malicious PRs attempting to introduce unsafe content
  - compromised CI secrets (even if minimal)
  - build steps running untrusted scripts without controls

### Content publication risk

- The most realistic portfolio risk:
  - accidentally publishing secrets or sensitive internal information
- This includes:
  - API keys
  - internal endpoints
  - internal IPs/hostnames
  - proprietary logs or screenshots containing identifiers

### Content injection and client-side risk

- Docusaurus supports MDX, which can embed React components.
- Risks:
  - unsafe client-side behavior
  - accidental inclusion of sensitive data in embedded components
  - XSS-style risks if rendering untrusted content (avoid)

## Enforceable SDLC controls (minimum)

### Control 1: PR-only to `main`

- All changes must go through PR review (even solo).
- PR must include: what/why/evidence/no-secrets statement.

### Control 2: Build gate

- `pnpm build` must pass in CI.
- Broken links and invalid structures should fail the build.

### Control 3: Secrets hygiene

- Strict “no secrets” policy:
  - do not commit secrets
  - do not paste sensitive config
  - do not include internal endpoints
- Recommended enforcement:
  - secrets scanning in CI (pre-commit and/or CI)

### Control 4: Dependency hygiene

- Define a dependency update policy:
  - regular updates (cadence)
  - review required for major upgrades
  - security advisories prioritized
- Recommended enforcement:
  - dependency audit checks in CI
  - PR-based updates only

### Control 5: Environment variable security

- **Public-safe only**: All `DOCUSAURUS_*` variables must be safe for production exposure
- **No hardcoded secrets**: Use environment files (`.env.local`, `.env.production.local`) for local-only overrides
- **Verify at merge**: PR reviewers check that no sensitive URLs or endpoints are being added
- **Protected in Vercel**: Production variables are restricted to authorized users only
- See [Portfolio Docs Environment Variables Contract](https://github.com/bryce-seefieldt/portfolio-docs/blob/main/docs/_meta/env/portfolio-docs-env-contract.md) for public-safe variable reference

### Control 6: MDX minimization

- Default to Markdown.
- Use MDX only when needed and treat MDX as “code” requiring higher scrutiny.

## Security evidence expectations (public-safe)

The goal is to demonstrate controls, not to leak details. Evidence should be:

- summarized
- redacted
- reproducible via documented procedure

Examples of acceptable evidence:

- “CI runs dependency audit and fails on critical vulnerabilities.”
- “Build fails on broken links.”
- “No secrets policy enforced; secrets scanning enabled.”- "Environment variables are public-safe; production URLs are Vercel-hosted only."

## Validation / Expected outcomes

Security posture is acceptable when:

- no secrets or sensitive environment details exist in the repo history
- CI gates prevent merging broken builds
- dependency risk is managed via a documented policy and enforcement
- MDX usage is minimized and reviewed like code
- publication risk is treated as a first-class threat

## Failure modes / Troubleshooting

- **Accidental sensitive publication:** treat as a security incident:
  - remove content immediately
  - rotate any exposed secrets (if applicable)
  - document corrective actions and prevention controls
- **Dependency vulnerability discovered:** document response:
  - patch/upgrade
  - validate build
  - update release notes if impact is material
- **Unreviewed MDX change introduces risk:** require tighter review, add a control/checklist.

## References

- Threat model template (internal-only): `docs/_meta/templates/template-threat-model.md`
- Security domain: `docs/40-security/`
- Secure SDLC controls: `docs/40-security/secure-sdlc/` (to be created as the program expands)
- Incident response: `docs/50-operations/incident-response/` (for publication incidents)
