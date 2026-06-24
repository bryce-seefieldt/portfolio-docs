---
title: 'UX Engineering Standards'
description: 'Accessibility, interaction, motion, performance, responsive, and testing standards for portfolio applications.'
sidebar_position: 5
sidebar_label: 'UX Engineering Standards'
tags: [ux, accessibility, interaction, performance, responsive, testing]
---

# UX Engineering Standards

## Purpose

Define consistent behavior and quality standards for portfolio UX across accessibility, interaction, motion, performance, and responsive implementation. This enables:

- **Consistency** across all portfolio pages and future projects
- **Reusability** of tested interaction and accessibility patterns
- **Accessibility** compliance with WCAG AA standards
- **Maintainability** through clear UX engineering documentation

For visual identity, tokens, and component materiality, see the **Design System reference**:

- [Design System (engineering/design-system)](https://bryce.seefieldt.ca/docs/engineering/design-system)

---

## Scope

### In scope

- Layout and navigation behavior (header, footer, route structure)
- Navigation architecture (sticky behavior, keyboard access, responsive behavior)
- Accessibility standards and validation
- Animation strategy and performance
- Theme consistency discipline (token-driven, class-safe implementation)
- UX testing approach (manual + automated)

### Out of scope

- Visual identity definitions (color palettes, typography specs, spacing scales)
- Design-token authority and component visual specs (see Design System reference)
- Framework-specific implementation details (see [Theme System Reference](../70-reference/theme-system-reference.md))

---

## Layout Components

### Sticky Header

**Rationale:**

The portfolio uses a sticky (not fixed) header to keep navigation accessible while scrolling. This choice balances:

- **Pros:** Always-visible navigation, clear scroll position context, professional UX
- **Cons:** Slight reduction in viewport height (minimal with 4px padding)
- **Alternative considered:** Non-sticky header rejected for poor UX on long pages

**Implementation:**

```tsx
<header className="sticky top-0 z-40">
  <div className="mx-auto max-w-5xl px-4 py-4 flex items-center justify-between">
    {/* Logo */}
    {/* Navigation */}
  </div>
</header>
```

**Key Patterns:**

- `sticky top-0` (browser native, performant)
- `z-40` (ensures above content, below modals if added)
- Border below for visual separation
- Background color required for sticky to not see-through

### Navigation Link Structure

**Primary Navigation:**

- **Home** (/) - Landing page with proposition
- **Work** (/projects) - Portfolio showcase
- **CV** (/cv) - Career timeline and experience
- **Engineering Docs** (external docs app)
- **Contact** (/contact) - Contact information
- **GitHub** (external repository link)

**Navigation Behavior:**

- Keyboard navigable (Tab/Shift+Tab)
- ARIA labels for screen readers: `aria-label="Main navigation"`
- Current page indication (visual + semantic)
- Responsive adaptation (horizontal on desktop, expandable on mobile)

### Responsive Layout

**Desktop (lg and above):**

```
┌─────────────────────────────────────┐
│ Logo        Nav1 Nav2 Nav3 Theme    │  Header (sticky)
├─────────────────────────────────────┤
│                                     │
│        Main content (max-w-5xl)    │
│                                     │
├─────────────────────────────────────┤
│ Footer links                        │
└─────────────────────────────────────┘
```

**Mobile (< md):**

```
┌──────────────────┐
│ Logo      Menu   │  Header with expandable mobile nav
├──────────────────┤
│  Main content    │
│  (full width,    │
│   px-4 padding)  │
└──────────────────┘
```

**Current approach:** Collapsible mobile navigation with an accessible menu toggle.

---

## Navigation Architecture

### Keyboard Navigation

**Accessibility Requirements:**

- All interactive elements focusable via Tab key
- Logical tab order: left-to-right, top-to-bottom
- Clear focus indicators (ring utilities minimum 2px)
- No `tabindex="-1"` abuse (keeps elements in tab order)
- Links and buttons distinguishable to assistive tech

**Implementation:**

```tsx
{
  /* Links use <a> or Link component */
}
<Link
  href="/cv"
  className="focus-visible:outline focus-visible:outline-2 rounded"
>
  CV
</Link>;

{
  /* Buttons use <button> */
}
<button className="focus-visible:outline focus-visible:outline-2 rounded">
  Action
</button>;

{
  /* Skip link for screen readers (placed first in DOM) */
}
<a href="#main" className="sr-only focus:not-sr-only">
  Skip to main content
</a>;
```

### Mobile Responsiveness

**Current implementation:**

- Collapsible navigation on small screens
- All primary routes remain reachable via keyboard and touch
- Touch-friendly spacing and targets
- Theme toggle always visible

---

## Animation Strategy

### Performance-First Approach

**Principle:** Use CSS transforms and opacity (GPU-accelerated), never layout-affecting properties

**Allowed:**

- `opacity` changes
- `transform: translate()`, `scale()`, `rotate()`
- `filter` effects (blur, brightness)

**Forbidden:**

- `width`, `height` changes (triggers layout recalculation)
- `margin`, `padding` changes (triggers reflow)
- `left`, `right`, `top`, `bottom` (use transform instead)

**Example:**

```css
/* ✅ Good: GPU accelerated */
.fade-in {
  opacity: 0;
  animation: fadeIn 300ms ease-out forwards;
}

@keyframes fadeIn {
  to {
    opacity: 1;
  }
}

/* ❌ Bad: Triggers layout */
.slide-in {
  left: -100px;
  animation: slideIn 300ms ease-out forwards;
}

@keyframes slideIn {
  to {
    left: 0;
  } /* Expensive! Use transform instead */
}
```

### Animation Types

**Fade-In (Scroll Trigger)**

Used for: Content entering viewport on scroll

```css
.scroll-fade-in {
  opacity: 0;
  transition: opacity 300ms ease-out;
}

.scroll-fade-in.in-view {
  opacity: 1;
}
```

**Implementation:** Intersection Observer API (no scroll listeners)

**Smooth Scroll**

Used for: "Back to Top" button, anchor links

```tsx
element.scrollTo({ top: 0, behavior: 'smooth' });
```

**Transition Timings:**

- Fast: 150ms (hover states, small interactions)
- Base: 200ms (theme changes, fade-ins)
- Slow: 300ms (page transitions, major layout changes)

### Respecting `prefers-reduced-motion`

**Requirement:** Disable animations for users who prefer reduced motion

**Implementation:**

```css
/* Default: with animation */
.interactive {
  transition: all 200ms ease-out;
}

/* Respect user preference */
@media (prefers-reduced-motion: reduce) {
  .interactive {
    transition: none;
  }
}
```

**Testing:**

- macOS: System Settings → Accessibility → Display → Reduce motion
- Windows: Settings → Ease of Access → Display → Show animations
- Linux: Varies by desktop environment

**Expected:** Animations disappear; functionality remains

---

## Accessibility Standards

### WCAG AA Compliance

**Target Level:** WCAG 2.1 Level AA (industry standard)

**Key Requirements:**

1. **Color Contrast:** 4.5:1 minimum for normal text, 3:1 minimum for large text

  Validate against active design tokens from the Design System reference (do not hardcode legacy palette assumptions).

2. **Keyboard Navigation:** All functionality accessible via keyboard

3. **Focus Indicators:** Visible outline on focused elements (minimum 2px)

4. **Alt Text:** All images have descriptive alt text

5. **Semantic HTML:** Proper heading hierarchy (h1-h6, no skipping levels)

6. **ARIA Labels:** Screen reader text for icon-only buttons

   ```tsx
   <button aria-label="Toggle dark mode" onClick={toggleTheme}>
     {/* Icon only */}
   </button>
   ```

7. **Form Labels:** All inputs have associated labels

   ```tsx
   <label htmlFor="name">Name</label>
   <input id="name" type="text" />
   ```

### Testing Approach

**Automated:**

- Lighthouse audit (Chrome DevTools)
- axe DevTools extension
- WAVE accessibility checker

**Manual:**

- Keyboard-only navigation (no mouse)
- Screen reader testing (NVDA on Windows, VoiceOver on Mac)
- Color contrast verification (WebAIM Contrast Checker)
- Zoom testing (200% zoom should remain usable)

**Regular cadence:** Test on every significant layout/color change

---

## Best Practices

### Theme Consistency

**DO:**

- Use CSS variables for all theme-dependent colors
- Test all components in both light and dark modes
- Verify contrast ratios in both modes
- Use token-driven names and values defined in shared `globals.css` variable sets

**DON'T:**

- Hardcode hex/RGB values in components
- Apply theme classes directly to components (use variables)
- Assume light mode is default (always test both)
- Use `dark:` Tailwind class for everything (use variables + dark: sparingly)

### Animation Guidelines

**DO:**

- Use animations to guide attention or indicate state changes
- Keep animations under 300ms for UI feedback
- Respect `prefers-reduced-motion`
- Test animations on actual mobile hardware

**DON'T:**

- Animate for decoration alone
- Chain animations without user input (jarring)
- Use animations that block interaction
- Assume fast networks (animations should work on 3G)

### Navigation Extension Pattern

**Adding New Pages:**

1. Add route: `src/app/new-page/page.tsx`
2. Export metadata: `title`, `description`
3. Add navigation link in layout
4. Verify keyboard navigation works
5. Test sticky header behavior

**Adding New Navigation Section:**

```tsx
<nav className="flex items-center gap-4">
  {/* Existing items */}
  <Link href="/new-section" className="text-sm">
    New Section
  </Link>
</nav>
```

### Mobile-First Design

**DO:**

- Start with mobile layout (single column)
- Use responsive images (NextJS `Image` component)
- Test on actual mobile devices
- Consider touch target sizes (44px minimum)

**DON'T:**

- Design desktop first, then shrink
- Use hover-only interactions (no hover on touch)
- Assume large screens have more bandwidth

---

## References

- [Design System Reference](https://bryce.seefieldt.ca/docs/engineering/design-system)
- [Theme System Technical Reference](../70-reference/theme-system-reference.md)
- [WCAG 2.1 Level AA Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)
- [Next.js Image Component](https://nextjs.org/docs/app/api-reference/components/image)
- [MDN: Accessible Forms](https://developer.mozilla.org/en-US/docs/Learn/Accessibility/HTML#forms)
