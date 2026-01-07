# Bryce Seefieldt | Development Portfolio Documentation

This website is built using [Docusaurus](https://docusaurus.io/), a modern static website generator.

## Installation

```bash
pnpm install
```

## Local Development

```bash
pnpm start
```

This command starts a local development server and opens up a browser window. Most changes are reflected live without having to restart the server.

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
   - `pnpm build` (required before PR)
4. Open a PR and complete the checklist in the PR template.
5. Merge only when required checks pass (build, nav integrity, security statement).

### Standards

- Every new navigable folder must include `_category_.json` (or `_category_.yml`).
- Every section must have an index hub (curated index doc or generated index).
- No secrets, tokens, private keys, or sensitive environment details may be committed.
