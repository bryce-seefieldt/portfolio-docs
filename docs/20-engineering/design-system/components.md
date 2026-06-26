---
title: 'Design System: Components Reference'
sidebar_label: 'Components'
sidebar_position: 2
description: 'Component-level reference for cassette-futurism primitives used in the Portfolio App, including purpose, props, accessibility behavior, and source paths.'
tags: [engineering, design-system, components, frontend, accessibility]
---

# Components Reference

## Purpose

Document the reusable UI primitives that define the Phase 2 control-surface language so maintainers can change behavior and styling without drift.

## Scope

### In scope

- component purpose and usage boundaries
- public props and expected values
- accessibility behavior and reduced-motion handling
- source paths in portfolio-app

### Out of scope

- token value authority (see design-system index and globals)
- product-copy decisions

## Components

### ControlButton

- Purpose: Reusable deep hardware-style CTA and control link used in hero and navigation.
- Source: `portfolio-app/src/components/ControlButton.tsx`
- Styling contract: Uses `control-button` and optional compact variant classes from `portfolio-app/src/app/globals.css`.
- Materiality: Deep outset bevel, layered elevation shadow, subtle sheen, and inlaid/engraved label treatment.

Props:

- `href: string` (required) - destination URL or route
- `children: ReactNode` (required) - visible button label text
- `external?: boolean` (default false) - when true, renders external anchor semantics
- `className?: string` (default empty) - additional class composition

Accessibility behavior:

- Renders real interactive elements (`<a>` or Next.js `Link`-backed anchor semantics)
- Requires discernible visible text labels (for example: WORK, CV, DOCS)
- Focus-visible ring handled by shared control styles

Motion behavior:

- Default mode: hover energizes the face and active depresses the hardware
- Reduced motion: transitions removed by reduced-motion media query; pressed state remains static

---

### ThemeToggle (Cockpit Rocker)

- Purpose: Global mode switch between dark-default and explicit light mode.
- Source: `portfolio-app/src/components/ThemeToggle.tsx`
- Styling contract: `control-switch` family classes in `portfolio-app/src/app/globals.css`.

Behavior:

- Backlit rocker control with light/dark icon cues
- Local storage persistence and `html.light` / `html.dark` toggling

State model:

- Reads persisted `theme` from localStorage on mount
- Applies class state to `<html>`: `.light` present for light mode, `.dark` otherwise
- Persists toggled state back to localStorage

Accessibility behavior:

- Real `<button type="button">`
- Dynamic `aria-label` announces the toggle as light/dark mode control
- Keyboard operable with visible focus state

Motion behavior:

- Default mode: rocker movement transition
- Reduced motion: rocker transition removed

---

### DeployPipeline

- Purpose: Hero instrumentation sequence representing deploy lifecycle state.
- Source: `portfolio-app/src/components/DeployPipeline.tsx`
- Styling contract: `pipeline-led` stage classes in `portfolio-app/src/app/globals.css`.

Behavior contract (post-spec timing):

- Runs one time after load
- Active stage shifts every 1 second
- Sequence: COMMIT -> CHECKS -> STAGING -> PRODUCTION
- Final state: PRODUCTION remains active after the sequence; earlier stages turn off as the next stage lights

Color mapping:

- COMMIT: red
- CHECKS: orange
- STAGING: yellow
- PRODUCTION: green

Accessibility behavior:

- LED dots are decorative and marked `aria-hidden`
- Stage labels remain text-visible through `LabelTag`

Motion behavior:

- Default mode: state changes with color/glow transitions
- Reduced motion: transitions removed (state changes remain discrete)

---

### Readout

- Purpose: Display short operational metrics and status values inside control panels.
- Source: `portfolio-app/src/components/Readout.tsx`

Props:

- `value: string | number` (required)
- `unit?: string`
- `caption: string` (required)
- `className?: string`

Behavior note:

- Long or alphabetic values are automatically compacted to avoid overlap with neighboring readouts (for example: OPERATIONAL vs numeric values).

Accessibility behavior:

- Value and caption are plain text, no icon-only semantics

## Validation checklist

- Component labels remain visible and descriptive at all breakpoints
- Keyboard focus indicators are visible for all interactive controls
- Reduced-motion mode preserves function with minimized motion
- Hero readouts do not overlap at desktop, tablet, or ~360px widths

## References

- [Design System Index](/20-engineering/design-system/index.md)
- [UX Engineering Standards](/20-engineering/ux-engineering-standards.md)
- [Feature: Control-Panel Hero](/00-portfolio/features/03-navigation-ux-polish/hero-control-panel.md)
- [Feature: Theme Toggle](/00-portfolio/features/04-theming-accessibility/theme-toggle.md)
