---
title: 'ADR 0015: Open Graph + Twitter Cards + JSON-LD Metadata Strategy'
description: 'Decision to use tri-layer metadata approach (OG/Twitter/JSON-LD) for rich social previews and search engine understanding.'
sidebar_position: 15
tags: [adr, seo, metadata, open-graph, structured-data]
---

# ADR 0015: Open Graph + Twitter Cards + JSON-LD Metadata Strategy

**Date:** January 2026

**Status:** Accepted

**Context:** Portfolio needs to show rich previews when shared on social media and appear with enhanced results in search engines.

---

## Problem

Need metadata strategy that:

- Generates attractive social media previews (Facebook, LinkedIn, Twitter, Discord)
- Enables rich search results (Google Knowledge Graph)
- Works across different platforms (each has different requirements)
- Maintains consistency with content
- Supports future content expansion (blog, case studies)

---

## Options Considered

### Option A: Keywords + Meta Description Only

**Approach:** Traditional SEO - just title, description, and keyword tags

**Pros:**

- Simple, minimal code
- Historical SEO standard
- Good for basic text ranking

**Cons:**

- No social media previews
- No structured understanding by search engines
- Plain text results only
- Missing competitive advantage

**Verdict:** ❌ Rejected - insufficient for modern portfolio

### Option B: Open Graph Only

**Approach:** Use OG tags for all metadata and social previews

```html
<meta property="og:title" content="..." />
<meta property="og:description" content="..." />
<meta property="og:image" content="..." />
```

**Pros:**

- Single source of truth
- Works across platforms
- Good social previews

**Cons:**

- Twitter requires different card tag format
- Search engines need JSON-LD for structured understanding
- No semantic markup for machines
- Incomplete solution

**Verdict:** ❌ Rejected - incomplete, requires supplementary approaches

### Option C: JSON-LD Only

**Approach:** Structured data only, rely on search engines to extract

**Pros:**

- Semantic markup
- Supports rich results
- Extensible schema

**Cons:**

- No social media preview control
- Requires search engine parsing
- Not used by social media platforms
- Incomplete solution

**Verdict:** ❌ Rejected - doesn't cover social sharing

### Option D: Tri-Layer Strategy (OG + Twitter + JSON-LD) ✅

**Approach:** Use all three in complementary roles:

- **Open Graph:** Social media preview defaults
- **Twitter Cards:** Twitter-specific enhancements
- **JSON-LD:** Machine-readable structured data

**Pros:**

- Maximum reach (every platform supported)
- Better social previews than OG alone
- Structured data for search engines
- Extensible for future content
- Best practice across industry

**Cons:**

- More metadata tags in HTML
- Requires coordination between layers
- Maintenance burden if content changes

**Verdict:** ✅ **Selected** - comprehensive solution with maximum coverage

---

## Decision

**Implement tri-layer metadata strategy:**

### Layer 1: Open Graph (Social Media Defaults)

**Purpose:** Fallback for all social platforms when platform-specific tags missing

**Implementation:**

```typescript
{
  openGraph: {
    type: "website",
    locale: "en_US",
    url: "https://portfolio.com/projects/portfolio-app",
    siteName: "Portfolio",
    title: "Portfolio App",
    description: "Enterprise Next.js 16 application with dark mode and SEO optimization",
    images: [
      {
        url: "/og-image.png",
        width: 1200,
        height: 630,
      },
    ],
  },
}
```

**Coverage:** Facebook, LinkedIn, Discord, Slack (when no specific card)

### Layer 2: Twitter Cards (Twitter-Specific)

**Purpose:** Optimized preview for Twitter/X with custom card format

**Implementation:**

```typescript
{
  twitter: {
    card: "summary_large_image",
    title: "Portfolio App",
    description: "Enterprise Next.js 16 application...",
    creator: "@yourname",  // Optional
    images: ["/og-image.png"],
  },
}
```

**Coverage:** Twitter/X with `summary_large_image` card format

### Layer 3: JSON-LD (Machine-Readable Structure)

**Purpose:** Enable rich results and structured understanding

**Implementation:**

```html
<script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "Person",
    "name": "Your Name",
    "url": "https://portfolio.com",
    "sameAs": ["https://github.com/username"],
    "description": "Enterprise-grade full-stack engineer..."
  }
</script>
```

**Coverage:** Google Search, Bing, voice assistants, semantic web

---

## Metadata Hierarchy

**Per-page metadata cascade:**

```
Page-level metadata (specific)
  ↓
Layout metadata (global)
  ↓
Defaults (fallback)
```

**Implementation in Next.js:**

```typescript
// layout.tsx - global defaults
export const metadata: Metadata = {
  metadataBase: SITE_URL,
  title: { default: 'Portfolio', template: '%s | Portfolio' },
  description: 'Enterprise-grade portfolio...',
  openGraph: { type: 'website', siteName: 'Portfolio' },
  twitter: { card: 'summary_large_image' },
};

// [slug]/page.tsx - specific override
export const metadata: Metadata = {
  title: 'Portfolio App', // becomes "Portfolio App | Portfolio"
  description: 'Enterprise Next.js application...',
  // OG and Twitter inherit from layout, only override if needed
};
```

---

## Image Requirements

### OG Image (1200x630px)

- **Size:** 1200x630 pixels (critical for aspect ratio)
- **Format:** PNG (lossless, 24-bit preferred)
- **Location:** `public/og-image.png`
- **Aspect Ratio:** 1.91:1 (Facebook standard)
- **File Size:** < 500KB (for fast loading)
- **Content:** Brand + key message + readable text

### Twitter Image

- **Same file as OG image** (Twitter uses OG image by default)
- **Displays as:** Large image (summary_large_image card)
- **Minimum size:** 1200x630px recommended

---

## Content Coordination

### When Content Changes

**Update priority:**

1. Page metadata in `page.tsx`
2. OG tags (synchronized)
3. JSON-LD (update schema fields)
4. Image (if visual changed significantly)

**Example workflow:**

```typescript
// Before: "Portfolio App - Stage 4.5"
export const metadata = {
  title: 'Portfolio App',
  description:
    'Enterprise Next.js 16 application with dark mode and SEO optimization.',
  openGraph: {
    title: 'Portfolio App',
    description:
      'Enterprise Next.js 16 application with dark mode and SEO optimization.',
  },
  twitter: {
    title: 'Portfolio App',
    description:
      'Enterprise Next.js 16 application with dark mode and SEO optimization.',
  },
};
```

### Tools to Verify

- [Facebook Sharing Debugger](https://developers.facebook.com/tools/debug/sharing/) - Test OG
- [Twitter Card Validator](https://cards-dev.twitter.com/validator) - Test Twitter
- [Google Rich Results Test](https://search.google.com/test/rich-results) - Test JSON-LD
- [Slack Link Previewer](https://slack.com/tools/link-previewer) - Test Discord/Slack

---

## JSON-LD Schemas

### Person Schema (Homepage)

```json
{
  "@context": "https://schema.org",
  "@type": "Person",
  "name": "Your Name",
  "url": "https://portfolio.com",
  "description": "Enterprise-grade full-stack engineer portfolio...",
  "sameAs": ["https://github.com/username", "https://linkedin.com/in/username"],
  "image": "https://portfolio.com/profile-image.jpg"
}
```

**Benefits:** May trigger Knowledge Panel in Google results

### WebSite Schema (Homepage/Global)

```json
{
  "@context": "https://schema.org",
  "@type": "WebSite",
  "url": "https://portfolio.com",
  "name": "Portfolio",
  "description": "Enterprise-grade full-stack portfolio...",
  "potentialAction": {
    "@type": "SearchAction",
    "target": {
      "@type": "EntryPoint",
      "urlTemplate": "https://portfolio.com/search?q={search_term_string}"
    },
    "query-input": "required name=search_term_string"
  }
}
```

**Benefits:** Enables site search box in Google results

### BreadcrumbList Schema (All Pages)

```json
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {
      "@type": "ListItem",
      "position": 1,
      "name": "Home",
      "item": "https://portfolio.com"
    },
    {
      "@type": "ListItem",
      "position": 2,
      "name": "Projects",
      "item": "https://portfolio.com/projects"
    }
  ]
}
```

**Benefits:** Rich breadcrumb navigation in search results

---

## Consequences

### Positive

✅ **Social Reach:** Rich previews on all major platforms
✅ **Search Visibility:** Enhanced results, knowledge panels, snippets
✅ **Consistency:** Single metadata source cascades correctly
✅ **Flexibility:** Each layer handles its purpose
✅ **Future-Proof:** JSON-LD supports adding blog schemas, events, etc.
✅ **Competitive Advantage:** Most portfolios don't have this level of optimization

### Negative

⚠️ **Maintenance:** Must keep metadata synchronized across layers

- Mitigated by: Use Next.js metadata API (automatic deduplication)

⚠️ **HTML Size:** Additional meta tags increase page size by ~1KB

- Impact: Negligible with gzip compression

⚠️ **Complexity:** Understanding three different standards

- Mitigated by: Documentation and helper functions

---

## Implementation Roadmap

**Phase 1 (Current):** Core OG + Twitter + JSON-LD

- ✅ Open Graph for all pages
- ✅ Twitter Cards with summary_large_image
- ✅ Person schema on homepage
- ✅ WebSite schema on homepage
- ✅ Breadcrumb schema on subpages

**Phase 2 (Future):** Blog Support

- BlogPosting schema for blog posts
- Article schema for case studies
- Author schema for bylines

**Phase 3 (Future):** Advanced Metadata

- VideoObject schema for demos/demos
- FAQPage schema for FAQ section
- Event schema for talks/conferences

---

## Related Decisions

- ADR-0007: Dark Mode (CSS Variables)
- ADR-0009: Animation Strategy

---

## References

- [Next.js Metadata API](https://nextjs.org/docs/app/api-reference/functions/generate-metadata)
- [Open Graph Protocol](https://ogp.me/)
- [Twitter Card Documentation](https://developer.twitter.com/en/docs/twitter-for-websites/cards)
- [Schema.org](https://schema.org/)
- [Google Structured Data](https://developers.google.com/search/docs/appearance/structured-data)
