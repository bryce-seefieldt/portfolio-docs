# Contributing to Development Documentation

## Authoring Guidance (Reduce Noise)

- Every major folder has an `index.md` that acts as a “section hub.”

- Enforce templates (ADR/runbook/postmortem/threat model) via `docs/_meta/templates/`.

- Treat `60-projects/portfolio-web-app/` as the canonical service doc set; each demo project mirrors the same headings (architecture, deployment, ops, security).

## Content

- Product/portfolio narrative → docs/00-portfolio/
- System design → docs/10-architecture/
- Engineering practices & local dev → docs/20-engineering/
- CI/CD, infra, observability → docs/30-devops-platform/
- Security posture & SDLC controls → docs/40-security/
- Runbooks, IR, DR/BCP → docs/50-operations/
- Project-specific dossiers → docs/60-projects/
- Reference/cheatsheets/configs → docs/70-reference/

## Branch Discipline

### Default model

- Default branch: `main`
- Branching approach: trunk-based (short-lived branches, small PRs)
- No direct pushes to `main`

### Branch Name Rules

Use one of the following prefixes:

- `docs/`: normal documentation additions/updates
- `sec/`: security posture, threat models, SDLC controls, security testing docs
- `ops/`: runbooks, incident response, DR/BCP, operational procedures
- `arch/`: architecture pages, diagrams, ADRs
- `ci/`: workflows, quality gates, build/deploy tooling
- `ref/`: reference material (CLI cheatsheets, config references)

Format:

```text
<prefix>/<area>-<short-topic>
```

Examples:

- `docs/architecture-c4-l1`
- `sec/threat-model-portfolio-app`
- `ops/runbook-deploy-rollback`
- `ci/link-check-workflow`
- `ref/wsl2-workstation-cheatsheet`

Hard rules:

- lowercase only
- no spaces
- keep under ~60 chars
- one topic per branch (avoid “mega branches”)

## PR Discipline

### Local setup (before starting work)

1. **Install and configure:**

   ```bash
   pnpm install
   cp .env.example .env.local
   ```

2. **Edit `.env.local`** with your local development values:

   ```env
   DOCUSAURUS_SITE_URL=http://localhost:3000
   DOCUSAURUS_GITHUB_ORG=your-github-username
   DOCUSAURUS_GITHUB_REPO_DOCS=portfolio-docs
   DOCUSAURUS_GITHUB_REPO_APP=portfolio-app
   DOCUSAURUS_PORTFOLIO_APP_URL=http://localhost:3000
   ```

   See [Environment Variables Contract](./docs/_meta/env/portfolio-docs-env-contract.md) for complete documentation and all available variables.

3. **Test locally:**

   ```bash
   pnpm start       # preview
   pnpm verify      # required before PR
   # Optional for faster iteration: pnpm verify:quick (skip build, rerun full verify before PR)
   ```

4. **Commit and push** (`.env.local` is gitignored; do not commit)

### PR Discipline (no changes)

All doc changes go through PRs (even solo)

PR must include:

- What changed
- Why
- Evidence (build output and links must pass, screenshots optional)

#### Issue closure via PRs

- Use a closing keyword in the PR description to auto-close the issue on merge into `main` (e.g., `Closes #123`, `Fixes #123`, `Resolves #123`).
- If multiple issues: list each on its own line with a closing keyword.
- If multiple PRs touch the same issue: only the PR targeting `main` should auto-close; other PRs should use non-closing phrasing (e.g., `Refs #123`).
- Verify the issue closed after merge; otherwise close manually with a comment.

### PR Title rules

Use Conventional Commit-like phrasing:

- docs: add CI/CD pipeline overview
- sec: add portfolio threat model
- ops: add deploy and rollback runbooks
- arch: add ADR for hosting choice
- ci: add docs build/link-check workflow

### PR Scope rules

A PR should typically be one of:

- add/update a single page (and references)
- add a new folder with `_category_` + `index.md` hub
- add one template
- add/update one CI workflow

If a PR touches multiple domains (`40-security` + `50-operations` + `30-devops-platform`) it should justify why, or split.

### Required checks (definition of merge-ready)

A PR is merge-ready only if:

1. **Quality gates pass**
   - `pnpm lint` succeeds (ESLint)
   - `pnpm typecheck` succeeds (TypeScript)
   - `pnpm format:check` succeeds (Prettier)
   - CI workflow `ci / quality` passes (GitHub Actions)
2. **Build passes**
   - `pnpm build` succeeds (no broken links; no broken refs)
   - CI workflow `ci / build` passes (GitHub Actions)
3. **Deployment Checks understanding**
   - Understand that after merge, production deployment is **automatic**
   - Deployment domain assignment is **gated** by **both** Deployment Checks passing (`ci / quality` and `ci / build`)
   - If checks fail, deployment is created but remains unpromoted; site stays on prior version
   - See [Deployment Checks flow](./docs/60-projects/portfolio-docs-app/03-deployment.md#release-governance-vercel-deployment-checks) for details
4. **Nav integrity**
   - if adding a folder: `_category_.json` (or .yml) exists
   - any new section has an index hub (generated or curated)
5. **Evidence**
   - include at least one of:
     - link(s) to the rendered page(s)
     - local build output snippet
     - screenshot of the rendered page (optional, but great for PR review)
6. **Security statement**
   - confirm: "No secrets added"
   - if security-related doc: link to updated threat model / control / test page (or state TBD + created issue)

**Quick check commands:**

For **portfolio-app** (two options):

**Option 1 - Comprehensive verification script (recommended):**

```bash
pnpm verify
```

Runs all quality checks with auto-formatting and detailed error reporting (environment check, format:write, format:check, lint, typecheck, registry:validate, build).

**Option 2 - Individual commands:**

```bash
pnpm format:write && pnpm lint && pnpm typecheck && pnpm build
```

Secrets scanning:

- CI gate runs `secrets:scan` via TruffleHog on PRs.
- Local verification does not run TruffleHog; a lightweight pattern-based scan is included.
- Optional local opt-in: enable pre-commit to run TruffleHog automatically:

```bash
pip install pre-commit
pre-commit install
```

For **portfolio-docs**:

- Recommended: `pnpm verify`
- Faster iteration: `pnpm verify:quick` (skips the build gate; run `pnpm verify` before opening a PR)
- Manual equivalent: `pnpm format:write && pnpm lint && pnpm typecheck && pnpm format:check && pnpm build`

All checks must pass before opening a PR.

### Review rules (solo-friendly)

Even as a solo maintainer, act like a team:

- Leave at least one review comment on your own PR before merging (e.g., “Checked nav, build ok”).
- Use squash merge to keep history clean

### Definition of Done

A doc PR is done only if:

- All quality gates pass (`pnpm verify`)
- CI checks pass (`ci / quality` and `ci / build`)
- New pages have front matter (title + sidebar rules)
- The page is placed in the correct domain folder
- Code follows ESLint/Prettier standards (auto-fixable with `pnpm lint:fix` and `pnpm format:write`)
- Any new process includes a rollback or recovery note (runbook mindset)
- Any security-relevant change updates at least one of:
  - threat model
  - secure SDLC controls
  - security testing notes

### Toolchain consistency (build determinism)

To ensure consistent builds across local, CI, and Vercel environments:

- **Environment variables**: Use `.env.local` for local development (see [Local setup](#local-setup-before-starting-work))
- **Never** manually update pnpm or Node versions without updating `package.json`
- Changes to `package.json` or `pnpm-lock.yaml` require:
  - Local `pnpm install --frozen-lockfile` + all quality gates verification
  - Commit of the updated lockfile
  - Confirmation that CI passes
- Corepack is enabled in Vercel (`ENABLE_EXPERIMENTAL_COREPACK=1`), which enforces `package.json#packageManager` pinning
- If you see "version mismatch" errors in Vercel builds, see [Build Determinism](./docs/60-projects/portfolio-docs-app/03-deployment.md#build-contract-and-determinism) section of the deployment dossier
- Lockfile/toolchain failures? See [Broken Links Triage Runbook](./docs/50-operations/runbooks/rbk-docs-broken-links-triage.md)

### Code quality and formatting

The project enforces code quality through automated gates:

**Linting (ESLint):**

- Configuration: `eslint.config.mjs`
- Run: `pnpm lint`
- Auto-fix: `pnpm lint:fix`
- Enforces: TypeScript best practices, React/Hooks rules, code quality standards

**Type checking (TypeScript):**

- Configuration: `tsconfig.json`
- Run: `pnpm typecheck`
- Validates: Type safety in config files and React components

**Formatting (Prettier):**

- Configuration: `.prettierrc.json`
- Run check: `pnpm format:check`
- Auto-format: `pnpm format:write`
- Standards: Single quotes, semicolons, 2-space indent, 80-char width, LF endings

**Before committing:**

```bash
pnpm verify          # Full local verification (format, lint, typecheck, format:check, build)
pnpm verify:quick    # Optional: skips build for faster iteration (run full verify before PR)
```

See [ADR-0004](/docs/architecture/adr/adr-0004-expand-ci-deploy-quality-gates) for quality gate rationale and [Testing](./docs/60-projects/portfolio-docs-app/05-testing.md) for details.

## Style Guide and Structure Rules

### File and folder conventions

- Folders: kebab-case (and use your numeric top-level ordering: 00-, 10-, etc.)
- Docs: kebab-case.md or kebab-case.mdx
  - Prefer .md unless you need React components; MDX is powerful but should be intentional.

### Front matter (required fields)

At top of every doc:

```yaml
---
title: 'Short, specific title'
description: '1–2 sentence summary of why this page exists.'
sidebar_position: 10
sidebar_label: 'Optional shorter label'
tags: [devops, security, portfolio]
---
```

Notes:

- `sidebar_label` can override generated sidebar labels when using autogenerated [sidebars](https://docusaurus.io/docs/sidebar/items)
- Use `unlisted: true` for WIP or pages you want accessible only by direct link; Docusaurus supports unlisted in docs [front matter](https://docusaurus.io/docs/api/plugins/@docusaurus/plugin-content-docs)

### Category metadata (required for every folder)

In each directory that appears in navigation, add `_category_.json` (or .yml) to control label/position and [optionally generate an index page](https://docusaurus.io/pt-BR/docs/sidebar/autogenerated)

Example:

```json
{
  "label": "CI/CD",
  "position": 2,
  "link": { "type": "generated-index" }
}
```

### Writing style (strict)

**Default voice:** professional, technical, operational.

**Rules:**

- No fluff. Every paragraph should answer: what, why, how, evidence, risk.
- Prefer imperative for procedures (“Run… Verify… Roll back…”) in runbooks.
- Prefer neutral/third-person for architecture and security (“The system performs…”).
- First-person is allowed only in 00-portfolio/ pages (interactive narrative).

### Standard page shape (use this everywhere)

**Every page should follow:**

1. Purpose (1–3 bullets)
2. Scope (what’s in/out)
3. Prereqs / Inputs
4. Procedure / Content
5. Validation / Expected outcomes
6. Failure modes / Troubleshooting
7. References (links to ADRs, runbooks, upstream docs)

### Admonitions (use consistently)

Use [Docusaurus admonitions](https://docusaurus.io/docs/next/markdown-features/admonitions) for operational clarity (notes, warnings, dangers). Syntax is triple-colon blocks like `:::note`, `:::tip`, etc.

Examples:

```md
:::note

Some **content** with _Markdown_ `syntax`.

:::

:::tip

Some **content** with _Markdown_ `syntax`.

:::

:::info

Some **content** with _Markdown_ `syntax`.

:::

:::warning

Some **content** with _Markdown_ `syntax`.
:::

:::danger

Some **content** with _Markdown_ `syntax`.
:::
```

### Code blocks and command examples (non-negotiable)

- Always specify the language fence:
  - `bash`, `powershell`, `yaml`, `json`, `ts`, `tsx`

- Commands must be copy/paste safe.
- If a command is destructive, prefix with a warning admonition and include a rollback.

### Security redaction and safe publication rules

Never commit:

- secrets, tokens, credentials, private keys
- internal hostnames, private IPs, personal emails, or proprietary logs

For evidence artifacts:

- Publish sanitized SAST/SCA summaries and SBOM excerpts
- Keep raw reports private unless redacted

### AI agent contribution protocol

#### Agent Contract:

Agent must:

- choose the correct target directory based on routing rules
- use the applicable template (ADR/runbook/threat model)
- include required front matter
- update or add `_category_.json` when creating a new folder
- add links to related ADRs/runbooks/security pages
- produce a short PR summary + a checklist mapping to “Definition of Done”

Agent must not:

- invent system details (if unknown, mark as `TBD:` and create a tracking issue)
- include secrets or pseudo-secrets
- change taxonomy without updating `docs/_meta/taxonomy-and-tagging.md`
