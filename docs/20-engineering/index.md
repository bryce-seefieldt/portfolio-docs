---
title: 'Engineering Standards and Local Development'
description: 'Coding standards, repository conventions, local dev workflows (WSL2/VS Code), testing strategy, and dependency management to ensure repeatable, reviewable delivery.'
sidebar_position: 3
tags: [engineering, standards, testing, local-dev, wsl2, developer-experience]
---

## Purpose

This section defines the engineering system: how code is written, validated, tested, and maintained so that delivery is repeatable and professional.

It exists to show:

- disciplined engineering standards
- reproducible local development (especially Windows 11 + WSL2 + VS Code Remote)
- test strategy aligned with product risk and security requirements
- maintainable dependency and version management

## Scope

### In scope

- coding standards (TypeScript/Node, React, repository conventions)
- local development workflows and workstation setup practices
- testing strategy (unit/integration/e2e) and quality gates
- dependency management and update policies
- developer troubleshooting and operationally-relevant dev tools

### Out of scope

- CI/CD pipeline orchestration (belongs in `30-devops-platform/`)
- security policies and scans (belongs in `40-security/`)
- production operational procedures (belongs in `50-operations/`)

## Engineering contribution principles

- Prefer deterministic, reproducible steps.
- Document commands and expected outcomes, not just “what to click.”
- Treat docs updates as part of engineering changes; no “docs later.”

## Local dev expectations (portfolio credibility)

Local development docs should make it possible to rebuild the environment from scratch:

- WSL2 setup assumptions and resource caps
- VS Code Remote WSL workflow and CLI ergonomics
- Node version and package manager expectations
- standard “golden commands” (build, test, lint, format, typecheck)

## Testing and quality model (high-level)

Every meaningful code path should be covered by an appropriate test:

- unit tests for business logic
- integration tests for contracts and boundaries
- e2e tests for user-facing flows and security-relevant behaviors

Test documentation should include:

- what is tested and why
- how to run tests locally
- how tests run in CI
- known gaps and planned improvements (with tracked work)

## Validation and expected outcomes

Engineering docs are “correct” when:

- a new contributor can run the system locally with minimal guesswork
- quality checks are explicit and easy to execute
- troubleshooting steps are practical and ordered

## Failure modes and troubleshooting

Common issues:

- **Undocumented assumptions:** environment “just works” for the author → capture prerequisites explicitly.
- **Non-reproducible steps:** steps depend on local state → document cleanup/reset steps.
- **Tool drift:** Node/TypeScript toolchain changes → update standards and golden commands in the same PR.

## References

Engineering changes that alter build/test/lint behavior must update:

- standards and golden commands (this section)
- CI gates in `30-devops-platform/`
- release notes if behavior is user-visible
