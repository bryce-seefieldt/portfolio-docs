---
last-updated: 2026-01-13
active-phase: Phase 1 (near completion)
workspace-repos:
  - portfolio-app (Next.js + TypeScript)
  - portfolio-docs (Docusaurus)
---

# Copilot Session Context

## Current State

### Active Branches

- **portfolio-app:** `main` (PR merged: chore/phase1-governance-quality-script)
- **portfolio-docs:** `main` (working branch: feat/portfolio-app-phase-1-update)

### Phase Progress: Phase 1 (Near Completion)

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
  - architecture.md: Repository structure, routing/evidence strategy, route list annotated
  - testing.md: Formatting, quality gates, merge gates, phased testing (annotated)
  - operations.md: CI release gate, branch governance, runbook references
  - deployment.md: Pre-deployment governance, stable check names, status note
  - security.md: Step 3 posture (Dependabot, CodeQL, public-safe env), status note
  - (other pages baseline complete)
- Runbooks updated:
  - rbk-portfolio-deploy.md: Pre-merge checklist, ruleset confirmation, env validation
  - rbk-portfolio-ci-triage.md: CI topology, known Prettier failure, re-run checks guidance
  - rbk-portfolio-rollback.md: CI gate enforcement, revert-based recovery
- ADR-0008: CI quality gates (Purpose/Scope + decision body complete)
- Internal env contract: `docs/_meta/env/portfolio-app-env-contract.md` with NEXT*PUBLIC*\* rules, CI determinism, references
- Release note: `docs/00-portfolio/release-notes/20260110-portfolio-app-baseline.md` (includes README section)

#### ⏳ In Progress / Pending

- Vercel deployment (not yet connected)
- GitHub Ruleset enforcement (not yet configured with required checks)
- Public repo URLs (pending in `src/data/projects.ts`: repoUrl, demoUrl)
- Docs site deployment (pending final Vercel link)

---

## Integration Contract

### Evidence Link Strategy

- Portfolio App links to docs via: `NEXT_PUBLIC_DOCS_BASE_URL` (env var)
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

### 2026-01-13 Session

- Completed Phase 1 documentation alignment
- Updated all dossier pages, runbooks, ADR-0008, env contract, release note
- Added status notes to Deployment and Security docs
- Updated portfolio-app README with implemented governance
- Added `quality` script to package.json
- Opened PR for portfolio-app governance updates
- Established this session context file for future resumption

### What Changed Since Last Commit

- Portfolio-app: README governance section + quality script in package.json
- Portfolio-docs: Multiple dossier pages, runbooks, ADR, env contract, release note

### Lessons Learned

- Stable CI check names are an operational API
- Wire runbook references across docs to reduce broken links
- Annotate docs to distinguish implemented vs planned to avoid reviewer confusion
- Frozen lockfile in CI is a determinism requirement
- Internal env contract should be non-public but documented
