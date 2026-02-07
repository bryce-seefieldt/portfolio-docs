---
title: 'Troubleshooting: Portfolio Publish & Link Validation'
description: 'Common errors and fixes for project publishing, registry validation, and link checks.'
sidebar_position: 11
tags: [troubleshooting, operations, publishing, links, registry]
---

## Purpose

Provide fast fixes for the most common failures during project publishing: registry validation errors, slug violations, broken dossier/evidence links, and CI link-check failures.

## How to Use This Guide

1. Identify the failing step (local command or CI job and which job/step).
2. Jump to the matching issue below.
3. Apply the fix, re-run the specific command, then rerun `pnpm links:check` and `pnpm build` before pushing.

## CI Artifact Locations

- Job: `link-validation` (portfolio-app CI)
- Artifact on failure: `playwright-report` (HTML) — inspect for failed routes/links
- Related jobs: `quality`, `test`, `build`

## Issues & Fixes

### Invalid slug format

- **Symptom:** `registry:validate` fails with regex error or CI `link-validation` fails on slug.
- **Cause:** Slug not matching `^[a-z0-9]+(?:-[a-z0-9]+)*$` or duplicate slug.
- **Fix:**
  1. Edit `src/data/projects.yml` in portfolio-app; correct slug to lowercase, hyphenated, unique.
  2. Re-run `pnpm registry:validate` locally.
  3. Commit and push; confirm CI `link-validation` passes.

### Broken dossier or evidence links

- **Symptom:** `links:check` Playwright report shows 404/500 for dossier/threat model/ADR/runbook links.
- **Cause:** URL path wrong (missing numeric prefix or `.md`), or docs page not yet merged/deployed.
- **Fix:**
  1. Ensure doc links use `/docs/<prefix>-<domain>/<path>.md` when authoring in docs repo.
  2. For app links, use env-first helpers (see copilot instructions) to build full URLs.
  3. If docs PR not merged, land docs first or point to staging URL for validation.
  4. Re-run `pnpm links:check` locally; inspect `playwright-report` if CI fails.

### Evidence URL missing or empty

- **Symptom:** `registry:validate` reports missing required evidence URLs.
- **Cause:** Required fields omitted in registry entry.
- **Fix:**
  1. Add evidence URLs (dossier, threat model, ADR index, runbooks, GitHub repo) to the project entry.
  2. Re-run `pnpm registry:validate` and `pnpm build`.

### Registry validation failure (schema)

- **Symptom:** Zod schema errors during `registry:validate` or `pnpm build`.
- **Cause:** Field type mismatch, missing required fields, invalid enums.
- **Fix:**
  1. Compare entry against /docs/70-reference/registry-schema-guide.md.
  2. Correct fields; ensure dates are ISO, arrays non-empty where required.
  3. Re-run `pnpm registry:validate` locally.

### CI `link-validation` failing, but local passes

- **Symptom:** CI job fails on link checks while local runs succeed.
- **Cause:** Missing env vars in CI, transient network, or uncommitted changes.
- **Fix:**
  1. Confirm env vars in workflow match production (`NEXT_PUBLIC_DOCS_BASE_URL`, `NEXT_PUBLIC_GITHUB_URL`, `NEXT_PUBLIC_DOCS_GITHUB_URL`, `NEXT_PUBLIC_SITE_URL`).
  2. Download `playwright-report` artifact to see failing routes.
  3. Retry locally using `pnpm links:check` after `pnpm install --frozen-lockfile`.
  4. If still flaky, rerun CI once; otherwise fix underlying link.

## Validation Checklist (after fixes)

- [ ] `pnpm registry:validate` passes locally
- [ ] `pnpm links:check` passes locally
- [ ] `pnpm build` passes locally
- [ ] CI jobs `link-validation`, `quality`, `test`, `build` are green
- [ ] Evidence links resolve in deployed app and docs

## References

- Publish runbook: /docs/50-operations/runbooks/rbk-portfolio-project-publish.md
- Archived issue records for the publishing workflow (app + docs)
- Registry schema guide: /docs/70-reference/registry-schema-guide.md
- Copilot instructions (docs): /.github/copilot-instructions.md
- Copilot instructions (app): https://github.com/bryce-seefieldt/portfolio-app/blob/main/.github/copilot-instructions.md
