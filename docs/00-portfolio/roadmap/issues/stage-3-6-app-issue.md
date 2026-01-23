---
title: 'Stage 3.6 — Analytics & Social Metadata (App)'
description: 'Add Open Graph and Twitter Card metadata for social sharing; integrate Vercel Web Analytics for privacy-safe page view tracking.'
tags:
  [portfolio, roadmap, planning, phase-3, stage-3.6, app, metadata, analytics]
---

# Stage 3.6: Analytics & Social Metadata — App Implementation

**Type:** Feature / Enhancement  
**Phase:** Phase 3 — Scaling & Governance  
**Stage:** 3.6  
**Linked Issue:** [Stage 3.6 Docs Issue](./stage-3-6-docs-issue.md)  
**Duration Estimate:** 1.5–2 hours  
**Assignee:** Developer

---

## Overview

Stage 3.6 enhances the portfolio's social sharing capabilities and adds privacy-safe analytics. Implements dynamic Open Graph and Twitter Card metadata for projects, generates social preview images, and optionally integrates Vercel Web Analytics for aggregate page view tracking without collecting PII. This improves discoverability, professional presentation on social platforms, and provides lightweight usage insights.

## Objectives

- Add dynamic Open Graph metadata for project pages
- Implement Twitter Card configuration for social sharing
- Generate or configure social preview images
- Integrate privacy-safe analytics (Vercel Web Analytics or Plausible)
- Document privacy implications and data collection practices

---

## Scope

### Files to Create

1. **`src/app/opengraph-image.tsx`** (optional) — Dynamic Open Graph image generation
   - Renders portfolio branding for default OG image
   - Uses Next.js Image API for optimization

2. **`src/app/projects/[slug]/opengraph-image.tsx`** (optional) — Per-project OG image
   - Dynamically generates preview with project title, tech stack
   - Branded with portfolio identity

### Files to Update

1. **`src/app/layout.tsx`** — Global metadata configuration
   - Add default Open Graph metadata
   - Configure Twitter Card defaults
   - Add Vercel Analytics component (if using)

2. **`src/app/projects/[slug]/page.tsx`** — Project-specific metadata
   - Generate dynamic metadata per project
   - Include project title, description, tech stack in OG tags
   - Configure Twitter Card with project details

3. **`next.config.ts`** — Image domain configuration (if using external images)
   - Add allowed domains for social preview images

4. **`package.json`** — Add analytics dependency (if not using Vercel)
   - Add dependency: `@vercel/analytics` or `plausible-tracker`

5. **`.env.example`** — Document analytics configuration
   - Add `NEXT_PUBLIC_VERCEL_ANALYTICS_ID` (if applicable)
   - Add `NEXT_PUBLIC_PLAUSIBLE_DOMAIN` (if using Plausible)

### Dependencies to Add

- `@vercel/analytics` (if using Vercel Web Analytics) — Privacy-safe analytics from Vercel
- `plausible-tracker` (alternative) — Self-hosted privacy-focused analytics

---

## Design & Architecture

### System Overview

```
Social Metadata Flow:
┌─────────────────┐
│  layout.tsx     │ → Default OG + Twitter metadata
└─────────────────┘
         │
         ▼
┌─────────────────┐
│ [slug]/page.tsx │ → Dynamic project metadata
└─────────────────┘
         │
         ▼
┌─────────────────┐
│ OG Image API    │ → Optional: Dynamic image generation
└─────────────────┘

Analytics Flow:
┌─────────────────┐
│  layout.tsx     │ → <Analytics /> component
└─────────────────┘
         │
         ▼
┌─────────────────┐
│ Vercel/Plausible│ → Aggregate page views (no PII)
└─────────────────┘
```

### Metadata Schema

```typescript
// Open Graph metadata structure
interface ProjectMetadata {
  title: string;
  description: string;
  openGraph: {
    title: string;
    description: string;
    type: 'website';
    url: string;
    images: Array<{
      url: string;
      width: number;
      height: number;
      alt: string;
    }>;
  };
  twitter: {
    card: 'summary_large_image';
    title: string;
    description: string;
    images: string[];
  };
}
```

### Key Design Decisions

1. **Decision: Use Vercel Web Analytics over Google Analytics**
   - Rationale: Privacy-safe, no cookies, GDPR-compliant, simple integration
   - Alternative considered: Google Analytics (rejected: PII concerns, cookie consent complexity)

2. **Decision: Generate dynamic OG images with Next.js API**
   - Rationale: Branded, consistent, automatic per-project customization
   - Alternative considered: Static images (rejected: maintenance burden for each project)

3. **Decision: Use summary_large_image Twitter Card**
   - Rationale: Best visual presentation for project showcases
   - Alternative considered: summary card (rejected: less engaging visual)

### API / Function Signatures

```typescript
// Dynamic metadata generation for project pages
export async function generateMetadata({
  params,
}: {
  params: { slug: string };
}): Promise<Metadata> {
  const project = getProjectBySlug(params.slug);

  return {
    title: project.title,
    description: project.summary,
    openGraph: {
      title: project.title,
      description: project.summary,
      type: 'website',
      url: `${process.env.NEXT_PUBLIC_SITE_URL}/projects/${params.slug}`,
      images: [
        {
          url: `/api/og?title=${encodeURIComponent(project.title)}`,
          width: 1200,
          height: 630,
          alt: project.title,
        },
      ],
    },
    twitter: {
      card: 'summary_large_image',
      title: project.title,
      description: project.summary,
    },
  };
}
```

---

## Validation Rules & Constraints

1. **Open Graph Image Size:** `1200x630` pixels (recommended by Facebook/LinkedIn)
   - Example valid: Image with exact dimensions or responsive scaling
   - Constraint: Must be hosted on HTTPS domain
   - Error handling: Fallback to default OG image if generation fails

2. **Twitter Card Type:** `summary_large_image` for projects, `summary` for other pages
   - Enforcement: Set in metadata object per page
   - Error message: N/A (build-time validation)

3. **Analytics Privacy:** No PII collection, aggregate data only
   - Enforcement: Use privacy-safe analytics providers only
   - Documentation: Privacy policy must disclose analytics usage

---

## Implementation Tasks

### Phase 1: Open Graph Metadata (0.5–1 hour)

Add dynamic Open Graph metadata for project pages

#### Tasks

- [ ] Update `src/app/layout.tsx` with default OG metadata
  - Details: Add site-wide defaults (title, description, image, URL)
  - Files: `src/app/layout.tsx`

- [ ] Update `src/app/projects/[slug]/page.tsx` with dynamic metadata
  - Details: Implement `generateMetadata` function using registry data
  - Files: `src/app/projects/[slug]/page.tsx`
  - Code example:
    ```typescript
    export async function generateMetadata({
      params,
    }: {
      params: { slug: string };
    }): Promise<Metadata> {
      const project = getProjectBySlug(params.slug);
      return {
        title: project.title,
        description: project.summary,
        openGraph: {
          title: project.title,
          description: project.summary,
          type: 'website',
          url: `${process.env.NEXT_PUBLIC_SITE_URL}/projects/${params.slug}`,
          images: [`${process.env.NEXT_PUBLIC_SITE_URL}/og-image.png`],
        },
      };
    }
    ```

- [ ] Add Twitter Card metadata
  - Details: Add twitter.card, twitter.title, twitter.description
  - Files: `src/app/layout.tsx`, `src/app/projects/[slug]/page.tsx`

- [ ] Test metadata with Twitter Card Validator and Facebook Sharing Debugger
  - Details: Verify OG tags render correctly
  - URLs: https://cards-dev.twitter.com/validator, https://developers.facebook.com/tools/debug/

#### Success Criteria for This Phase

- [ ] Default OG metadata present on all pages
- [ ] Project pages have unique OG metadata with project details
- [ ] Twitter Card validator shows correct preview
- [ ] Facebook Sharing Debugger shows correct preview

---

### Phase 2: Analytics Integration (0.5–1 hour)

Add privacy-safe analytics with Vercel Web Analytics

#### Tasks

- [ ] Install Vercel Analytics package
  - Details: `pnpm add @vercel/analytics`
  - Files: `package.json`

- [ ] Add Analytics component to root layout
  - Details: Import and render `<Analytics />` in layout.tsx
  - Files: `src/app/layout.tsx`
  - Code example:

    ```typescript
    import { Analytics } from '@vercel/analytics/react';

    export default function RootLayout({ children }: { children: React.ReactNode }) {
      return (
        <html lang="en">
          <body>
            {children}
            <Analytics />
          </body>
        </html>
      );
    }
    ```

- [ ] Document analytics in .env.example (if configuration needed)
  - Details: Add NEXT_PUBLIC_VERCEL_ANALYTICS_ID if required
  - Files: `.env.example`

- [ ] Test analytics tracking in Vercel dashboard
  - Details: Deploy to Vercel, verify page views are tracked
  - Dependencies: Requires Vercel deployment

#### Success Criteria for This Phase

- [ ] Analytics component integrated without errors
- [ ] Page views tracked in Vercel Analytics dashboard
- [ ] No PII collected (confirmed in privacy settings)

---

## Testing Strategy

### Unit Tests

- [ ] Metadata generation tests
  - Location: `src/app/projects/[slug]/__tests__/metadata.test.ts`
  - Coverage: Verify generateMetadata returns correct structure for all projects

### Integration Tests

- [ ] OG metadata rendering tests
  - Scenario: Verify OG tags present in HTML head
  - Expected: meta tags with correct property and content attributes

### E2E / Manual Testing

- [ ] Social sharing validation
  - Steps:
    1. Deploy to Vercel
    2. Share project URL on Twitter
    3. Share project URL on LinkedIn
    4. Verify preview card displays correctly
  - Expected result: Rich preview with project title, description, and image

- [ ] Analytics tracking verification
  - Steps:
    1. Visit portfolio app in incognito mode
    2. Navigate to 2–3 project pages
    3. Check Vercel Analytics dashboard
  - Expected result: Page views recorded without identifying user

### Test Commands

```bash
# Unit tests for metadata
pnpm test -- metadata

# Build verification
pnpm build

# Type checking
pnpm typecheck

# Local verification (recommended before PR)
pnpm verify
```

---

## Acceptance Criteria

This stage is complete when:

- [ ] All project pages have dynamic Open Graph metadata
- [ ] Twitter Card previews render correctly for shared links
- [ ] LinkedIn/Facebook previews render correctly for shared links
- [ ] Vercel Web Analytics integrated and tracking page views
- [ ] No PII collected (aggregate data only)
- [ ] Privacy implications documented
- [ ] `pnpm verify` passes (lint, format, typecheck, build all succeed)
- [ ] No TypeScript errors: `pnpm typecheck`
- [ ] No ESLint violations: `pnpm lint`
- [ ] Code is formatted: `pnpm format:check`
- [ ] Production build succeeds: `pnpm build`
- [ ] Social preview tested on Twitter, LinkedIn, Facebook

---

## Code Quality Standards

All code must meet:

- **TypeScript:** Strict mode enabled; no `any` types unless documented
- **Linting:** ESLint with Next.js preset; max-warnings=0
- **Formatting:** Prettier; single quotes, semicolons, 2-space indent
- **Documentation:** Metadata structure documented; privacy policy updated
- **Testing:** Metadata generation tested; social sharing validated
- **Security:** No API keys in client code; analytics privacy-safe

---

## Deployment & CI/CD

### CI Pipeline Integration

- [ ] No new CI steps required (metadata is build-time)
- [ ] Analytics tested in Vercel preview deployments

### Environment Variables / Configuration

```env
# Add to .env.local for local development (optional, Vercel auto-injects)
NEXT_PUBLIC_VERCEL_ANALYTICS_ID=optional-if-manual-config

# Site URL for OG metadata
NEXT_PUBLIC_SITE_URL=https://portfolio.example.com
```

Documentation: See `.env.example` for complete list.

### Rollback Plan

- Quick rollback: Remove `<Analytics />` component from layout.tsx
- Metadata rollback: Revert metadata changes in layout.tsx and [slug]/page.tsx
- No data migration concerns (analytics is non-invasive)

---

## Dependencies & Blocking

### Depends On

- [ ] Stage 3.1 complete (registry data for metadata)
- [ ] Vercel deployment active (for analytics)

### Blocks

- [ ] None (Stage 3.6 is final stage in Phase 3)

### Related Work

- Related issue: Stage 3.6 Docs Issue (privacy policy update, analytics documentation)
- Related documentation: Portfolio App dossier deployment page (analytics section)

---

## Performance & Optimization Considerations

**Performance:**

- Metadata generation is build-time (no runtime cost)
- Analytics script is lightweight (~1KB)
- OG images can be generated dynamically or pre-rendered for performance

**Optimization:**

- Use Next.js Image component for OG image optimization
- Consider static OG images if dynamic generation adds build time
- Vercel Analytics has negligible performance impact (edge-based)
