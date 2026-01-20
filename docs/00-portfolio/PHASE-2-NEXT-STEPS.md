---
title: 'Phase 2 Next Steps — Detailed Implementation Guide'
description: 'Step-by-step guide for completing remaining Phase 2 deliverables: dossier enhancements, gold standard project page, CV enhancement, and release note.'
tags: [phase-2, implementation, portfolio-app, next-steps, planning]
date: 2026-01-20
---

# Phase 2 Next Steps — Detailed Implementation Guide

## Status Overview

**Current Phase:** Phase 2 (Gold Standard Project + Credibility Baseline)

**Completed Steps:**
- ✅ STEP 1: Gold standard project decided (portfolio-app via ADR-0010)
- ✅ STEP 2: Smoke test infrastructure (Playwright + CI integration)
- ✅ STEP 4a: Phase 2 security enhancements (secrets scanning, CI hardening)
- ✅ STEP 4b: Secrets incident response runbook

**Remaining Steps:**
- 🟡 STEP 3: Enhance portfolio-app dossier to gold standard
- 🟡 STEP 4: Complete/merge threat model PR #32
- 🟡 STEP 6: Create gold standard project page in portfolio-app
- 🟡 STEP 7: Enhance CV page with capability-to-proof mapping
- 🟡 STEP 8: Create Phase 2 release note

---

## Remaining Work Breakdown

### Priority 1: Complete Threat Model (STEP 4) — 1–2 hours

**Goal:** Merge threat model PR #32 and ensure all references are correct.

**Action Items:**

1. **Review and merge PR #32** (portfolio-docs threat model enhancement)
   ```bash
   cd /home/seven30/src/portfolio/portfolio-docs
   gh pr view 32
   gh pr merge 32 --squash
   ```

2. **Verify threat model references in dossier**
   - Check [docs/60-projects/portfolio-app/04-security.md](docs/60-projects/portfolio-app/04-security.md)
   - Ensure link to threat model is correct

3. **Update session-context.md** to mark threat model as completed

**Success Criteria:**
- [ ] PR #32 merged
- [ ] Threat model accessible at `/docs/40-security/threat-models/portfolio-app-threat-model`
- [ ] Dossier security page links correctly to threat model
- [ ] Build passes with no broken links

---

### Priority 2: Enhance Portfolio App Dossier (STEP 3) — 4–6 hours

**Goal:** Elevate existing 7-page dossier to "gold standard" with executive summaries, metrics, diagrams, and comprehensive technical details.

**Files to Enhance:**

#### 3a. Update `01-overview.md` (1–2 hours)

**Location:** `/home/seven30/src/portfolio/portfolio-docs/docs/60-projects/portfolio-app/01-overview.md`

**Add/Update Sections:**

1. **Executive Summary** (new section, top of file)
   ```markdown
   ## Executive Summary
   
   The Portfolio App is a production TypeScript web application that serves as an interactive CV and project showcase, intentionally designed to demonstrate enterprise-grade engineering discipline. Built with Next.js and deployed on Vercel with comprehensive CI/CD governance, it proves competency across modern web development, security hygiene, operational maturity, and evidence-first documentation practices.
   
   **Key value:** Not just a portfolio site—a working exemplar of how senior engineers build, secure, operate, and document production systems.
   ```

2. **Key Metrics (Phase 2 Baseline)** (new section)
   ```markdown
   ## Key Metrics (Phase 2 Baseline)
   
   - **Lines of code:** ~500 (application), ~200 (tests)
   - **Routes:** 5 core routes (/, /cv, /projects, /contact, /projects/[slug])
   - **CI checks:** 4 required (quality, secrets-scan, build w/smoke tests, CodeQL)
   - **Test coverage:** 100% route coverage (Playwright smoke tests)
   - **Deployment frequency:** On every merge to main (automatic)
   - **Mean time to rollback:** ~1 minute (Git revert + CI)
   - **Quality gates:** Lint, format, typecheck, secrets scan, build, smoke tests (all enforced)
   - **Dependencies:** ~17 production, ~15 dev (Dependabot weekly updates)
   ```

3. **What This Project Proves** (new section)
   ```markdown
   ## What This Project Proves
   
   ### Technical Competency
   - Modern full-stack web development (Next.js 15+, React 19+, TypeScript 5+)
   - Component-driven architecture with App Router
   - Responsive design with Tailwind CSS
   - Evidence-first UX (deep links to documentation)
   
   ### Engineering Discipline
   - CI quality gates (ESLint max-warnings=0, Prettier, TypeScript strict)
   - Automated smoke testing (Playwright multi-browser)
   - Secrets scanning (TruffleHog CI + pre-commit)
   - Frozen lockfile installs (deterministic builds)
   - PR-only merge discipline (GitHub Ruleset enforcement)
   
   ### Security Awareness
   - Public-safe by design (no secrets, internal endpoints, or auth)
   - CodeQL + Dependabot enabled (supply chain hardening)
   - Least-privilege CI permissions (scoped per job)
   - Environment variable hygiene (documented, validated)
   - Secrets incident response runbook
   
   ### Operational Maturity
   - Deploy/rollback runbooks (tested and documented)
   - CI triage procedures (deterministic troubleshooting)
   - Secrets incident response (5-phase procedure)
   - Vercel production promotion gating (required checks)
   - Evidence-based release notes
   
   ### Documentation Excellence
   - Complete dossier (7 comprehensive pages)
   - ADRs for durable decisions (hosting, CI gates, testing strategy, gold standard choice)
   - Threat model (STRIDE analysis with 12 threat scenarios)
   - Operational runbooks (deploy, secrets incident, CI triage, rollback)
   ```

**Action:**
```bash
# Edit file with comprehensive enhancements
code /home/seven30/src/portfolio/portfolio-docs/docs/60-projects/portfolio-app/01-overview.md
```

---

#### 3b. Update `02-architecture.md` (2–3 hours)

**Location:** `/home/seven30/src/portfolio/portfolio-docs/docs/60-projects/portfolio-app/02-architecture.md`

**Add/Update Sections:**

1. **Technology Stack (Complete Inventory)** (new or enhanced section)
   - List all major dependencies with versions and rationale
   - Include: Next.js, React, TypeScript, Tailwind, Playwright, ESLint, Prettier, pnpm, Vercel

2. **High-Level Request Flow** (new section with Mermaid diagram)
   ````markdown
   ## High-Level Request Flow
   
   ```mermaid
   graph TD
     A[Browser] -->|HTTPS GET /projects/portfolio-app| B[Vercel Edge CDN]
     B --> C[Next.js App Router]
     C --> D[Route: /projects/slug]
     D --> E[getProjectBySlug from src/data/projects.ts]
     E --> F[Server Component Rendering]
     F --> G[HTML Response with RSC payload]
     G --> A
   ```
   
   **Flow explanation:**
   1. Browser requests project detail page
   2. Vercel Edge CDN terminates SSL, serves cached response if available
   3. Next.js App Router matches `/projects/[slug]` route
   4. Server component fetches project metadata from static registry
   5. Component renders with Section/Callout components and evidence links
   6. Static-optimized HTML + RSC payload returned to browser
   ````

3. **Component Architecture** (new section)
   ```markdown
   ## Component Architecture
   
   ```
   src/
   ├── app/                # Next.js App Router
   │   ├── layout.tsx      # Root layout (global nav, metadata)
   │   ├── page.tsx        # Landing page (/)
   │   ├── cv/
   │   │   └── page.tsx    # CV route
   │   ├── projects/
   │   │   ├── page.tsx    # Projects list
   │   │   └── [slug]/
   │   │       └── page.tsx  # Dynamic project detail
   │   └── contact/
   │       └── page.tsx    # Contact page
   ├── components/         # Reusable components
   │   ├── Section.tsx     # Content section wrapper
   │   └── Callout.tsx     # Highlighted content blocks
   ├── data/
   │   └── projects.ts     # Project registry (typed)
   └── lib/
       └── config.ts       # Environment config helpers
   ```
   ```

4. **Scalability Patterns** (new section)
   ```markdown
   ## Scalability Patterns
   
   **Current (Phase 2):**
   - Static project data in TypeScript (typed, version-controlled)
   - Manual content updates via code changes + PRs
   - Evidence links hardcoded per project
   
   **Planned (Phase 3+):**
   - CMS or API-driven project data (Contentful, headless CMS)
   - Automated evidence link validation
   - Tag-based filtering and search
   ```

**Action:**
```bash
code /home/seven30/src/portfolio/portfolio-docs/docs/60-projects/portfolio-app/02-architecture.md
```

---

#### 3c. Update `04-security.md` (1 hour)

**Location:** `/home/seven30/src/portfolio/portfolio-docs/docs/60-projects/portfolio-app/04-security.md`

**Add/Update Sections:**

1. **Public-Safety Rules (Enforced)** (new section)
   ```markdown
   ## Public-Safety Rules (Enforced)
   
   ### Environment Variables
   - ✅ All `NEXT_PUBLIC_*` variables are client-visible by design
   - ✅ No secrets in any `NEXT_PUBLIC_*` variable
   - ✅ `.env.example` documents all required variables
   - ✅ Local `.env.local` gitignored
   
   **Validation procedure:**
   ```bash
   # Check for secrets in env vars
   grep -r "NEXT_PUBLIC.*SECRET\|NEXT_PUBLIC.*KEY\|NEXT_PUBLIC.*TOKEN" src/
   # Should return: no results
   
   # Verify secrets scanning gate
   pnpm secrets:scan
   # Should pass with no detections
   ```
   
   ### Dependencies
   - ✅ CodeQL scanning (JS/TS) on PR + weekly schedule
   - ✅ Dependabot weekly updates (grouped, majors excluded)
   - ✅ Frozen lockfile in CI (`pnpm install --frozen-lockfile`)
   
   ### CI/CD Pipeline
   - ✅ Least-privilege permissions (scoped per job)
   - ✅ Secrets scanning gate (TruffleHog, PR-only)
   - ✅ Required checks before merge (quality, secrets-scan, build, CodeQL)
   ```

2. **Security Controls (Phase 2)** (update existing or new)
   ```markdown
   ## Security Controls (Phase 2)
   
   | Control | Status | Evidence |
   |---------|--------|----------|
   | Secrets scanning (CI) | ✅ Enforced | [ci.yml](https://github.com/bryce-seefieldt/portfolio-app/blob/main/.github/workflows/ci.yml) |
   | Pre-commit secrets scan | ✅ Available | [.pre-commit-config.yaml](https://github.com/bryce-seefieldt/portfolio-app/blob/main/.pre-commit-config.yaml) |
   | Least-privilege CI perms | ✅ Enforced | [ci.yml job permissions](https://github.com/bryce-seefieldt/portfolio-app/blob/main/.github/workflows/ci.yml#L19-L22) |
   | CodeQL scanning | ✅ Enforced | [codeql.yml](https://github.com/bryce-seefieldt/portfolio-app/blob/main/.github/workflows/codeql.yml) |
   | Dependabot updates | ✅ Enabled | [dependabot.yml](https://github.com/bryce-seefieldt/portfolio-app/blob/main/.github/dependabot.yml) |
   | Threat model | ✅ Complete | [portfolio-app-threat-model.md](/docs/40-security/threat-models/portfolio-app-threat-model.md) |
   | Incident response | ✅ Ready | [rbk-portfolio-secrets-incident.md](/docs/50-operations/runbooks/rbk-portfolio-secrets-incident.md) |
   ```

**Action:**
```bash
code /home/seven30/src/portfolio/portfolio-docs/docs/60-projects/portfolio-app/04-security.md
```

---

#### 3d. Verify Other Dossier Pages (30 min)

**Files to review (should already be comprehensive):**
- ✅ `03-deployment.md` — Verify smoke test references, CI hardening notes
- ✅ `05-testing.md` — Verify Playwright details, Phase 2 enhancements
- ✅ `06-operations.md` — Verify runbook references
- ✅ `07-troubleshooting.md` — Verify comprehensive coverage
- ✅ `index.md` — Update with Phase 2 current state

**Action:**
```bash
# Quick review of each file
cat /home/seven30/src/portfolio/portfolio-docs/docs/60-projects/portfolio-app/03-deployment.md | head -50
cat /home/seven30/src/portfolio/portfolio-docs/docs/60-projects/portfolio-app/05-testing.md | head -50
# etc.
```

**Success Criteria:**
- [ ] All 7 dossier files enhanced to gold standard
- [ ] Executive summary, key metrics, "what this proves" added to overview
- [ ] Technology stack inventory and flow diagrams added to architecture
- [ ] Public-safety rules and Phase 2 controls added to security
- [ ] Build passes (`pnpm build`)
- [ ] PR created with dossier enhancements

---

### Priority 3: Create Gold Standard Project Page (STEP 6) — 2–3 hours

**Goal:** Create `/projects/portfolio-app` page that highlights gold standard status and comprehensive evidence.

**File to Create/Enhance:**

**Location:** `/home/seven30/src/portfolio/portfolio-app/src/app/projects/portfolio-app/page.tsx`

**Note:** This route already exists (per smoke tests), but needs gold-standard enhancement.

**Enhancement Approach:**

1. **Add "Gold Standard Badge" Component**

Create `/home/seven30/src/portfolio/portfolio-app/src/components/GoldStandardBadge.tsx`:

```typescript
export function GoldStandardBadge() {
  return (
    <div className="inline-flex items-center gap-2 rounded-full border border-amber-500 bg-amber-50 px-3 py-1 text-sm font-medium text-amber-900 dark:border-amber-400 dark:bg-amber-950 dark:text-amber-100">
      <svg
        className="h-4 w-4"
        fill="none"
        stroke="currentColor"
        viewBox="0 0 24 24"
      >
        <path
          strokeLinecap="round"
          strokeLinejoin="round"
          strokeWidth={2}
          d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"
        />
      </svg>
      Gold Standard Exemplar
    </div>
  );
}
```

2. **Enhance Project Detail Page**

Update `/home/seven30/src/portfolio/portfolio-app/src/app/projects/portfolio-app/page.tsx`:

```typescript
import { Section } from '@/components/Section';
import { Callout } from '@/components/Callout';
import { GoldStandardBadge } from '@/components/GoldStandardBadge';
import { docsUrl } from '@/lib/config';

export default function PortfolioAppProjectPage() {
  return (
    <div className="flex flex-col gap-8">
      <header className="flex flex-col gap-3">
        <GoldStandardBadge />
        <h1 className="text-3xl font-semibold tracking-tight">
          Portfolio App
        </h1>
        <p className="max-w-3xl text-zinc-700 dark:text-zinc-300">
          A production TypeScript web application demonstrating enterprise-grade
          engineering discipline: CI/CD governance, automated testing, threat modeling,
          operational runbooks, and evidence-first documentation.
        </p>
      </header>

      <Section title="What This Project Proves">
        <div className="grid gap-4 md:grid-cols-2">
          <div>
            <h3 className="font-medium text-zinc-900 dark:text-white">
              Technical Competency
            </h3>
            <ul className="mt-2 space-y-1 text-sm text-zinc-700 dark:text-zinc-300">
              <li>• Next.js 15+ (App Router, React Server Components)</li>
              <li>• TypeScript 5+ (strict mode)</li>
              <li>• Tailwind CSS 4 (responsive design)</li>
              <li>• Evidence-first UX</li>
            </ul>
          </div>
          
          <div>
            <h3 className="font-medium text-zinc-900 dark:text-white">
              Engineering Discipline
            </h3>
            <ul className="mt-2 space-y-1 text-sm text-zinc-700 dark:text-zinc-300">
              <li>• CI quality gates (lint, format, typecheck, secrets scan)</li>
              <li>• Automated smoke testing (Playwright)</li>
              <li>• Frozen lockfile builds (determinism)</li>
              <li>• PR-only merge discipline</li>
            </ul>
          </div>
          
          <div>
            <h3 className="font-medium text-zinc-900 dark:text-white">
              Security Awareness
            </h3>
            <ul className="mt-2 space-y-1 text-sm text-zinc-700 dark:text-zinc-300">
              <li>• Public-safe by design (no secrets)</li>
              <li>• CodeQL + Dependabot (supply chain)</li>
              <li>• Least-privilege CI permissions</li>
              <li>• Secrets incident response runbook</li>
            </ul>
          </div>
          
          <div>
            <h3 className="font-medium text-zinc-900 dark:text-white">
              Operational Maturity
            </h3>
            <ul className="mt-2 space-y-1 text-sm text-zinc-700 dark:text-zinc-300">
              <li>• Deploy/rollback runbooks</li>
              <li>• CI triage procedures</li>
              <li>• Vercel promotion gating</li>
              <li>• Evidence-based release notes</li>
            </ul>
          </div>
        </div>
      </Section>

      <Section title="Verification Checklist">
        <Callout type="info">
          Independent reviewers can validate these claims by following the evidence links below.
        </Callout>
        
        <div className="mt-4 space-y-2 text-sm">
          <div className="flex items-start gap-2">
            <span className="text-zinc-500">✓</span>
            <span>
              <strong>Architecture:</strong>{' '}
              <a href={docsUrl('projects/portfolio-app/architecture')} className="underline">
                Complete tech stack inventory and flow diagrams
              </a>
            </span>
          </div>
          
          <div className="flex items-start gap-2">
            <span className="text-zinc-500">✓</span>
            <span>
              <strong>Security:</strong>{' '}
              <a href={docsUrl('security/threat-models/portfolio-app-threat-model')} className="underline">
                STRIDE threat model with 12 scenarios
              </a>
            </span>
          </div>
          
          <div className="flex items-start gap-2">
            <span className="text-zinc-500">✓</span>
            <span>
              <strong>Testing:</strong>{' '}
              <a href="https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/smoke.spec.ts" className="underline">
                Playwright smoke tests (100% route coverage)
              </a>
            </span>
          </div>
          
          <div className="flex items-start gap-2">
            <span className="text-zinc-500">✓</span>
            <span>
              <strong>Operations:</strong>{' '}
              <a href={docsUrl('operations/runbooks/rbk-portfolio-deploy')} className="underline">
                Deploy, CI triage, secrets incident runbooks
              </a>
            </span>
          </div>
          
          <div className="flex items-start gap-2">
            <span className="text-zinc-500">✓</span>
            <span>
              <strong>CI/CD:</strong>{' '}
              <a href="https://github.com/bryce-seefieldt/portfolio-app/blob/main/.github/workflows/ci.yml" className="underline">
                4 required checks (quality, secrets-scan, build, CodeQL)
              </a>
            </span>
          </div>
        </div>
      </Section>

      <Section title="Deep Evidence">
        <div className="grid gap-4 md:grid-cols-2">
          <div>
            <h3 className="font-medium text-zinc-900 dark:text-white">
              Documentation
            </h3>
            <ul className="mt-2 space-y-1 text-sm">
              <li>
                <a href={docsUrl('projects/portfolio-app/')} className="underline">
                  Complete Project Dossier (7 pages)
                </a>
              </li>
              <li>
                <a href={docsUrl('architecture/adr/')} className="underline">
                  Architecture Decision Records
                </a>
              </li>
              <li>
                <a href={docsUrl('portfolio/roadmap')} className="underline">
                  Program Roadmap
                </a>
              </li>
            </ul>
          </div>
          
          <div>
            <h3 className="font-medium text-zinc-900 dark:text-white">
              Source & CI
            </h3>
            <ul className="mt-2 space-y-1 text-sm">
              <li>
                <a href="https://github.com/bryce-seefieldt/portfolio-app" className="underline">
                  GitHub Repository
                </a>
              </li>
              <li>
                <a href="https://github.com/bryce-seefieldt/portfolio-app/actions" className="underline">
                  CI/CD Pipeline Runs
                </a>
              </li>
              <li>
                <a href="https://github.com/bryce-seefieldt/portfolio-app/security" className="underline">
                  Security & Dependabot
                </a>
              </li>
            </ul>
          </div>
        </div>
      </Section>

      <Section title="Tech Stack">
        <div className="flex flex-wrap gap-2">
          {['Next.js 15+', 'React 19+', 'TypeScript 5+', 'Tailwind CSS 4', 'Playwright', 'Vercel', 'pnpm'].map((tech) => (
            <span
              key={tech}
              className="rounded-full border border-zinc-200 px-3 py-1 text-sm text-zinc-700 dark:border-zinc-800 dark:text-zinc-300"
            >
              {tech}
            </span>
          ))}
        </div>
      </Section>
    </div>
  );
}
```

**Action:**
```bash
# Create badge component
code /home/seven30/src/portfolio/portfolio-app/src/components/GoldStandardBadge.tsx

# Enhance project page
code /home/seven30/src/portfolio/portfolio-app/src/app/projects/portfolio-app/page.tsx
```

**Success Criteria:**
- [ ] Gold standard badge component created
- [ ] Project detail page enhanced with comprehensive sections
- [ ] Verification checklist guides independent reviewers
- [ ] All evidence links resolve correctly
- [ ] Smoke tests pass
- [ ] PR created with gold standard project page

---

### Priority 4: Enhance CV Page (STEP 7) — 2–3 hours

**Goal:** Transform CV skeleton into meaningful capability-to-proof mapping.

**File to Enhance:**

**Location:** `/home/seven30/src/portfolio/portfolio-app/src/app/cv/page.tsx`

**Enhancement Approach:**

1. **Create Timeline Data Structure**

Add to `/home/seven30/src/portfolio/portfolio-app/src/data/cv.ts` (new file):

```typescript
import { docsUrl } from '@/lib/config';

export interface TimelineEntry {
  title: string;
  organization: string;
  period: string;
  description: string;
  keyCapabilities: string[];
  proofs: Array<{
    text: string;
    href: string;
  }>;
}

export const TIMELINE: TimelineEntry[] = [
  {
    title: 'Senior Software Engineer (Portfolio Program)',
    organization: 'Independent Project',
    period: '2026',
    description:
      'Building enterprise-grade portfolio application with comprehensive CI/CD, security controls, and documentation.',
    keyCapabilities: [
      'Next.js & React Architecture',
      'TypeScript (Strict Mode)',
      'CI/CD & Quality Gates',
      'Secrets Scanning & Security',
      'Threat Modeling (STRIDE)',
      'Operational Runbooks',
      'Evidence-First Documentation',
    ],
    proofs: [
      {
        text: 'Portfolio App Project Dossier',
        href: docsUrl('projects/portfolio-app/'),
      },
      {
        text: 'Threat Model (STRIDE Analysis)',
        href: docsUrl('security/threat-models/portfolio-app-threat-model'),
      },
      {
        text: 'CI/CD Workflow (4 Required Checks)',
        href: 'https://github.com/bryce-seefieldt/portfolio-app/blob/main/.github/workflows/ci.yml',
      },
      {
        text: 'Smoke Test Suite (Playwright)',
        href: 'https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/smoke.spec.ts',
      },
      {
        text: 'Operational Runbooks',
        href: docsUrl('operations/runbooks/'),
      },
    ],
  },
  // Add more entries as needed (past roles, education, certifications)
];
```

2. **Update CV Page**

Update `/home/seven30/src/portfolio/portfolio-app/src/app/cv/page.tsx`:

```typescript
import { Section } from '@/components/Section';
import { TIMELINE } from '@/data/cv';

export default function CVPage() {
  return (
    <div className="flex flex-col gap-8">
      <header className="flex flex-col gap-3">
        <h1 className="text-3xl font-semibold tracking-tight">
          Experience & Capabilities
        </h1>
        <p className="max-w-3xl text-zinc-700 dark:text-zinc-300">
          Evidence-first CV: each role links to proofs (projects, dossiers,
          architecture decisions, operational maturity).
        </p>
      </header>

      {TIMELINE.map((entry, idx) => (
        <Section
          key={idx}
          title={entry.title}
          subtitle={`${entry.organization} — ${entry.period}`}
        >
          <p className="mb-4 text-sm text-zinc-700 dark:text-zinc-300">
            {entry.description}
          </p>

          <div className="mb-4">
            <h4 className="font-medium text-zinc-900 dark:text-white">
              Key Capabilities
            </h4>
            <div className="mt-2 flex flex-wrap gap-2">
              {entry.keyCapabilities.map((cap) => (
                <span
                  key={cap}
                  className="rounded-full border border-zinc-200 px-2 py-1 text-xs text-zinc-700 dark:border-zinc-800 dark:text-zinc-300"
                >
                  {cap}
                </span>
              ))}
            </div>
          </div>

          <div>
            <h4 className="font-medium text-zinc-900 dark:text-white">
              Proofs & Evidence
            </h4>
            <ul className="mt-2 list-disc space-y-1 pl-5 text-sm">
              {entry.proofs.map((proof, pIdx) => (
                <li key={pIdx}>
                  <a
                    className="underline hover:text-zinc-950 dark:hover:text-white"
                    href={proof.href}
                  >
                    {proof.text}
                  </a>
                </li>
              ))}
            </ul>
          </div>
        </Section>
      ))}
    </div>
  );
}
```

**Action:**
```bash
# Create CV data file
code /home/seven30/src/portfolio/portfolio-app/src/data/cv.ts

# Update CV page
code /home/seven30/src/portfolio/portfolio-app/src/app/cv/page.tsx
```

**Success Criteria:**
- [ ] CV data structure created with capability-to-proof mapping
- [ ] CV page displays timeline with evidence links
- [ ] Each entry links to dossiers, threat models, runbooks
- [ ] Evidence links resolve in smoke tests
- [ ] Smoke tests pass
- [ ] PR created with CV enhancement

---

### Priority 5: Create Phase 2 Release Note (STEP 8) — 1–2 hours

**Goal:** Document Phase 2 completion milestone.

**File to Create:**

**Location:** `/home/seven30/src/portfolio/portfolio-docs/docs/00-portfolio/release-notes/20260120-portfolio-app-phase-2-gold-standard.md`

**Template Structure:**

```markdown
---
title: 'Release Notes: Portfolio App Phase 2 Complete (Gold Standard Project)'
description: 'Phase 2 completion: comprehensive dossier, smoke tests, threat model, enhanced CV, and gold standard project page.'
tags: [release-notes, portfolio-app, phase-2, gold-standard]
date: 2026-01-20
---

# Release Notes: Portfolio App Phase 2 Complete (Gold Standard Project)

## Summary

Phase 2 establishes credibility through one exemplary "gold standard" project. The Portfolio App itself serves as the proof, with comprehensive documentation, automated testing, STRIDE threat model, and operational procedures.

**Status:** ✅ **Phase 2 Complete** (2026-01-20)

---

## Highlights

- **Gold standard project page** with verification checklist and deep evidence links
- **Smoke test infrastructure** (Playwright) with 100% route coverage (12 tests)
- **Enhanced dossier** with executive summary, key metrics, "what this proves" sections
- **STRIDE threat model** documenting 12 threat scenarios and mitigations
- **Phase 2 security enhancements:** Secrets scanning, CI hardening, incident response runbook
- **Enhanced CV page** with capability-to-proof mapping
- **Gold standard badge** component highlighting exemplary quality

---

## Added

### Portfolio App Features

- **Gold Standard Project Page:**
  - Badge component highlighting exemplar status
  - "What this project proves" section (4 categories: technical, engineering, security, operations)
  - Verification checklist for independent reviewers
  - Deep evidence links to dossier, threat model, ADRs, runbooks

- **Enhanced CV Page:**
  - Timeline structure with capability-to-proof mapping
  - Each entry links to projects, dossiers, threat models, runbooks
  - Evidence-first hiring approach demonstration

- **Smoke Test Suite (Playwright):**
  - Route accessibility tests (all 5 core routes)
  - Content rendering validation
  - Evidence link integrity checks
  - Integrated into CI (required before merge)

### Documentation Artifacts

- **Enhanced Project Dossier:**
  - Executive summary (overview)
  - Key metrics (quantified Phase 2 baseline)
  - "What this proves" sections (technical, engineering, security, operations)
  - Complete tech stack inventory (architecture)
  - Public-safety rules and Phase 2 controls (security)

- **Threat Model (STRIDE):**
  - Trust boundary diagram
  - 12 threat scenarios across 6 STRIDE categories
  - Mitigation controls documented
  - Residual risks accepted

- **Phase 2 Security Enhancements:**
  - Secrets scanning CI gate (TruffleHog)
  - Pre-commit secrets scanning hook
  - Least-privilege CI permissions (scoped per job)
  - Secrets incident response runbook (5-phase procedure)

---

## Changed

### Project Detail Page
- Added gold standard badge
- Enhanced evidence links section
- Added verification checklist

### CV Page
- Converted from skeleton to comprehensive timeline
- Added capability-to-proof mapping
- Linked each role to evidence artifacts

### Dossier Pages
- Overview: Added executive summary, key metrics, "what this proves"
- Architecture: Added tech stack inventory, flow diagrams, scalability patterns
- Security: Added public-safety rules, Phase 2 controls table

---

## Verification (Phase 2 Success Criteria — All Complete ✅)

- ✅ One "gold standard" project page is fully polished
- ✅ Comprehensive dossier covers architecture, security, deployment, operations
- ✅ STRIDE threat model documents security posture and controls
- ✅ Operational runbooks complete (deploy, CI triage, rollback, secrets incident)
- ✅ Smoke tests validate all core routes and evidence links
- ✅ CV page maps capabilities to proofs
- ✅ A reviewer can validate senior-level engineering discipline through one project
- ✅ All evidence links resolve correctly

---

## Architecture & Governance References

- [Portfolio App Dossier](/docs/60-projects/portfolio-app/)
- [Threat Model: Portfolio App](/docs/40-security/threat-models/portfolio-app-threat-model.md)
- [ADR-0010: Portfolio App as Gold Standard Exemplar](/docs/10-architecture/adr/adr-0010-portfolio-app-as-gold-standard-exemplar.md)
- Operational Runbooks:
  - [Deploy Runbook](/docs/50-operations/runbooks/rbk-portfolio-deploy.md)
  - [CI Triage Runbook](/docs/50-operations/runbooks/rbk-portfolio-ci-triage.md)
  - [Rollback Runbook](/docs/50-operations/runbooks/rbk-portfolio-rollback.md)
  - [Secrets Incident Response](/docs/50-operations/runbooks/rbk-portfolio-secrets-incident.md)

---

## What's Next (Phase 3)

- Repeatable project publishing pipeline
- Data-driven project registry with validation
- Unit tests (Vitest) for content/slug validation
- CMS integration (optional)
- Tag-based filtering and search

---

**Owner:** Architecture & Documentation  
**Updated:** 2026-01-20
```

**Action:**
```bash
code /home/seven30/src/portfolio/portfolio-docs/docs/00-portfolio/release-notes/20260120-portfolio-app-phase-2-gold-standard.md
```

**Success Criteria:**
- [ ] Release note created with comprehensive Phase 2 summary
- [ ] All deliverables documented
- [ ] Evidence links verified
- [ ] Build passes
- [ ] PR created with release note

---

## Summary Checklist

Use this checklist to track overall Phase 2 completion:

### Documentation (portfolio-docs)
- [ ] Threat model PR #32 merged
- [ ] Dossier `01-overview.md` enhanced (executive summary, metrics, "what this proves")
- [ ] Dossier `02-architecture.md` enhanced (tech stack, flow diagrams, scalability)
- [ ] Dossier `04-security.md` enhanced (public-safety rules, Phase 2 controls)
- [ ] Other dossier pages verified complete
- [ ] Release note created (Phase 2 completion)

### Application (portfolio-app)
- [ ] Gold standard badge component created
- [ ] Project detail page enhanced (gold standard content)
- [ ] CV data structure created (`src/data/cv.ts`)
- [ ] CV page enhanced (capability-to-proof mapping)
- [ ] Smoke tests pass for all new content
- [ ] Build passes locally (`pnpm build`)

### PRs Created
- [ ] portfolio-docs: Dossier enhancements PR
- [ ] portfolio-app: Gold standard project page PR
- [ ] portfolio-app: CV enhancement PR
- [ ] portfolio-docs: Phase 2 release note PR

### Final Validation
- [ ] All evidence links resolve correctly
- [ ] Smoke tests cover all routes (including enhanced pages)
- [ ] CI passes on all PRs
- [ ] Phase 2 acceptance criteria met (per roadmap)

---

## Estimated Timeline

| Task | Estimated Time | Priority |
|------|---------------|----------|
| Merge threat model PR #32 | 1 hour | P1 |
| Enhance dossier (3 files) | 4–6 hours | P2 |
| Create gold standard project page | 2–3 hours | P3 |
| Enhance CV page | 2–3 hours | P4 |
| Create Phase 2 release note | 1–2 hours | P5 |
| **Total** | **10–15 hours** | |

---

## Getting Started

```bash
# 1. Pull latest from both repos
cd /home/seven30/src/portfolio/portfolio-app && git pull
cd /home/seven30/src/portfolio/portfolio-docs && git pull

# 2. Start with Priority 1 (merge threat model)
cd /home/seven30/src/portfolio/portfolio-docs
gh pr view 32
gh pr merge 32 --squash

# 3. Continue with dossier enhancements (Priority 2)
code docs/60-projects/portfolio-app/01-overview.md
# ... follow guide above
```

---

**Owner:** Portfolio Program  
**Phase:** Phase 2 (Gold Standard Project)  
**Updated:** 2026-01-20
