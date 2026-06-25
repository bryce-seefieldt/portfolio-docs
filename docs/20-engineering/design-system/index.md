---
title: 'Design System'
sidebar_label: 'Design System'
sidebar_position: 1
description: "The Portfolio App's cassette-futurism design system: token philosophy, the control-panel component language, and a source map of where every design parameter lives in the application code."
tags: [engineering, design, frontend, reference]
---

# Design System

> Maintainer note: this is the index/overview for the design-system reference cluster in the engineering domain. It is drafted as a stub during the Phase 2 redesign and filled in incrementally as phases land. Sibling pages (to be created as content stabilizes): `tokens.md`, `components.md`, `materiality-and-motion.md`. Follow the standard seven-part page shape on each.

## Purpose

This is the authoritative reference for the Portfolio App's visual design system. It exists so a developer (or the author, months later) can understand the aesthetic intent, find any design parameter in source, and change it safely. The durable _why_ of the design direction lives in the architecture ADR (see References); this reference is the _what_ and the _where_.

### Boundary with UX Engineering Standards

This reference owns **what the interface looks like**: the design tokens (color, typography, scale), the control-panel component primitives, and the materiality conventions. A separate page, **[UX Engineering Standards](/20-engineering/ux-engineering-standards.md)** (engineering domain), owns **how the interface must behave**: accessibility (WCAG AA, keyboard, focus, ARIA, semantic HTML), motion and performance rules (`prefers-reduced-motion`, GPU-only animation), responsive/mobile-first doctrine, and testing approach. Every component documented here must meet the standards documented there. The two pages cross-link; neither duplicates the other.

### How the redesign is documented (three complementary homes)

Design work is recorded in three places, each with a distinct job; none duplicates the others:

1. **The visual-identity ADR** (10-architecture) holds the _why_: the decision, the alternatives, the constraints, and the deferral of true 3D. The durable rationale.
2. **This Design System reference** (20-engineering) holds the _what and where_: token values, component contracts, materiality conventions, and the source map. The maintainer's reference.
3. **The feature catalog** (`00-portfolio/features`) holds the _reviewer-facing capability view_: user-facing design features (e.g. the hero, the live metrics dashboard) are documented there as feature pages following `template-feature-details.md`, with low-tech and technical summaries and verification steps. Where possible these fold into existing feature groups (the hero extends "Navigation and UX Polish" and "Theming and Accessibility"); a genuinely new capability such as the live metrics dashboard may warrant its own feature-group page.

In short: _why_ lives in the ADR, _what/where_ lives here, _what a reviewer sees and how to verify it_ lives in the feature catalog. This reference stays focused on tokens, components, and source mapping, and does not restate the feature-catalog content.

## Scope

In scope: the design tokens (color, typography, scale), the reusable control-panel component primitives, the materiality and motion conventions, and a map from each of these to its location in the `portfolio-app` source tree.

Out of scope: the _behavioral_ standards every component must meet (accessibility, motion/performance rules, responsive doctrine, testing) — those live in **UX Engineering Standards**; copy/content strategy; information architecture; the historical sequence of how the system was built (that is not documented as narration by design).

## The aesthetic in two sentences

A stylized, accessible interface inspired by cassette futurism: phosphor-on-dark "powered-on" theming, control-panel framing, CRT-style readouts, and analog instrumentation, rendered with CSS and inline SVG. It is confident and clearly a website, not a photoreal hardware reproduction, and readability always wins.

## Source map (where the design lives in `portfolio-app`)

> Fill in / confirm exact paths during implementation. This map is the single most useful entry on this page for a maintainer or reviewer.

| Concern                   | Source location                          | Notes                                                                 |
| ------------------------- | ---------------------------------------- | --------------------------------------------------------------------- |
| Color tokens (both modes) | `src/app/globals.css`                    | CSS custom properties under `:root` (dark default) and `html.light`   |
| Tailwind token exposure   | Tailwind theme config                    | Maps tokens to `bg-*`, `text-*`, `border-*` utilities                 |
| Typography (fonts)        | `src/app/layout.tsx`                     | `next/font` setup for Space Grotesk, Inter, JetBrains Mono → CSS vars |
| Type scale                | `src/app/globals.css` / theme            | Scale utilities / heading classes                                     |
| Phosphor glow utility     | `src/app/globals.css`                    | `.glow-accent` (dark-mode-only layered bloom)                         |
| Panel primitive           | `src/components/Panel.tsx`               | Elevated + inset variants, rivets, sheen, bevel                       |
| Readout primitive         | `src/components/Readout.tsx`             | Metric display; consumes glow utility                                 |
| LabelTag primitive        | `src/components/LabelTag.tsx`            | Uppercase mono utilitarian labels/chips                               |
| Dial primitive            | `src/components/Dial.tsx`                | Static analog gauge SVG; needle/tick math                             |
| Hero composition          | `src/app/page.tsx`                       | Above-the-fold control-panel hero (copy, CTAs, pipeline, readouts)    |
| Design preview            | `src/app/design-tokens-preview/page.tsx` | Isolated primitive preview (not in production nav)                    |

## Sub-references

- **Tokens** (`tokens.md`) — color values for both modes, Tailwind mapping, type scale, source paths. _(Populate after the token values are final.)_
- **Components** (`components.md`) — each primitive's purpose, props, accessibility behavior, and source path. _(Populate as components stabilize through Phases 2B–2E.)_
- **Materiality & motion** (`materiality-and-motion.md`) — the depth/texture conventions (single top-left light source, bevel/shadow approach, glow intensity) and the animation philosophy. _(Populate at the polish phase.)_

## Validation / Expected outcomes

- A reviewer can locate any design parameter in source within one lookup using the source map.
- A maintainer can change a token or component and know exactly which file to edit and what the convention is.
- The reference stays current: every design phase updates the relevant sub-reference as part of its definition of done.

## Failure modes / Troubleshooting

- Source map drift (paths change but the table does not) → updating this table is part of each design PR's definition of done.
- Token values in docs diverging from `globals.css` → `tokens.md` is generated/confirmed against source, not authored independently.

## References

- [ADR-0021: Visual Identity and Design-System Direction](/10-architecture/adr/adr-0021-visual-identity.md) — the durable decision and constraints.
- [UX Engineering Standards](/20-engineering/ux-engineering-standards.md) — the accessibility, motion/performance, responsive, and testing standards every component here must meet.
- Portfolio App source: `globals.css`, `src/components/`, `layout.tsx`.
