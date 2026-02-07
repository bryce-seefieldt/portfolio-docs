---
title: 'SEO & Social Metadata Reference'
description: 'Complete reference for SEO metadata architecture, structured data, Open Graph/Twitter cards, and social media optimization.'
sidebar_position: 7
tags: [seo, metadata, open-graph, twitter-card, json-ld, reference]
---

# SEO & Social Metadata Reference

## Overview

Complete technical reference for implementing SEO metadata, structured data (JSON-LD), and social media rich previews. For strategy and monitoring approach, see [Portfolio App Security Controls](../40-security/portfolio-app-security-controls.md) section on SEO.

---

## Scope

### In scope

- Meta tags strategy (title, description, keywords, robots)
- Open Graph tags for social media previews
- Twitter Card tags for X/Twitter sharing
- JSON-LD structured data (Person, WebSite schemas)
- Sitemap and robots.txt configuration
- Metadata hierarchy (global vs page-level)

### Out of scope

- SEO strategy and business goals (see Planning docs)
- Monitoring and analytics (see Operations docs)
- Blog SEO patterns (future enhancement)

---

## Metadata Architecture

### Layout Metadata (Global, Inherited by All Pages)

```typescript
// src/app/layout.tsx
export const metadata: Metadata = {
  title: {
    default: 'Portfolio',
    template: '%s | Portfolio',
  },
  description:
    'Enterprise-grade full-stack portfolio: interactive CV, verified projects, and engineering evidence.',
  metadataBase: SITE_URL ? new URL(SITE_URL) : undefined,
  keywords: [
    'full-stack engineer',
    'portfolio',
    'Next.js',
    'TypeScript',
    'enterprise architecture',
  ],
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      'max-image-preview': 'large',
      'max-snippet': -1,
    },
  },
  openGraph: {
    type: 'website',
    locale: 'en_US',
    url: SITE_URL || '/',
    siteName: 'Portfolio',
  },
  twitter: {
    card: 'summary_large_image',
  },
};
```

### Page-Level Metadata (Specific to Route)

```typescript
// src/app/cv/page.tsx
export const metadata: Metadata = {
  title: 'CV',
  description:
    'Interactive curriculum vitae with verified experience and technical skills.',
};
```

**Result:** Title becomes "CV | Portfolio" (template applied)

### Metadata Flow Architecture

```mermaid
graph TB
    A[Portfolio Page Loads] --> B[Next.js Metadata API]

    B --> C[Generate HTML Head Tags]

    C --> D[Basic Meta Tags]
    C --> E[Open Graph Tags]
    C --> F[Twitter Card Tags]
    C --> G[JSON-LD Structured Data]

    D --> D1[title: Page | Portfolio]
    D --> D2[description: Unique per page]
    D --> D3[keywords: Targeted list]
    D --> D4[robots: index, follow]

    E --> E1[og:title]
    E --> E2[og:description]
    E --> E3[og:image: 1200x630px]
    E --> E4[og:url: Canonical URL]
    E --> E5[og:type: website]

    F --> F1[twitter:card: summary_large_image]
    F --> F2[twitter:title]
    F --> F3[twitter:description]
    F --> F4[twitter:image]

    G --> G1[Person Schema]
    G --> G2[WebSite Schema]
    G --> G3[Breadcrumb Schema]

    E1 --> H[Social Media Platforms]
    E2 --> H
    E3 --> H
    E4 --> H
    E5 --> H

    F1 --> I[Twitter/X Platform]
    F2 --> I
    F3 --> I
    F4 --> I

    D1 --> J[Search Engines]
    D2 --> J
    D3 --> J
    D4 --> J

    G1 --> K[Google Knowledge Graph]
    G2 --> K
    G3 --> K

    H --> L[Rich Preview Card]
    I --> M[Twitter Card]
    J --> N[Search Results Snippet]
    K --> O[Enhanced Search Result]

    style H fill:#1877f2,color:#fff
    style I fill:#1da1f2,color:#fff
    style J fill:#4285f4,color:#fff
    style K fill:#34a853,color:#fff
    style L fill:#e4e6eb,color:#000
    style M fill:#e8f5fd,color:#000
    style N fill:#f8f9fa,color:#000
    style O fill:#f1f3f4,color:#000
```

**Tri-Layer Strategy:**

1. **Open Graph (Primary):** Default for Facebook, LinkedIn, Discord, Slack
2. **Twitter Cards (Platform-Specific):** Optimized for X/Twitter with large image format
3. **JSON-LD (Semantic):** Machine-readable data for search engines and AI assistants

**Why All Three?**

- Maximum platform coverage (each platform prefers specific tags)
- Semantic understanding (JSON-LD helps search engines understand context)
- Fallback redundancy (if Twitter tags missing, OG tags used)
- Enhanced results (structured data enables rich snippets, knowledge panels)

### Metadata Hierarchy

**Order of precedence (most specific wins):**

1. Page-level metadata (`page.tsx` export)
2. Layout metadata (`layout.tsx` export)
3. Default fallbacks

**Why this structure?**

- Define once in layout, inherit everywhere
- Override per-page when needed
- Single source of truth for global branding

---

## Meta Tags Strategy

### Title Tag (`<title>`)

**Purpose:** Appears in browser tab and search results (first line)

**Format:**

```
[Page Name] | Portfolio
```

**Examples:**

- Homepage: `Portfolio`
- CV: `CV | Portfolio`
- Projects: `Projects | Portfolio`
- Individual project: `Portfolio App | Portfolio`

**Length:** 50-60 characters (Google truncates at ~60)

**Why this format?**

- Keywords first (page name appears first)
- Brand consistency (Portfolio on every page)
- Unique per page (no duplicate titles)

**Implementation:**

```typescript
export const metadata: Metadata = {
  title: {
    default: 'Portfolio',
    template: '%s | Portfolio',
  },
};

// In individual pages:
export const metadata: Metadata = {
  title: 'CV', // Becomes "CV | Portfolio"
};
```

### Meta Description (`<meta name="description">`)

**Purpose:** Snippet shown in search results (150-160 characters)

**Format:** Action-oriented, keyword-rich, unique per page

**Examples:**

```
Homepage: "Enterprise-grade full-stack portfolio: interactive CV, verified
projects, and engineering evidence (ADRs, threat models, runbooks)."

CV: "Interactive curriculum vitae with verified experience, technical skills,
and evidence-backed accomplishments."

Projects: "Portfolio of production applications with architecture documentation,
threat models, and verified deployments."
```

**Length:** 150-160 characters (optimal for display)

**Best practices:**

- Action-oriented language ("explore", "discover", "view")
- Include target keywords naturally
- Unique per page (no duplicates)
- No keyword stuffing

**Implementation:**

```typescript
export const metadata: Metadata = {
  description: 'Enterprise-grade full-stack portfolio...',
};
```

### Meta Keywords (`<meta name="keywords">`)

**Purpose:** Hint to search engines (low SEO value but doesn't hurt)

**Format:** Comma-separated list of target keywords

**Implementation:**

```typescript
export const metadata: Metadata = {
  keywords: [
    'full-stack engineer',
    'portfolio',
    'Next.js',
    'TypeScript',
    'DevOps',
  ],
};
```

**Note:** Google doesn't use keywords for ranking, but some search engines do.

### Robots Meta Tag

**Purpose:** Control indexing and following behavior

**Format:**

```html
<meta
  name="robots"
  content="index, follow, max-image-preview:large, max-snippet:-1"
/>
```

**Directives:**

| Directive           | Value   | Meaning                              |
| ------------------- | ------- | ------------------------------------ |
| `index`             | true    | Allow search engines to index page   |
| `follow`            | true    | Allow search engines to follow links |
| `max-image-preview` | `large` | Allow large images in results        |
| `max-snippet`       | `-1`    | No limit on text snippet length      |

**Implementation:**

```typescript
export const metadata: Metadata = {
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      'max-image-preview': 'large',
      'max-snippet': -1,
    },
  },
};
```

---

## Open Graph Tags

### Purpose

Rich link previews on social media (Facebook, LinkedIn, Slack, Discord)

### Standard Format

```html
<meta property="og:type" content="website" />
<meta property="og:locale" content="en_US" />
<meta property="og:url" content="https://portfolio.com/" />
<meta property="og:site_name" content="Portfolio" />
<meta property="og:title" content="Portfolio" />
<meta
  property="og:description"
  content="Enterprise-grade full-stack portfolio..."
/>
<meta property="og:image" content="https://portfolio.com/og-image.png" />
<meta property="og:image:width" content="1200" />
<meta property="og:image:height" content="630" />
```

### Implementation

```typescript
export const metadata: Metadata = {
  openGraph: {
    type: 'website',
    locale: 'en_US',
    url: SITE_URL || '/',
    siteName: 'Portfolio',
    title: 'Portfolio',
    description: 'Enterprise-grade full-stack portfolio...',
    images: [
      {
        url: '/og-image.png',
        width: 1200,
        height: 630,
        alt: 'Portfolio - Enterprise-Grade Full-Stack Engineering',
      },
    ],
  },
};
```

### OG Image Requirements

- **Size:** 1200x630px (Facebook/LinkedIn recommended)
- **Format:** PNG or JPG (PNG preferred for quality)
- **Aspect ratio:** 1.91:1
- **File location:** `public/og-image.png`
- **Alt text:** Descriptive text for accessibility

### Testing

[Facebook Sharing Debugger](https://developers.facebook.com/tools/debug/)
[LinkedIn Post Inspector](https://www.linkedin.com/post-inspector/)
[Open Graph Preview](https://www.opengraph.xyz/)

---

## Twitter Card Tags

### Purpose

Rich link previews on X/Twitter

### Card Types

| Type                  | Layout                       | Best for       |
| --------------------- | ---------------------------- | -------------- |
| `summary`             | Small image left, text right | Articles       |
| `summary_large_image` | Large image above text       | Visual content |
| `app`                 | Mobile app install card      | Apps           |
| `player`              | Video/audio player           | Media          |

**We use `summary_large_image`** for maximum visual impact

### Implementation

```typescript
export const metadata: Metadata = {
  twitter: {
    card: 'summary_large_image',
    title: 'Portfolio',
    description: 'Enterprise-grade full-stack portfolio...',
    creator: '@yourname', // Optional: your Twitter handle
    images: ['/og-image.png'],
  },
};
```

### Testing

[Twitter Card Validator](https://cards-dev.twitter.com/validator)

---

## JSON-LD Structured Data

### Purpose

Semantic markup for search engines to understand page content

### Person Schema

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

**Benefits:**

- May appear in Google Knowledge Panel
- Helps search engines understand portfolio owner
- Enables rich results

### WebSite Schema

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

**Benefits:**

- Enables sitelinks search box in Google results
- Allows users to search your site from Google
- Improves SERP (search engine results page) presence

### Breadcrumb Schema (Optional)

```json
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {
      "@type": "ListItem",
      "position": 1,
      "name": "Home",
      "item": "https://portfolio.com/"
    },
    {
      "@type": "ListItem",
      "position": 2,
      "name": "Projects",
      "item": "https://portfolio.com/projects"
    },
    {
      "@type": "ListItem",
      "position": 3,
      "name": "Portfolio App",
      "item": "https://portfolio.com/projects/portfolio-app"
    }
  ]
}
```

### Implementation in React

```typescript
<script
  type="application/ld+json"
  dangerouslySetInnerHTML={{
    __html: JSON.stringify({
      "@context": "https://schema.org",
      "@type": "Person",
      // ... schema fields
    }),
  }}
/>
```

### Testing

[Google Rich Results Test](https://search.google.com/test/rich-results)
[Schema.org Validator](https://validator.schema.org/)

---

## Sitemap Configuration

### sitemap.xml

Location: `public/sitemap.xml`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>https://portfolio.com/</loc>
    <lastmod>2026-01-28</lastmod>
    <changefreq>weekly</changefreq>
    <priority>1.0</priority>
  </url>
  <url>
    <loc>https://portfolio.com/cv</loc>
    <lastmod>2026-01-28</lastmod>
    <changefreq>monthly</changefreq>
    <priority>0.8</priority>
  </url>
  <url>
    <loc>https://portfolio.com/projects</loc>
    <lastmod>2026-01-28</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.9</priority>
  </url>
</urlset>
```

**Fields:**

| Element      | Format     | Meaning                |
| ------------ | ---------- | ---------------------- |
| `loc`        | URL        | Absolute page URL      |
| `lastmod`    | YYYY-MM-DD | Last modification date |
| `changefreq` | Enum       | Update frequency hint  |
| `priority`   | 0.0-1.0    | Relative importance    |

**Priority Guidelines:**

- `1.0` - Homepage (most important)
- `0.9` - Key pages (Projects index)
- `0.8` - Important pages (CV)
- `0.7` - Secondary pages (Individual projects)
- `0.5` - Utility pages (Contact)

### robots.txt

Location: `public/robots.txt`

```txt
User-agent: *
Allow: /

Sitemap: https://portfolio.com/sitemap.xml
```

---

## Optimization Checklist

Before deploying or submitting to search engines:

- [ ] **Titles:** Unique, 50-60 characters, keywords first
- [ ] **Descriptions:** Unique, 150-160 characters, no duplicate
- [ ] **OG tags:** Complete on all pages (title, description, image)
- [ ] **Twitter tags:** Configured with summary_large_image
- [ ] **JSON-LD:** Valid schemas, tested with Rich Results Test
- [ ] **Keywords:** Included naturally (no stuffing)
- [ ] **Sitemap:** Generated and accessible at /sitemap.xml
- [ ] **robots.txt:** Correct and accessible at /robots.txt
- [ ] **Mobile responsive:** Works on small screens
- [ ] **HTTPS:** All pages served securely

---

## Monitoring

### Google Search Console

**Setup:**

1. Verify domain ownership
2. Submit sitemap
3. Monitor coverage and indexing

**Track:**

- Indexed pages
- 404 errors
- Coverage issues
- Search rankings
- Click-through rate (CTR)

### Tools

- [Google Search Console](https://search.google.com/search-console)
- [Bing Webmaster Tools](https://www.bing.com/webmasters)
- [PageSpeed Insights](https://pagespeed.web.dev/)

---

## References

- [Next.js Metadata API](https://nextjs.org/docs/app/api-reference/functions/generate-metadata)
- [Open Graph Protocol](https://ogp.me/)
- [Twitter Card Documentation](https://developer.twitter.com/en/docs/twitter-for-websites/cards)
- [Schema.org Documentation](https://schema.org/)
- [Google Search Central](https://developers.google.com/search)
