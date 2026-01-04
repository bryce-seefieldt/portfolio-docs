---
title: "Reference Library (CLI, Configs, Cheatsheets)"
description: "A curated reference system for workstation configuration, CLI commands, troubleshooting recipes, and configuration snippets used across the portfolio program."
sidebar_position: 8
tags: [reference, cli, configuration, wsl2, troubleshooting, productivity]
---

## Purpose

This section is the fast-access reference library. It is designed for daily use and for reviewers who want to see disciplined operational habits.

It includes:
- command recipes and diagnostics
- configuration references (public-safe)
- “golden commands” for building, testing, and verifying systems
- workstation and workflow conventions (especially WSL2 + VS Code Remote)

## Scope

### In scope
- CLI recipes (git/node/docker/wsl/system tools)
- configuration references and rationale (redacted and public-safe)
- troubleshooting checklists for common failures
- small, reusable snippets (YAML, JSON, shell, tsconfig, lint configs)

### Out of scope
- narrative tutorials (belongs in `20-engineering/` or `30-devops-platform/`)
- operational procedures (belongs in `50-operations/runbooks/`)
- architecture rationale (belongs in `10-architecture/`)

## Reference entry standards

Every reference entry should include:
1. Purpose (what problem it solves)
2. Context (where it runs: WSL bash vs PowerShell vs CI)
3. Command/snippet (copy/paste safe)
4. Expected output (or validation signal)
5. Common failure modes and fixes

## Publication safety rules (reinforced)

Reference content must never include:
- tokens, secrets, private keys
- private IPs or internal hostnames
- sensitive environment paths that identify personal data
- raw logs with identifiers

When in doubt: summarize rather than paste verbatim.

## Validation and expected outcomes

Reference content is “good” when:
- it’s short, correct, and immediately usable
- it states environment context clearly
- it includes validation output or checks
- it reduces time-to-fix for common issues

## Failure modes and troubleshooting

- **Reference sprawl:** too many entries without structure → add subfolders and category metadata.
- **Stale commands:** updates to toolchain invalidate instructions → update in the same PR that changes tooling.
- **Hidden prerequisites:** commands require tools not mentioned → include prerequisites explicitly.

## References

Reference entries must align with:
- engineering standards and local dev workflows (`20-engineering/`)
- platform and pipeline requirements (`30-devops-platform/`)
- operational runbooks (`50-operations/`) where procedures exist
