# Bryce Seefieldt | Development Portfolio Documentation

This website is built using [Docusaurus](https://docusaurus.io/), a modern static website generator.

## Reviewer quickstart

- Reviewer guide: [docs/00-portfolio/reviewer-guide.md](./docs/00-portfolio/reviewer-guide.md)
- Portfolio App dossier: [docs/60-projects/portfolio-app/index.md](./docs/60-projects/portfolio-app/index.md)
- Evidence audit checklist: [docs/70-reference/evidence-audit-checklist.md](./docs/70-reference/evidence-audit-checklist.md)

## Installation

```bash
pnpm install
```

## Local Development

### Setup (First Time)

1. **Install dependencies:**

   ```bash
   pnpm install
   ```

2. **Configure environment variables:**

   ```bash
   cp .env.example .env.local
   ```

   Edit `.env.local` with your local development values:

   ```env
   DOCUSAURUS_SITE_URL=http://localhost:3000
   DOCUSAURUS_GITHUB_ORG=your-github-username
   DOCUSAURUS_GITHUB_REPO_DOCS=portfolio-docs
   DOCUSAURUS_GITHUB_REPO_APP=portfolio-app
   DOCUSAURUS_PORTFOLIO_APP_URL=http://localhost:3000
   ```

   **Note:** `.env.local` is gitignored. See [Environment Variables Contract](./docs/_meta/env/portfolio-docs-env-contract.md) for full documentation.

3. **Start the development server:**
   ```bash
   pnpm start
   ```

This command starts a local development server and opens up a browser window. Most changes are reflected live without having to restart the server.

The dev server uses the environment variables from `.env.local` to configure site URLs, GitHub links, and cross-repository linking.

### Pre-PR verification (required)

- Recommended: `pnpm verify` (runs format, lint, typecheck, format:check, audit, build)
- Faster iteration: `pnpm verify:quick` (skips the build gate; rerun full `pnpm verify` before opening a PR)
- Manual equivalent: `pnpm format:write && pnpm lint && pnpm typecheck && pnpm format:check && pnpm audit && pnpm build`
- Audit posture: CI blocks high/critical advisories; lower severities are logged and require a ticket or risk entry if persistent
- Optional audit report: `pnpm verify -- --audit-json` (writes `audit-report.json`)

## Build

```bash
pnpm build
```

This command generates static content into the `build` directory and can be served using any static contents hosting service.

## Deployment

### Hosting and CI/CD

The Portfolio Docs App is deployed to **Vercel** with the following workflow:

- **Preview deployments** for all PR branches (one per PR)
- **Production deployment** from `main` (automatic on merge)
- **Deployment Checks** gate: production domain is assigned only after GitHub Actions `ci / build` checks pass
- **Build determinism** via Corepack and pinned pnpm version (`package.json#packageManager: "pnpm@10.0.0"`)

**Learn more:**

- [Hosting & Deployment Decision](./docs/10-architecture/adr/adr-0003-hosting-vercel-with-preview-deployments.md) (ADR-0003)
- [Portfolio Docs Deployment Model](./docs/60-projects/portfolio-docs-app/03-deployment.md) (dossier page)
- [Deploy Runbook](./docs/50-operations/runbooks/rbk-docs-deploy.md) (step-by-step deployment guide)
- [Rollback Runbook](./docs/50-operations/runbooks/rbk-docs-rollback.md) (emergency recovery)

### Local build and test

```bash
pnpm build
```

This command generates static content into the `build` directory. The same command runs in CI and blocks merge if it fails (intentional safety gate for broken links).

### Scripts

- `pnpm start` — run the local dev server
- `pnpm build` — produce the static site output (`build/`)
- `pnpm serve` / `pnpm serve:wsl` — serve a built site locally
- `pnpm lint` / `pnpm lint:fix` — ESLint check / auto-fix
- `pnpm typecheck` — TypeScript type validation
- `pnpm format:check` / `pnpm format:write` — Prettier check / write
- `pnpm audit` — dependency audit (high severity)
- `pnpm verify` — full local quality gates (format, lint, typecheck, format:check, audit, build)
- `pnpm verify:quick` — skip build for faster iteration (run full `pnpm verify` before PR)

### Reference

[Docusaurus Deployment Guide](https://docusaurus.io/docs/deployment)

## Configuration

Please see [`CONFIGURATION.md`](./CONFIGURATION.md) for details of the Docusaurus configuration, project structure and features., and other customizations.

## Contributing

This repository follows a docs-as-code workflow. All changes (including solo changes) go through pull requests.

Please see [`CONTRIBUTING.md`](./CONTRIBUTING.md) for detailed workflow and rules for authoring documentation.

### Workflow

1. Create a branch from `main` using a standard prefix:
   - `docs/`, `arch/`, `sec/`, `ops/`, `ci/`, `ref/`
2. Keep PRs small and focused (one topic per PR).
3. Run locally:
   - `pnpm install`
   - `pnpm start` (preview)
   - `pnpm verify` (required before PR; use `pnpm verify:quick` only for iteration)
4. Open a PR and complete the checklist in the PR template.
5. Merge only when required checks pass (build, nav integrity, security statement).

### Standards

- Every new navigable folder must include `_category_.json` (or `_category_.yml`).
- Every section must have an index hub (curated index doc or generated index).
- No secrets, tokens, private keys, or sensitive environment details may be committed.
