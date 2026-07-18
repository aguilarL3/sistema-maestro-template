---
type: How-to
title: "Skill | Mantenimiento Sistema — frescura + consistencia"
tags: [skill, ia, claude-code, mantenimiento, frescura, consistencia, llm-as-judge]
origen: "[[Catálogo de Skills]]"
fecha_creacion: 2026-06-26
timestamp: 2026-06-26T00:00:00Z
fecha_actualizacion: 2026-06-26
modelo_objetivo: claude-sonnet-4-6
version_modelo: claude-sonnet-4-6
categoria: Skill
subcategoria: Mantenimiento del Sistema
caso_uso: Auditar frescura (fechas) y consistencia (convenciones + criterio) de la documentación y proponer mejoras
harness: claude-code
tools_usadas: [Bash, Glob, Grep, Read, Task, WebSearch, Write]
scope: vault
domains: [ia, automatizacion]
version: v2.1
estado: 🟦 En pruebas
resource:
---

# Skill | Mantenimiento Sistema — frescura + consistencia

> **TL;DR:** Audita la documentación en dos dimensiones: **frescura** (fechas vencidas) y **consistencia** (drift de convenciones vía heurística + obsolescencia de criterio vía juez LLM). Propone, nunca aplica.

---

## 🎯 Objetivo

La documentación se desactualiza de **dos formas distintas**, y la fecha solo detecta una:

| Forma | Cómo se detecta | Ejemplo real |
|---|---|---|
| **Frescura** | Por fecha (`timestamp` vs hoy) | Un SOP sin tocar hace 120 días |
| **Consistencia** | NO por fecha — por contenido | Una skill "fresca" que apunta a una carpeta que ya no existe |

La v1 solo medía frescura. La **v2 agrega consistencia**, porque un drift de convención (como las skills Cerebro apuntando a `05 Diario/` tras crear `Auditorías/`) pasa invisible a un chequeo de fechas.

- **Input esperado:** Docs en `00 Sistema/`, `04 Knowledge/Conectores/`, `04 Knowledge/Skills/`
- **Output esperado:** `05 Diario/Auditorías/Informe Mantenimiento - YYYY-MM-DD.md`
- **Quién la invoca:** {{OWNER}} vía `/mantenimiento-sistema`

---

## 🧩 Contexto de uso

- **¿Cuándo usarla?** Revisión mensual, o tras un cambio estructural grande (mover carpetas, cambiar convenciones) — ahí el drift de consistencia es más probable.
- **¿Cuándo NO usarla?** Justo después de actualizar todo.
- **Dependencias:** Docs con `timestamp`; el [CHANGELOG del Sistema](<../../00 Sistema/CHANGELOG del Sistema.md>) al día (el Nivel 1 lo cruza para detectar archivos movidos).
- **Flujo:** Revisión mensual → `/mantenimiento-sistema` → informe → resolver en chat → cambios al changelog.

---

## 🔧 Scope y herramientas

| Herramienta | Para qué se usa |
|---|---|
| `Bash` | Correr los checkers deterministas `check-links.sh` y `check-contradictions.sh` (Nivel 0) |
| `Glob` / `Grep` | Listar docs y extraer fechas/referencias |
| `Read` | Leer el doc bajo análisis |
| `Task` | Lanzar el subagente "juez" del Nivel 2 (consistencia de criterio) |
| `WebSearch` | El juez compara contra buenas prácticas actuales |
| `Write` | Crear el informe |

**Carpetas que toca:**
- Lee: `00 Sistema/`, `04 Knowledge/Conectores/`, `04 Knowledge/Skills/`
- Escribe: `05 Diario/Auditorías/Informe Mantenimiento - YYYY-MM-DD.md`
- No toca: ningún doc original (solo propone)

---

## 🏗️ Arquitectura: dos dimensiones, tres niveles

```
DIMENSIÓN 1 — FRESCURA (fechas)
  └─ compara timestamp vs hoy → vencido / por vencer / fresco / sin fecha

DIMENSIÓN 2 — CONSISTENCIA (contenido)
  ├─ NIVEL 0 — Determinista (baratísimo, TODO el vault, vía Bash)
  │     check-links.sh          → enlaces/embeds rotos (real vs planificado)
  │     check-contradictions.sh → callouts [!contradiction] abiertos
  │     → refs rotas y contradicciones SIN que el LLM las adivine (~0.6s)
  │
  ├─ NIVEL 1 — Heurístico (barato, TODOS los docs)
  │     ¿rutas existen? ¿convenciones vigentes?
  │     ¿apunta a archivos movidos? (cruza CHANGELOG del Sistema)
  │     → caza los DRIFT de convención (lo que la v1 no veía)
  │
  └─ NIVEL 2 — Juez (caro, solo lo SOSPECHOSO / alto valor)
        subagente que compara contra buenas prácticas actuales (WebSearch)
        y busca contradicciones con el resto del vault
        → caza OBSOLESCENCIA DE CRITERIO
        patrón LLM-as-Judge / Agent-as-Judge
```

**Regla de costo (best practice 2026):** heurística barata sobre el 100%, juez caro sobre una muestra/lo sospechoso. Ver [[#📖 Referencias]].

---

## 📝 Instrucciones

Ver archivo ejecutable: `.claude/commands/mantenimiento-sistema.md`

**Pasos:**
1. Fecha de hoy desde runtime (nunca de un archivo).
2. **Frescura:** Glob + Grep de fechas → clasificar por antigüedad.
3. **Consistencia N0 (determinista, Bash):** correr `check-links.sh` y `check-contradictions.sh`; usar su salida como fuente autoritativa de refs rotas y contradicciones (separar rotos reales de planificados).
4. **Consistencia N1 (heurístico, todos):** rutas, convenciones vigentes, archivos movidos (cruzar CHANGELOG) — enfocado en lo que N0 no cubre.
5. **Consistencia N2 (juez, sospechosos):** subagente que compara contra buenas prácticas actuales + busca contradicciones de criterio.
6. **Verificar** cada hallazgo antes de proponerlo (precedente DNS-AID).
7. Generar informe con ambas dimensiones priorizadas.

---

## 🔀 Variables / Argumentos

| Variable | Tipo | Descripción | Ejemplo |
|---|---|---|---|
| `$ARGUMENTS` | string | Umbral / scope / dimensión | `--dias 60` · `--scope Conectores` · `--solo consistencia` |

---

## 🧪 Casos de prueba

| # | Condición | Output esperado | Resultado | Notas |
|---|---|---|---|---|
| 1 | Doc con `timestamp` de +120 días | Aparece como vencido (frescura) | ⬜ N/A | No hay docs tan viejos aún |
| 2 | Todo fresco | Informe "sin vencidos" | ✅ 2026-06-26 | 0 vencidos reportado |
| 3 | Doc sin `timestamp` | "sin fecha" sin abortar | ✅ 2026-06-26 | 29 sin fecha, sin abortar |
| 4 | Hallazgo web no verificable | "no verificado, no incluir" | ⬜ N/A | Sin WebSearch en la prueba |
| 5 | Skill que apunta a carpeta vieja (drift) | Nivel 1 lo marca como drift de convención | ✅ 2026-06-26 | N1 ejecutó el check de convención; 0 drifts (post-fix). Capacidad validada |
| 6 | Doc que contradice a otro | Nivel 2 (juez) lo marca | ✅ 2026-06-26 | N2 corrido sobre SOP Interoperabilidad IA: verificó 11 afirmaciones + cruzó 3 docs por contradicción. Veredicto VIGENTE. Capacidad validada |

---

## 🔄 Iteraciones / Versionado

| Versión | Fecha | Cambio | Motivo | Resultado |
|---|---|---|---|---|
| v1.0 | 2026-06-26 | Versión inicial — solo frescura | Resolver el `date.now()` del SOP Interoperabilidad IA | Baseline |
| v2.0 | 2026-06-26 | Agregada dimensión **consistencia** (heurístico N1 + juez N2) | La v1 no detectaba drift de convención: las skills Cerebro apuntaban a `05 Diario/` tras crear `Auditorías/` y pasó invisible | Cierra el gap "el sistema se mantiene a sí mismo" |
| v2.1 | 2026-07-01 | Agregado **Nivel 0 determinista**: integra `check-links.sh` + `check-contradictions.sh` (Bash) como pre-pass exhaustivo de refs rotas y contradicciones | El N1 pedía al LLM verificar wikilinks a mano (lento, parcial); los checkers lo hacen en ~0.6s sobre todo el vault y liberan al juez para lo que sí requiere criterio | Mecánica barata sobre 100%, LLM solo donde aporta |

---

## 🚫 Limitaciones conocidas

- El Nivel 2 (juez) es un LLM evaluando a otro: hereda sus sesgos. Mitigación 2026: fijar `version_modelo` (ya está en frontmatter) y validación humana del informe (regla "proponer, nunca decidir").
- El juez corre sobre muestra/sospechosos, no sobre todo — puede omitir obsolescencia en docs no marcados.
- Depende de que el [CHANGELOG del Sistema](<../../00 Sistema/CHANGELOG del Sistema.md>) esté al día para detectar archivos movidos.
- `WebSearch` trae calidad variable → el paso de verificación es obligatorio.

---

## 🔗 Skills relacionadas

- [Skill - Revisión Mensual](<Skill - Revisión Mensual.md>) → orquestador que corre esta + Cerebro Audit en paralelo
- [Skill - Cerebro Audit](<Skill - Cerebro Audit.md>) → audita estructura/conexiones; complementa la dimensión consistencia
- Esta skill cubre frescura + consistencia de la **documentación**; Cerebro cubre el **grafo de notas**

---

## 📖 Referencias

**Internas:**
- [Conflicto Semántico - Enlaces y Contradicciones](<../../00 Sistema/Conflicto Semántico - Enlaces y Contradicciones.md>) — el Nivel 0 (checkers) y cómo leer sus salidas
- [Catálogo de Hooks y Locks](<../Automatización/Catálogo de Hooks y Locks.md>) — fichas de `check-links.sh` / `check-contradictions.sh`
- [SOP Interoperabilidad IA](<../../00 Sistema/SOP Interoperabilidad IA.md>) — §8 (mantenimiento y el `date.now()`)
- [SOP Conectores](<../../00 Sistema/SOP Conectores.md>) — §6 (cuándo actualizar un conector)
- [SOP Skills](<../../00 Sistema/SOP Skills.md>) — §13 (flujo hallazgo → resolución → changelog)
- [Tipos de Documentación](<../../00 Sistema/Tipos de Documentación.md>) — convenciones que el Nivel 1 verifica
- [CHANGELOG del Sistema](<../../00 Sistema/CHANGELOG del Sistema.md>) — fuente para detectar archivos movidos
- [Blueprint de Sistemas](<../../00 Sistema/Blueprint de Sistemas.md>) · [AGENTS](<../../AGENTS.md>)

**Conceptos y fuentes externas (best practices 2026):**
- **LLM-as-Judge** — un modelo evalúa la salida de otro según dimensiones (relevancia, exactitud, consistencia). Base del Nivel 2. Fuente: DeepEval — *LLM-as-a-Judge in 2026* (deepeval.com/guides/guides-llm-as-a-judge)
- **Agent-as-Judge** — el juez es un agente con herramientas que evalúa la trayectoria, no solo el resultado. Fuente: Adaline — *Complete Guide to LLM & AI Agent Evaluation in 2026* (adaline.ai); Confident AI — *LLM Agent Evaluation* (confident-ai.com)
- **Heurística 100% + juez en muestra** — chequeos baratos sobre todo el tráfico, juez caro sobre 5-10%. Fuente: StackPulsar — *LLM Model Drift Detection 2026*
- **Lock judge version** — fijar la versión del modelo-juez para que no derive sola (ya aplicado vía `version_modelo`).
- **Drift de consistencia / obsolescencia de criterio** — ver [Glosario de términos](<../../00 Sistema/Glosario de términos.md>).

---

◀ [Skill - Cerebro Audit](<Skill - Cerebro Audit.md>) | MOC: [Catálogo de Skills](<Catálogo de Skills.md>) | [Skill - Revisión Mensual](<Skill - Revisión Mensual.md>) ▶
