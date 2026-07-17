---
type: Runbook
title: "Runbook - [Nombre del Fallo]"
tags: [runbook, ops]
estado: 🟢 Activo
prioridad: ⏳ Media
responsable: "{{OWNER}}"
id: "RUN-XXX"
fecha_creacion: <% tp.date.now("YYYY-MM-DD") %>
timestamp: <% tp.date.now("YYYY-MM-DD") %>
resource:
---

>[!info] Documentación relacionada
>[[SOP Documentación]] | [[nota-relacionada]]

> **ID:** RUN-XXX
> **Aplica cuando:** [síntoma o condición de fallo que dispara este runbook]

---

# Runbook - [Nombre del Fallo]

## 1. Síntoma
*¿Cómo se ve el problema? ¿Qué mensaje de error, comportamiento o alerta lo indica?*

## 2. Causa probable
*La causa más común primero.*

## 3. Diagnóstico
1. **Verificar:**
2. **Verificar:**

## 4. Resolución (paso a paso)
1. **Paso 1:**
2. **Paso 2:**
3. **Paso 3:**

## 5. Verificar que se resolvió
- [ ] Señal de que el sistema volvió a la normalidad

## 6. Si no se resuelve / escalar
*Qué hacer si los pasos anteriores fallan.*

## Referencias
- [[SOP Documentación]]
- [[SOP relacionado]]

## Cómo leer este documento
Es un runbook: se usa **durante un fallo**. Andá directo al síntoma (§1) y seguí la resolución (§4). No hace falta leerlo completo de antemano.
