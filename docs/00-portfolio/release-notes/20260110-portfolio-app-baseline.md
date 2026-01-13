---
title: 'Release Notes: Portfolio App Baseline (App Skeleton + Governance + Supply-Chain Controls)'
description: 'Initial public baseline of the Portfolio App including core routes, evidence-first integration, deterministic CI quality gates, supply-chain automation, and branch governance.'
tags: [release-notes, portfolio-app, governance, ci, security, operations]
date: 2026-01-10
---

# Release Notes: Portfolio App Baseline (App Skeleton + Governance + Supply-Chain Controls)

## Summary

This release establishes the Portfolio App as a production-quality, public-facing Next.js + TypeScript application with an evidence-first UX, deterministic build posture, and enterprise-grade delivery governance. The app now provides stable navigation surfaces for reviewers while enforcing CI quality gates, supply-chain hygiene, and protected mainline workflows.

## Highlights

- A complete front-of-house application skeleton with stable routes and reviewer-oriented content
- Centralized, public-safe configuration and documentation integration contract
- Deterministic CI quality gates with stable check naming for governance and promotion workflows
- Baseline supply-chain controls (static analysis + automated dependency updates)
- Protected `main` branch governance aligned with enterprise policy patterns

---

## Added

### Application surface (routes and UX)

- Landing page (`/`) implemented as an evidence-first entry point:
  - reviewer “fast path” guidance
  - curated links into the Documentation App evidence hubs
- Interactive CV skeleton (`/cv`) with structured capability sections and evidence hub links
- Projects listing (`/projects`) with featured entries and a scalable registry placeholder
- Project detail route (`/projects/[slug]`) using a standard “proof + evidence links” shape
- Contact page (`/contact`) providing static contact methods (no backend form; reduced surface area)

### Configuration and evidence-link contract

- Centralized public-safe configuration module:
  - `src/lib/config.ts` reads `NEXT_PUBLIC_*` variables only
  - stable helpers for evidence links (`docsUrl()`) and mail links (`mailtoUrl()`)
- Committed environment variable contract:
  - `./.env.example` provides required/optional keys and public-safety guidance
  - local development uses `.env.local` (not committed)

### Project registry placeholder

- Minimal project registry introduced to support scalable content:
  - `src/data/projects.ts` defines `Project` and `EvidenceLinks`
  - featured project entries include stable slugs and evidence paths

### Repository documentation

- README updated with repository overview, local development commands, and links to evidence and runbooks.

---

## Changed

### Developer workflow and quality enforcement

- Standardized local command contract:
  - `pnpm lint`
  - `pnpm format:check`
  - `pnpm typecheck`
  - `pnpm build`
- Formatting configuration updated to support modern plugin ecosystems:
  - Prettier configuration uses ESM (`prettier.config.mjs`)
  - Tailwind class sorting plugin enabled via plugin name reference
- Linting runs via ESLint CLI (Next.js no longer provides `next lint` in modern versions)

---

## Governance and Security Baselines

### Continuous Integration (CI) quality gates

- GitHub Actions CI established with stable, governance-grade check names:
  - `ci / quality` (lint + format check + typecheck)
  - `ci / build` (production build; depends on quality gate)
- Deterministic installs in CI:
  - `pnpm install --frozen-lockfile` enforced

### Branch governance

- `main` branch protected using GitHub **Rulesets** (policy-based governance):
  - PR required before merge
  - required checks enforced (`ci / quality`, `ci / build`)
  - force-push blocked
  - branch deletion prevented
  - conversation resolution required (recommended baseline)

### Supply-chain automation

- CodeQL scanning enabled for JavaScript/TypeScript:
  - runs on PRs and `main`
  - scheduled periodic scans enabled
- Dependabot enabled:
  - weekly cadence for dependencies and GitHub Actions
  - patch/minor grouped
  - majors excluded by default to reduce unplanned churn

### PR discipline

- PR template added to enforce:
  - change summary and rationale
  - evidence checklist (local commands + CI)
  - “no secrets added” declaration
  - documentation impact checklist (dossier, ADR, threat model, runbooks where applicable)

---

## Verification

The release is considered valid when:

- `ci / quality` and `ci / build` pass on `main`
- Branch ruleset enforcement blocks merge without required checks
- Application builds successfully with `pnpm build`
- Documentation links resolve correctly once `NEXT_PUBLIC_DOCS_BASE_URL` is configured in the deployment environment

---

## Known limitations (intentional)

- No authentication
- No backend contact form (static contact links only)
- Project registry remains static and minimal by design (intended to evolve into a richer data-driven model)
- Deeper technical artifacts (decisions, threat models, runbooks) remain authored and maintained in the Documentation App (linked from this app)

---

## Follow-ups (next increments)

- Deploy the Portfolio App to Vercel with preview deployments and production promotion gated by imported GitHub checks
- Introduce smoke tests (and later unit/e2e) as phased gates once the baseline remains stable
- Expand the project registry and complete one “gold standard” project page with a full evidence trail
