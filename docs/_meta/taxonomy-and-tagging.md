---
title: 'Taxonomy and Tagging'
description: 'Standard taxonomy, naming conventions, and tag policies to keep documentation discoverable, navigable, and scalable.'
sidebar_position: 2
tags: [meta, governance, taxonomy, tags, information-architecture]
---

# Taxonomy and Tagging

## Purpose

This document defines the taxonomy used across the repository so that:

- content is discoverable via search and tags
- navigation remains stable as volume grows
- AI agents can categorize and place new docs correctly
- “misc” sprawl is prevented by strict classification

## Scope

### In scope

- folder placement rules
- naming conventions
- tag vocabulary and rules
- page-level classification guidelines
- “when to create a new folder” rules

### Out of scope

- content-specific writing rules (see Documentation Style Guide)

## Folder placement rules (authoritative)

Use these domains:

- `00-portfolio`: narrative, roadmap, release notes, capability map
- `10-architecture`: C4 views, data flows, integrations, ADRs
- `20-engineering`: standards, local dev, tests, dependency policy
- `30-devops-platform`: CI/CD, environments, hosting, observability
- `40-security`: threat models, SDLC controls, supply chain, privacy
- `50-operations`: runbooks, IR, DR/BCP, postmortems
- `60-projects`: per-project dossiers (portfolio app and demos)
- `70-reference`: CLI/config/cheatsheets and fast diagnostics

Rule of thumb:

- If it changes how the system is **built** → Engineering / DevOps
- If it changes how the system is **secured** → Security
- If it changes how the system is **run** → Operations
- If it changes what the system **is** → Architecture / Portfolio

## Naming conventions

### File names

- `kebab-case.md` or `kebab-case.mdx`
- no spaces, no uppercase
- keep names stable (renames create churn)

### Folder names

- `kebab-case`
- keep domain numeric prefixes at top level (00/10/20/…)

### Special collections

- ADRs: `adr-0001-short-title.md`
- Runbooks: `rbk-<system>-<task>.md`
- Postmortems: `pm-YYYY-MM-DD-short-title.md`
- Threat models: `<system>-threat-model.md` (or a folder per system)

## Tag rules

### Principles

- Tags are not decoration. They are for discovery and maintenance.
- Use **3–8 tags** per page.
- Prefer repository-standard tags over novel tags.

### Standard tag vocabulary (recommended)

Use from this list whenever possible:

**Domains**

- `portfolio`, `architecture`, `engineering`, `devops`, `security`, `operations`, `projects`, `reference`

**Delivery**

- `roadmap`, `release-notes`, `cicd`, `observability`, `testing`, `deployment`, `rollback`

**Security**

- `threat-model`, `sdlc`, `supply-chain`, `sast`, `sca`, `sbom`, `privacy`, `headers`

**Operations**

- `runbook`, `incident-response`, `postmortem`, `drbcp`, `oncall`, `monitoring`

**Tech stack (use sparingly)**

- `node`, `typescript`, `react`, `nextjs`, `vercel`, `github-actions`, `docker`, `wsl2`

### Disallowed tag patterns

- overly generic tags (`misc`, `random`, `stuff`)
- one-off tags that duplicate a folder name
- tags that contain sensitive info

## Page classification guidance

### Choose one primary domain tag

Every page must include exactly one primary domain tag:

- `portfolio` OR `architecture` OR `engineering` OR `devops` OR `security` OR `operations` OR `projects` OR `reference`

### Add secondary tags for topic and lifecycle

Example:

- A CI pipeline overview page:
  - primary: `devops`
  - secondary: `cicd`, `github-actions`, `deployment`, `rollback`

## When to create a new folder

Create a new folder only if:

- there are at least **3 pages** planned for that topic, OR
- the topic represents a durable enterprise capability (e.g., `observability`, `incident-response`)

When creating a new folder:

- add `_category_.json`/`.yml`
- include a folder `index.md` hub (or generated-index if using that approach)

## Validation and expected outcomes

Taxonomy is “healthy” when:

- pages are easy to locate via search and tags
- new contributors can place content consistently
- the sidebar remains coherent without manual curation

## Failure modes and troubleshooting

- **Tag explosion:** too many unique tags → consolidate into standard vocabulary.
- **Folder sprawl:** many folders with 1 file → merge into a parent topic.
- **Unclear ownership:** no “home” for content → create a hub and enforce placement rules.

## References

This taxonomy is authoritative for placement and tagging decisions.
