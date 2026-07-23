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

# Capa multi-persona: solo hace algo si owner.env declara VAULT_MODE=equipo.
if [ -f team-mode.sh ]; then bash ./team-mode.sh; fi

echo ""
echo "Siguientes pasos:"
echo "  1. Abrí esta carpeta como vault en Obsidian → 'Trust author and enable plugins'"
echo "  2. Leé '00 Inicio Rapido.md' (el tutorial de entrada)"
echo "  3. Con un agente de IA: abrilo acá y pedile 'Run onboarding'"
echo "  4. Actualizaciones: ./update.sh --check"
