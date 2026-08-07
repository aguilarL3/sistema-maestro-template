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

# Instancias anteriores a vault.conf: el modo vivía en owner.env, que está
# GITIGNOREADO. En el clon de la segunda persona ese archivo no existe, así que
# el modo equipo entero (gate de rama, aviso de PRs, auto-commit) nacía inerte
# justo para quien tenía que protegerlo. Se avisa fuerte y una sola vez.
if [ ! -f vault.conf ] && grep -qs '^[[:space:]]*VAULT_MODE[[:space:]]*=[[:space:]]*equipo' owner.env 2>/dev/null; then
  echo ""
  echo "🔴 Este vault declara VAULT_MODE=equipo en owner.env, que está gitignoreado."
  echo "   O sea: NO llega al clon de las demás personas, y ahí el modo equipo"
  echo "   queda apagado sin aviso (sin gate de rama, sin aviso de PRs)."
  echo "   Arreglo, una vez, y lo hace quien mantiene el vault:"
  echo "     1) crear vault.conf con VAULT_MODE, MAIN_BRANCH y TEAM_MEMBERS"
  echo "     2) git add vault.conf && commitear  ← versionado, esa es la clave"
  echo ""
fi

# Capa multi-persona: solo hace algo si vault.conf declara VAULT_MODE=equipo.
if [ -f team-mode.sh ]; then bash ./team-mode.sh; fi

echo ""
echo "Siguientes pasos:"
echo "  1. Abrí esta carpeta como vault en Obsidian → 'Trust author and enable plugins'"
echo "  2. Leé '00 Inicio Rapido.md' (el tutorial de entrada)"

# El onboarding se sugiere SOLO si el vault está sin inicializar. FIRST_RUN.md es
# la marca. En un vault ya personalizado, /onboarding pediría la identidad de
# quien lo corre y volvería a personalizar TODO con SU nombre — que es justo el
# accidente a evitar cuando la segunda persona clona un vault que ya tiene dueño.
if [ -f FIRST_RUN.md ]; then
  echo "  3. Con un agente de IA: abrilo acá y pedile 'Run onboarding'"
  echo "  4. Actualizaciones: ./update.sh --check"
else
  echo "  3. Este vault YA está inicializado: NO corras /onboarding ni personalize.sh."
  echo "     Pediría tu identidad y re-personalizaría el vault entero con tu nombre,"
  echo "     mezclando dos identidades. Si te sumás a un vault que ya tiene dueño,"
  echo "     tu paso siguiente es leer el acuerdo de trabajo del equipo, no inicializar."
  if [ -f "00 Sistema/Cómo trabajamos en este vault.md" ]; then
    echo "     → '00 Sistema/Cómo trabajamos en este vault.md'"
  fi
  echo "  4. Configurá tu identidad de git con tu correo VERIFICADO en GitHub:"
  echo "       git config user.email <tu-correo>   &&   git log -1 --format='%ae'"
  echo "  5. Actualizaciones: ./update.sh --check  (las corre quien mantiene el vault)"
fi
