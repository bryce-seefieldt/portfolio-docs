---
title: 'Tech Stack Keyboard'
description: 'Interactive radiogroup keyboard MODULE 01 showcasing curated tech stack with proportional key sizing, category color-coding, and CRT detail panel.'
tags: [feature, design-system, interaction, accessibility, theming]
sidebar_position: 6
---

## Purpose

- Feature name: Tech Stack Keyboard (MODULE 01)
- Why this feature exists: Demonstrate depth-language keycap styling, proportional key sizing, and accessible radiogroup interaction patterns in a production home-page context. The module showcases the curated tech stack with category-based color-coding and interactive detail feedback.

## Scope

### In scope

- Interactive keyboard interface with 21 curated tech-stack keys
- 6 category groupings (languages, frontend, backend, data, cloud, tooling) with distinct color roles
- Radiogroup + CRT detail pattern for accessible keyboard navigation and feedback
- Proportional key sizing (1u/1.25u/1.5u/2u) with accurate CSS width ratios
- Keyboard navigation (arrows, Home/End, Enter/Space) and focus-visible states
- Dark and light theme support using design-system tokens

### Out of scope

- Real-time tech-stack updates or dynamic key generation
- Mobile/responsive layout optimization beyond current Tailwind grid behavior
- Animation or typing effects (reduced-motion compliant)

## Prereqs / Inputs

- Design system tokens (color, type scale, depth language) locked in Phase 2C
- Keycap and Keypad primitives available and working
- OperatingPrinciplesPanel radiogroup + CRT pattern to replicate
- 21 curated tech-stack blurbs from portfolio content
- Simple Icons SVG library (or text legends for missing icons)

## Procedure / Content

### Feature summary

- Feature name: Tech Stack Keyboard (MODULE 01 / MY TOOLBOX)
- Feature group: Theming and Accessibility
- Technical summary: Interactive keyboard component using React radiogroup pattern with client-side state management, keyboard event handling (arrows, Home, End, Enter/Space), and aria-live region for detail feedback. Built from reusable Keycap/Keypad primitives with proportional sizing (1u/1.25u/1.5u/2u) via CSS `--keycap-unit` variable.
- Low-tech summary: Click a tech-stack key to see its name and a one-sentence description in the detail panel. Use arrow keys or click to navigate. Each category has a color to help organize the stack.

### Feature in action

- Where to see it working: `/` (home page, MODULE 01 / TECH STACK section)
- Visual treatment: Proportional keycap board with 6 category sections; selected key shows backlit state; detail panel on the right displays tech name and blurb
- Interaction: Click or keyboard navigate to select a key; detail panel updates with `aria-live=polite` feedback
- Theme behavior: Both light (warm beige keycaps) and dark (phosphor-green accents) modes fully supported

### Confirmation Process

#### Manual

- **Steps:**
  1. Navigate to `/`
  2. Scroll to MODULE 01 / TECH STACK section
  3. Click on any key (e.g., TypeScript, React, PostgreSQL)
  4. Verify the detail panel updates with the key's name and blurb
  5. Use arrow keys to navigate; verify all keys are reachable
  6. Press Home/End to jump to first/last key
  7. Press Enter or Space to select the currently focused key
  8. Toggle light/dark theme; verify keycap colors and contrast are correct

- **What to look for:**
  - Selected key has backlit appearance (raised top-face glow)
  - Detail panel updates immediately and reads aloud (if screen reader present)
  - All 21 keys are rendered in correct proportions (1u, 1.25u, 1.5u, 2u widths are visually accurate)
  - Category labels (LANGUAGES, FRONTEND, etc.) are visible above/below key groups
  - Keyboard navigation wraps (End → Home, Home → End on arrows)
  - No JavaScript errors in browser console
  - Reduced-motion CSS media query respected (no unnecessary transitions)

- **Artifacts or reports to inspect:**
  - E2E test: `/portfolio-app/tests/e2e/smoke.spec.ts` → smoke tests cover home page render
  - Design tokens: `/portfolio-app/src/app/globals.css` → `--keycap-unit`, keycap size classes, category color roles
  - Component: `/portfolio-app/src/components/home/TechStackKeyboard.tsx` → radiogroup setup, keyboard handler, aria-live detail

#### Tests

- Unit tests: none (component is light on logic; mostly UI/state)
- E2E tests: 
  - [smoke.spec.ts](https://github.com/bryce-seefieldt/portfolio-app/blob/feat/phase2c4-tech-stack-keyboard/tests/e2e/smoke.spec.ts#L69) — home page renders without errors
  - [smoke.spec.ts: Resilience checks › Reduced motion](https://github.com/bryce-seefieldt/portfolio-app/blob/feat/phase2c4-tech-stack-keyboard/tests/e2e/smoke.spec.ts#L55) — reduced-motion CSS respected

### Potential behavior if broken or misconfigured

- **Keycap widths all equal**: `--keycap-unit` CSS variable not set or size classes using `grid-column: span` instead of explicit widths → all keys render same size, defeating proportional sizing.
- **Detail panel doesn't update**: `selectedId` state not wired to CRT region, or radiogroup role missing → interaction feels broken.
- **Keyboard navigation broken**: `onKeyDown` handler not attached, or `tabIndex` logic incorrect → arrow/Home/End do nothing, focus not managed.
- **Color contrast fails**: keycap cap/legend pair not validated against depth-language endpoints; verify AA compliance in `globals.css` token pairs.
- **Missing icons**: Simple Icons CDN down or SVG path incorrect → fallback text legend should still render legibly.
- **Accessibility failure**: radiogroup role missing, aria-checked not managed, aria-live region not present → fails WCAG 2.1 AA keyboard and screen-reader testing.

### Long-term maintenance notes

- **Keycap sizing**: If `--keycap-unit` or gap size changes, update all four `.keycap--*u` width calc() expressions to keep ratios accurate.
- **Icon asset drift**: Text legends (Java, AWS, Azure, REST, SQL Server) are fallbacks; if Simple Icons adds these in future releases, consider updating to SVG glyphs.
- **Blurb updates**: Tech-stack blurbs are hardcoded in `STACK_KEYS` array; update there, not in the template files.
- **Category colors**: Each category uses a `--key-*` or `--key2-*` role; if design-system color palette changes, verify category contrast still meets AA.
- **Keyboard nav**: Home/End and arrow behavior relies on `STACK_KEYS.length` and modulo math; keep test coverage on edge cases (wrap, single key, etc.).

### Dependencies, libraries, tools

- React 19 (hooks: `useState`, `useMemo`, `useId`)
- TypeScript (union types for StackKeyCategory)
- Tailwind CSS (grid, responsive utilities)
- Design tokens from `src/app/globals.css` (color roles, depth language, keycap size classes)
- Simple Icons library (16 vendored SVG files as React components)

### Source code references (GitHub URLs)

- [TechStackKeyboard component](https://github.com/bryce-seefieldt/portfolio-app/blob/feat/phase2c4-tech-stack-keyboard/src/components/home/TechStackKeyboard.tsx)
- [Vendored tech stack icons](https://github.com/bryce-seefieldt/portfolio-app/blob/feat/phase2c4-tech-stack-keyboard/src/icons/TechStackIcons.tsx)
- [Home page integration](https://github.com/bryce-seefieldt/portfolio-app/blob/feat/phase2c4-tech-stack-keyboard/src/app/page.tsx#L90-L95)
- [Keycap width-ratio fixes in globals.css](https://github.com/bryce-seefieldt/portfolio-app/blob/feat/phase2c4-tech-stack-keyboard/src/app/globals.css#L1160-L1165)
- [Inline scoped suppressions for object-injection lint rule](https://github.com/bryce-seefieldt/portfolio-app/blob/feat/phase2c4-tech-stack-keyboard/src/components/home/TechStackKeyboard.tsx#L276)

### ADRs

- [ADR-0021: Visual Identity and Design-System Direction](/10-architecture/adr/adr-0021-visual-identity.md) — design direction and materiality principles
- [ADR-0014: Class-Based Dark Mode](/10-architecture/adr/adr-0014-class-based-dark-mode.md) — theme switching mechanism
- [ADR-0018: React2Shell Hardening Baseline](/10-architecture/adr/adr-0018-react2shell-hardening-baseline.md) — input validation and security defense-in-depth

### Runbooks

- Performance Troubleshooting: [rbk-portfolio-performance-troubleshooting](/50-operations/runbooks/rbk-portfolio-performance-troubleshooting.md) — if MODULE 01 render time regresses

### Additional internal references

- Design System: [/20-engineering/design-system/index.md](/20-engineering/design-system/index.md) — full source map and phase implementation notes
- UX Engineering Standards: [/20-engineering/ux-engineering-standards.md](/20-engineering/ux-engineering-standards.md) — accessibility, motion, responsive, and testing standards
- Keycap and Keypad primitives: [/20-engineering/design-system/components.md](/20-engineering/design-system/components.md) (when created)
- OperatingPrinciplesPanel pattern: source in portfolio-app at `src/components/home/OperatingPrinciplesPanel.tsx`

### External reference links

- [Simple Icons](https://simpleicons.org/) — SVG icon library used for tech stack glyphs
- [MDN: aria-live](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Attributes/aria-live) — screen-reader feedback pattern
- [MDN: Keyboard events](https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent) — arrow key handling

## Validation / Expected outcomes

- **Visual:** All 21 keys render in correct proportions; category colors match design-system roles; both light and dark themes are readable and AA-compliant.
- **Interaction:** Clicking selects a key; detail panel updates immediately; keyboard navigation (arrows, Home/End, Enter/Space) works smoothly.
- **Accessibility:** radiogroup role and aria-checked states properly set; detail region has aria-live=polite; all keys reachable by keyboard; no focus traps.
- **Performance:** MODULE 01 renders within 16ms budget; no layout shifts after initial paint; reduced-motion CSS respected.
- **Tests:** E2E smoke tests pass; all 21 keys render without console errors; no contrast violations detected.

## Failure modes / Troubleshooting

| Symptom | Root Cause | Fix |
|---------|-----------|-----|
| All keys same size | `--keycap-unit` not set or `.keycap--Xu` classes using `grid-column: span` | Update `globals.css` size classes to use `width: calc(X * var(--keycap-unit))` |
| Detail panel blank | `selectedId` state not synced to CRT region; aria-live not present | Add aria-live="polite" to detail region; wire onClick to `setSelectedId` |
| Keyboard nav broken | `onKeyDown` handler not attached or `tabIndex` logic broken | Verify all keys have `tabIndex={isActive ? 0 : -1}` and `onKeyDown` prop |
| Color contrast fails | depth-language endpoints not validated; keycap + legend pair fails AA | Run contrast checker on cap color against legend color; adjust `--depth-*` tokens if needed |
| Missing icon renders as broken image | SVG path incorrect or icon doesn't exist in Simple Icons | Use text legend fallback (Java, AWS, Azure, REST, SQL Server) instead |
| Screen reader doesn't announce updates | aria-live missing or value is "off" not "polite" | Verify detail panel has `role="status"` and `aria-live="polite"` |

## References

- Phase 2C.4 Tech Stack Keyboard specification: `portfolio-app/tmp/phase2c4-tech-stack-keyboard-spec.md`
- Keycap and Keypad component documentation: [/20-engineering/design-system/index.md](/20-engineering/design-system/index.md)
- Design-system source map: [/20-engineering/design-system/index.md#source-map-where-the-design-lives-in-portfolio-app](/20-engineering/design-system/index.md#source-map-where-the-design-lives-in-portfolio-app)
