#!/usr/bin/env bash
# check-contradictions.sh — inventario de contradicciones del vault (Gap 2b).
#
# El conflicto SEMÁNTICO (dos notas que afirman cosas opuestas) no se detecta
# mecánicamente: requiere criterio. La convención (adoptada de claude-obsidian)
# es que quien lo detecta lo MARCA con un callout Obsidian `> [!contradiction]`
# en vez de "arreglarlo" en silencio. Este script es el lado determinista:
# recorre el vault y lista todos esos callouts con su estado (abierta /
# reconciliada), para que las contradicciones abiertas sean auditables y no se
# pierdan. Es el "buzón de reconciliación". Sin jq, sin node.
#
# Estado: se infiere del cuerpo del callout — "reconciliada" si alguna línea del
# bloque lo dice; "abierta" en caso contrario (default).
#
# Uso:
#   check-contradictions.sh            -> lista agrupada + resumen
#   check-contradictions.sh --quiet    -> solo el resumen (total / abiertas)
# Salida: 0 siempre (auditoría).
set -uo pipefail

ROOT="${CLAUDE_PROJECT_DIR:-$PWD}"
cd "$ROOT" 2>/dev/null || exit 0
QUIET=0; [ "${1:-}" = "--quiet" ] && QUIET=1

PRUNE='-path ./.git -o -path ./.obsidian -o -path ./.claude -o -path ./.vault-meta -o -path ./node_modules'
PLANTILLAS='./00 Sistema/001_plantillas'

MDS="$(mktemp)"; BRK="$(mktemp)"
eval "find . \\( $PRUNE -o -path '$PLANTILLAS' \\) -prune -o -type f -name '*.md' -print" > "$MDS"
mapfile -t MDARR < "$MDS"

[ "${#MDARR[@]}" -eq 0 ] && { echo "check-contradictions: 0 contradicciones (0 abiertas)."; rm -f "$MDS" "$BRK"; exit 0; }

SUMMARY="$(awk -v out="$BRK" '
  function flush(){ if (pending){ printf "%s\t%s\t%s\t%s\n", pf, pln, pstatus, ptitle > out; total++; if (pstatus=="abierta") open++; pending=0 } }
  FNR==1 { flush(); incb=0; infence=0 }
  {
    l=$0
    # saltar bloques de código (los ejemplos de la convención no son contradicciones reales)
    if (l ~ /^[ \t]*(```|~~~)/) { if (incb){flush();incb=0}; infence=!infence; next }
    if (infence) { if (incb){flush();incb=0}; next }
    if (l ~ /^[ \t]*>[ \t]*\[!contradiction\]/) {
      flush()
      ptitle=l; sub(/^[ \t]*>[ \t]*\[!contradiction\][-+]?[ \t]*/, "", ptitle)
      if (ptitle=="") ptitle="(sin título)"
      pf=FILENAME; sub(/^\.\//,"",pf); pln=FNR
      pstatus="abierta"; pending=1; incb=1; next
    }
    if (incb) {
      if (l ~ /^[ \t]*>/) { if (l ~ /[Rr]econciliad/) pstatus="reconciliada"; next }
      else { flush(); incb=0 }
    }
  }
  END {
    flush()
    printf "check-contradictions: %d contradicción(es) (%d abierta(s)).", total+0, open+0
  }
' "${MDARR[@]}")"

if [ "$QUIET" -eq 0 ] && [ -s "$BRK" ]; then
  echo "Contradicciones registradas ([!contradiction]):"
  sort "$BRK" | awk -F'\t' '{ if($1!=p){print "";print $1;p=$1} printf "  L%-5s [%s] %s\n",$2,$3,$4 }'
  echo
fi
echo "$SUMMARY"
rm -f "$MDS" "$BRK" 2>/dev/null || true
