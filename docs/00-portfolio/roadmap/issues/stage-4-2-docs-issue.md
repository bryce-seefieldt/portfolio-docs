---
title: 'Stage 4.2 — Performance Optimization & Measurement (Docs)'
description: 'Document performance architecture, optimization strategy, baseline metrics, and operational runbooks for performance monitoring and regression prevention.'
tags:
  [
    portfolio,
    roadmap,
    planning,
    phase-4,
    stage-4-2,
    docs,
    performance,
    runbook,
    reference,
  ]
---

# Stage 4.2: Performance Optimization & Measurement — Documentation

**Type:** Reference Guide / Runbook  
**Phase:** Phase 4 — Enterprise-Grade Platform Maturity  
**Stage:** 4.2  
**Linked Issue:** [stage-4-2-app-issue.md](stage-4-2-app-issue.md)  
**Duration Estimate:** 2–3 hours  
**Assignee:** [Your name or team]

---

## Overview

Document the performance architecture, optimization decisions, baseline metrics, and operational procedures for maintaining and improving performance. This documentation establishes performance accountability, enables regression detection, and provides clear guidance for performance-related investigations—demonstrating production maturity through measurable outcomes.

**Audience:** Engineers, platform reviewers, performance analysts, operations team.

## Objectives

- Document performance architecture and caching strategy with clear rationale
- Create operational runbook for performance optimization and monitoring procedures
- Record baseline performance metrics and establish regression thresholds
- Update portfolio-app dossier with comprehensive performance section
- Provide reference guide for bundle analysis and performance debugging

---

## Scope

### Files to Create

1. **`docs/50-operations/runbooks/rbk-portfolio-performance-optimization.md`** — Performance optimization and monitoring runbook
   - Type: Operational Runbook
   - Purpose: Step-by-step procedures for performance analysis, optimization, and regression investigation
   - Audience: Engineers, DevOps leads, performance analysts
   - Sections: Baseline metrics, optimization procedures, bundle analysis, regression triage, Core Web Vitals monitoring

2. **`docs/70-reference/performance-optimization-guide.md`** — Performance optimization reference guide
   - Type: Reference Guide
   - Purpose: Comprehensive guide to Next.js performance patterns, caching strategies, and optimization techniques
   - Audience: Developers implementing new features
   - Sections: Caching patterns, static generation, ISR strategy, image optimization, bundle size management

### Files to Update

1. **`docs/60-projects/portfolio-app/02-architecture.md`** — Add performance architecture section
   - Update section: Add "Performance & Caching Architecture" subsection after deployment section
   - Add: Caching strategy diagram, static generation flow, ISR explanation
   - Add: Link to performance runbook and reference guide
   - Reason: Performance is architectural concern; belongs in architecture documentation

2. **`docs/60-projects/portfolio-app/01-overview.md`** — Add performance summary
   - Update section: "Key Technical Achievements" section
   - Add: Performance optimization bullet points (static generation, caching, bundle optimization)
   - Add: Link to baseline metrics and Core Web Vitals targets
   - Reason: Performance is key capability; should be visible in overview

3. **`docs/60-projects/portfolio-app/06-operations.md`** — Add performance monitoring procedures
   - Update section: Add "Performance Monitoring" subsection
   - Add: Links to Vercel Analytics, bundle analyzer, Lighthouse CI
   - Add: Quick reference for performance triage
   - Reason: Performance monitoring is operational concern

4. **`docs/50-operations/runbooks/index.md`** — Add performance runbook entry
   - Update section: Add entry for `rbk-portfolio-performance-optimization.md`
   - Add: Brief description and link to runbook
   - Reason: All runbooks must be registered in index

5. **`docs/70-reference/index.md`** — Add performance guide entry
   - Update section: Add entry for `performance-optimization-guide.md`
   - Add: Brief description and link to guide
   - Reason: All reference docs must be registered in index

---

## Content Structure & Design

### Document 1: Performance Optimization Runbook

**Type:** Operational Runbook

**Template:** `template-runbook.md`

**Front Matter:**

```yaml
---
title: 'Runbook: Performance Optimization & Monitoring'
description: 'Procedures for analyzing performance, optimizing bundle size, investigating regressions, and monitoring Core Web Vitals in the Portfolio App.'
sidebar_position: 5
tags:
  [
    runbook,
    performance,
    optimization,
    monitoring,
    operations,
    phase-4,
    stage-4-2,
  ]
---
```

**Content Outline:**

#### Section 1: Purpose & Scope

**Purpose:** Operational guide for performance analysis, optimization, and regression investigation

**Scope:**
- Performance baseline metrics and targets
- Bundle size analysis and optimization
- Caching strategy verification
- Core Web Vitals monitoring
- Performance regression triage

#### Section 2: Performance Baseline & Targets

**Source of truth:** Baseline metrics live in [portfolio-app/docs/performance-baseline.md](portfolio-app/docs/performance-baseline.md); keep this docs copy concise and reference the app repo for detailed tables and thresholds.

**Baseline Metrics (as of Stage 4.2 completion):**

```markdown
Build Performance:
- Build Time: ___ seconds (target: <30s)
- First Load JS (Homepage): ___ KB (target: <100 KB)
- First Load JS (Project Page): ___ KB (target: <120 KB)
- Total Bundle Size: ___ KB

Runtime Performance (Production):
- Homepage LCP: ___ ms (target: <2500ms)
- Homepage FID: ___ ms (target: <100ms)
- Homepage CLS: ___ (target: <0.1)
- Project Page LCP: ___ ms (target: <2500ms)

Regression Thresholds:
- Bundle size increase >10%: Requires investigation and justification
- Build time increase >20%: Triggers warning
- LCP increase >500ms: Requires immediate investigation
- CLS increase >0.05: Requires immediate investigation
```

#### Section 3: Performance Analysis Procedures

**3.1 Bundle Analysis**

```bash
# Step 1: Generate bundle analysis report
cd portfolio-app
pnpm analyze:bundle

# Step 2: Review in browser
# Analyzer opens at http://localhost:8888
# Look for:
# - Unexpected dependencies
# - Duplicate packages
# - Large vendor chunks

# Step 3: Document findings
# Record largest packages, optimization opportunities
```

**3.2 Build Performance Analysis**

```bash
# Step 1: Clean build with timing
pnpm clean
time pnpm build

# Step 2: Review build output
# Look for:
# - Static routes (○ Static)
# - Server routes (λ Server)
# - First Load JS sizes

# Step 3: Compare against baseline
# Alert if build time >20% increase
```

**3.3 Runtime Performance Measurement**

```bash
# Option A: Lighthouse (Local)
# 1. Deploy to preview: git push origin feature-branch
# 2. Open preview URL in Chrome
# 3. DevTools → Lighthouse → Run audit
# 4. Record Performance score, LCP, FID, CLS

# Option B: Vercel Analytics (Production)
# 1. Navigate to Vercel Dashboard
# 2. Select portfolio-app project
# 3. Analytics tab → Core Web Vitals
# 4. Review P75 metrics over last 7 days
```

#### Section 4: Optimization Procedures

**4.1 Reduce Bundle Size**

- Identify large dependencies: Use bundle analyzer
- Check for duplicates: Look for multiple versions of same package
- Code split: Move large imports to dynamic import()
- Tree shake: Ensure imports use named exports, not namespace imports

**4.2 Improve Caching**

- Verify Cache-Control headers: `curl -I [URL] | grep Cache-Control`
- Check ISR revalidation: Monitor Vercel function logs
- Optimize static generation: Ensure all known routes use `generateStaticParams()`

**4.3 Image Optimization**

- Use Next.js Image component: Never use `<img>` directly
- Specify dimensions: Prevents CLS; enables optimization
- Lazy load below fold: Use `loading="lazy"` (default)
- Verify WebP format: Check Network tab for `image/webp` MIME type

#### Section 5: Performance Regression Triage

**Scenario 1: Bundle Size Increased >10%**

```markdown
Symptoms:
- CI check fails: "Bundle size increased by X%"
- First Load JS exceeds baseline + 10%

Diagnosis:
1. Run `pnpm analyze:bundle` on current branch
2. Run on main branch for comparison
3. Identify new/larger dependencies

Resolution:
- If intentional (new feature): Document in PR, update baseline
- If unintentional: Remove dependency or find lighter alternative
- If duplicate: Resolve version conflicts in pnpm-lock.yaml
```

**Scenario 2: Core Web Vitals Degraded**

```markdown
Symptoms:
- LCP increased >500ms from baseline
- CLS increased >0.05 from baseline
- Vercel Analytics shows red/orange metrics

Diagnosis:
1. Run Lighthouse on affected page
2. Identify specific element causing LCP/CLS issue
3. Check for recent layout changes, new images, or render-blocking resources

Resolution:
- LCP issue: Optimize largest contentful element (image compression, lazy load)
- CLS issue: Add explicit width/height to images/iframes; avoid layout shifts
- FID issue: Reduce JavaScript bundle size, optimize event handlers
```

#### Section 6: Monitoring & Alerts

**Tools:**
- Vercel Analytics: Real-time Core Web Vitals from production traffic
- Bundle Analyzer: Quarterly review of bundle composition
- CI Checks: Automated bundle size regression detection

**Alert Thresholds:**
- Bundle size increase >10%: CI fails, requires review
- LCP >2.5s (P75): Manual investigation recommended
- CLS >0.1 (P75): Manual investigation recommended

**Review Schedule:**
- Weekly: Check Vercel Analytics dashboard for trends
- Monthly: Review bundle analyzer for optimization opportunities
- Quarterly: Comprehensive performance audit (Lighthouse, full analysis)

---

### Document 2: Performance Optimization Reference Guide

**Type:** Reference Guide

**Template:** Custom (comprehensive reference format)

**Front Matter:**

```yaml
---
title: 'Performance Optimization Guide'
description: 'Comprehensive reference for Next.js performance patterns, caching strategies, static generation, and optimization techniques used in the Portfolio App.'
sidebar_position: 8
tags: [reference, performance, optimization, nextjs, caching, ssr, ssg, isr]
---
```

**Content Outline:**

#### Section 1: Purpose & Audience

**Purpose:** Developer reference for implementing performant features in Next.js

**Prerequisite knowledge:**
- Next.js App Router fundamentals
- React Server Components
- HTTP caching basics

**Use cases:**
- Implementing new routes with optimal caching
- Optimizing existing pages for performance
- Troubleshooting performance regressions

#### Section 2: Caching Strategies

**2.1 Static Generation (SSG)**

```typescript
// Full static generation (no revalidation)
export const revalidate = false; // Cache forever

// Use for:
// - Content that rarely changes (/, /cv, /contact)
// - No user-specific data
// - Known routes at build time

// Example:
// src/app/cv/page.tsx
export const revalidate = false;
```

**2.2 Incremental Static Regeneration (ISR)**

```typescript
// ISR with 1-hour revalidation
export const revalidate = 3600; // Revalidate every hour

// Use for:
// - Content that updates occasionally (project pages)
// - SEO-critical pages that need to stay fresh
// - Dynamic content with acceptable staleness

// Example:
// src/app/projects/[slug]/page.tsx
export const revalidate = 3600;
export async function generateStaticParams() {
  return PROJECTS.map((p) => ({ slug: p.slug }));
}
```

**2.3 Server-Side Rendering (SSR)**

```typescript
// Dynamic rendering (no caching)
export const revalidate = 0; // Always fresh

// Use for:
// - User-specific content
// - Real-time data (health checks, metrics)
// - Content that must be current

// Example:
// src/app/api/health/route.ts
export const revalidate = 0;
```

#### Section 3: Image Optimization Best Practices

**3.1 Use Next.js Image Component**

```tsx
import Image from 'next/image';

// Good: Automatic optimization
<Image
  src="/path/to/image.jpg"
  alt="Description"
  width={800}
  height={600}
  loading="lazy"
/>

// Bad: No optimization
<img src="/path/to/image.jpg" alt="Description" />
```

**3.2 Responsive Images**

```tsx
// Responsive with multiple sizes
<Image
  src="/hero.jpg"
  alt="Hero"
  fill
  sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
/>
```

#### Section 4: Bundle Optimization Techniques

**4.1 Dynamic Imports**

```typescript
// Good: Code splitting for large components
const HeavyComponent = dynamic(() => import('@/components/HeavyComponent'), {
  loading: () => <p>Loading...</p>,
});

// Bad: Large component in initial bundle
import HeavyComponent from '@/components/HeavyComponent';
```

**4.2 Tree Shaking**

```typescript
// Good: Named imports (tree-shakeable)
import { specific, functions } from 'library';

// Bad: Namespace import (entire library bundled)
import * as library from 'library';
```

#### Section 5: Performance Debugging Checklist

- [ ] Run Lighthouse audit on affected page
- [ ] Check Network tab for large resources (>100 KB)
- [ ] Verify Cache-Control headers are correct
- [ ] Check for render-blocking resources
- [ ] Review bundle analyzer for unexpected dependencies
- [ ] Validate images use Next.js Image component
- [ ] Confirm static generation for known routes
- [ ] Check for unnecessary JavaScript in initial load

---

## Implementation Tasks

### Phase 1: Create Performance Runbook (1–1.5 hours)

#### Tasks

- [ ] **Create `docs/50-operations/runbooks/rbk-portfolio-performance-optimization.md`**
  - Details: Follow runbook template structure
  - Include: Baseline metrics (populate from Stage 4.2 app implementation)
  - Include: Bundle analysis procedures with screenshots
  - Include: Regression triage scenarios with step-by-step resolution
  - Files: New runbook file

- [ ] **Update `docs/50-operations/runbooks/index.md`**
  - Details: Add entry for performance runbook
  - Link: `[Performance Optimization & Monitoring](rbk-portfolio-performance-optimization.md)`
  - Files: Runbook index

#### Success Criteria for This Phase

- [ ] Runbook includes all sections from content outline
- [ ] Baseline metrics are populated with actual values
- [ ] Bundle analysis procedures are step-by-step executable
- [ ] Runbook index includes new entry

---

### Phase 2: Create Performance Reference Guide (1–1.5 hours)

#### Tasks

- [ ] **Create `docs/70-reference/performance-optimization-guide.md`**
  - Details: Comprehensive reference with code examples
  - Include: All caching strategies (SSG, ISR, SSR)
  - Include: Image optimization examples
  - Include: Bundle optimization techniques
  - Include: Performance debugging checklist
  - Files: New reference guide

- [ ] **Update `docs/70-reference/index.md`**
  - Details: Add entry for performance guide
  - Link: `[Performance Optimization Guide](performance-optimization-guide.md)`
  - Files: Reference index

#### Success Criteria for This Phase

- [ ] Reference guide includes all sections from content outline
- [ ] All code examples are syntactically correct TypeScript/TSX
- [ ] Examples reference actual Portfolio App patterns
- [ ] Reference index includes new entry

---

### Phase 3: Update Portfolio App Dossier (30 minutes)

#### Tasks

- [ ] **Update `docs/60-projects/portfolio-app/02-architecture.md`**
  - Details: Add "Performance & Caching Architecture" section
  - Include: Caching strategy diagram (copy from Stage 4.2 app issue)
  - Include: Static generation flow explanation
  - Include: Links to runbook and reference guide
  - Files: Architecture dossier page

- [ ] **Update `docs/60-projects/portfolio-app/01-overview.md`**
  - Details: Add performance achievements to "Key Technical Achievements"
  - Add bullets: Static generation, ISR, bundle optimization, Core Web Vitals
  - Include: Link to baseline metrics in runbook
  - Files: Overview dossier page

- [ ] **Update `docs/60-projects/portfolio-app/06-operations.md`**
  - Details: Add "Performance Monitoring" subsection
  - Include: Links to Vercel Analytics, bundle analyzer
  - Include: Quick reference for performance triage
  - Files: Operations dossier page

#### Success Criteria for This Phase

- [ ] All three dossier pages updated with performance content
- [ ] Internal links to runbook and reference guide are correct
- [ ] Performance achievements are visible in overview
- [ ] Operations page includes monitoring procedures

---

## Acceptance Criteria

This stage is complete when:

- [ ] Performance optimization runbook created with all sections complete
- [ ] Performance reference guide created with code examples and best practices
- [ ] Baseline performance metrics documented in runbook (populated from app implementation)
- [ ] Portfolio-app dossier updated with performance architecture section
- [ ] Operations dossier includes performance monitoring procedures
- [ ] All internal links verified working (runbook ↔ reference ↔ dossier)
- [ ] All new docs follow style guide (front matter, headings, code formatting)
- [ ] All new docs added to appropriate index pages (runbooks/index.md, reference/index.md)
- [ ] Docs build succeeds: `pnpm build` (in portfolio-docs repo)
- [ ] No broken links: Link validation passes
- [ ] PR created with title: `docs: Stage 4.2 - Performance architecture and runbooks`

---

## Code Quality Standards

All documentation must meet:

- **Style Guide Compliance:** Follow `docs/_meta/doc-style-guide.md`
- **Front Matter:** All required fields (title, description, sidebar_position, tags)
- **Markdown Formatting:** Consistent heading levels, code blocks with language tags
- **Code Examples:** Syntactically correct, runnable TypeScript/TSX
- **Internal Links:** Use relative paths, verify all links resolve
- **Taxonomy:** Use approved tags from `docs/_meta/taxonomy-and-tagging.md`

---

## Related Documentation

- [Stage 4.2 App Issue](stage-4-2-app-issue.md) — Portfolio App performance implementation
- [Phase 4 Implementation Guide](../phase-4-implementation-guide.md) — Stage 4.2 section
- [ADR-0013: Multi-Environment Deployment](../../10-architecture/adr/adr-0013-multi-environment-deployment.md) — Environment context for performance testing
- [Doc Style Guide](../../_meta/doc-style-guide.md) — Documentation standards

---

## Notes & Assumptions

- **Assumption:** Baseline metrics will be populated during Stage 4.2 app implementation
  - Runbook includes placeholders (___) for values to be filled in after build
- **Assumption:** Vercel Analytics provides sufficient granularity for performance monitoring
  - If more detailed metrics needed, reference guide can be extended with custom instrumentation
- **Assumption:** Performance optimization is iterative; runbook and guide will evolve
  - Both documents should be treated as living documentation; update as patterns emerge
