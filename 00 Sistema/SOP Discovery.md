---
type: How-to
title: "SOP Discovery — Investigación Previa"
tags: [sop, discovery, investigacion, prior-art]
estado: 🟢 Activo
prioridad: 🔥 Alta
responsable: "{{OWNER}}"
id: "SOP-DISCOVERY-001"
generated:
  by: human:{{OWNER}}
  at: 2026-06-26T00:00:00Z
fecha_creacion: 2026-06-26
resource:
---

>[!info] Documentación relacionada
>[Investigación Previa (Discovery)](<../04 Knowledge/Sistemas y Metodologías/Investigación Previa (Discovery).md>) (estudio a fondo) | [Blueprint de Sistemas](<Blueprint de Sistemas.md>) | [Ciclo de Vida de Capacidades IA](<../04 Knowledge/Sistemas y Metodologías/Ciclo de Vida de Capacidades IA.md>) | [SOP Interoperabilidad IA](<SOP Interoperabilidad IA.md>)

# SOP Discovery — Investigación Previa

## Objetivo

Definir el protocolo **timeboxed** que se ejecuta **antes** de construir cualquier cosa (proyecto, feature, app, skill, conector, negocio): averiguar si ya existe, si está documentado oficialmente, y decidir build / buy / adopt — para no reinventar ni perder tiempo descifrando lo que ya está escrito.

> **Regla de oro:** ninguna construcción arranca sin un Discovery. Es la **Fase 0** del [Ciclo de Vida de Capacidades IA](<../04 Knowledge/Sistemas y Metodologías/Ciclo de Vida de Capacidades IA.md>) y el paso 0 del [Blueprint de Sistemas](<Blueprint de Sistemas.md>).
>
> El *por qué* y los conceptos a fondo (Spike, Prior Art, Build-vs-Buy, parálisis por análisis) están en [Investigación Previa (Discovery)](<../04 Knowledge/Sistemas y Metodologías/Investigación Previa (Discovery).md>). Este SOP es solo el **cómo**.

---

## 1. Cuándo se aplica

Siempre que vayas a **crear algo nuevo**: un proyecto, una skill, un conector, una integración, una funcionalidad, un negocio. Si la respuesta a "¿voy a construir X?" es sí → primero Discovery.

---

## 2. El protocolo (checklist)

Timebox sugerido: **30 min – 3 días** según tamaño. No más.

- [ ] **¿Ya existe?** Buscá producto/solución/repo que haga esto. (Prior Art)
- [ ] **¿Hay documentación oficial?** Si la hay, **leerla primero** (RTFM). Es la base de arranque.
- [ ] **¿La fuente es oficial o no?** Distinguí doc oficial (vendor) de blogs/terceros. Priorizá oficial, pero verificá (puede estar incompleta o atrasada).
- [ ] **¿Hay repos / research disponibles?** GitHub, papers, ejemplos. Sirven de base o de auditoría para mejorar.
- [ ] **¿Hay estándar o convención?** (ej. para conectores: MCP. Ver [SOP Interoperabilidad IA](<SOP Interoperabilidad IA.md>)).
- [ ] **Decisión Build / Buy / Adopt** (ver §3), explícita.
- [ ] **Escribir el brief** (ver §4).

---

## 3. Decisión Build / Buy / Adopt

| Opción | Cuándo |
|---|---|
| **Adopt** | Ya existe oficial/estándar y cubre la necesidad → usarlo (ej. conector MCP oficial) |
| **Buy** | Es commodity (no es tu diferencial) y hay solución que encaja |
| **Build** | Es parte de cómo competís / no hay nada que encaje / querés control total |

Lente recomendada: **costo total a 5 años** (construir incluye mantenerlo para siempre).

---

## 4. Output: el brief de Discovery

Un documento corto (no un tratado) que responde:
1. **Qué se quería construir** y por qué.
2. **Qué ya existe** (con links a docs oficiales / repos / research).
3. **Calidad de las fuentes** (oficial vs terceros).
4. **Decisión:** Build / Buy / Adopt + justificación.
5. **Punto de arranque:** si se construye, sobre qué base; si se adopta, qué leer.

Vive en `05 Diario/Auditorías/` (si es exploratorio) o junto al proyecto/conector que origina.

---

## 5. Anti-parálisis (límite duro)

> El Discovery **termina cuando tenés información suficiente para decidir**, no cuando "estás seguro".

- Timebox fijo. Cuando se acaba, decidís con lo que hay.
- "Suficiente para decidir" > "completo".
- Si dudás entre seguir investigando o empezar a construir un prototipo chico para aprender → construí el prototipo (eso *es* un Spike).

---

## 6. Errores comunes

| Error | Por qué falla | Cómo evitarlo |
|---|---|---|
| Saltar a construir sin Discovery | Reinventás o descifrás lo ya documentado (caso Notion) | Discovery obligatorio antes de Build |
| Discovery sin timebox | Parálisis por análisis | Timebox fijo (§5) |
| Tratar la doc oficial como infalible | Puede estar incompleta/atrasada | Leer + **verificar** |
| No registrar la decisión | Se repite el análisis después | Escribir el brief (§4) |
| Reinventar por orgullo | Costo innecesario | Decisión Build/Buy/Adopt explícita (§3) |

---

## 7. Flujo

```
Idea de construir algo (proyecto / skill / conector / negocio)
↓
DISCOVERY (timeboxed)
  ¿ya existe? · ¿doc oficial? · ¿fuente oficial? · ¿repos/research? · ¿estándar?
↓
Decisión Build / Buy / Adopt
↓
Escribir el brief
↓
└─ Adopt/Buy → usar lo existente. Fin.
└─ Build → recién acá arranca el Ciclo de Vida (Build → Test → ...)
```

---

## Referencias
- [Investigación Previa (Discovery)](<../04 Knowledge/Sistemas y Metodologías/Investigación Previa (Discovery).md>) — el estudio a fondo de los conceptos
- [Blueprint de Sistemas](<Blueprint de Sistemas.md>) — Discovery es su paso 0
- [Ciclo de Vida de Capacidades IA](<../04 Knowledge/Sistemas y Metodologías/Ciclo de Vida de Capacidades IA.md>) — Discovery es su Fase 0
- [SOP Interoperabilidad IA](<SOP Interoperabilidad IA.md>) · [Glosario de términos](<Glosario de términos.md>)

## Cómo leer este SOP
Es el **cómo**. Si querés entender el porqué de cada paso, andá a [Investigación Previa (Discovery)](<../04 Knowledge/Sistemas y Metodologías/Investigación Previa (Discovery).md>). Para ejecutar: seguí el checklist (§2), respetá el timebox (§5), escribí el brief (§4).
