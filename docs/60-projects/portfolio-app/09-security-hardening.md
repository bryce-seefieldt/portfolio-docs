---
title: 'Security Hardening: Implementation & Configuration'
description: 'OWASP security headers, CSP policy, environment variables, and security configuration for portfolio app'
sidebar_position: 9
tags: [security, headers, csp, configuration, implementation]
---

## Security Headers Overview

**Why Security Headers Matter:**

HTTP security headers are a defense-in-depth mechanism. They instruct the browser to enforce strict security policies, preventing common attacks like XSS, clickjacking, and MIME type confusion.

**OWASP-Recommended Headers Implemented:**

| Header                  | Value                                    | Purpose                                      |
| ----------------------- | ---------------------------------------- | -------------------------------------------- |
| X-Frame-Options         | DENY                                     | Prevent clickjacking (page cannot be framed) |
| X-Content-Type-Options  | nosniff                                  | Prevent MIME sniffing attacks                |
| X-XSS-Protection        | 1; mode=block                            | Legacy XSS filter (defense-in-depth)         |
| Referrer-Policy         | strict-origin-when-cross-origin          | Control referrer leakage to external sites   |
| Permissions-Policy      | geolocation=(), microphone=(), camera=() | Disable unused device APIs                   |
| Content-Security-Policy | (see below)                              | Prevent XSS and control script/style sources |

**Configuration Location:** `next.config.ts` in portfolio-app — `headers()` function

---

## Content Security Policy (CSP) Deep Dive

### CSP Basics

**What is CSP?** A browser security mechanism that restricts where scripts, styles, images, and other resources can be loaded from. Prevents XSS by blocking injected scripts unless they match the policy.

**Portfolio App CSP Policy:**

```
default-src 'self';
script-src 'self' 'unsafe-inline' vercel.live;
style-src 'self' 'unsafe-inline';
img-src 'self' data: https:;
font-src 'self';
connect-src 'self' vitals.vercel-analytics.com
```

### CSP Directives Explained

| Directive     | Value                                | Purpose                                                                    |
| ------------- | ------------------------------------ | -------------------------------------------------------------------------- |
| `default-src` | `'self'`                             | Default: only allow resources from same origin                             |
| `script-src`  | `'self' 'unsafe-inline' vercel.live` | Scripts from same origin + inline (Next.js) + Vercel Live (hot reload dev) |
| `style-src`   | `'self' 'unsafe-inline'`             | Styles from same origin + inline (Next.js styling)                         |
| `img-src`     | `'self' data: https:`                | Images from same origin, data URIs, and HTTPS                              |
| `font-src`    | `'self'`                             | Fonts from same origin only                                                |
| `connect-src` | `'self' vitals.vercel-analytics.com` | Network requests (fetch, XHR, WebSocket) to same origin + Vercel Analytics |

### Trade-Off: Why `unsafe-inline`?

**The Challenge:** Next.js injects inline styles and scripts for app hydration, CSS-in-JS, and dynamic optimization. Removing `unsafe-inline` would break the framework.

**Current Mitigation:**

- CSP still prevents external script injection
- CSP still prevents inline event handlers (e.g., `onclick="alert()"`)
- Framework controls what inline code is injected (no user-controlled input)

**Future Upgrade Path:**

- Upgrade to Content Security Policy Level 3 nonces/hashes when external script dependencies stabilize
- Eliminates need for `unsafe-inline` by hashing known-safe scripts
- Requires monitoring and testing to ensure no external scripts are introduced

**How to Detect CSP Violations:**

1. Browser DevTools Console: CSP violations appear as red warnings

   ```
   Refused to load the script 'https://evil.com/malware.js'
   because it violates the following Content Security Policy directive:
   "script-src 'self' 'unsafe-inline' vercel.live".
   ```

2. Monitor logs for patterns like:

   ```
   csp-violation:
     source: 'https://unexpected-domain.com/script.js'
     violation-type: script-src-elem-violation
   ```

3. Vercel dashboard includes CSP violation metrics (if report-uri is configured)

---

## Environment Variables & Public-Safe Configuration

### Environment Variable Security Contract

**The Rule:** All `NEXT_PUBLIC_*` variables must be **public-safe**. Never include secrets, API keys, or internal URLs.

**Why?** Variables prefixed with `NEXT_PUBLIC_*` are embedded in the browser bundle and visible in the HTML source. Treat them as public.

### Required Public-Safe Variables

See `.env.example` in the portfolio-app for definitive list and placeholder values:

```
# Public-safe configuration (embedded in browser)
NEXT_PUBLIC_SITE_URL=https://portfolio.example.com
NEXT_PUBLIC_DOCS_BASE_URL=https://docs.portfolio.example.com
NEXT_PUBLIC_GITHUB_REPO=https://github.com/user/portfolio-app
NEXT_PUBLIC_GITHUB_URL=https://github.com/user

# No secrets in NEXT_PUBLIC_*
# Secret values are stored in Vercel dashboard only
```

### Validation Checklist

- [ ] `.env.example` has no real credentials
- [ ] All `NEXT_PUBLIC_*` values are public URLs or identifiers
- [ ] Code review checks that config is never used for secrets
- [ ] TruffleHog scans detect any accidental secrets

---

## Testing Security Headers & CSP Locally

### Test Headers Are Present

```bash
# Start dev server
pnpm dev

# In another terminal, test headers
curl -I http://localhost:3000/

# Expected output includes:
# X-Frame-Options: DENY
# X-Content-Type-Options: nosniff
# X-XSS-Protection: 1; mode=block
# Referrer-Policy: strict-origin-when-cross-origin
# Permissions-Policy: geolocation=(), microphone=(), camera=()
# Content-Security-Policy: default-src 'self'; ...
```

### Test CSP in Browser

1. Open `http://localhost:3000/` in browser
2. Open DevTools → Console tab
3. Look for any CSP violations (red warning messages)
4. Type in Console:
   ```javascript
   // Test CSP blocks inline injection
   try {
     eval('console.log("CSP should block this")');
   } catch (e) {
     console.log('✓ CSP blocked unsafe eval');
   }
   ```
5. Network tab: verify external requests match connect-src policy

### Test CSP Violation Blocking

Create a test HTML file (don't commit):

```html
<!-- CSP Test Page -->
<script src="https://evil.com/malware.js"></script>
<!-- Should see CSP violation in console, script NOT executed -->
```

Load this and verify CSP prevents the external script from loading.

---

## Production Security Checklist

**Before deploying to production:**

- [ ] All security headers present: `curl -I https://production-domain.com/`
- [ ] No CSP violations in production logs
- [ ] Environment variables are correctly set in Vercel dashboard
- [ ] No secrets in `.env.example` or logs
- [ ] Dependency audit passes: `pnpm audit`
- [ ] Git history has no leaked secrets (checked in PR review)

**After deployment:**

- [ ] Verify headers on production: `curl -I https://production-domain.com/`
- [ ] Test critical routes load without CSP violations
- [ ] Monitor Vercel logs for any security-related errors
- [ ] Quarterly review CSP policy for necessary adjustments

---

## Security Headers & CSP Maintenance

### Monitoring CSP

**What to Monitor:**

- CSP violations in browser console (indicates potential XSS attempt or misconfiguration)
- External script injection attempts
- Style injection attempts

**Frequency:**

- Weekly: Review production logs for CSP violations
- Post-deployment: Immediately verify headers are present
- Quarterly: Review CSP policy; consider upgrade path to nonces/hashes

### Updating CSP Policy

**When to Update:**

- Adding new external script (e.g., analytics, third-party widget)
- Migrating from `unsafe-inline` to nonces (future phase)
- Removing unused external sources

**Process:**

1. Identify the new source (URL)
2. Add to appropriate CSP directive (script-src, connect-src, etc.)
3. Test locally: verify script loads without CSP violation
4. Update [portfolio-app/next.config.ts](https://github.com/bryce-seefieldt/portfolio-app/blob/main/next.config.ts)
5. Create PR with CSP change documented
6. Review in PR: why is this source needed? Is it safe?
7. Test in staging before production promotion

---

## Troubleshooting

### Issue: CSP Violation in Browser Console

**Symptom:** Red warning in DevTools Console about CSP violation

**Diagnosis:**

1. Read the CSP violation message: what source was blocked? (e.g., `https://evil.com/script.js`)
2. Check: Is this expected? Is it in the CSP policy?
3. If external script: Review PR history — when was it added?

**Resolution:**

- If expected: Add to CSP policy (e.g., `script-src 'self' https://trusted-service.com`)
- If not expected: Investigate security; consider blocking instead of allowing
- If misconfiguration: Update next.config.ts and redeploy

### Issue: Script or Style Not Loading

**Symptom:** Page renders but scripts/styles don't apply (e.g., styling missing, interactivity broken)

**Diagnosis:**

1. DevTools Console: Check for CSP violations
2. If CSP violation: The resource is blocked by policy
3. If no CSP violation: Check Network tab for other errors

**Resolution:**

- CSP violation: Determine if source is safe; add to policy if needed
- Other error: Investigate resource URL or script error separately

---

## References

- Next.js Security Headers: https://nextjs.org/docs/app/api-reference/next-config-js/headers
- OWASP Security Headers: https://owasp.org/www-project-secure-headers/
- MDN CSP: https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP
- Configuration: See portfolio-app `next.config.ts` for security headers implementation
- Security policies: [/docs/40-security/security-policies.md](/docs/40-security/security-policies.md)
- Threat model v2: [/docs/40-security/threat-models/portfolio-app-threat-model-v2.md](/docs/40-security/threat-models/portfolio-app-threat-model-v2.md)
