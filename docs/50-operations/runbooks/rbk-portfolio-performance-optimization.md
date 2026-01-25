---
title: 'Runbook: Portfolio Performance Optimization & Monitoring'
description: 'Procedures for verifying performance baselines, bundle size regressions, and Vercel Analytics signals for the Portfolio App.'
sidebar_position: 9
tags: [runbook, performance, optimization, monitoring, stage-4-2]
---

## Purpose

Operational steps to confirm performance baselines, detect regressions (bundle size, build time), and verify Vercel Analytics signals for the Portfolio App.

## Source of truth

- Baseline metrics and thresholds live in the app repo: https://github.com/bryce-seefieldt/portfolio-app/blob/main/docs/performance-baseline.md
- Vercel Analytics dashboard (preview/prod): https://vercel.com/bryce-seefieldt/portfolio-app/analytics

## Prerequisites

- Access to Vercel project with Analytics enabled
- pnpm and Node 20 installed locally (matches CI)
- Environment variables loaded (`.env.local`)

## Procedure

1) Build with bundle analyzer (optional visualization)
- Command: `ANALYZE=true pnpm build`
- Expectation: build succeeds; routes show static/SSG; analyzer opens for bundle composition review.

2) Capture build duration
- Command: `pnpm analyze:build`
- Expectation: build time logged (e.g., ~9.6s local). Compare to baseline in performance-baseline.md.

3) Bundle size regression check (local quick guard)
- After build: `du -sh .next` and `find .next -name "*.js" -type f | xargs wc -c | tail -1`
- Expectation: JS total ~27.8 MB baseline (Phase 2). Investigate if >10% growth.

4) Verify Cache-Control headers (local)
- Start: `pnpm start`
- Command: `curl -I http://localhost:3000/projects/portfolio-app | grep Cache-Control`
- Expectation: `public, max-age=3600, stale-while-revalidate=86400`.

5) Verify Vercel Analytics data
- Deploy preview (or prod) and open dashboard: https://vercel.com/bryce-seefieldt/portfolio-app/analytics
- Expectation: Core Web Vitals charts populate (LCP <2.5s, FID <100ms, CLS <0.1). If empty, wait for traffic or trigger synthetic page views.

6) CI bundle threshold behavior
- CI build step runs bundle check (10% JS growth threshold). If failing, inspect new deps and update baseline only with justification.

## Validation

- Build passes locally (`pnpm build` or `pnpm analyze:build`).
- Cache-Control header present and correct.
- JS total within 10% of baseline unless justified.
- Vercel Analytics shows data for latest deploy (preview or prod).

## Rollback / Recovery

- If bundle regression found: revert or tree-shake the offending dependency; re-run `pnpm build`.
- If analytics missing: confirm Vercel Analytics is enabled and env matches; redeploy preview; check ad/tracker blockers locally.

## Troubleshooting

- Build fails with Turbopack/webpack warning: ensure `turbopack: {}` exists in next.config.ts.
- Analyzer not launching: ensure `ANALYZE=true` and no headless CI context (use local).
- Cache headers missing in prod: verify next.config.ts headers and redeploy; Vercel may cache prior headers until next deploy.
- Analytics empty: verify project/branch matches dashboard, allow time for ingestion, and ensure no script blocking.
