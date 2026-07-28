#!/usr/bin/env bash
# UserPromptSubmit — ruteo por intención (OPT-IN, apagado por defecto).
#
# Cada vez que el usuario escribe un mensaje, mira palabras clave y, si detecta
# cierta intención, le inyecta al agente una PISTA de ruteo (a qué capa/plantilla/
# SOP del vault va eso). Sin LLM, solo regex. Es un recordatorio de las propias
# reglas del vault para que el agente no ponga las cosas en el lugar equivocado.
# Falsos positivos cuestan ~0: el agente ignora la pista que no aplica.
#
# OPT-IN: SOLO actúa si existe .vault-meta/route-intent.enabled. Sin ese archivo
# no hace nada (default apagado, para no meter ruido en sesiones de build).
#   Encender:  touch .vault-meta/route-intent.enabled
#   Apagar:    rm    .vault-meta/route-intent.enabled
#
# Adaptado de obsidian-mind (classify-message.ts) a shell puro (sin node, sin jq).
# El campo `prompt` se extrae con python (parseo JSON robusto; la clave literal
# "prompt" del payload envenenaría un match sobre el texto crudo). Como el router
# es opt-in, python solo se invoca cuando está encendido. Match por keywords sobre
# el texto del prompt; falsos positivos cuestan ~0 (el agente ignora la pista).
# Emite el envelope hookSpecificOutput.additionalContext (UserPromptSubmit).
# FAIL-OPEN: cualquier problema → exit 0 (nunca frena el prompt).
set -uo pipefail

ROOT="${CLAUDE_PROJECT_DIR:-$PWD}"
cd "$ROOT" 2>/dev/null || exit 0
[ -f .vault-meta/route-intent.enabled ] || exit 0   # opt-in: sin flag, no hace nada

PY="$(command -v python 2>/dev/null || command -v python3 2>/dev/null || true)"
[ -z "$PY" ] && exit 0   # sin python → fail-open (router inactivo)

INPUT="$(cat)"
PROMPT="$(printf '%s' "$INPUT" | "$PY" -c 'import sys,json
try:
    print(json.load(sys.stdin).get("prompt") or "")
except Exception:
    pass')"
[ -z "$PROMPT" ] && exit 0
LOWER="$(printf '%s' "$PROMPT" | tr 'A-Z' 'a-z')"

hints=""
h() { hints="${hints}\\n- $1"; }
m() { printf '%s' "$LOWER" | grep -Eq "$1"; }

m 'decid|decisi|optamos|elegimos|vamos con'                 && h "DECISIÓN → registrala con Plantilla Decisiones (en el proyecto o 00 Sistema)."
m 'apunte|clase|curso|leccion|lecci|modulo'                 && h "APUNTE de curso → 04 Knowledge/Cursos/{Curso}/ (Plantilla Apunte Curso o /nota-estudio)."
m 'prompt'                                                  && h "PROMPT reutilizable → 04 Knowledge/Prompts/ (SOP Prompts, versionar v1.0/v2.0)."
m 'proyecto|iniciativa'                                     && h "PROYECTO con inicio/fin → 03 Proyectos (Plantilla Proyecto)."
m 'concepto|nota atom|idea atom|nota nueva'                 && h "NOTA atómica (una idea) → 04 Knowledge/Temas; enlazá al MOC del tema."
m 'moc|mapa de contenido'                                   && h "MOC = puerta temática → 02 MOCs (Plantilla MOC), no una carpeta."
m ' sop|regla|protocolo|convenci|politica'                  && h "REGLA/SOP → 00 Sistema; si es ley base, sincronizá AGENTS.md ↔ CLAUDE.md."
m 'captur|fuente cruda|06 raw| raw |pegar|guarda esto'      && h "CAPTURA/fuente cruda → 06 Raw (sin procesar todavía)."
m 'auditor|revisi|mantenimiento|duplicad|hu.rfan|ce-re-bro' && h "AUDITORÍA/revisión → skills Cerebro (/cerebro-*), /mantenimiento-sistema o /revision-mensual."

[ -z "$hints" ] && exit 0

CTX="Pistas de ruteo del vault (accioná solo si el mensaje trae ese contenido; ignorá si no):${hints}\\nUsá plantillas, [[wikilinks]] y respetá CLAUDE.md/AGENTS.md y la Matriz Definitiva."
printf '{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"%s"}}\n' "$CTX"
exit 0
