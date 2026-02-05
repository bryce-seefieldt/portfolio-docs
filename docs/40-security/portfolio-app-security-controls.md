---
title: 'Portfolio App Security Controls'
description: 'OWASP security headers, Content Security Policy, environment variable security, and hardening configuration.'
sidebar_position: 2
tags: [security, headers, csp, hardening, controls, reference]
---

# Portfolio App Security Controls

## Security Headers Overview

**Why Security Headers Matter:**

HTTP security headers are a defense-in-depth mechanism. They instruct the browser to enforce strict security policies, preventing common attacks like XSS, clickjacking, and MIME type confusion.

### OWASP-Recommended Headers

| Header                    | Value                                      | Purpose                                      |
| ------------------------- | ------------------------------------------ | -------------------------------------------- |
| `X-Frame-Options`         | `DENY`                                     | Prevent clickjacking (page cannot be framed) |
| `X-Content-Type-Options`  | `nosniff`                                  | Prevent MIME sniffing attacks                |
| `X-XSS-Protection`        | `1; mode=block`                            | Legacy XSS filter (defense-in-depth)         |
| `Referrer-Policy`         | `strict-origin-when-cross-origin`          | Control referrer leakage to external sites   |
| `Permissions-Policy`      | `geolocation=(), microphone=(), camera=()` | Disable unused device APIs                   |
| `Content-Security-Policy` | (see below)                                | Prevent XSS and control script/style sources |

**Configuration Location:**

- Base headers: `next.config.ts` → `headers()`
- CSP nonce: `src/proxy.ts` (per-request)

### Verification

**Test headers are present:**

```bash
# Local development
curl -I http://localhost:3000/

# Production
curl -I https://production-domain.com/

# Expected output includes all security headers above
```

---

## Content Security Policy (CSP) Deep Dive

### What is CSP?

A browser security mechanism that restricts where scripts, styles, images, and other resources can be loaded from. Prevents XSS by blocking injected scripts unless they match the policy.

### Portfolio App CSP Policy

```
default-src 'self';
script-src 'self' 'nonce-<per-request>' https://cdn.vercel-analytics.com;
style-src 'self' 'unsafe-inline';
img-src 'self' data: https:;
font-src 'self';
connect-src 'self' vitals.vercel-analytics.com
```

### CSP Directives Explained

| Directive     | Value                                                           | Purpose                                                          |
| ------------- | --------------------------------------------------------------- | ---------------------------------------------------------------- |
| `default-src` | `'self'`                                                        | Default: only allow resources from same origin                   |
| `script-src`  | `'self' 'nonce-<per-request>' https://cdn.vercel-analytics.com` | Scripts from same origin + nonce-gated inline + Vercel Analytics |
| `style-src`   | `'self' 'unsafe-inline'`                                        | Styles from same origin + inline (Next.js styling)               |
| `img-src`     | `'self' data: https:`                                           | Images from same origin, data URIs, and HTTPS                    |
| `font-src`    | `'self'`                                                        | Fonts from same origin only                                      |
| `connect-src` | `'self' vitals.vercel-analytics.com`                            | Network requests (fetch, XHR) to same origin + Vercel Analytics  |

### Trade-Off: Why `unsafe-inline` for styles?

**The Challenge:** Next.js injects inline styles for app hydration and dynamic optimization. Removing `unsafe-inline` would break rendering.

**Current Mitigation:**

- Script execution is nonce-gated per request
- CSP still prevents external script injection
- Framework controls what inline code is injected (no user-controlled input)

**Future Upgrade Path:**

- Upgrade to CSP Level 3 nonces/hashes when external dependencies stabilize
- Eliminates need for `unsafe-inline`
- Requires monitoring to ensure no external scripts are introduced

### Detecting CSP Violations

**Browser DevTools Console:**

```
Refused to load the script 'https://evil.com/malware.js'
because it violates the following Content Security Policy directive:
"script-src 'self' 'unsafe-inline' vercel.live".
```

**Production logs:**

```
csp-violation:
  source: 'https://unexpected-domain.com/script.js'
  violation-type: script-src-elem-violation
```

---

## Testing Security Headers & CSP

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
# Content-Security-Policy: default-src 'self'; script-src 'self' 'nonce-...'; ...
```

### Test CSP in Browser

1. Open `http://localhost:3000/` in browser
2. Open DevTools → Console tab
3. Look for any CSP violations (red warning messages)
4. Test CSP blocks unsafe eval:

   ```javascript
   try {
     eval('console.log("CSP should block this")');
   } catch (e) {
     console.log('✓ CSP blocked unsafe eval');
   }
   ```

5. Network tab: verify external requests match `connect-src` policy

### Test CSP Violation Blocking

Try loading an external script (for testing only):

```javascript
// In console
const img = document.createElement('img');
img.src = 'https://evil.com/tracker.gif';
// Should see CSP violation, image NOT loaded
```

---

## Environment Variables & Configuration

### Public-Safe Configuration

**The Rule:** All `NEXT_PUBLIC_*` variables must be **public-safe**. Never include secrets, API keys, or internal URLs.

**Why?** Variables prefixed with `NEXT_PUBLIC_*` are embedded in the browser bundle and visible in HTML source. Treat them as public.

### Required Variables (.env.example)

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
- [ ] No environment variables leaked in build output

---

## Dependency Audit Policy

### Scanning & Updates

- **Weekly scans:** Dependabot checks for vulnerabilities
- **GitHub alerts:** Immediate notification of new CVEs
- **CI validation:** `pnpm audit` enforced in build
- **Frozen lockfile:** CI installs with `--frozen-lockfile` to prevent drift

### Response Times (MTTR Targets)

| Severity     | MTTR     | Action                         |
| ------------ | -------- | ------------------------------ |
| **Critical** | 24 hours | Immediate patch and deploy     |
| **High**     | 48 hours | Priority patch within 2 days   |
| **Medium**   | 2 weeks  | Include in next release cycle  |
| **Low**      | 4 weeks  | Address with other maintenance |

### Escalation

If MTTR targets are at risk:

1. Notify team lead
2. Escalate to security team if Critical
3. Document all incidents in postmortem template
4. Consider applying temporary workaround if patch unavailable

---

## Secrets Management

### Pre-Commit Scanning

Optional local validation using TruffleHog:

```bash
# Install TruffleHog
brew install trufflesecurity/trufflehog/trufflehog  # macOS
# or download from https://github.com/trufflesecurity/trufflehog/releases

# Run scan
pnpm secrets:scan
```

### CI Secrets Scanning

Automatic scanning on all PRs using TruffleHog:

- **Scope:** Entire repository contents
- **Pattern detection:** Credit cards, API keys, tokens, certificates
- **Gate:** PR cannot merge if secrets detected

---

## Mutation Safety Controls

### Input Validation

- All mutation endpoints validate input with Zod.
- Unknown or malformed payloads are rejected with `400`.

### CSRF Protection

- Double-submit CSRF tokens are issued via `/api/csrf`.
- Non-idempotent routes require `x-csrf` header matching the `csrf` cookie.

### Rate Limiting

- Mutation endpoints are throttled per IP to reduce abuse.
- Requests exceeding limits return `429`.

### Prevention Checklist

- [ ] No secrets in `.env.example`
- [ ] No tokens or keys in Git history
- [ ] All `NEXT_PUBLIC_*` values are public-safe
- [ ] Vercel dashboard stores all secrets (not `.env`)
- [ ] TruffleHog passes in CI before merge
- [ ] Pre-commit hooks optional but recommended

---

## Incident Response

### Security Incident Detection

**Automated detection:**

- TruffleHog scanning on every PR
- CodeQL static analysis for vulnerabilities
- Dependabot alerts for known CVEs
- Vercel logs monitored for suspicious activity

**Manual detection:**

- Code review identifies suspicious patterns
- Vercel dashboard alerts for deployment failures
- External security scanner reports (future)

### Response Procedures

**If secrets detected:**

1. **Immediate:** Block PR from merging
2. **Triage:** Determine scope (what was leaked? where?)
3. **Contain:** Rotate any exposed credentials immediately
4. **Remediate:** Remove secret from history, force push
5. **Verify:** Confirm removal in all branches and builds
6. **Document:** Create postmortem detailing incident and prevention

**If vulnerability discovered:**

1. **Triage:** Assess severity and affected systems
2. **Patch:** Apply security update or workaround
3. **Deploy:** Fast-track fix to production
4. **Communicate:** Update team and stakeholders
5. **Document:** Track in postmortem template

---

## Security Hardening Checklist

### Before Deployment

- [ ] All security headers present: `curl -I https://production-domain.com/`
- [ ] No CSP violations in production logs
- [ ] Environment variables correctly set in Vercel dashboard
- [ ] No secrets in `.env.example` or Git history
- [ ] Dependency audit passes: `pnpm audit`
- [ ] CodeQL scan passes
- [ ] TruffleHog scan passes
- [ ] No suspicious code patterns in PR review

### After Deployment

- [ ] Verify headers on production
- [ ] Verify critical routes load without CSP violations
- [ ] Monitor Vercel logs for security-related errors
- [ ] Confirm analytics and monitoring active

### Ongoing Maintenance

- [ ] Weekly: Review Dependabot PR updates
- [ ] Weekly: Review CSP violation logs
- [ ] Monthly: Run full security audit
- [ ] Quarterly: Review and update CSP policy
- [ ] Quarterly: Review threat model

---

## Troubleshooting

### Issue: CSP Violation in Browser Console

**Symptom:** Red warning in DevTools Console about CSP violation

**Steps:**

1. Read the CSP violation message: what source was blocked?
2. Determine: Is this expected?
3. Check: Is the source in the CSP policy?

**Resolution:**

- If expected: Add to CSP policy in `next.config.ts`
- If not expected: Investigate security; consider blocking instead
- If misconfiguration: Update config and redeploy

### Issue: Script or Style Not Loading

**Symptom:** Page renders but functionality broken (styling missing, interactivity gone)

**Steps:**

1. DevTools Console: Check for CSP violations
2. If violation: Resource is blocked by policy
3. If no violation: Check Network tab for other errors

**Resolution:**

- CSP violation: Determine if source is safe; add to policy if needed
- Other error: Investigate resource URL or script error separately

### Issue: Health Check Failing

**Symptom:** `/api/health` returns 500 or 503 status

**Steps:**

1. Check Vercel logs for error details
2. Verify environment variables set correctly
3. Check build completed successfully
4. Verify registry/data files load correctly

**Resolution:**

- Environment error: Add missing variables in Vercel dashboard
- Build error: Check build logs; fix and redeploy
- Registry error: Verify data file syntax and format

---

## References

- [OWASP Security Headers](https://owasp.org/www-project-secure-headers/)
- [Content Security Policy (MDN)](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP)
- [Next.js Security Headers](https://nextjs.org/docs/app/api-reference/next-config-js/headers)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Threat Model: Portfolio App](/docs/40-security/threat-models/portfolio-app-threat-model-v2.md)
