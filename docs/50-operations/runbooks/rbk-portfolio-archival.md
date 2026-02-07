---
title: 'Runbook: Portfolio Archival Procedure'
description: 'Safely deprecate and archive portfolio content without breaking evidence links.'
sidebar_position: 6
tags: [runbook, operations, governance, archival, maintenance]
---

# Runbook: Portfolio Archival Procedure

## Quick Reference

|                 |                                            |
| --------------- | ------------------------------------------ |
| **Scenario**    | Deprecating or archiving portfolio content |
| **Severity**    | Low (planned maintenance)                  |
| **MTTR Target** | N/A (planned work)                         |
| **On-Call**     | No                                         |
| **Escalation**  | Portfolio owner if policy conflicts arise  |

---

## Overview

This runbook defines the steps to archive portfolio content while preserving evidence integrity. Use it whenever a project or document is no longer representative but must remain traceable.

**When to use this runbook:**

- A project is no longer active or representative
- Evidence artifacts must be retired without breaking links
- Governance policy requires archival rather than removal

**When NOT to use this runbook:**

- Minor documentation edits (use normal PR workflow)
- Emergency changes (use relevant incident runbooks)

---

## Prereqs / Inputs

- Portfolio eligibility criteria
- Portfolio archival policy
- Portfolio change intake checklist

```md
:::warning
If archival would break evidence links or remove required artifacts, stop and update the policy before proceeding.
:::
```

---

## Procedure / Content

### 1) Confirm context

- Identify the content to be archived
- Confirm the reason matches archival triggers
- List all inbound links (dossiers, ADRs, runbooks, release notes)

### 2) Prepare archival updates

- Add an archival notice to the affected page(s)
- Update any index pages to mark the item as archived
- Ensure a replacement link or rationale is documented
- Choose one archive visibility option:
	- **Option 1 (Draft):** add `draft: true` in front matter to prevent rendering.
	- **Option 2 (Archive folder):** move content under `docs/_archive/` and exclude it from the docs build.

### 3) Update governance artifacts

- Update the release notes index with the archival entry
- Add a release note describing the archival decision
- Update the roadmap if the archive affects phase status

### 4) Validate link integrity

- Run local link checks (`pnpm build` in portfolio-docs)
- Confirm no broken links or missing references
- If using Option 2, verify inbound links are updated or intentionally preserved as historical references

### 5) Merge and publish

- Open a PR with evidence and rationale
- After merge, deploy docs and verify navigation

---

## Validation / Expected outcomes

- Archived content remains accessible and clearly labeled
- No broken links in docs build
- Release notes capture the archival decision

If validation fails, revert the archival changes and correct links before retrying.

---

## Rollback / Recovery

### Rollback trigger conditions

- Broken links detected after archival
- Reviewer path no longer resolves to evidence

### Rollback procedure

- Revert the PR
- Restore the archived content and index links
- Re-run `pnpm build` and confirm integrity

---

## Failure modes / Troubleshooting

- **Broken links:** identify inbound references and add archival notes or redirects
- **Missing release note:** add a release note before re-attempting

---

## References

- Portfolio archival policy: [/docs/00-portfolio/portfolio-archival-policy.md](/docs/00-portfolio/portfolio-archival-policy.md)
- Change intake checklist: [/docs/00-portfolio/portfolio-change-intake.md](/docs/00-portfolio/portfolio-change-intake.md)
- Release notes: [/docs/00-portfolio/release-notes/index.md](/docs/00-portfolio/release-notes/index.md)
