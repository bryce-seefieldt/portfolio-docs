---
title: 'Portfolio Docs: Troubleshooting'
description: 'Common failure modes for the Portfolio Docs App and deterministic fixes: build failures, broken links, category issues, routing confusion, and MDX errors.'
sidebar_position: 7
tags: [projects, troubleshooting, documentation, docusaurus, operations]
---

## Purpose

This page provides a practical, operator-oriented troubleshooting guide for common Portfolio Docs App failures.

The intent is to reduce time-to-fix and standardize responses to predictable problems.

## Scope

### In scope

- local dev failures (`pnpm start`, build issues)
- broken link failures during `pnpm build`
- category/navigation issues (`_category_.json`, missing hub pages)
- routing and base path confusion
- MDX parsing/rendering issues (if MDX is used)

### Out of scope

- hosting vendor incidents requiring account-level access (document separately if needed)
- security incident handling (see operations incident response area)

## Prereqs / Inputs

- Ability to run:
  - `pnpm start`
  - `pnpm build`
- Understanding of:
  - folder placement rules
  - category metadata rules
  - page shape and front matter expectations

## Procedure / Content

## Symptom: `pnpm start` fails to run

### Likely causes

- dependencies not installed
- Node/pnpm version mismatch
- corrupted local workspace state

### Diagnostics

```bash
pnpm -v
node -v
pnpm install
```

### Fix

Reinstall dependencies:

```bash
pnpm install
```

- If persistent, clear local caches carefully (avoid destructive actions unless necessary) and re-run install.

## Symptom: `pnpm build` fails due to broken links

### Likely causes

- a new markdown link points to a file that does not exist yet
- a file was renamed without updating references
- a category link points to a missing doc id

### Diagnostics

- Read the build output and identify the exact missing link target.
- Confirm whether the referenced file exists under `docs/`.

### Fix

- If the target does not exist yet:
  - remove the link
  - replace with a plain-text path reference until the target is created
- If the file was renamed:
  - update references consistently in the same PR
- If the issue is category link id:
  - confirm the id matches the doc path, e.g. `00-portfolio/index`

## Symptom: Sidebar category shows wrong label or order

### Likely causes

- missing or incorrect `_category_.json`
- missing `position` values
- reliance on folder name ordering only

### Diagnostics

- Confirm `_category_.json` exists in the folder.
- Confirm it includes:
  - `label`
  - `position`
  - `link` (for top-level domains)

### Fix

- Add or correct `_category_.json`
- Ensure top-level domains link to their curated index.md hub docs.

## Symptom: Clicking a category doesn’t land on a hub page

### Likely causes

- category metadata missing `link`
- category `link` points to a doc id that does not exist

### Diagnostics

- Verify `link.type` and `link.id` in `_category_.json`.
- Confirm the `index.md` exists at the matching path.

### Fix

- For top-level domain folders, set:
  - `link: { "type": "doc", "id": "<domain>/index" }`
- Ensure `<domain>/index.md` exists and has front matter.

## Symptom: Route/base path confusion (URLs not as expected)

### Likely causes

- `routeBasePath` setting differs from assumed URL structure
- hosting assumes a different base path than local expectation

### Diagnostics

- Identify current `routeBasePath` setting in `docusaurus.config.ts`.
- Confirm expected public URL scheme:
  - docs at `/` vs docs under `/docs`

### Fix

- Choose a stable `routeBasePath` early and keep it consistent.
- If changed, treat as a breaking navigation change and update documentation accordingly.

## Symptom: MDX errors or unexpected rendering

### Likely causes

- invalid MDX syntax
- React component usage without required imports
- misuse of components in Markdown pages

### Diagnostics

- Build output will typically cite a file and line.
- Confirm whether file should be `.md` rather than `.mdx`.

### Fix

- Prefer `.md` unless interactivity is required.
- Move complex components to dedicated `.mdx` pages and treat them as code:
  - tighter review
  - stricter testing via `pnpm build`

## Validation / Expected outcomes

Troubleshooting is effective when:

- contributors can diagnose failures quickly from build output
- fixes are deterministic and documented
- recurring failures lead to improved governance (templates, lint rules, runbooks)

## Vercel Deployment Failure Modes

When the site builds successfully locally but fails in production (Vercel), refer to the deployment runbook for diagnostics and recovery:

- **Symptom: Site returns 404 or pages are missing**
  - Likely cause: Output directory misconfigured
  - See: [Output directory mismatch](/docs/operations/runbooks/rbk-docs-deploy#failure-output-directory-mismatch-404-errors-or-missing-pages)

- **Symptom: Build fails with dependency/version errors in Vercel (but passes locally)**
  - Likely cause: pnpm lockfile drift or version mismatch
  - See: [pnpm lockfile/version mismatch](/docs/operations/runbooks/rbk-docs-deploy#failure-pnpm-lockfile-drift-or-version-mismatch)

- **Symptom: Build shows no output or unclear status**
  - Likely cause: Build step ignored or webhook misconfigured
  - See: [Missing build logs](/docs/operations/runbooks/rbk-docs-deploy#failure-missing-build-logs-or-build-doesnt-start)

## Failure modes / Troubleshooting

- **“Fix by disabling checks”**: never weaken `pnpm build` gate to “make it pass.” Fix the root cause or revert.
- **Over-linking to future work**: avoid links to uncreated pages; add them only once targets exist.
- **Silent drift**: if the fix becomes common, convert it into a runbook entry or governance rule.

## References

- Quality gates: `docs/60-projects/portfolio-docs-app/testing.md`
- Navigation governance: `docs/60-projects/portfolio-docs-app/architecture.md`
- Operations posture: `docs/60-projects/portfolio-docs-app/operations.md`
- Runbook template (internal-only): `docs/_meta/templates/template-runbook.md`
