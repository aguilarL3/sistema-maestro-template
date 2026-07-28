#!/usr/bin/env bash
# Setup del vault (correr UNA vez tras clonar). Idempotente.
set -euo pipefail
cd "$(dirname "$0")"
UPSTREAM_URL="${UPSTREAM_URL:-https://github.com/aguilarL3/sistema-maestro-template.git}"

echo "== Sistema Maestro — setup =="
git config core.hooksPath .githooks && echo "✓ git hooks (verifier pre-commit) activados"
git config core.longpaths true 2>/dev/null && echo "✓ core.longpaths (Windows)" || true
mkdir -p .vault-meta && echo "✓ .vault-meta/ (estado local, gitignored)"
if ! git remote get-url upstream >/dev/null 2>&1; then
  git remote add upstream "$UPSTREAM_URL" && echo "✓ remote 'upstream' → $UPSTREAM_URL"
else
  echo "✓ remote 'upstream' ya existe"
fi

# gh: con dos remotos (origin = tu vault, upstream = el template), gh no sabe contra
# cuál abrir PRs/issues y falla con 'Head sha can't be blank' / 'No commits between'.
# Fijar origin como default lo evita. Solo si gh está instalado y autenticado; si no,
# queda documentado en el README y se corre a mano: gh repo set-default <org>/<repo>.
if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
  origin_slug="$(git remote get-url origin 2>/dev/null | sed -E -e 's#\.git$##' -e 's#.*[:/]([^/]+/[^/]+)$#\1#' || true)"
  if [ -n "${origin_slug:-}" ] && gh repo set-default "$origin_slug" >/dev/null 2>&1; then
    echo "✓ gh default → $origin_slug (PRs/issues van a tu vault, no al template)"
  else
    echo "· gh: fijá el default cuando vayas a abrir PRs → gh repo set-default <org>/<repo>"
  fi
fi

# Capa multi-persona: solo hace algo si owner.env declara VAULT_MODE=equipo.
if [ -f team-mode.sh ]; then bash ./team-mode.sh; fi

echo ""
echo "Siguientes pasos:"
echo "  1. Abrí esta carpeta como vault en Obsidian → 'Trust author and enable plugins'"
echo "  2. Leé '00 Inicio Rapido.md' (el tutorial de entrada)"
echo "  3. Con un agente de IA: abrilo acá y pedile 'Run onboarding'"
echo "  4. Actualizaciones: ./update.sh --check"
