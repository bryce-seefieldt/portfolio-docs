---
title: 'Portfolio Roadmap Issues Archived'
description: 'Archive of roadmap issue documents for historical traceability.'
tags: [portfolio, release-notes, roadmap, governance, archival]
---

# Summary

The roadmap issues directory is archived to preserve historical planning artifacts while preventing stale issues from being treated as active work items.

# Highlights

- Archived all roadmap issue pages and removed them from the rendered build.
- Added archive notices to each issue file and updated the issues index.
- Preserved all links for historical traceability.

# Changed

- Issues content moved to `docs/_archive/closed-issues/`.
- Docs build excludes `docs/_archive/**` to keep archived issues out of navigation.
- Issues index now marks all entries as archived.
- Each issue document includes an archive notice with this release note link.

# Governance and security baselines

- Archival performed under the Portfolio Archival Policy and runbook requirements.
- No evidence links removed; historical references remain intact.

# Verification

- `pnpm build` (portfolio-docs)

# Known limitations

- Archived issues are read-only historical references; new planning work should use current roadmap guidance.

# Follow-ups

- None.
