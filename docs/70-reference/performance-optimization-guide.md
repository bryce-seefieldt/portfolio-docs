---
title: 'Performance Optimization Guide (Portfolio App)'
description: 'Concise reference for bundle analysis, caching, and Vercel Speed Insights (Core Web Vitals) for the Portfolio App.'
sidebar_position: 9
tags:
  [
    reference,
    performance,
    caching,
    bundle,
    speed-insights,
    analytics,
    stage-4-2,
  ]
---

## Purpose

Quick reference for performance work on the Portfolio App: how to analyze bundles, confirm caching, and find analytics signals.

## Source of truth

- Baseline metrics (machine-readable): [`portfolio-app/docs/performance-baseline.yml`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/docs/performance-baseline.yml)
- Baseline documentation (human-readable): [`portfolio-app/docs/performance-baseline.md`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/docs/performance-baseline.md)
- Vercel Speed Insights (Core Web Vitals): [portfolio-app/speed-insights](https://vercel.com/bryce-seefieldts-projects/portfolio-app/speed-insights)
- Vercel Web Analytics (traffic): [portfolio-app/analytics](https://vercel.com/bryce-seefieldts-projects/portfolio-app/analytics)
- Vercel docs: [Speed Insights](https://vercel.com/docs/speed-insights) | [Web Analytics](https://vercel.com/docs/analytics)
- Troubleshooting: [Performance Troubleshooting Runbook](../operations/runbooks/rbk-portfolio-performance-troubleshooting.md)

## Commands

- Build with analyzer: `pnpm analyze:bundle` (sets `ANALYZE=true` and runs `pnpm build`)
- Time build locally: `pnpm analyze:build`
- Full verification with performance gates: `pnpm verify` (bundle size + cache checks)
- Quick verification during dev: `pnpm verify:quick` (skips performance checks and all tests)
- Check JS total: `find .next -name "*.js" -type f | xargs wc -c | tail -1`
- Check cache header (local): `curl -I http://localhost:3000/projects/portfolio-app | grep Cache-Control`

## Expected signals

- Cache-Control (HTML): `no-store, must-revalidate` (App Router default)
- ISR Revalidation: 3600 seconds (1 hour) via route segment config
- Static Assets: Aggressive caching with long max-age
- JS total baseline: ~27.8 MB (Phase 2); investigate >10% growth
- Routes: project pages are SSG with 1h ISR

**Note:** Next.js App Router returns `no-store` for HTML but caching still works via:
- Route segment config (`export const revalidate = 3600`)
- Vercel Edge Network caching (respects revalidate setting)
- This is expected behavior and doesn't indicate a caching problem
- Core Web Vitals targets (see [Vercel metrics guide](https://vercel.com/docs/speed-insights/metrics)):
  - LCP (Largest Contentful Paint) < 2.5s
  - INP (Interaction to Next Paint) < 200ms (primary responsiveness metric)
  - CLS (Cumulative Layout Shift) < 0.1
  - FCP (First Contentful Paint) < 1.8s
  - FID (First Input Delay) < 100ms (legacy, still tracked)
  - TBT (Total Blocking Time) < 800ms
  - TTFB (Time to First Byte) < 800ms

## Speed Insights (Performance Metrics)

- Dashboard: https://vercel.com/bryce-seefieldts-projects/portfolio-app/speed-insights
- Access path: Vercel → portfolio-app → **Speed Insights** → pick environment (Production/Preview), adjust date range, read P75 metrics vs targets.
- Key views:
  - **Real Experience Score (RES):** Overall performance (target ≥ 90)
  - **By Route:** Identify slow pages (sort by score, focus on high-traffic routes)
  - **By Selector:** Find specific HTML elements causing issues (LCP, INP, CLS)
  - **By Country:** Geographic performance variations
- Ensure recent preview/prod deploy; allow time for ingestion.
- If empty: verify Speed Insights enabled, hit pages (home + project) in that environment, wait a few minutes, refresh.
- Package: `@vercel/speed-insights` with `<SpeedInsights />` component in layout.
- **Deep dive:** See [runbook dashboard guide](docs/50-operations/runbooks/rbk-portfolio-performance-optimization.md#reading-the-speed-insights-dashboard) for detailed interpretation instructions.

## Web Analytics (Traffic & Behavior)

- Dashboard: https://vercel.com/bryce-seefieldts-projects/portfolio-app/analytics
- Tracks: page views, routes, referrers, devices, countries.
- Key panels: Pages, Routes, Referrers, Countries, Browsers, Devices
- **Use case:** Identify high-traffic pages → prioritize optimization in Speed Insights
- Package: `@vercel/analytics` with `<Analytics />` component in layout.
- **Deep dive:** See [runbook dashboard guide](docs/50-operations/runbooks/rbk-portfolio-performance-optimization.md#reading-the-web-analytics-dashboard) for detailed usage instructions.

## Notes

- CI enforces 10% JS growth threshold; update baseline only with explicit justification. See [Bundle Size Regression troubleshooting](../operations/runbooks/rbk-portfolio-performance-troubleshooting.md#bundle-size-regression) if failing.
- Turbopack is enabled; keep `turbopack: {}` in next.config.ts to avoid webpack conflicts when analyzer plugin is present.
- Both `@vercel/analytics` (traffic) and `@vercel/speed-insights` (performance) are installed; they serve different purposes.

## Quick Decision Tree

**"My app feels slow"**

1. Check Speed Insights → Real Experience Score
2. If RES < 90 (orange/red): Click worst metric → identify problem routes/selectors
3. Optimize identified pages/elements (see [Poor Speed Insights Scores troubleshooting](../operations/runbooks/rbk-portfolio-performance-troubleshooting.md#poor-speed-insights-scores-res--90))
4. Redeploy → verify RES improves

**"Which pages should I optimize first?"**

1. Open Web Analytics → note top 3 pages by traffic
2. Open Speed Insights → check scores for those routes
3. Prioritize: High traffic + Low score = urgent optimization target

**"Did my recent deploy make things worse?"**

1. Speed Insights → check RES time graph for sudden drops
2. Compare Production vs Preview environments
3. If Preview worse than Production: investigate before promoting

**"Where are users coming from?"**

1. Web Analytics → Referrers panel
2. Cross-check with Countries panel for geographic distribution
3. Action: Optimize for primary referrer sources (e.g., if LinkedIn dominates, ensure mobile experience excellent)

**"Is a specific page broken?"**

1. Web Analytics → Pages panel → find the page
2. Check if views dropped suddenly (possible error or navigation break)
3. Cross-check Speed Insights → that route → look for red metrics
4. Test page manually in different browsers (see Browsers panel for user distribution)

## Example Workflows

### Workflow 1: Monthly Performance Review

1. **Speed Insights dashboard:**
   - Verify RES ≥ 90 (green) for Production environment
   - Review 30-day trend: any drops?
   - Check all Core Web Vitals: any orange/red zones?
2. **If issues found:**
   - Click worst metric → sort routes by score
   - Export top 10 problem routes (three-dot menu → export)
   - For each route: check Selectors tab for specific elements causing issues
3. **Geographic check:**
   - Scroll to Countries map
   - Click any orange/red countries → see their metrics
   - Decide if geo-specific optimization needed (CDN, edge functions)

4. **Document findings:**
   - Compare current RES to previous month baseline
   - Log any regressions with route details
   - Create optimization tasks for orange/red routes with high traffic

### Workflow 2: Pre-Production Deployment Validation

1. **Deploy to Preview environment** (feature branch)

2. **Speed Insights:**
   - Switch to Preview environment
   - Generate traffic: manually visit home + top 3 project pages
   - Wait 5 minutes → refresh dashboard
   - Compare Preview RES to Production RES
   - **Gate:** If Preview RES ≥ Production RES → safe to promote
   - **Gate:** If Preview RES < Production RES by >5 points → investigate before merging

3. **Web Analytics (optional):**
   - Switch to Preview environment
   - Verify no broken links (check if expected pages appear)
   - Confirm routes tracked correctly

### Workflow 3: Debugging Specific Performance Complaint

**Scenario:** "Project page X loads slowly on my phone"

1. **Speed Insights:**
   - Environment: Production
   - Click **LCP** (loading) metric
   - Find route `/projects/[slug]` → note score
   - Switch to **Selectors** tab → identify slow elements (likely images)
   - Check **Devices** breakdown: Mobile vs Desktop scores differ?
2. **Web Analytics:**
   - Devices panel → what % of traffic is mobile?
   - If mobile-dominant: mobile optimization is critical
3. **Local testing:**
   - Chrome DevTools → throttle to "Slow 4G"
   - Visit the project page
   - Network tab → find large assets
   - Performance tab → see what blocks rendering
4. **Fix:**
   - Optimize images (compress, lazy load, responsive sizes)
   - Redeploy to Preview
   - Verify in Speed Insights Preview environment
   - Compare before/after LCP scores

### Workflow 4: Identifying Content Opportunities

1. **Web Analytics:**
   - Pages panel → sort by views (descending)
   - Note top 5 pages
   - Routes panel → see which route patterns dominate
2. **Insight:**
   - If `/projects/portfolio-app` gets 60% of traffic: ensure it's your best showcase
   - If `/cv` gets minimal traffic but you want it prominent: consider navigation changes
3. **Cross-reference Speed Insights:**
   - For top-traffic pages: verify green scores
   - Low-traffic pages with red scores: lower priority (but still address eventually)

### Workflow 5: Tracking Optimization Impact

**Scenario:** You optimized images on `/projects/portfolio-app`

1. **Before deployment:**
   - Note current Speed Insights LCP score for that route (e.g., 3.2s, orange)
   - Export route data (CSV) for baseline

2. **Deploy optimization**

3. **After deployment (wait 24-48h for data):**
   - Speed Insights → LCP → find route
   - New score (e.g., 1.8s, green) → improvement confirmed!
   - Check time graph: see the drop at deployment timestamp
4. **Document win:**
   - "Optimized images reduced LCP from 3.2s → 1.8s (44% improvement)"
   - Use in portfolio narrative as evidence of performance work
