---
title: 'Runbook: Portfolio Performance Optimization & Monitoring'
description: 'Procedures for verifying performance baselines, bundle size regressions, and Vercel Speed Insights (Core Web Vitals) for the Portfolio App.'
sidebar_position: 9
tags:
  [runbook, performance, optimization, monitoring, stage-4-2, speed-insights]
---

## Purpose

Operational steps to confirm performance baselines, detect regressions (bundle size, build time), and verify Vercel Analytics signals for the Portfolio App.

## Source of truth

- Baseline metrics and thresholds (machine-readable): [`portfolio-app/docs/performance-baseline.yml`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/docs/performance-baseline.yml)
- Baseline documentation (human-readable): [`portfolio-app/docs/performance-baseline.md`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/docs/performance-baseline.md)
- Vercel Speed Insights dashboard (Core Web Vitals): [portfolio-app/speed-insights](https://vercel.com/bryce-seefieldts-projects/portfolio-app/speed-insights)
- Vercel Web Analytics dashboard (traffic/visits): [portfolio-app/analytics](https://vercel.com/bryce-seefieldts-projects/portfolio-app/analytics)
- Vercel Speed Insights docs: https://vercel.com/docs/speed-insights

## Prerequisites

- Access to Vercel project with Speed Insights enabled
- Packages installed: `@vercel/analytics` (traffic) and `@vercel/speed-insights` (performance)
- pnpm and Node 20 installed locally (matches CI)
- Environment variables loaded (`.env.local`)

## Procedure

### Phase A: Local Verification (Pre-Deploy)

**Purpose:** Catch potential performance regressions in bundle size and caching before deployment. These steps verify code changes, NOT real-user experience.

#### Step 1: Build with bundle analyzer (optional visualization)

- Command: `ANALYZE=true pnpm build`
- Expectation: build succeeds; routes show static/SSG; analyzer opens for bundle composition review.
- **When to use:** If you want visual breakdown of what's in your JavaScript bundles (useful after adding large dependencies).

#### Step 2: Capture build duration

- Command: `pnpm analyze:build`
- Expectation: build time logged (e.g., ~9.6s local). Compare to baseline in performance-baseline.yml.
- **When to use:** After code changes; if build time creeps up, may indicate new bottlenecks.
- **Action:** If > 10% slower than baseline, see [Slow Build Time troubleshooting](./rbk-portfolio-performance-troubleshooting.md#slow-build-time).

#### Step 3: Bundle size regression check (local quick guard)

- After build: `du -sh .next` and `find .next -name "*.js" -type f | xargs wc -c | tail -1`
- Expectation: JS total ~27.8 MB baseline. Investigate if > 10% growth.
- **When to use:** Every pre-deploy; catches accidental bloat before it hits production.
- **Action:** If > 10% growth, see [Bundle Size Regression troubleshooting](./rbk-portfolio-performance-troubleshooting.md#bundle-size-regression).

#### Step 4: Verify Cache-Control headers (local)

- Start: `pnpm start`
- Command: `curl -I http://localhost:3000/projects/portfolio-app | grep Cache-Control`
- Expectation: `public, max-age=3600, stale-while-revalidate=86400`.
- **When to use:** After changes to next.config.ts or layout; ensures caching strategy is in place.
- **Action:** If headers missing, see [Cache Headers Missing troubleshooting](./rbk-portfolio-performance-troubleshooting.md#cache-headers-missing). If headers different, see [Cache Headers Mismatch troubleshooting](./rbk-portfolio-performance-troubleshooting.md#cache-headers-mismatch).

**Summary of Phase A:** If all checks pass, you've verified code-level optimizations are correct. Ready to deploy.

---

### Phase B: Deployed Verification (Post-Deploy)

**Purpose:** Monitor real-user Core Web Vitals performance after deployment. Speed Insights shows how actual visitors experience your app, NOT hypothetical performance.

#### Step 5: Deploy and verify Speed Insights data collection

**Status:** Speed Insights requires Vercel Pro plan or $10/month add-on on Hobby plan. This step is deferred until plan upgrade.

- **Prerequisite:** Speed Insights must be enabled in Vercel project settings (requires paid add-on on Hobby plan)
- **How to enable:** Vercel project → Settings → Speed Insights → Enable (pay-what-you-want, starts at $10/month)
- Once enabled: Deploy to preview (feature branch) or production (main branch)
- **Timeline:** Within 5-10 minutes of traffic, Core Web Vitals charts populate with Real Experience Score (RES)
- **Key metrics:** LCP < 2.5s, INP < 200ms, CLS < 0.1, FCP < 1.8s
- **If empty:** Wait for traffic (need ~50-100 page views for reliable P75 metrics)

#### Step 6: Enable & review Speed Insights in Vercel dashboard

**Status:** Deferred to a later hardening pass when Speed Insights add-on is enabled.

Once Speed Insights is enabled:

- Path: Vercel → Project **portfolio-app** → **Speed Insights** → select environment (Production or Preview)
- **Select environment:** Pick Production (main branch) or Preview (feature branch)
- **View metrics:** Real Experience Score (RES) should be ≥ 90 (green). If < 90, click each metric to identify problem routes/selectors
- **Adjust date range:** Use date picker (top-right) to focus on timeframe (e.g., last 7 days since deployment)
- **Troubleshooting:** See [Vercel metrics guide](https://vercel.com/docs/speed-insights/metrics) and [Poor Speed Insights Scores troubleshooting](./rbk-portfolio-performance-troubleshooting.md#poor-speed-insights-scores-res--90)

**Summary of Phase B:** Deferred. Once Speed Insights enabled, follow steps above to verify real-user performance.

**Note on Status 204 responses:** Script endpoint returning 204 No Content indicates Speed Insights is not enabled. This is expected until the feature is purchased and enabled in project settings.

---

## Monitoring & Analysis Guides

### Understanding Speed Insights Dashboard

**Dashboard URL:** https://vercel.com/bryce-seefieldts-projects/portfolio-app/speed-insights  
**Reference:** [Using Speed Insights](https://vercel.com/docs/speed-insights/using-speed-insights) | [Metrics Guide](https://vercel.com/docs/speed-insights/metrics)

#### Understanding the Overview

1. **Real Experience Score (RES)** - Top-level metric
   - Weighted average of all Core Web Vitals from real user devices
   - Score range: 0-100 with color coding:
     - **90-100 (green)**: Good - excellent user experience
     - **50-89 (orange)**: Needs Improvement - functional but suboptimal
     - **0-49 (red)**: Poor - serious performance issues
   - Target: **≥ 90** for production
   - Based on P75 (75th percentile) by default - represents experience of fastest 75% of users

2. **Time-based Graph**
   - Shows RES trend over selected timeframe
   - Click percentile dropdown to switch between P75 (default), P90, P95, P99
   - **P75**: Excludes slowest 25% of users (balanced view)
   - **P99**: Excludes slowest 1% (best-case scenario)
   - Use date range picker (top-right) for custom timeframes

3. **Environment Selector** (top-right)
   - **Production**: Main branch deployed to production URL
   - **Preview**: Feature branch preview deployments
   - **All Environments**: Combined view
   - Always verify you're viewing the correct environment for your analysis

#### Core Web Vitals Breakdown

**Largest Contentful Paint (LCP)** - Loading Performance

- **What it measures:** Time until largest content element appears (hero image, main heading, etc.)
- **Target:** < 2.5 seconds
- **Good:** 0-2500ms (green) | **Needs Improvement:** 2500-4000ms (orange) | **Poor:** > 4000ms (red)
- **How to improve:** Optimize images, reduce server response time, eliminate render-blocking resources
- **Dashboard view:** Click "LCP" in left panel → see breakdown by route/path/selector

**Interaction to Next Paint (INP)** - Responsiveness (Primary Metric)

- **What it measures:** Time from user interaction (click, tap, keypress) to browser rendering response
- **Target:** < 200 milliseconds
- **Good:** 0-200ms (green) | **Needs Improvement:** 200-500ms (orange) | **Poor:** > 500ms (red)
- **How to improve:** Reduce JavaScript execution time, defer non-critical scripts, optimize event handlers
- **Dashboard view:** Click "INP" → see which elements/interactions are slow
- **Note:** INP replaced FID as the primary responsiveness metric (Lighthouse 10+)

**Cumulative Layout Shift (CLS)** - Visual Stability

- **What it measures:** How much page content shifts unexpectedly during load
- **Target:** < 0.1
- **Good:** 0-0.1 (green) | **Needs Improvement:** 0.1-0.25 (orange) | **Poor:** > 0.25 (red)
- **How to improve:** Set image/video dimensions, avoid inserting content above existing content, use CSS transforms
- **Dashboard view:** Click "CLS" → see which elements cause layout shifts

**First Contentful Paint (FCP)** - Initial Rendering

- **What it measures:** Time until first text, image, or canvas element appears
- **Target:** < 1.8 seconds
- **Good:** 0-1800ms (green) | **Needs Improvement:** 1800-3000ms (orange) | **Poor:** > 3000ms (red)
- **Dashboard view:** Click "FCP" → breakdown by route

**First Input Delay (FID)** - Legacy Responsiveness (Deprecated)

- **What it measures:** Time from first user interaction to browser response
- **Target:** < 100 milliseconds
- **Note:** Being replaced by INP; still tracked for historical comparison
- **Status:** Use INP for modern analysis; FID for legacy baseline comparison

**Other Metrics:**

- **Total Blocking Time (TBT):** < 800ms - time main thread is blocked (Virtual Experience Score)
- **Time to First Byte (TTFB):** < 800ms - server response time

#### Analyzing Performance by Dimension

**By Route/Path** (Most useful for identifying problem pages)

1. Click any metric (e.g., LCP) in left panel
2. Switch between **Route** (framework routes) vs **Path** (actual URLs) tabs
3. Sort by:
   - **Score** (lowest first = worst performers)
   - **Data Points** (most traffic first)
4. Click **View all** to see complete list with filters
5. **Action:** Focus optimization on routes with orange/red scores AND high traffic

**By HTML Selector** (Available for LCP, INP, CLS, FID)

1. Click **Selectors** tab
2. See specific HTML elements causing issues
3. Example: `img.hero-image` causing slow LCP
4. **Action:** Optimize identified elements (lazy load, compress, defer)

**By Country** (Geographic Performance)

1. Scroll to **Countries** section
2. Map shows color-coded performance per region
3. Click country for detailed breakdown
4. **Action:** If specific regions are slow, consider CDN optimization or regional edge functions

#### Interpreting Percentiles

- **P75 (default):** 75% of users experience this speed or better
  - Example: P75 LCP = 2.0s means 75% of users see content in ≤ 2.0s, 25% wait longer
- **P90:** 90% experience this or better (excludes slowest 10%)
- **P95:** 95% experience this or better (excludes slowest 5%)
- **P99:** 99% experience this or better (near best-case)

**Best Practice:** Use P75 for general health, P90/P95 to catch outliers

#### Data Point Collection

Speed Insights collects up to **6 data points per visit**:

- **On page load:** TTFB, FCP
- **On interaction:** FID, LCP
- **On leave:** INP, CLS, LCP (if not already sent)

**Note:** Only hard navigations (first page view) are tracked. Next.js client-side route changes don't generate new data points.

#### Actionable Workflow

1. **Check RES Score:** Is it green (≥90)? If yes, monitor periodically. If orange/red, continue analysis.
2. **Identify worst metric:** Which Core Web Vital is dragging down the score? (Red/orange)
3. **Find problem routes:** Click that metric → sort by score → identify low-scoring high-traffic pages
4. **Drill into selectors:** Switch to Selectors tab → see which elements cause issues
5. **Check geography:** If specific regions lag, consider CDN/edge optimization
6. **Compare environments:** Switch between Production/Preview to validate fixes before promoting
7. **Monitor trends:** Use time graph to see if recent deploys improved/degraded performance

#### Red Flags to Investigate

- RES score < 90 (orange/red)
- Any metric in red zone (LCP > 4s, INP > 500ms, CLS > 0.25)
- Sudden score drop after deployment (check time graph)
- High-traffic routes with orange/red scores
- Geographic disparities (e.g., APAC slow, US fast)

#### Step 8: CI bundle threshold behavior (continuous monitoring)

- Note: CI build step runs bundle check (10% JS growth threshold). If failing, inspect new deps and update baseline only with justification.
- This is an automated gate during PR/deployment; if it fails, address in Phase A (local checks) before redeploying.

---

#### Step 7: Review Speed Insights dashboard insights

**Dashboard URL:** https://vercel.com/bryce-seefieldts-projects/portfolio-app/speed-insights  
**Reference:** [Using Speed Insights](https://vercel.com/docs/speed-insights/using-speed-insights) | [Metrics Guide](https://vercel.com/docs/speed-insights/metrics)

#### Understanding the Overview

1. **Real Experience Score (RES)** - Top-level metric
   - Weighted average of all Core Web Vitals from real user devices
   - Score range: 0-100 with color coding:
     - **90-100 (green)**: Good - excellent user experience
     - **50-89 (orange)**: Needs Improvement - functional but suboptimal
     - **0-49 (red)**: Poor - serious performance issues
   - Target: **≥ 90** for production
   - Based on P75 (75th percentile) by default - represents experience of fastest 75% of users

2. **Time-based Graph**
   - Shows RES trend over selected timeframe
   - Click percentile dropdown to switch between P75 (default), P90, P95, P99
   - **P75**: Excludes slowest 25% of users (balanced view)
   - **P99**: Excludes slowest 1% (best-case scenario)
   - Use date range picker (top-right) for custom timeframes

3. **Environment Selector** (top-right)
   - **Production**: Main branch deployed to production URL
   - **Preview**: Feature branch preview deployments
   - **All Environments**: Combined view
   - Always verify you're viewing the correct environment for your analysis

#### Core Web Vitals Breakdown

**Largest Contentful Paint (LCP)** - Loading Performance

- **What it measures:** Time until largest content element appears (hero image, main heading, etc.)
- **Target:** < 2.5 seconds
- **Good:** 0-2500ms (green) | **Needs Improvement:** 2500-4000ms (orange) | **Poor:** > 4000ms (red)
- **How to improve:** Optimize images, reduce server response time, eliminate render-blocking resources
- **Dashboard view:** Click "LCP" in left panel → see breakdown by route/path/selector

**Interaction to Next Paint (INP)** - Responsiveness (Primary Metric)

- **What it measures:** Time from user interaction (click, tap, keypress) to browser rendering response
- **Target:** < 200 milliseconds
- **Good:** 0-200ms (green) | **Needs Improvement:** 200-500ms (orange) | **Poor:** > 500ms (red)
- **How to improve:** Reduce JavaScript execution time, defer non-critical scripts, optimize event handlers
- **Dashboard view:** Click "INP" → see which elements/interactions are slow
- **Note:** INP replaced FID as the primary responsiveness metric (Lighthouse 10+)

**Cumulative Layout Shift (CLS)** - Visual Stability

- **What it measures:** How much page content shifts unexpectedly during load
- **Target:** < 0.1
- **Good:** 0-0.1 (green) | **Needs Improvement:** 0.1-0.25 (orange) | **Poor:** > 0.25 (red)
- **How to improve:** Set image/video dimensions, avoid inserting content above existing content, use CSS transforms
- **Dashboard view:** Click "CLS" → see which elements cause layout shifts

**First Contentful Paint (FCP)** - Initial Rendering

- **What it measures:** Time until first text, image, or canvas element appears
- **Target:** < 1.8 seconds
- **Good:** 0-1800ms (green) | **Needs Improvement:** 1800-3000ms (orange) | **Poor:** > 3000ms (red)
- **Dashboard view:** Click "FCP" → breakdown by route

**First Input Delay (FID)** - Legacy Responsiveness (Deprecated)

- **What it measures:** Time from first user interaction to browser response
- **Target:** < 100 milliseconds
- **Note:** Being replaced by INP; still tracked for historical comparison
- **Status:** Use INP for modern analysis; FID for legacy baseline comparison

**Other Metrics:**

- **Total Blocking Time (TBT):** < 800ms - time main thread is blocked (Virtual Experience Score)
- **Time to First Byte (TTFB):** < 800ms - server response time

#### Analyzing Performance by Dimension

**By Route/Path** (Most useful for identifying problem pages)

1. Click any metric (e.g., LCP) in left panel
2. Switch between **Route** (framework routes) vs **Path** (actual URLs) tabs
3. Sort by:
   - **Score** (lowest first = worst performers)
   - **Data Points** (most traffic first)
4. Click **View all** to see complete list with filters
5. **Action:** Focus optimization on routes with orange/red scores AND high traffic

**By HTML Selector** (Available for LCP, INP, CLS, FID)

1. Click **Selectors** tab
2. See specific HTML elements causing issues
3. Example: `img.hero-image` causing slow LCP
4. **Action:** Optimize identified elements (lazy load, compress, defer)

**By Country** (Geographic Performance)

1. Scroll to **Countries** section
2. Map shows color-coded performance per region
3. Click country for detailed breakdown
4. **Action:** If specific regions are slow, consider CDN optimization or regional edge functions

#### Interpreting Percentiles

- **P75 (default):** 75% of users experience this speed or better
  - Example: P75 LCP = 2.0s means 75% of users see content in ≤ 2.0s, 25% wait longer
- **P90:** 90% experience this or better (excludes slowest 10%)
- **P95:** 95% experience this or better (excludes slowest 5%)
- **P99:** 99% experience this or better (near best-case)

**Best Practice:** Use P75 for general health, P90/P95 to catch outliers

#### Data Point Collection

Speed Insights collects up to **6 data points per visit**:

- **On page load:** TTFB, FCP
- **On interaction:** FID, LCP
- **On leave:** INP, CLS, LCP (if not already sent)

**Note:** Only hard navigations (first page view) are tracked. Next.js client-side route changes don't generate new data points.

#### Actionable Workflow

1. **Check RES Score:** Is it green (≥90)? If yes, monitor periodically. If orange/red, continue analysis.
2. **Identify worst metric:** Which Core Web Vital is dragging down the score? (Red/orange)
3. **Find problem routes:** Click that metric → sort by score → identify low-scoring high-traffic pages
4. **Drill into selectors:** Switch to Selectors tab → see which elements cause issues
5. **Check geography:** If specific regions lag, consider CDN/edge optimization
6. **Compare environments:** Switch between Production/Preview to validate fixes before promoting
7. **Monitor trends:** Use time graph to see if recent deploys improved/degraded performance

#### Red Flags to Investigate

- RES score < 90 (orange/red)
- Any metric in red zone (LCP > 4s, INP > 500ms, CLS > 0.25)
- Sudden score drop after deployment (check time graph)
- High-traffic routes with orange/red scores
- Geographic disparities (e.g., APAC slow, US fast)

---

### Understanding Web Analytics Dashboard

**Dashboard URL:** https://vercel.com/bryce-seefieldts-projects/portfolio-app/analytics  
**Reference:** [Using Web Analytics](https://vercel.com/docs/analytics/using-web-analytics) | [Filtering](https://vercel.com/docs/analytics/filtering)

#### Purpose & Scope

**Web Analytics tracks traffic & user behavior**, NOT performance metrics.

- Page views, unique visitors, routes accessed
- Referrer sources (where visitors came from)
- Geographic distribution, devices, browsers, OS
- Custom events (if configured)

**For performance metrics, use Speed Insights dashboard instead.**

#### Overview Metrics

**Top of Dashboard:**

1. **Visitors** - Unique visitors in selected timeframe
2. **Page Views** - Total pages viewed
3. **Average Visit Duration** - How long users stay on site
4. **Bounce Rate** - % who leave after viewing one page

**Time Selector** (top-right):

- Predefined: Last 24h, 7d, 30d, 90d
- Custom: Click calendar icon for specific date range

**Environment Selector** (top-right):

- **Production** (default) - Main site traffic
- **Preview** - Preview deployment traffic (usually low/zero for public sites)
- **All Environments** - Combined

#### Analyzing Traffic by Dimension

**Pages Panel**

- Lists all page URLs visited (without query params)
- Shows views, unique visitors per page
- **Action:** Identify most popular pages (focus optimization there)

**Routes Panel**

- Shows framework-defined routes (e.g., `/projects/[slug]`)
- Useful for understanding route popularity
- **Action:** If certain routes dominate traffic, ensure they're well-optimized

**Referrers Panel**

- Shows where visitors came from (external links, search engines, social media)
- **Direct** = typed URL or bookmark
- **Action:** Understand traffic sources; optimize for primary referrers

**Countries Panel**

- Geographic distribution of visitors
- **Action:** If concentrated in specific regions, consider geo-targeted optimization

**Browsers / Devices / Operating System Panels**

- Browser usage (Chrome, Safari, Firefox, etc.)
- Device types (Desktop, Mobile, Tablet)
- OS distribution (Windows, macOS, iOS, Android)
- **Action:** Test site on most-used browsers/devices; prioritize mobile if dominant

#### Filtering Data

Click filter icon on any panel to:

- Include/exclude specific values
- Combine filters across dimensions
- **Example:** "Show mobile visitors from US who accessed /projects route"

#### Exporting Data

1. Click three-dot menu on any panel
2. Select **Export as CSV**
3. Exports up to 250 entries from that panel
4. **Use case:** Share with stakeholders, perform custom analysis

#### Verifying Analytics Collection

**Check Network Tab:**

1. Open browser DevTools → Network tab
2. Visit any page on deployed site
3. Look for Fetch/XHR request to `/_vercel/insights/view`
4. **If missing:** Verify `@vercel/analytics` package installed and `<Analytics />` component present

#### Common Insights

**High bounce rate on specific page:**

- Content may not match user expectations (from referrer)
- Slow load time (cross-reference with Speed Insights)
- Broken navigation or unclear CTA

**Low average visit duration:**

- Content not engaging
- Navigation issues
- Mobile experience poor (check Devices panel)

**Geographic concentration:**

- If traffic heavily US-centric, consider if targeting is correct
- If global, ensure CDN delivers well worldwide (check Speed Insights by country)

**Unexpected referrers:**

- May indicate backlinks or mentions
- Verify referrers are legitimate (not spam/bot traffic)

#### Comparison: Speed Insights vs Web Analytics

| Aspect            | Speed Insights                               | Web Analytics                                |
| ----------------- | -------------------------------------------- | -------------------------------------------- |
| **Purpose**       | Performance metrics                          | Traffic behavior                             |
| **Key Metrics**   | LCP, INP, CLS, FCP                           | Page views, visitors, referrers              |
| **Dashboard Tab** | `/speed-insights`                            | `/analytics`                                 |
| **Package**       | `@vercel/speed-insights`                     | `@vercel/analytics`                          |
| **Component**     | `<SpeedInsights />`                          | `<Analytics />`                              |
| **Script Path**   | `/_vercel/speed-insights/script.js`          | `/_vercel/insights/view`                     |
| **Use When**      | Diagnosing slow pages, optimizing load times | Understanding user behavior, traffic sources |

**Workflow Integration:**

1. Use **Web Analytics** to identify high-traffic pages/routes
2. Use **Speed Insights** to ensure those pages perform well
3. Cross-reference: if high-traffic page has poor performance score, prioritize optimization

## Validation

- Build passes locally (`pnpm build` or `pnpm analyze:build`).
- Cache-Control header present and correct.
- JS total within 10% of baseline unless justified.
- Vercel Speed Insights shows Core Web Vitals data for latest deploy (preview or prod).

## Rollback / Recovery

- If bundle regression found: revert or tree-shake the offending dependency; re-run `pnpm build`.
- If Speed Insights data missing: confirm Speed Insights is enabled and env matches; redeploy preview; check ad/tracker blockers locally; verify `@vercel/speed-insights` package installed and `<SpeedInsights />` component present in layout.

## Troubleshooting

- Build fails with Turbopack/webpack warning: ensure `turbopack: {}` exists in next.config.ts.
- Analyzer not launching: ensure `ANALYZE=true` and no headless CI context (use local).
- Cache headers missing in prod: verify next.config.ts headers and redeploy; Vercel may cache prior headers until next deploy.
- Speed Insights empty: verify project/branch matches dashboard, allow time for data ingestion (few minutes post-deploy), ensure no script blocking, check `/_vercel/speed-insights/script.js` loads in browser DevTools Network tab.
- Wrong metrics showing: Speed Insights = performance (LCP, INP, CLS); Web Analytics = traffic (page views, routes). Use correct dashboard tab.

**For detailed troubleshooting procedures, see:**

**[Performance Optimization Troubleshooting Runbook](./rbk-portfolio-performance-troubleshooting.md)**

Common issues covered:

- [Bundle Size Regression](./rbk-portfolio-performance-troubleshooting.md#bundle-size-regression) - Exceeds 10% growth threshold
- [Slow Build Time](./rbk-portfolio-performance-troubleshooting.md#slow-build-time) - > 4.2s warning threshold
- [Cache Headers Missing](./rbk-portfolio-performance-troubleshooting.md#cache-headers-missing) - Not configured or not applying
- [Poor Speed Insights Scores](./rbk-portfolio-performance-troubleshooting.md#poor-speed-insights-scores-res--90) - RES < 90, metrics in red zones
