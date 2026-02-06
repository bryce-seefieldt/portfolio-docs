---
title: 'Feature: Supply Chain Security'
description: 'Dependabot, CodeQL, and audit gates for dependencies.'
sidebar_position: 3
tags: [portfolio, features, security, supply-chain]
---

## Purpose

- Feature name: Supply chain security
- Why this feature exists: Detect dependency vulnerabilities and keep the dependency graph healthy.

## Scope

### In scope

- Dependabot updates
- CodeQL scanning
- `pnpm audit` policy in CI

### Out of scope

- runtime security headers
- secrets scanning

## Prereqs / Inputs

- Dependabot and CodeQL configured in repo
- CI pipeline runs audits

## Procedure / Content

### Feature summary

- Feature name: Supply chain security
- Feature group: Security posture and hardening
- Technical summary: Automated dependency scanning and audits block merges on high severity issues.
- Low-tech summary: Keeps dependencies updated and checks for known vulnerabilities.

### Feature in action

- Where to see it working: CI runs on PRs, Dependabot PRs appear weekly.

### Confirmation Process

#### Manual

- Steps: Review Dependabot PRs and CodeQL results in GitHub.
- What to look for: Alerts resolved, audit gate passes.
- Artifacts or reports to inspect: CI `pnpm audit` output and CodeQL checks.

#### Tests

- Unit tests: None specific.
- E2E tests: None.

### Potential behavior if broken or misconfigured

- Vulnerabilities not detected due to disabled scans.
- Audit gate skipped or loosened.

### Long-term maintenance notes

- Review Dependabot update cadence periodically.
- Keep audit severity thresholds aligned with policies.

### Dependencies, libraries, tools

- Dependabot
- GitHub CodeQL
- pnpm audit

### Source code references (GitHub URLs)

- [`/portfolio-app/.github/dependabot.yml`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/.github/dependabot.yml)
- [`/portfolio-app/.github/workflows/codeql.yml`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/.github/workflows/codeql.yml)
- [`/portfolio-app/.github/workflows/ci.yml`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/.github/workflows/ci.yml)

### ADRs

- None.

### Runbooks

- [`/50-operations/runbooks/rbk-portfolio-dependency-vulnerability.md`](/docs/50-operations/runbooks/rbk-portfolio-dependency-vulnerability.md)

### Additional internal references

- [`/40-security/security-policies.md`](/docs/40-security/security-policies.md)
- [`/30-devops-platform/ci-cd-pipeline-overview.md`](/docs/30-devops-platform/ci-cd-pipeline-overview.md)

### External reference links

- https://docs.github.com/en/code-security/dependabot
- https://docs.github.com/en/code-security/code-scanning/introduction-to-code-scanning/about-code-scanning
- https://pnpm.io/cli/audit

## Validation / Expected outcomes

- CodeQL and audit checks pass on every PR.
- Dependabot keeps dependencies within policy.

## Failure modes / Troubleshooting

- Scan failures: inspect CodeQL logs and resolve issues.
- Audit fails: update dependencies and re-run CI.

## References

- None.
