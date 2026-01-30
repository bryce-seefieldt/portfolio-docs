---
title: 'copilot-instructions.md (Overhaul Prompt + Canonical Agent Instructions)'
description: 'Canonical GitHub Copilot Agent operating instructions for the Portfolio Docs App (Docusaurus) and its role in the broader Portfolio program.'
tags:
  [
    meta,
    copilot,
    agent,
    governance,
    documentation,
    devops,
    security,
    operations,
  ]
---

# Purpose

This file defines the **canonical operating instructions** for the GitHub Copilot Agent used within VS Code for this repository.

It has two goals:

1. Enable the agent to safely and correctly **maintain and evolve the Docusaurus-based Portfolio Docs App** (this repository) as a production-grade documentation platform.
2. Enable the agent to safely and correctly **author enterprise-grade documentation content** that supports:
   - the Documentation App itself (as the first Project Dossier), and
   - future project dossiers for the broader Portfolio application and linked demo projects.

This repository is a **portfolio artifact** intended to demonstrate enterprise-level engineering discipline: docs-as-code governance, reproducibility, CI quality gates, security hygiene, operational readiness, and decision traceability.

---

# Copilot Agent Mission and Responsibilities

## Mission

Operate as a disciplined, enterprise-oriented engineering and documentation agent that:

- keeps the documentation system coherent, scalable, and professionally presented
- enforces strict docs-as-code governance and public-safety rules
- ensures changes are reproducible and build-validated
- updates documentation in lockstep with code, CI, and operational changes
- produces artifacts that look and read like a real, mature engineering organization

## Primary responsibilities

### A) Maintain the Documentation App (Docusaurus)

- update Docusaurus configuration responsibly
- maintain consistent navigation and information architecture
- maintain build determinism and CI discipline
- ensure deployment configuration (Vercel + GitHub checks) remains correct

### B) Maintain and author documentation content

- enforce standard page shapes, front matter, and taxonomy rules
- create/extend enterprise evidence artifacts (ADRs, threat models, runbooks, postmortems)
- maintain project dossiers under `docs/60-projects/`
- update release notes where changes materially affect the system

### C) Enforce safety and credibility constraints

- never introduce secrets or sensitive internal information
- never publish internal-only scaffolding content
- ensure documentation is public-safe and portfolio-appropriate
- treat quality gates and CI checks as non-negotiable

---

# High-Level System Context (Required Understanding)

## What this repository is

This repository is a **Docusaurus (TypeScript) docs-as-code system** that hosts:

- a public-facing documentation site (the Portfolio Docs App)
- enterprise-grade artifacts that document the planning, architecture, security posture, and operations of:
  - the docs platform itself
  - the future Portfolio web application
  - linked demo projects and supporting infrastructure

This docs platform is itself a **first-class project** (and the first project dossier entry) and must be treated like a production system.

## Data-driven project registry (Stage 3.1)

- Portfolio App now sources projects from a YAML registry; schema and validation rules must be documented and kept in sync.
- Registry schema reference: [docs/70-reference/registry-schema-guide.md](docs/70-reference/registry-schema-guide.md); decision record: [docs/10-architecture/adr/adr-0011-data-driven-project-registry.md](docs/10-architecture/adr/adr-0011-data-driven-project-registry.md).
- When registry shape changes, update the schema guide, ADR (if decision-level), and relevant project dossiers to keep evidence links accurate.
- YAML template for examples/guides:

```yaml
- slug: example-project
  title: 'Example Project'
  summary: 'Short proof-focused summary.'
  category: fullstack
  tags: ['Next.js', 'TypeScript']
  status: featured
  evidence:
    dossierPath: 'projects/example-project/'
    adrIndexPath: 'architecture/adr/'
    runbooksPath: 'operations/runbooks/'
    github: '{DOCS_GITHUB_URL}'
```

- Cross-repo linking examples to keep docs and app aligned:
  - Rendered docs: `NEXT_PUBLIC_DOCS_BASE_URL + "docs/portfolio/roadmap"`
  - Docs repo source: `NEXT_PUBLIC_DOCS_GITHUB_URL + "blob/main/docs/10-architecture/adr/adr-0011-data-driven-project-registry.md"`
  - App repo source: `https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/registry.ts`

**Project Status:** Complete Phase 3 (3.1–3.6). Phase 4 Stages 4.1–4.4 complete; Stage 4.5 (UX, Content, Advanced Features) ready to begin.
**Current work:** Stage 4.4 security posture deepening complete. App PR #61 (security headers, CSP, env documentation) and Docs PR #67 (threat model v2, risk register, policies, security hardening guide, dependency vulnerability runbook, phase-4-summary) both open and ready for review/merge. Both builds passing. Next: Stage 4.5 UX/content focus.

## Relationship to the future Portfolio project

The Portfolio Docs App is a **platform** that will document the broader Portfolio program:

- A NodeJS-based portfolio web application will be the centerpiece of the portfolio.
- The docs platform must scale to document that application and all linked projects with consistent enterprise practices.
- The docs app is the "evidence engine": it must contain ADRs, threat models, runbooks, postmortems, and dossiers that prove planning rigor, SDLC maturity, security posture, and operational readiness.

---

# Repository Architecture Requirements (Non-Negotiable)

## 1) Documentation is Markdown-first

- Author docs in Markdown (`.md`) by default.
- Use MDX (`.mdx`) only when required; treat MDX as **code** requiring higher scrutiny.

## 2) Information Architecture is enterprise domain-driven

Top-level docs domains use a numeric prefix system that is the canonical information architecture:

- `docs/00-portfolio/`
- `docs/10-architecture/`
- `docs/20-engineering/`
- `docs/30-devops-platform/`
- `docs/40-security/`
- `docs/50-operations/`
- `docs/60-projects/`
- `docs/70-reference/`

This scaffolding is intentional and must remain stable unless governed by an ADR.

## 3) Navigation is filesystem-driven with `_category_.json` governance

- `sidebars.ts` uses an **autogenerated** sidebar from the filesystem.
- Every folder that must appear in the sidebar must have a `_category_.json` defining:
  - label
  - position
  - link behavior (doc hub or generated-index)
- Top-level domains and major sections MUST have curated hub pages:
  - `<folder>/index.md` and category `link.type: "doc"` pointing to it.

## 4) `docs/_meta/` is internal-only scaffolding

- `docs/_meta/` is underscore-prefixed and MUST remain **non-public**.
- It may contain templates, style guides, taxonomy rules, and internal authoring procedures.
- Do not move `_meta` into public docs. If you need to publish governance pages publicly later, create a dedicated public domain (e.g., `docs/80-governance/`) and copy curated content there.

## 5) Build integrity and CI gates are mandatory

- `pnpm build` must pass locally before PR.
- CI must run `pnpm build` and block merge on failure.
- Broken internal links must be treated as failures (never “work around” by weakening gates).

## 6) Public safety rules are mandatory

Never commit or publish:

- secrets/tokens/keys
- internal endpoints, private hostnames, internal IP addresses
- sensitive logs or screenshots containing identifiers
- proprietary or confidential content

If sensitive publication is suspected, treat it as an incident:

- revert/remove immediately
- rotate credentials if applicable
- write a postmortem

---

# Toolchain and Runtime Standards

## Node and pnpm determinism

- Standardize on Node **20+**.
- Use pnpm with a pinned version via `package.json#packageManager`.
- If Vercel Corepack is enabled, ensure the pinned pnpm version is respected.

## Commands (canonical)

From repo root:

- `pnpm install`
- `pnpm start` (local preview)
- `pnpm build` (hard gate)
- `pnpm serve` (optional production-like local serve)

---

# Agent Workflow (How to Approach Any Task)

## Step 1 — Read the codebase and docs structure

Before making changes, always inspect:

- `README.md` (project overview and contributor expectations)
- `docusaurus.config.ts` (routes, base paths, global behavior)
- `sidebars.ts` (autogenerated sidebar config)
- `package.json` (scripts, engines, packageManager)
- `docs/index.md` (site entrypoint and narrative)
- top-level docs domains and their `index.md`
- templates and rules under `docs/_meta/` (internal-only)

## Step 2 — Identify scope and required cross-documentation updates

Any material change must update:

- a dossier page (if it affects a project’s behavior)
- ADR(s) (if it is a durable architectural decision)
- threat model(s) (if it changes trust boundaries or supply chain posture)- runbook(s) (if it changes deploy/rollback/triage steps)
- release notes (if it changes externally visible behavior or governance)

### Special case: CI/CD and verification process changes

**Mandatory:** When making changes to CI workflows or local verification processes, you MUST update the following files in the same PR:

**CONTRIBUTING.md updates required when:**

- Adding/removing/renaming CI jobs (`.github/workflows/ci.yml` or `.github/workflows/*.yml`)
  - Update: "Required checks (definition of merge-ready)" section → numbered list of checks
  - Update: Job names and descriptions in quality gates subsection
- Adding/removing/changing local verification steps or commands
  - Update: "Quick check commands" section for both portfolio-app and portfolio-docs
  - Update: Command examples in "Required checks" section
- Changing pnpm script names or adding new verification scripts
  - Update: All command references throughout CONTRIBUTING.md
  - Update: "For portfolio-app" and "For portfolio-docs" verification sections
- Adding new verification tools (like TruffleHog, Playwright)
  - Update: "Secrets scanning" or relevant subsections
  - Add installation/setup instructions if needed

**scripts/verify-docs-local.sh updates required when:**

- Adding/removing/changing verification steps in the local development workflow
  - Add: New step section with appropriate print_section, command execution, success/failure handling
  - Remove: Obsolete step sections
  - Update: Step numbers and descriptions to maintain sequential flow (Step 1, Step 2, etc.)
- Adding/removing pnpm scripts that should be run during local verification
  - Add: Execution block with appropriate error handling and troubleshooting guidance
  - Update: Summary section to reflect new check count
- Changing verification tools or their invocation (e.g., ESLint config changes, new TypeScript options)
  - Update: Tool version checks in "Environment check" section if applicable
  - Update: Troubleshooting guidance for the affected step
- Adding flags or options to existing commands (e.g., `--skip-build`, `--ci-mode`)
  - Add: Argument parsing in script header
  - Update: Help text and usage examples

**PULL_REQUEST_TEMPLATE.md updates required when:**

- Adding/removing/renaming CI jobs or changing job names displayed in GitHub UI
  - Update: "Evidence" section → CI job checklist (add/remove/rename checkboxes with descriptions)
- Changing what each CI job validates
  - Update: Job descriptions in parentheses (e.g., "Docusaurus build + broken links check")
- Adding new CI-only gates or conditional jobs
  - Update: Add notes about when job runs if applicable

**Validation before merge:**

- Verify CONTRIBUTING.md "Required checks" section lists all current CI jobs
- Verify CONTRIBUTING.md verification commands match actual scripts in `package.json`
- Verify PULL_REQUEST_TEMPLATE.md Evidence checklist matches `.github/workflows/ci.yml` jobs
- Confirm all command examples in CONTRIBUTING.md are copy/paste safe and current
- Verify scripts/verify-docs-local.sh steps match CONTRIBUTING.md verification workflow and `pnpm verify` execution

**Failure to update these files will cause:**

- Contributor confusion (CONTRIBUTING.md doesn't match reality)
- PR template checklist drift (missing/outdated CI jobs in Evidence section)
- Onboarding friction (new contributors follow outdated verification steps)
- Evidence gaps in PRs (checklist doesn't cover all required checks)
- Local verification script drift (developers run outdated checks)

**Example:** If you add a new `ci / link-validation` job:

1. Update CONTRIBUTING.md:
   - Add to "Required checks" list: "5. **Link validation** - \`ci / link-validation\` passes"
   - Add command example if there's a local equivalent: `pnpm links:check`
2. Update PULL_REQUEST_TEMPLATE.md:
   - Add to Evidence section: `- [ ] \`ci / link-validation\` passed (description)`
3. Update scripts/verify-docs-local.sh:
   - Add new step section (e.g., "Step 6: Link validation")
   - Add `pnpm links:check` execution with error handling
   - Update step numbers for subsequent steps if needed

---- runbook(s) (if it changes deploy/rollback/triage steps)

- release notes (if it changes externally visible behavior or governance)

## Step 3 — Implement changes in small, auditable increments

- Use minimal diffs.
- Avoid mixing unrelated refactors with content changes in one PR.
- When uncertain, create stubs first (index/hubs) then fill in.

## Step 4 — Validate locally and ensure CI correctness

- Run `pnpm build` before proposing changes.
- Do not disable checks to make builds pass.
- Fix root causes (links, structure, config).

## Step 5 — Enforce PR discipline

Even when working solo:

- Use a feature branch.
- Provide PR-ready summary:
  - What changed
  - Why
  - Evidence (`pnpm build` passed)
  - Security note (“No secrets added”)

---

# Template Enforcement and Phase Delivery

## When to Use Templates

This project uses **mandatory templates** to ensure governance discipline and traceability. Templates are not optional.

## Phase Planning & Stage Delivery

When working on **Phase N implementation**, use **linked templates**:

### 1. **Phase Implementation Guide** (`template-phase-implementation-guide.md`)

- **When:** Creating a phase plan from scratch
- **Output:** Published in `docs/00-portfolio/phase-[N]-implementation-guide.md`
- **Purpose:** Master plan for the entire phase across both repositories
- **Usage:**
  - Define all stages within the phase
  - Specify prerequisites and readiness criteria
  - Provide sequencing and interdependencies
  - Include total effort estimate and timeline
  - Document success criteria and verification steps
- **Frequency:** Once per phase (updated after phase completion with actual metrics)
- **Reference:** [Full Template Guide](./docs/_meta/templates/README.md#how-templates-work-together-the-phase-delivery-workflow)

### 2. **Phase Stage App Issue** (`template-phase-stage-app-issue.md`)

- **When:** Creating a GitHub issue for portfolio-app implementation work within a phase
- **Repository:** `portfolio-app`
- **Issue Title Format:** `Stage X.Y: [Stage Title] — App Implementation`
- **Purpose:** Traceable GitHub issue for code/implementation work
- **Required Sections:**
  - Overview and objectives
  - Files to create/update
  - Design and architecture (data model, API signatures)
  - Implementation tasks with checkboxes
  - Testing strategy (unit, integration, E2E)
  - Acceptance criteria
  - Success checks per task
- **Linking:** Link to companion docs stage issue in "Related Issues"
- **Reference:** [Full Template Guide](./docs/_meta/templates/README.md)

### 3. **Phase Stage Docs Issue** (`template-phase-stage-docs-issue.md`)

- **When:** Creating a GitHub issue for portfolio-docs documentation/analysis work within a phase
- **Repository:** `portfolio-docs`
- **Issue Title Format:** `Stage X.Y: [Stage Title] — Documentation`
- **Purpose:** Traceable GitHub issue for documentation and analysis work
- **Required Sections:**
  - Overview and objectives
  - Files to create/update
  - Document type (ADR, runbook, guide, threat model, etc.)
  - Content structure and outline
  - If ADR: problem statement, decision, rationale, consequences, alternatives
  - If guide: audience, prerequisites, key concepts, examples
  - Success criteria and verification steps
- **Linking:** Link to companion app stage issue in "Related Issues"
- **Reference:** [Full Template Guide](./docs/_meta/templates/README.md)

## Standalone Work (Non-Phase Issues)

For work **NOT tied to a phase stage**, use **Generic GitHub Issue** (`template-github-issue-generic.md`):

- **When:**
  - Urgent fixes (security patches, production bugs)
  - One-off improvements (performance tweaks, refactoring)
  - Ad-hoc documentation (single-page updates)
  - Maintenance (dependency upgrades, tooling)
- **Repository:** Either `portfolio-app` or `portfolio-docs`
- **Supported Types:** Bug, Feature, Enhancement, Documentation, Refactoring, Maintenance, Other
- **Purpose:** General-purpose tracking for non-phase work
- **Usage:**
  - Fill relevant sections only (adapt to issue type)
  - Provide clear acceptance criteria
  - Include testing strategy and effort estimate
  - Keep scope focused (one issue = one topic)
- **Reference:** [Full Template Guide](./docs/_meta/templates/README.md)

## Documentation Artifacts

For **evidence documents** created within or outside phases, use:

- `template-adr.md` — Architecture decisions (new frameworks, hosting, platform capabilities)
- `template-runbook.md` — Operational procedures (deploy, rollback, incident response)
- `template-threat-model.md` — Security analysis (system boundaries, attack surface)
- `template-postmortem.md` — Incident retrospectives (root cause, lessons learned)
- `template-project-dossier/` — Complete project documentation (8-page structure)

**Location in docs:**

- ADRs: `docs/10-architecture/adr/`
- Runbooks: `docs/50-operations/runbooks/`
- Threat models: `docs/40-security/threat-models/`
- Postmortems: `docs/50-operations/runbooks/` (in postmortem subsection)
- Project dossiers: `docs/60-projects/[project-name]/`

---

# Documentation Authoring Standards (Mandatory)

## Front matter

Every doc MUST include:

7.  PR discipline: use closing keyword (e.g., Closes #123) when linking issues.

- `description`
- `tags`
  When appropriate, include:
- `sidebar_position`

## Standard page shape

For most operational/technical pages, preserve this structure:

1. Purpose
2. Scope
3. Prereqs / Inputs
4. Procedure / Content
5. Validation / Expected outcomes
6. Failure modes / Troubleshooting
7. References

Exceptions:

- Pure index/hub pages may be shorter but still must be structured and navigable.

## Tone and quality

- write like an enterprise engineering organization
- prefer explicit steps and acceptance criteria over vague narrative
- define “how we know it worked” (validation) for every procedure
- avoid unverifiable claims; use evidence artifacts and references

## Linking policy (critical)

### Internal Links (within portfolio-docs)

- Use **relative paths starting with `/docs/`**
- **MUST include section prefix numbers:** `./00-portfolio/.` not `./portfolio/.`
- **MUST include `.md` file extension**
- Example: `[roadmap.md](/docs/00-portfolio/roadmap/index.md)`
- Do NOT link to pages that do not exist yet
- Broken links must be fixed immediately; builds should fail when they occur

### External Links (linking FROM portfolio-app TO portfolio-docs)

- Use **production deployment URL prefix:** `https://bns-portfolio-docs.vercel.app/docs/`
- Do **NOT include section prefix numbers:** use `/portfolio/` not `/00-portfolio/`
- Do **NOT include `.md` file extension**
- Example: `https://bns-portfolio-docs.vercel.app/docs/portfolio/roadmap`

### Repository Links (non-rendered content)

- Use **full GitHub repo URL** when linking to files not rendered in the served docs
- Example: `https://github.com/bryce-seefieldt/portfolio-app/blob/main/.github/workflows/ci.yml`
- Use this format for: workflow files, non-Docusaurus configs, build artifacts, source code

## Diagram standards (mandatory)

**ALL diagrams created within `docs/` subdirectories MUST use Mermaid format exclusively — never PNG, SVG, ASCII art, or external tools.**

- When adding or updating any diagram, follow the canonical style rules in [docs/70-reference/mermaid-diagram-style-guide.md](docs/70-reference/mermaid-diagram-style-guide.md) to ensure palette, shapes, and layout stay consistent across the site.

### Why Mermaid

- Natively supported by Docusaurus (v3.9+)
- Source code is version-controlled (no binary images)
- Renders consistently across light/dark modes
- Collaborative and maintainable alongside documentation

### Mermaid syntax and placement

- Place Mermaid code blocks using triple-backtick syntax: \`\`\`mermaid ... \`\`\`
- Example:
  ```
  \`\`\`mermaid
  graph LR
    A[System A] -->|HTTP| B[System B]
  \`\`\`
  ```
- All diagrams must render cleanly in HTML output
- Test locally: `pnpm build && pnpm serve` (verify both light and dark modes)

### Diagram types and use cases

| Type              | Use Case                                                  | Examples                                                      |
| ----------------- | --------------------------------------------------------- | ------------------------------------------------------------- |
| `graph LR/TD`     | Architecture, trust boundaries, system context, data flow | C4 system context, service dependencies, integration topology |
| `flowchart`       | Procedures, decision trees, workflows                     | Runbook steps, deployment procedures, incident triage         |
| `sequenceDiagram` | Temporal interactions, multi-step sequences               | Deployment flows, authentication handshakes, service calls    |
| `classDiagram`    | Component relationships, inheritance, layers              | Architecture patterns, service structure                      |
| `stateDiagram`    | State machines, lifecycle transitions                     | Build job states, deployment stages, service lifecycle        |
| `timeline`        | Historical events, phases, milestones                     | Roadmap timeline, release schedule, capability rollout        |

### Mandatory quality standards

1. **Context:** Every diagram MUST have explanatory text (caption or surrounding paragraph)
   - Explain what the diagram shows, why it matters, and any assumptions
2. **Focus:** Keep each diagram focused on a single concept; break large flows into multiple diagrams
3. **Labels:** Use descriptive node labels; avoid abbreviations where possible
4. **Readability:** Test locally (`pnpm build && pnpm serve`) in both light and dark modes; ensure text doesn’t overlap
5. **Accuracy:** Ensure labels and relationships reflect the actual system; indicate directionality and async/sync where relevant

### Common Mermaid patterns for portfolio-docs

**System context (graph):**

```
\`\`\`mermaid
graph LR
  User[User] -->|Browse| App[Portfolio App]
  App -->|Read| Docs[Portfolio Docs]
  App -->|Deploy| Vercel[Vercel Platform]
  Docs -->|Deploy| Vercel
\`\`\`
```

**Deployment workflow (flowchart):**

```
\`\`\`mermaid
flowchart TD
  A[PR Created] --> B{CI Checks Pass?}
  B -->|No| C[Fix Errors]
  C --> A
  B -->|Yes| D[Preview Deploy]
  D --> E{Merge Approved?}
  E -->|No| F[Iterate]
  F --> A
  E -->|Yes| G[Prod Deploy]
\`\`\`
```

**Runbook triage (flowchart):**

```
\`\`\`mermaid
flowchart TD
  A[Incident Detected] --> B[Check Logs]
  B --> C{Root Cause?}
  C -->|Config| D[Update Config]
  C -->|Code| E[Revert Deployment]
  C -->|Dependency| F[Pin Version]
  D --> G[Monitor]
  E --> G
  F --> G
  G --> H{Resolved?}
  H -->|Yes| I[Close Incident]
  H -->|No| J[Escalate]
\`\`\`
```

### Anti-patterns (never do these)

- ❌ Never commit PNG/SVG/image exports — always commit Mermaid source syntax
- ❌ Never use ASCII art or hand-drawn diagrams in source docs
- ❌ Never create diagrams without surrounding explanation text
- ❌ Never link to external diagram services (Lucidchart, Draw.io, etc.)
- ❌ Never use unsupported Mermaid features — test locally first

### Updating diagrams

When modifying an existing diagram:

1. Edit the Mermaid syntax directly in the `.md` file
2. Run `pnpm build` locally to verify rendering
3. Check both light and dark modes: `pnpm serve`
4. Include diagram changes in the same PR as content changes
5. Update caption/explanation if scope or purpose changed

### References and learning resources

- [Mermaid.js Official Documentation](https://mermaid.js.org/)
- [Docusaurus Mermaid Diagram Support](https://docusaurus.io/docs/markdown-features/diagrams)
- Portfolio-docs examples: `docs/10-architecture/` and `docs/50-operations/runbooks/`

---

# Enterprise Evidence Artifacts: When and How to Use Them

## ADRs (Architecture Decision Records)

Location:

- `docs/10-architecture/adr/`

Create an ADR when:

- choosing/altering major stack components (framework, hosting, nav strategy)
- changing trust boundaries or integration patterns
- changing CI gate or governance model

ADR minimum requirements:

- context
- decision
- alternatives
- consequences (ops + security)
- validation
- rollback/mitigation notes

## Threat models

Location:

- `docs/40-security/threat-models/`

Create/update when:

- adding integrations
- changing auth/session handling
- changing CI permissions or build chain
- changing deployment model or routing/base paths
- introducing MDX or dynamic content patterns

Threat model must include:

- assets
- trust boundaries
- entry points
- concrete threats with mitigations and validation
- residual risk and review cadence

## Runbooks

Location:

- `docs/50-operations/runbooks/`

Create/update when:

- deploy/rollback steps change
- build/quality gates change
- recurring failure modes appear (broken links, routing issues, dependency failures)

Runbooks must include:

- prerequisites
- step-by-step procedure
- validation
- rollback
- failure modes

## Postmortems

Location:

- `docs/50-operations/incident-response/postmortems/` (or agreed final location)

Write one when:

- user impact occurred
- rollback required
- sensitive publication occurred or suspected
- manual intervention was needed to restore service

Use the postmortem template in `docs/_meta/templates/template-postmortem.md`.

---

# Vercel Deployment Governance (Required Understanding)

## Expected deployment model

- PR branches produce preview deployments.
- `main` produces production deployment.
- Vercel may use Deployment Checks to gate promotion until GitHub Actions checks pass.

## Agent behavior

When asked to implement deployment changes:

- ensure CI workflows exist and are stable
- ensure checks run on `push` to `main` and on PRs
- document changes in:
  - dossier deployment page
  - ADR hosting strategy
  - runbooks (deploy/rollback/triage)

---

---

# Environment Variables and Configuration

## Standard Configuration Pattern

The Portfolio Docs App uses environment variables to support portability across local, preview, and production deployments.

### Variable Prefix Convention

- **`DOCUSAURUS_*`**: Client-exposed variables (available in browser)
- **Non-prefixed**: Build-time only (server-side, not available in React)
- Analogous to Next.js `NEXT_PUBLIC_*` convention

### Core Variables

| Variable                       | Purpose                       | Local                   | Production                              |
| ------------------------------ | ----------------------------- | ----------------------- | --------------------------------------- |
| `DOCUSAURUS_SITE_URL`          | Base URL for SEO, sitemap     | `http://localhost:3000` | `https://bns-portfolio-docs.vercel.app` |
| `DOCUSAURUS_BASE_URL`          | Subpath (if any)              | `/`                     | `/`                                     |
| `DOCUSAURUS_GITHUB_ORG`        | GitHub org/user               | your-username           | bryce-seefieldt                         |
| `DOCUSAURUS_GITHUB_REPO_DOCS`  | Docs repo name                | portfolio-docs          | portfolio-docs                          |
| `DOCUSAURUS_GITHUB_REPO_APP`   | App repo name (cross-linking) | portfolio-app           | portfolio-app                           |
| `DOCUSAURUS_PORTFOLIO_APP_URL` | Portfolio App URL             | `http://localhost:3000` | `https://bns-portfolio-app.vercel.app`  |

### File Structure

- **`.env.example`**: Template (committed, no secrets)
- **`.env.local`**: Local overrides (gitignored, not committed)
- **`.env.production.local`**: Production overrides (gitignored, optional)

### Enforcement

- **Local development**: Always use `.env.local` (copied from `.env.example`)
- **Production (Vercel)**: Set variables in Vercel Dashboard → **Settings → Environment Variables**
- **CI**: Use production values automatically during build
- **Security**: No secrets in any `.env` files; all values are public-safe

### Full Reference

See [Portfolio Docs Environment Variables Contract](./docs/_meta/env/portfolio-docs-env-contract.md) for:

- Complete variable documentation
- Environment-specific examples
- React component access via customFields
- File precedence rules
- Security guidelines
- **Deployed URLs:** When constructing links to the deployed docs site, use environment variables (do **not** hardcode production host): `${DOCUSAURUS_SITE_URL}${DOCUSAURUS_BASE_URL}<path>` or the precomputed `NEXT_PUBLIC_DOCS_BASE_URL` pattern where applicable. The only exception is internal links inside authored docs that must remain relative `/docs/...`.

---

# URL Linking Standards (Required for All Documentation)

**Env-first rule:** For any deployed URL (portfolio-docs or portfolio-app), build the URL using the appropriate environment variables (e.g., `${DOCUSAURUS_SITE_URL}${DOCUSAURUS_BASE_URL}` for docs, `NEXT_PUBLIC_DOCS_BASE_URL` from portfolio-app). Do **not** hardcode production hosts. The only exception is internal links within authored docs that are rendered on the site—those must stay as relative `/docs/...` links per the rules below.

## Linking within portfolio-docs (authoring in this repository)

When creating URLs inside portfolio-docs source (Markdown/MDX under `docs/`):

- **Hosted docs pages (rendered on the site):**
  - Use **relative paths starting with `/docs/`**
  - **Include section prefix numbers** (e.g., `00-portfolio`, not `portfolio`)
  - **Include `.md` file extension**
  - Example: `[ADR-0001](/docs/10-architecture/adr/adr-0001-adopt-docusaurus-for-portfolio-docs.md)`

- **Docs hub pages using `index.md`:**
  - When constructing **published site URLs**, do **not** include `index.md` in the path.
  - Example: `docs/00-portfolio/index.md` → published at `https://bns-portfolio-docs.vercel.app/docs/portfolio/` (built as `NEXT_PUBLIC_DOCS_BASE_URL + "docs/portfolio/"`).

- **Non-hosted files (e.g., `docs/\_meta/**` or any file not rendered by the site):\*\*
  - Link to the GitHub blob URL: `https://github.com/<org>/<repo>/blob/main/<path>`
  - Use environment-driven pattern when available: `https://github.com/${DOCUSAURUS_GITHUB_ORG}/${DOCUSAURUS_GITHUB_REPO_DOCS}/blob/main/<path>`
  - Apply the same rule from portfolio-app when linking to `docs/_meta` (these files are not hosted on the site).

These rules are **mandatory** for all links authored within the portfolio-docs repository.

## Linking within portfolio-docs (internal cross-references)

When linking from one page to another **within** the portfolio-docs repository:

**Rules:**

- Use relative paths starting with `/docs/`
- **DO include** section prefix numbers (e.g., `00-portfolio`, `10-architecture`)
- **DO include** `.md` file extension
- Use markdown link syntax: `[display text](path)`

**Examples:**

- ✅ `[roadmap.md](/docs/00-portfolio/roadmap/index.md)`
- ✅ `[Architecture ADRs](/docs/10-architecture/adr/)`
- ✅ `[Threat model](/docs/40-security/threat-models/portfolio-app-threat-model.md)`
- ❌ `[roadmap](/docs/portfolio/roadmap)` (missing prefix + extension)
- ❌ `https://github.com/bryce-seefieldt/portfolio-docs/blob/main/docs/00-portfolio/roadmap.md` (use relative links for internal nav)

## Linking to non-rendered portfolio-docs files (configuration, repo metadata)

When linking to files in portfolio-docs **outside** of `/docs/` (e.g., root config, CI workflows, package.json):

**Rules:**

- Use full GitHub repository URLs
- Format: `https://github.com/bryce-seefieldt/portfolio-docs/blob/main/<path>`
- **DO include** file extensions
- Use for: CI workflows, config files, metadata, root-level documentation

**Examples:**

- ✅ `https://github.com/bryce-seefieldt/portfolio-docs/blob/main/package.json`
- ✅ `https://github.com/bryce-seefieldt/portfolio-docs/blob/main/.github/workflows/ci.yml`
- ✅ `https://github.com/bryce-seefieldt/portfolio-docs/blob/main/docusaurus.config.ts`
- ❌ `[package.json](/package.json)` (not a doc, use full GitHub URL)

## Linking to portfolio-app files

When linking to the portfolio-app repository:

**Rules:**

- Use full GitHub repository URLs
- Format: `https://github.com/bryce-seefieldt/portfolio-app/blob/main/<path>`
- **DO include** file extensions
- Use for: CI workflows, source code, config files, non-rendered artifacts

**Examples:**

- ✅ `https://github.com/bryce-seefieldt/portfolio-app/blob/main/.github/workflows/ci.yml`
- ✅ `https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/config.ts`
- ✅ `https://github.com/bryce-seefieldt/portfolio-app/blob/main/package.json`
- ✅ Link references in dossiers to portfolio-app deployment checks, CI code, etc.

## Linking from portfolio-app to portfolio-docs (see portfolio-app instructions)

The portfolio-app uses environment variables to link to rendered docs:

- `NEXT_PUBLIC_DOCS_BASE_URL` for rendered Docusaurus pages
- `NEXT_PUBLIC_DOCS_GITHUB_URL` for non-rendered portfolio-docs files

See `.github/copilot-instructions.md` in portfolio-app for detailed URL rules from that repository's perspective.

---

# File/Folder Creation Rules (Strict)

## Adding a new section (folder) in public docs

When adding any new navigable folder:

1. Create folder under correct domain (e.g., `docs/40-security/<new-folder>/`)
2. Add `_category_.json` with:
   - label
   - position
   - link behavior
3. Add `index.md` if it is a major section or needs a curated hub.
4. Validate with `pnpm build`.

## Adding templates or internal instructions

Place in:

- `docs/_meta/`

Never place internal authoring mechanics into public-facing domains unless explicitly approved and curated.

---

# Phase 3 Stage 3.2 — Documentation Work

## Overview

Stage 3.2 is the EvidenceBlock component implementation stage (portfolio-app) paired with documentation updates (portfolio-docs).

The app work creates three reusable React components for evidence visualization. The docs work involves:

1. Updating Portfolio App dossier with component architecture details
2. Ensuring ADRs and runbooks remain aligned
3. Updating copilot-instructions in portfolio-app with component specs (already done)

## Documentation Tasks for Stage 3.2

### 1. Update Portfolio App Dossier (`docs/60-projects/portfolio-app/`)

**Files to update:**

- `01-overview.md` — Add brief mention of component library introduction
- `02-architecture.md` — Add new section: "Evidence Visualization Layer (Stage 3.2)"

**Section Content (02-architecture.md):**

Create a new subsection after the registry section:

```markdown
### Evidence Visualization Layer (Stage 3.2)

**Components:**

Three new React components standardize evidence artifact linking:

- `EvidenceBlock.tsx` — Renders evidence cards (dossier, threat model, ADRs, runbooks, GitHub)
- `VerificationBadge.tsx` — Status badges indicating evidence completeness (docs-available, threat-model, gold-standard, adr-complete)
- `BadgeGroup.tsx` — Multi-badge container with conditional rendering based on project evidence

**Integration:**

- Used on `/projects/[slug]` pages to display project evidence trail
- Allows reviewers to verify evidence availability at a glance
- Responsive design: mobile (1 col) → tablet (2 cols) → desktop (3 cols)

**Styling:**

- Tailwind CSS 4 with `dark:` mode support
- Gold Standard badge: amber colors (reference: GoldStandardBadge.tsx)
- Other evidence badges: blue, violet, indigo (matching evidence type)

**Maintainability:**

- Components accept `project: Project` prop from registry
- Uses environment-aware URL helpers (`docsUrl()`, `githubUrl()`)
- No hardcoded links; all evidence paths from `src/data/projects.yml`

**See Also:**

- Component specifications: [`@/app/.github/copilot-instructions.md`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/.github/copilot-instructions.md) (Section 8 — Phase 3 Stage 3.2)
- Stage 3.2 app issue: [stage-3.2-app-issue](/docs/00-portfolio/roadmap/issues/stage-3.2-app-issue.md) (linked in PR)
```

### 2. Update Copilot Instructions (Already Done)

The portfolio-app copilot-instructions already received Section 8 updates with full component specifications. No additional docs work needed here.

### 3. Verify Evidence Link Consistency

**Checklist for docs review:**

- [ ] All evidence paths in dossier match `src/data/projects.yml` schema
- [ ] ADRs and threat models referenced in dossier still exist and are not broken links
- [ ] Runbook paths are accurate (check against `docs/50-operations/runbooks/` structure)
- [ ] No new gaps introduced in evidence availability for portfolio-app

### 4. Update Release Notes (Post-Implementation)

**File:** `docs/00-portfolio/release-notes/` (create new entry if needed or update existing draft)

After Stage 3.2 completes, add entry:

```markdown
## Stage 3.2: Evidence Components (2026-01-XX)

**What changed:**

- Introduced EvidenceBlock component for standardized evidence linking
- Introduced VerificationBadge component for status indicators
- Introduced BadgeGroup utility for multi-badge rendering
- Updated project detail pages (`/projects/[slug]`) to integrate components

**Why:**

- Standardizes how projects display evidence artifacts (dossier, threat model, ADRs, runbooks)
- Enables reviewers to quickly verify evidence availability
- Supports gold-standard designation and quality signals

**Impact:**

- All featured project pages now display evidence badges and linked artifacts
- Responsive design improves mobile UX for evidence discovery
- Dark mode support for consistent portfolio experience

**Evidence:**

- PR: portfolio-app#XY
- Components: `src/components/{EvidenceBlock,VerificationBadge,BadgeGroup}.tsx`
- Dossier update: [Portfolio App Architecture — Evidence Visualization](/docs/60-projects/portfolio-app/02-architecture.md#evidence-visualization-layer-stage-32)
```

## Documentation Quality Standards for Stage 3.2

- Component descriptions must be specific about props, styling, and responsive behavior
- Evidence link validation is critical: verify all paths resolve when stage is complete
- Maintain consistency between app and docs: if component props change, dossier documentation must reflect that
- Use Mermaid diagrams if helpful (e.g., component hierarchy or evidence flow diagram)

---

# Required Self-Checks Before Any Change Proposal

Before generating a change plan or diff, the agent must confirm:

- [ ] I have read the existing docs structure and key config files.
- [ ] I understand which domain(s) this change touches.
- [ ] I know what evidence artifacts need updates (ADR/threat model/runbooks/dossier).
- [ ] I will not introduce broken links or references to non-existent docs.
- [ ] I will not introduce secrets or sensitive information.
- [ ] I will run (or require) `pnpm build` as the hard gate.

---

# Task Execution Mode: How to Proceed When Asked to Implement Work

When given a task, the agent should respond with:

1. **Repository reconnaissance summary**
   - what files were inspected
   - what assumptions were validated

2. **Change plan**
   - list of file changes (create/update)
   - rationale for each change
   - what documentation artifacts must be updated

3. **Implementation steps**
   - exact commands and edits (public-safe)
   - how to validate locally
   - how CI validates

4. **DoD checklist**
   - evidence that build passes
   - evidence that docs updates are in place
   - security statement

---

# Appendix: Non-Negotiable Principles

- Do not weaken quality gates to make builds pass.
- Do not publish internal-only scaffolding content.
- Do not create documentation without validation steps.
- Do not create operational guidance without rollback procedures.
- Do not introduce unverifiable claims; tie changes to evidence artifacts.

---

# End of copilot-instructions.md
