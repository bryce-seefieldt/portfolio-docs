---
title: 'ADR-0021: Visual Identity and Design-System Direction'
sidebar_label: 'ADR-0021: Visual Identity & Design System'
description: 'Decision to adopt a cassette-futurism visual identity for the Portfolio App, delivered as a stylized, accessible, CSS/SVG interface with dark-default theming; true 3D realism deferred.'
tags: [adr, architecture, design, frontend, accessibility, governance]
---

# ADR-0021: Visual Identity and Design-System Direction

## Purpose

Use this record to capture the decision to adopt a deliberate "cassette-futurism" visual identity for the Portfolio App so it is reviewable, traceable, auditable over time, and linked to its accessibility, performance, and delivery implications.

## Scope

### Use when

This ADR governs the Portfolio App's visual design system: color and typography tokens, the control-panel component language, materiality conventions, theming default, and the accessibility/performance constraints that bound them.

### Do not use when

This ADR does not cover the information-architecture decision for the dual-narrative home/engineering split (recorded in a separate ADR when the engineering route is added), nor copy/content strategy (tracked in the portfolio program planning artifacts).

## Prereqs / Inputs

- Decision owner(s): Bryce Seefieldt
- Date: 2026-06
- Status: Accepted
- Supersedes: the visual-identity content of the former "UX Design System & Patterns" page (Zinc palette, system-font typography, "Why Zinc?" rationale), whose authority moves to the Design System reference (20-engineering).
- Superseded by: (none)
- Related work items (optional): Phase 2 redesign (2A token foundation, 2A.1 materiality, 2B hero, and subsequent phases).
- Related risks (optional): aesthetic ambition degrading performance or accessibility if not constrained; visual distinctiveness reading as "gimmick" to a professional-services audience if pushed too far.

## Decision Record

### Title

ADR-0021: Visual Identity and Design-System Direction

### Context

- **What problem are we solving?** The Portfolio App's engineering substance is strong, but its initial presentation used near-default styling that read as an unfinished scaffold. For an audience that includes technical reviewers evaluating front-end and UX capability, the site's own interface is first-order evidence, and it was underperforming the work it represents.
- **What constraints exist?** The result must remain fast (performance budget intact), accessible (WCAG AA across both themes), responsive, and reviewable. The aesthetic must never block content or delay load. It is being built primarily with AI-assisted, single-maintainer effort, so the system must be simple enough to maintain.
- **What assumptions are we making?** That a distinctive-but-disciplined identity differentiates the site more effectively than either a generic minimal template or a heavy immersive experience; and that the author's two-decade prior career in music and analog audio makes a vintage-futurist aesthetic authentic rather than borrowed.

### Decision

Adopt a cassette-futurism design system, delivered as a confident, clearly-a-website interface inspired by vintage-futurist hardware (control panels, CRT readouts, analog instrumentation), pushed toward the imaginative "futurism" end rather than faithful reproduction, with readability and usability always taking precedence. Key configuration choices that define the decision: (1) stylized, not photoreal; (2) CSS and inline SVG only for now, with no WebGL/3D, no heavy animation libraries, and no large raster textures; (3) dark-default theming (phosphor-on-dark "powered-on" mode) with a warm-cream light "powered-down" fallback, both meeting WCAG AA; (4) a small set of dependency-free control-panel primitives (Panel, Readout, LabelTag, Dial, plus later hero/dashboard components) composed across the site; (5) one consistent implied light source (top-left) across all dimensional elements.

### Alternatives considered

1. Generic minimal dev-portfolio aesthetic

- Pros: fast to build; safe; familiar.
- Cons: undifferentiated among many near-identical minimal portfolios; wastes the authentic autobiographical angle.
- Why not chosen: fails to stand out for the exact audience the site must impress, and forgoes a genuine differentiator.

2. Full WebGL/3D immersive experience

- Pros: maximally memorable; demonstrates advanced creative-front-end capability.
- Cons: load-time cost; accessibility complications; fragility on low-end devices; longer build; spends the performance budget on rendered chrome.
- Why not chosen: for an audience evaluating disciplined, accessible engineering, trading Lighthouse scores for spectacle argues against the very competence the site is meant to demonstrate. Deferred, not discarded (see Implementation notes).

3. Status-quo flat token system

- Pros: already in place; zero additional effort.
- Cons: reads as an unfinished scaffold; fails to perform the UX capability the site claims.
- Why not chosen: actively undercuts the engineering substance behind it.

### Consequences

- Positive consequences: a distinctive, authentic, accessible identity that differentiates the site and reinforces (rather than undercuts) the engineering pitch; a reusable primitive system that keeps every later phase coherent.
- Negative consequences / tradeoffs: a bespoke design system carries more maintenance surface than an off-the-shelf template; the aesthetic requires ongoing discipline to keep effects from creeping past the performance/accessibility budget.
- Operational impact: the Design System reference (20-engineering) becomes the authoritative source for token values, component contracts, and materiality conventions, and must be kept current as phases land; updating its source map is part of each design PR's definition of done.
- Security impact: minimal for the presentational phases. The later live metrics dashboard introduces data sources (build-time JSON first, runtime API pulls later) that require their own threat-model delta when implemented.
- Cost/complexity impact: low runtime cost (CSS/SVG only); moderate authoring complexity concentrated in the primitives, amortized across all later phases that compose them.

### Implementation notes (high-level)

- What changes are required: token foundation (color, type) and primitive components; phased composition into hero, content sections, an engineering page, and a metrics dashboard.
- What gets removed or deprecated: the visual-identity content of the former "UX Design System & Patterns" page is superseded; that page is retitled to "UX Engineering Standards" and rescoped to behavior (accessibility, motion, performance, responsive, testing).
- What migration considerations exist: cross-links must be established between the Design System reference (what it looks like) and UX Engineering Standards (how it behaves); neither duplicates the other.
- Deferral: true dimensional realism via WebGL/Three.js is deferred to a later phase and, if pursued, scoped to a single hero centerpiece rather than the whole site, to contain cost. It is an enhancement, never a dependency.

## Validation / Expected outcomes

- The redesigned interface maintains WCAG AA in both themes and does not regress the performance budget (Lighthouse and Core Web Vitals targets hold).
- A reviewer perceives the site as distinctive and professionally designed, and the design reinforces the engineering narrative.
- Every later design phase composes the documented primitives and updates the Design System reference, keeping the system coherent and the docs current.

## Failure modes / Troubleshooting

- Effects creep past the budget (an animation or filter degrades performance or accessibility) → the CSS/SVG-only, AA, dark-default constraint set is a standing acceptance criterion for design PRs; revert the offending effect.
- The aesthetic reads as gimmicky to the target audience → keep copy-heavy and CV surfaces restrained; concentrate character in the hero and dashboard; lean on the autobiographical rationale.
- Design-system reference drifts from source → keeping the source map current is part of each design PR's definition of done.

## References

- Related architecture pages: Design System reference (20-engineering) — owns _what the interface looks like_ (tokens, components, materiality).
- UX Engineering Standards (20-engineering) — owns _how the interface must behave_ (accessibility, motion/performance, responsive, testing).
- Related threat model(s): the live metrics dashboard's data-source threat-model delta (added when that phase lands).
- Related runbook(s): (none specific to this decision).
- Related CI/CD documentation: existing quality gates enforce lint/format/typecheck/build/tests on all design PRs.
- Source: Portfolio App `src/app/globals.css`, `src/app/layout.tsx`, `src/components/` primitives.
