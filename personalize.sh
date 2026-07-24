#!/usr/bin/env bash
# Reemplaza los placeholders {{OWNER}}/{{OWNER_EMAIL}}/{{OWNER_GITHUB}} usando owner.env.
# Idempotente. update.sh lo corre automáticamente tras cada actualización.
set -euo pipefail
cd "$(dirname "$0")"

# ── Guard: no personalizar una instancia recién clonada "a mano"/desde afuera ──
# La inicialización correcta es interactiva, vía /onboarding, desde una sesión de
# agente abierta DENTRO de esta carpeta. La presencia de FIRST_RUN.md marca "sin
# inicializar todavía". /onboarding exporta SM_ONBOARDING=1 al llamar acá; update.sh
# corre post-onboarding (ya no existe FIRST_RUN.md), así que no queda bloqueado.
if [ -f FIRST_RUN.md ] && [ "${SM_ONBOARDING:-0}" != "1" ] && [ "${FORCE:-0}" != "1" ]; then
  cat >&2 <<'MSG'
⛔ Esta instancia todavía no está inicializada — no la personalices a mano ni desde afuera.

   La inicialización es interactiva y desde adentro:
   1. Abrí ESTA carpeta como una sesión propia de tu agente (Claude Code / Codex / …).
   2. Pedí:  /onboarding   (hace la entrevista y personaliza el vault correctamente).

   ¿Sabés lo que hacés y querés forzar la personalización mecánica igual?
     →  FORCE=1 ./personalize.sh
MSG
  exit 1
fi

[ -f owner.env ] || { echo "No hay owner.env — corré la skill /onboarding (o creá owner.env: OWNER=..., OWNER_EMAIL=..., OWNER_GITHUB=...)"; exit 0; }
# shellcheck disable=SC1091
source ./owner.env
: "${OWNER:?owner.env sin OWNER=}"
find . -path ./.git -prune -o -type f \( -name "*.md" -o -name "*.txt" \) -print0 | \
  xargs -0 sed -i "s/{{OWNER_EMAIL}}/${OWNER_EMAIL:-}/g; s/{{OWNER_GITHUB}}/${OWNER_GITHUB:-}/g; s/{{OWNER}}/${OWNER}/g"
echo "✓ Personalizado para: $OWNER"
