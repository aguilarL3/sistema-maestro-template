#!/usr/bin/env bash
# migrate-okf.sh — Migra una instancia existente del Sistema Maestro al vocabulario OKF (v1.0.0).
#
# Qué hace (todo local, reversible con git):
#   1. Renombra los README.md de carpeta-índice → index.md generado (preservando tu prosa en un backup).
#   2. Migra las claves de frontmatter de TUS notas: tipo_doc→type, ultima_revision→timestamp,
#      + alta de title (desde el H1) + resource (scaffold vacío), y luego timestamp→generated{by,at} (OKF v0.2).
#   3. Convierte los wikilinks resueltos a links markdown (las promesas [[...]] quedan intactas).
#   4. Regenera los index.md desde el frontmatter.
#
# Tu contenido no se pierde: los README con prosa se respaldan en ".okf-backup/" antes de borrarse.
# Es idempotente: correrlo dos veces no rompe nada (la 2ª pasada no encuentra claves viejas).
#
# Uso:  ./migrate-okf.sh [--dry-run]
set -euo pipefail
cd "$(dirname "$0")"
DRY="${1:-}"

HOOKS=".claude/hooks"
for s in migrate-keys.py migrate-generated.py harden-links.py generate-index.py; do
  [ -f "$HOOKS/$s" ] || { echo "✗ Falta $HOOKS/$s — actualizá el framework primero (./update.sh)."; exit 1; }
done

# Carpetas cuyo README.md es un índice de carpeta (NO tooling: .claude/hooks y Baseline conservan README).
INDEX_README_DIRS=(
  "03 Proyectos" "04 Knowledge" "04 Knowledge/Temas" "04 Knowledge/Prompts"
  "04 Knowledge/Sistemas y Metodologías" "05 Diario" "06 Raw" "99 Archivo"
)

echo "== 1/4 · README.md de carpeta → index.md (con backup de prosa) =="
BACKUP=".okf-backup/$(date +%Y%m%d-%H%M%S)"
for d in "${INDEX_README_DIRS[@]}"; do
  r="$d/README.md"
  [ -f "$r" ] || continue
  if [ "$DRY" = "--dry-run" ]; then echo "  DRY backup+rm: $r"; continue; fi
  mkdir -p "$BACKUP/$d"
  cp "$r" "$BACKUP/$d/README.md"          # preserva tu prosa personalizada
  git rm -q "$r" 2>/dev/null || rm -f "$r"
  echo "  ✓ $r  (backup en $BACKUP/$d/)"
done

if [ "$DRY" = "--dry-run" ]; then KEYS_FLAG="--dry"; LINK_FLAG=""; else KEYS_FLAG="--apply"; LINK_FLAG="--apply"; fi

echo "== 2/4 · claves de frontmatter (type/timestamp/title/resource) =="
python "$HOOKS/migrate-keys.py" "$KEYS_FLAG" | tail -1
echo "== 2b/4 · OKF v0.2: timestamp → generated{by,at} =="
python "$HOOKS/migrate-generated.py" "$KEYS_FLAG" | tail -1

echo "== 3/4 · wikilinks resueltos → links markdown =="
python "$HOOKS/harden-links.py" --wiki $LINK_FLAG | tail -1

echo "== 4/4 · regenerar index.md =="
[ "$DRY" = "--dry-run" ] || python "$HOOKS/generate-index.py" | tail -1

echo ""
if [ "$DRY" = "--dry-run" ]; then
  echo "DRY-RUN: no se tocó nada. Corré sin --dry-run para aplicar."
else
  echo "✓ Migración OKF aplicada. Tu prosa de README quedó en $BACKUP/ (revisala y movela a un SOP si querés conservarla)."
  echo "  Revisá 'git status', abrí el vault en Obsidian para chequear links/grafo, y commiteá:"
  echo "  git add -A && git commit -m \"chore: migración OKF (v1.0.0)\""
fi
