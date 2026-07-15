---
tipo_doc: Reference
aliases:
  - Bitácora de Agentes
tags: [multiagente, bitacora, agentes]
estado: 🟢 Activo
prioridad: ⏳ Media
responsable: "{{OWNER}}"
id: "REF-BITACORA-AGENTES-001"
ultima_revision: 2026-07-02
fecha_creacion: 2026-07-01
---

>[!info] Documentación relacionada
>[[Orquestación Multi-Agente Abierta]] (§12.3 patrón Agent Diary) | [[SOP Interoperabilidad IA]] (capa Estado)

# Bitácora de Agentes

Registro de **handoff entre agentes** (Claude Code, Codex, Antigravity, Hermes…). Cada agente, al cerrar una sesión donde tocó el vault, deja una entrada. Así cualquier agente que entre después arranca con contexto y no se repite trabajo.

Es la **capa Estado** de [[SOP Interoperabilidad IA]] aplicada a multi-agente, y el patrón "Agent Diary" del §12.3 de [[Orquestación Multi-Agente Abierta]].

## Cómo se completa (automático)

No hay que acordarse: el **hook `Stop`** (`.claude/hooks/agent-diary.sh`) detecta si hubo trabajo sobre el vault y le recuerda al agente registrar la entrada antes de terminar.

## Formato de cada entrada

Un archivo por mes: `YYYY-MM.md`. Dentro, una entrada por sesión significativa:

```markdown
## YYYY-MM-DD — <agente, ej. Claude Code>
- Qué se avanzó/creó/editó:
- Qué quedó bloqueado:
- Qué se decidió o cambió:
- Qué debe saber el próximo agente:
```

## Dos reglas de orden (no negociables)

El hook `SessionStart` (`.claude/hooks/session-context.sh`) inyecta al arrancar la **última entrada del archivo** asumiendo que la última físicamente es la más reciente. Para que esa suposición nunca se rompa:

1. **Append al final, siempre.** Cada entrada nueva va **al final del archivo** — la más reciente queda abajo. Nunca insertar arriba ni entre medio. (En jul-2026 se mezclaron append y prepend; el hook terminó inyectando una entrada vieja cuyo "siguiente = Gap B" ya estaba hecho → confusión. Ver esa corrección en `2026-07.md`.)

2. **El "siguiente paso" apunta al Roadmap, no lo congela.** En *"Qué debe saber el próximo agente"*, para el siguiente paso remitir a [[Roadmap del Sistema]] (fuente viva). No escribir *"siguiente = X"* como hecho fijo: esa predicción se pudre cuando X se completa después y el hook la reinyecta como si fuera actual.

> **Señal de frescura (red de seguridad):** aunque el orden se respete, el hook avisa `⚠ Hubo N commit(s) DESPUÉS de este handoff` cuando hubo trabajo commiteado posterior al último toque de la bitácora — indica que el handoff mostrado puede estar desfasado y hay que confirmar contra el Roadmap y el `git log`.

## Controles

- **Desactivar la bitácora:** crear el archivo `.vault-meta/diary.disabled`.
- **Desactivar el auto-commit de agentes:** crear `.vault-meta/autocommit.disabled`.

> *Sesión significativa* = se crearon/editaron archivos del vault, se tocaron sistemas externos, o se crearon/mejoraron SOPs.
