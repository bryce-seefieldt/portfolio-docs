#!/usr/bin/env bash

# policy-consistency-check.sh
# Non-invasive governance drift checker for portfolio-docs.
# Default mode is warning-only (exit 0). Use --strict to fail on warnings.

set -u

STRICT=false
for arg in "$@"; do
  case "$arg" in
    --strict)
      STRICT=true
      ;;
    --help|-h)
      echo "Usage: $0 [--strict]"
      echo "  --strict  Exit non-zero when warnings are found"
      exit 0
      ;;
  esac
done

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WARNINGS=0
ALLOWLIST_FILE="$ROOT_DIR/scripts/policy-consistency-allowlist.txt"

warn() {
  WARNINGS=$((WARNINGS + 1))
  echo "[policy-check][warn] $1"
}

info() {
  echo "[policy-check][info] $1"
}

is_allowlisted() {
  local rule="$1"
  local line="$2"

  [[ ! -f "$ALLOWLIST_FILE" ]] && return 1

  while IFS= read -r entry; do
    [[ -z "$entry" ]] && continue
    [[ "$entry" =~ ^# ]] && continue

    local entry_rule="${entry%%|*}"
    local entry_pattern="${entry#*|}"

    [[ "$entry_rule" != "$rule" ]] && continue
    if [[ "$line" =~ $entry_pattern ]]; then
      return 0
    fi
  done < "$ALLOWLIST_FILE"

  return 1
}

filter_non_allowlisted() {
  local rule="$1"
  local input="$2"
  local output=""

  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    if ! is_allowlisted "$rule" "$line"; then
      output+="$line"$'\n'
    fi
  done <<< "$input"

  printf '%s' "$output"
}

check_hardcoded_hosts() {
  info "Checking for hardcoded production hosts in policy-sensitive docs"
  local files filtered
  files=$(grep -RIn --include='*.md' --include='*.mdx' --exclude-dir='_archive' --exclude-dir='build' --exclude-dir='.docusaurus' \
    -E 'https://bns-portfolio-docs\.vercel\.app|https://bns-portfolio-app\.vercel\.app' "$ROOT_DIR/docs" "$ROOT_DIR/.github" 2>/dev/null || true)

  filtered=$(filter_non_allowlisted "hardcoded-host" "$files")

  if [[ -n "$filtered" ]]; then
    warn "Hardcoded host references detected; prefer env-driven URL construction"
    echo "$filtered"
  fi
}

check_known_legacy_paths() {
  info "Checking for known legacy internal path shapes"
  local files filtered
  files=$(grep -RIn --include='*.md' --include='*.mdx' --exclude-dir='build' --exclude-dir='.docusaurus' \
    -E '/docs/(architecture|operations)(/|$)' "$ROOT_DIR/docs" "$ROOT_DIR/.github" 2>/dev/null || true)

  filtered=$(filter_non_allowlisted "legacy-link-path" "$files")

  if [[ -n "$filtered" ]]; then
    warn "Legacy internal link path shapes detected"
    echo "$filtered"
  fi
}

check_public_docs_front_matter() {
  info "Checking front matter in public docs pages"
  local missing=0
  while IFS= read -r file; do
    [[ "$file" == *"/docs/_meta/"* ]] && continue
    [[ "$file" == *"/docs/_archive/"* ]] && continue

    local first
    first=$(head -n 1 "$file" 2>/dev/null || true)
    if [[ "$first" != "---" ]]; then
      if ! is_allowlisted "front-matter" "$file"; then
        warn "Missing front matter opening marker: $file"
      fi
      missing=$((missing + 1))
      continue
    fi

    if ! head -n 60 "$file" | grep -q '^---$' ; then
      if ! is_allowlisted "front-matter" "$file"; then
        warn "Front matter closing marker not found in first 60 lines: $file"
      fi
      missing=$((missing + 1))
    fi
  done < <(find "$ROOT_DIR/docs" -type f \( -name '*.md' -o -name '*.mdx' \))

  if [[ $missing -eq 0 ]]; then
    info "Public docs front matter check passed"
  fi
}

check_tier_c_in_canonical_policy() {
  info "Checking for temporal phase/stage guidance in canonical policy"
  local hits filtered
  hits=$(grep -nE '^#{1,3}[[:space:]].*(Phase [0-9]+|Stage [0-9]+\.[0-9]+)' "$ROOT_DIR/.github/copilot-instructions.md" 2>/dev/null || true)
  filtered=$(filter_non_allowlisted "temporal-guidance" "$hits")

  if [[ -n "$filtered" ]]; then
    warn "Potential temporal guidance detected in canonical instructions"
    echo "$filtered"
  fi
}

if [[ -f "$ALLOWLIST_FILE" ]]; then
  info "Using allowlist file: $ALLOWLIST_FILE"
else
  info "No allowlist file found; running without exceptions"
fi

check_hardcoded_hosts
check_known_legacy_paths
check_public_docs_front_matter
check_tier_c_in_canonical_policy

echo "[policy-check][summary] warnings=$WARNINGS strict=$STRICT"

if [[ "$STRICT" == "true" && $WARNINGS -gt 0 ]]; then
  exit 1
fi

exit 0
