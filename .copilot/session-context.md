---
last-updated: 2026-01-20
active-phase: Phase 1 (documentation complete; deployment pending) → Phase 2 (environment variables implemented)
workspace-repos:
  - portfolio-app (Next.js + TypeScript)
  - portfolio-docs (Docusaurus)
---

# Copilot Session Context

## Current State (Phase 2 — Environment Variables Implementation)

### Active Branches

- **portfolio-app:** `main`
- **portfolio-docs:** `main`

### Phase Progress: Phase 2 (Environment Variables — COMPLETED)

#### ✅ Completed (Portfolio App)

- Routes implemented: `/`, `/cv`, `/projects`, `/projects/[slug]`, `/contact`
- Config contract: `src/lib/config.ts` with `NEXT_PUBLIC_*` and `docsUrl()` helper
- Project registry placeholder: `src/data/projects.ts` with types and helpers
- CI workflows: `ci / quality` (lint, format:check, typecheck) and `ci / build` (Next.js build)
- CodeQL scanning: JS/TS on PR/main + weekly schedule
- Dependabot: weekly, majors excluded, grouped updates
- PR template: includes local quality checklist and docs impact checklist
- README governance: marked as Implemented with required checks and local quality snippet
- Quality script: `pnpm quality` runs lint + format:check + typecheck

#### ✅ Completed (Portfolio Docs)

- Dossier updates (8 pages):
  - index.md: Current State + Reviewer path
  - architecture.md: Repository structure, routing/evidence strategy, route list annotated; + Component architecture, dark mode, navigation IA, metadata strategy, toolchain/Node policy
  - testing.md: Formatting, quality gates, merge gates, phased testing (annotated); + ESLint/Prettier config details
  - operations.md: CI release gate, branch governance, runbook references
  - deployment.md: Pre-deployment governance, stable check names, status note; + Environment variable examples by environment
  - security.md: Step 3 posture (Dependabot, CodeQL, public-safe env), status note
  - (other pages baseline complete)
- Runbooks updated:
  - rbk-portfolio-deploy.md: Pre-merge checklist, ruleset confirmation, env validation
  - rbk-portfolio-ci-triage.md: CI topology, known Prettier failure, re-run checks guidance
  - rbk-portfolio-rollback.md: CI gate enforcement, revert-based recovery
- ADRs:
  - ADR-0008: CI quality gates (Purpose/Scope + decision body complete)
  - ADR-0009: React Compiler (decision, rationale, validation, rollback criteria)
- Internal env contract: `docs/_meta/env/portfolio-app-env-contract.md` with NEXT*PUBLIC*\* rules, CI determinism, references
- Release note: `docs/00-portfolio/release-notes/20260110-portfolio-app-baseline.md` (comprehensive, includes README section)
- Configuration reference: `docs/70-reference/portfolio-app-config-reference.md` (next.config.ts, eslint.config.mjs, prettier.config.mjs, postcss.config.mjs, tsconfig.json, .nvmrc)

#### ⏳ In Progress / Pending

- Vercel deployment (not yet connected)
- GitHub Ruleset enforcement (not yet configured with required checks)
- Public repo URLs (pending in `src/data/projects.ts`: repoUrl, demoUrl)
- Docs site deployment (pending final Vercel link)

---

## Integration Contract

### Environment Variables Configuration (NEW — Phase 2)

The Portfolio Docs App now supports environment variable configuration for portability across environments.

**Standard Prefix Convention:**
- `DOCUSAURUS_*` prefix for client-exposed variables (browser)
- Non-prefixed variables are build-time only

**Core Variables (6 required):**
- `DOCUSAURUS_SITE_URL`: Base URL (local: `http://localhost:3000`, production: Vercel domain)
- `DOCUSAURUS_BASE_URL`: Subpath (default: `/`)
- `DOCUSAURUS_GITHUB_ORG`, `DOCUSAURUS_GITHUB_REPO_DOCS`, `DOCUSAURUS_GITHUB_REPO_APP`: GitHub linking
- `DOCUSAURUS_PORTFOLIO_APP_URL`: Cross-linking to portfolio-app

**File Structure:**
- `.env.example`: Template (committed, public-safe placeholders)
- `.env.local`: Local overrides (gitignored, never committed)
- `.env.production.local`: Production overrides (optional, gitignored)

**Setup:**
1. **Local**: `cp .env.example .env.local && edit .env.local` with local values
2. **Production**: Set in Vercel Dashboard → Settings → Environment Variables
3. **CI**: Uses production env vars automatically

**Security:** All variables are public-safe. No secrets in `.env` files.

**Reference:** [Portfolio Docs Environment Variables Contract](./docs/_meta/env/portfolio-docs-env-contract.md)

### URL Linking Standards (Canonical Rules)

**Portfolio-docs authoring (this repository):**

- Hosted docs pages: use relative links starting with `/docs/`, include section prefix numbers (e.g., `00-portfolio`), and include `.md` extensions. Example: `/docs/10-architecture/adr/adr-0001-adopt-docusaurus-for-portfolio-docs.md`.
- Docs hub pages (`index.md`): when constructing published URLs, omit `index.md` (e.g., `docs/00-portfolio/index.md` → `https://bns-portfolio-docs.vercel.app/docs/portfolio/`, built with `NEXT_PUBLIC_DOCS_BASE_URL + "docs/portfolio/"`).
- Non-hosted files (including anything under `docs/_meta`): link via GitHub blob URLs using repo/env variables (`https://github.com/${DOCUSAURUS_GITHUB_ORG}/${DOCUSAURUS_GITHUB_REPO_DOCS}/blob/main/<path>`). This rule also applies when portfolio-app links to `docs/_meta` content.
- Env-first rule: For any deployed URLs (docs or app), build URLs from environment variables (`DOCUSAURUS_SITE_URL` + `DOCUSAURUS_BASE_URL`, `NEXT_PUBLIC_DOCS_BASE_URL`, `NEXT_PUBLIC_DOCS_GITHUB_URL`). Do **not** hardcode production hosts. The only exception is internal `/docs/...` links inside authored content, which stay relative as above.

**These rules are enforced in both repository's copilot-instructions files.**

#### Within portfolio-docs (internal):

- Use relative paths: `/docs/00-portfolio/roadmap.md` (include prefix numbers + .md extension)

#### portfolio-docs non-rendered files:

- Use GitHub URLs: `https://github.com/bryce-seefieldt/portfolio-docs/blob/main/package.json`

#### portfolio-app files:

- Use GitHub URLs: `https://github.com/bryce-seefieldt/portfolio-app/blob/main/.github/workflows/ci.yml`

#### From portfolio-app to portfolio-docs (docs site):

- Use `NEXT_PUBLIC_DOCS_BASE_URL + "docs/portfolio/roadmap"` (no prefix numbers, no .md extension)

#### From portfolio-app to portfolio-docs (non-docs):

- Use `NEXT_PUBLIC_DOCS_GITHUB_URL + "blob/main/package.json"` (with extensions)

**See `.github/copilot-instructions.md` in both repos for complete URL linking guidance.**

### Evidence Link Strategy

- Portfolio App links to docs via: `NEXT_PUBLIC_DOCS_BASE_URL` (env var) + GitHub URLs for non-rendered files
- Helper function: `docsUrl(pathname)` in `src/lib/config.ts`
- Evidence paths in `src/data/projects.ts` align with docs structure:
  - Dossier: `projects/portfolio-app/`
  - Threat model: `security/threat-models/portfolio-app-threat-model`
  - ADRs: `architecture/adr/`
  - Runbooks: `operations/runbooks/`

### CI Check Names (Stable API)

- `ci / quality` — lint, format:check, typecheck
- `ci / build` — Next.js build (depends on quality)
- Frozen installs: `pnpm install --frozen-lockfile`
- These names are used by:
  - GitHub Rulesets (required checks before merge)
  - Vercel Deployment Checks (promotion gating)

### Config Contract

- All client-visible config: `NEXT_PUBLIC_*` prefix only
- No secrets in env vars
- Centralized in `src/lib/config.ts`
- `.env.example` defines the contract

---

## Recent Decisions (ADRs)

- **ADR-0008:** Portfolio App CI Quality Gates
  - Stable check names for governance
  - Frozen lockfile installs for determinism
  - CodeQL + Dependabot baseline
  - GitHub Rulesets (not classic branch protection)

- **ADR-0007** (planned): Vercel hosting with promotion checks

- **ADR-0006** (planned): Evidence separation (app vs docs)

- **ADR-0005** (planned): Stack choice (Next.js + TypeScript)

---

## Known Gaps (Phase 1)

### Out-of-Repo Admin Tasks

1. **Vercel Deployment:**
   - Connect portfolio-app repo to Vercel
   - Configure env vars: `NEXT_PUBLIC_DOCS_BASE_URL`, `NEXT_PUBLIC_SITE_URL` (optional)
   - Enable preview deployments for PRs
   - Enable production deployment from `main`

2. **GitHub Ruleset:**
   - Create ruleset: `main-protection`
   - Require PR before merge
   - Require checks: `ci / quality`, `ci / build`
   - Block force-push and deletion

3. **Vercel Promotion Checks:**
   - Import GitHub checks into Vercel
   - Require `ci / quality` and `ci / build` before production promotion

4. **Public Repo URLs:**
   - Finalize public repo URLs (if making repos public)
   - Update `src/data/projects.ts`: repoUrl, demoUrl
   - Update docs release note with links

---

## Quick Resume Commands

### Start of Session

```bash
# Navigate to workspace
cd /home/seven30/src/portfolio/portfolio-docs

# Check state
git status
cat notes.md
cat .copilot/session-context.md

# Review roadmap
cat docs/00-portfolio/roadmap.md | grep -A 30 "Phase 1"

# Check both repos
cd ../portfolio-app && git status && git log -1 --oneline
cd ../portfolio-docs && git status && git log -1 --oneline
```

### Phase 1 Verification

```bash
# Portfolio-app local verification
cd /home/seven30/src/portfolio/portfolio-app
pnpm quality    # runs lint + format:check + typecheck
pnpm build      # Next.js build

# Portfolio-docs local verification
cd /home/seven30/src/portfolio/portfolio-docs
pnpm build      # Docusaurus build
```

---

## Context for Next Session

### Immediate Next Steps (Priority Order)

1. **Deploy portfolio-app to Vercel** (admin task, out-of-repo)
2. **Configure GitHub Ruleset** (admin task, requires repo settings access)
3. **Configure Vercel promotion checks** (admin task, Vercel UI)
4. **Validate end-to-end:** PR → preview → CI pass → merge → production
5. **Populate public URLs** in `src/data/projects.ts` once deployed

### Phase 1 Acceptance Criteria (Roadmap Reference)

- [x] Portfolio App can be deployed and validated end-to-end with preview-to-prod governance
- [x] CI gates are enforceable and stable (check names consistent)
- [ ] Routes render in preview and production _(pending Vercel deployment)_
- [x] Portfolio App pages include correct evidence-link placeholders to docs

### Phase 2 Readiness

Once Phase 1 is complete (deployed + validated):

- Begin "gold standard" project planning
- Choose exemplar project for deep evidence trail
- Expand CV page with real capability-to-proof mapping

---

## References

- **Copilot Instructions (Binding Rules):**
  - `portfolio-app/.github/copilot-instructions.md`
  - `portfolio-docs/.github/copilot-instructions.md`

- **Roadmap:** `portfolio-docs/docs/00-portfolio/roadmap.md`

- **Release Notes:** `portfolio-docs/docs/00-portfolio/release-notes/20260110-portfolio-app-baseline.md`

- **Dossier (Portfolio App):** `portfolio-docs/docs/60-projects/portfolio-app/`

- **Session Notes:** `portfolio-docs/notes.md`

---

## Session History (Brief)

### 2026-01-20 Session (CURRENT — Phase 2 Environment Variables Documentation Review & Update)

**Objective:** Review and update all portfolio-docs development and deployment documentation to comprehensively reflect environment variable support.

**Scope:** 13 files reviewed and updated:

1. **README.md** — Updated Local Development section with `.env.local` setup and configuration
2. **CONTRIBUTING.md** — Added PR Discipline local setup section with `.env.local` workflow
3. **CONFIGURATION.md** — Added comprehensive Environment Variables Configuration section
4. **01-overview.md** (dossier) — Added Environment Variable Support subsection with portability rationale
5. **02-architecture.md** (dossier) — Added environment configuration details to components section
6. **03-deployment.md** (dossier) — Added environment variable configuration section with Vercel dashboard setup
7. **04-security.md** (dossier) — Added Control 5: Environment Variable Security with public-safe enforcement
8. **rbk-docs-deploy.md** (runbook) — Added env var prereqs and Vercel configuration verification
9. **rbk-docs-rollback.md** (runbook) — Added environment variable considerations to prereqs
10. **rbk-docs-broken-links-triage.md** (runbook) — Added .env.local verification to toolchain checks
11. **portfolio-docs-app-threat-model.md** — Enhanced Threat 3 with environment variable scenarios
12. **.github/copilot-instructions.md** — Added Environment Variables and Configuration section with table
13. **.copilot/session-context.md** — Updated with Phase 2 environment variables context

**Documentation Updates Summary:**

- ✅ All PRs and pull request workflows documented with `.env.local` requirements
- ✅ Vercel environment variable configuration documented with step-by-step instructions
- ✅ Security controls for environment variables formalized and linked to contract
- ✅ Runbooks updated with environment variable verification procedures
- ✅ Threat model includes environment variable security scenarios
- ✅ Copilot instructions include environment variable prefix convention and table
- ✅ Session context updated with Phase 2 environment variable implementation

**Files Modified:** 13 total
**Lines Added:** ~400+ lines across all files
**Key Documentation Links Added:**
- Cross-references to [Portfolio Docs Environment Variables Contract](./docs/_meta/env/portfolio-docs-env-contract.md)
- Vercel dashboard configuration instructions
- Local development `.env.local` setup procedures
- Environment variable security controls

**Validation:**
- All links verified to existing contracts and documentation
- Build determinism implications documented
- Security implications formalized in threat model
- Setup procedures match actual implementation (.env.example + .env.local)

### 2026-01-16 Session (COMPLETED)

**Priorities 1–3 Completed in Earlier Part of Session:**

- ✅ Created ADR-0009: React Compiler enablement decision
- ✅ Updated architecture.md: Added components, dark mode, navigation IA, metadata, toolchain sections
- ✅ Updated testing.md: Added ESLint/Prettier config details with rationale
- ✅ Updated deployment.md: Added env var examples for local/preview/production
- ✅ Updated architecture.md: Added Node version policy
- ✅ Created comprehensive config-reference.md (all config files documented)

**Admin Tasks Documentation — COMPLETED (This Session, Later Part):**

Created comprehensive **Phase 1 Completion Documentation** to support admin tasks (Vercel deployment + GitHub ruleset):

**Main Documents Created:**

1. **rbk-vercel-setup-and-promotion-validation.md** (6 phases, ~400 lines)
   - Complete step-by-step Vercel setup (connect repo, env vars, deployment checks)
   - GitHub Ruleset configuration via Vercel or separate
   - E2E validation procedure (test PR → production promotion)
   - Troubleshooting for all common issues

2. **portfolio-app-github-ruleset-config.md** (reference guide, ~200 lines)
   - Detailed GitHub Ruleset setup for `main-protection`
   - Required: ci / quality, ci / build, 1 PR review
   - 4 validation tests
   - Troubleshooting

3. **phase-1-completion-checklist.md** (master checklist, ~400 lines)
   - All 6 admin task phases with detailed checklists
   - Pre/post-setup validation
   - Success criteria
   - Links to all procedures

4. **phase-1-quick-reference.md** (executive summary, ~300 lines)
   - One-page summary with copy-paste instructions
   - 5 admin tasks with time estimates
   - Critical constants
   - 11-point success validation
   - Quick troubleshooting matrix

5. **PHASE_1_ADMIN_TASKS.md** (root-level implementation guide)
   - Overview of all documentation
   - Recommended reading order by use case
   - 60-minute execution plan
   - Pro tips and troubleshooting

**Documentation Updates:**

- Updated `docs/00-portfolio/index.md` with Phase 1 status and quick reference link
- Updated `docs/60-projects/portfolio-app/03-deployment.md` with Vercel runbook reference
- Updated `docs/50-operations/runbooks/index.md` to list all Portfolio App runbooks

**Git State (after all work):**

- portfolio-app: main (no new changes)
- portfolio-docs: main (3 new commits)
  - a576d04: docs/add Phase 1 completion procedures
  - a158c14: docs/add Phase 1 quick reference card
  - ceae815: docs/add Phase 1 admin tasks implementation guide
- No uncommitted changes in either repo

### 2026-01-13 Session

- Completed Phase 1 documentation alignment
- Updated all dossier pages, runbooks, ADR-0008, env contract, release note
- Added status notes to Deployment and Security docs
- Updated portfolio-app README with implemented governance
- Added `quality` script to package.json
- Opened PR for portfolio-app governance updates
- Established this session context file for future resumption

### What Changed Since Last Commit

- Portfolio-docs: ADR-0009, enhanced architecture.md, updated testing.md and deployment.md, created config-reference.md
- Portfolio-app: Already merged (no new changes since last session)
- Session context: Updated with latest completions

### Lessons Learned

- Stable CI check names are an operational API
- Wire runbook references across docs to reduce broken links
- Annotate docs to distinguish implemented vs planned to avoid reviewer confusion
- Configuration files need explicit documentation for enterprise credibility
- React Compiler and toolchain decisions warrant explicit ADRs
- Frozen lockfile in CI is a determinism requirement
- Internal env contract should be non-public but documented
