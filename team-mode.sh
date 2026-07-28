#!/usr/bin/env bash
# Activa la capa multi-persona del vault cuando owner.env declara VAULT_MODE=equipo.
# Idempotente y no destructivo: nunca pisa un archivo existente.
# En modo personal no hace absolutamente nada.
#
# Lo corren solos ./setup.sh y ./update.sh. También podés correrlo a mano.
# Ver: 00 Sistema/SOP Git y Flujo de Trabajo.md §11 y SOP Multi-Agente.md §5
set -euo pipefail
cd "$(dirname "$0")"

[ -f owner.env ] || exit 0
# shellcheck disable=SC1091
source ./owner.env
MODE="${VAULT_MODE:-personal}"
[ "$MODE" = "equipo" ] || exit 0

echo "== Modo equipo =="

# ── 1. Una carpeta de diario por persona ─────────────────────────────────────
# El diario es el archivo más editado y el menos compartido: separarlo por
# persona elimina de raíz el grueso de los conflictos de merge.
if [ -n "${TEAM_MEMBERS:-}" ]; then
  IFS=',' read -ra MEMBERS <<< "$TEAM_MEMBERS"
  for m in "${MEMBERS[@]}"; do
    # trim de espacios alrededor
    name="$(printf '%s' "$m" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')"
    [ -n "$name" ] || continue
    if [ -d "05 Diario/$name" ]; then
      echo "  · 05 Diario/$name/ ya existe"
    else
      mkdir -p "05 Diario/$name"
      : > "05 Diario/$name/.gitkeep"
      echo "  ✓ 05 Diario/$name/"
    fi
  done
else
  echo "  ⚠ TEAM_MEMBERS está vacío en owner.env — no se crearon carpetas de diario."
fi

# ── 2. CODEOWNERS ────────────────────────────────────────────────────────────
# Deliberadamente NO se genera el reparto de zonas: quién es dueño de qué es
# una decisión de gobernanza, no algo que una plantilla pueda adivinar.
# Se instala el ejemplo y se avisa qué falta.
if [ -f .github/CODEOWNERS ]; then
  echo "  · .github/CODEOWNERS ya existe (no se toca)"
elif [ -f .github/CODEOWNERS.example ]; then
  cp .github/CODEOWNERS.example .github/CODEOWNERS
  echo "  ✓ .github/CODEOWNERS creado desde el ejemplo"
  echo "    ⚠ FALTA: reemplazar @persona-a/@persona-b/@persona-c por handles reales"
  echo "      de GitHub, y ajustar el reparto de zonas a tu equipo."
  echo "    ⚠ Al editarlo: los espacios de las rutas van escapados (/00\\ Sistema/)."
  echo "      Sin escapar, CODEOWNERS lee lo que sigue al espacio como DUEÑO."
else
  echo "  ⚠ No se encontró .github/CODEOWNERS.example"
fi

# ── 3. Auto-commit ya protege `main` ─────────────────────────────────────────
echo "  ✓ auto-commit consciente del modo: en 'equipo' NO commitea en main/master"
echo "    (el trabajo va en tu rama de persona → PR). En una rama, funciona igual."

# ── 4. Lo que el script NO puede hacer por vos ───────────────────────────────
cat <<'EOF'

Trabajá SIEMPRE en tu rama (nunca directo en main): `git checkout -b <inicial>/<tema>`.
En main el auto-commit se abstiene a propósito; tu cambio queda sin commitear hasta
que estés en una rama.

Para abrir PRs con `gh`: si no lo hizo el setup (gh no estaba instalado entonces),
fijá una sola vez el repo default a tu vault, o `gh pr create` falla contra el
template (origin vs upstream):  gh repo set-default <org>/<repo>

Pendiente en GitHub (Settings → Rules → proteger `main`) — es server-side, ningún
script lo puede garantizar por vos:
  · Require a pull request before merging
  · Require review from Code Owners      ← sin esto CODEOWNERS solo sugiere
  · Require status checks to pass
  · Block force pushes

Y un recordatorio del SOP: en modo equipo el AUTOR del commit es la persona
que lanzó al agente; el agente va como trailer (SOP Multi-Agente §3.1).
EOF
