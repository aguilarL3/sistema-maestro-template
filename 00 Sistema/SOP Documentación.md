---
tipo_doc: SOP
tags: [SOP, documentacion, sistema, estandar]
estado: 🟢 Activo
prioridad: 🔥 Alta
responsable: "{{OWNER}}"
id: "SOP-002"
ultima_revision: 2026-07-09
fecha_creacion: 2026-06-28
---

>[!info] Documentación relacionada
>[[Tipos de Documentación]] (qué tipo crear) | [[Catálogo de Tipos de Documentación]] (estudio profundo) | [[SOP Maestro]] | [[Blueprint de Sistemas]] | [[Glosario de términos]]

> **ID:** SOP-002
> **Fecha:** 2026-06-28
> **Estado:** 🟢 Activo
> **Responsable:** {{OWNER}}

---

# SOP - Documentación

## 1. Objetivo
Definir **el estándar único de cómo se documenta** en el Sistema Maestro: frontmatter, naming, `id`, estilo y ciclo de vida. Resuelve el problema de que hoy esas reglas están dispersas e inconsistentes entre documentos.

Este SOP responde a la pregunta operativa: *"voy a crear o tocar un documento — ¿qué frontmatter le pongo, cómo lo nombro, qué estilo sigo, cuándo lo reviso?"*.

> **Qué NO cubre este SOP:** *qué tipo* de documento crear (eso lo decide [[Tipos de Documentación]]) ni *qué capas* construir (eso lo decide [[Blueprint de Sistemas]]). Este SOP cubre el *cómo escribir* cualquier documento, sea del tipo que sea.

## 2. Requisitos previos
- [ ] Saber qué **tipo** de documento vas a crear → consultá [[Tipos de Documentación]] (§3 guía de decisión).
- [ ] Verificar que el documento **no exista ya** (no duplicar; si existe, enlazar o extender).
- [ ] Tener clara la **intención del lector** (aprender / hacer / consultar / entender / decidir / rastrear).

---

## 3. Flujo de trabajo

### Paso 1 — Decidir tipo y ubicación
1. Elegí el **tipo** ([[Tipos de Documentación]]) → determina el prefijo de `id` y la plantilla.
2. Elegí la **carpeta** según la arquitectura de 8 capas ([[SOP Maestro]] §5).

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
tipo_doc: SOP            # uno de la enum (ver 4.3)
estado: 🟢 Activo        # estado de vida (ver 4.4)
ultima_revision: 2026-06-28   # YYYY-MM-DD
id: "SOP-002"            # prefijo por tipo + número (ver §7)
---
```

### 4.2 Campos OPCIONALES (según el tipo y el contexto)

```yaml
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

> **Contrato de fechas (unificado 2026-07-03):** una nota lleva **`fecha_creacion`** (día de nacimiento, fijo) + **`ultima_revision`** (cambia con cada edición de fondo, §9). `ultima_auditoria_ia` es un campo **opcional** exclusivo de MOCs (marca la última auditoría de IA, evento distinto de una edición: puede subir aunque no cambie el contenido). El nombre de creación es **`fecha_creacion`** — quedan deprecados `fecha_registro` y `fecha` para ese uso. Solo `ultima_revision` es obligatorio/enforced (§4.1); `fecha_creacion` se agrega **al tocar** (no migración retroactiva). Las daily notes conservan `fecha` (= el día que cubren, no "creación").

### 4.6 Orden canónico de las claves (secuencia)
Aunque cada tipo tiene campos propios, las claves del frontmatter van **siempre en esta secuencia** (las que existan; las ausentes se saltan):

```
tipo_doc · tags · estado · prioridad · responsable · id
· fecha_creacion · ultima_revision · ultima_auditoria_ia
· <campos propios del tipo, en su orden>
· life_areas · domains · goals · habits · projects · sources
```

> Las plantillas de `001_plantillas/` ya emiten este orden. Al crear o tocar un doc, mantené la secuencia — da consistencia visual y hace el frontmatter predecible entre tipos distintos.

### 4.3 Valores válidos de `tipo_doc`
Usá el valor **más específico** disponible:

`Tutorial · How-to · SOP · Runbook · Reference · Explanation · ADR · Changelog · Postmortem · Checklist · Indice · Plantilla · Policy`

> Un SOP usa `tipo_doc: SOP` (no `How-to`); un how-to que no es un SOP formal usa `How-to`. Un runbook usa `Runbook`, no `SOP`.

### 4.4 Valores válidos de `estado`
`🟢 Activo · 🧭 Planificación · 🚧 En progreso · ✅ Completado · 📦 Archivado`

### 4.5 Qué NO lleva frontmatter (por regla)
Igual que [[Tipos de Documentación]] §6: apuntes de curso, proyectos, entradas de diario, `CLAUDE.md`, `AGENTS.md`, `llms.txt` y `.claude/commands/` **no** llevan `tipo_doc` ni este frontmatter; se rigen por su propia convención.

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
   >[[Doc A]] | [[Doc B]] | [[Doc C]]
   ```
2. **Título H1** = el tipo + nombre cuando aplica (`# SOP - Documentación`).
3. **Cuerpo** según el tipo (la plantilla ya trae las secciones correctas).
4. **`## Referencias`** al final: `[[...]]` internas y enlaces externos.
5. **`## Cómo leer este documento`**: una o dos líneas que orientan al lector (cada plantilla ya lo incluye).

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
- **No es retroactivo.** Los documentos viejos reciben `id` cuando se crean o se tocan (igual criterio que `tipo_doc` en [[Tipos de Documentación]] §4).
- La numeración se lleva en el **Registro de IDs** (§7.1).

### 7.1 Registro de IDs (fuente de verdad)
Asignados hasta hoy (2026-07-09):

| ID | Documento |
|---|---|
| `SOP-001` | [[SOP Maestro]] |
| `SOP-002` | [[SOP Documentación]] |
| `REF-001` | [[Tipos de Documentación]] *(antes `REF-DOCTYPES-001`, normalizar al tocar)* |
| `EXP-001` | [[Catálogo de Tipos de Documentación]] |
| `TPL-001` | [[Plantilla Runbook]] |
| `TPL-002` | [[Plantilla Postmortem]] |
| `TPL-003` | [[Plantilla Checklist]] |
| `HOW-001` | [[Conflicto Semántico - Enlaces y Contradicciones]] |
| `HOW-002` | [[Centinelas de Edición]] |
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
| `REF-ROADMAP-001` | [[Roadmap del Sistema]] |
| `SOP-003` | [[SOP Notas Atómicas]] |
| `SOP-004` | [[SOP Diario]] |
| `HOW-003` | [[SOP Evergreen Notes]] *(puntero; contenido fusionado en SOP-003)* |
| `MOC-001` | README de `04 Knowledge/Temas` |
| `MOC-002` | [[MOC - Aprendizaje]] |
| `MOC-003` | [[MOC - Automatizacion IA]] |
| `MOC-004` | [[MOC - BI Analytics]] |
| `MOC-005` | [[MOC - Carrera]] |
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
| `EXP-002` | [[Filosofía del Sistema]] |
| `EXP-003` | [[Investigación y auditoría de marcos]] |
| `EXP-004` | [[Principios]] |
| `EXP-005` | [[Valores]] |
| `EXP-006` | [[Vision]] |
| `EXP-008` | [[Career OS]] |
| `EXP-009` | [[CE-RE-BRO]] |
| `EXP-010` | [[Cerebro Digital]] |
| `EXP-011` | [[Evergreen Notes]] |
| `EXP-012` | [[GTD]] |
| `EXP-013` | [[Investigación Previa (Discovery)]] |
| `EXP-014` | [[LLM Wiki]] |
| `EXP-015` | [[MOC]] |
| `EXP-016` | [[PARA]] |
| `EXP-017` | [[Yo SA]] |
| `EXP-018` | [[Zettelkasten]] |
| `EXP-019` | [[IA Generativa]] |
| `LOG-001` | [[CHANGELOG del Sistema]] |
| `MOC-016` | [[MOC - Investigación del Sistema]] |
| `MOC-017` | [[Index Global]] |
| `MOC-018` | [[Mapa Personal]] |
| `MOC-020` | [[04 Knowledge/README]] |
| `MOC-021` | [[04 Knowledge/Sistemas y Metodologías/README]] |
| `REF-003` | [[Objetivos]] |
| `REF-004` | [[Notion - Arquitectura]] |
| `REF-005` | [[Ciclo de Vida de Capacidades IA]] |
| `SOP-005` | [[SOP Cronogramas de Estudio]] |
| `SOP-006` | [[SOP Decisiones]] |
| `SOP-007` | [[SOP IA]] |
| `SOP-008` | [[SOP Index]] |
| `SOP-009` | [[SOP MOCs]] |
| `SOP-010` | [[SOP Proyectos]] |
| `SOP-011` | [[SOP Revisiones]] |
| `SOP-012` | [[SOP Áreas]] |
| `BP-SISTEMAS-001` | [[Blueprint de Sistemas]] |
| `EXP-MULTIAGENTE-001` | [[Orquestación Multi-Agente Abierta]] |
| `REF-HOOKS-CAT-001` | [[Catálogo de Hooks y Locks]] |
| `SOP-CAREER-001` | [[SOP Career OS]] |
| `SOP-COMPARTIR-ARCHIVOS-001` | [[SOP Compartir Archivos]] |
| `SOP-CONECT-001` | [[SOP Conectores]] |
| `SOP-COURSES-001` | [[SOP Cursos y Apuntes]] |
| `SOP-DISCOVERY-001` | [[SOP Discovery]] |
| `SOP-GIT-001` | [[SOP Git y Flujo de Trabajo]] |
| `SOP-HOOKS-001` | [[SOP Hooks y Automatización]] |
| `SOP-IA-APRENDIZAJE-001` | [[SOP Aprendizaje con IA]] |
| `SOP-INTEROP-001` | [[SOP Interoperabilidad IA]] |
| `SOP-MASTER-STUDY-001` | [[SOP Sistema de Estudio]] |
| `SOP-PROMPTS-001` | [[SOP Prompts]] |
| `SOP-SKILLS-001` | [[SOP Skills]] |
| `TUT-002` | [[00 Inicio Rapido]] (tutorial único de entrada) |
| `EXP-SEGURIDAD-001` | [[Prompt Injection y la Tríada Letal]] |
| `EXP-SEGURIDAD-002` | [[Cadena de Suministro y Código de Terceros]] |
| `SOP-SEGURIDAD-001` | [[SOP de Seguridad]] |
| `MOC-SEGURIDAD-001` | [[MOC - Seguridad]] |
| `HOW-SEGURIDAD-BASELINE-001` | [[Baseline de Seguridad]] |
| `MOC-AGENTES-001` | [[MOC - Agentes]] |
| `SOP-013` | [[SOP Proyectos de Código]] |
| `EXP-020` | RAG - darle tu contenido al modelo sin re-entrenarlo |
| `EXP-021` | Fine-tuning - cambiar el cómo, no el qué |
| `EXP-MULTIAGENTE-016` | Loop TAO-ReAct - el corazón de un agente |
| `EXP-MULTIAGENTE-017` | Anatomía de un harness - los 9 componentes |
| `EXP-MULTIAGENTE-018` | Cómo portar la automatización a otro harness |
| `EXP-MULTIAGENTE-019` | Skill, hook y subagente - definir la pieza no es usarla |
| `SOP-014` | [[SOP Multi-Agente]] |

> Cuando crees un documento, agregá su fila acá y usá el siguiente número libre de su prefijo. Para altas masivas, el `id` del frontmatter es la verdad; este registro puede quedar detrás (normalizar al tocar).
>
> **Próximo libre por prefijo (2026-07-11):** SOP-015 · EXP-022 · EXP-MULTIAGENTE-020 · REF-008 · MOC-022 · LOG-005 · HOW-005 · TUT-003 · ADR-002 · RUN/CHK/PM/POL-001.

---

## 8. Checklist de cierre
Antes de dar un documento por terminado:

- [ ] Frontmatter con los 4 campos obligatorios (`tipo_doc`, `estado`, `ultima_revision`, `id`).
- [ ] `tags` en formato `[a, b]`, minúsculas, sin `#`.
- [ ] `id` registrado en §7.1 con número libre.
- [ ] Nombre de archivo según §5.
- [ ] Callout de relacionadas al inicio.
- [ ] Sección `## Referencias` y `## Cómo leer este documento`.
- [ ] Al menos un enlace `[[...]]` entrante o saliente (no queda huérfano).
- [ ] No duplica un documento existente.

---

## 9. Ciclo de vida
- **`ultima_revision`** se actualiza cada vez que tocás el contenido de fondo (no por cambios menores de formato).
- Un documento sin tocar en su ciclo correspondiente ([[SOP Revisiones]]) se marca para revisión.
- Cuando un documento deja de ser válido: `estado: 📦 Archivado` y se mueve a `99 Archivo`. **Nunca se borra** sin propuesta previa (regla del vault).
- Los tipos nuevos definidos por este SOP tienen plantilla: [[Plantilla Runbook]], [[Plantilla Postmortem]], [[Plantilla Checklist]].

---

## 10. Troubleshooting
- **El frontmatter no se parsea / Obsidian lo ignora:** revisá que `tags` no tenga `#` sin comillas. Usá `[a, b]`.
- **Dos documentos con el mismo `id`:** el Registro (§7.1) es la fuente de verdad; renombrá el más nuevo al siguiente número libre.
- **No sé si es SOP o Runbook:** ¿describe la operación normal? → SOP. ¿describe qué hacer cuando algo falla? → Runbook.
- **No sé si es Reference o Explanation:** ¿se consulta un dato puntual? → Reference. ¿se lee para entender el porqué? → Explanation.

## Referencias
- [[Tipos de Documentación]]
- [[Catálogo de Tipos de Documentación]]
- [[Blueprint de Sistemas]]
- [[SOP Maestro]]
- [[SOP Revisiones]]
- [[Glosario de términos]]
- Diátaxis — https://diataxis.fr

## Cómo leer este documento
Es el estándar normativo de documentación. Cuando vayas a crear o tocar un documento, seguí el flujo (§3) y cerrá con la checklist (§8). El resto de secciones se consultan puntualmente.
