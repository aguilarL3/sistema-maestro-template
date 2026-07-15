#!/usr/bin/env bash
# Actualiza SOLO los archivos de framework desde el template upstream.
# Tu contenido (notas, diario, proyectos, 01 Index, Knowledge propio) NUNCA se toca.
# Patrón: whitelist explícita (prior art: COG-second-brain cog-update.sh).
#
# Uso: ./update.sh [--check | --dry-run | --force]
set -euo pipefail
cd "$(dirname "$0")"
REMOTE="upstream"; BRANCH="main"

# Whitelist de framework (sincronizada con vault-manifest.json → infrastructure)
FRAMEWORK_PATHS=(
  ".claude" ".githooks" ".gitattributes" ".gitignore" ".obsidian"
  "00 Sistema"
  "04 Knowledge/Skills" "04 Knowledge/Automatización" "04 Knowledge/Sistemas y Metodologías"
  "04 Knowledge/Investigación del Sistema"
  "01 Index/Principios.md" "01 Index/Valores.md"
  "02 MOCs/MOC - Investigación del Sistema.md"
  "04 Knowledge/README.md" "04 Knowledge/Temas/README.md"
  "04 Knowledge/Temas/Prompt Injection y la Tríada Letal.md"
  "04 Knowledge/Temas/Cadena de Suministro y Código de Terceros.md"
  "02 MOCs/MOC - Seguridad.md"
  "03 Proyectos/README.md" "05 Diario/README.md"
  "05 Diario/Bitácora Agentes/_Acerca de esta bitácora.md"
  "06 Raw/README.md" "99 Archivo/README.md"
  "CLAUDE.md" "AGENTS.md" "llms.txt" "00 Inicio Rapido.md"
  "Matriz Definitiva.md" "SOPS.md" "Vault System Map.md"
  "README.md" "VERSION" "vault-manifest.json" "setup.sh" "update.sh" "personalize.sh" "owner.env.example" "LICENSE"
)

MODE="${1:-interactive}"
git remote get-url "$REMOTE" >/dev/null 2>&1 || { echo "Falta remote '$REMOTE'. Corré ./setup.sh"; exit 1; }
git fetch "$REMOTE" "$BRANCH" --quiet

LOCAL_V=$(cat VERSION 2>/dev/null || echo "?")
REMOTE_V=$(git show "$REMOTE/$BRANCH:VERSION" 2>/dev/null || echo "?")
echo "Versión local: $LOCAL_V · upstream: $REMOTE_V"
if [ "$MODE" = "--check" ]; then
  [ "$LOCAL_V" = "$REMOTE_V" ] && echo "Al día." || echo "Hay actualización disponible. Corré ./update.sh"
  exit 0
fi

# Archivos de framework que difieren del upstream
CHANGED=$(git -c core.quotepath=false diff --name-only HEAD "$REMOTE/$BRANCH" -- "${FRAMEWORK_PATHS[@]}" || true)
if [ -z "$CHANGED" ]; then echo "Nada que actualizar."; exit 0; fi
echo "Archivos de framework con cambios upstream:"; echo "$CHANGED" | sed 's/^/  · /'

if [ "$MODE" = "--dry-run" ]; then exit 0; fi
if [ "$MODE" != "--force" ]; then
  read -r -p "¿Actualizar estos archivos? Tu contenido no se toca. [s/N] " R
  case "$R" in [sS]) ;; *) echo "Cancelado."; exit 0;; esac
fi

echo "$CHANGED" | while IFS= read -r f; do
  git -c core.quotepath=false checkout "$REMOTE/$BRANCH" -- "$f" && echo "  ✓ $f"
done
echo ""
if [ -f owner.env ]; then bash ./personalize.sh; fi
if printf '%s\n' "$CHANGED" | grep -qx "update.sh"; then
  echo "⚠ update.sh se actualizó a sí mismo — corré ./update.sh una vez más para aplicar la whitelist nueva."
fi
echo "Actualizado a $REMOTE_V. Revisá 'git status' y commiteá: git commit -m \"chore: update framework a $REMOTE_V\""
