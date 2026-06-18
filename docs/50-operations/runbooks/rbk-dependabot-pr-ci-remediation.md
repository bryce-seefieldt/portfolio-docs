---
title: 'Runbook: Dependabot PR CI Remediation'
description: 'Deterministic workflow to diagnose failing Dependabot pull requests, reproduce failures locally, apply fixes, and push updates back to unblock required checks.'
sidebar_position: 7
tags: [operations, runbook, dependabot, cicd, troubleshooting, supply-chain]
---

## Purpose

Provide a deterministic responder workflow for failing Dependabot pull requests across:

- `portfolio-docs` (Docusaurus docs app)
- `portfolio-app` (Next.js app)

This runbook is used when automation is insufficient and a maintainer must reproduce, fix, and push a patch to the Dependabot PR branch.

## Scope

### Use when

- a Dependabot PR has one or more failed required checks
- CI logs show non-transient failures (typecheck, lint, audit gate, test, build, links)
- re-running jobs does not resolve the failure

### Do not use when

- a CI failure is unrelated to Dependabot PRs (use service-specific CI triage runbooks)
- the PR is blocked by policy decisions (for example, major-version upgrade deferral)

## Prereqs / Inputs

- GitHub access to view checks and push commits
- local checkout with both repositories available
- tooling:
  - `gh`
  - `git`
  - `pnpm`
  - Node 20 runtime (to match CI)

## Procedure / Content

### 1) Identify the failing check and failing step

From local shell:

```bash
gh pr checks <PR_NUMBER> --repo bryce-seefieldt/<REPO>
gh pr view <PR_NUMBER> --repo bryce-seefieldt/<REPO> --json title,headRefName,author,statusCheckRollup
```

If needed, inspect failed step logs:

```bash
gh run list --repo bryce-seefieldt/<REPO> --branch <HEAD_BRANCH> --limit 5
gh run view <RUN_ID> --repo bryce-seefieldt/<REPO> --log-failed
```

Capture:

- failing check name (`ci / quality`, `ci / test`, `ci / link-validation`, `ci / build`, `secrets-scan`)
- failing step (`typecheck`, `format:check`, `pnpm build`, etc.)
- first actionable error line

### 2) Checkout the Dependabot PR branch locally

Preferred:

```bash
gh pr checkout <PR_NUMBER> --repo bryce-seefieldt/<REPO>
```

Fallback (if checkout helper fails):

```bash
git fetch origin pull/<PR_NUMBER>/head:dependabot-pr-<PR_NUMBER>
git checkout dependabot-pr-<PR_NUMBER>
```

### 3) Reproduce failure locally

#### For `portfolio-docs`

```bash
pnpm install --frozen-lockfile
pnpm verify
```

Targeted diagnosis:

```bash
pnpm lint
pnpm format:check
pnpm typecheck
pnpm audit --audit-level=high
pnpm build
pnpm policy:check
```

#### For `portfolio-app`

```bash
pnpm install --frozen-lockfile
pnpm verify
```

Targeted diagnosis:

```bash
pnpm lint
pnpm format:check
pnpm typecheck
pnpm audit --audit-level=high
pnpm test:unit
pnpm test:e2e
pnpm registry:validate
pnpm build
```

### 4) Apply minimal fix for the failing class

Decision matrix:

| Failing check          | Typical root cause                                  | First local command                | Fix strategy                                         |
| ---------------------- | --------------------------------------------------- | ---------------------------------- | ---------------------------------------------------- |
| `ci / quality`         | lint, format, typecheck                             | `pnpm verify` or targeted commands | fix code/config; avoid policy weakening              |
| `ci / quality` (audit) | high/critical vulnerabilities from baseline or PR   | `pnpm audit --audit-level=high`    | patch dependencies/overrides + lockfile; keep gate   |
| `ci / test`            | unit or E2E regression (`portfolio-app`)            | `pnpm test:unit` / `pnpm test:e2e` | update code or tests to match intended behavior      |
| `ci / link-validation` | stale/missing docs evidence links (`portfolio-app`) | `pnpm registry:validate`           | correct registry links and targets                   |
| `ci / build`           | broken build, invalid config, routing/link errors   | `pnpm build`                       | fix root cause; do not bypass build gate             |
| `secrets-scan`         | verified secret in PR diff                          | review scan output                 | rotate/revoke secret and remove from history/content |

### 5.1) Known pattern: baseline audit drift blocks Dependabot PRs

Symptoms:

- Dependabot PR fails at `ci / quality` audit gate
- Same strict audit command fails on `main`

Responder flow:

1. Validate whether failure is baseline or PR-specific:

```bash
# On current main
pnpm audit --audit-level=high
```

2. If baseline fails, remediate baseline first:

- upgrade direct vulnerable dependencies to patched versions
- add targeted `pnpm.overrides` for vulnerable transitive chains
- regenerate lockfile (`pnpm install`)
- re-run strict audit and full verification

3. Push remediation and rebase/retry Dependabot PR.

Guardrail:

- do not bypass high/critical audit with `|| true` in required CI gates

### 5) Known pattern: TypeScript 6 deprecation failures (`TS5101`)

Symptom example:

- `error TS5101: Option 'baseUrl' is deprecated and will stop functioning in TypeScript 7.0`

Responder approach:

1. confirm error appears in CI logs and local `pnpm typecheck`
2. remove deprecated option when no longer needed, or migrate to supported alternatives
3. use temporary suppression only if migration cannot be completed safely in the PR scope
4. rerun full verification locally before push

### 6) Commit and push patch to Dependabot PR branch

After local verification is green:

```bash
git add -A
git commit -m "fix(ci): resolve Dependabot PR failure"
git push
```

If direct push is rejected:

1. create a maintainer branch from the checked-out state
2. push that branch and open a replacement PR
3. link back to the original Dependabot PR with rationale

### 7) Re-run checks and verify merge readiness

- re-run all jobs for transient flakes (GitHub Actions UI)
- verify required checks are green
- ensure no new warnings introduce policy drift

## Validation / Expected outcomes

- local verification reproduces and then resolves the failure
- Dependabot PR checks are green after patch push
- merge gate is unblocked without reducing CI policy strictness

## Rollback / Recovery

If remediation introduces additional regressions:

- revert the patch commit on the PR branch
- re-open diagnosis with step-level logs
- escalate to service-specific runbook if issue is broader than dependency update scope

## References

- `docs/50-operations/runbooks/rbk-docs-deploy.md`
- `docs/50-operations/runbooks/rbk-portfolio-ci-triage.md`
- `docs/50-operations/runbooks/rbk-portfolio-dependency-vulnerability.md`
- `docs/30-devops-platform/ci-cd-pipeline-overview.md`
- `docs/50-operations/incident-response/incident-handbook.md`
