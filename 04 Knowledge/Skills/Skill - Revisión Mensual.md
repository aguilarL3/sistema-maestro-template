---
tags: [skill, ia, claude-code, orquestador, subagentes, mantenimiento, revision]
origen: "[[Catálogo de Skills]]"
fecha_creacion: 2026-06-26
fecha_actualizacion: 2026-06-26
modelo_objetivo: claude-sonnet-4-6
version_modelo: claude-sonnet-4-6
categoria: Skill
subcategoria: Orquestador
caso_uso: Revisión mensual del sistema — orquesta auditoría de conexiones + frescura en un solo informe
harness: claude-code
tools_usadas: [Task, Glob, Grep, Read, Write]
scope: vault
domains: [ia, automatizacion]
version: v1.1
estado: 🟦 En pruebas
tipo_doc: How-to
---

# Skill | Revisión Mensual — el orquestador

> **TL;DR:** Orquestador que lanza dos subagentes en paralelo (conexiones + frescura), cada uno devuelve una síntesis, y consolida todo en UN informe mensual. Sigue el patrón orquestador-worker de Anthropic.

---

## 🎯 Objetivo

Unificar la revisión mensual del sistema en un solo comando y un solo informe, en vez de correr varias skills por separado y juntar los resultados a mano.

- **Input esperado:** Vault completo
- **Output esperado:** `05 Diario/Auditorías/Revisión Mensual - YYYY-MM-DD.md` — un informe consolidado
- **Quién la invoca:** {{OWNER}} vía `/revision-mensual`, una vez al mes

---

## 🧩 Contexto de uso

- **¿Cuándo usarla?** En la revisión mensual (atada al ciclo "Mensual" del [[CLAUDE]] / [[SOP Revisiones]]).
- **¿Cuándo NO usarla?** Para una auditoría puntual de una sola dimensión — ahí usá la skill específica (`/cerebro-ce`, `/mantenimiento-sistema`).
- **Dependencias:** Las skills base (Cerebro Audit, Mantenimiento) y sus convenciones de frontmatter.
- **Flujo donde se integra:** Revisión mensual → `/revision-mensual` → un informe → resolvemos en el chat → cambios al [[CHANGELOG del Sistema]].

---

## 🔧 Scope y herramientas

| Herramienta | Para qué se usa |
|---|---|
| `Task` | Lanzar los 2 subagentes (conexiones, frescura) en paralelo |
| `Glob` / `Grep` / `Read` | Lo usan los subagentes para auditar |
| `Write` | Crear el informe consolidado |

**Carpetas que toca:**
- Lee: todo el vault (vía subagentes)
- Escribe: `05 Diario/Auditorías/Revisión Mensual - YYYY-MM-DD.md`
- No toca: ningún doc original (solo propone)

---

## 🏗️ Arquitectura (patrón orquestador-worker)

Basado en el patrón documentado por Anthropic (multi-agent research system):

```
/revision-mensual  (ORQUESTADOR — este skill)
        │
        ├─► Subagente A — Conexiones
        │     reusa la lógica de Cerebro Audit (CE/RE/BRO)
        │     devuelve SÍNTESIS: huérfanas, links rotos, clusters sin MOC
        │
        └─► Subagente B — Mantenimiento v2
              reusa la lógica de Mantenimiento Sistema v2
              devuelve SÍNTESIS: frescura (vencidos) + consistencia (drift de convención)
        │
        ▼
   Consolida ambas síntesis → UN informe priorizado
```

**Reglas del patrón (Anthropic):**
- Cada subagente trabaja con **contexto aislado** (no se contaminan entre sí).
- Cada subagente devuelve **síntesis, no transcripción** — el orquestador no lee el detalle completo, solo el resumen.
- Los subagentes **solo leen y proponen**. Ninguno aplica cambios.

---

## 📝 Instrucciones

Ver archivo ejecutable: `.claude/commands/revision-mensual.md`

**Qué hace, paso a paso:**
1. Lee la fecha de hoy (runtime).
2. Lanza Subagente A (conexiones) y Subagente B (frescura) en paralelo con `Task`.
3. Recibe la síntesis de cada uno (no el detalle).
4. Consolida en un informe con prioridades cruzadas (ej. un doc huérfano Y vencido = prioridad alta).
5. Escribe el informe en `05 Diario/Auditorías/`.

---

## 🔀 Variables / Argumentos

| Variable | Tipo | Descripción | Ejemplo |
|---|---|---|---|
| `$ARGUMENTS` | string | Acotar dimensiones | `--solo frescura` · `--solo conexiones` |

---

## 🧪 Casos de prueba

| # | Condición | Output esperado | Resultado | Notas |
|---|---|---|---|---|
| 1 | Vault con huérfanas y docs vencidos | Informe consolidado con ambas dimensiones priorizadas | ✅ 2026-06-26 | 2 subagentes paralelos OK; síntesis correctas; informe generado |
| 2 | Vault sano (sin hallazgos) | Informe "sin hallazgos" claro | 🟨 Pendiente | |
| 3 | Un subagente falla | Reporta lo del otro sin abortar | 🟨 Pendiente | |
| 4 | `--solo frescura` | Corre solo el subagente B | 🟨 Pendiente | |

---

## 🔄 Iteraciones / Versionado

| Versión | Fecha | Cambio | Motivo | Resultado |
|---|---|---|---|---|
| v1.0 | 2026-06-26 | Versión inicial | Orquestar Cerebro Audit + Mantenimiento (patrón Anthropic) | Baseline; probado OK (2 corridas) |
| v1.1 | 2026-06-26 | Subagente B sincronizado con Mantenimiento v2 (frescura + consistencia); subagente A excluye `05 Diario/Auditorías/` | Drift detectado en la 2da corrida: B era v1 (solo fechas); A marcaba falsos rotos desde informes de auditoría | Sincronizado |

---

## 🚫 Limitaciones conocidas

- Depende de que las skills base mantengan sus convenciones.
- Si los subagentes devuelven demasiado detalle, el orquestador se satura — la síntesis debe ser breve.
- No aplica cambios (por diseño). La resolución es manual en el chat.

---

## 🔗 Skills relacionadas

- [[Skill - Cerebro Audit]] → la lógica del subagente A (conexiones)
- [[Skill - Mantenimiento Sistema]] → la lógica del subagente B (frescura)
- Esta skill las orquesta; no las reemplaza (siguen sirviendo para auditorías puntuales)

---

## 📖 Referencias

- [[SOP Skills]] — §13 (flujo de auditoría) y arquitectura 2 capas
- [[SOP Interoperabilidad IA]] — capa Capacidad + §8 mantenimiento
- [[SOP Conectores]] — entre lo auditado, la frescura de `Conectores/`
- [[Blueprint de Sistemas]] — el mantenimiento que el checklist exige
- Anthropic — multi-agent research system (orquestador-worker)
- Anthropic — subagents docs (cuándo paralelizar)

---

◀ [[Skill - Mantenimiento Sistema]] | MOC: [[Catálogo de Skills]] | [[Skill Siguiente]] ▶
