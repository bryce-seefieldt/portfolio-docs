---
title: 'Portfolio App: Security'
description: 'Security posture for the Portfolio App: threat surface, enforceable SDLC controls, and public-safe content and deployment practices.'
sidebar_position: 4
tags: [projects, security, sdlc, supply-chain, web, portfolio]
---

## Purpose

Document the Portfolio App security posture as a public-facing site without authentication.

The security objective is to demonstrate credible enterprise practices:

- safe-publication discipline
- dependency and supply chain hygiene
- CI integrity
- practical web hardening where appropriate

## Scope

### In scope

- threat surface summary (public site, no auth)
- enforceable SDLC controls
- public-safe publication rules
- recommended hardening measures (balanced with practicality)

### Out of scope

- exhaustive threat enumeration (belongs in a dedicated threat model)
- private vendor configuration and secrets

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
