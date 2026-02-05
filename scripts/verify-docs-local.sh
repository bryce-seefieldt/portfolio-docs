#!/usr/bin/env bash

# verify-docs-local.sh
# Comprehensive local verification for the Portfolio Docs App (Docusaurus).
# Runs formatting, linting, type checking, and production build to mirror CI.

set -euo pipefail

SKIP_BUILD=false
AUDIT_JSON=false
AUDIT_REPORT_PATH="audit-report.json"
for arg in "$@"; do
  case "$arg" in
    --skip-build)
      SKIP_BUILD=true
      ;;
    --audit-json)
      AUDIT_JSON=true
      ;;
    --audit-json=*)
      AUDIT_JSON=true
      AUDIT_REPORT_PATH="${arg#*=}"
      ;;
    --help|-h)
      echo "Usage: $0 [--skip-build] [--audit-json[=path]]"
      echo "  --skip-build        Run all checks except the production build (for quick iteration)"
      echo "  --audit-json        Save pnpm audit JSON output to audit-report.json"
      echo "  --audit-json=path   Save pnpm audit JSON output to a custom path"
      exit 0
      ;;
  esac
done

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

FAILURES=0
WARNINGS=0
AUDIT_FAILED=false

print_header() {
  echo ""
  echo -e "${BOLD}${BLUE}═══════════════════════════════════════════════════════════════════════════${NC}"
  echo -e "${BOLD}${BLUE}  Portfolio Docs — Local Verification${NC}"
  echo -e "${BOLD}${BLUE}═══════════════════════════════════════════════════════════════════════════${NC}"
  echo ""
  echo "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
  echo "Workspace: $(pwd)"
  echo ""
}

print_section() {
  echo ""
  echo -e "${BOLD}${CYAN}▶ $1${NC}"
  echo ""
}

print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_failure() { echo -e "${RED}✗${NC} $1"; FAILURES=$((FAILURES + 1)); }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; WARNINGS=$((WARNINGS + 1)); }
print_info() { echo -e "${BLUE}ℹ${NC} $1"; }

print_header

print_section "Environment check"

NODE_VERSION=$(node --version 2>/dev/null || true)
PNPM_VERSION=$(pnpm --version 2>/dev/null || true)

if [ -z "$NODE_VERSION" ]; then
  print_failure "Node.js not found"
else
  print_success "Node.js $NODE_VERSION"
fi

if [ -z "$PNPM_VERSION" ]; then
  print_failure "pnpm not found"
else
  print_success "pnpm $PNPM_VERSION"
fi

if [ ! -f ".env.local" ]; then
  print_warning ".env.local not found (local preview may use defaults)"
  echo "  Hint: cp .env.example .env.local and adjust values for local preview."
else
  print_success ".env.local present"
fi

print_section "Step 1: Auto-format (format:write)"
if pnpm format:write > /dev/null 2>&1; then
  print_success "Formatting applied"
else
  print_failure "format:write failed"
fi

print_section "Step 2: ESLint (lint)"
if pnpm lint; then
  print_success "Lint passed"
else
  print_failure "Lint failed"
fi

print_section "Step 3: TypeScript (typecheck)"
if pnpm typecheck; then
  print_success "Type check passed"
else
  print_failure "Type check failed"
fi

print_section "Step 4: Format validation (format:check)"
if pnpm format:check; then
  print_success "Format check passed"
else
  print_failure "Format check failed"
fi

print_section "Step 5: Dependency audit (pnpm audit --audit-level=high)"
if [ "$AUDIT_JSON" = true ]; then
  AUDIT_OUTPUT=$(pnpm audit --audit-level=high --json 2>&1)
  AUDIT_EXIT_CODE=$?
  echo "$AUDIT_OUTPUT" > "$AUDIT_REPORT_PATH"
else
  AUDIT_OUTPUT=$(pnpm audit --audit-level=high 2>&1)
  AUDIT_EXIT_CODE=$?
fi

if [ $AUDIT_EXIT_CODE -eq 0 ]; then
  print_success "Dependency audit passed (no high/critical vulnerabilities)"
  if [ "$AUDIT_JSON" = true ]; then
    print_info "Audit report saved to ${AUDIT_REPORT_PATH}"
  fi
else
  AUDIT_FAILED=true
  print_failure "Dependency audit failed"
  echo ""
  echo "Audit output (full):"
  echo ""
  echo "$AUDIT_OUTPUT"
  echo ""
  if [ "$AUDIT_JSON" = true ]; then
    print_info "Audit report saved to ${AUDIT_REPORT_PATH}"
  fi
fi

if [ "$SKIP_BUILD" = false ]; then
  print_section "Step 6: Production build (build)"
  if pnpm build; then
    print_success "Build passed"
  else
    print_failure "Build failed"
  fi
else
  print_section "Step 6: Production build (skipped)"
  print_warning "Build skipped by flag --skip-build"
fi

echo ""
echo -e "${BOLD}${BLUE}Summary${NC}"

if [ $FAILURES -eq 0 ]; then
  print_success "All checks completed"
else
  print_failure "Failures encountered: $FAILURES"
fi

if [ $WARNINGS -gt 0 ]; then
  print_warning "Warnings: $WARNINGS"
fi

echo ""
echo "Next steps:"
echo "  1) Review any failures above"
echo "  2) Fix issues and rerun this script"
echo "  3) When clean, open PR with evidence that checks passed"

if [ "$AUDIT_FAILED" = true ]; then
  echo ""
  echo "Audit troubleshooting:"
  echo "  - Re-run: pnpm audit --audit-level=high"
  echo "  - Update vulnerable dependencies: pnpm up --latest"
  echo "  - Identify direct vs transitive advisory impact in the audit output"
  echo "  - Review ${AUDIT_REPORT_PATH} for machine-readable details (if generated)"
  echo "  - If no fix exists, document the risk in docs/40-security/risk-register.md"
fi

if [ $FAILURES -gt 0 ]; then
  exit 1
fi

exit 0