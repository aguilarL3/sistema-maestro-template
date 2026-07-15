#!/usr/bin/env bash
# Reemplaza los placeholders {{OWNER}}/{{OWNER_EMAIL}}/{{OWNER_GITHUB}} usando owner.env.
# Idempotente. update.sh lo corre automáticamente tras cada actualización.
set -euo pipefail
cd "$(dirname "$0")"
[ -f owner.env ] || { echo "No hay owner.env — corré la skill /onboarding (o creá owner.env: OWNER=..., OWNER_EMAIL=..., OWNER_GITHUB=...)"; exit 0; }
# shellcheck disable=SC1091
source ./owner.env
: "${OWNER:?owner.env sin OWNER=}"
find . -path ./.git -prune -o -type f \( -name "*.md" -o -name "*.txt" \) -print0 | \
  xargs -0 sed -i "s/{{OWNER_EMAIL}}/${OWNER_EMAIL:-}/g; s/{{OWNER_GITHUB}}/${OWNER_GITHUB:-}/g; s/{{OWNER}}/${OWNER}/g"
echo "✓ Personalizado para: $OWNER"
