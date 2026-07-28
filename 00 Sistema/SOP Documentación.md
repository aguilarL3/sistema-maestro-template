---
type: SOP
title: "SOP - Documentación"
tags: [SOP, documentacion, sistema, estandar]
estado: 🟢 Activo
prioridad: 🔥 Alta
responsable: "{{OWNER}}"
id: "SOP-002"
generated:
  by: human:{{OWNER}}
  at: 2026-07-09T00:00:00Z
fecha_creacion: 2026-06-28
resource:
---

>[!info] Documentación relacionada
>[Tipos de Documentación](<Tipos de Documentación.md>) (qué tipo crear) | [Catálogo de Tipos de Documentación](<../04 Knowledge/Sistemas y Metodologías/Catálogo de Tipos de Documentación.md>) (estudio profundo) | [SOP Maestro](<SOP Maestro.md>) | [Blueprint de Sistemas](<Blueprint de Sistemas.md>) | [Glosario de términos](<Glosario de términos.md>)

> **ID:** SOP-002
> **Fecha:** 2026-06-28
> **Estado:** 🟢 Activo
> **Responsable:** {{OWNER}}

---

# SOP - Documentación

## 1. Objetivo
Definir **el estándar único de cómo se documenta** en el Sistema Maestro: frontmatter, naming, `id`, estilo y ciclo de vida. Resuelve el problema de que hoy esas reglas están dispersas e inconsistentes entre documentos.

Este SOP responde a la pregunta operativa: *"voy a crear o tocar un documento — ¿qué frontmatter le pongo, cómo lo nombro, qué estilo sigo, cuándo lo reviso?"*.

> **Qué NO cubre este SOP:** *qué tipo* de documento crear (eso lo decide [Tipos de Documentación](<Tipos de Documentación.md>)) ni *qué capas* construir (eso lo decide [Blueprint de Sistemas](<Blueprint de Sistemas.md>)). Este SOP cubre el *cómo escribir* cualquier documento, sea del tipo que sea.

## 2. Requisitos previos
- [ ] Saber qué **tipo** de documento vas a crear → consultá [Tipos de Documentación](<Tipos de Documentación.md>) (§3 guía de decisión).
- [ ] Verificar que el documento **no exista ya** (no duplicar; si existe, enlazar o extender).
- [ ] Tener clara la **intención del lector** (aprender / hacer / consultar / entender / decidir / rastrear).

---

## 3. Flujo de trabajo

### Paso 1 — Decidir tipo y ubicación
1. Elegí el **tipo** ([Tipos de Documentación](<Tipos de Documentación.md>)) → determina el prefijo de `id` y la plantilla.
2. Elegí la **carpeta** según la arquitectura de 8 capas ([SOP Maestro](<SOP Maestro.md>) §5).

### Paso 2 — Crear desde la plantilla
Partí siempre de `00 Sistema/001_plantillas/`. No escribas el andamio a mano.

### Paso 3 — Completar el frontmatter canónico
Ver §4. Cuatro campos son **obligatorios** en todo documento.

### Paso 4 — Nombrar el archivo
Ver §5 (convención de naming por tipo).

### Paso 5 — Escribir el cuerpo con el estilo del sistema
Ver §6 (callout de relacionadas, secciones, "Cómo leer", Referencias).

### Paso 6 — Conectar
Enlazá `[[...]]` con su MOC, documentos relacionados y, si aplica, su proyecto o fuente. **Conectar antes que clasificar.**

### Paso 7 — Cerrar
Pasá la **checklist de cierre** (§8) antes de dar el documento por hecho.

---

## 4. Frontmatter canónico

### 4.1 Campos OBLIGATORIOS (todo documento)

```yaml
---
type: SOP                        # clave OKF; uno de la enum (ver 4.3)
title: "SOP - Documentación"     # OKF; = el H1 del cuerpo (ver §5)
estado: 🟢 Activo                # estado de vida (ver 4.4)
generated:                       # OKF v0.2; quién generó/editó y cuándo (ver contrato de fechas)
  by: human:{{OWNER}}            # actor (ver 4.7); un agente pone process:<id>
  at: 2026-06-28T00:00:00Z       # datetime ISO 8601 — última edición de fondo
id: "SOP-002"                    # prefijo por tipo + número (ver §7)
---
```

> **Vocabulario OKF:** `type`, `generated` (v0.2, `{by, at}`), `title` (= H1) y `description`/`resource` (§4.2) son las claves del estándar [Open Knowledge Format](<../04 Knowledge/Sistemas y Metodologías/Open Knowledge Format (OKF).md>). El enforcement duro es sobre `type`/`estado`/`generated`/`id`; `title` es **warn-only** (como `description`). `generated.at` es la fecha de última edición; `generated.by` el actor (§4.7).

### 4.2 Campos OPCIONALES (según el tipo y el contexto)

```yaml
description: "Resumen de UNA oración del propósito de la nota."  # OKF; fuente de los index.md y la búsqueda
resource: https://...           # OKF; URI del asset externo que la nota documenta (solo si existe: workspace, video, dashboard). Al tocar.
tags: [sop, documentacion]      # minúsculas, SIN #, formato lista [a, b]
prioridad: 🔥 Alta              # 🔥 Alta / ⏳ Media / 💤 Baja
responsable: "{{OWNER}}"
fecha_creacion: 2026-07-03      # YYYY-MM-DD — el día que nació la nota (no cambia)
ultima_auditoria_ia: 2026-06-25 # YYYY-MM-DD — solo en MOCs, cuándo la IA los auditó
# Campos transversales (notas de Knowledge):
life_areas: [profesional]
domains: [comunicacion]
goals: []
habits: []
projects: []
sources: []
```

> **Regla de `tags`:** siempre lista en línea `[a, b, c]`, en **minúsculas y SIN `#`**. El `#` dentro del YAML sin comillas rompe el parseo. (Hoy hay 3 formatos distintos en el vault — este es el único válido de ahora en más.)

> **Contrato de fechas:** una nota lleva **`fecha_creacion`** (día de nacimiento, fijo, `YYYY-MM-DD`) + **`generated.at`** (OKF v0.2; datetime ISO 8601 `YYYY-MM-DDT00:00:00Z`, cambia con cada edición de fondo, §9), acompañada de **`generated.by`** (el actor que la generó/editó, §4.7). `ultima_auditoria_ia` es un campo **opcional** exclusivo de MOCs (marca la última auditoría de IA, evento distinto de una edición). Solo `generated` es obligatorio/enforced (§4.1); `fecha_creacion` se agrega **al tocar**. Las daily notes conservan `fecha` (= el día que cubren, no "creación").

> **§4.7 · Convención de actor (OKF v0.2):** el `by` (en `generated` y `verified`) identifica **quién** con uno de tres formatos: **`human:<id>`** (una persona, ej. `human:{{OWNER}}`), **`process:<id>`** (un agente/automatización, ej. `process:claude-code`, `process:verifier`), o **`<producer>/<version>`** (una herramienta versionada). Una nota escrita a mano por el dueño lleva `by: human:{{OWNER}}`; una escrita por un agente refleja su generador real.

> **Campos opt-in de OKF v0.2:** `verified` (lista de eventos `{by, at}` de verificación) y `stale_after` (`YYYY-MM-DD`, fecha absoluta de caducidad). Ambos opcionales — se agregan al verificar / al definir una caducidad.

### 4.6 Orden canónico de las claves (secuencia)
Aunque cada tipo tiene campos propios, las claves del frontmatter van **siempre en esta secuencia** (las que existan; las ausentes se saltan):

```
type · title · tags · description · estado · prioridad · responsable · id
· fecha_creacion · generated · ultima_auditoria_ia · verified · stale_after · resource
· <campos propios del tipo, en su orden>
· life_areas · domains · goals · habits · projects · sources
```

> Las plantillas de `001_plantillas/` ya emiten este orden. Al crear o tocar un doc, mantené la secuencia — da consistencia visual y hace el frontmatter predecible entre tipos distintos.

### 4.3 Valores válidos de `type`
Usá el valor **más específico** disponible:

`Tutorial · How-to · SOP · Runbook · Reference · Explanation · ADR · Changelog · Postmortem · Checklist · Indice · Plantilla · Policy · Attested Computation`

> **`Attested Computation` (OKF v0.2):** tipo para una nota que *es* una computación versionada y verificable (una query, un script, un cálculo). Suma campos propios: `runtime`, `parameters`, `computation` (path al archivo ejecutable), `executor` y `attester`, más un heading de cuerpo `# Computation`. Opt-in.

> Un SOP usa `type: SOP` (no `How-to`); un how-to que no es un SOP formal usa `How-to`. Un runbook usa `Runbook`, no `SOP`.

### 4.4 Valores válidos de `estado`
`🟢 Activo · 🧭 Planificación · 🚧 En progreso · ✅ Completado · 📦 Archivado`

### 4.5 Qué NO lleva frontmatter (por regla)
Igual que [Tipos de Documentación](<Tipos de Documentación.md>) §6: apuntes de curso, proyectos, entradas de diario, `CLAUDE.md`, `AGENTS.md`, `llms.txt` y `.claude/commands/` **no** llevan `type` ni este frontmatter; se rigen por su propia convención. Los **`index.md`** de carpeta tampoco: son artefactos generados de listado puro (sin frontmatter, salvo `okf_version: "0.1"` en el raíz); el verifier los exime.

---

## 5. Naming de archivos

| Tipo | Patrón | Ejemplo |
|---|---|---|
| SOP | `SOP <Nombre>` | `SOP Documentación` |
| Runbook | `Runbook - <Fallo>` | `Runbook - Git push falla SSL` |
| Reference | `<Nombre>` o `<Tema> - <Subtema>` | `Glosario de términos` |
| Explanation | `<Concepto>` | `Filosofía del Sistema` |
| MOC / Índice | `MOC - <Tema>` | `MOC - Carrera` |
| ADR / Decisión | `Decisión - <Tema>` | `Decisión - Vault a disco local` |
| Changelog / Bitácora | `CHANGELOG ...` / `<Proceso> (bitácora)` | `CHANGELOG del Sistema` |
| Postmortem | `Postmortem - <Incidente> (YYYY-MM-DD)` | `Postmortem - Pérdida de sync (2026-06-28)` |
| Checklist | `Checklist - <Proceso>` | `Checklist - Cierre semanal` |
| Plantilla | `Plantilla <Tipo>` | `Plantilla Runbook` |

**Reglas generales:** título descriptivo en español, sin guiones bajos, sin fechas salvo en bitácoras/postmortems, sin números de versión en el nombre (la versión va en el frontmatter o changelog).

---

## 6. Estilo del cuerpo

Todo documento (salvo los excluidos en §4.5) sigue esta estructura mínima:

1. **Callout de relacionadas** (primero, tras el frontmatter):
   ```markdown
   >[!info] Documentación relacionada
   >[Doc A](<Doc A.md>) | [Doc B](<Doc B.md>) | [[Promesa aún no escrita]]
   ```
2. **Título H1** = el tipo + nombre cuando aplica (`# SOP - Documentación`).
3. **Cuerpo** según el tipo (la plantilla ya trae las secciones correctas).
4. **`## Referencias`** al final: links markdown a notas existentes, wikilink a promesas, y enlaces externos.
5. **`## Cómo leer este documento`**: una o dos líneas que orientan al lector (cada plantilla ya lo incluye).

### 6.1 Convención de enlaces

Regla del vault (endurecida por el hook `harden-links`):

- **Conocimiento existente** (la nota ya existe) → **link markdown** `[Título](<ruta relativa.md>)`.
- **Conocimiento aún no escrito** (promesa) → **wikilink** `[[Nombre]]` (resuelve por nombre; se convierte a markdown cuando la nota nace).
- **Frontmatter YAML** (`moc_principal`, etc.) → **siempre wikilink** — ni Obsidian ni Dataview reconocen links markdown dentro del YAML.
- **Índices `index.md`** → siempre markdown (artefacto generado).
- **Embeds** `![[...]]` → intactos (no se convierten).

---

## 7. Esquema de `id`

**Formato:** `PREFIJO-NNN` (número de 3 dígitos, secuencial por prefijo).

| Tipo | Prefijo | | Tipo | Prefijo |
|---|---|---|---|---|
| Tutorial | `TUT` | | ADR / Decisión | `ADR` |
| How-to | `HOW` | | Changelog / Bitácora | `LOG` |
| SOP | `SOP` | | MOC / Índice | `MOC` |
| Runbook | `RUN` | | Postmortem | `PM` |
| Reference | `REF` | | Checklist | `CHK` |
| Explanation | `EXP` | | Plantilla | `TPL` |
| Policy | `POL` | | | |

**Reglas:**
- El `id` es **estable**: no cambia aunque renombres el archivo. Por eso permite referenciar de forma confiable.
- **No es retroactivo.** Los documentos viejos reciben `id` cuando se crean o se tocan (igual criterio que `type` en [Tipos de Documentación](<Tipos de Documentación.md>) §4).
- La numeración se lleva en el **Registro de IDs** (§7.1).

### 7.1 Registro de IDs (fuente de verdad)
Asignados hasta hoy (2026-07-09):

| ID | Documento |
|---|---|
| `SOP-001` | [SOP Maestro](<SOP Maestro.md>) |
| `SOP-002` | [[SOP Documentación]] |
| `REF-001` | [Tipos de Documentación](<Tipos de Documentación.md>) *(antes `REF-DOCTYPES-001`, normalizar al tocar)* |
| `EXP-001` | [Catálogo de Tipos de Documentación](<../04 Knowledge/Sistemas y Metodologías/Catálogo de Tipos de Documentación.md>) |
| `TPL-001` | [[Plantilla Runbook]] |
| `TPL-002` | [[Plantilla Postmortem]] |
| `TPL-003` | [[Plantilla Checklist]] |
| `HOW-001` | [Conflicto Semántico - Enlaces y Contradicciones](<Conflicto Semántico - Enlaces y Contradicciones.md>) |
| `HOW-002` | [Centinelas de Edición](<Centinelas de Edición.md>) |
| `HOW-004` | Guía - Graphify en el vault |
| `EXP-MULTIAGENTE-002` | Contexto persistente entre agentes (Agent Diary) |
| `EXP-MULTIAGENTE-003` | Conflicto semántico entre agentes |
| `EXP-MULTIAGENTE-004` | Propiedad del contenido (centinelas) |
| `EXP-MULTIAGENTE-005` | Verificación determinista vs criterio del agente |
| `EXP-MULTIAGENTE-006` | Verifier pre-commit (self-review) |
| `EXP-MULTIAGENTE-007` | Anatomía de los hooks del vault |
| `EXP-MULTIAGENTE-008` | Ruteo por intención y backup de sesión |
| `EXP-MULTIAGENTE-009` | Patrón Orquestador vs Patrón Asesor |
| `EXP-MULTIAGENTE-010` | Cómo crear agentes - guía y mejores prácticas |
| `EXP-MULTIAGENTE-011` | Qué se carga al abrir el vault con otro agente |
| `EXP-MULTIAGENTE-012` | Chat, harness y modelo - el mapa de herramientas de IA |
| `EXP-MULTIAGENTE-013` | Cómo construir un harness - Claude Agent SDK y LangGraph |
| `EXP-MULTIAGENTE-014` | Construir el cerebro - modelo, fine-tuning, RAG y ML clásico |
| `EXP-MULTIAGENTE-015` | Graphify el vault - de wikilinks a Graph RAG |
| `REF-ROADMAP-001` | [Roadmap del Sistema](<../01 Index/Roadmap del Sistema.md>) |
| `SOP-003` | [SOP Notas Atómicas](<SOP Notas Atómicas.md>) |
| `SOP-004` | [SOP Diario](<SOP Diario.md>) |
| `HOW-003` | [SOP Evergreen Notes](<SOP Evergreen Notes.md>) *(puntero; contenido fusionado en SOP-003)* |
| `MOC-002` | [[MOC - Aprendizaje]] |
| `MOC-003` | [[MOC - Automatizacion IA]] |
| `MOC-004` | [[MOC - BI Analytics]] |
| `MOC-005` | [MOC - Carrera](<../02 MOCs/MOC - Carrera.md>) |
| `MOC-006` | [[MOC - Decisiones]] |
| `MOC-007` | [[MOC - Finanzas]] |
| `MOC-008` | MOC - IA con Claude |
| `MOC-009` | MOC - Master Learning System |
| `MOC-010` | [[MOC - n8n]] |
| `MOC-011` | [[MOC - Negocio]] |
| `MOC-012` | [[MOC - Personal]] |
| `MOC-013` | [[MOC - Prompt Engineering]] |
| `MOC-014` | [[MOC - Relaciones]] |
| `MOC-015` | [[MOC - Salud]] |
| `EXP-002` | [Filosofía del Sistema](<Filosofía del Sistema.md>) |
| `EXP-003` | [Investigación y auditoría de marcos](<../04 Knowledge/Investigación del Sistema/Investigación y auditoría de marcos.md>) |
| `EXP-004` | [Principios](<../01 Index/Principios.md>) |
| `EXP-005` | [Valores](<../01 Index/Valores.md>) |
| `EXP-006` | [Vision](<../01 Index/Vision.md>) |
| `EXP-008` | [Career OS](<../04 Knowledge/Sistemas y Metodologías/Career OS.md>) |
| `EXP-009` | [CE-RE-BRO](<../04 Knowledge/Sistemas y Metodologías/CE-RE-BRO.md>) |
| `EXP-010` | [Cerebro Digital](<../04 Knowledge/Sistemas y Metodologías/Cerebro Digital.md>) |
| `EXP-011` | [Evergreen Notes](<../04 Knowledge/Sistemas y Metodologías/Evergreen Notes.md>) |
| `EXP-012` | [GTD](<../04 Knowledge/Sistemas y Metodologías/GTD.md>) |
| `EXP-013` | [Investigación Previa (Discovery)](<../04 Knowledge/Sistemas y Metodologías/Investigación Previa (Discovery).md>) |
| `EXP-014` | [LLM Wiki](<../04 Knowledge/Sistemas y Metodologías/LLM Wiki.md>) |
| `EXP-015` | [MOC](<../04 Knowledge/Sistemas y Metodologías/MOC.md>) |
| `EXP-016` | [PARA](<../04 Knowledge/Sistemas y Metodologías/PARA.md>) |
| `EXP-017` | [Yo SA](<../04 Knowledge/Sistemas y Metodologías/Yo SA.md>) |
| `EXP-018` | [Zettelkasten](<../04 Knowledge/Sistemas y Metodologías/Zettelkasten.md>) |
| `EXP-019` | [[IA Generativa]] |
| `LOG-001` | [CHANGELOG del Sistema](<CHANGELOG del Sistema.md>) |
| `MOC-016` | [MOC - Investigación del Sistema](<../02 MOCs/MOC - Investigación del Sistema.md>) |
| `MOC-017` | [Index Global](<../01 Index/Index Global.md>) |
| `MOC-018` | [Mapa Personal](<../01 Index/Mapa Personal.md>) |
| `REF-003` | [Objetivos](<../01 Index/Objetivos.md>) |
| `REF-004` | [Notion - Arquitectura](<../04 Knowledge/Conectores/Notion - Arquitectura.md>) |
| `REF-005` | [Ciclo de Vida de Capacidades IA](<../04 Knowledge/Sistemas y Metodologías/Ciclo de Vida de Capacidades IA.md>) |
| `SOP-005` | [SOP Cronogramas de Estudio](<SOP Cronogramas de Estudio.md>) |
| `SOP-006` | [SOP Decisiones](<SOP Decisiones.md>) |
| `SOP-007` | [SOP IA](<SOP IA.md>) |
| `SOP-008` | [SOP Index](<SOP Index.md>) |
| `SOP-009` | [SOP MOCs](<SOP MOCs.md>) |
| `SOP-010` | [SOP Proyectos](<SOP Proyectos.md>) |
| `SOP-011` | [SOP Revisiones](<SOP Revisiones.md>) |
| `SOP-012` | [SOP Áreas](<SOP Áreas.md>) |
| `BP-SISTEMAS-001` | [Blueprint de Sistemas](<Blueprint de Sistemas.md>) |
| `EXP-MULTIAGENTE-001` | [Orquestación Multi-Agente Abierta](<Orquestación Multi-Agente Abierta.md>) |
| `REF-HOOKS-CAT-001` | [Catálogo de Hooks y Locks](<../04 Knowledge/Automatización/Catálogo de Hooks y Locks.md>) |
| `SOP-CAREER-001` | [SOP Career OS](<SOP Career OS.md>) |
| `SOP-COMPARTIR-ARCHIVOS-001` | [SOP Compartir Archivos](<SOP Compartir Archivos.md>) |
| `SOP-CONECT-001` | [SOP Conectores](<SOP Conectores.md>) |
| `SOP-COURSES-001` | [SOP Cursos y Apuntes](<SOP Cursos y Apuntes.md>) |
| `SOP-DISCOVERY-001` | [SOP Discovery](<SOP Discovery.md>) |
| `SOP-GIT-001` | [SOP Git y Flujo de Trabajo](<SOP Git y Flujo de Trabajo.md>) |
| `SOP-HOOKS-001` | [SOP Hooks y Automatización](<SOP Hooks y Automatización.md>) |
| `SOP-IA-APRENDIZAJE-001` | [SOP Aprendizaje con IA](<SOP Aprendizaje con IA.md>) |
| `SOP-INTEROP-001` | [SOP Interoperabilidad IA](<SOP Interoperabilidad IA.md>) |
| `SOP-MASTER-STUDY-001` | [SOP Sistema de Estudio](<SOP Sistema de Estudio.md>) |
| `SOP-PROMPTS-001` | [SOP Prompts](<SOP Prompts.md>) |
| `SOP-SKILLS-001` | [SOP Skills](<SOP Skills.md>) |
| `TUT-002` | [00 Inicio Rapido](<../00 Inicio Rapido.md>) (tutorial único de entrada) |
| `EXP-SEGURIDAD-001` | [Prompt Injection y la Tríada Letal](<../04 Knowledge/Temas/Prompt Injection y la Tríada Letal.md>) |
| `EXP-SEGURIDAD-002` | [Cadena de Suministro y Código de Terceros](<../04 Knowledge/Temas/Cadena de Suministro y Código de Terceros.md>) |
| `SOP-SEGURIDAD-001` | [SOP de Seguridad](<SOP de Seguridad.md>) |
| `MOC-SEGURIDAD-001` | [MOC - Seguridad](<../02 MOCs/MOC - Seguridad.md>) |
| `HOW-SEGURIDAD-BASELINE-001` | [[Baseline de Seguridad]] |
| `MOC-AGENTES-001` | [[MOC - Agentes]] |
| `SOP-013` | [SOP Proyectos de Código](<SOP Proyectos de Código.md>) |
| `EXP-020` | RAG - darle tu contenido al modelo sin re-entrenarlo |
| `EXP-021` | Fine-tuning - cambiar el cómo, no el qué |
| `EXP-MULTIAGENTE-016` | Loop TAO-ReAct - el corazón de un agente |
| `EXP-MULTIAGENTE-017` | Anatomía de un harness - los 9 componentes |
| `EXP-MULTIAGENTE-018` | Cómo portar la automatización a otro harness |
| `EXP-MULTIAGENTE-019` | Skill, hook y subagente - definir la pieza no es usarla |
| `SOP-014` | [SOP Multi-Agente](<SOP Multi-Agente.md>) |

> Cuando crees un documento, agregá su fila acá y usá el siguiente número libre de su prefijo. Para altas masivas, el `id` del frontmatter es la verdad; este registro puede quedar detrás (normalizar al tocar).
>
> **Próximo libre por prefijo (2026-07-11):** SOP-015 · EXP-022 · EXP-MULTIAGENTE-020 · REF-008 · MOC-022 · LOG-005 · HOW-005 · TUT-003 · ADR-002 · RUN/CHK/PM/POL-001.

---

## 8. Checklist de cierre
Antes de dar un documento por terminado:

- [ ] Frontmatter con los 4 campos obligatorios (`type`, `estado`, `generated`, `id`).
- [ ] `tags` en formato `[a, b]`, minúsculas, sin `#`.
- [ ] `id` registrado en §7.1 con número libre.
- [ ] Nombre de archivo según §5.
- [ ] Callout de relacionadas al inicio.
- [ ] Sección `## Referencias` y `## Cómo leer este documento`.
- [ ] Al menos un enlace `[[...]]` entrante o saliente (no queda huérfano).
- [ ] No duplica un documento existente.

---

## 9. Ciclo de vida
- **`generated.at`** se actualiza cada vez que tocás el contenido de fondo (no por cambios menores de formato); **`generated.by`** refleja quién lo hizo (§4.7).
- Un documento sin tocar en su ciclo correspondiente ([SOP Revisiones](<SOP Revisiones.md>)) se marca para revisión.
- Cuando un documento deja de ser válido: `estado: 📦 Archivado` y se mueve a `99 Archivo`. **Nunca se borra** sin propuesta previa (regla del vault).
- Los tipos nuevos definidos por este SOP tienen plantilla: [[Plantilla Runbook]], [[Plantilla Postmortem]], [[Plantilla Checklist]].

---

## 10. Troubleshooting
- **El frontmatter no se parsea / Obsidian lo ignora:** revisá que `tags` no tenga `#` sin comillas. Usá `[a, b]`.
- **Dos documentos con el mismo `id`:** el Registro (§7.1) es la fuente de verdad; renombrá el más nuevo al siguiente número libre.
- **No sé si es SOP o Runbook:** ¿describe la operación normal? → SOP. ¿describe qué hacer cuando algo falla? → Runbook.
- **No sé si es Reference o Explanation:** ¿se consulta un dato puntual? → Reference. ¿se lee para entender el porqué? → Explanation.

## Referencias
- [Tipos de Documentación](<Tipos de Documentación.md>)
- [Catálogo de Tipos de Documentación](<../04 Knowledge/Sistemas y Metodologías/Catálogo de Tipos de Documentación.md>)
- [Blueprint de Sistemas](<Blueprint de Sistemas.md>)
- [SOP Maestro](<SOP Maestro.md>)
- [SOP Revisiones](<SOP Revisiones.md>)
- [Glosario de términos](<Glosario de términos.md>)
- Diátaxis — https://diataxis.fr

## Cómo leer este documento
Es el estándar normativo de documentación. Cuando vayas a crear o tocar un documento, seguí el flujo (§3) y cerrá con la checklist (§8). El resto de secciones se consultan puntualmente.
