---
title: 'Feature: Secrets Hygiene'
description: 'Public-safe configuration and secrets scanning discipline.'
sidebar_position: 2
tags: [portfolio, features, security, secrets]
---

## Purpose

- Feature name: Secrets hygiene
- Why this feature exists: Prevent accidental exposure of secrets in a public repo and deployments.

## Scope

### In scope

- `NEXT_PUBLIC_*` safety rules
- secrets scanning in CI
- local lightweight scanning guidance

### Out of scope

- dependency scanning (covered in supply chain features)
- incident response procedures (covered in operations runbooks)

## Prereqs / Inputs

- CI workflow configured for secrets scanning
- environment variable contract documented

## Procedure / Content

### Feature summary

- Feature name: Secrets hygiene
- Feature group: Security posture and hardening
- Technical summary: Enforces public-safe environment variables and scans for secrets in CI.
- Low-tech summary: Stops sensitive data from ending up in public code.

### Feature in action

- Where to see it working: CI runs on PRs and main; repo remains free of secrets.

### Confirmation Process

#### Manual

- Steps: Review `.env.example` and confirm no secrets are documented.
- What to look for: No secret-like values in public config or repo history.
- Artifacts or reports to inspect: CI `secrets:scan` job output.

#### Tests

- Unit tests: None specific.
- E2E tests: None.

### Potential behavior if broken or misconfigured

- Secrets committed to the repo.
- CI secrets scan disabled or skipped.

### Long-term maintenance notes

- Revalidate environment variable docs after config changes.
- Keep secret scanning tools up to date.

### Dependencies, libraries, tools

- TruffleHog (CI)
- GitHub Actions

### Source code references (GitHub URLs)

- [`/portfolio-app/.github/workflows/ci.yml`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/.github/workflows/ci.yml)
- [`/portfolio-app/src/lib/config.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/config.ts)

### ADRs

- None.

### Runbooks

- [`/50-operations/runbooks/rbk-portfolio-secrets-incident.md`](/docs/50-operations/runbooks/rbk-portfolio-secrets-incident.md)

### Additional internal references

- [`/40-security/security-policies.md`](/docs/40-security/security-policies.md)
- [`/70-reference/portfolio-app-config-reference.md`](/docs/70-reference/portfolio-app-config-reference.md)

### External reference links

- https://github.com/trufflesecurity/trufflehog
- https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions

## Validation / Expected outcomes

- Secrets scans pass in CI.
- No secrets appear in public configuration files.

## Failure modes / Troubleshooting

- Scan failures: inspect findings, remove secrets, rotate credentials.
- False positives: document rationale and adjust patterns if needed.

## References

- None.
