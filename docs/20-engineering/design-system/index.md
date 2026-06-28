---
title: 'Design System'
sidebar_label: 'Design System'
sidebar_position: 1
description: "The Portfolio App's cassette-futurism design system: token philosophy, the control-panel component language, and a source map of where every design parameter lives in the application code."
tags: [engineering, design, frontend, reference]
---

# Design System

> Maintainer note: this page is the stable entrypoint for design-system references. Keep the source map current whenever component paths, control primitives, or motion behavior changes.

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

The interface presents one coherent hardware fiction in two states: light mode is warm beige institutional hardware in daylight (powered down), and dark mode is the same hardware powered on with phosphor instrumentation. It is stylized and confidently web-native (not photoreal), and readability always wins.

## Phase 2C token lock (current)

- Light mode palette (locked): `#E8E2D0` page base, `#D4CBB3` surface, `#C9BFA3` inset surface, `#1A1814` primary ink, `#A34722` accent, `#9A958A` line.
- Dark mode palette (locked): `#0A0A0A` page base, `#1A1814` surface, `#211E18` inset surface, `#E8E2D0` warm-cream ink, `#00FF41` phosphor accent, `#003311` divider line.
- Type registers (locked): Space Grotesk (display), Inter (body), JetBrains Mono (mono/readouts), Departure Mono (pixel accent labels and counters).
- Panel grammar (locked): prose on clean background, data in inset panels, interactive controls in raised/outset panels.

## Source map (where the design lives in `portfolio-app`)

> Fill in / confirm exact paths during implementation. This map is the single most useful entry on this page for a maintainer or reviewer.

| Concern                       | Source location                                    | Notes                                                                               |
| ----------------------------- | -------------------------------------------------- | ----------------------------------------------------------------------------------- |
| Color tokens (both modes)     | `src/app/globals.css`                              | Phase 2C lock under `:root` (dark powered-on) and `html.light` (beige powered-down) |
| Typography (fonts)            | `src/app/layout.tsx`                               | `next/font` setup for Space Grotesk, Inter, JetBrains Mono, Departure Mono          |
| Type scale + glow utilities   | `src/app/globals.css`                              | `type-*`, `type-register-pixel`, `glow-accent`, control-strip/control-link classes  |
| Panel primitive               | `src/components/Panel.tsx`                         | Elevated + inset variants, rivets, sheen, bevel                                     |
| Readout primitive             | `src/components/Readout.tsx`                       | Long string compaction to prevent overlap with adjacent readouts                    |
| LabelTag primitive            | `src/components/LabelTag.tsx`                      | Uppercase mono utilitarian labels/chips                                             |
| Dial primitive                | `src/components/Dial.tsx`                          | Static analog gauge SVG; needle/tick math                                           |
| ControlButton primitive       | `src/components/ControlButton.tsx`                 | Deep hardware CTA/control element with inlaid labels for hero and nav               |
| Theme switch primitive        | `src/components/ThemeToggle.tsx`                   | Cockpit-style backlit rocker with localStorage persistence and html class toggling  |
| Deploy pipeline primitive     | `src/components/DeployPipeline.tsx`                | One-time staged LED sequence with post-spec timing (1s per stage)                   |
| Nav control strip composition | `src/components/NavigationEnhanced.tsx`            | Full-bleed brand-and-controls control strip, no hamburger/menu toggle               |
| Footer recessed panel         | `src/app/layout.tsx` + `src/app/globals.css`       | Inset footer surface with control-style text links                                  |
| Hero composition              | `src/app/page.tsx`                                 | Above-the-fold split layout with clean copy area and instrumentation panel          |
| Home module composition       | `src/app/page.tsx`                                 | Module 01-06 order and section-level panel grammar                                  |
| Operating principles panel    | `src/components/home/OperatingPrinciplesPanel.tsx` | Accessible annunciator (`radiogroup`/`radio`) plus `aria-live` CRT detail           |
| By-the-numbers cluster        | `src/components/home/ByTheNumbersCluster.tsx`      | Banked inset instrumentation (seven-segment, nixie, bar, gauge, lamps)              |
| Career era cards              | `src/components/home/CareerEraCards.tsx`           | Four channel-strip style cards for era highlights                                   |
| Design preview                | `src/app/design-tokens-preview/page.tsx`           | Isolated primitive preview (not in production nav)                                  |

## Sub-references

- **Components** (`components.md`) — each primitive's purpose, props, accessibility behavior, and source path.
- **Tokens** (`tokens.md`) — color values for both modes, mapping, type scale, source paths. _(Create when token documentation is fully normalized.)_
- **Materiality & motion** (`materiality-and-motion.md`) — depth/texture conventions (single top-left light source, bevel/shadow approach, glow intensity) and animation philosophy. _(Create when final polish values are locked.)_

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
- [Design System: Components Reference](/20-engineering/design-system/components.md)
- Portfolio App source: `globals.css`, `src/components/`, `layout.tsx`.
