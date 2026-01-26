---
title: 'Stage 4.3 — Observability & Operational Readiness (App)'
description: 'Add health checks, structured logging, and failure mode documentation to portfolio app'
tags:
  [portfolio, roadmap, planning, phase-4, stage-4.3, app, observability, operations]
---

# Stage 4.3: Observability & Operational Readiness — App Implementation

**Type:** Feature / Enhancement / Implementation  
**Phase:** Phase 4 — Enterprise-Grade Platform Maturity  
**Stage:** 4.3  
**Linked Issue:** stage-4.3-docs-issue  
**Duration Estimate:** 4–6 hours  
**Assignee:** [TBD]

---

## Overview

Enable operational visibility into portfolio app health, performance, and failures through health check endpoints, structured logging, and failure mode definitions. This stage provides the foundation for proactive monitoring and incident response, allowing the team to detect, diagnose, and resolve issues quickly before they impact users.

## Objectives

- Implement a health check API endpoint that reports app status, environment, and critical resource state
- Add structured logging helpers that output machine-readable logs for monitoring systems
- Define failure modes (healthy/degraded/unhealthy) and their indicators
- Create runbooks for common operational scenarios (degradation, deployment failure, incident response)
- Enable observability integration with Vercel and future external monitoring systems

---

## Scope

### Files to Create

1. **`src/app/api/health/route.ts`** — Health check endpoint that verifies critical app resources and returns structured status
   - Endpoint: `GET /api/health`
   - Returns: JSON with status, environment, commit, build time, project count, timestamp
   - Status codes: 200 (healthy), 503 (degraded), 500 (unhealthy)
   - No caching (revalidate=0)

2. **`src/lib/observability.ts`** — Structured logging helpers for application logging
   - Exports `LogEntry` interface with level, message, context, timestamp, environment
   - Exports `log()` function that outputs JSON-formatted logs to console
   - Supports: info, warn, error, debug log levels
   - Includes context object for structured data (e.g., user ID, operation, timing)

### Files to Update

1. **`next.config.ts`** — Configure error handling and logging
   - Add error page configuration if needed
   - Document any monitoring hooks or logging integrations

2. **`package.json`** — Add any observability dependencies if needed
   - May add: `pino`, `bunyan`, or similar structured logging (evaluate based on bundle impact)
   - Note: Prefer native console.log with JSON.stringify for lightweight approach

3. **`src/app/layout.tsx`** — May add error boundary or observability provider
   - Import observability helpers where needed
   - Document any new instrumentation

### Dependencies to Add

- None required (uses native Node.js console for JSON logging)
- Optional: Lightweight structured logging package if evaluation determines benefit

### Dependencies to Remove

- None

---

## Design & Architecture

### System Overview

The observability system consists of three components:

```
┌─────────────────────────────────────────────────────────────┐
│                    Portfolio App                             │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ Application Logic                                     │   │
│  │ (pages, components, API routes)                       │   │
│  └──────────────────────────────────────────────────────┘   │
│           │                              │                    │
│           ▼                              ▼                    │
│  ┌──────────────────┐        ┌──────────────────────────┐   │
│  │ Health Check     │        │ Structured Logging       │   │
│  │ /api/health      │        │ observability.ts         │   │
│  │ - Status 200/503 │        │ - JSON log output        │   │
│  │ - Metrics        │        │ - Log levels             │   │
│  │ - Environment    │        │ - Context metadata       │   │
│  └──────────────────┘        └──────────────────────────┘   │
│           │                              │                    │
│           └──────────────┬───────────────┘                    │
│                          ▼                                     │
│           ┌─────────────────────────────┐                    │
│           │ Vercel Logs / External      │                    │
│           │ Monitoring System           │                    │
│           └─────────────────────────────┘                    │
└─────────────────────────────────────────────────────────────┘
```

### Health Check Endpoint Design

```typescript
// src/app/api/health/route.ts
GET /api/health

Response (healthy):
{
  "status": "healthy",
  "timestamp": "2026-01-26T15:30:45.123Z",
  "environment": "production",
  "commit": "a2058c7",
  "buildTime": "2026-01-26T15:20:00.000Z",
  "projectCount": 8
}

Response (degraded):
{
  "status": "degraded",
  "message": "No projects loaded",
  "timestamp": "2026-01-26T15:30:45.123Z"
}
Status: 503

Response (unhealthy):
{
  "status": "unhealthy",
  "error": "Cannot load projects registry",
  "timestamp": "2026-01-26T15:30:45.123Z"
}
Status: 500
```

### Structured Logging Design

```typescript
// src/lib/observability.ts
export interface LogEntry {
  timestamp: string;           // ISO 8601 timestamp
  level: 'info' | 'warn' | 'error' | 'debug';  // Log level
  message: string;             // Human-readable message
  context?: Record<string, unknown>;  // Structured data
  environment?: string;        // Deployment environment
}

// Usage in application:
import { log } from '@/lib/observability';

log({
  level: 'info',
  message: 'Project page rendered',
  context: { slug: 'portfolio-app', renderTime: 145 }
});

// Output (JSON):
{"timestamp":"2026-01-26T15:30:45.123Z","level":"info","message":"Project page rendered","context":{"slug":"portfolio-app","renderTime":145},"environment":"production"}
```

### Failure Modes Definition

| State         | Definition                                                                 | User Impact | HTTP Status | Recovery                                    |
| ------------- | -------------------------------------------------------------------------- | ----------- | ----------- | ------------------------------------------- |
| **Healthy**   | All routes render, health check passes, analytics working                  | None        | 200         | N/A                                         |
| **Degraded**  | Core routes work; non-critical features unavailable (e.g., analytics slow) | Minor       | 503         | Monitor; escalate if persists >5 min        |
| **Unhealthy** | Critical routes fail (500s, timeouts); no projects loaded                  | Major       | 500         | Execute incident runbook; consider rollback |

### Key Design Decisions

1. **Health Check Approach:** Simple HTTP endpoint (not gRPC, not custom protocol)
   - Rationale: Easy to test with curl, integrates with standard monitoring tools, minimal dependencies
   - Alternative considered: Comprehensive metrics endpoint (too heavy for current needs)

2. **Structured Logging:** JSON output to console (not external package)
   - Rationale: Native Node.js, zero external dependencies, parseable by Vercel Logs and external systems
   - Alternative considered: Pino/Bunyan (adds 50KB+; evaluate ROI if monitoring needs grow)

3. **Failure Mode Detection:** Application-level checks (not infrastructure)
   - Rationale: Catches business logic failures (e.g., missing projects) not just HTTP availability
   - Infrastructure checks (CDN health) handled separately by Vercel

---

## Implementation Tasks

### Phase 1: Health Check Endpoint (1–2 hours)

[Description: Implement the `/api/health` endpoint with status detection and environment metadata]

#### Tasks

- [ ] Create `src/app/api/health/route.ts`
  - Details: Implement GET handler that returns JSON status
  - Import PROJECTS from data registry
  - Check if projectCount > 0 (indicates degraded if 0)
  - Include environment, commit, buildTime from env vars
  - Handle errors and return 500 unhealthy status
  - Set revalidate=0 (no caching)

- [ ] Extract build metadata from environment
  - Details: Capture `VERCEL_GIT_COMMIT_SHA`, `VERCEL_ENV`, `BUILD_TIME`
  - Document where these come from (Vercel sets commit/env; we set BUILD_TIME in next.config.ts)
  - Provide fallback values if not set

- [ ] Test health endpoint locally
  - Command: `curl http://localhost:3000/api/health`
  - Expected: Returns 200 with healthy status, project count, environment
  - Test error case: Temporarily remove projects, verify 503 response

- [ ] Verify TypeScript and linting
  - No `any` types; proper error handling
  - Follow ESLint rules

#### Success Criteria for Phase 1

- [ ] `src/app/api/health/route.ts` exists and exports GET handler
- [ ] Health check returns 200 with all required fields (status, timestamp, environment, commit, projectCount)
- [ ] Degraded state (no projects) returns 503
- [ ] Error handling catches exceptions and returns 500
- [ ] `pnpm typecheck` passes
- [ ] `pnpm lint` passes
- [ ] Local testing confirms endpoint accessible and responsive

---

### Phase 2: Structured Logging (1–2 hours)

[Description: Implement structured logging helpers and integrate into error handling paths]

#### Tasks

- [ ] Create `src/lib/observability.ts`
  - Details: Define LogEntry interface with all required fields
  - Implement log() function that outputs JSON
  - Support log levels: info, warn, error, debug
  - Include environment from process.env.VERCEL_ENV
  - Handle context as optional Record `<string, unknown>`

- [ ] Integrate logging into key error paths
  - Details: Add log() calls in API routes and error boundaries
  - Example: Log when health check fails, when projects load, when API errors occur
  - Ensure all error responses are logged with context

- [ ] Test structured logging output
  - Command: Run app and trigger error (e.g., access non-existent route)
  - Expected: Console output is valid JSON parseable by monitoring systems
  - Verify fields are present: timestamp, level, message, environment, context

- [ ] Verify TypeScript and formatting
  - No `any` types
  - Proper JSDoc comments on exported functions

#### Success Criteria for Phase 2

- [ ] `src/lib/observability.ts` exists and exports LogEntry and log()
- [ ] Log output is valid JSON with all required fields
- [ ] Environment variable automatically included
- [ ] Context object properly serialized
- [ ] Integrated into error handling (at least 2–3 key paths)
- [ ] `pnpm typecheck` passes
- [ ] `pnpm format:check` passes

---

### Phase 3: Verification & Testing (1–2 hours)

[Description: Verify health checks, test failure scenarios, document findings]

#### Tasks

- [ ] Run health endpoint in production mode
  - Command: `pnpm build && pnpm start`
  - Test: `curl http://localhost:3000/api/health`
  - Expected: All fields present, commit/environment populated correctly

- [ ] Test failure scenarios
  - Scenario 1: Simulate missing projects (remove from registry, deploy)
  - Expected: Health check returns 503 with degraded message
  - Scenario 2: Simulate project data access error
  - Expected: Health check returns 500 with error message, error logged

- [ ] Verify logging in build output
  - Details: Ensure structured logs appear in console during build and runtime
  - Check that JSON is valid and parseable

- [ ] Document observability in next.config.ts comments
  - Add comments explaining monitoring setup
  - Note Vercel environment variable availability
  - Note future integration points (external monitoring)

- [ ] Run full verification
  - Command: `pnpm verify`
  - Expected: All checks pass, no new warnings

#### Success Criteria for Phase 3

- [ ] Health check works in production build
- [ ] All failure scenarios tested and logged appropriately
- [ ] Structured logs verified as valid JSON
- [ ] next.config.ts documents observability setup
- [ ] `pnpm verify` passes with no new issues
- [ ] Ready for documentation and runbook creation

---

## Testing Strategy

### Unit Tests

- [ ] Health check endpoint returns correct status codes
  - Test file: `src/app/api/health/__tests__/route.test.ts` (future)
  - Coverage: Happy path (healthy), degraded (no projects), error cases
  - Mocks: PROJECTS registry, environment variables

- [ ] Structured logging formats correctly
  - Test file: `src/lib/__tests__/observability.test.ts` (future)
  - Coverage: All log levels, context serialization, timestamp generation
  - Verify JSON.parse() works on output

### Integration Tests

- [ ] Health check with live project registry
  - Test: Load actual projects, verify count matches
  - Verify environment variables from test environment

### E2E / Manual Testing

- [ ] Health endpoint accessible via curl
  - Steps: `curl http://localhost:3000/api/health`
  - Expected: Valid JSON response with 200 status

- [ ] Degradation detection works
  - Steps: Remove all projects, rebuild, test endpoint
  - Expected: 503 status, degraded message

- [ ] Logging appears in console
  - Steps: Trigger errors in app, observe console output
  - Expected: Each error produces parseable JSON log entry

### Test Commands

```bash
# Build verification
pnpm build

# Local verification (full suite including new health checks)
pnpm verify

# Type checking
pnpm typecheck

# Linting
pnpm lint

# Test health endpoint
curl http://localhost:3000/api/health

# Start server and monitor logs
pnpm start
```

---

## Acceptance Criteria

This stage is complete when:

- [ ] `src/app/api/health/route.ts` endpoint fully functional
- [ ] Returns 200 (healthy), 503 (degraded), or 500 (unhealthy) based on app state
- [ ] Health check includes environment, commit, buildTime, projectCount, timestamp
- [ ] `src/lib/observability.ts` provides structured logging
- [ ] All log output is valid JSON with required fields
- [ ] Structured logging integrated into error paths
- [ ] Failure modes (healthy/degraded/unhealthy) defined and detected
- [ ] `pnpm verify` passes (lint, format, typecheck, build all succeed)
- [ ] No TypeScript errors: `pnpm typecheck`
- [ ] No ESLint violations: `pnpm lint`
- [ ] All new code is type-safe (no `any` types)
- [ ] Production build succeeds: `pnpm build`
- [ ] Health endpoint tested and working in production build
- [ ] All error paths include structured logging

---

## Code Quality Standards

All code must meet:

- **TypeScript:** Strict mode enabled; no `any` types unless documented
- **Linting:** ESLint with Next.js preset; max-warnings=0
- **Formatting:** Prettier; single quotes, semicolons, 2-space indent
- **Documentation:** All exported functions have JSDoc comments
- **Error Handling:** All async operations have try-catch; errors logged with context
- **Performance:** Health check endpoint responds in `<100ms`; no blocking I/O

---

## Dependencies & Blocking

### Depends On

- [ ] Stage 4.2 (Performance optimization) — must be merged first
- [ ] Vercel deployment infrastructure — environment variables available

### Blocks

- [ ] Stage 4.3 Docs: Runbooks and operational procedures depend on this implementation

### Related Work

- Docs issue: stage-4.3-docs-issue (runbooks for observability)
- Monitoring integration: TBD (external monitoring system, Phase 5)

---

## Performance & Optimization Considerations

- **Health Check Response Time:** Must respond in `<100ms` (no I/O, simple data access)
- **Log Output:** JSON serialization is O(n) where n = context size; keep context objects small
- **No Caching:** Health endpoint must not be cached (revalidate=0) to reflect live status
- **Memory:** Structured logging via console.log; no buffering or queue needed

---

## Security Considerations

- [ ] Health endpoint does not expose sensitive secrets
  - Include: environment (prod/staging), commit SHA (first 7 chars), project count
  - Exclude: API keys, database credentials, internal IPs
- [ ] Structured logs do not leak sensitive data in context
- [ ] No PII in error messages (don't expose user emails, IDs in logs)
- [ ] Environment variables properly escaped

---

## Effort Breakdown

| Phase | Task                           | Hours  | Notes                                       |
| ----- | ------------------------------ | ------ | ------------------------------------------- |
| 1     | Create health check endpoint   | 1–2h   | Simple GET route, environment checks        |
| 2     | Structured logging integration | 1–2h   | observability.ts + integrate into errors    |
| 3     | Verification & testing         | 1–2h   | Test scenarios, verify output, run pnpm ver |
| **Total** | **Stage 4.3 App Complete**     | **4–6h** | Ready for docs & runbooks                   |

---

## Success Verification Checklist

Before marking this stage complete:

- [ ] All Phase 1 tasks complete (health check endpoint)
- [ ] All Phase 2 tasks complete (structured logging)
- [ ] All Phase 3 tasks complete (verification)
- [ ] All acceptance criteria met
- [ ] `pnpm verify` passes
- [ ] Code reviewed for quality
- [ ] PR created and CI checks passing
- [ ] Ready for docs issue (Stage 4.3 Docs) to proceed

---

## Troubleshooting & Known Issues

### Common Issues & Fixes

**Issue: Health endpoint returns 500 even though projects are loaded**

- **Cause:** Unhandled error in health check logic or accessing PROJECTS registry
- **Fix:** Add try-catch wrapper; log error details; verify PROJECTS imports correctly
- **Prevention:** Write unit tests for health check with mocked registry

**Issue: Structured logs not appearing in Vercel console**

- **Cause:** Logs may be buffered or not flushed; JSON parsing failing
- **Fix:** Use `console.log()` directly; verify JSON is valid before output
- **Prevention:** Test JSON output with `jq` or `JSON.parse()`

**Issue: Environment variables undefined in production**

- **Cause:** Vercel not setting `BUILD_TIME` or `VERCEL_GIT_COMMIT_SHA` env vars
- **Fix:** Set BUILD_TIME in next.config.ts during build; provide fallback values
- **Prevention:** Document expected env vars; test locally with simulated values

---

## Documentation Requirements

By the time this stage is complete:

- [ ] Health endpoint documented in comments (URL, response format, status codes)
- [ ] Observability.ts exported functions have JSDoc comments
- [ ] next.config.ts includes comments about observability setup
- [ ] Failure modes documented in code comments or separate reference
- [ ] Error handling examples provided in health check and logging
- [ ] Environment variables documented (BUILD_TIME, VERCEL_ENV, VERCEL_GIT_COMMIT_SHA)

---

## Notes & Assumptions

- Assumes Vercel provides `VERCEL_ENV` and `VERCEL_GIT_COMMIT_SHA` env vars
- Assumes `BUILD_TIME` can be injected during build in next.config.ts
- Structured logging uses native console.log with JSON.stringify (no external package)
- Health check does not require database or external API calls (quick status only)
- Future monitoring systems can parse JSON logs from Vercel console

---

## Related Issues

- Parent issue: Phase 4 Implementation Guide
- Docs issue: stage-4.3-docs-issue (runbooks and operational documentation)
- Blocks: Stage 4.3 docs completion (runbooks need this implementation)

---

## Review Checklist (for Reviewer)

- [ ] Code achieves stated objectives (health check + structured logging)
- [ ] All required fields in health endpoint response
- [ ] Logging properly structured as JSON
- [ ] Error handling is comprehensive
- [ ] No secrets leaked in health response or logs
- [ ] Code follows style guidelines
- [ ] TypeScript types are strict (no `any`)
- [ ] Performance acceptable (health check `<100ms`)
- [ ] No new vulnerabilities introduced
- [ ] PR description is clear
- [ ] Commits follow conventions

---

## Completion Verification

- [ ] All phases complete
- [ ] All acceptance criteria met
- [ ] All tests passing: `pnpm test` (when tests added)
- [ ] All quality gates pass: `pnpm verify`
- [ ] Code reviewed and approved
- [ ] PR merged to `main`
- [ ] Stage 4.3 Docs issue can now proceed (implementation complete)

**Date Completed:** [YYYY-MM-DD]  
**Completed By:** [Name/GitHub handle]

---

## Post-Implementation Notes

[Any learnings, gotchas, or notes for future stages]

- Structured logging may benefit from external package (Pino, Bunyan) once monitoring needs grow
- Consider adding custom error boundary component for frontend error logging
- Future stage: Integrate with external monitoring (Datadog, New Relic, etc.)
- Future stage: Add metrics export (Prometheus, StatsD) for performance metrics

---

**Milestone:** Phase 4 — Enterprise-Grade Platform Maturity  
**Labels:** `enhancement`, `phase-4`, `stage-4.3`, `observability`, `operations`  
**Priority:** High
