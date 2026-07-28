---
type: Explanation
title: "Plan mode — explorar y planificar antes de tocar nada"
description: "El modo de solo-lectura de Claude Code: el agente investiga y propone un plan, y no edita nada hasta tu aprobación."
tags: [multiagente, plan-mode, claude-code, spec-driven, agentes, tema]
estado: 🌱 Semilla
prioridad: ⏳ Media
responsable: "{{OWNER}}"
id: "EXP-MULTIAGENTE-020"
generated:
  by: human:{{OWNER}}
  at: 2026-07-21T00:00:00Z
fecha_creacion: 2026-07-21
moc_principal: "[[MOC - Agentes]]"
life_areas: [profesional]
domains: [ia]
resource:
---

>[!info] Documentación relacionada
>[Spec-Driven Development](<../Sistemas y Metodologías/Spec-Driven Development.md>) (el flujo que lo enmarca — §7.2) | [SOP Proyectos de Código](<../../00 Sistema/SOP Proyectos de Código.md>) (la regla operativa — §3) | [[Loop TAO-ReAct - el corazón de un agente]] (el ciclo que el plan mode interrumpe) | [[Verificación determinista vs criterio del agente]]

# Plan mode — explorar y planificar antes de tocar nada

Nota atómica sobre el **plan mode** de Claude Code: qué es, cuándo usarlo y cómo se relaciona con el spec.

> **La idea en una frase:** el plan mode es un candado de **solo-lectura** — el agente puede leer, buscar y explorar, pero no puede editar, escribir ni correr comandos que muten nada. Investiga, te presenta un plan, y **recién actúa cuando lo aprobás**.

---

## 1. Qué es

Es un modo del agente donde se separa el **pensar** del **hacer**. Corresponde a las dos primeras fases del [[Loop TAO-ReAct - el corazón de un agente|loop de un agente]] — *Explore → Plan* — con un gate humano al final:

```
Explore   → lee el código y los docs relevantes (solo lectura)
Plan      → propone qué haría, paso a paso
[TU OK]   → recién acá se desbloquea la escritura
Implement → ejecuta el plan aprobado
Commit    → con su verificación en verde
```

Hasta tu aprobación, **no toca nada**. En Claude Code se cicla entre modos con `Shift+Tab` (uno de ellos es el plan mode); podés arrancar una tarea directamente en él.

## 2. Cuándo usarlo

| Situación | Modo |
|---|---|
| Cambio **multi-archivo** o que toca varias partes | **Plan mode** — revisás el plan antes de que empiece |
| Algo **riesgoso** (migraciones, borrados, auth, dinero) | **Plan mode** — el error es caro |
| No estás seguro de *cómo* lo va a encarar | **Plan mode** — ves el approach antes de gastar tokens |
| Fix de **una línea**, obvio | **Directo** — el plan mode sería ceremonia inútil |

**Por qué importa:** es mucho más barato revisar un plan de 10 líneas que revisar 1000 líneas de código ya escrito. El plan mode mueve tu revisión al momento donde corregir cuesta menos — el mismo principio de *decidir antes de tocar nada* que rige el [Discovery](<../Sistemas y Metodologías/Investigación Previa (Discovery).md>) y el spec.

## 3. Cómo se relaciona con el spec

No hay que confundir el plan mode con los artefactos del [Spec-Driven Development](<../Sistemas y Metodologías/Spec-Driven Development.md>):

- Los cuatro artefactos (`constitution` / `spec` / `plan` / `tasks`) son **durables** — viven en el repo y sobreviven a las sesiones.
- El plan mode es **efímero** — es *Specify + Plan en miniatura, dentro de una sesión*, para ejecutar **un ítem** del `tasks.md`.

Encajan así: para una **feature grande**, primero se escribe el `spec.md` (entrevista → spec), y después una **sesión fresca** la ejecuta tarea por tarea, usando plan mode en cada cambio no trivial. El spec es el plan *del producto* (durable); el plan mode es el plan *de este cambio* (del momento).

## 4. Cómo se conecta

- Es el paso *Plan* del [[Loop TAO-ReAct - el corazón de un agente|Loop TAO/ReAct]], vuelto explícito y gateado.
- La regla operativa (plan mode para multi-archivo, directo para one-liners) vive en [SOP Proyectos de Código](<../../00 Sistema/SOP Proyectos de Código.md>) §3.
- Cierra el loop con una [[Verificación determinista vs criterio del agente|verificación ejecutable]]: un plan aprobado se implementa y se valida con tests, no con "parece que anda".
