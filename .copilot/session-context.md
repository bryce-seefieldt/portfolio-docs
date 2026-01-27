last-updated: 2026-01-27
active-phase: Phase 4 (Enterprise-Grade Platform Maturity) — Stage 4.3 COMPLETE, Stage 4.4 READY
workspace-repos:

- portfolio-app (Next.js + TypeScript)
- portfolio-docs (Docusaurus)

---

# Copilot Session Context

## Current State (Phase 3 COMPLETE; Phase 4 Stage 4.1 COMPLETE; Stage 4.2 READY)

### Active Branches

- **portfolio-app:** `main` (PR #46 created for Stage 4.1 multi-environment deployment)
- **portfolio-docs:** `main` (PR #57 merged with Stage 4.1 comprehensive documentation)

### Phase Progress: Phase 3 complete; Phase 4 Stage 4.1 complete; Stage 4.2 (Performance Optimization) ready to begin

#### Template Enforcement (Critical)

All work in both repositories **MUST** use templates for proper governance and traceability:

**Phase Planning & Delivery Templates (Mandatory):**

- `template-phase-implementation-guide.md` — Master plan for entire phase (published in `docs/00-portfolio/`)
- `template-phase-stage-app-issue.md` — GitHub issue for `portfolio-app` stage work
- `template-phase-stage-docs-issue.md` — GitHub issue for `portfolio-docs` stage work
- `template-github-issue-generic.md` — GitHub issue for non-phase work (bugs, features, maintenance)

**Evidence Templates:**

- `template-adr.md` — Architecture decisions (docs/10-architecture/adr/)
- `template-runbook.md` — Operational procedures (docs/50-operations/runbooks/)
- `template-threat-model.md` — Security analysis (docs/40-security/threat-models/)
- `template-postmortem.md` — Incident retrospectives
- `template-project-dossier/` — Complete project documentation

**Template Location & Usage:**

- All templates: `portfolio-docs/docs/_meta/templates/`
- Reference guide: [Templates Guide and Definitions of Done](./docs/_meta/templates/README.md)
- Required in both copilot-instructions.md and CONTRIBUTING.md
- Enforced in GitHub issue workflows

**Phase Stage Workflow:**

1. Create Phase Implementation Guide (published in docs/00-portfolio/)
2. For each stage: create paired issues (app + docs) using stage templates
3. Reference companion issue in linked issues
4. Implementation follows design and testing specs in issue body
5. PR closes issue with `Closes #X` keyword

#### ✅ Completed (Portfolio App)

- Core routes delivered: `/`, `/cv`, `/projects`, `/projects/[slug]`, `/contact`
- Governance + config: `src/lib/config.ts` with `NEXT_PUBLIC_*` helpers (`docsUrl()`), `src/data/projects.ts` registry scaffold
- CI/CD + security gates:
  - `ci / quality` (lint, format:check, typecheck) and `ci / build` (Next.js build + Playwright smoke tests)
  - `secrets-scan` (TruffleHog, PR-only) with least-privilege job permissions; frozen installs (`pnpm install --frozen-lockfile`)
  - CodeQL scanning (PR + weekly); Dependabot weekly (majors excluded, grouped)
  - Local hygiene: `.pre-commit-config.yaml` (TruffleHog hook) + `pnpm secrets:scan`
- Testing: Playwright smoke tests cover core routes and evidence links (run in build job)
- **Stage 3.1 COMPLETE:** YAML registry (`src/data/projects.yml`), TypeScript validation (`src/lib/registry.ts`), environment-based link interpolation, slug uniqueness + format validation

#### ✅ Completed (Portfolio Docs)

- Phase 1 dossier/runbooks/ADRs baseline intact (8 dossier pages, ADR-0008/0009, deploy/rollback/CI triage runbooks)
- Phase 2 planning and hardening artifacts:
  - [docs/00-portfolio/phase-2-implementation-guide.md](docs/00-portfolio/phase-2-implementation-guide.md) (step-by-step execution)
  - [docs/00-portfolio/PHASE-2-ENHANCEMENTS-SUMMARY.md](docs/00-portfolio/PHASE-2-ENHANCEMENTS-SUMMARY.md) (CI/security hardening summary)
  - Threat model expanded with STRIDE analysis (PR #32 merged 2026-01-19)
  - [docs/50-operations/runbooks/rbk-portfolio-secrets-incident.md](docs/50-operations/runbooks/rbk-portfolio-secrets-incident.md) added + runbook index updated
- Template system fully enforced with mandatory guidance in both repos (PRs #43-44 merged)

#### ✅ Complete: Phase 3 Stage 3.3 — Unit & E2E Tests

**What shipped:**

- Vitest suite for registry schema, slug rules, link construction, and coverage thresholds
- Playwright E2E smoke tests tightened (page error handling corrected); evidence links validated
- CI pipeline wiring confirmed via `pnpm verify` (lint, typecheck, build, unit, E2E)

**Status:** Complete (2026-01-22)

#### ✅ Complete: Phase 4 Stage 4.1 — Multi-Environment Deployment Strategy

**What shipped (2026-01-24):**

- **portfolio-app (PR #46):**
  - Environment helpers in config.ts (`ENVIRONMENT`, `isProduction`, `isPreview`, `isStaging`, `isDevelopment`)
  - Deleted redundant promotion workflows (promote-staging.yml, promote-production.yml) — Git-based promotion via branch merges
  - Complete .env.example with all NEXT*PUBLIC*\* variables documented
  - Clarified staging-first workflow in README
  - Immutability principle established (same build artifact across tiers)

- **portfolio-docs (PR #57 - MERGED):**
  - ADR-0013: Multi-Environment Deployment Strategy (with mermaid diagram)
  - rbk-portfolio-environment-promotion.md (staging validation procedures)
  - rbk-portfolio-environment-rollback.md (incident recovery)
  - Updated 6 portfolio-app dossier files (01-overview, 02-architecture, 03-deployment, 05-testing, 06-operations, runbook index)

**Status:** COMPLETE — Three-tier deployment model operational (Preview → Staging → Production)

#### 🎯 Next: Phase 4 Stage 4.2 — Performance Optimization & Measurement

**Objective:** Introduce caching strategy, static generation with `generateStaticParams()`, asset optimization, and performance instrumentation

**Key deliverables:**

- next.config.ts enhancements (caching headers, image optimization, bundle analyzer)
- generateStaticParams() for project pages
- Performance runbook and dossier updates
- Build size tracking and baseline metrics

#### 🔜 Next: Phase 3 Stage 3.4 — ADRs & Documentation Updates

- Document Stage 3 decisions (ADR-0011/0012 updates), dossier refresh, and registry schema guide alignment
- Keep template enforcement unchanged; use Phase Stage templates for paired app/docs issues

---

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

### Diagram authoring standard (Docs repository)

- All diagrams in `docs/` must be Mermaid code blocks (no PNG/SVG/ASCII/external tools)
- Use triple-backtick fenced blocks with `mermaid` language id
- Keep a short caption explaining the diagram’s purpose; test render via `pnpm build && pnpm serve`
- Full requirements live in [portfolio-docs/.github/copilot-instructions.md](.github/copilot-instructions.md)

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
- `secrets-scan` — TruffleHog (PR-only gate; Information Disclosure mitigation)
- `ci / build` — Next.js build + Playwright smoke tests (depends on quality)
- Frozen installs: `pnpm install --frozen-lockfile`
- CodeQL: JS/TS (PR + scheduled) — keep as a required check in branch protections
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

- **ADR-0011** (exisits, updates in Stage 3.4 planned): Data-Driven Registry Decision
  - Why YAML (readable, structured, standard format)
  - Why type safety via Zod (catch errors at build time)
  - Why build-time validation (prevent broken links in production)
  - Migration path from hardcoded projects

- **ADR-0012** (Stage 3.4 planned): Cross-Repo Documentation Linking
  - Environment-first URL construction pattern
  - Schema-based link validation approach
  - Bidirectional link assertions (app ↔ docs consistency)
  - Deployment synchronization strategy

- **ADR-0010** (existing): Gold Standard Exemplar — Portfolio App proves enterprise SDLC posture

- **ADR-0009** (existing): Documentation platform (Docusaurus)

- **ADR-0008:** Portfolio App CI Quality Gates
  - Stable check names for governance
  - Frozen lockfile installs for determinism
  - CodeQL + Dependabot baseline
  - GitHub Rulesets (not classic branch protection)

---

### Phase 3 Stage 3.2 Implementation Context

**What Components Will Do:**

1. **`EvidenceBlock.tsx`** — Card-based evidence display
   - Props: `project: Project`, `className?: string`
   - Renders sections for: dossier, threat model, ADRs, runbooks, GitHub repo
   - Each section: title + clickable link if available, placeholder if not
   - Responsive grid layout (1 col mobile, 2 col tablet, 3 col desktop)
   - Uses Tailwind: `border`, `rounded-lg`, `hover:shadow`, `dark:` variants

2. **`VerificationBadge.tsx`** — Status indicators
   - Props: `type: 'docs-available' | 'threat-model' | 'gold-standard' | 'adr-complete'`
   - Icons + color-coded styling (Tailwind)
   - gold-standard uses amber (existing GoldStandardBadge as reference)
   - Each type has tooltip/aria-label for accessibility

3. **`BadgeGroup.tsx`** — Multi-badge renderer
   - Props: `badges: BadgeType[]`, `project: Project`
   - Conditionally renders badges based on evidence presence
   - Responsive flex wrapping with gap spacing
   - Example: portfolio-app shows [gold-standard, docs-complete, threat-model]

**Integration Points:**

- Import all three in `/projects/[slug]/page.tsx`
- Place `EvidenceBlock` after "What This Project Proves" section
- Place `BadgeGroup` in header area near title
- Test on mobile: DevTools → iPhone 12 / iPad

**Design Reference:**

- Use existing `GoldStandardBadge.tsx` as style pattern (amber border/bg/text)
- Check current project pages for layout patterns
- Follow Tailwind 4 naming (no spaces in class names, use `dark:` modifier)

---

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
   - Require checks: `ci / quality`, `secrets-scan`, `ci / build`, CodeQL
   - Block force-push and deletion

3. **Vercel Promotion Checks:**
   - Import GitHub checks into Vercel
   - Require `ci / quality` and `ci / build` before production promotion (align with secrets-scan as a PR gate)

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

1. **Stage 3.4 documentation set**: finalize ADR-0011/0012 text, dossier updates, registry schema guide alignment, and release-note entry if needed
2. **Issue discipline**: open paired Stage 3.4 app/docs issues using phase templates and link them; PRs must close those issues
3. **CI sanity**: keep `pnpm verify` green (lint, typecheck, build, unit, E2E) before drafting docs PRs
4. **Evidence links**: validate docs/app cross-links via `docsUrl` patterns and registry placeholders while editing docs

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

### 2026-01-20 Session (Phase 2 Security & Testing Hardening)

**Objective:** Add CI security gates and operational readiness controls for Phase 2.

**Scope:**

- Added TruffleHog `secrets-scan` CI job with per-job least-privilege permissions; build continues to run Playwright smoke tests
- Added local hygiene: `.pre-commit-config.yaml` (TruffleHog hook) and `pnpm secrets:scan`
- Authored [docs/00-portfolio/PHASE-2-ENHANCEMENTS-SUMMARY.md](docs/00-portfolio/PHASE-2-ENHANCEMENTS-SUMMARY.md) and updated [docs/00-portfolio/phase-2-implementation-guide.md](docs/00-portfolio/phase-2-implementation-guide.md) Step 4a/4b for hardening
- Created [docs/50-operations/runbooks/rbk-portfolio-secrets-incident.md](docs/50-operations/runbooks/rbk-portfolio-secrets-incident.md); threat model expanded (PR #32 merged 2026-01-19)

**Validation:** `pnpm build` (includes Playwright smoke tests) succeeded; secrets-scan gate runs on PRs.

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

- Portfolio-app: CI hardened with TruffleHog `secrets-scan` (PR-only), per-job least-privilege permissions, Playwright smoke tests in build, `.pre-commit-config.yaml`, and `pnpm secrets:scan`
- Portfolio-docs: Added Phase 2 artifacts ([docs/00-portfolio/phase-2-implementation-guide.md](docs/00-portfolio/roadmap/phase-2-implementation-guide.md), , [docs/50-operations/runbooks/rbk-portfolio-secrets-incident.md](docs/50-operations/runbooks/rbk-portfolio-secrets-incident.md)); threat model expansion merged (PR #32, 2026-01-19)
- Session context: Updated for Phase 2 hardening status, required checks, and remaining gold-standard deliverables

### Lessons Learned

- Stable CI check names are an operational API
- Wire runbook references across docs to reduce broken links
- Annotate docs to distinguish implemented vs planned to avoid reviewer confusion
- Configuration files need explicit documentation for enterprise credibility
- React Compiler and toolchain decisions warrant explicit ADRs
- Frozen lockfile in CI is a determinism requirement
- Internal env contract should be non-public but documented
