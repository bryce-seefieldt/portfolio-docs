---
title: 'Phase 2 Implementation Guide: Gold Standard Project & Credibility Baseline'
description: 'Step-by-step guide to Phase 2 implementation, including smoke tests, gold standard project development, CV enhancement, evidence artifacts, and documentation updates.'
tags: [phase-2, implementation, portfolio-app, testing, projects, operations]
date: 2026-01-17
---

# Phase 2 Implementation Guide: Gold Standard Project & Credibility Baseline

## Overview

Phase 2 transforms the Portfolio App from a "professional foundation" into a "credible engineering portfolio." The focus is on creating one exemplary project that demonstrates senior-level engineering discipline and using that as the template for all future portfolio entries.

**Duration:** ~2–3 weeks (assuming 10–15 hrs/week)

**Key outputs:**

- Smoke test infrastructure (Playwright or similar)
- One "gold standard" project page with full evidence trail
- Enhanced CV page with capability-to-proof mapping
- Complete dossier, threat model, and runbooks for the chosen project
- Updated documentation reflecting new standards

---

## Phase 2 Objectives (from Roadmap)

### Portfolio App deliverables

1. **One polished "gold standard" project page**
   - What it is, what it proves
   - Repo + demo links
   - Evidence links (dossier, threat model, runbooks)
   - Public-safe screenshots/diagrams

2. **Meaningful CV page**
   - Employment/impact timeline
   - Capability-to-proof mapping (links to projects and evidence)

3. **Smoke test infrastructure** (prerequisite for scaling)
   - Basic route validation tests
   - Content/slug validation
   - Evidence link integrity checks

### Documentation App deliverables

1. **Project dossier for gold standard project**
   - Overview, architecture, deployment, security, testing, operations, troubleshooting

2. **At least 1 ADR** for a durable decision in the chosen project

3. **Threat model** (if the project introduces meaningful surface)

4. **Runbooks** (if the project is deployed/operated)

5. **Release note** marking the Phase 2 milestone

### Acceptance criteria

A reviewer can validate senior-level engineering discipline through a single project:

- "What, why, how" clarity
- Security posture and controls
- Operational readiness and reproducibility
- Testing and quality discipline

---

## Phase 2 Implementation Steps (Step-by-Step)

### STEP 1: Decide on the "Gold Standard" Project (1–2 hours)

**Goal:** Choose which project will be your exemplary case study.

**Options:**

- **portfolio-app itself** (what you're building now): Advantage—already deployed, live evidence, deep governance records
- **portfolio-docs** (the documentation system): Advantage—also deployed, demonstrates ops maturity
- **A past project** (if public/shareable): Advantage—potentially more complex real-world example
- **A mini-demonstration project** (written as part of Phase 2): Advantage—can be designed specifically to showcase capabilities

**Recommendation for your situation:**
Start with **portfolio-app** as the gold standard. Rationale:

- Already deployed and operational
- Demonstrates full SDLC (Phase 1 already documented)
- Can showcase governance, testing, observability
- Sets precedent for all future projects

**Action items:**

1. ✅ **Decision documented in ADR-0010** — see [ADR-0010: Portfolio App as Gold Standard Exemplar](/docs/10-architecture/adr/adr-0010-portfolio-app-as-gold-standard-exemplar.md)
   - Portfolio App selected as the exemplary project
   - Rationale, consequences, and implementation approach documented
   - Alternatives considered and rejected

2. Create GitHub issue in `portfolio-app` repo titled: `Phase 2: Portfolio App as Gold Standard Exemplar Project`
   - Issue template: [GITHUB_ISSUE_TEMPLATE_PHASE2.md](https://github.com/bryce-seefieldt/portfolio-app/tree/main/GITHUB_ISSUE_TEMPLATE_PHASE2.md)
   - Tracks all Phase 2 deliverables (portfolio-app + portfolio-docs)
   - Links to ADR-0010
   - Assign to yourself; label `phase-2`

3. Create GitHub issue in `portfolio-docs` repo for documentation work
   - Dossier, threat model, runbooks, ADR, release note
   - Link back to portfolio-app issue for cross-repo visibility

**Success check:**

- [x] Gold standard project decided: **portfolio-app**
- [x] Decision documented in ADR-0010
- [x] [GitHub issue #9 created in portfolio-app repo](https://github.com/bryce-seefieldt/portfolio-app/issues/9)
- [x] [GitHub issue #24 created in portfolio-docs repo](https://github.com/bryce-seefieldt/portfolio-docs/issues/24)
- [x] ADR-0010 linked from both issues

---

### STEP 2: Set Up Smoke Test Infrastructure (3–5 hours)

**Goal:** Create test infrastructure that validates core routes, content, and evidence links.

**Tools:** Playwright (recommended) or Vitest for unit-style content validation

**Implementation:**

#### 2a. Install test dependencies

```bash
cd portfolio-app
pnpm add -D @playwright/test
```

#### 2b. Create Playwright configuration

Create `playwright.config.ts` at repo root:

```typescript
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests/e2e',
  fullyParallel: false,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: 'html',
  use: {
    baseURL: process.env.PLAYWRIGHT_TEST_BASE_URL || 'http://localhost:3000',
    trace: 'on-first-retry',
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },
  ],
  webServer: process.env.CI
    ? undefined
    : {
        command: 'pnpm dev',
        url: 'http://localhost:3000',
        reuseExistingServer: !process.env.CI,
      },
});
```

#### 2c. Create smoke test suite

Create `tests/e2e/smoke.spec.ts`:

```typescript
import { test, expect } from '@playwright/test';

const ROUTES = [
  { path: '/', title: 'Portfolio App' },
  { path: '/cv', title: 'CV' },
  { path: '/projects', title: 'Projects' },
  { path: '/contact', title: 'Contact' },
  { path: '/projects/portfolio-app', title: 'Portfolio App' },
];

test.describe('Smoke tests', () => {
  ROUTES.forEach(({ path, title }) => {
    test(`Route ${path} should render`, async ({ page }) => {
      const response = await page.goto(path);
      expect(response?.status()).toBeLessThan(400);
      // Basic content check
      expect(page.locator('h1')).toBeTruthy();
    });
  });

  test('Evidence links resolve to docs', async ({ page }) => {
    await page.goto('/projects/portfolio-app');
    const docsLink = page.locator('a[href*="/docs/"]').first();
    expect(docsLink).toBeTruthy();
  });

  test('Project registry has no broken slugs', async ({ page }) => {
    const { PROJECTS } = await import('../src/data/projects');
    for (const project of PROJECTS) {
      const response = await page.goto(`/projects/${project.slug}`);
      if (project.status !== 'planned') {
        expect(response?.status()).toBeLessThan(400);
      }
    }
  });
});
```

#### 2d. Add test script to `package.json`

```json
{
  "scripts": {
    "test": "playwright test",
    "test:ui": "playwright test --ui",
    "test:debug": "playwright test --debug"
  }
}
```

#### 2e. Add tests to CI workflow

Update `.github/workflows/ci.yml` to include:

```yaml
- name: Run smoke tests
  run: pnpm test
  continue-on-error: false
```

#### 2f. Update `.gitignore`

```
test-results/
playwright-report/
```

**Success check:**

- [x] Playwright installed and configured
- [x] Smoke test suite runs locally: `pnpm test`
- [x] Tests pass on `pnpm dev` server
- [x] Test script added to package.json
- [x] Tests integrated into CI workflow
- [x] PR created with test infrastructure ([PR #10](https://github.com/bryce-seefieldt/portfolio-app/pull/10))

**Files to create/modify:**

- [x] `playwright.config.ts` (new)
- [x] `tests/e2e/smoke.spec.ts` (new)
- [x] `package.json` (update scripts)
- [x] `.github/workflows/ci.yml` (add test step)
- [x] `.gitignore` (add test results)

---

### STEP 3: Create Gold Standard Project Dossier (4–6 hours)

**Goal:** Document the chosen project comprehensively with enterprise-standard sections.

**Location:** `/portfolio-docs/docs/60-projects/portfolio-app/00-dossier.md` (or `01-overview.md`, depending on your naming)

**Structure:**

````markdown
---
title: 'Portfolio App: Complete Dossier'
description: 'Comprehensive documentation of the Portfolio App...'
tags: [projects, portfolio-app, dossier, governance]
---

# Portfolio App: Complete Dossier

## Executive Summary

[1 paragraph overview of what the app does, who built it, what business value it delivers]

## I. Overview

### What is this?

[What the app does, core surfaces, who uses it]

### What does it prove?

[What this project demonstrates about engineering discipline]

### Key metrics

- Lines of code: ~500
- Routes: 5 core routes
- CI checks: 2 (quality, build)
- Test coverage: Smoke tests (100% routes)
- Deployment frequency: On every merge to main
- Mean time to rollback: ~1 minute (Git revert)

---

## II. Architecture

### Design goals

- Evidence-first UX (links to deep technical artifacts)
- Public-safe by design (no secrets, no internal endpoints)
- Scalable project registry (static data → eventual CMS/API)
- Enterprise SDLC posture (docs-as-code, governance, transparency)

### Technology stack

- **Framework:** Next.js (App Router)
- **Language:** TypeScript (strict mode)
- **Styling:** Tailwind CSS + custom CSS
- **Build tool:** pnpm (frozen lockfile in CI)
- **Hosting:** Vercel (preview + production)
- **CI:** GitHub Actions
- **Governance:** GitHub Rulesets, Deployment Checks

### High-level flow

[ASCII diagram or detailed description of request → routing → rendering → output]

### Key dependencies

- next: v15+
- react: v19+
- typescript: v5.x
- tailwind: latest
- [List others briefly; note if any are notable for security/compliance]

---

## III. Security Posture

### Threat Model

[Link to threat model document]

### Public-safety rules (enforced)

- No `NEXT_PUBLIC_*` variables contain secrets
- No internal endpoints or API keys in code
- All environment variables documented in `.env.example`
- No database connections or backend logic

### Authentication & authorization

- Not implemented (intentionally)
- Future iterations: Consider static site generation or API-based auth for optional "member-only" content

### Data handling

- No user data collection or storage
- All content is static or environment-driven
- Links to docs are public-safe (same origin or documented external domain)

### Secrets scanning & supply chain

- CodeQL enabled (JavaScript/TypeScript)
- Dependabot enabled (weekly; majors excluded)
- PR template includes "no secrets added" declaration

---

## IV. Development & Testing

### Local development

```bash
pnpm install
cp .env.example .env.local
pnpm dev
```
````

### Quality gates (enforced)

```bash
pnpm lint       # ESLint
pnpm format:check  # Prettier
pnpm typecheck  # TypeScript
pnpm build      # Next.js production build
pnpm test       # Playwright smoke tests
```

### Testing strategy

- **Smoke tests (Playwright):** Route accessibility, content rendering, evidence link integrity
- **Unit tests (planned for Phase 3):** Content/slug validation, config module
- **E2E tests (planned for Phase 3+):** Full user flows, evidence link resolution

### Test coverage

- Core routes: ✅ 100% (smoke tests)
- Content validation: 🟡 Partial (manual + data-driven validation)
- Evidence links: ✅ Spot-checked in smoke tests

---

## V. Deployment

### Environments

- **Preview:** Auto-generated per PR (via Vercel)
- **Production:** `main` branch, gated by required checks

### Deployment process

1. Create PR with code changes
2. GitHub Actions runs `ci / quality` and `ci / build` checks
3. Vercel creates preview deployment (auto-generated URL)
4. Merge when checks pass (GitHub Ruleset enforces this)
5. Vercel creates production deployment (automatic after merge)

### Environment variables

[Link to deployment dossier for complete environment configuration]

### Rollback

- Revert the commit: `git revert <hash>`
- Wait for checks to pass
- Merge revert PR
- Vercel automatically deploys reverted code

**Mean time to rollback:** ~1 minute

---

## VI. Operations & Observability

### Monitoring (current)

- Vercel analytics (built-in)
- GitHub Actions CI logs
- Manual spot-checks of production domain

### Observability (planned for Phase 3+)

- Application logging (Vercel logs)
- Performance metrics (Web Vitals)
- Error tracking (optional, light-weight)

### Incidents & postmortems

- Process: [Link to incident response process or postmortem template]
- Escalation: [Who to notify if production is down]

---

## VII. Known Limitations

- No backend processing
- Static project registry (planned to evolve)
- No user authentication
- No database or persistent state

---

## VIII. Troubleshooting & Runbooks

[Links to operational runbooks — created in Phase 2, Step 5]

- Deploy runbook (created in Phase 2)
- CI triage runbook (created in Phase 2)
- Rollback runbook (created in Phase 2)

---

## IX. Related Artifacts

- [ADR-0007: Vercel + Promotion Checks](/docs/10-architecture/adr/adr-0007-portfolio-app-hosting-vercel-with-promotion-checks.md)
- [ADR-0008: CI Quality Gates](/docs/10-architecture/adr/adr-0008-portfolio-app-ci-quality-gates.md)
- [Threat Model: Portfolio App](/docs/40-security/threat-models/portfolio-app-threat-model.md)
- [Deployment Dossier](/docs/60-projects/portfolio-app/03-deployment.md)

---

## X. Change History

| Date       | Change                        | PR   |
| ---------- | ----------------------------- | ---- |
| 2026-01-10 | Phase 1 baseline              | #21  |
| 2026-01-17 | Phase 2 gold standard dossier | #TBD |

````

**Success check:**
- [ ] Dossier document created with all 10 sections
- [ ] Links to threat model, ADRs, runbooks added (placeholder if not yet created)
- [ ] Build verification passes
- [ ] PR created with dossier

---

### STEP 4: Create/Update Threat Model (2–3 hours)

**Goal:** Document security assumptions, threats, and controls for the project.

**Location:** `/portfolio-docs/docs/40-security/threat-models/portfolio-app-threat-model.md`

**Approach:** Use STRIDE or a simple trust boundary diagram.

**Template:**

```markdown
---
title: 'Threat Model: Portfolio App'
description: 'Security analysis of the Portfolio App...'
tags: [security, threat-model, portfolio-app]
---

# Threat Model: Portfolio App

## Trust Boundaries Diagram
[Simple ASCII diagram showing public users → portfolio app → docs app → GitHub]

## Assets at Risk
- Source code (GitHub)
- Deployment credentials (Vercel)
- Custom domain (DNS)
- Reputation (if compromised)

## Threats (STRIDE)

### Spoofing
- **Threat:** Attacker spoofs the portfolio domain
- **Mitigation:** Use TLS/HTTPS, HSTS header, domain registration lock

### Tampering
- **Threat:** Attacker modifies deployed content
- **Mitigation:** Deployments only via authenticated Git + Vercel; no manual edits

### Repudiation
- **Threat:** Attacker denies making changes
- **Mitigation:** Git commit audit trail; GitHub Actions logs

### Information Disclosure
- **Threat:** Attacker exfiltrates environment variables or secrets
- **Mitigation:** No secrets in `NEXT_PUBLIC_*` variables; secrets never committed

### Denial of Service
- **Threat:** Attacker floods the app or docs domain
- **Mitigation:** Vercel DDoS protection; docs served as static files

### Elevation of Privilege
- **Threat:** Attacker gains elevated access to deployment pipeline
- **Mitigation:** GitHub Rulesets enforce PR reviews; required checks gate merges

## Residual Risks (Accepted)
- Dependabot alerts may not catch all zero-days immediately
- Manual review required for major dependency updates

## Controls Summary
- ✅ Code review (GitHub Rulesets + PR template)
- ✅ CI/CD gating (required checks)
- ✅ Supply chain: CodeQL + Dependabot
- ✅ Static deployment (no runtime secrets)
- ✅ Immutable deployments (Git revert only)
````

**Success check:**

- [ ] Threat model document created
- [ ] Trust boundaries identified
- [ ] STRIDE analysis complete
- [ ] Mitigations documented
- [ ] Residual risks accepted and reviewed
- [ ] Linked from dossier
- [ ] Build verification passes

---

### STEP 5: Create/Update Operational Runbooks (2–4 hours)

**Goal:** Document repeatable procedures for deployment, CI triage, and rollback.

**Files to create:**

#### 5a. Deploy Runbook

**Location:** `/docs/50-operations/runbooks/rbk-portfolio-deploy.md`

````markdown
---
title: 'Runbook: Deploy Portfolio App'
description: 'Step-by-step procedure for deploying changes to production.'
tags: [operations, runbooks, portfolio-app, deployment]
---

# Runbook: Deploy Portfolio App

## Overview

This runbook describes the standard deployment workflow for the Portfolio App.
Deployments are automatic after merge to `main` (no manual steps required).

## Prerequisites

- GitHub Ruleset requires passing checks before merge
- Vercel Deployment Checks verify production promotion readiness

## Procedure

### 1. Create PR with changes

```bash
git checkout -b feat/my-feature
# Make changes
pnpm lint
pnpm format:check
pnpm typecheck
pnpm build
git commit -am "feat: add my feature"
git push origin feat/my-feature
```
````

### 2. Open PR and wait for checks

- GitHub Actions runs `ci / quality` and `ci / build`
- Vercel creates preview deployment

### 3. Validate preview deployment

- Open preview URL from Vercel comment
- Test routes and evidence links
- Spot-check styling and rendering

### 4. Merge PR (GitHub Ruleset enforces checks)

- All checks must pass
- At least 1 review (configure as needed)
- Click "Merge" (Ruleset prevents merge if conditions not met)

### 5. Automatic production deployment

- Vercel monitors `main` branch
- After merge, Vercel runs same checks
- If checks pass, Vercel deploys to production domain
- Production domain updates automatically (no manual step)

## Rollback

If an issue is discovered post-deployment, see [rbk-portfolio-rollback.md](/docs/50-operations/runbooks/rbk-portfolio-rollback.md).

## Troubleshooting

- Checks fail: See [rbk-portfolio-ci-triage.md](/docs/50-operations/runbooks/rbk-portfolio-ci-triage.md)
- Preview doesn't update: Refresh Vercel dashboard or wait 2 minutes

````

#### 5b. CI Triage Runbook

**Location:** `/portfolio-docs/docs/50-operations/runbooks/rbk-portfolio-ci-triage.md`

```markdown
---
title: 'Runbook: CI Triage — Portfolio App'
description: 'How to diagnose and fix CI failures.'
tags: [operations, runbooks, portfolio-app, ci]
---

# Runbook: CI Triage — Portfolio App

## Quick diagnostics

| Symptom | Likely cause | Fix |
| --- | --- | --- |
| `ci / quality` fails | Lint, format, or typecheck error | Run `pnpm lint`, `pnpm format:check`, `pnpm typecheck` locally |
| `ci / build` fails | Next.js build error | Run `pnpm build` locally |
| Playwright tests fail | Route or content regression | Review test output; run `pnpm test --debug` |
| Vercel preview fails | Build succeeds but deployment fails | Check Vercel logs in deployment dashboard |

## Step-by-step triage

### 1. Identify which check failed
- Look at GitHub PR checks (scroll to "Checks" tab)
- Click on failed check name to see logs

### 2. Reproduce locally
```bash
git fetch origin
git checkout feat/my-feature
pnpm install
# Run the same command as CI
pnpm lint        # if ci/quality failed
pnpm build       # if ci/build failed
pnpm test        # if smoke tests failed
````

### 3. Fix the issue

- Edit source files to fix errors
- Rerun the command to verify

### 4. Commit and push

```bash
git add .
git commit -m "fix: resolve ci/quality lint error"
git push origin feat/my-feature
```

### 5. Monitor re-run

- GitHub Actions automatically re-runs checks
- Watch for green checkmarks on the PR

## Common issues and fixes

### ESLint errors

```bash
pnpm lint -- --fix
```

### Prettier formatting

```bash
pnpm format
```

### TypeScript type errors

- Open the file and fix based on error message
- No auto-fix for type errors

### Next.js build errors

- Usually caused by missing exports or dynamic import issues
- Check the build log for specific file and line

---

## Escalation

If issues persist after triage:

1. Check GitHub Actions logs for full error context
2. Verify `.env.local` has all required vars from `.env.example`
3. Clear `.next` cache: `rm -rf .next` and rebuild
4. Ask for help in team/community channels

````

#### 5c. Rollback Runbook

**Location:** `/portfolio-docs/docs/50-operations/runbooks/rbk-portfolio-rollback.md`

```markdown
---
title: 'Runbook: Rollback Portfolio App'
description: 'Emergency rollback procedure if production deployment has issues.'
tags: [operations, runbooks, portfolio-app, incident-response]
---

# Runbook: Rollback Portfolio App

## When to rollback
- Critical bug discovered in production
- Performance degradation observed
- Security issue identified and needs immediate remediation

## Rollback procedure

### 1. Identify the problematic commit
```bash
git log --oneline -10  # Find the commit to revert
````

### 2. Create revert commit

```bash
git checkout main
git pull origin main
git revert <commit-hash>  # Creates a new commit that undoes the change
git push origin main
```

### 3. Wait for checks and deployment

- GitHub Actions runs checks on the revert commit
- After checks pass, Vercel deploys the previous version to production
- **Time to rollback:** ~2–3 minutes

### 4. Verify rollback

- Open production domain
- Spot-check that issue is resolved

### 5. Investigate root cause

- Create a new branch to investigate
- Create ADR or incident postmortem documenting the issue

## Quick rollback (if needed immediately)

If waiting for CI is unacceptable, you can manually redeploy a previous commit in Vercel dashboard:

1. Go to Vercel project settings
2. Deployments → find good deployment
3. Click "Redeploy"
4. Confirm

(This bypasses GitHub checks, use only in true emergency)

## After rollback

1. Fix the underlying issue in a new PR
2. Add regression test to prevent repeat
3. Document lessons learned (postmortem)

````

**Success check:**
- [ ] Deploy runbook created and linked from dossier
- [ ] CI triage runbook created with common issues
- [ ] Rollback runbook created with both automated and manual steps
- [ ] All runbooks tested (at least mentally walkthrough)
- [ ] Links cross-reference correctly
- [ ] Build verification passes

---

### STEP 6: Create/Update ADRs for Phase 2 Decisions (1–2 hours)

**Goal:** Document any significant decisions made during Phase 2.

**Likely ADRs:**
- **Testing strategy** (Playwright for smoke tests, planned unit tests)
- **Gold standard project criteria** (what makes a project "gold standard")

**Example ADR:**

**Location:** `/portfolio-docs/docs/10-architecture/adr/adr-0009-portfolio-app-test-strategy.md`

```markdown
---
title: 'ADR-0000: Portfolio App Testing Strategy'
status: 'accepted'
date: 2026-01-17
tags: [adr, architecture, testing, portfolio-app]
---

# ADR-0000: Portfolio App Testing Strategy

## Context

The Portfolio App has reached Phase 2 (gold standard credibility baseline). To support this and future scaling, we need a clear testing strategy that:

1. Validates core functionality (routes, content, evidence links)
2. Catches regressions as we add features
3. Scales as the project registry grows
4. Integrates with CI/CD without adding excessive overhead

## Decision

We will adopt a **phased testing approach**:

### Phase 2 (now)
- **Smoke tests (Playwright):** Route accessibility, content rendering, evidence link integrity
- **Manual spot-checks:** Evidence links resolve to docs; styling renders correctly

### Phase 3 (planned)
- **Unit tests (Vitest):** Content validation (slug formats, required fields)
- **Property-based tests:** Ensure all projects in registry follow consistent schema

### Phase 3+ (future)
- **E2E tests (Playwright):** Full user flows, cross-domain evidence link validation
- **Performance tests:** Lighthouse CI for Core Web Vitals

## Rationale

1. **Start simple:** Smoke tests catch 80% of issues (broken routes, missing content) with minimal maintenance
2. **Progressive:** Add unit tests once content model stabilizes (Phase 3)
3. **Scale-ready:** Schema validation prevents inconsistent project data
4. **CI-friendly:** Tests run in ~2 minutes; fast feedback on PRs

## Consequences

- Smoke tests may not catch subtle bugs (UI logic, edge cases)
- Unit tests require schema formalization (good practice but more upfront work for Phase 3)
- E2E tests initially manual (acceptable for Phase 2 given low volume)

## Alternatives considered

1. **Full e2e tests from day 1:** Too much maintenance burden for current project size
2. **No tests initially:** Higher risk of regressions; harder to catch broken evidence links
3. **Only unit tests:** Wouldn't catch routing or integration issues

## Implementation

See: [Smoke test setup in Phase 2 guide]
````

**Success check:**

- [ ] ADR created for testing strategy (or other Phase 2 decision)
- [ ] Decision rationale clear
- [ ] Alternatives considered
- [ ] Consequences documented
- [ ] Linked from dossier
- [ ] Build verification passes

---

### STEP 7: Enhance Project Detail Page (2–3 hours)

**Goal:** Make the project page showcase the evidence trail and governance posture.

**Current state:** Basic project detail with evidence links

**Enhancements:**

#### 7a. Add "What This Project Proves" section (already exists, enhance)

Update `/portfolio-app/src/app/projects/[slug]/page.tsx` to display:

```tsx
<Section
  title="What this project proves"
  subtitle="Senior-level engineering discipline demonstrated."
>
  <ul className="list-disc pl-5 space-y-2 text-sm text-zinc-700 dark:text-zinc-300">
    <li>
      <strong>Clear scope & architecture:</strong>{' '}
      <a className="underline" href={docsUrl(evidence?.dossierPath)}>
        See dossier
      </a>
    </li>
    <li>
      <strong>Enterprise SDLC:</strong> PR discipline, CI gates, governance
    </li>
    <li>
      <strong>Security-aware:</strong> Threat modeling, safe-publication rules
    </li>
    <li>
      <strong>Operational readiness:</strong> Deploy/rollback/triage procedures
    </li>
    <li>
      <strong>Tested:</strong> Automated checks, smoke tests, reproducibility
    </li>
  </ul>
</Section>
```

#### 7b. Create "Gold Standard Badge" component

Create `/portfolio-app/src/components/GoldStandardBadge.tsx`:

```tsx
export function GoldStandardBadge() {
  return (
    <div className="flex items-center gap-2 rounded-lg border border-amber-200 bg-amber-50 p-3 dark:border-amber-900 dark:bg-amber-950">
      <span className="text-lg">🏆</span>
      <p className="text-sm font-medium text-amber-900 dark:text-amber-100">
        This is a gold standard portfolio project — comprehensive documentation,
        full governance trail, and operational readiness.
      </p>
    </div>
  );
}
```

Add to project detail page:

```tsx
import { GoldStandardBadge } from '@/components/GoldStandardBadge';

// In the component:
<GoldStandardBadge />;
```

#### 7c. Add "Verification Checklist" section

```tsx
<Section
  title="How to verify"
  subtitle="Independent validation steps for reviewers."
>
  <ul className="list-disc pl-5 space-y-2 text-sm text-zinc-700 dark:text-zinc-300">
    <li>
      Visit{' '}
      <a className="underline" href={project.repoUrl}>
        GitHub repository
      </a>{' '}
      — check commit history, PR discipline, CI checks
    </li>
    <li>
      View{' '}
      <a className="underline" href={project.demoUrl}>
        live deployment
      </a>{' '}
      — test routing, rendering, performance
    </li>
    <li>
      Review{' '}
      <a className="underline" href={docsUrl(evidence?.dossierPath)}>
        project dossier
      </a>{' '}
      — architecture, decisions, operational procedures
    </li>
    <li>
      Check{' '}
      <a className="underline" href={docsUrl(evidence?.threatModelPath)}>
        threat model
      </a>{' '}
      — security assumptions and controls
    </li>
    <li>
      Read{' '}
      <a className="underline" href={docsUrl(evidence?.adrIndexPath)}>
        ADRs
      </a>{' '}
      — rationale for durable decisions
    </li>
  </ul>
</Section>
```

**Success check:**

- [ ] Enhanced project detail page components created
- [ ] Gold standard badge displays for chosen project
- [ ] Evidence links are comprehensive and organized
- [ ] Verification checklist guides reviewers
- [ ] Smoke tests validate links resolve
- [ ] Build passes
- [ ] PR created with enhancements

---

### STEP 8: Enhance CV Page with Capability Mapping (2–3 hours)

**Goal:** Transform CV from skeleton into meaningful capability-to-proof mapping.

**Current approach:** Create a structured CV that links capabilities to projects/evidence

**Update `/portfolio-app/src/app/cv/page.tsx`:**

```tsx
'use client';
import Link from 'next/link';
import { Section } from '@/components/Section';
import { docsUrl } from '@/lib/config';

type TimelineEntry = {
  title: string;
  organization: string;
  period: string;
  description: string;
  keyCapabilities: string[];
  proofs: { text: string; href: string }[];
};

const TIMELINE: TimelineEntry[] = [
  {
    title: 'Full-Stack Engineer',
    organization: 'Portfolio Program',
    period: '2026',
    description:
      'Designed and built an enterprise-grade portfolio demonstrating modern web development, governance, and operational maturity.',
    keyCapabilities: [
      'Next.js / React / TypeScript',
      'CI/CD governance',
      'Security & threat modeling',
      'Docs-as-code culture',
      'Vercel deployment',
    ],
    proofs: [
      {
        text: 'Portfolio App on GitHub',
        href: 'https://github.com/bryce-seefieldt/portfolio-app',
      },
      { text: 'Live deployment', href: 'https://your-portfolio.com' },
      {
        text: 'Full dossier with architecture & decisions',
        href: docsUrl('projects/portfolio-app'),
      },
      {
        text: 'Complete threat model & security posture',
        href: docsUrl('security/threat-models/portfolio-app-threat-model'),
      },
      {
        text: 'Operational runbooks (deploy, rollback, triage)',
        href: docsUrl('operations/runbooks/'),
      },
    ],
  },
  // Add more timeline entries as you accumulate projects/roles
];

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

**Success check:**

- [ ] CV page displays timeline with capability mapping
- [ ] Each entry links to projects, dossiers, threat models, runbooks
- [ ] Evidence links resolve in smoke tests
- [ ] Styling integrates with rest of site
- [ ] Smoke tests pass
- [ ] PR created with CV enhancements

---

### STEP 9: Create Release Note for Phase 2 (1–2 hours)

**Goal:** Document Phase 2 completion with all additions and changes.

**Location:** `/portfolio-docs/docs/00-portfolio/release-notes/20260124-portfolio-app-phase-2-gold-standard.md` (adjust date)

**Template:**

```markdown
---
title: 'Release Notes: Portfolio App Phase 2 Complete (Gold Standard Project + Testing)'
description: 'Phase 2 completion: comprehensive project dossier, smoke test infrastructure, enhanced CV with capability mapping, threat model, and operational runbooks.'
tags: [release-notes, portfolio-app, phase-2, testing, projects]
date: 2026-01-24
---

# Release Notes: Portfolio App Phase 2 Complete (Gold Standard Project + Testing)

## Summary

Phase 2 of the Portfolio App establishes credibility through one exemplary "gold standard" project. The Portfolio App itself serves as the proof, with comprehensive documentation, automated testing, full threat model, and operational procedures.

**Status:** ✅ **Phase 2 Complete** (2026-01-24)

---

## Highlights

- **Gold standard project page** with full evidence trail and verification checklist
- **Smoke test infrastructure** (Playwright) with 100% route coverage
- **Comprehensive dossier** covering architecture, security, deployment, operations
- **Threat model** documenting security assumptions and controls
- **Operational runbooks** for deploy, CI triage, rollback
- **Enhanced CV page** with capability-to-proof mapping
- **Gold standard badge** component highlighting exemplary project quality

---

## Added

### Portfolio App features

- **Smoke test suite (Playwright):**
  - Route accessibility tests (all 5 core routes)
  - Content rendering validation
  - Evidence link integrity checks
  - Integrated into CI pipeline (required before merge)

- **Enhanced project detail page:**
  - Gold standard badge
  - "What this project proves" section with detailed capabilities
  - "Verification checklist" section guiding independent validation
  - Comprehensive evidence links (dossier, threat model, ADRs, runbooks)

- **Meaningful CV page:**
  - Timeline of experience with capability-to-proof mapping
  - Each entry links to projects, dossiers, threat models, runbooks
  - Evidence-first approach: each claim is verifiable

### Documentation artifacts

- **Project dossier (10 sections):**
  - Executive summary, overview, architecture, security, testing, deployment, operations, limitations, troubleshooting, related artifacts
  - ~4,000 words

- **Threat model:**
  - Trust boundary diagram
  - STRIDE analysis
  - Mitigation controls
  - Residual risks documented and accepted

- **Operational runbooks:**
  - Deploy runbook (standard workflow)
  - CI triage runbook (troubleshooting common failures)
  - Rollback runbook (emergency recovery procedure)

- **ADR for testing strategy:**
  - Justification for phased testing approach (smoke → unit → e2e)
  - Rationale for Playwright + Vitest stack

---

## Changed

### Testing & quality

- `package.json` updated with Playwright test scripts
- `.github/workflows/ci.yml` updated to run smoke tests (required check)
- `.gitignore` updated to exclude test results and reports

### Project detail page

- Now displays gold standard badge for exemplary project
- Enhanced evidence links section
- Added verification checklist for reviewers

### CV page

- Converted from skeleton to comprehensive capability-to-proof mapping
- Timeline entries link to deep evidence artifacts
- Demonstrates evidence-first hiring/evaluation approach

---

## Verification (Phase 2 Success Criteria — All Complete ✅)

The Phase 2 release is valid when:

- ✅ One "gold standard" project page is fully polished
- ✅ Comprehensive dossier covers architecture, security, deployment, operations
- ✅ Threat model documents security posture and controls
- ✅ Operational runbooks (deploy, CI triage, rollback) are complete
- ✅ Smoke tests validate all core routes and evidence links
- ✅ CV page meaningfully maps capabilities to proofs
- ✅ A reviewer can validate senior-level engineering discipline through one project
- ✅ All evidence links resolve correctly

---

## Architecture & Governance References

- [Portfolio App Dossier](/docs/60-projects/portfolio-app/) (location TBD during implementation)
- [Threat Model: Portfolio App](/docs/40-security/threat-models/) (location TBD during implementation)
- [ADR-0009: Portfolio App Testing Strategy](/docs/10-architecture/adr/) (location TBD during implementation)
- Operational runbooks (created during Phase 2):
  - Deploy runbook
  - CI triage runbook
  - Rollback runbook

---

## Phase 3 Planning (Next Increments)

With Phase 2 establishing credibility through one exemplary project, Phase 3 will focus on:

- **Scale content model:** Repeatable project publishing pipeline with validation
- **Unit tests:** Content/slug validation, project registry schema enforcement
- **E2E tests:** Full user flows, cross-domain evidence link validation
- **Add additional projects:** Now that gold standard is proven, add portfolio entries at same quality bar

---

## Known Limitations (Phase 2 scope)

- Smoke tests only (unit/e2e planned for Phase 3)
- Single gold standard project (additional projects planned for Phase 3+)
- Manual evidence link testing (automated in Phase 3)
- No performance or accessibility audit yet (planned for Phase 4)
```

**Success check:**

- [ ] Release note created with all Phase 2 features
- [ ] Links to dossier, threat model, ADRs, runbooks
- [ ] Success criteria clearly documented
- [ ] Build verification passes
- [ ] PR created with release note

---

### STEP 10: Create PR and Verify End-to-End (1–2 hours)

**Goal:** Consolidate all Phase 2 work into a single PR and validate everything works together.

**Process:**

```bash
# Ensure you're on main and up-to-date
cd portfolio-app
git checkout main
git pull origin main

# Create Phase 2 feature branch
git checkout -b feat/phase-2-gold-standard

# Make all changes (test infrastructure, components, documentation)
# ...commit as you go...

# Run all checks locally
pnpm lint
pnpm format:check
pnpm typecheck
pnpm build
pnpm test  # Run Playwright smoke tests

# Verify documentation builds
cd ../portfolio-docs
pnpm build

# If all passes, create PR
cd ../portfolio-app
git push origin feat/phase-2-gold-standard
# Open PR on GitHub
```

**PR template checklist:**

```
## Phase 2 Implementation: Gold Standard Project & Testing

### Changes
- [ ] Smoke test infrastructure (Playwright)
- [ ] Enhanced project detail page with gold standard badge
- [ ] Meaningful CV page with capability mapping
- [ ] Local test commands and CI integration

### Documentation updates (portfolio-docs repo)
- [ ] Project dossier (10 sections)
- [ ] Threat model
- [ ] Operational runbooks (deploy, CI triage, rollback)
- [ ] ADR for testing strategy
- [ ] Phase 2 release note

### Evidence
- [ ] All smoke tests pass locally: `pnpm test`
- [ ] CI checks pass on main
- [ ] Production deployment successful
- [ ] Evidence links resolve to docs (verified in smoke tests)

### No secrets added
- [ ] No `NEXT_PUBLIC_*` secrets added
- [ ] No API keys or credentials in code or config
```

**Success check:**

- [ ] All local checks pass (`lint`, `format:check`, `typecheck`, `build`, `test`)
- [ ] Documentation builds pass
- [ ] PR created with comprehensive description
- [ ] GitHub Actions CI runs successfully
- [ ] Vercel preview deployment works
- [ ] After merge, production deployment automatic
- [ ] All evidence links resolve to docs app
- [ ] Smoke tests pass in CI

---

## Summary: Phase 2 Timeline & Effort

| Step | Task                            | Effort  | Cumulative |
| ---- | ------------------------------- | ------- | ---------- |
| 1    | Choose gold standard project    | 1–2 hrs | 1–2 hrs    |
| 2    | Set up smoke tests (Playwright) | 3–5 hrs | 4–7 hrs    |
| 3    | Create project dossier          | 4–6 hrs | 8–13 hrs   |
| 4    | Create threat model             | 2–3 hrs | 10–16 hrs  |
| 5    | Create operational runbooks     | 2–4 hrs | 12–20 hrs  |
| 6    | Create/update ADRs              | 1–2 hrs | 13–22 hrs  |
| 7    | Enhance project detail page     | 2–3 hrs | 15–25 hrs  |
| 8    | Enhance CV page                 | 2–3 hrs | 17–28 hrs  |
| 9    | Create Phase 2 release note     | 1–2 hrs | 18–30 hrs  |
| 10   | Create PR & verify end-to-end   | 1–2 hrs | 19–32 hrs  |

**Total effort:** ~19–32 hours (2–4 weeks at 10–15 hrs/week)

---

## Success Metrics for Phase 2

After Phase 2 completes, you should be able to answer YES to:

1. **Coverage:** Can a reviewer access 100% of core routes through the app or docs?
2. **Clarity:** Does each route explain what it proves about engineering discipline?
3. **Evidence:** Are all evidence links (dossier, threat model, ADRs, runbooks) complete and accurate?
4. **Automation:** Do smoke tests validate all core routes on every merge?
5. **Credibility:** Can a senior engineer validate your engineering posture through one project?
6. **Scale-ready:** Is the structure repeatable for adding additional projects without chaos?

---

## Next Steps After Phase 2

Once Phase 2 is complete:

1. **Share with stakeholders** — show gold standard project and evidence trail
2. **Gather feedback** — refine based on reviewer perspective
3. **Plan Phase 3** — scale to multiple projects, add unit/e2e tests
4. **Consider Phase 4** — performance, security hardening, observability

---
