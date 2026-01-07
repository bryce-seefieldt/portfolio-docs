---
title: 'Templates Guide and Definitions of Done'
description: 'How to use documentation templates in this repository, including when to use each artifact type and the minimum Definition of Done (DoD) required for acceptance.'

tags: [meta, templates, governance, definition-of-done, documentation]
---

# Templates Guide and Definitions of Done

## Purpose

This document defines:

- when to use each template in `docs/_meta/templates/`
- the minimum **Definition of Done (DoD)** for each artifact type
- quality gates and review expectations so that humans and AI agents can contribute consistently

These templates are not optional. They enforce enterprise-level structure, traceability, and operational/security readiness.

## Scope

### In scope

- ADRs (Architecture Decision Records)
- Runbooks (Operational procedures)
- Threat models (Security analysis tied to a system boundary)
- Postmortems (Incident analysis and corrective action tracking)

### Out of scope

- general page writing rules (see `docs/_meta/doc-style-guide.md`)
- taxonomy and tagging rules (see `docs/_meta/taxonomy-and-tagging.md`)

## Template inventory

Current templates:

- `template-adr.md`
- `template-runbook.md`
- `template-threat-model.md`
- `template-postmortem.md`

Recommended conventions:

- Copy the template into the correct target directory.
- Fill all required sections.
- Remove placeholder text and “TBD” items unless explicitly tracked as planned work.

## Global rules (apply to all artifact types)

### Required front matter

All artifacts must have valid front matter with:

- `title`
- `description`
- `tags` (including the domain tag: `architecture` / `operations` / `security`)

### Standard section shape

Artifacts must maintain the repository’s standard shape:

1. Purpose
2. Scope
3. Prereqs / Inputs
4. Procedure / Content
5. Validation / Expected outcomes
6. Failure modes / Troubleshooting
7. References

Templates may add sections, but should not remove these headings.

### Public safety (non-negotiable)

Artifacts must not contain:

- secrets/tokens/private keys
- internal hostnames/private IPs
- raw logs with identifiers
- proprietary or sensitive details that should not be public

### Build hygiene

- Do not add markdown links to files that do not exist yet.
- The site must pass `pnpm build` before merge.

### PR expectations

Each PR must include:

- What changed
- Why
- Evidence (`pnpm build` passed)
- Security statement (“No secrets added”)

---

## ADR (Architecture Decision Record)

### When to use

Create an ADR when you:

- introduce or change core stack components (framework, hosting model, identity/auth, persistence)
- materially change system boundaries, trust boundaries, or data flows
- adopt/replace major platform capabilities (CI/CD gates, observability stack, deployment strategy)
- introduce a security control that has architectural implications

Do **not** create ADRs for:

- small refactors with no lasting implications
- purely editorial doc changes
- reversible experiments with no architectural consequences (use a short proposal note instead)

### Where it lives

- Primary: `docs/10-architecture/adr/`

### Naming convention

- `adr-0001-short-title.md`

### Minimum Definition of Done (ADR)

An ADR is complete only if it includes:

- **Context**: what problem and constraints exist
- **Decision**: clear statement of what is chosen
- **Alternatives considered**: at least 2 (or explicitly state why not applicable)
- **Consequences**: explicit tradeoffs, including operational and security impacts
- **Validation**: how success will be measured/verified
- **Failure modes + rollback/mitigation**: what can go wrong and what to do
- **References**: related architecture pages and impacted domains (security/runbooks/pipeline docs)

Quality checks:

- No implementation-level secrets
- Consequences include at least one operational and one security consideration (or explicitly “not applicable”)

---

## Runbook

### When to use

Create a runbook for any procedure that:

- an operator must execute under time pressure (deploy, rollback, triage)
- changes production-like state (config changes, dependency changes)
- is required to restore service or validate health

Do **not** use runbooks for:

- conceptual explanations
- raw command lists without a procedure (use Reference)
- one-off tasks that will never recur (unless it is likely to recur later)

### Where it lives

- Primary: `docs/50-operations/runbooks/`

### Naming convention

- `rbk-<system>-<task>.md`
  - e.g., `rbk-portfolio-deploy.md`, `rbk-portfolio-rollback.md`

### Minimum Definition of Done (Runbook)

A runbook is complete only if it includes:

- **Prereqs**: required access, tools, environment, and preconditions
- **Procedure**: step-by-step, copy/paste-safe commands
- **Validation**: explicit success checks (logs/metrics/smoke tests)
- **Rollback/Recovery**: explicit rollback triggers and a full rollback procedure
- **Failure modes**: common symptoms, causes, diagnostics, fixes
- **References**: relevant pipeline docs, architecture notes, and security considerations

Quality checks:

- Destructive steps have `:::warning` or `:::danger` admonitions
- Validation steps are executable and unambiguous
- Rollback is at least as detailed as deploy steps

---

## Threat Model

### When to use

Create or update a threat model when you:

- add/modify authentication/session handling
- introduce a new external integration or API boundary
- change data storage or data movement
- change deployment model (edge/CDN/headers) or runtime trust boundaries
- change CI/build integrity approach (supply chain posture)

Do **not** use threat models for:

- generic security advice without a defined system boundary
- purely theoretical risks unrelated to the service

### Where it lives

- Primary: `docs/40-security/threat-models/` (or `docs/40-security/` if you keep a single model)

### Naming convention

- `<system>-threat-model.md`
  - e.g., `portfolio-app-threat-model.md`

### Minimum Definition of Done (Threat Model)

A threat model is complete only if it includes:

- **System overview**: what is in scope, what is out of scope
- **Assets**: explicit list of what must be protected
- **Trust boundaries**: explicit boundary description
- **Entry points**: explicit list of external inputs and triggers
- **Threats**: concrete scenarios with impact/likelihood and mitigations
- **Controls required**: at least one enforceable SDLC control if applicable
- **Validation**: how mitigations are tested/verified
- **Residual risk**: explicit accepted risks with review notes (or “none”)

Quality checks:

- Threats are tied to entry points and assets (no free-floating lists)
- Mitigations are actionable, not vague
- Validation includes at least one reproducible check or evidence artifact expectation

---

## Postmortem

### When to use

Create a postmortem when:

- users experienced an outage, security event, or correctness issue
- a deploy required rollback or caused a material regression
- manual intervention was required to restore service or integrity
- monitoring/alerting failed to detect a meaningful issue in time

Do **not** use postmortems for:

- issues caught before user impact and resolved without incident response
- purely editorial documentation issues (use a normal PR note)

### Where it lives

- Primary: `docs/50-operations/incident-response/postmortems/`

### Naming convention

- `pm-YYYY-MM-DD-short-title.md`

### Minimum Definition of Done (Postmortem)

A postmortem is complete only if it includes:

- **Executive summary**: what happened, impact, duration, detection method
- **Timeline**: key events with timestamps and actions taken
- **Impact**: who/what was affected (public-safe)
- **Root cause**: primary cause + contributing factors
- **What went well / poorly**: honest operational assessment
- **Corrective actions**: owner, priority, due date, verification method
- **Validation**: how we confirm the issue is prevented or mitigated
- **References**: related PR/release/runbook/threat model (public-safe references)

Quality checks:

- Action items are verifiable (not “improve monitoring” without specifics)
- Postmortem is blameless and process-oriented
- Sensitive details are redacted/summarized appropriately

---

## Minimum acceptance checklist (quick reference)

Use this as a final scan before opening a PR:

- [ ] Correct template used for artifact type
- [ ] Front matter present (`title`, `description`, `tags`)
- [ ] Standard headings preserved
- [ ] No secrets or sensitive internals included
- [ ] Commands (if any) are fenced with language and copy/paste safe
- [ ] Validation steps present and actionable
- [ ] Rollback included for operational procedures
- [ ] References included (architecture/security/ops/cicd as relevant)
- [ ] `pnpm build` passes locally
- [ ] PR includes: what/why/evidence/no-secrets statement

## Troubleshooting

### “Where should this go?”

- Decisions → ADR
- How to do something safely and repeatedly → Runbook
- Security analysis tied to a boundary → Threat model
- User-impacting incident retrospective → Postmortem

### “This feels too heavy for a small change.”

Use the lightest artifact that still preserves traceability:

- small decision with lasting impact → ADR
- one operational action you might repeat → Runbook
- new entry point / integration → Threat model update
- any user impact incident → Postmortem

## References

This document is authoritative for artifact usage and DoD enforcement across the repository.
