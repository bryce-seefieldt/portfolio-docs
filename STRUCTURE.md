# Documentation Structure

## Rationale

- Enforce a stable, predictable navigation order (and avoids “misc” sprawl).
- Reads like an enterprise binder:  
  Product → Architecture → Engineering → Platform → Security → Ops → Projects → Reference.

## Architecture

```makefile

docs/
  index.md                         # landing: “What is this service? Who is it for? How to navigate?”
  _meta/
    glossary.md
    abbreviations.md
    doc-style-guide.md
    taxonomy-and-tagging.md
    templates/
      template-adr.md
      template-runbook.md
      template-postmortem.md
      template-threat-model.md
      template-architecture.md
      template-operations-checklist.md

  00-portfolio/
    index.md
    product-brief.md               # “interactive CV” positioning, target audience, differentiators
    capabilities-map.md            # what the portfolio demonstrates (DevOps, security, platform, etc.)
    roadmap.md
    release-notes/
      index.md
      v0.1.0.md
      v0.2.0.md

  10-architecture/
    index.md
    system-context.md              # C4 L1
    container-architecture.md      # C4 L2
    component-design.md            # C4 L3 (key subsystems)
    data-flows.md                  # data movement + trust boundaries
    integrations.md                # linked demo projects + dependencies
    adr/
      index.md
      adr-0001-tech-stack.md
      adr-0002-hosting-and-cicd.md
      adr-0003-authn-authz.md
      adr-0004-logging-and-auditing.md

  20-engineering/
    index.md
    coding-standards.md            # TS/React/Node conventions, lint/format, commit standards
    branching-and-release.md        # trunk-based, tagging, environments
    testing-strategy.md             # unit/integration/e2e, test pyramid, coverage gates
    dependency-management.md        # pinning, updates, renovate/dependabot policy
    local-dev/
      index.md
      wsl2-workstation.md           # reproducible dev env + rebuild steps (your WSL2+VS Code standard)
      repo-layout.md
      commands-cheatsheet.md        # “golden commands” + task recipes
      troubleshooting.md

  30-devops-platform/
    index.md
    ci-cd/
      index.md
      pipeline-overview.md          # pipeline stages + rationale
      github-actions.md             # workflows: lint/test/build/deploy
      build-artifacts.md            # what artifacts exist, naming, retention
      environment-promotion.md      # preview -> staging -> prod (even if “prod” is Vercel)
      rollback-strategy.md
    infrastructure/
      index.md
      hosting.md                    # Vercel/edge, domains, TLS, caching, headers
      IaC.md                        # Terraform/Pulumi approach if used (or rationale if not)
      networking.md                 # DNS, CDN behavior, rate limits
      containers.md                 # if Docker used anywhere (dev/test)
    observability/
      index.md
      logging.md
      metrics.md
      tracing.md
      alerting.md
      dashboards.md

  40-security/
    index.md
    security-overview.md            # your security model: goals, assumptions, threat landscape
    threat-models/
      index.md
      portfolio-app.md              # STRIDE-style threats + mitigations
      supply-chain.md               # dependencies, build integrity, provenance
    secure-sdlc/
      index.md
      sdlc-controls.md              # required checks, reviews, gates
      secrets-management.md         # no secrets in repo; env vars; rotation approach
      code-scanning.md              # SAST/DAST/SCA, what runs in CI
      dependency-audits.md
      sbom-and-provenance.md        # SBOM, attestations, SLSA posture (as applicable)
    privacy-and-data/
      index.md
      data-classification.md         # what data exists; what never exists
      retention.md
      pii-policy.md
    security-testing/
      index.md
      pentest-notes.md              # lightweight, reproducible checks + tooling
      headers-and-csp.md
      auth-security.md

  50-operations/
    index.md
    runbooks/
      index.md
      rbk-deploy.md
      rbk-rollback.md
      rbk-domain-dns.md
      rbk-incident-triage.md
    incident-response/
      index.md
      oncall-guide.md
      severity-model.md
      comms-templates.md
      postmortems/
        index.md
        pm-2025-xx-xx-example.md
    dr-bcp/
      index.md
      service-impact-analysis.md     # “portfolio app as service” + RTO/RPO
      backup-and-restore.md
      dependency-failures.md
      recovery-playbooks.md

  60-projects/
    index.md
    portfolio-web-app/
      index.md
      overview.md                    # what it is; features; NFRs
      architecture.md
      deployment.md
      security.md
      testing.md
      troubleshooting.md
    demos/
      index.md
      demo-01-eval-first-rag/
        index.md
        architecture.md
        deployment.md
        operations.md
        security.md
      demo-02-cmdb-sync-agents/
        index.md
        architecture.md
        api-contracts.md
        operations.md
        security.md

  70-reference/
    index.md
    api/
      index.md
      openapi.md                     # link/embedding strategy
    cli/
      index.md
      git.md
      node.md
      docker.md
      wsl.md
    configs/
      index.md
      vercel.md
      github-actions.md
      eslint-prettier.md
      tsconfig.md
```

### `src/`

**_Custom Pages and Polish_**

```makefile
src/
  pages/
    index.tsx                       # polished landing page for the docs site
    portfolio.tsx                   # “interactive CV” page (curated, recruiter-friendly)
    evidence.tsx                    # auto-curated security/devops evidence dashboard (optional)
  components/
    BadgeRow.tsx
    EvidenceCard.tsx
    ArchitectureCallout.tsx
  css/
    custom.css
```

### `static/`

**_diagrams, artifacts, downloadable evidence_**

```makefile
static/
  img/
    logos/
    diagrams/
      c4/
      sequence/
      threat-model/
  artifacts/
    sbom/
    scan-reports/
    architecture-exports/
```

_**Tip:** Keep “evidence artifacts” in static/artifacts/ and link them from security/DevOps pages in order to publish sanitized reports._

### CI/CD and Repo Hygiene

```makefile
.github/
  workflows/
    ci.yml                          # lint/test/build
    security.yml                    # code scanning, dependency audit, SBOM generation
    deploy.yml                      # publish docs (to Vercel or Pages)
    link-check.yml                  # broken link checks
```

#### Templates

```makefile
.github/ISSUE_TEMPLATE/
  bug_report.yml
  doc_improvement.yml
  security_issue.yml
  proposal.yml
```
