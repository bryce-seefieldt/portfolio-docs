---
title: 'Portfolio Docs Environment Variables Contract'
description: 'Canonical environment variables contract for the Portfolio Docs App (Docusaurus): local development, preview, and production configuration.'
sidebar_position: 2
tags: [env, configuration, contract, deployment, vercel, security]
---

# Portfolio Docs Environment Variables Contract

This document defines the **canonical environment variables contract** for the Portfolio Docs App (Docusaurus). It specifies what variables exist, where they're used, and how to configure them across environments.

## Purpose

- **Portability**: Enable the same codebase to run in local, preview, and production environments
- **Security**: Prevent hardcoded URLs and facilitate environment-specific configuration
- **Maintainability**: Centralize environment-dependent values for easier updates
- **Transparency**: Document the public-safe environment contract (no secrets)

## Environment Variable Prefix Convention

Docusaurus uses the `DOCUSAURUS_` prefix convention for client-exposed variables:

- **`DOCUSAURUS_*`**: Exposed to client-side code (browser)
- **Non-prefixed**: Build-time only (server-side, not available in React components)

This is analogous to Next.js `NEXT_PUBLIC_*` convention in the Portfolio App.

## Required Variables

### Deployment Configuration

#### `DOCUSAURUS_SITE_URL`

- **Purpose**: Base URL of the deployed site (used for SEO, sitemap, canonical URLs)
- **Used in**: `docusaurus.config.ts` (`url` field)
- **Local**: `http://localhost:3000`
- **Production**: `https://bns-portfolio-docs.vercel.app`
- **Required**: Yes
- **Default**: `https://bns-portfolio-docs.vercel.app` (fallback in config)

#### `DOCUSAURUS_BASE_URL`

- **Purpose**: Base path under which the site is served (for subpath deployments)
- **Used in**: `docusaurus.config.ts` (`baseUrl` field)
- **Default**: `/` (root)
- **GitHub Pages example**: `/portfolio-docs/`
- **Required**: No (defaults to `/`)

### GitHub Integration

#### `DOCUSAURUS_GITHUB_ORG`

- **Purpose**: GitHub organization or user name
- **Used in**: `docusaurus.config.ts` (organizationName, GitHub links, edit URLs)
- **Value**: `bryce-seefieldt`
- **Required**: Yes
- **Default**: `bryce-seefieldt` (fallback in config)

#### `DOCUSAURUS_GITHUB_REPO_DOCS`

- **Purpose**: GitHub repository name for portfolio-docs
- **Used in**: `docusaurus.config.ts` (projectName, blog edit URLs, navbar links)
- **Value**: `portfolio-docs`
- **Required**: Yes
- **Default**: `portfolio-docs` (fallback in config)

#### `DOCUSAURUS_GITHUB_REPO_APP`

- **Purpose**: GitHub repository name for portfolio-app (cross-linking)
- **Used in**: `docusaurus.config.ts` (customFields.githubRepoAppUrl)
- **Value**: `portfolio-app`
- **Required**: No (used for documentation cross-references)
- **Default**: `portfolio-app` (fallback in config)

### Portfolio App Integration

#### `DOCUSAURUS_PORTFOLIO_APP_URL`

- **Purpose**: URL of the Portfolio App (for cross-linking from docs to live app)
- **Used in**: `docusaurus.config.ts` (customFields.portfolioAppUrl)
- **Local**: `http://localhost:3000` (if running portfolio-app locally)
- **Production**: `https://bns-portfolio-app.vercel.app`
- **Required**: No (used for doc → app navigation)
- **Default**: `https://bns-portfolio-app.vercel.app` (fallback in config)

## Optional Variables

### Feature Flags

#### `DOCUSAURUS_ENABLE_BLOG_EDIT`

- **Purpose**: Toggle blog edit links on/off
- **Values**: `true` | `false`
- **Default**: Edit links enabled if `editUrl` is configured
- **Use case**: Disable edit links in production if blog is curated/controlled

### Analytics (Future)

#### `DOCUSAURUS_GA_MEASUREMENT_ID`

- **Purpose**: Google Analytics measurement ID
- **Example**: `G-XXXXXXXXXX`
- **Used in**: gtag plugin configuration (when enabled)
- **Security note**: Public-safe (GA IDs are meant to be exposed)

## Configuration Pattern

### In `docusaurus.config.ts`

```typescript
const config: Config = {
  url: process.env.DOCUSAURUS_SITE_URL || 'https://bns-portfolio-docs.vercel.app',
  baseUrl: process.env.DOCUSAURUS_BASE_URL || '/',
  organizationName: process.env.DOCUSAURUS_GITHUB_ORG || 'bryce-seefieldt',
  projectName: process.env.DOCUSAURUS_GITHUB_REPO_DOCS || 'portfolio-docs',

  customFields: {
    portfolioAppUrl: process.env.DOCUSAURUS_PORTFOLIO_APP_URL || 'https://bns-portfolio-app.vercel.app',
    githubOrgUrl: `https://github.com/${process.env.DOCUSAURUS_GITHUB_ORG || 'bryce-seefieldt'}`,
    githubRepoDocsUrl: `https://github.com/${process.env.DOCUSAURUS_GITHUB_ORG || 'bryce-seefieldt'}/${process.env.DOCUSAURUS_GITHUB_REPO_DOCS || 'portfolio-docs'}`,
    githubRepoAppUrl: `https://github.com/${process.env.DOCUSAURUS_GITHUB_ORG || 'bryce-seefieldt'}/${process.env.DOCUSAURUS_GITHUB_REPO_APP || 'portfolio-app'}`,
  },
};
```

### Accessing Custom Fields in React Components

```tsx
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';

function MyComponent() {
  const { siteConfig } = useDocusaurusContext();
  const portfolioAppUrl = siteConfig.customFields.portfolioAppUrl as string;
  
  return <a href={portfolioAppUrl}>Visit Portfolio App</a>;
}
```

## Environment-Specific Configuration

### Local Development (`.env.local`)

```bash
DOCUSAURUS_SITE_URL=http://localhost:3000
DOCUSAURUS_BASE_URL=/
DOCUSAURUS_GITHUB_ORG=bryce-seefieldt
DOCUSAURUS_GITHUB_REPO_DOCS=portfolio-docs
DOCUSAURUS_GITHUB_REPO_APP=portfolio-app
DOCUSAURUS_PORTFOLIO_APP_URL=http://localhost:3000
```

### Vercel Preview

Environment variables set in Vercel dashboard (Project Settings → Environment Variables):

- **Scope**: Preview
- **Values**: Same as production (preview uses production URLs for cross-linking)

### Vercel Production

Environment variables set in Vercel dashboard:

- **Scope**: Production
- **Values**: Production URLs (`https://bns-portfolio-docs.vercel.app`, etc.)

## File Precedence

Docusaurus respects standard `.env` file precedence:

1. `.env.local` (highest priority, gitignored, local overrides)
2. `.env.production.local` (gitignored, production-specific overrides)
3. `.env.development.local` (gitignored, dev-specific overrides)
4. `.env.production` (optional, production defaults)
5. `.env.development` (optional, dev defaults)
6. `.env` (lowest priority, base defaults, can be committed)

**Recommendation**: Use `.env.local` for local development; configure Vercel dashboard for deployments.

## Security Notes

### Public-Safe Variables Only

- ✅ All `DOCUSAURUS_*` variables are **public-safe** (exposed to client-side)
- ✅ No secrets, API keys, tokens, or private infrastructure details
- ✅ GitHub repository URLs are already public
- ✅ Production deployment URLs are intentionally public

### What NOT to Put in Environment Variables

- ❌ API keys or tokens
- ❌ Private internal URLs or infrastructure endpoints
- ❌ Secrets of any kind
- ❌ Non-public repository URLs

### Build-Time vs Runtime

- All environment variables are resolved at **build time** (static site generation)
- No runtime environment variable access (static HTML/JS/CSS)
- Changes to environment variables require rebuild and redeploy

## Validation

### Local Validation

```bash
# Set .env.local with your local config
cp .env.example .env.local

# Verify build with environment variables
pnpm build

# Check generated URLs in build output
grep -r "localhost:3000" build/  # Should appear if DOCUSAURUS_SITE_URL is local
```

### CI/CD Validation

- CI workflow uses default fallback values (no `.env.local` in CI)
- Build should succeed with defaults (production URLs)
- Vercel deployment uses environment variables from dashboard

## Troubleshooting

### Links point to wrong environment

- **Symptom**: Documentation links to portfolio-app use `localhost` in production
- **Cause**: `DOCUSAURUS_PORTFOLIO_APP_URL` not set correctly in Vercel
- **Fix**: Set `DOCUSAURUS_PORTFOLIO_APP_URL=https://bns-portfolio-app.vercel.app` in Vercel dashboard (Production scope)

### Edit links broken

- **Symptom**: Blog or docs "Edit this page" links 404
- **Cause**: `DOCUSAURUS_GITHUB_ORG` or `DOCUSAURUS_GITHUB_REPO_DOCS` misconfigured
- **Fix**: Verify environment variables match actual GitHub org/repo names

### Build uses wrong base URL

- **Symptom**: Site assets 404 or navigation broken
- **Cause**: `DOCUSAURUS_BASE_URL` set incorrectly (e.g., `/docs/` when it should be `/`)
- **Fix**: Ensure `DOCUSAURUS_BASE_URL=/` (or appropriate subpath) in all environments

## References

- Repository root: `.env.example` (canonical contract)
- Docusaurus config: `docusaurus.config.ts` (implementation)
- Docusaurus docs: [Using Environment Variables](https://docusaurus.io/docs/deployment#using-environment-variables)
- Portfolio App env contract: [portfolio-app-env-contract.md](/docs/_meta/env/portfolio-app-env-contract.md)

---

**Owner**: DevOps Platform + Security  
**Last Updated**: 2026-01-20  
**Next Review**: When adding new environment-dependent features
