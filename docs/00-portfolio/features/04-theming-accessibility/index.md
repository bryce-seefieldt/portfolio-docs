---
title: 'Theming and Accessibility'
description: 'Governance for theming, accessibility, and motion preferences.'
sidebar_position: 4
tags: [portfolio, features, theming, accessibility]
---

## Purpose

Define how theming and accessibility features are documented and validated.

## Scope

### In scope

- light and dark theme behavior
- reduced-motion support
- color contrast and readability

### Out of scope

- general navigation patterns (see navigation group)

## Prereqs / Inputs

- Theme system reference exists

## Procedure / Content

- Use the standard feature page fields and include accessibility checks.

### Governance focus

- theme persistence must survive reloads without FOUC
- contrast and readability must meet accessibility targets
- reduced-motion settings must disable non-essential animations

## Validation / Expected outcomes

- Theme switching is reliable and accessible.

## Failure modes / Troubleshooting

- Theme mismatch or FOUC: validate initialization and CSS variables.

## References

- Feature catalog governance: [docs/00-portfolio/features/index.md](../index.md)
