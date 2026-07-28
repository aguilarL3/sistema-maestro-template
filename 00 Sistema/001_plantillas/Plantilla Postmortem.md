---
type: Postmortem
title: "Postmortem - [Incidente] (<% tp.date.now(\"YYYY-MM-DD\") %>)"
tags: [postmortem, incidente]
estado: ✅ Completado
prioridad: ⏳ Media
responsable: "{{OWNER}}"
id: "PM-XXX"
fecha_creacion: <% tp.date.now("YYYY-MM-DD") %>
generated:
  by: human:{{OWNER}}
  at: <% tp.date.now("YYYY-MM-DD") %>
resource:
---

>[!info] Documentación relacionada
>[[SOP Documentación]] | [[Runbook relacionado]] | [[CHANGELOG del Sistema]]

> **ID:** PM-XXX
> **Fecha del incidente:** <% tp.date.now("YYYY-MM-DD") %>
> **Duración / impacto:** [cuánto duró y a qué afectó]

---

# Postmortem - [Incidente] (<% tp.date.now("YYYY-MM-DD") %>)

> **Sin culpa (blameless):** el foco es el sistema y el aprendizaje, no la persona.

## 1. Resumen
*Qué pasó, en 2-3 frases.*

## 2. Línea de tiempo
| Hora | Evento |
|---|---|
|  |  |

## 3. Causa raíz
*¿Por qué pasó realmente? (no el síntoma, la causa de fondo)*

## 4. Cómo se resolvió
*Qué acciones devolvieron la normalidad.*

## 5. Qué aprendimos
- **Salió bien:**
- **Salió mal:**
- **Tuvimos suerte:**

## 6. Acciones para que no vuelva a pasar
- [ ] Acción 1 (¿crear un [[Runbook]]?)
- [ ] Acción 2

## Referencias
- [[SOP Documentación]]
- [[CHANGELOG del Sistema]]

## Cómo leer este documento
Es un postmortem: registra un incidente ya resuelto para aprender de él. Lo importante son la causa raíz (§3) y las acciones (§6).
