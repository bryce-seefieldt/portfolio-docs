---
title: 'Observability & Health Checks'
description: 'Health check endpoints, structured logging, and failure mode definitions for production applications.'
sidebar_position: 3
tags: [devops, observability, monitoring, health-checks, logging, runbooks]
---

# Observability & Health Checks

## Overview

**Observability** is the ability to understand the internal state of an application by examining its outputs (logs, metrics, traces). Unlike traditional monitoring which tells you _when_ something is broken, observability enables you to understand _why_ it's broken and _how_ to fix it.

### Why Observability Matters

- **Faster Incident Response:** Detect issues before users report them (MTTR target: < 10 minutes)
- **Proactive Problem Detection:** Identify degradation trends before they become outages
- **Evidence-Based Debugging:** Structured logs provide context for reproducing and fixing issues
- **Operational Confidence:** Clear health status enables automated monitoring and alerting

### Observability Pillars

Production applications should implement three observability pillars:

1. **Logs** — Structured JSON logs for debugging and audit trails
2. **Health Checks** — Application status endpoint for monitoring
3. **Metrics** — Quantitative performance measurements (future enhancement)

---

## Health Check Endpoint

### Endpoint Specification

**URL:** `GET /api/health`  
**Cache Policy:** No caching (`revalidate: 0`)  
**Response Time Target:** < 500ms

### Response Format

The health endpoint returns JSON with the following fields:

| Field          | Type                                     | Description                      | Example                      |
| -------------- | ---------------------------------------- | -------------------------------- | ---------------------------- |
| `status`       | `"healthy" \| "degraded" \| "unhealthy"` | Application health state         | `"healthy"`                  |
| `timestamp`    | `string` (ISO 8601)                      | Response timestamp               | `"2026-01-26T15:30:45.123Z"` |
| `environment`  | `string`                                 | Deployment environment           | `"production"`               |
| `commit`       | `string`                                 | Git commit SHA (first 7 chars)   | `"a2058c7"`                  |
| `buildTime`    | `string` (ISO 8601)                      | Build timestamp                  | `"2026-01-26T15:20:00.000Z"` |
| `projectCount` | `number`                                 | Number of projects/items loaded  | `8`                          |
| `message`      | `string` (optional)                      | Error or degradation description | `"No projects loaded"`       |
| `error`        | `string` (optional)                      | Error message (unhealthy only)   | `"Cannot load registry"`     |

### Status Codes

| HTTP Status                   | State     | Meaning                                                 | Action                                      |
| ----------------------------- | --------- | ------------------------------------------------------- | ------------------------------------------- |
| **200 OK**                    | Healthy   | All systems operational, all checks passed              | No action needed                            |
| **503 Service Unavailable**   | Degraded  | Core functionality works, but some features unavailable | Monitor for 5 minutes; escalate if persists |
| **500 Internal Server Error** | Unhealthy | Critical failure; service broken                        | Execute incident runbook immediately        |

### Response Examples

#### Healthy (200 OK)

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

```json
{
  "status": "degraded",
  "message": "Registry data incomplete",
  "timestamp": "2026-01-26T15:30:45.123Z",
  "environment": "production",
  "commit": "a2058c7"
}
```

#### Unhealthy (500 Internal Server Error)

```json
{
  "status": "unhealthy",
  "error": "Cannot read properties of undefined (reading 'length')",
  "timestamp": "2026-01-26T15:30:45.123Z",
  "environment": "production"
}
```

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
# Test deployed instance
curl https://production-domain.com/api/health | jq .

# Automated monitoring
curl -sf https://production-domain.com/api/health | jq -e '.status == "healthy"'
```

---

## Structured Logging

### Log Format

All logs follow the `LogEntry` interface:

```typescript
interface LogEntry {
  timestamp: string; // ISO 8601 timestamp
  level: 'info' | 'warn' | 'error' | 'debug'; // Severity level
  message: string; // Human-readable description
  context?: Record<string, unknown>; // Structured metadata
  environment?: string; // Deployment environment
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

| Level     | Usage                              | Examples                              | Alerting          |
| --------- | ---------------------------------- | ------------------------------------- | ----------------- |
| **info**  | Normal operations, state changes   | "User loaded page", "Registry loaded" | No alerts         |
| **warn**  | Unexpected but non-critical issues | "Slow render (3.5s)", "404 Not Found" | Alert if >10/min  |
| **error** | Failures requiring attention       | "Failed to load", "API timeout"       | Alert immediately |
| **debug** | Development debugging only         | "Cache hit", "`Props: {...}`"         | Disabled in prod  |

### Context Guidelines

**Do include in context:**

- Route/URL: `route: '/projects/portfolio-app'`
- Operation: `operation: 'loadProjects'`
- Timing: `renderTime: 2500, cacheHit: false`
- Non-sensitive IDs: `slug: 'portfolio-app'`

**Do NOT include in context:**

- Passwords or API keys
- User emails or PII
- Sensitive internal URLs
- Secrets or tokens

### Viewing Logs

**Local development:**

```bash
pnpm dev
# Logs appear in terminal as JSON
```

**Production (Vercel):**

1. Go to Vercel Dashboard
2. Click "Deployments" → Select deployment
3. Click "Functions" → View function logs
4. Filter by time range and keywords

**Parsing with jq:**

```bash
# Filter by error level
cat logs.json | jq 'select(.level == "error")'

# Count errors by route
cat logs.json | jq -r '.context.route' | sort | uniq -c

# Find slow operations (>3s)
cat logs.json | jq 'select(.context.renderTime > 3000)'
```

---

## Failure Modes Definition

### State Definitions

| State         | Definition                                         | User Impact | HTTP Status | Detection                                                       |
| ------------- | -------------------------------------------------- | ----------- | ----------- | --------------------------------------------------------------- |
| **Healthy**   | All routes render successfully, no errors          | None        | 200         | Health endpoint returns `healthy`                               |
| **Degraded**  | Core routes work, but some features unavailable    | Minor       | 503         | Health endpoint returns `degraded` OR median response time >3s  |
| **Unhealthy** | Critical routes fail, registry empty, build failed | Major       | 500         | Health endpoint returns `unhealthy` OR 500 errors on all routes |

### State Transition Diagram

```
Healthy ──→ Degraded ──→ Unhealthy
             ↓ (fix)      ↓ (rollback)
            Healthy ←────┘
```

**Healthy → Degraded:** Data load issue, slow performance, partial failure

**Degraded → Unhealthy:** Critical failure, build error, configuration issue

**Recovery:** Fix deployed or rollback to previous version

### Detection Methods

**Automated monitoring:**

```bash
# External uptime monitor polls every 1 minute
curl -s https://production-domain.com/api/health | jq '.status'
# Expected: "healthy"
```

**Alert if:**

- Status changes from `healthy` to `degraded` or `unhealthy`
- Endpoint unresponsive >30 seconds
- Response time > 5 seconds

---

## Monitoring Integration

### External Monitoring Setup

**Recommended monitors:**

- [UptimeRobot](https://uptimerobot.com/) (free: 50 monitors)
- [Better Uptime](https://betteruptime.com/) (statuspage integration)
- [Pingdom](https://www.pingdom.com/) (advanced analytics)

**Configuration:**

| Setting         | Value                                                              |
| --------------- | ------------------------------------------------------------------ |
| Monitor Type    | HTTP(S)                                                            |
| URL             | `https://production-domain.com/api/health`                         |
| Check Interval  | 1 minute (or 5 minutes on free tier)                               |
| Alert Condition | Status ≠ 200 OR response time > 5s OR missing `"status":"healthy"` |
| Alert Channels  | Email, Slack, PagerDuty                                            |

### Alert Thresholds

| Condition             | Threshold  | Severity | Notification            | Response Time |
| --------------------- | ---------- | -------- | ----------------------- | ------------- |
| Health = degraded     | Immediate  | Medium   | Slack + Email           | 15 minutes    |
| Health = unhealthy    | Immediate  | High     | Slack + SMS + PagerDuty | 5 minutes     |
| Response time > 3s    | 3 checks   | Low      | Email                   | 1 hour        |
| Error rate > 5%       | 1 minute   | High     | Slack + PagerDuty       | 10 minutes    |
| Endpoint unresponsive | 30 seconds | Critical | All channels            | Immediate     |

---

## Operational Readiness Checklist

### Pre-Deployment

- [ ] Health endpoint deployed and accessible at `/api/health`
- [ ] Health endpoint returns 200 in production
- [ ] Structured logging active in logs
- [ ] Environment variables correctly set
- [ ] No secrets in logs or context
- [ ] Response time < 500ms median

### Monitoring Setup

- [ ] External monitor configured
- [ ] Alerts configured for 503/500 status
- [ ] Alert channels verified
- [ ] Baseline response time documented
- [ ] Failure threshold tuned

### Team Readiness

- [ ] On-call rotation defined
- [ ] Runbooks accessible
- [ ] Team trained on failure modes
- [ ] Escalation procedures documented
- [ ] Postmortem template ready

### Testing & Validation

- [ ] Health check tested locally
- [ ] Degraded state tested (503 response)
- [ ] Error state tested (500 response)
- [ ] Structured logs verified as JSON
- [ ] Alert test executed

---

## Future Enhancements

### Metrics Export (Planned)

Add quantitative metrics for performance tracking:

- **Build metrics:** Build time, bundle size, routes generated
- **Runtime metrics:** Request count, error rate, response time percentiles (p50/p95/p99)
- **Resource metrics:** Memory usage, CPU usage

**Implementation approach:** Prometheus metrics at `/api/metrics` or StatsD export

### Distributed Tracing (Planned)

Add request tracing for debugging cross-service calls:

- **Trace ID:** Unique ID for each request
- **Spans:** Measure time in each function/component
- **Context propagation:** Link logs to specific traces

**Tools:** OpenTelemetry, Vercel APM, Datadog APM

### Automated Incident Creation (Planned)

Auto-create GitHub issues when incidents occur:

- **Trigger:** Health check fails >3 times OR error rate >10%
- **Action:** Create issue with severity label, link logs, assign to on-call
- **Integration:** GitHub Actions workflow + webhook

---

## References

- [Vercel Logs Documentation](https://vercel.com/docs/observability/log-drains)
- [UptimeRobot](https://uptimerobot.com/)
- [jq Manual](https://jqlang.github.io/jq/manual/)
- [Structured Logging Best Practices](https://www.kartar.net/2015/12/structured-logging/)
