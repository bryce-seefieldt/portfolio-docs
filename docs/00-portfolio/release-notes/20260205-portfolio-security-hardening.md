---
title: 'Portfolio Security Hardening (Docs + App)'
description: 'Release note covering security hardening across the Portfolio Docs App and Portfolio App, including CSP headers, audit gates, and governance updates.'
tags: [portfolio, release-notes, security, hardening, governance]
---

# Summary

Security hardening updates are now in place for both the Portfolio Docs App and the Portfolio App. This release introduces host-level security headers for the docs platform, codifies MDX review controls, and reinforces audit gating and validation rules across both repositories.

# Highlights

- Host-level security headers enforced for the docs platform via Vercel configuration
- CSP nonce, CSRF protection, and rate limiting reinforced for the Portfolio App
- Audit gate posture standardized: high/critical fail, lower severities logged
- Security governance strengthened with ADRs and hardening implementation plan

# Added

- Docs hardening plan: [/docs/40-security/portfolio-docs-hardening-implementation-plan.md](/docs/40-security/portfolio-docs-hardening-implementation-plan.md)
- ADR-0019 (docs hardening baseline): [/docs/10-architecture/adr/adr-0019-portfolio-docs-hardening-baseline.md](/docs/10-architecture/adr/adr-0019-portfolio-docs-hardening-baseline.md)
- ADR-0018 (app hardening baseline): [/docs/10-architecture/adr/adr-0018-react2shell-hardening-baseline.md](/docs/10-architecture/adr/adr-0018-react2shell-hardening-baseline.md)
- Host-level headers configuration for docs: [vercel.json](vercel.json)

# Changed

- Security policies updated with docs-specific CSP and MDX controls: [/docs/40-security/security-policies.md](/docs/40-security/security-policies.md)
- Docs deployment runbook now includes header verification: [/docs/50-operations/runbooks/rbk-docs-deploy.md](/docs/50-operations/runbooks/rbk-docs-deploy.md)
- Docs dossier security page references hardening plan and header checks: [/docs/60-projects/portfolio-docs-app/04-security.md](/docs/60-projects/portfolio-docs-app/04-security.md)
- PR checklist includes MDX review and header verification prompts: [/.github/PULL_REQUEST_TEMPLATE.md](/.github/PULL_REQUEST_TEMPLATE.md)

# Governance and security baselines

- Docs: host-level headers, audit gate enforcement, and MDX treated as code
- App: CSP nonce enforcement, CSRF protection, rate limiting, and stricter audit posture
- Evidence and verification procedures documented in security and ops domains

# Verification

- Header checks executed against production docs domain (CSP and baseline headers present)
- Audit gate behavior verified in CI (high/critical fail, low/medium logged)

# Known limitations

- CSP may require iteration if new third-party scripts are introduced
- MDX policy requires ongoing reviewer discipline to remain effective

# Follow-ups

- Re-validate CSP if analytics/search integrations are added
- Periodically review MDX usage for reduction opportunities
