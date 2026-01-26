---
title: 'Observability & Monitoring'
description: 'Health checks, structured logging, and failure modes for portfolio app'
sidebar_position: 8
tags: [observability, monitoring, health-checks, logging, architecture]
---

# Observability & Monitoring

## Overview

**Observability** is the ability to understand the internal state of the portfolio application by examining its outputs (logs, metrics, traces). Unlike traditional monitoring which tells you *when* something is broken, observability enables you to understand *why* it's broken and *how* to fix it.

### Why Observability Matters

- **Faster Incident Response:** Detect issues before users report them (MTTR target: < 10 minutes)
- **Proactive Problem Detection:** Identify degradation trends before they become outages
- **Evidence-Based Debugging:** Structured logs provide context for reproducing and fixing issues
- **Operational Confidence:** Clear health status enables automated monitoring and alerting

### Observability Pillars

The portfolio app implements two of the three observability pillars:

1. **Logs** — Structured JSON logs for debugging and audit trails (implemented via `src/lib/observability.ts`)
2. **Health Checks** — Application status endpoint for monitoring (implemented via `/api/health`)
3. **Metrics** — Quantitative performance measurements (future: Prometheus/StatsD export)

Future phases will add distributed tracing for request flow analysis.

### Architecture

```
┌──────────────────────────────────────────────────────────────────┐
│                     Portfolio App (Next.js)                       │
│                                                                    │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │ Application Logic                                           │  │
│  │ • Pages: /, /cv, /projects, /projects/[slug], /contact     │  │
│  │ • Components: Evidence, Section, Callout                   │  │
│  │ • Data: projects.yml registry                              │  │
│  └─────────────────┬───────────────────┬──────────────────────┘  │
│                    │                   │                          │
│                    ▼                   ▼                          │
│  ┌─────────────────────────┐  ┌───────────────────────────────┐  │
│  │ Health Check Endpoint   │  │ Structured Logging            │  │
│  │                         │  │                               │  │
│  │ GET /api/health         │  │ src/lib/observability.ts      │  │
│  │ • Status: 200/503/500   │  │ • JSON output to console      │  │
│  │ • Environment metadata  │  │ • Levels: info/warn/error/debug│  │
│  │ • Project count         │  │ • Context: route, timing, etc.│  │
│  │ • Commit SHA            │  │ • Auto environment injection  │  │
│  │ • Build timestamp       │  │                               │  │
│  └──────────┬──────────────┘  └───────────┬───────────────────┘  │
│             │                             │                       │
│             └──────────────┬──────────────┘                       │
│                            ▼                                       │
└────────────────────────────────────────────────────────────────────┘
                             │
                             ▼
         ┌──────────────────────────────────────────────┐
         │ Vercel Logs / External Monitoring Systems    │
         │                                              │
         │ • Real-time log streaming (Vercel dashboard) │
         │ • Health check polling (uptime monitors)     │
         │ • Future: Metrics export (Prometheus/Datadog)│
         └──────────────────────────────────────────────┘
```

---

## Health Check Endpoint

### Endpoint Specification

**URL:** `GET /api/health`  
**Cache Policy:** No caching (`revalidate: 0`)  
**Implementation:** [`src/app/api/health/route.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/api/health/route.ts)

### Response Format

The health endpoint returns JSON with the following fields:

| Field | Type | Description | Example |
|-------|------|-------------|---------|
| `status` | `"healthy" \| "degraded" \| "unhealthy"` | Application health state | `"healthy"` |
| `timestamp` | `string` (ISO 8601) | Response timestamp | `"2026-01-26T15:30:45.123Z"` |
| `environment` | `string` | Deployment environment | `"production"` |
| `commit` | `string` | Git commit SHA (first 7 chars) | `"a2058c7"` |
| `buildTime` | `string` (ISO 8601) | Build timestamp | `"2026-01-26T15:20:00.000Z"` |
| `projectCount` | `number` | Number of projects loaded | `8` |
| `message` | `string` (optional) | Error or degradation description | `"No projects loaded"` |
| `error` | `string` (optional) | Error message (unhealthy only) | `"Cannot load PROJECTS registry"` |

### Status Codes

| HTTP Status | State | Meaning | Action |
|-------------|-------|---------|--------|
| **200 OK** | Healthy | All systems operational, all checks passed | No action needed |
| **503 Service Unavailable** | Degraded | Core functionality works, but some features unavailable | Monitor for 5 minutes; escalate if persists |
| **500 Internal Server Error** | Unhealthy | Critical failure; service broken | Execute [incident runbook](#related-runbooks) immediately |

### Response Examples

#### Healthy (200 OK)

All checks passed, application is fully operational:

```bash
curl https://portfolio.example.com/api/health
```

```json
{
  "status": "healthy",
  "timestamp": "2026-01-26T15:30:45.123Z",
  "environment": "production",
  "commit": "a2058c7",
  "buildTime": "2026-01-26T15:20:00.000Z",
  "projectCount": 8
}
```

#### Degraded (503 Service Unavailable)

Core functionality works, but data loading issue detected:

```bash
curl https://portfolio.example.com/api/health
```

```json
{
  "status": "degraded",
  "message": "No projects loaded",
  "timestamp": "2026-01-26T15:30:45.123Z",
  "environment": "production",
  "commit": "a2058c7"
}
```

**Typical causes:** Empty or corrupted project registry, environment variable misconfiguration

#### Unhealthy (500 Internal Server Error)

Critical exception during health check indicates broken application:

```bash
curl https://portfolio.example.com/api/health
```

```json
{
  "status": "unhealthy",
  "error": "Cannot read properties of undefined (reading 'length')",
  "timestamp": "2026-01-26T15:30:45.123Z",
  "environment": "production"
}
```

**Typical causes:** Build failure, missing dependencies, configuration error

### Testing the Health Endpoint

**Local development:**

```bash
# Start dev server
pnpm dev

# Test health endpoint
curl http://localhost:3000/api/health | jq .
```

**Production:**

```bash
# Test deployed production
curl https://portfolio-app.vercel.app/api/health | jq .

# Expected: status "healthy", projectCount > 0
```

**Automated monitoring:**

```bash
# Simple uptime check (returns 0 if healthy, 1 otherwise)
curl -sf https://portfolio-app.vercel.app/api/health | jq -e '.status == "healthy"'
```

---

## Structured Logging

### Overview

Structured logging outputs logs as JSON for machine parsing by monitoring systems. Unlike plain-text logs, structured logs enable:

- **Filtering:** Query by level, route, error type, etc.
- **Aggregation:** Group errors by category, count occurrences, track trends
- **Correlation:** Link logs across requests using context IDs
- **Alerting:** Trigger alerts based on specific log patterns

### Log Format

All logs follow the `LogEntry` interface from [`src/lib/observability.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/observability.ts):

```typescript
interface LogEntry {
  timestamp: string;           // ISO 8601 timestamp
  level: 'info' | 'warn' | 'error' | 'debug';  // Log severity
  message: string;             // Human-readable description
  context?: Record<string, unknown>;  // Structured metadata
  environment?: string;        // Deployment environment
}
```

**Example log output:**

```json
{
  "timestamp": "2026-01-26T15:30:45.123Z",
  "level": "error",
  "message": "Failed to load project",
  "context": {
    "slug": "portfolio-app",
    "error": "Not found",
    "route": "/projects/portfolio-app"
  },
  "environment": "production"
}
```

### Log Levels

| Level | Usage | Examples | Alerting |
|-------|-------|----------|----------|
| **info** | Normal operations, user actions, state changes | "User loaded project page", "Project registry loaded" | No alerts |
| **warn** | Unexpected but non-critical issues | "Slow page render (3.5s)", "404 Not Found" | Alert if >10/min |
| **error** | Failures requiring attention | "Failed to load project", "API timeout" | Alert immediately |
| **debug** | Development debugging only | "Cache hit", "`Props: {...}`" | Disabled in prod |

### Usage Examples

#### Basic Logging

```typescript
import { log } from '@/lib/observability';

// Info: User action
log({
  level: 'info',
  message: 'User navigated to projects page',
  context: { route: '/projects', referrer: '/' }
});

// Warning: Performance issue
log({
  level: 'warn',
  message: 'Slow page render detected',
  context: { route: '/projects', renderTime: 3500 }
});
```

#### Error Logging with Helper

```typescript
import { logError } from '@/lib/observability';

try {
  const project = await loadProject(slug);
} catch (error) {
  logError('Failed to load project', error, {
    slug,
    operation: 'loadProject'
  });
  throw error;
}
```

#### Integration in Components

```typescript
// Error boundary (src/app/error.tsx)
useEffect(() => {
  logError('Unhandled application error', error, {
    digest: error.digest,
    route: window.location.pathname,
  });
}, [error]);
```

### Context Guidelines

**Do include in context:**
- Route/URL: `route: '/projects/portfolio-app'`
- Operation: `operation: 'loadProjects'`
- Timing: `renderTime: 2500, cacheHit: false`
- Non-sensitive IDs: `slug: 'portfolio-app'`

**Do NOT include in context:**
- Passwords or API keys: ❌ `apiKey: 'sk_live_...'`
- User emails: ❌ `email: 'user@example.com'`
- PII: ❌ `userIP: '192.168.1.1'`
- Secrets: ❌ `token: 'Bearer ...'`

### Viewing Logs

**Vercel Console:**

1. Go to [Vercel Dashboard](https://vercel.com/bryce-seefieldts-projects/portfolio-app)
2. Click "Deployments" → Select deployment
3. Click "Functions" → View function logs
4. Filter by time range, search for keywords

**Local development:**

```bash
# Start dev server
pnpm dev

# Logs appear in terminal as JSON
# Example output:
# {"timestamp":"2026-01-26T15:30:45.123Z","level":"info","message":"Project loaded","context":{"slug":"portfolio-app"},"environment":"development"}
```

**Parsing logs with `jq`:**

```bash
# Filter by level
cat vercel-logs.json | jq 'select(.level == "error")'

# Count errors by route
cat vercel-logs.json | jq -r '.context.route' | sort | uniq -c | sort -rn

# Find slow renders (>3s)
cat vercel-logs.json | jq 'select(.context.renderTime > 3000)'
```

---

## Failure Modes Definition

The application can exist in three states, each with distinct characteristics and recovery procedures:

### State Definitions

| State | Definition | User Impact | HTTP Status | Detection | Recovery |
|-------|------------|-------------|-------------|-----------|----------|
| **Healthy** | All routes render successfully, analytics active, no errors in logs | None | 200 | Health endpoint returns `status: "healthy"` | N/A — system operational |
| **Degraded** | Core routes work (homepage, CV, contact), but some features unavailable (e.g., projects page slow/broken, analytics down) | Minor — users can access most content | 503 | Health endpoint returns `status: "degraded"` OR median response time >3s | Monitor for 5 minutes; if persists, [escalate to on-call](#related-runbooks) |
| **Unhealthy** | Critical routes fail (500 errors), projects registry empty, build failed | Major — service broken, users see errors | 500 | Health endpoint returns `status: "unhealthy"` OR 500 errors on all routes | Execute [incident runbook](#related-runbooks) immediately; consider rollback |

### Transition Diagram

```
        ┌─────────────┐
        │   Healthy   │ ◄──────────────────────┐
        │ (200 OK)    │                        │
        └──────┬──────┘                        │
               │                               │
               │ Data load issue               │ Recovery
               │ Slow performance              │ (fix deployed)
               ▼                               │
        ┌─────────────┐                        │
        │  Degraded   │                        │
        │ (503 Unavailable)                    │
        └──────┬──────┘                        │
               │                               │
               │ Critical failure              │
               │ Build error                   │
               ▼                               │
        ┌─────────────┐                        │
        │  Unhealthy  │ ───────────────────────┘
        │ (500 Error) │      Rollback
        └─────────────┘
```

### Detection Methods

**Automated monitoring (recommended):**

- External uptime monitor polls `/api/health` every 1 minute
- Alert if status changes from `healthy` to `degraded` or `unhealthy`
- Alert if endpoint unresponsive >30 seconds

**Manual detection:**

```bash
# Quick health check
curl -s https://portfolio-app.vercel.app/api/health | jq '.status'

# Expected output: "healthy"
# If output is "degraded" or "unhealthy", investigate immediately
```

**Vercel Logs:**

- Spike in error rate (>5% of requests)
- 500 errors on critical routes
- Missing or empty project registry logs

---

## Monitoring Integration

### External Monitoring Setup

The health endpoint is designed for integration with external uptime monitors:

**Recommended monitors:**

- [UptimeRobot](https://uptimerobot.com/) (free tier: 50 monitors, 5-min intervals)
- [Pingdom](https://www.pingdom.com/) (commercial: advanced analytics)
- [Better Uptime](https://betteruptime.com/) (statuspage integration)

**Configuration:**

1. **Monitor Type:** HTTP(S)
2. **URL:** `https://portfolio-app.vercel.app/api/health`
3. **Check Interval:** 1 minute (or 5 minutes on free tier)
4. **Alert Conditions:**
   - HTTP status ≠ 200
   - Response time > 5 seconds
   - Response body does NOT contain `"status":"healthy"`
5. **Alert Channels:** Email, Slack, PagerDuty

**Example UptimeRobot configuration:**

```yaml
Monitor Name: Portfolio App Health
URL: https://portfolio-app.vercel.app/api/health
Monitor Type: HTTP(s)
Monitoring Interval: 1 minute
Alert Contacts: team@example.com, #alerts-slack
Keyword Alert: "healthy" (expect this keyword in response)
```

### Vercel Integration

**Deployment Checks (future):**

Vercel can call `/api/health` after each deployment to verify health:

1. Go to Vercel Dashboard → Project Settings → Deployment Checks
2. Add health check URL: `/api/health`
3. Expected status: 200
4. Rollback if check fails after 3 retries

**Log Streaming (future):**

Forward Vercel logs to external systems:

- [Datadog Log Integration](https://vercel.com/integrations/datadog)
- [New Relic Logs](https://vercel.com/integrations/newrelic)
- Custom webhook for structured log export

### Alerting Thresholds

**Suggested alert configuration:**

| Condition | Threshold | Severity | Notification | Response Time |
|-----------|-----------|----------|--------------|---------------|
| Health status = degraded | Immediate | Medium | Slack + Email | 15 minutes |
| Health status = unhealthy | Immediate | High | Slack + SMS + PagerDuty | 5 minutes |
| Response time > 3s | 3 consecutive checks | Low | Email only | 1 hour |
| Error rate > 5% | 1 minute | High | Slack + PagerDuty | 10 minutes |
| Endpoint unresponsive | 30 seconds | Critical | All channels | Immediate |

---

## Operational Readiness Checklist

Before going live, verify all observability components are functional:

### Pre-Deployment

- [ ] **Health endpoint deployed** and accessible at `/api/health`
- [ ] **Health endpoint returns 200** in production environment
- [ ] **Structured logging active** — logs appear in Vercel console
- [ ] **Environment variables set** — `VERCEL_ENV`, `VERCEL_GIT_COMMIT_SHA` populated
- [ ] **Build time captured** — `BUILD_TIME` injected during build (future)
- [ ] **No secrets in logs** — context does not contain API keys or tokens

### Monitoring Setup

- [ ] **External monitor configured** — uptime checks call `/api/health`
- [ ] **Alerts configured** — 503/500 status triggers notifications
- [ ] **Alert channels verified** — test alerts reach Slack/email/PagerDuty
- [ ] **Response time baseline** — < 500ms median for health endpoint
- [ ] **Failure threshold tuned** — > 3 consecutive failures triggers alert

### Team Readiness

- [ ] **On-call rotation defined** — engineer assigned to respond to alerts
- [ ] **Runbooks accessible** — degradation and incident response runbooks available
- [ ] **Team trained on failure modes** — healthy/degraded/unhealthy states understood
- [ ] **Escalation procedures documented** — when to page VP Eng, when to rollback
- [ ] **Postmortem template ready** — incident documentation process established

### Testing & Validation

- [ ] **Health check tested locally** — returns 200 with expected fields
- [ ] **Degraded state tested** — verify 503 when projects registry empty
- [ ] **Error state tested** — verify 500 when exception occurs
- [ ] **Structured logs verified** — JSON output is parseable, fields present
- [ ] **Alert test executed** — trigger alert and verify notification received

---

## Related Runbooks

Refer to these operational runbooks for detailed procedures:

- **[Service Degradation Runbook](../../50-operations/runbooks/rbk-portfolio-service-degradation.md)** — Diagnose and resolve degraded state (MTTR: 10 min)
- **[Deployment Failure Runbook](../../50-operations/runbooks/rbk-portfolio-deployment-failure.md)** — Rollback failed deployments (MTTR: 5 min)
- **[General Incident Response](../../50-operations/runbooks/rbk-portfolio-incident-response.md)** — Framework for all incidents (severity levels, triage, postmortem)
- **[Performance Optimization](../../50-operations/runbooks/rbk-portfolio-performance-optimization.md)** — Proactive performance tuning
- **[Performance Troubleshooting](../../50-operations/runbooks/rbk-portfolio-performance-troubleshooting.md)** — Diagnose slow pages, high bundle sizes

---

## Future Enhancements

### Metrics Export (Phase 5)

Add quantitative metrics for performance tracking:

- **Build metrics:** Build time, bundle size, routes generated
- **Runtime metrics:** Request count, error rate, response time percentiles (p50/p95/p99)
- **Resource metrics:** Memory usage, CPU usage (Vercel Function Analytics)

**Proposed implementation:** Prometheus metrics export at `/api/metrics` or StatsD push to Datadog

### Distributed Tracing (Phase 5)

Add request tracing for debugging cross-service calls:

- **Trace ID:** Unique ID for each request, propagated across functions
- **Spans:** Measure time spent in each function/component
- **Context propagation:** Link logs to specific traces

**Proposed tools:** OpenTelemetry, Vercel APM, Datadog APM

### Automated Incident Creation (Phase 5)

Auto-create GitHub issues when incidents occur:

- **Trigger:** Health check fails >3 times OR error rate >10%
- **Action:** Create GitHub issue with severity label, link to logs, assign to on-call
- **Integration:** GitHub Actions workflow + Vercel webhook

---

## Additional Resources

- **Implementation:** [`src/app/api/health/route.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/app/api/health/route.ts), [`src/lib/observability.ts`](https://github.com/bryce-seefieldt/portfolio-app/blob/main/src/lib/observability.ts)
- **Vercel Logs:** [Dashboard](https://vercel.com/bryce-seefieldts-projects/portfolio-app/logs)
- **Uptime Monitors:** [UptimeRobot](https://uptimerobot.com/), [Better Uptime](https://betteruptime.com/)
- **Log Analysis:** [jq Manual](https://jqlang.github.io/jq/manual/), [Vercel Log Drains](https://vercel.com/docs/observability/log-drains)
