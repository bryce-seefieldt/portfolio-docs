---
title: 'Portfolio Phase 6 Governance Baseline'
description: 'Phase 6 release note establishing long-term governance, versioning, and archival policies.'
tags: [portfolio, release-notes, phase-6, governance, lifecycle]
---

# Summary

Phase 6 establishes the long-term governance baseline for the portfolio. Inclusion criteria, versioning policy, archival rules, and change intake guidance are now explicit and reviewable.

# Highlights

- Portfolio eligibility criteria and evidence minimums published
- Semantic versioning policy established with ADR support
- Archival policy and runbook define safe retirement paths

# Added

- Eligibility criteria: [/docs/00-portfolio/portfolio-eligibility-criteria.md](/docs/00-portfolio/portfolio-eligibility-criteria.md)
- Versioning policy: [/docs/00-portfolio/portfolio-versioning-policy.md](/docs/00-portfolio/portfolio-versioning-policy.md)
- Archival policy: [/docs/00-portfolio/portfolio-archival-policy.md](/docs/00-portfolio/portfolio-archival-policy.md)
- Change intake checklist: [/docs/00-portfolio/portfolio-change-intake.md](/docs/00-portfolio/portfolio-change-intake.md)
- ADR-0017: [/docs/10-architecture/adr/adr-0017-portfolio-versioning-and-lifecycle.md](/docs/10-architecture/adr/adr-0017-portfolio-versioning-and-lifecycle.md)
- Archival runbook: [/docs/50-operations/runbooks/rbk-portfolio-archival.md](/docs/50-operations/runbooks/rbk-portfolio-archival.md)

# Changed

- Reviewer guide linked to new governance policies
- Release notes index updated with Phase 6 entry

# Governance and security baselines

- Governance decisions are now versioned and auditable
- Public-safe constraints remain enforced across all new policies

# Verification

- Not run in this update (recommended: `pnpm verify` in portfolio-docs)

# Known limitations

- Policies are new and should be reviewed after the next minor release

# Follow-ups

- Validate governance links after docs deployment
- Apply versioning policy to the next portfolio change
