---
title: 'UX Design System & Patterns'
description: 'Visual design system, component patterns, navigation architecture, and accessibility standards for portfolio applications.'
sidebar_position: 5
tags: [ux, design-system, accessibility, navigation, component-patterns]
---

# UX Design System & Patterns

## Purpose

Define consistent UX patterns, visual design principles, and accessibility standards for portfolio applications. This enables:

- **Consistency** across all portfolio pages and future projects
- **Reusability** of tested patterns and components
- **Accessibility** compliance with WCAG AA standards
- **Maintainability** through clear design documentation

---

## Scope

### In scope

- Visual identity (color, typography, spacing)
- Component patterns (buttons, links, cards, forms)
- Layout components (header, footer, navigation)
- Navigation architecture (sticky headers, responsive behavior)
- Accessibility standards and validation
- Animation strategy and performance
- Theme system (dark/light mode patterns)

### Out of scope

- Technical implementation details (see [Theme System Reference](../70-reference/theme-system-reference.md))
- Specific project color overrides or custom themes
- JavaScript framework specifics

---

## Design System Overview

### Visual Identity

**Color Palette:**

- **Primary:** Zinc scale (zinc-50 through zinc-950) for neutral UI
- **Accent:** Blue for interactive elements, CTAs, links
- **Semantic:** Status colors (green=success, amber=warning, red=error)

**Why Zinc?**

- Neutral, professional appearance
- Works well in both light and dark modes
- Large enough palette for subtle differentiation
- Industry standard (matches Apple, GitHub, Vercel palettes)

**Typography:**

- System font stack: `-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif`
- Responsive sizing: Base 16px, h1=32px, h2=24px, h3=20px, body=16px, caption=14px
- Line-height: 1.5 for body (readability), 1.2 for headings
- Font weights: Regular 400, Medium 500, Semibold 600

**Spacing:**

- Base unit: 4px (Tailwind default)
- Common gaps: 8px (gap-2), 16px (gap-4), 24px (gap-6), 32px (gap-8)
- Containers: `max-w-5xl` (64rem) for optimal line length

**Breakpoints (Tailwind defaults):**

```
sm: 640px   (mobile)
md: 768px   (tablet)
lg: 1024px  (desktop)
xl: 1280px  (large desktop)
2xl: 1536px (ultra-wide)
```

---

## Component Patterns

### Interactive Components

**Buttons**

Pattern: Zinc background, blue accent on hover/focus

```tsx
<button
  className="rounded-lg px-4 py-2 bg-zinc-100 hover:bg-zinc-200 
                   dark:bg-zinc-800 dark:hover:bg-zinc-700 
                   transition-colors duration-200 focus:ring-2 focus:ring-blue-500"
>
  Action
</button>
```

**Key Patterns:**

- Rounded corners (`rounded-lg`) for modern feel
- Hover color change (not just opacity)
- Focus ring for keyboard users
- Dark mode variant via `dark:` prefix
- 200ms transition for smooth feel

**Links**

Pattern: Text links with color change and underline on hover

```tsx
<a
  href="/"
  className="text-blue-600 hover:text-blue-800 dark:text-blue-400 
                       dark:hover:text-blue-300 underline-offset-2"
>
  Link text
</a>
```

**Key Patterns:**

- Semantic color (blue for links)
- Underline visible in both states
- Underline offset for readability
- Dark mode color adjustment (lighter blue)

**Form Inputs**

Pattern: Bordered inputs with focus ring

```tsx
<input
  type="text"
  className="px-3 py-2 border border-zinc-300 dark:border-zinc-600 
                              rounded-lg focus:ring-2 focus:ring-blue-500 
                              focus:border-transparent"
/>
```

**Key Patterns:**

- Clear border (not just underline)
- Focus ring to indicate interactive element
- Padding for touch-friendly size (44px minimum)
- Clear visual feedback

**Cards**

Pattern: Subtle shadow, border, and padding

```tsx
<div
  className="rounded-lg border border-zinc-200 dark:border-zinc-800 
                bg-white dark:bg-zinc-950 shadow-sm p-6"
>
  Card content
</div>
```

**Key Patterns:**

- Subtle border (not filled background)
- Small shadow for depth (not aggressive)
- Consistent padding
- Dark mode border instead of trying to darken white

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
<header className="border-b border-zinc-200 dark:border-zinc-800 sticky top-0 bg-white dark:bg-zinc-950 z-40">
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
- **CV** (/cv) - Interactive timeline and skills
- **Projects** (/projects) - Portfolio showcase
- **Evidence (Docs)** - Documentation app link
- **Contact** (/contact) - Contact information

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
│ Logo      Theme  │  Header (all nav visible, no hamburger)
├──────────────────┤
│  Main content    │
│  (full width,    │
│   px-4 padding)  │
└──────────────────┘
```

**Current approach:** All nav items remain visible on mobile (horizontal scroll if needed)

**Future (planned):** Hamburger menu for screens < 640px

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
  className="focus:ring-2 focus:ring-blue-500 focus:outline-none rounded"
>
  CV
</Link>;

{
  /* Buttons use <button> */
}
<button className="focus:ring-2 focus:ring-blue-500 focus:outline-none rounded">
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

**Current Implementation:**

- Horizontal scroll navigation on small screens
- All links remain visible
- Touch-friendly spacing (gap-4)
- Theme toggle always visible

**Future Enhancement:**

- Hamburger menu for screens < md
- Slide-in navigation drawer
- Close drawer on link selection
- Smooth animation for drawer toggle

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

1. **Color Contrast:** 4.5:1 minimum for normal text, 3:1 for large text

   ```
   Light bg + dark text: #FFFFFF + #111827 = 16.1:1 ✅
   Light bg + gray text: #FFFFFF + #595959 = 6.4:1 ✅
   Dark bg + light text: #0A0A0A + #FFFFFF = 13.2:1 ✅
   ```

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
- Use semantic color names (`--accent-primary`, not `--brand-blue`)

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
  <Link href="/new-section" className="text-sm hover:text-blue-600">
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

- [Theme System Technical Reference](../70-reference/theme-system-reference.md)
- [WCAG 2.1 Level AA Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)
- [Next.js Image Component](https://nextjs.org/docs/app/api-reference/components/image)
- [MDN: Accessible Forms](https://developer.mozilla.org/en-US/docs/Learn/Accessibility/HTML#forms)
