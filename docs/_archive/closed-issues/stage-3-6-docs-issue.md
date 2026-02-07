---
title: 'Stage 3.6 — Analytics & Social Metadata (Docs)'
description: 'Create social metadata guide; document analytics operations, privacy stance, and Stage 3.6 deliverables in dossier and runbooks.'
tags:
  [portfolio, roadmap, planning, phase-3, stage-3.6, docs, reference, analytics]
---

> **Archive notice:** Archived 2026-02-06. This issue is retained for historical traceability only.
> See release note: /docs/00-portfolio/release-notes/20260206-portfolio-roadmap-issues-archived.md

# Stage 3.6: Analytics & Social Metadata — Documentation

**Type:** Documentation / Reference  
**Phase:** Phase 3 — Scaling & Governance  
**Stage:** 3.6  
**Linked Issue:** [Stage 3.6 App Issue](./stage-3-6-app-issue.md)  
**Duration Estimate:** 0.5–1 hour  
**Assignee:** Technical Writer

---

## Overview

Stage 3.6 documentation captures the decisions and operational guidance for social sharing optimization and privacy-safe analytics. Documents Open Graph and Twitter Card implementation, analytics provider selection rationale, privacy implications, and troubleshooting for social preview issues. Ensures compliance transparency and provides future reference for analytics data interpretation.

## Objectives

- Document social metadata implementation and best practices
- Record analytics provider decision and privacy considerations
- Update privacy policy or create privacy notice for analytics
- Provide troubleshooting guide for social sharing issues
- Update Portfolio App dossier with Stage 3.6 enhancements

---

## Scope

### Files to Create

1. **`docs/70-reference/social-metadata-guide.md`** — Social sharing best practices
   - Type: Reference Guide
   - Audience: Developers adding new project pages
   - Purpose: Explain Open Graph and Twitter Card configuration patterns

### Files to Update

1. **`docs/60-projects/portfolio-app/06-operations.md`** — Analytics operations
   - Update section: Monitoring and observability
   - Reason: Document analytics dashboard access and interpretation

2. **`docs/60-projects/portfolio-app/05-deployment.md`** — Deployment considerations
   - Update section: Environment variables
   - Reason: Add NEXT_PUBLIC_SITE_URL and analytics configuration

3. **`docs/60-projects/portfolio-app/index.md`** — Portfolio App dossier overview
   - Update section: Current State (Phase 3)
   - Reason: Add Stage 3.6 deliverables (social metadata, analytics)

4. **`docs/60-projects/portfolio-app/08-security.md`** — Privacy and data handling
   - Update section: Data collection and privacy
   - Reason: Document analytics privacy stance and GDPR compliance

5. **`docs/00-portfolio/roadmap/phase-3-implementation-guide.md`** — Mark Stage 3.6 complete
   - Update section: Stage 3.6 Checklist
   - Reason: Track completion of final Phase 3 stage

---

## Content Structure & Design

### Document Type & Template

**Type:** Reference Guide

**Template:** Reference material format from `docs/_meta/templates/template-phase-stage-docs-issue.md`

**Front Matter:**

```yaml
---
title: 'Social Metadata Guide'
description: 'Best practices for Open Graph and Twitter Card configuration in portfolio projects'
sidebar_position: 11
tags: ['reference', 'social-metadata', 'open-graph', 'twitter-cards', 'seo']
---
```

### Content Outline

#### Section 1: Open Graph Metadata

**Purpose:** Explain Open Graph protocol and implementation

**Key topics to cover:**

- What is Open Graph and why it matters
- Required vs optional OG tags
- Image size recommendations (1200x630)
- Dynamic metadata generation patterns

**Examples to include:**

- Example 1: Default site-wide OG metadata in layout.tsx
- Example 2: Dynamic project-specific metadata in [slug]/page.tsx
- Example 3: Metadata validation with Facebook Sharing Debugger

#### Section 2: Twitter Cards

**Purpose:** Document Twitter Card types and usage

**Key topics to cover:**

- Twitter Card types (summary vs summary_large_image)
- When to use each card type
- Testing with Twitter Card Validator

**Examples to include:**

- Example 1: Twitter Card metadata structure
- Example 2: Validation workflow

#### Section 3: Analytics & Privacy

**Purpose:** Document analytics implementation and privacy considerations

**Key topics to cover:**

- Why Vercel Web Analytics was chosen
- Privacy-safe analytics principles (no PII, no cookies)
- GDPR compliance
- Data retention and deletion policies

**Examples to include:**

- Example 1: Analytics component integration
- Example 2: Privacy policy language for analytics disclosure

### Code Examples & Diagrams

- Example 1: Metadata generation function

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
        /* ... */
      },
      twitter: {
        /* ... */
      },
    };
  }
  ```

- Example 2: Analytics component

  ```typescript
  import { Analytics } from '@vercel/analytics/react';

  export default function RootLayout({ children }: { children: React.ReactNode }) {
    return (
      <html>
        <body>
          {children}
          <Analytics />
        </body>
      </html>
    );
  }
  ```

- Diagram 1: Social sharing flow
  ```mermaid
  flowchart LR
    A[User shares link] --> B{Platform detects URL}
    B --> C[Fetches OG metadata]
    C --> D[Renders preview card]
    D --> E[User sees rich preview]
  ```

---

## Reference Material Documentation (if Guide/Reference)

### Purpose & Audience

- **Audience:** Developers adding new pages or projects to portfolio
- **Prerequisite knowledge:** Basic understanding of HTML meta tags
- **Use case:** When configuring social sharing for new content

### Key Concepts

1. **Open Graph Protocol:** Facebook-originated standard for rich social previews, adopted by LinkedIn and other platforms
2. **Twitter Cards:** Twitter's metadata format for enhanced link previews
3. **Privacy-Safe Analytics:** Analytics that collect aggregate data without tracking individuals or using cookies

### Complete Reference

- **og:title:** Page title for social sharing (50–60 characters recommended)
- **og:description:** Page description (150–160 characters recommended)
- **og:image:** Preview image URL (1200x630 pixels recommended)
- **og:url:** Canonical URL of the page
- **twitter:card:** Type of Twitter Card (summary, summary_large_image, app, player)
- **twitter:title:** Twitter-specific title (falls back to og:title)
- **twitter:description:** Twitter-specific description (falls back to og:description)

### Usage Examples

**Example 1: Site-wide defaults**

```typescript
// src/app/layout.tsx
export const metadata: Metadata = {
  title: {
    default: 'Portfolio - Developer Name',
    template: '%s | Portfolio',
  },
  description:
    'Full-stack developer specializing in TypeScript, React, and cloud architecture',
  openGraph: {
    type: 'website',
    locale: 'en_US',
    url: process.env.NEXT_PUBLIC_SITE_URL,
    siteName: 'Developer Portfolio',
    images: [
      {
        url: `${process.env.NEXT_PUBLIC_SITE_URL}/og-default.png`,
        width: 1200,
        height: 630,
        alt: 'Developer Portfolio',
      },
    ],
  },
};
```

**Example 2: Project-specific metadata**

```typescript
// src/app/projects/[slug]/page.tsx
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
          url: `${process.env.NEXT_PUBLIC_SITE_URL}/api/og?title=${encodeURIComponent(project.title)}`,
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

### Best Practices

- **Use 1200x630 images:** Optimal size for all platforms (Facebook, LinkedIn, Twitter)
- **Test before sharing:** Validate with Twitter Card Validator and Facebook Sharing Debugger
- **Avoid generic images:** Use project-specific or branded images for better engagement
- **Keep descriptions concise:** 150–160 characters for optimal display

### Troubleshooting

**Issue: Social preview not updating after changes**

- **Cause:** Platform caches are not invalidated
- **Solution:**
  1. Use Facebook Sharing Debugger: https://developers.facebook.com/tools/debug/ and click "Scrape Again"
  2. Use Twitter Card Validator: https://cards-dev.twitter.com/validator
  3. Add cache-busting query parameter to OG image URL (e.g., `?v=2`)

**Issue: Image not displaying in preview**

- **Cause:** Image URL is relative or not HTTPS
- **Solution:** Use absolute HTTPS URLs for all og:image values

**Issue: Description truncated**

- **Cause:** Description exceeds platform limits
- **Solution:** Keep descriptions under 160 characters for best results

---

## Integration with Existing Docs

### Cross-References

- **Links to:** Portfolio App dossier (operations, deployment, security pages)
- **Referenced by:** Phase 3 Implementation Guide (Stage 3.6 completion)
- **Update required in:**
  - `docs/60-projects/portfolio-app/index.md` (add Stage 3.6 to current state)
  - `docs/00-portfolio/roadmap/phase-3-implementation-guide.md` (mark complete)

### Updates to Existing Pages

1. **Page: `docs/60-projects/portfolio-app/06-operations.md`**
   - Update section: "Monitoring and Observability"
   - Add subsection: "Analytics Dashboard"
   - Content: Link to Vercel Analytics dashboard, explain page view metrics
   - Reason: Operational guidance for monitoring usage

2. **Page: `docs/60-projects/portfolio-app/08-security.md`**
   - Update section: "Data Collection and Privacy"
   - Add subsection: "Analytics Privacy Stance"
   - Content: Document Vercel Web Analytics privacy features (no cookies, no PII, GDPR-compliant)
   - Reason: Transparency for portfolio reviewers and compliance

3. **Page: `docs/60-projects/portfolio-app/index.md`**
   - Update section: "Current State (Phase 3 — Stage 3.6)"
   - Add bullets: Social metadata (Open Graph, Twitter Cards), Privacy-safe analytics (Vercel Web Analytics)
   - Reason: Keep dossier current with latest features

---

## Implementation Tasks

### Phase 1: Social Metadata Guide (0.25–0.5 hour)

Create comprehensive reference guide for social metadata

#### Tasks

- [x] Create `docs/70-reference/social-metadata-guide.md`
  - Details: Write sections for Open Graph, Twitter Cards, best practices
  - Sources: Open Graph protocol docs, Twitter developer docs, Next.js metadata docs

- [x] Add code examples for metadata generation
  - File: `docs/70-reference/social-metadata-guide.md`
  - Outline complete: Site-wide defaults, project-specific, validation examples

- [x] Add troubleshooting section
  - Details: Common issues (cache, HTTPS, truncation) with solutions
  - File: `docs/70-reference/social-metadata-guide.md`

#### Success Criteria for This Phase

- [x] Social Metadata Guide published with complete reference
- [x] Code examples are copy/paste safe
- [x] Troubleshooting covers 3+ common issues

---

### Phase 2: Dossier and Policy Updates (0.25–0.5 hour)

Update Portfolio App dossier and privacy documentation

#### Tasks

- [x] Update `docs/60-projects/portfolio-app/06-operations.md`
  - Details: Add "Analytics Dashboard" subsection under monitoring
  - Content: Link to Vercel Analytics, explain metrics interpretation

- [x] Update `docs/60-projects/portfolio-app/08-security.md`
  - Details: Add "Analytics Privacy Stance" subsection
  - Content: Document privacy-safe analytics approach, GDPR compliance

- [x] Update `docs/60-projects/portfolio-app/index.md`
  - Details: Add Stage 3.6 deliverables to "Current State" section
  - Content: Social metadata, privacy-safe analytics

- [x] Update `docs/00-portfolio/roadmap/phase-3-implementation-guide.md`
  - Details: Mark Stage 3.6 checklist items complete
  - Content: Check off all Stage 3.6 tasks

#### Success Criteria for This Phase

- [x] Operations page documents analytics access
- [x] Security page documents privacy stance
- [x] Dossier index reflects Stage 3.6 completion
- [x] Phase 3 guide shows Stage 3.6 complete

---

## Acceptance Criteria

This stage is complete when:

- [x] Social Metadata Guide published at `docs/70-reference/social-metadata-guide.md`
- [x] Portfolio App dossier updated with Stage 3.6 context (operations, security, index)
- [x] Privacy documentation updated with analytics disclosure
- [x] Phase 3 Implementation Guide marked Stage 3.6 complete
- [x] All cross-references added to related pages
- [x] Documentation builds successfully: `pnpm build`
- [x] No broken links: Docusaurus broken link checker passes
- [x] Meets doc style guide standards (front matter, structure, tags)

---

## Quality Checklist

- [x] Front matter complete (title, description, sidebar_position, tags)
- [x] Uses standard page structure for reference guide
- [x] Code examples are syntax-highlighted and copy/paste safe
- [x] All external links are valid (Open Graph docs, Twitter docs, validator tools)
- [x] Mermaid diagrams render correctly
- [x] Cross-references use correct paths (include section numbers, .md extension)
- [x] Follows Docusaurus conventions (admonitions, code blocks, etc.)
