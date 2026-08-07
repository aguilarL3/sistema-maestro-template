#!/usr/bin/env bash
# Activa la capa multi-persona del vault cuando vault.conf declara VAULT_MODE=equipo.
# Idempotente y no destructivo: nunca pisa un archivo existente.
# En modo personal no hace absolutamente nada.
#
# Lo corren solos ./setup.sh y ./update.sh. También podés correrlo a mano.
# Ver: 00 Sistema/SOP Git y Flujo de Trabajo.md §11 y SOP Multi-Agente.md §5
set -euo pipefail
cd "$(dirname "$0")"

# vault.conf se PARSEA, no se sourcea: está versionado, y un `source` ejecutaría
# shell de un archivo que puede llegar por PR. owner.env sí se sourcea porque es
# local y gitignorado — pero por eso mismo NO llega al clon de las demás personas,
# y por eso la gobernanza se mudó a vault.conf.
vault_conf() {   # $1=clave  $2=default
  local v
  v="$(sed -n "s/^[[:space:]]*$1[[:space:]]*=[[:space:]]*//p" vault.conf 2>/dev/null | head -1)"
  v="${v%"${v##*[![:space:]]}"}"
  v="${v#\"}"; v="${v%\"}"; v="${v#\'}"; v="${v%\'}"
  [ -n "$v" ] && printf '%s' "$v" || printf '%s' "$2"
}

MODE="$(vault_conf VAULT_MODE "")"
TEAM_MEMBERS="$(vault_conf TEAM_MEMBERS "")"
# Compat: instancias anteriores a vault.conf tenían las dos claves en owner.env.
if [ -z "$MODE" ] && [ -f owner.env ]; then
  # shellcheck disable=SC1091
  source ./owner.env
  MODE="${VAULT_MODE:-}"
  TEAM_MEMBERS="${TEAM_MEMBERS:-}"
fi
[ "${MODE:-personal}" = "equipo" ] || exit 0

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
  echo "  ⚠ TEAM_MEMBERS está vacío en vault.conf — no se crearon carpetas de diario."
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

# ── 3. Acuerdo de trabajo del equipo ─────────────────────────────────────────
# En plan Free de GitHub no hay reglas de rama, así que este documento no es un
# complemento del control: ES el control. Se instala desde el ejemplo y se avisa
# qué falta completar. Jamás se pisa uno existente.
ACUERDO="00 Sistema/Cómo trabajamos en este vault.md"
if [ -f "$ACUERDO" ]; then
  echo "  · $ACUERDO ya existe (no se toca)"
elif [ -f "$ACUERDO.example" ] || [ -f "00 Sistema/Cómo trabajamos en este vault.example.md" ]; then
  cp "00 Sistema/Cómo trabajamos en este vault.example.md" "$ACUERDO"
  echo "  ✓ $ACUERDO creado desde el ejemplo"
  echo "    ⚠ FALTA completarlo: la organización, los prefijos de rama de cada"
  echo "      persona y el reparto de zonas. Y borrar el bloque PLANTILLA de arriba."
  echo "    Es lo primero que lee quien se suma — y en plan Free, el único control."
else
  echo "  ⚠ No se encontró 00 Sistema/Cómo trabajamos en este vault.example.md"
fi

# ── 4. Qué queda protegido ───────────────────────────────────────────────────
echo "  ✓ gate de rama en .githooks/pre-commit: RECHAZA commits sobre la rama"
echo "    principal, lo haga un agente o una persona (kill-switch:"
echo "    .vault-meta/branch-gate.disabled). Requiere core.hooksPath=.githooks."
echo "  ✓ auto-commit consciente del modo: en 'equipo' no commitea en main/master."

# ── 5. Lo que el script NO puede hacer por vos ───────────────────────────────
cat <<'EOF'

Trabajá SIEMPRE en tu rama (nunca directo en la principal):
  git switch -c <tu-prefijo>/<tema>      # ej. le/moc-clientes
El prefijo es de DOS letras, no la inicial: con dos personas que comparten
inicial, la inicial sola es ambigua. Fijalo por escrito antes del primer PR.

Para abrir PRs con `gh`: si no lo hizo el setup (gh no estaba instalado entonces),
fijá una sola vez el repo default a tu vault, o `gh pr create` falla contra el
template (origin vs upstream):  gh repo set-default <org>/<repo>

Y pedí el review explícitamente —`gh pr create --reviewer <persona>`— porque
CODEOWNERS NO auto-asigna revisor en repos privados con plan Free. Sin ese flag,
la otra persona no se entera de que abriste el PR.

Reglas de rama en GitHub (Settings → Rules): si el repo es PÚBLICO o el plan es
de pago, activá 'Require a pull request', 'Require review from Code Owners',
'Require status checks' y 'Block force pushes'. En plan Free con repo PRIVADO no
están disponibles (403) — ahí el gate de arriba y el acuerdo escrito del equipo
son todo el control que hay.

Y un recordatorio del SOP: en modo equipo el AUTOR del commit es la persona
que lanzó al agente; el agente va como trailer (SOP Multi-Agente §3.1).
EOF
