---
title: 'Feature: Contact Page (/contact)'
description: 'Public-safe contact page with static links only.'
sidebar_position: 5
tags: [portfolio, features, core-pages, contact]
---

## Purpose

- Feature name: Contact page (`/contact`)
- Why this feature exists: Provide safe, static contact paths without introducing a backend form.

## Scope

### In scope

- contact cards for LinkedIn, GitHub, and email
- fallbacks when no contact links are configured

### Out of scope

- contact form handling or inbound data processing
- authentication or identity verification

## Prereqs / Inputs

- `NEXT_PUBLIC_LINKEDIN_URL` or `NEXT_PUBLIC_GITHUB_URL` or `NEXT_PUBLIC_CONTACT_EMAIL`

## Procedure / Content

### Feature summary

- Feature name: Contact page (`/contact`)
- Feature group: Core pages and reviewer journey
- Technical summary: Renders static contact cards based on configured public environment variables.
- Low-tech summary: A safe contact page that avoids forms and uses simple links.

### Feature in action

- Where to see it working: `/contact` in the deployed app or `http://localhost:3000/contact` during `pnpm dev`.

### Confirmation Process

#### Manual

- Steps: Open `/contact`, verify that configured contact cards appear.
- What to look for: Mailto links open a mail client, external links resolve correctly, and fallback text appears if nothing is set.
- Artifacts or reports to inspect: Optional E2E route coverage in CI.

#### Tests

- Unit tests: [`/portfolio-app/src/lib/__tests__/config.test.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/__tests__/config.test.ts)
- E2E tests: [`/portfolio-app/tests/e2e/routes.spec.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/tests/e2e/routes.spec.ts)

### Potential behavior if broken or misconfigured

- Contact links missing because env vars are unset.
- Mailto formatting incorrect due to invalid email values.

### Long-term maintenance notes

- Keep contact endpoints current and remove stale links.
- Re-validate after changing environment variables.

### Dependencies, libraries, tools

- Next.js App Router
- React
- Tailwind CSS

### Source code references (GitHub URLs)

- [`/portfolio-app/src/app/contact/page.tsx`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/contact/page.tsx)
- [`/portfolio-app/src/lib/config.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/config.ts)

### ADRs

- None.

### Runbooks

- None.

### Additional internal references

- [`/40-security/security-policies.md`](/docs/40-security/security-policies.md)
- [`/70-reference/portfolio-app-config-reference.md`](/docs/70-reference/portfolio-app-config-reference.md)

### External reference links

- https://nextjs.org/docs/app
- https://nextjs.org/docs/app/getting-started/layouts-and-pages

## Validation / Expected outcomes

- Contact page renders with at least one configured contact method.
- No form or backend processing is required.

## Failure modes / Troubleshooting

- No contact cards shown: set at least one public contact env var.
- Incorrect links: validate env values and redeploy.

## References

- None.
