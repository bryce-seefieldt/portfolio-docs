---
title: 'Social Metadata Guide'
description: 'Best practices for Open Graph and Twitter Card configuration in portfolio projects, plus privacy-safe analytics notes.'
sidebar_position: 11
tags: ['reference', 'social-metadata', 'open-graph', 'twitter-cards', 'seo']
---

# Social Metadata Guide

## Purpose

Provide a concise, copy/paste-safe reference for configuring social sharing metadata (Open Graph + Twitter Cards) and validating previews. Covers defaults in `layout.tsx`, project-specific metadata in `[slug]/page.tsx`, and how to validate cards before sharing.

## Quick Start (Defaults)

1. **Set canonical site URL**: Ensure `NEXT_PUBLIC_SITE_URL` is set to your production domain (e.g., `https://portfolio.example.com`).
2. **Site-wide defaults**: `src/app/layout.tsx` defines Open Graph + Twitter defaults used by all pages.
3. **Per-project metadata**: `src/app/projects/[slug]/page.tsx` uses `generateMetadata` to set project-specific title/description and URLs.
4. **Validate previews**: Use the validators below before posting links.

## Open Graph (OG) Metadata

- **Why it matters**: Facebook, LinkedIn, and most platforms render rich previews using OG tags.
- **Minimum fields**: `og:title`, `og:description`, `og:type`, `og:url`, `og:site_name`.
- **Image guidance**: 1200x630 px, HTTPS URL, descriptive `alt` text.

### Site-wide defaults (layout)

- Title/description set once in `src/app/layout.tsx`.
- `openGraph.type`: `website`
- `openGraph.url`: uses `NEXT_PUBLIC_SITE_URL` when provided; falls back to `/`.
- `openGraph.siteName`: `Portfolio` (can be branded as needed).

### Project-specific metadata

- Implemented via `generateMetadata` in `src/app/projects/[slug]/page.tsx`.
- Title/description sourced from the project registry entry.
- URL construction uses `SITE_URL` (from `NEXT_PUBLIC_SITE_URL`) to build absolute paths: `https://yourdomain.com/projects/<slug>`.
- If a project is missing, a graceful fallback is returned to avoid broken previews.

## Twitter Cards

- **Card type**: `summary_large_image` for project pages (best visual impact).
- **Fields used**: `twitter.title`, `twitter.description`, `twitter.card`.
- Inherit title/description from the project registry to keep OG and Twitter in sync.

## Validation Workflow

1. **Set prod URL**: Confirm `NEXT_PUBLIC_SITE_URL` matches the deployed domain.
2. **Deploy preview**: Use Vercel preview URL or production after merge.
3. **Validate**:
   - Twitter: [https://cards-dev.twitter.com/validator](https://cards-dev.twitter.com/validator)
   - Facebook: [https://developers.facebook.com/tools/debug/](https://developers.facebook.com/tools/debug/)
4. **Troubleshoot common issues**:
   - Stale cache → click "Scrape Again" in Facebook debugger or re-run Twitter validator.
   - Missing images → ensure absolute HTTPS URLs and 1200x630 size.
   - Truncated text → keep descriptions ~150–160 characters.

## Privacy-Safe Analytics (Context)

- App uses Vercel Web Analytics (no cookies, no PII, GDPR-friendly).
- No extra env vars required; the `&lt;Analytics /&gt;` component is rendered in `layout.tsx`.
- Purpose: understand which pages/projects are viewed without tracking individuals.

## Copy/Paste Examples

### Project metadata (simplified excerpt)

```typescript
// src/app/projects/[slug]/page.tsx (excerpt)
export async function generateMetadata({
  params,
}: {
  params: Promise<{ slug: string }>;
}): Promise<Metadata> {
  const { slug } = await params;
  const project = getProjectBySlug(slug);
  const projectUrl = SITE_URL
    ? `${SITE_URL}/projects/${slug}`
    : `/projects/${slug}`;

  if (!project) {
    return {
      title: 'Project Not Found',
      description: 'The requested project could not be found.',
    };
  }

  return {
    title: project.title,
    description: project.summary,
    openGraph: {
      title: project.title,
      description: project.summary,
      type: 'website',
      url: projectUrl,
      siteName: 'Portfolio',
    },
    twitter: {
      card: 'summary_large_image',
      title: project.title,
      description: project.summary,
    },
  };
}
```

### Site-wide metadata defaults (simplified excerpt)

```typescript
// src/app/layout.tsx (excerpt)
export const metadata: Metadata = {
  title: {
    default: 'Portfolio',
    template: '%s | Portfolio',
  },
  description:
    'Enterprise-grade portfolio with verified projects and evidence.',
  metadataBase: SITE_URL ? new URL(SITE_URL) : undefined,
  openGraph: {
    type: 'website',
    locale: 'en_US',
    url: SITE_URL || '/',
    siteName: 'Portfolio',
    title: 'Portfolio',
    description:
      'Enterprise-grade portfolio with verified projects and evidence.',
  },
  twitter: {
    card: 'summary_large_image',
    title: 'Portfolio',
    description:
      'Enterprise-grade portfolio with verified projects and evidence.',
  },
};
```

## Troubleshooting Cheatsheet

- **Preview not updating**: Re-run validators; scrape again on Facebook; ensure caches bust with a new deploy.
- **Image missing**: Use absolute HTTPS URL; verify 1200x630; check that the image is reachable without auth.
- **Wrong URL**: Set `NEXT_PUBLIC_SITE_URL` to the canonical domain; redeploy so metadataBase updates.
- **Mixed content warnings**: Ensure all assets (images, links) are HTTPS.

## References

- Open Graph reference: [ogp.me/](https://ogp.me/)
- Twitter Card docs: [developer.twitter.com/en/docs/twitter-for-websites/cards/overview/abouts-cards](https://developer.twitter.com/en/docs/twitter-for-websites/cards/overview/abouts-cards)
- Next.js Metadata: [nextjs.org/docs/app/api-reference/functions/generate-metadata](https://nextjs.org/docs/app/api-reference/functions/generate-metadata)
- Social preview validators: Twitter Card Validator, Facebook Sharing Debugger
