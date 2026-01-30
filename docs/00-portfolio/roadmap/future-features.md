---
title: 'Future Features & Advanced Enhancements'
description: 'Planned feature roadmap for future phases beyond Phase 4: blog/case studies, contact form integration, content management, and advanced UX enhancements.'
sidebar_position: 10
tags: [roadmap, future, features, backlog, phase-5]
---

# Future Features & Advanced Enhancements

This document captures planned features and advanced enhancements that extend beyond Phase 4. These are high-value additions that enhance portfolio credibility and user engagement but are deprioritized in favor of core Phase 4 delivery (multi-environment deployment, performance, security, and observability).

---

## Content-Driven Features

### Blog & Case Studies

**Purpose:** Showcase project depth, demonstrate technical communication skills, and provide ongoing content updates to boost SEO and reviewer engagement.

**Value:**

- Demonstrates ability to articulate technical decisions and lessons learned
- Provides fresh content for search engine indexing
- Shows communication and writing discipline (important for senior/leadership roles)
- Case studies link back to project evidence in the Portfolio Docs

**Approach Options:**

#### Option A: MDX-Based (Git-Backed, Recommended)

- Blog posts and case studies as `.mdx` files in version control
- Front matter with metadata (title, date, tags, excerpt, author)
- Routes: `/blog/[slug]` and `/case-studies/[slug]`
- No external CMS; everything in Git and reviewed via PR
- Static generation with `generateStaticParams()` for optimal performance

**Example Structure:**

```
src/content/
├── blog/
│   ├── 2026-01-24-nextjs-16-setup.mdx
│   ├── 2026-01-25-tailwind-v4-migration.mdx
│   ├── 2026-02-01-phase-4-learnings.mdx
│   └── ...
├── case-studies/
│   ├── portfolio-app.mdx
│   ├── portfolio-docs.mdx
│   └── ...
└── metadata.ts (index of all content files)
```

**Front Matter Example:**

```yaml
---
title: 'Next.js 16 Setup: Building Enterprise Portfolios'
date: '2026-01-24'
tags: ['Next.js', 'TypeScript', 'DevOps']
excerpt: 'Lessons learned setting up Next.js 16 for production portfolio with enterprise DevOps maturity.'
author: 'Your Name'
---
```

#### Option B: Headless CMS (Contentful, Sanity, etc.)

**Pros:**

- More flexible content management UI (non-technical content editors)
- Real-time preview and scheduling
- Content versioning and approval workflows

**Cons:**

- External dependency (service availability, cost, API rate limits)
- Requires careful secret management (API keys, tokens)
- Coupling to third-party service; harder to migrate
- Not recommended for Phase 4 solo projects

#### Option C: Database-Backed (Future)

- Content stored in PostgreSQL or similar
- Admin panel for CRUD operations
- Requires authentication and authorization design
- Significant complexity; defer to Phase 5+

**Recommendation:** Start with Option A (MDX). If content management becomes a bottleneck, evaluate Option B.

**Implementation Checklist:**

- [ ] Create `src/content/blog/` and `src/content/case-studies/` directories
- [ ] Define front matter schema (TypeScript types)
- [ ] Create `src/content/metadata.ts` to index all content files
- [ ] Build loader function to parse MDX files at build time
- [ ] Create `/blog/[slug]` page route with static generation
- [ ] Create `/case-studies/[slug]` page route with static generation
- [ ] Create `/blog` hub page listing all blog posts
- [ ] Create `/case-studies` hub page listing all case studies
- [ ] Implement tagging and filtering (optional enhancement)
- [ ] Link blog/case study content back to evidence docs
- [ ] Write 2–3 initial blog posts (depth > quantity)
- [ ] Write 2–3 case studies covering key projects
- [ ] Integrate with SEO metadata (canonical URLs, OG tags)

---

### Interactive Contact Form

**Purpose:** Demonstrate full-stack capability (form handling, validation, email integration) and provide friction-free contact path for reviewers.

**Value:**

- Shows ability to build complete user flows (frontend + backend)
- Demonstrates form validation and error handling
- Email integration shows understanding of transactional systems
- Adds authenticity and professionalism to portfolio

**Implementation Approach:**

#### Option A: Email-to-Inbox (Recommended for Phase 4+)

Send form submissions directly to email via service (SendGrid, Resend, etc.).

**Frontend Component (`src/app/contact/page.tsx`):**

```typescript
"use client";

import { useState } from "react";

export default function ContactPage() {
  const [form, setForm] = useState({ name: "", email: "", message: "" });
  const [status, setStatus] = useState<"idle" | "loading" | "success" | "error">("idle");
  const [error, setError] = useState("");

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setStatus("loading");
    setError("");

    try {
      const response = await fetch("/api/contact", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(form),
      });

      if (response.ok) {
        setStatus("success");
        setForm({ name: "", email: "", message: "" });
        // Reset success message after 3 seconds
        setTimeout(() => setStatus("idle"), 3000);
      } else {
        const data = await response.json();
        setStatus("error");
        setError(data.error || "Failed to send message");
      }
    } catch (error) {
      setStatus("error");
      setError("Network error. Please try again.");
    }
  };

  return (
    <div className="max-w-2xl mx-auto py-12">
      <h1 className="text-3xl font-bold mb-6">Get in Touch</h1>
      <p className="text-gray-600 mb-8">
        Have a question or opportunity? I'd love to hear from you.
      </p>

      <form onSubmit={handleSubmit} className="space-y-6">
        <div>
          <label htmlFor="name" className="block text-sm font-medium mb-2">
            Name
          </label>
          <input
            id="name"
            type="text"
            placeholder="Your name"
            value={form.name}
            onChange={(e) => setForm({ ...form, name: e.target.value })}
            required
            className="w-full px-4 py-2 border rounded-lg"
          />
        </div>

        <div>
          <label htmlFor="email" className="block text-sm font-medium mb-2">
            Email
          </label>
          <input
            id="email"
            type="email"
            placeholder="your@email.com"
            value={form.email}
            onChange={(e) => setForm({ ...form, email: e.target.value })}
            required
            className="w-full px-4 py-2 border rounded-lg"
          />
        </div>

        <div>
          <label htmlFor="message" className="block text-sm font-medium mb-2">
            Message
          </label>
          <textarea
            id="message"
            placeholder="Your message here..."
            value={form.message}
            onChange={(e) => setForm({ ...form, message: e.target.value })}
            required
            rows={5}
            className="w-full px-4 py-2 border rounded-lg"
          />
        </div>

        <button
          type="submit"
          disabled={status === "loading"}
          className="w-full bg-blue-600 hover:bg-blue-700 disabled:bg-gray-400 text-white font-medium py-2 px-4 rounded-lg transition"
        >
          {status === "loading" ? "Sending..." : "Send Message"}
        </button>
      </form>

      {status === "success" && (
        <div className="mt-4 p-4 bg-green-50 border border-green-200 rounded-lg text-green-800">
          ✓ Message sent successfully! I'll get back to you soon.
        </div>
      )}

      {status === "error" && (
        <div className="mt-4 p-4 bg-red-50 border border-red-200 rounded-lg text-red-800">
          ✗ Error: {error}
        </div>
      )}
    </div>
  );
}
```

**Backend Endpoint (`src/app/api/contact/route.ts`):**

```typescript
import { NextRequest, NextResponse } from 'next/server';

export async function POST(request: NextRequest) {
  const { name, email, message } = await request.json();

  // Input validation
  if (!name || !email || !message) {
    return NextResponse.json(
      { error: 'Missing required fields' },
      { status: 400 }
    );
  }

  // Length validation (prevent spam/abuse)
  if (message.length > 5000 || name.length > 100 || email.length > 254) {
    return NextResponse.json(
      { error: 'Input exceeds maximum length' },
      { status: 400 }
    );
  }

  // Basic email validation
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailRegex.test(email)) {
    return NextResponse.json(
      { error: 'Invalid email address' },
      { status: 400 }
    );
  }

  // Anti-spam: Check for common spam patterns
  const spamPatterns = [
    /viagra|cialis|casino|lottery/i,
    /click here|buy now|limited time/i,
    /.{0,3}(http|www|\.com).{0,3}/i, // URLs in content
  ];

  if (spamPatterns.some((pattern) => pattern.test(message))) {
    return NextResponse.json(
      { error: 'Message contains disallowed content' },
      { status: 400 }
    );
  }

  try {
    // Option 1: SendGrid Integration
    // const response = await fetch("https://api.sendgrid.com/v3/mail/send", {
    //   method: "POST",
    //   headers: {
    //     "Authorization": `Bearer ${process.env.SENDGRID_API_KEY}`,
    //     "Content-Type": "application/json"
    //   },
    //   body: JSON.stringify({
    //     personalizations: [{
    //       to: [{ email: process.env.CONTACT_EMAIL }]
    //     }],
    //     from: { email: "noreply@portfolio.example.com" },
    //     subject: `New Contact Form Submission from ${name}`,
    //     content: [{
    //       type: "text/plain",
    //       value: `From: ${name} <${email}>\n\n${message}`
    //     }],
    //     reply_to: { email },
    //   }),
    // });

    // Option 2: Resend Integration (simpler, recommended)
    // const { Resend } = require('resend');
    // const resend = new Resend(process.env.RESEND_API_KEY);
    // await resend.emails.send({
    //   from: 'noreply@portfolio.example.com',
    //   to: process.env.CONTACT_EMAIL,
    //   replyTo: email,
    //   subject: `New Contact Form Submission from ${name}`,
    //   html: `<p><strong>From:</strong> ${name}</p><p><strong>Email:</strong> ${email}</p><p><strong>Message:</strong></p><p>${message}</p>`,
    // });

    // For now: Log to Vercel console (Phase 4 placeholder)
    console.log(
      `[CONTACT FORM] From: ${name} <${email}>\nMessage: ${message.slice(0, 200)}...`
    );

    return NextResponse.json({ success: true }, { status: 200 });
  } catch (error) {
    console.error('Contact form error:', error);
    return NextResponse.json(
      { error: 'Failed to send message' },
      { status: 500 }
    );
  }
}
```

**Security Considerations:**

- Rate limit by IP address (prevent spam/abuse)
- Validate and sanitize all inputs
- Don't echo user input back in errors (prevent XSS)
- Log submissions for audit trail
- Consider CAPTCHA if spam becomes issue (reCAPTCHA, hCaptcha)

**Email Service Options:**

| Service  | Cost                | Setup             | Recommended               |
| -------- | ------------------- | ----------------- | ------------------------- |
| SendGrid | Free tier available | API key setup     | ✅ Established            |
| Resend   | Free tier available | SDK, simpler      | ✅ Modern, React-friendly |
| AWS SES  | Per-email cost      | Complex IAM setup | For scale                 |
| Mailgun  | Free tier available | API key           | Solid alternative         |

**Implementation Checklist:**

- [ ] Design contact form UI (accessibility: labels, ARIA, keyboard nav)
- [ ] Build form component with client-side validation
- [ ] Create API endpoint with server-side validation
- [ ] Implement anti-spam checks (length, patterns, optional CAPTCHA)
- [ ] Choose and configure email service (SendGrid, Resend, etc.)
- [ ] Add environment variables for email service credentials
- [ ] Test form submission with valid/invalid data
- [ ] Test email delivery
- [ ] Add error handling and user feedback messages
- [ ] Monitor submission logs for spam patterns
- [ ] Document contact form setup in runbook

---

## UX & Navigation Enhancements

### Enhanced Navigation & Search

**Sticky Navigation Bar:**

- Logo or site title in header
- Navigation links (Home, CV, Projects, Contact, Docs)
- Mobile hamburger menu
- Search bar (optional)
- Theme toggle (light/dark mode)

**Search Implementation:**

**For Portfolio App (Client-Side):**

Use `fuse.js` for fuzzy search across projects and content:

```typescript
// src/lib/search.ts
import Fuse from 'fuse.js';

export interface SearchItem {
  id: string;
  title: string;
  excerpt: string;
  url: string;
  type: 'project' | 'blog' | 'page';
}

export function createSearchIndex(items: SearchItem[]) {
  return new Fuse(items, {
    keys: ['title', 'excerpt'],
    threshold: 0.3,
  });
}

export function search(index: Fuse<SearchItem>, query: string) {
  return index.search(query).map((result) => result.item);
}
```

**For Portfolio Docs (Hosted):**

Use Algolia for hosted search (enterprise-grade, free tier available):

```typescript
// src/lib/algolia.ts
export function initAlgolia() {
  // Initialize Algolia InstantSearch
  // Index docs at build time
  // Provides search-as-you-type UX
}
```

**404 Page Enhancement:**

- Friendly design with link back to home
- Quick links to popular pages (Projects, CV, Docs)
- Search box to find content
- Bug report option

**Back-to-Top Button:**

- Appears on scroll
- Smooth scroll animation
- Fixed position (bottom-right corner)
- Accessible with keyboard (Tab, Enter)

**Implementation Checklist:**

- [ ] Create sticky navigation component
- [ ] Add mobile hamburger menu
- [ ] Implement responsive design (mobile-first)
- [ ] Create search component (choose fuse.js or Algolia)
- [ ] Create custom 404 page with quick links
- [ ] Add back-to-top button with scroll trigger
- [ ] Test accessibility (keyboard nav, screen readers)
- [ ] Test responsive breakpoints (mobile, tablet, desktop)

---

## Theming & Visual Enhancements

### Dark Mode Toggle

**Implementation (`src/components/ThemeToggle.tsx`):**

```typescript
"use client";

import { useEffect, useState } from "react";

export function ThemeToggle() {
  const [theme, setTheme] = useState<"light" | "dark" | null>(null);
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
    // Check system preference if no saved theme
    const saved = localStorage.getItem("theme") as "light" | "dark" | null;
    const prefersDark = window.matchMedia("(prefers-color-scheme: dark)").matches;
    const initial = saved || (prefersDark ? "dark" : "light");
    setTheme(initial);
    applyTheme(initial);
  }, []);

  const applyTheme = (newTheme: "light" | "dark") => {
    document.documentElement.classList.remove("light", "dark");
    document.documentElement.classList.add(newTheme);
    localStorage.setItem("theme", newTheme);
  };

  const toggle = () => {
    const newTheme = theme === "light" ? "dark" : "light";
    setTheme(newTheme);
    applyTheme(newTheme);
  };

  if (!mounted) return null;

  return (
    <button
      onClick={toggle}
      aria-label="Toggle theme"
      className="p-2 rounded-lg hover:bg-gray-200 dark:hover:bg-gray-800"
    >
      {theme === "light" ? "🌙" : "☀️"}
    </button>
  );
}
```

**CSS Variables for Theming:**

```css
/* globals.css */
:root {
  --bg-primary: #ffffff;
  --bg-secondary: #f5f5f5;
  --text-primary: #000000;
  --text-secondary: #666666;
  --border: #e0e0e0;
}

html.dark {
  --bg-primary: #1a1a1a;
  --bg-secondary: #2a2a2a;
  --text-primary: #ffffff;
  --text-secondary: #999999;
  --border: #333333;
}

body {
  background-color: var(--bg-primary);
  color: var(--text-primary);
}
```

**Tailwind Dark Mode Integration:**

```typescript
// tailwind.config.ts
export default {
  darkMode: 'class', // Use class-based dark mode
  theme: {
    extend: {
      colors: {
        // Custom dark mode colors
      },
    },
  },
};
```

**Implementation Checklist:**

- [ ] Set up CSS variables for theme colors
- [ ] Configure Tailwind for dark mode (class-based)
- [ ] Create ThemeToggle component
- [ ] Add theme persistence to localStorage
- [ ] Test theme switching across all pages
- [ ] Ensure contrast ratios meet WCAG standards (both themes)
- [ ] Test system preference detection (prefers-color-scheme)

### Subtle Animations

**Fade-In on Scroll (Intersection Observer):**

```typescript
// src/hooks/useIntersectionObserver.ts
'use client';

import { useEffect, useRef, useState } from 'react';

export function useFadeInOnScroll() {
  const ref = useRef<HTMLDivElement>(null);
  const [isVisible, setIsVisible] = useState(false);

  useEffect(() => {
    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          setIsVisible(true);
          observer.unobserve(entry.target);
        }
      },
      { threshold: 0.1 }
    );

    if (ref.current) observer.observe(ref.current);

    return () => observer.disconnect();
  }, []);

  return { ref, isVisible };
}
```

**Hover Effects on Cards:**

```typescript
// Use Tailwind utilities
<div className="transform hover:scale-105 transition-transform duration-200">
  {/* Card content */}
</div>
```

**Page Transitions (Optional: Framer Motion):**

```typescript
// src/components/PageTransition.tsx
"use client";

import { motion } from "framer-motion";

export function PageTransition({ children }: { children: React.ReactNode }) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.3 }}
    >
      {children}
    </motion.div>
  );
}
```

**Performance Notes:**

- Use CSS transforms (scale, translate) for GPU acceleration
- Avoid animating layout properties (width, height, position)
- Use `will-change` CSS property sparingly
- Monitor Core Web Vitals; animations shouldn't degrade performance
- Consider `prefers-reduced-motion` for accessibility

**Implementation Checklist:**

- [ ] Add fade-in-on-scroll effect using Intersection Observer
- [ ] Add hover effects to clickable elements
- [ ] Add smooth transitions between pages (router events)
- [ ] Test performance impact (Lighthouse scores)
- [ ] Test with `prefers-reduced-motion` media query
- [ ] Document animation style guide (consistency)

---

## SEO & Structured Data

### SEO Meta Optimization

**Enhanced Layout Metadata (`src/app/layout.tsx`):**

```typescript
import { Metadata } from 'next';
import { SITE_URL } from '@/lib/config';

export const metadata: Metadata = {
  title: {
    default: 'Portfolio — Enterprise-Grade Full-Stack Engineering',
    template: '%s | Portfolio',
  },
  description:
    'Full-stack engineer portfolio with Next.js, TypeScript, and enterprise DevOps maturity. Explore projects, verified evidence, and operational readiness.',
  keywords: [
    'full-stack engineer',
    'Next.js',
    'TypeScript',
    'DevOps',
    'portfolio',
    'enterprise architecture',
  ],
  metadataBase: SITE_URL ? new URL(SITE_URL) : undefined,
  alternates: {
    canonical: SITE_URL || '/',
  },
  openGraph: {
    type: 'website',
    locale: 'en_US',
    url: SITE_URL || '/',
    siteName: 'Portfolio',
    title: 'Portfolio — Enterprise-Grade Full-Stack Engineering',
    description:
      'Full-stack engineer portfolio with Next.js, TypeScript, and enterprise DevOps maturity.',
    images: [
      {
        url: `${SITE_URL}/og-image.png`,
        width: 1200,
        height: 630,
        alt: 'Portfolio',
      },
    ],
  },
  twitter: {
    card: 'summary_large_image',
    title: 'Portfolio — Enterprise-Grade Full-Stack Engineering',
    description: 'Full-stack engineer portfolio with verified evidence.',
    images: [`${SITE_URL}/twitter-image.png`],
    creator: '@yourusername', // Update with actual handle
  },
  robots: {
    index: true,
    follow: true,
    'max-snippet': -1,
    'max-image-preview': 'large',
    'max-video-preview': -1,
  },
};
```

**JSON-LD Structured Data:**

```typescript
// src/lib/structured-data.ts
import { SITE_URL } from '@/lib/config';

export function getPersonSchema() {
  return {
    '@context': 'https://schema.org',
    '@type': 'Person',
    name: 'Your Name',
    url: SITE_URL,
    image: `${SITE_URL}/profile-image.jpg`,
    sameAs: [
      'https://github.com/yourname',
      'https://linkedin.com/in/yourname',
      'https://twitter.com/yourname',
    ],
    jobTitle: 'Full-Stack Engineer',
    worksFor: {
      '@type': 'Organization',
      name: 'Your Organization (if applicable)',
    },
    knowsLanguage: ['English'],
  };
}

export function getWebsiteSchema() {
  return {
    '@context': 'https://schema.org',
    '@type': 'WebSite',
    url: SITE_URL,
    name: 'Portfolio',
    description: 'Enterprise-Grade Full-Stack Engineering Portfolio',
    potentialAction: {
      '@type': 'SearchAction',
      target: `${SITE_URL}/search?q={search_term_string}`,
      'query-input': 'required name=search_term_string',
    },
  };
}
```

**Add to Layout:**

```typescript
// src/app/layout.tsx
export const metadata: Metadata = {
  // ... existing metadata ...
  other: {
    'script:ld+json': JSON.stringify([getPersonSchema(), getWebsiteSchema()]),
  },
};
```

**Sitemap & Robots (`public/sitemap.xml` and `public/robots.txt`):**

```xml
<!-- public/sitemap.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>https://portfolio.example.com/</loc>
    <lastmod>2026-01-28</lastmod>
    <changefreq>weekly</changefreq>
    <priority>1.0</priority>
  </url>
  <url>
    <loc>https://portfolio.example.com/cv</loc>
    <lastmod>2026-01-28</lastmod>
    <changefreq>monthly</changefreq>
    <priority>0.8</priority>
  </url>
  <url>
    <loc>https://portfolio.example.com/projects</loc>
    <lastmod>2026-01-28</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>
</urlset>
```

```txt
# public/robots.txt
User-agent: *
Allow: /
Disallow: /api/
Sitemap: https://portfolio.example.com/sitemap.xml
```

**Implementation Checklist:**

- [ ] Update metadata in layout.tsx (title, description, OG, Twitter)
- [ ] Create JSON-LD schema (Person, WebSite, BreadcrumbList)
- [ ] Add to `<head>` via metadata or `<script>` tag
- [ ] Create sitemap.xml with all pages
- [ ] Create robots.txt with Sitemap reference
- [ ] Submit sitemap to Google Search Console
- [ ] Test with Google's Rich Results Test
- [ ] Monitor SEO metrics (ranking, impressions, CTR)

---

## Content Management Strategy

### Runbook: Content Management & Publication

**Purpose:** Document process for creating, reviewing, and publishing new blog posts and case studies.

**Workflow:**

1. **Planning (Idea Phase)**
   - Identify topic based on recent projects or lessons learned
   - Create GitHub issue with outline and target publication date
   - Review for alignment with portfolio positioning

2. **Authoring (Draft Phase)**
   - Write content in Markdown/MDX with front matter
   - Create feature branch: `content/[topic-slug]`
   - Include 2–3 code examples or diagrams if applicable
   - Self-edit for clarity and tone

3. **Review (Peer Review)**
   - Create PR with content change
   - Request review from peer or mentor
   - Incorporate feedback (clarity, accuracy, tone)
   - Ensure links to evidence docs are accurate

4. **Publishing (Release Phase)**
   - Merge PR to `main` (triggers auto-deployment)
   - Verify content renders correctly on production
   - Share on social media if applicable
   - Update blog index or case studies index

5. **Maintenance (Ongoing)**
   - Monitor for broken links
   - Update outdated information
   - Respond to comments/feedback (if enabled)
   - Archive content only if outdated/inaccurate

**Content Guidelines:**

- **Tone:** Professional, approachable, specific (avoid generic)
- **Length:** 500–1500 words for blog; 1500–3000 for case studies
- **Structure:**
  - Clear headline (SEO-friendly, 50–60 chars)
  - Introductory paragraph (hook + problem statement)
  - 2–4 main sections with subheadings
  - Conclusion with key takeaways
  - Links to related projects/docs
- **Links:** Every significant claim links to evidence (dossier, ADR, runbook, code)
- **Images/Diagrams:** 1–2 per section (Mermaid for diagrams, PNG/WebP for images)
- **Keywords:** Target 2–3 primary + 3–5 secondary keywords naturally

**Implementation Checklist:**

- [ ] Create content templates (blog.mdx, case-study.mdx)
- [ ] Document front matter schema (title, date, tags, excerpt, etc.)
- [ ] Create GitHub issue template for content ideas
- [ ] Document peer review process and checklist
- [ ] Set up auto-deployment on merge
- [ ] Implement analytics tracking (pageviews, scroll depth)
- [ ] Create content calendar (editorial plan)
- [ ] Establish publishing cadence (weekly, bi-weekly, etc.)

---

## Summary: Prioritization for Future Phases

| Feature             | Phase | Effort | Value  | Priority |
| ------------------- | ----- | ------ | ------ | -------- |
| Blog/Case Studies   | 5     | Medium | High   | ⭐⭐⭐   |
| Contact Form        | 5     | Low    | Medium | ⭐⭐     |
| Enhanced Navigation | 4.5   | Low    | Medium | ⭐⭐⭐   |
| Dark Mode           | 5     | Low    | Low    | ⭐⭐     |
| Animations          | 5     | Medium | Low    | ⭐       |
| SEO Optimization    | 4.5   | Medium | High   | ⭐⭐⭐   |
| Search (fuse.js)    | 5     | Low    | Medium | ⭐⭐     |
| Search (Algolia)    | 5+    | Medium | High   | ⭐⭐     |
| Content Management  | 5+    | High   | High   | ⭐⭐⭐   |

**Recommended Phase 5 Scope (6–8 hours):**

1. Blog & Case Studies (MDX-based)
2. Enhanced SEO Optimization (metadata, structured data, sitemap)
3. Contact Form (basic email integration)
4. Enhanced Navigation (sticky header, 404 page, back-to-top)
5. Dark Mode Toggle

**Recommended Phase 5+ (8+ hours):**

1. Advanced Search (Algolia integration)
2. Animations (Framer Motion, scroll effects)
3. Content Management Runbook & Editorial Calendar
4. Advanced filtering and tagging

---
