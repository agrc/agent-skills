#!/usr/bin/env bash
set -euo pipefail

# Validates all skills in the skills folder using pnpm exec skills-ref validate.
# Usage: ./scripts/validate-skills.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
SKILLS_DIR="${REPO_ROOT}/skills"

if [[ ! -d "${SKILLS_DIR}" ]]; then
  echo "❌ Skills directory not found: ${SKILLS_DIR}"
  exit 1
fi

failed=0

for skill_path in "${SKILLS_DIR}"/*; do
  if [[ ! -d "${skill_path}" ]]; then
    continue
  fi

  skill_name="$(basename "${skill_path}")"
  relative_path="./skills/${skill_name}"

  echo "🔍 Validating ${skill_name}..."
  if ! pnpm exec skills-ref validate "${relative_path}"; then
    echo "❌ ${skill_name} failed validation"
    failed=$((failed + 1))
  else
    echo "✅ ${skill_name} passed validation"
  fi
  echo ""
done

if [[ ${failed} -gt 0 ]]; then
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "❌ ${failed} skill(s) failed validation"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  exit 1
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ All skills passed validation"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
