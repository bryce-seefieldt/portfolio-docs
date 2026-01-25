---
title: 'Performance Optimization Guide (Portfolio App)'
description: 'Concise reference for bundle analysis, caching, and Vercel Analytics signals for the Portfolio App.'
sidebar_position: 9
tags: [reference, performance, caching, bundle, analytics, stage-4-2]
---

## Purpose

Quick reference for performance work on the Portfolio App: how to analyze bundles, confirm caching, and find analytics signals.

## Source of truth

- Detailed baseline metrics: https://github.com/bryce-seefieldt/portfolio-app/blob/main/docs/performance-baseline.md
- Vercel Analytics dashboard: https://vercel.com/bryce-seefieldt/portfolio-app/analytics

## Commands

- Build with analyzer: `ANALYZE=true pnpm build`
- Time build locally: `pnpm analyze:build`
- Check JS total: `find .next -name "*.js" -type f | xargs wc -c | tail -1`
- Check cache header (local): `curl -I http://localhost:3000/projects/portfolio-app | grep Cache-Control`

## Expected signals

- Cache-Control: `public, max-age=3600, stale-while-revalidate=86400`
- JS total baseline: ~27.8 MB (Phase 2); investigate >10% growth
- Routes: project pages are SSG with 1h ISR
- Core Web Vitals targets: LCP < 2.5s, FID < 100ms, CLS < 0.1

## Analytics

- Dashboard: https://vercel.com/bryce-seefieldt/portfolio-app/analytics
- Ensure recent preview/prod deploy; allow time for ingestion.
- If empty: verify Analytics enabled, hit pages (home + project), retry after a few minutes.

## Notes

- CI enforces 10% JS growth threshold; update baseline only with explicit justification.
- Turbopack is enabled; keep `turbopack: {}` in next.config.ts to avoid webpack conflicts when analyzer plugin is present.
