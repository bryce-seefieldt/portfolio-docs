---
title: "Documentation Style Guide"
description: "Mandatory writing, structure, and formatting rules for this Docusaurus docs-as-code repository."
sidebar_position: 0.1
tags: [meta, governance, style-guide, documentation, docusaurus]
---
# Documentation Style Guide 

## Purpose

This style guide defines **non-negotiable** standards for authoring documentation in this repository. It exists to ensure that documentation remains:

- consistent across all domains (portfolio, architecture, DevOps, security, operations)
- reviewable via PRs and CI
- safe for public publication
- maintainable by humans and AI agents without drift

## Scope

### In scope
- required page structure (templates and standard headings)
- Docusaurus-specific conventions (front matter, admonitions, categories)
- formatting and technical writing conventions
- procedures for commands and configuration snippets
- rules for public-safe content and redaction

### Out of scope
- project-specific engineering standards (see Engineering domain pages)
- security program requirements (see Security domain pages)

## Required front matter (every doc)

All docs must include a front matter block:

```yaml
---
title: "Short, specific title"
description: "1–2 sentence summary of why this page exists."
tags: [domain, topic, audience]
---
```

### Sidebar fields (use as needed)

Use these fields only when the page needs explicit ordering or naming:

- `sidebar_position`: number for ordering
- `sidebar_label`: override label shown in nav
- `unlisted: true`: hides from nav but page remains accessible by direct link

## Standard page shape (mandatory)

Every document must include these headings in this order (templates can add more):

1. Purpose
2. Scope
3. Prereqs / Inputs
4. Procedure / Content
5. Validation / Expected outcomes
6. Failure modes / Troubleshooting
7. References

If a document does not need a section, include it and state: “Not applicable.”

## Writing rules (strict)
### Tone and voice

- Default voice: professional, technical, operational
- Use imperative voice for procedures (“Run… Verify… Roll back…”)
- Use neutral descriptive voice for architecture and security (“The system performs…”)
- First-person is allowed only in 00-portfolio/ narrative pages, and only when appropriate.

### Clarity rules
- Prefer bullet points over long paragraphs.
- Define acronyms on first use; add to glossary if reused.
- Avoid vague language (“robust”, “secure”, “best”) unless backed by evidence.

### Enterprise evidence rule

Any claim about reliability/security/quality must provide at least one of:
- validation procedure
- reference to a control or gate
- evidence artifact location (sanitized if needed)

## Docusaurus conventions
### Admonitions

Use admonitions for operational clarity:
```md
:::
Context or helpful detail.
:::

:::
Potential risk; proceed carefully.
:::

:::
High-risk action or security-sensitive behavior.
:::
```
### Markdown vs MDX
- Prefer .md by default.
- Use .mdx only when you need React components (e.g., evidence dashboards, interactive CV components).
- Keep MDX usage intentional and minimal to reduce maintenance.

### Categories

Any folder that appears in navigation must include `_category_.json` (or `_category_.yml`) with:
- label, position
- link (generated-index or doc)

## Commands and code blocks
### Rules for commands
- Commands must be copy/paste safe.
- Always indicate environment context:
    - WSL bash (bash)
    - PowerShell (powershell)
    - CI (mention runner OS)
- If destructive:
    - include a warning admonition
    - include rollback steps in the same document

### Fence every snippet with a language

Use explicit fences:
- `bash`, `powershell`, `yaml`, `json`, `ts`, `tsx`

Example:
```bash
pnpm build
```

## Diagrams and architecture visuals
- Prefer Mermaid for sequence/flow diagrams when possible.
- Keep diagrams minimal and readable (avoid mega-diagrams).
- If using images, place them in [`static/img/diagrams/`](../../static/img/diagrams/) and reference them with stable, meaningful filenames.

## Public safety and redaction rules

Never include:
- secrets, tokens, private keys, connection strings
- private IPs/internal hostnames
- raw logs containing identifiers

When adding evidence artifacts:
- publish summaries and sanitized outputs
- remove identifiers and secrets
- prefer “how to reproduce” over dumping raw output

## Review checklist (author responsibility)

Before opening a PR, confirm:
- page follows standard structure
- front matter included
- commands are copy/paste safe
- no secrets added
- `pnpm build` succeeds

## Failure modes and troubleshooting

- **Inconsistent headings**: enforce templates and fix in PR.
- **Broken links**: avoid adding links to pages that do not exist; build must pass.
- **Overuse of MDX**: prefer plain Markdown unless interactivity is essential.

## References

This style guide is authoritative. If another document conflicts with it, update that document or propose a governance change via PR.