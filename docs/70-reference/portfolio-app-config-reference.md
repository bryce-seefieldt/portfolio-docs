---
title: 'Portfolio App Configuration Reference'
description: 'Comprehensive reference for Portfolio App configuration files: Next.js, ESLint, Prettier, PostCSS, and TypeScript compiler options.'
sidebar_position: 1
tags:
  [
    reference,
    configuration,
    portfolio-app,
    nextjs,
    eslint,
    prettier,
    typescript,
  ]
---

## Purpose

Provide a centralized reference for all Portfolio App configuration files, including rationale, options, and troubleshooting guidance.

## Scope

Configuration files covered:

- `next.config.ts` — Next.js framework configuration
- `eslint.config.mjs` — ESLint linting rules (flat config)
- `prettier.config.mjs` — Prettier formatting rules
- `postcss.config.mjs` — PostCSS and Tailwind integration
- `tsconfig.json` — TypeScript compiler options
- `.nvmrc` — Node version pinning

---

## `next.config.ts`

### Current configuration

```typescript
import type { NextConfig } from 'next';

const nextConfig: NextConfig = {
  /* config options here */
  reactCompiler: true,
};

export default nextConfig;
```

### Options

**`reactCompiler: true`**

- Enables the React Compiler (React 19 experimental feature)
- Automatically optimizes components for performance
- See ADR-0009 for decision rationale
- Rollback: set to `false` if compiler issues arise

### Future options (staged)

- `basePath` — if deploying to a subpath (not planned)
- `images.remotePatterns` — for external image optimization (when needed)
- `experimental.ppr` — Partial Prerendering (future enhancement)

### References

- Next.js configuration docs: https://nextjs.org/docs/app/api-reference/next-config-js
- ADR-0009: React Compiler

---

## `eslint.config.mjs`

### Current configuration

```javascript
import { defineConfig, globalIgnores } from 'eslint/config';
import nextVitals from 'eslint-config-next/core-web-vitals';
import nextTs from 'eslint-config-next/typescript';

const eslintConfig = defineConfig([
  ...nextVitals,
  ...nextTs,
  globalIgnores([
    '.next/**',
    'out/**',
    'dist/**',
    'coverage/**',
    '.vercel/**',
    'next-env.d.ts',
  ]),
]);

export default eslintConfig;
```

### Configuration approach

- **Flat config** (ESLint 9+) — modern ESLint standard
- Presets:
  - `eslint-config-next/core-web-vitals` — Next.js recommended rules (accessibility, performance)
  - `eslint-config-next/typescript` — TypeScript integration rules
- **Global ignores** — build artifacts, generated files, vendor folders

### Rationale

- Flat config simplifies composition and improves clarity
- Next.js presets align with framework best practices
- Zero warnings enforced via `--max-warnings=0` in CI

### Troubleshooting

- **Lint failures on type issues:** Ensure `tsconfig.json` is valid and `pnpm typecheck` passes
- **Rules too strict:** Override specific rules in `eslintConfig` array if justified; document via ADR if significant
- **Ignores not working:** Verify paths match repo structure; flat config uses `**` glob patterns

### References

- ESLint flat config docs: https://eslint.org/docs/latest/use/configure/configuration-files-new
- Next.js ESLint docs: https://nextjs.org/docs/app/building-your-application/configuring/eslint

---

## `prettier.config.mjs`

### Current configuration

```javascript
/** @type {import("prettier").Config} */
const config = {
  semi: true,
  singleQuote: false,
  trailingComma: 'all',
  printWidth: 100,
  tabWidth: 2,
  plugins: ['prettier-plugin-tailwindcss'],
};

export default config;
```

### Options explained

| Option          | Value                             | Rationale                                                |
| --------------- | --------------------------------- | -------------------------------------------------------- |
| `semi`          | `true`                            | Explicit semicolons for clarity (standard JS convention) |
| `singleQuote`   | `false`                           | Double quotes for consistency with JSON and JSX defaults |
| `trailingComma` | `"all"`                           | Cleaner diffs and easier array/object expansion          |
| `printWidth`    | `100`                             | Balance readability and horizontal space                 |
| `tabWidth`      | `2`                               | Standard for modern JS/TS projects                       |
| `plugins`       | `["prettier-plugin-tailwindcss"]` | Automatic Tailwind class sorting                         |

### Tailwind plugin

- **Purpose:** Automatically sorts Tailwind utility classes in a consistent order
- **Benefit:** Eliminates manual class ordering; improves diff quality
- **Requirement:** ESM config (`prettier.config.mjs`) to support plugin ESM/TLA

### Troubleshooting

- **Format check fails repeatedly:** Run `pnpm format:write` locally and commit
- **Plugin errors:** Ensure `prettier-plugin-tailwindcss` version is compatible with `prettier` and `tailwindcss` versions
- **Config not loading:** Verify filename is `prettier.config.mjs` (ESM) not `.prettierrc` (JSON)

### References

- Prettier options: https://prettier.io/docs/en/options.html
- Tailwind Prettier plugin: https://github.com/tailwindlabs/prettier-plugin-tailwindcss

---

## `postcss.config.mjs`

### Current configuration

```javascript
/** @type {import('postcss-load-config').Config} */
const config = {
  plugins: {
    '@tailwindcss/postcss': {},
  },
};

export default config;
```

### Options

**`@tailwindcss/postcss`**

- Tailwind CSS v4 PostCSS plugin
- Processes `@import "tailwindcss"` in `globals.css`
- No additional configuration needed (Tailwind v4 uses CSS-first config)

### Rationale

- Tailwind v4 requires PostCSS integration via this plugin
- Simpler than v3 (no `tailwind.config.js` needed for basic usage)
- See ADR-0010 for Tailwind v4 decision (to be created)

### References

- Tailwind v4 docs: https://tailwindcss.com/docs/v4-beta
- PostCSS plugin docs: https://github.com/tailwindlabs/tailwindcss/tree/next/packages/%40tailwindcss-postcss

---

## `tsconfig.json`

### Key compiler options

```json
{
  "compilerOptions": {
    "target": "ES2017",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [{ "name": "next" }],
    "paths": {
      "@/*": ["./src/*"]
    }
  }
}
```

### Important options

| Option             | Value                    | Purpose                                          |
| ------------------ | ------------------------ | ------------------------------------------------ |
| `strict`           | `true`                   | Enable all strict type-checking options          |
| `noEmit`           | `true`                   | Type-check only (Next.js handles build)          |
| `moduleResolution` | `bundler`                | Modern module resolution for Next.js 15+         |
| `paths`            | `{ "@/*": ["./src/*"] }` | Path alias for cleaner imports                   |
| `plugins`          | `[{ "name": "next" }]`   | Next.js TypeScript plugin for App Router support |

### Rationale

- **Strict mode:** Catches type errors early; improves code quality
- **Path aliases:** Clean imports (`@/components/Callout` vs `../../components/Callout`)
- **Next.js plugin:** Provides App Router type support and validation

### Troubleshooting

- **Type errors in .next/ folder:** Ensure `.next/**` is in ESLint/TS ignore lists
- **Module resolution errors:** Verify `moduleResolution: "bundler"` and Next.js version compatibility
- **Path alias not working:** Check `baseUrl` is set (implicitly `./` in Next.js) and `paths` matches actual structure

### References

- TypeScript compiler options: https://www.typescriptlang.org/tsconfig
- Next.js TypeScript docs: https://nextjs.org/docs/app/building-your-application/configuring/typescript

---

## `.nvmrc`

### Current configuration

```
20
```

### Purpose

- Pins Node.js version to 20 LTS
- Used by `nvm use` or compatible Node version managers
- Ensures consistent Node version across local dev and CI

### Rationale

- **Node 20 LTS:** Active long-term support; security updates; modern features
- **Determinism:** Same Node version locally and in CI reduces "works on my machine" issues
- **Upgrade policy:** Follow Node.js LTS schedule; document via ADR when upgrading

### References

- Node.js release schedule: https://nodejs.org/en/about/previous-releases
- Architecture doc: `docs/60-projects/portfolio-app/architecture.md` (Node version policy)

---

## Configuration change policy

### When to update configuration

- Security advisories requiring version bumps
- Performance improvements with measurable benefit
- Framework/tooling upgrades (Next.js, ESLint, Prettier)
- New features requiring config changes (e.g., React Compiler)

### Process for significant changes

1. Create ADR if decision is durable (e.g., enable React Compiler, adopt new ESLint rules)
2. Update configuration file
3. Test locally: `pnpm quality && pnpm build`
4. Validate in CI: open PR, verify checks pass
5. Update this reference doc if options change
6. Add release note if user-facing or operationally significant

### Rollback procedure

- Revert config file to previous state
- Redeploy from reverted commit
- Document reason in ADR or postmortem if material

---

## References

- Portfolio App architecture: `docs/60-projects/portfolio-app/architecture.md`
- Testing and quality gates: `docs/60-projects/portfolio-app/testing.md`
- ADR index: `docs/10-architecture/adr/`
