---
title: 'Security Policies & Governance'
description: 'Formal security policies for the portfolio app and platform'
sidebar_position: 1
tags: [security, policy, governance, procedures]
---

## Dependency Audit Policy

**Policy Statement:**

The portfolio app uses a strict dependency audit and update policy to minimize vulnerability risk. All direct and transitive dependencies are scanned weekly via Dependabot. Critical and High vulnerabilities are remediated within 24–48 hours. Medium vulnerabilities are fixed within 2 weeks. Low vulnerabilities are addressed in regular dependency cycles.

**Procedures:**

- **Weekly:** Dependabot creates PRs for available security updates and new versions
- **On CVE Alert:** Triage within 1 hour, categorize severity, execute remediation per MTTR targets
- **Monthly:** Review `pnpm audit` output and risk register
- **Quarterly:** Audit policy review; update based on lessons learned

**Enforcement:**

- Dependabot PRs require review before merge (standard PR process)
- `pnpm audit --audit-level=high` runs in CI (required check; failures documented in risk register)
- Frozen lockfile installs in CI (`pnpm install --frozen-lockfile`) prevent transitive surprises

**Ownership:** Development team (all PRs), DevOps (Dependabot configuration)

**MTTR Targets:**

| Severity | MTTR     | Example                              |
| -------- | -------- | ------------------------------------ |
| Critical | 24 hours | RCE in build tool or runtime library |
| High     | 48 hours | Auth bypass, significant flaw        |
| Medium   | 2 weeks  | Moderate risk, harder to exploit     |
| Low      | 4 weeks  | Edge case, low exploitability        |

**Runbook:** [rbk-portfolio-dependency-vulnerability.md](../50-operations/runbooks/rbk-portfolio-dependency-vulnerability.md)

---

## Secrets Management Policy

**Policy Statement:**

No secrets are committed to the repository or logged. All secrets are stored in Vercel Environment Variables only. TruffleHog scanning detects accidental leaks. Structured logging prevents unintended secret exposure.

**Procedures:**

- **Development:** Use `.env.local` for local secrets (git-ignored); never commit real values
- **Configuration:** `.env.example` documents required env vars with **no real values**
- **Commit:** Pre-commit hook or manual check ensures no secrets are staged
- **CI/CD:** GitHub Actions use Vercel OIDC for auth (no static secrets in workflow)
- **Secrets Storage:** Only Vercel dashboard for production env vars
- **Scanning:** TruffleHog runs in CI to detect patterns (API keys, tokens, etc.)
- **Incident:** See [rbk-portfolio-secrets-incident.md](../50-operations/runbooks/rbk-portfolio-secrets-incident.md) for response

**Ownership:** Development team (no-secrets discipline), DevOps (TruffleHog config, Vercel admin)

**Validation:**

- `.env.example` contains no real credentials
- Vercel dashboard has no sensitive values in logs
- TruffleHog scan passes in CI before merge

---

## MDX Usage Policy (Docs)

**Policy Statement:**

MDX is treated as code. Use Markdown by default and require explicit review for new or modified MDX files.

**Procedures:**

- Default to Markdown for standard docs pages.
- Use MDX only when a component or interactive example is required.
- Review MDX changes for embedded scripts, external calls, and data exposure.
- Keep MDX components minimal and documented.

**Enforcement:**

- PR checklist requires MDX review when applicable.
- Security reviewers spot-check MDX diffs for unsafe behavior.

**Ownership:** Development team (authoring discipline), reviewers (MDX scrutiny)

---

## Security Headers Policy

**Policy Statement:**

All responses include OWASP-recommended security headers. Content Security Policy is enforced with `default-src 'self'` to reduce XSS risk. Headers are configured per platform (Next.js app via `next.config.ts`, Docusaurus docs via `vercel.json`) and validated in preview and production.

**Required Headers:**

| Header                  | Policy                                                                                                                       | Purpose                                  |
| ----------------------- | ---------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------- |
| X-Frame-Options         | DENY                                                                                                                         | Prevent clickjacking                     |
| X-Content-Type-Options  | nosniff                                                                                                                      | Prevent MIME sniffing                    |
| X-XSS-Protection        | 1; mode=block                                                                                                                | Legacy XSS protection (defense-in-depth) |
| Referrer-Policy         | strict-origin-when-cross-origin                                                                                              | Control referrer leakage                 |
| Permissions-Policy      | geolocation=(), microphone=(), camera=()                                                                                     | Disable unused APIs                      |
| Content-Security-Policy | default-src 'self'; script-src 'self' 'nonce-per-request' https://cdn.vercel-analytics.com; style-src 'self' 'unsafe-inline' | Prevent XSS, control external scripts    |
| Strict-Transport-Security | max-age=31536000; includeSubDomains; preload                                                                                 | Enforce HTTPS across domains             |

**Trade-Off: `unsafe-inline` Styles**

- **Why Required:** Frameworks may inject inline styles for hydration and theme setup
- **Risk Mitigation:** Script execution is tightly scoped; external sources are restricted
- **Future Path:** Replace inline styles with hashes or nonces when feasible

**Docs CSP profile (Docusaurus):**

- `default-src 'self'`
- `script-src 'self' 'unsafe-inline'`
- `style-src 'self' 'unsafe-inline'`
- `img-src 'self' data: https:`
- `font-src 'self' data:`
- `object-src 'none'`
- `frame-ancestors 'none'`
- `base-uri 'self'`
- `form-action 'self'`

**Validation:**

```bash
# Test locally (app)
curl -I http://localhost:3000/ | grep -E "X-Frame-Options|X-Content-Type-Options|Content-Security-Policy"

# Test preview/prod (docs)
curl -I https://<docs-domain>/ | grep -E "X-Frame-Options|X-Content-Type-Options|Content-Security-Policy"

# Browser DevTools
# → Network → select any request → Response Headers → verify all headers present
# → Console → check for CSP violations
```

**Ownership:** Development team (configuration), DevOps (validation in CI)

---

## Mutation Safety Policy (React2Shell Hardening)

**Policy Statement:**

All mutation endpoints must validate input strictly, enforce CSRF protection, and apply rate limiting. Generic deserialization or dynamic execution is prohibited.

**Procedures:**

- **Validation:** Zod schema validation for all POST/PUT/DELETE payloads
- **CSRF:** Double-submit token enforcement for any non-idempotent route
- **Rate limiting:** Per-IP throttling on mutation routes
- **CSP:** Per-request nonce for inline scripts

**Enforcement:**

- Linting and code review reject dynamic evaluation patterns
- CI audit gate must pass for releases

**Ownership:** Development team (implementation), DevOps (CI enforcement)

---

## Incident Response Policy

**Policy Statement:**

Security incidents follow a structured triage, containment, investigation, and recovery cycle. MTTR targets ensure timely response. All incidents are logged and reviewed in quarterly security meetings.

**Triage (≤15 min):**

- Assess severity (Critical / High / Medium / Low)
- Notify team immediately for Critical/High
- Document initial findings

**Containment (≤30 min):**

- Disable affected features or rollback if necessary
- Rotate compromised credentials
- Update security logs/monitoring

**Investigation (≤24 hrs):**

- Root cause analysis
- Timeline of events
- Blast radius assessment

**Recovery (24–48 hrs):**

- Full remediation and testing
- Production validation
- Customer/team communication if needed

**Postmortem (1 week):**

- Document lessons learned
- Implement preventive controls
- Update relevant runbooks

**Runbooks:**

- [rbk-portfolio-secrets-incident.md](../50-operations/runbooks/rbk-portfolio-secrets-incident.md)
- [rbk-portfolio-dependency-vulnerability.md](../50-operations/runbooks/rbk-portfolio-dependency-vulnerability.md)
- [rbk-portfolio-deployment-failure.md](../50-operations/runbooks/rbk-portfolio-deployment-failure.md)

**Ownership:** All team members (detection/reporting), dev lead (triage/response)

---

## Environment Variable Security Contract

**Policy Statement:**

Environment variables prefixed with `NEXT_PUBLIC_*` are publicly accessible in the browser and must contain only public-safe values. Secret values are never used in `NEXT_PUBLIC_*` variables.

**Public-Safe Examples:**

- `NEXT_PUBLIC_SITE_URL` — Base URL (public)
- `NEXT_PUBLIC_DOCS_BASE_URL` — Docs domain (public)
- `NEXT_PUBLIC_GITHUB_REPO` — GitHub repo URL (public)

**Never Public:**

- API keys, tokens, credentials
- Private service endpoints
- Passwords, SSH keys
- Database connection strings

**Validation:**

- `.env.example` documents all `NEXT_PUBLIC_*` with public-safe placeholder values
- Code review explicitly checks that `process.env.NEXT_PUBLIC_*` contains no secrets
- TruffleHog scans for leaked credentials

**Ownership:** Development team (discipline), all PRs reviewed for compliance

---

## References

- Threat model v2: [threat-models/portfolio-app-threat-model-v2.md](./threat-models/portfolio-app-threat-model-v2.md)
- Risk register: [risk-register.md](./risk-register.md)
- Security hardening: [../60-projects/portfolio-app/04-security.md](../60-projects/portfolio-app/04-security.md)
- Runbooks: [../50-operations/runbooks/rbk-portfolio-secrets-incident.md](../50-operations/runbooks/rbk-portfolio-secrets-incident.md) and [../50-operations/runbooks/rbk-portfolio-dependency-vulnerability.md](../50-operations/runbooks/rbk-portfolio-dependency-vulnerability.md)
