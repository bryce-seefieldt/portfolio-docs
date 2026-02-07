---
title: 'Runbook: Portfolio Project Publish'
description: 'End-to-end procedure for publishing a project with registry validation, evidence links, and CI link checks.'
sidebar_position: 10
tags: [runbook, operations, publishing, registry, links]
---

## Purpose

Provide a deterministic, time-boxed procedure for publishing a new project in the Portfolio Program using the data-driven registry and evidence-first patterns. This runbook ensures every publish includes registry validation, link checks, and documented verification steps.

## Audience

Operations and engineering collaborators who publish or review new projects. Assumes familiarity with GitHub, pnpm, and the Portfolio App registry shape.

## Prerequisites / Access

- GitHub access to both repositories with permission to open PRs
- Local environment with Node 20+, pnpm (per `package.json#packageManager`), Playwright browsers (`npx playwright install --with-deps`)
- Required env vars exported when running app commands locally:
  - `NEXT_PUBLIC_DOCS_BASE_URL`
  - `NEXT_PUBLIC_GITHUB_URL`
  - `NEXT_PUBLIC_DOCS_GITHUB_URL`
  - `NEXT_PUBLIC_SITE_URL`
- Reference materials:
  - Registry schema: /docs/70-reference/registry-schema-guide.md
   - Implementation guide: /docs/00-portfolio/roadmap/phase-3-implementation-guide.md
   - Archived issue records for the publishing workflow (app + docs)

## Validation Signals (must stay green)

- `pnpm registry:validate` — schema, slug regex `^[a-z0-9]+(?:-[a-z0-9]+)*$`, evidence URLs present
- `pnpm links:check` — evidence/docs link smoke tests (Playwright)
- `pnpm build` — Next.js build
- CI job `link-validation` — runs registry + link checks and uploads `playwright-report` on failure

## Procedure (time-boxed)

1. **Planning (30 min)**
   - Review the archived issue records (app + docs) for scope and acceptance criteria.
   - Confirm target dossier location under `docs/60-projects/` and evidence links you expect to provide (dossier, ADRs, threat model, runbooks, GitHub repo).

2. **Registry Entry (30 min)**
   - Edit `src/data/projects.yml` (portfolio-app) with the new project entry using the schema guide.
   - Ensure slug matches regex `^[a-z0-9]+(?:-[a-z0-9]+)*$` and is unique.
   - Populate evidence URLs (dossier, threat model, ADR index, runbooks, GitHub repo).
   - Run locally:
     - `pnpm registry:validate`

3. **Dossier Creation (60–90 min)**
   - Create or update dossier content in /docs/60-projects/ with required evidence pages.
   - Include links back to the app once deployed (use env-first URL guidance in copilot instructions).

4. **Link Validation (30 min)**
   - From portfolio-app:
     - `pnpm links:check` (Playwright link smoke tests)
     - `pnpm build`
   - Expected outcomes: no Playwright failures; Next.js build succeeds without registry errors.

5. **PR Creation & Review (30 min)**
   - Open PRs in both repos with clear scope and closing keywords.
   - Include evidence section: commands run, CI job links, and note “no secrets added.”
   - Ensure CI `link-validation`, `quality`, `test`, and `build` are green.

6. **Post-Publish Verification (15 min)**
   - After merge/deploy, open the project detail page and verify evidence links resolve.
   - Spot-check dossier links on the docs site; confirm no broken links via production smoke (if available).

## Validation / Expected Outcomes

- ✅ `pnpm registry:validate` passes locally and in CI `link-validation`
- ✅ `pnpm links:check` passes locally and in CI (artifact only on failure)
- ✅ `pnpm build` passes locally and in CI `build`
- ✅ All evidence links resolve (dossier, threat model, ADRs, runbooks, GitHub repo)
- ✅ PRs include evidence commands and cross-links

## Rollback / Abort

- If registry validation fails in CI: pull the failing commit, run `pnpm registry:validate`, fix slug/evidence fields, re-run.
- If link checks fail: review `playwright-report` artifact from `link-validation` job; fix target URLs or slug mismatches; re-run locally.
- If build fails: run `pnpm build` locally, inspect registry interpolation and environment variables, apply fixes, and rerun CI.

## References

- Runbook index: /docs/50-operations/runbooks/index.md
- Troubleshooting guide: /docs/50-operations/runbooks/troubleshooting-portfolio-publish.md
- Registry schema: /docs/70-reference/registry-schema-guide.md
- Copilot instructions (docs): /.github/copilot-instructions.md
- Copilot instructions (app): https://github.com/bryce-seefieldt/portfolio-app/blob/main/.github/copilot-instructions.md
