---
title: 'Policy Drift Remediation Checklist'
description: 'Concrete, file-specific remediation checklist with exact edits to keep canonical governance, contributor docs, PR template, and templates aligned.'
tags:
  [
    governance,
    remediation,
    policy-drift,
    checklist,
    templates,
    contributor-guide,
  ]
---

# Purpose

Provide exact edits to remediate and prevent governance drift across canonical policy and contributor-facing docs.

# Scope

Files covered:

- `.github/copilot-instructions.md`
- `CONTRIBUTING.md`
- `.github/PULL_REQUEST_TEMPLATE.md`
- `docs/_meta/templates/README.md`
- selected templates under `docs/_meta/templates/`

# Status

Applied in this change set:

- Tier model added to canonical instructions
- front matter scope rule fixed
- contradictory hardcoded-host guidance removed from canonical instructions
- PR template includes `pnpm policy:check` evidence item
- CONTRIBUTING includes optional policy drift check and neutral secrets-scan wording
- roadmap issues index front matter normalized
- template links normalized for architecture/operations prefixed paths
- template governance README updated with policy consistency requirements
- non-blocking CI policy-consistency visibility job added
- allowlist-based false-positive tuning added for policy checks

Remaining recommended edits are listed below.

# Exact Edit Checklist

## 1) Canonical policy file

File: `.github/copilot-instructions.md`

- [x] Add section: `## Governance Tier Model (Canonical)` near Purpose
- [x] Replace malformed front matter section with scope-based requirements
- [x] Replace hardcoded production host rule for portfolio-app links with env-driven rule
- [x] Narrow diagram policy to "Mermaid required for architecture/process diagrams" and allow non-diagram static assets
- [x] Remove or relocate temporal Stage 3.2 guidance from canonical policy

Recommended follow-up exact edit:

- [ ] Replace any remaining hardcoded host examples under policy sections with env-based patterns:
  - `NEXT_PUBLIC_DOCS_BASE_URL + "docs/..."`
  - `${DOCUSAURUS_SITE_URL}${DOCUSAURUS_BASE_URL}...`

## 2) Contributor workflow file

File: `CONTRIBUTING.md`

- [x] Add optional command under portfolio-docs quick checks:
  - `pnpm policy:check`
- [x] Replace repo-specific secrets-scan statement with policy-consistent wording based on active CI jobs

Recommended follow-up exact edit:

- [x] Add short "Policy consistency" subsection under quick checks:
  - Purpose of `pnpm policy:check`
  - Warning-only behavior
  - Strict mode usage for governance PRs (`pnpm policy:check:strict`)

## 3) PR template

File: `.github/PULL_REQUEST_TEMPLATE.md`

- [x] Add evidence item:
  - `[ ] pnpm policy:check reviewed (non-blocking drift warnings triaged)`

Recommended follow-up exact edit:

- [ ] Add optional notes line under Evidence:
  - `Policy warnings triage summary:`

## 4) Template governance guide

File: `docs/_meta/templates/README.md`

Required exact edits:

- [x] Replace stale Stage 3.1 example links if targets no longer exist or changed path shape.
- [x] Add section `## Policy Consistency Requirements` with these exact bullets:
  - `Use /docs/... internal links for rendered docs pages.`
  - `Use full GitHub blob links for non-rendered files.`
  - `Do not hardcode production hosts in template examples.`
  - `Phase/stage temporal guidance belongs in roadmap/issues, not canonical policy docs.`

## 5) Project dossier templates with stale legacy links

Files:

- `docs/_meta/templates/template-project-dossier/03-deployment.md`
- `docs/_meta/templates/template-project-dossier/05-testing.md`

Required exact edits:

- [x] Replace legacy path examples:
  - `/docs/architecture/...` -> `/docs/10-architecture/...`
  - `/docs/operations/...` -> `/docs/50-operations/...`
- [x] Normalize internal docs links to route-style examples where possible.

## 6) Generic issue template front matter policy scope

File: `docs/_meta/templates/template-github-issue-generic.md`

Required exact edit:

- [x] Keep template body without front matter (intended raw template), and document this exception in canonical instructions and templates README.

## 7) Policy checker tuning and allowlist

Files:

- `scripts/policy-consistency-check.sh`
- `scripts/policy-consistency-allowlist.txt`

Required exact edits:

- [x] Add allowlist support by rule category.
- [x] Narrow temporal-guidance detection to heading-level patterns.
- [x] Document approved exceptions in a dedicated allowlist file.

# Validation Steps

After completing remaining items:

1. Run `pnpm policy:check` and triage warnings.
2. Run `pnpm verify`.
3. Confirm PR template Evidence section reflects current policy checks.
4. Confirm no Tier C temporal content exists in canonical policy sections.

# Done Criteria

Remediation is done when:

- no unresolved high-severity policy contradictions remain
- active contributor guidance reflects active CI and local verification behavior
- templates model the same link and policy conventions as canonical instructions
