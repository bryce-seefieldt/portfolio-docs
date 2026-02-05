---
title: 'React2Shell Hardening Implementation Guide'
description: 'Implementation plan for mitigating React2Shell-class risks in the portfolio app and documenting long-term hardening protocols.'
sidebar_position: 6
tags: [security, hardening, react2shell, governance, implementation]
---

# React2Shell Hardening Implementation Guide

## Purpose

Establish a concrete plan to mitigate React2Shell-class risks in the Portfolio App and document durable protocols in the docs repo. This guide treats React/Next.js as a backend surface and emphasizes defense-in-depth beyond patching.

## Summary of the Risk (from provided research)

- React2Shell is an unauthenticated RCE vulnerability tied to unsafe deserialization in React Server Components.
- The exploit class is likely to recur in server-side rendering frameworks.
- Patching is required but insufficient without runtime containment and strict input boundaries.

## Goals

- Patch quickly and verify vulnerable surfaces are updated.
- Reduce blast radius if a framework-layer exploit occurs again.
- Make security expectations enforceable through CI gates and docs.

## Non-Goals

- Building a full backend or auth system.
- Introducing complex infrastructure that is not needed for a portfolio site.

---

## Implementation Overview

Work is split into two tracks:

- **Portfolio App hardening:** concrete technical controls in the app.
- **Docs governance:** policies, ADRs, and runbooks that keep the controls durable.

---

## Track A: Portfolio App Hardening (portfolio-app)

### Step 1: Patch and dependency hygiene

**Goal:** ensure the app is on patched framework versions and has automated vulnerability checks.

**Actions:**

- Upgrade React/Next.js to patched versions that address the CVE.
- Add or confirm `pnpm audit --audit-level=high` as a CI gate.
- Document the patch window and CVE response expectation in docs.

**Files to update:**

- `portfolio-app/package.json`
- `portfolio-app/pnpm-lock.yaml`
- `portfolio-app/.github/workflows/ci.yml`

**Success checks:**

- `pnpm audit` reports no critical/high issues
- CI gate fails on new high/critical advisories

---

### Step 2: Harden request boundaries and deserialization paths

**Goal:** eliminate unsafe input handling and reduce implicit server action exposure.

**Actions:**

- Add Zod validation for any route handler input.
- Document a rule: no generic "execute" helpers or dynamic deserialization.
- Keep privileged logic behind explicit API routes only.

**Files to update:**

- `portfolio-app/src/app/api/*/route.ts`
- `portfolio-app/src/lib/*` (validation helpers)
- `portfolio-app/.github/copilot-instructions.md` (safety guidance)

**Success checks:**

- All mutation endpoints validate inputs with Zod.
- No route handlers accept unbounded or polymorphic payloads.

---

### Step 3: Runtime containment headers and CSP hardening

**Goal:** reduce XSS and script injection risk even if a framework bug exists.

**Actions:**

- Add security headers in `next.config.ts` (referrer, nosniff, frame, permissions).
- Add per-request CSP with a nonce in proxy.
- Ensure inline scripts (if any) use the nonce.

**Files to update:**

- `portfolio-app/next.config.ts`
- `portfolio-app/src/proxy.ts`
- `portfolio-app/src/app/layout.tsx`
- `portfolio-app/src/lib/security/headers.ts`

**Success checks:**

- CSP nonce is set on every request.
- Headers validated via `curl -I` locally and in production.

---

### Step 4: CSRF protection and rate limiting for mutations

**Goal:** reduce abuse and request forgery on any mutable endpoints.

**Actions:**

- Add a double-submit CSRF token endpoint.
- Validate CSRF tokens in any POST/PUT/DELETE routes.
- Add rate limiting with a small in-memory limiter (with future option for Redis).

**Files to update:**

- `portfolio-app/src/lib/security/csrf.ts`
- `portfolio-app/src/lib/security/ratelimit.ts`
- `portfolio-app/src/app/api/csrf/route.ts`
- `portfolio-app/src/app/api/*/route.ts`

**Success checks:**

- Requests missing CSRF token are rejected.
- Rate limiter returns 429 on excessive requests.

---

### Step 5: Logging and observability signals

**Goal:** make exploitation attempts visible and actionable.

**Actions:**

- Add structured logging for rejected requests (no sensitive data).
- Track CSP violations (report-only in dev if needed).
- Add a lightweight "security audit" page if feasible (future enhancement).

**Files to update:**

- `portfolio-app/src/lib/observability/*` (if present)
- `portfolio-app/next.config.ts` (report-uri if used)

**Success checks:**

- CSP violations surface in logs or dev console.
- Rejected requests are observable.

---

## Track B: Documentation and Governance (portfolio-docs)

### Step 6: ADR and governance policy updates

**Goal:** make React2Shell hardening a durable, reviewable decision.

**Actions:**

- Create ADR documenting the decision to adopt a hardening baseline.
- Update security policies to reflect CSP nonce, validation, and CSRF rules.
- Add a risk register entry for "framework-layer deserialization RCE" and mitigation status.

**Files to update:**

- `portfolio-docs/docs/10-architecture/adr/adr-0018-react2shell-hardening-baseline.md`
- `portfolio-docs/docs/40-security/security-policies.md`
- `portfolio-docs/docs/40-security/risk-register.md`

**Success checks:**

- ADR links to implementation guide and relevant policies.
- Risk register reflects the new risk and mitigations.

---

### Step 7: Security controls and threat model updates

**Goal:** ensure the Portfolio App security posture reflects new controls.

**Actions:**

- Update Portfolio App security controls documentation to include CSP nonce and CSRF/ratelimit.
- Update the threat model to include React2Shell-class risks and mitigations.
- Add a short response playbook or addendum to existing runbooks for framework CVEs.

**Files to update:**

- `portfolio-docs/docs/40-security/portfolio-app-security-controls.md`
- `portfolio-docs/docs/40-security/threat-models/portfolio-app-threat-model-v2.md`
- `portfolio-docs/docs/50-operations/runbooks/rbk-portfolio-dependency-vulnerability.md`

**Success checks:**

- Threat model reflects deserialization RCE risks.
- Runbook includes framework CVE response steps.

---

### Step 8: Developer protocol and guardrails

**Goal:** ensure future changes remain compliant.

**Actions:**

- Add a "React2Shell class" guidance section to the docs security posture page.
- Update Copilot instructions to avoid unsafe patterns (generic deserialization, eval, dynamic execution).
- Update verification guidance in docs to include security checks.

**Files to update:**

- `portfolio-docs/docs/40-security/index.md`
- `portfolio-docs/docs/70-reference/testing-guide.md`
- `portfolio-app/.github/copilot-instructions.md`

**Success checks:**

- Guardrails are documented and linked from security index.
- Guidance is explicit and enforceable.

---

## Verification

Run these checks after implementation:

```bash
# In portfolio-app
pnpm audit --audit-level=high
pnpm lint
pnpm typecheck
pnpm test
pnpm build
pnpm verify

# In portfolio-docs
pnpm build
pnpm verify
```

---

## Acceptance Criteria

- React and Next.js are patched and verified.
- CSP nonce and security headers are enforced in production.
- All mutation endpoints validate input and enforce CSRF + rate limiting.
- Security policies, threat model, and risk register reflect the new controls.
- ADR and implementation guide are published and linked.

---

## Open Questions

- Do we need to disable or reduce Server Actions usage if not required?
- Should CSP move to strict nonces/hashes for styles as well?
- Is a dedicated framework CVE response runbook required or a section in the existing dependency runbook?

---

## References

- React2Shell report: `/tmp/react2shell-report.md`
- React2Shell hardening research: `/tmp/react2shell-hardening-research.md`
- Security policies: [/docs/40-security/security-policies.md](/docs/40-security/security-policies.md)
- Risk register: [/docs/40-security/risk-register.md](/docs/40-security/risk-register.md)
- Portfolio App security controls: [/docs/40-security/portfolio-app-security-controls.md](/docs/40-security/portfolio-app-security-controls.md)
