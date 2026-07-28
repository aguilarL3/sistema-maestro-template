---
tags: [documentacion, sistema, diataxis, reference]
estado: 🟢 Activo
prioridad: ⏳ Media
responsable: "{{OWNER}}"
id: "REF-DOCTYPES-001"
generated:
  by: human:{{OWNER}}
  at: 2026-06-26T00:00:00Z
type: Reference
title: "Tipos de Documentación del Sistema"
fecha_creacion: 2026-06-26
resource:
---

>[!info] Documentación relacionada
>[Catálogo de Tipos de Documentación](<../04 Knowledge/Sistemas y Metodologías/Catálogo de Tipos de Documentación.md>) (versión profunda, para *estudiar*) | [Blueprint de Sistemas](<Blueprint de Sistemas.md>) | [SOP Interoperabilidad IA](<SOP Interoperabilidad IA.md>) | [SOP Maestro](<SOP Maestro.md>) | [Glosario de términos](<Glosario de términos.md>)

# Tipos de Documentación del Sistema

Documento de **referencia** (no es un SOP): mapea qué tipos de documentación existen y cuál usar para cada necesidad. Sirve para no caer en "todo es un SOP".

> **Insight:** la documentación no se organiza por tema, sino por **intención del lector**. ¿Quiere aprender, resolver, consultar o entender? Cada intención pide un tipo distinto.

---

## 1. El marco base: Diátaxis

Marco canónico (Daniele Procida, 2020 — usado por Django, Cloudflare, Canonical). Cuatro tipos según dos ejes: **acción vs conocimiento** y **estudiar vs trabajar**.

| Tipo | Intención del lector | Pregunta que responde | Ejemplo en el vault |
|---|---|---|---|
| **Tutorial** | Aprender haciendo | "¿Cómo empiezo?" | [00 Inicio Rapido](<../00 Inicio Rapido.md>) (el único tutorial de entrada) |
| **How-to guide** | Resolver una tarea concreta | "¿Cómo hago X?" | **los SOPs**, [Blueprint de Sistemas](<Blueprint de Sistemas.md>) |
| **Reference** | Consultar un dato preciso | "¿Cuál es el valor / campo / regla?" | [Glosario de términos](<Glosario de términos.md>), [Notion - Arquitectura](<../04 Knowledge/Conectores/Notion - Arquitectura.md>), este doc |
| **Explanation** | Entender el porqué | "¿Por qué es así?" | [Filosofía del Sistema](<Filosofía del Sistema.md>), [Principios](<../01 Index/Principios.md>), notas en `Temas/` |

```
                  ACCIÓN
                    │
     Tutorial  ─────┼─────  How-to
                    │
  ESTUDIAR ─────────┼───────── TRABAJAR
                    │
   Explanation ─────┼─────  Reference
                    │
                CONOCIMIENTO
```

---

## 2. Tipos de operaciones (complementan Diátaxis)

Del mundo ops/ingeniería 2026, categorías que el vault tiene o casi:

| Tipo | Qué es | En el vault |
|---|---|---|
| **SOP** | Cómo hacer una tarea **normal y esperada** | `00 Sistema/SOP *.md` ✅ |
| **Runbook** | Qué hacer cuando algo **falla** (anormal) | ⚠️ Hoy implícito en la sección Troubleshooting de los SOPs |
| **ADR** (Decision Record) | Por qué se **decidió** algo | [[Plantilla Decisiones]] ✅ |
| **Changelog / Bitácora** | Qué **cambió** | [CHANGELOG del Sistema](<CHANGELOG del Sistema.md>), `Migracion...` ✅ |
| **Índice / Mapa** | **Dónde** está cada cosa | MOCs, `llms.txt`, [[01 Index/Index Global]] ✅ |
| **Plantilla** | Andamio para crear cualquiera de los anteriores | `00 Sistema/001_plantillas/` ✅ |

> **SOP vs Runbook** es la distinción que más conviene incorporar: el SOP cubre la operación normal; el Runbook cubre el fallo. Hoy se mezclan en la sección Troubleshooting. Separarlos cuando un proceso tenga muchos modos de fallo.

---

## 3. Guía de decisión: ¿qué tipo creo?

```
¿Qué necesita quien va a leer esto?

├─ Aprender el sistema desde cero        → Tutorial
├─ Ejecutar una tarea conocida, paso a paso → SOP (How-to)
├─ Saber qué hacer cuando algo se rompe   → Runbook
├─ Consultar un dato / campo / regla      → Reference
├─ Entender por qué se diseñó así         → Explanation
├─ Saber por qué se tomó una decisión     → ADR (Decisiones)
├─ Ver qué cambió                         → Changelog
└─ Encontrar dónde está algo              → MOC / Índice
```

---

## 4. Convención: declarar el tipo

Para que cada doc sepa qué es, se recomienda el campo de frontmatter:

```yaml
type: Tutorial | How-to | Reference | Explanation | SOP | Runbook | ADR | Changelog | Indice
```

Esto permite que una IA (o vos) filtre por tipo y que el [Skill - Mantenimiento Sistema](<../04 Knowledge/Skills/Skill - Mantenimiento Sistema.md>) audite la consistencia. **No es obligatorio retroactivo** — se aplica a docs nuevos y a los que se vayan tocando (ver plan de migración pendiente).

---

## 5. Por qué importa (relación con el resto del sistema)

- El [Blueprint de Sistemas](<Blueprint de Sistemas.md>) dice *qué capas* crear; este doc dice *qué tipo de documento* es cada pieza de esas capas.
- El [SOP Interoperabilidad IA](<SOP Interoperabilidad IA.md>) separa Ley/Mapa/Estado/Arquitectura/Capacidad; esos son **roles**, esto son **formatos**. Un doc de Arquitectura suele ser Reference; uno de Capacidad suele ser How-to.
- Evita el anti-patrón "todo es un SOP", que infla los how-to con cosas que son reference o explanation.

---

## 6. Qué NO lleva `type` (y por qué)

No todo el vault se etiqueta. `type` es para **documentación**; estas categorías quedan fuera por principio:

| Excluido | Razón de best-practice |
|---|---|
| **Apuntes de curso** (`04 Knowledge/Cursos/`) | No son documentación dirigida a una audiencia: son notas de aprendizaje. Se rigen por **Zettelkasten/Evergreen**, ya clasificadas por carpeta + tags `[learning, clase]`. |
| **Proyectos** (`03 Proyectos/`) | Son artefactos de gestión, no documentación. Se rigen por **PARA** (Projects), ya clasificados por carpeta + Plantilla Proyecto. |
| **Diario** (`05 Diario/` entradas) | Registro temporal, no documentación. |
| **`CLAUDE.md`, `AGENTS.md`** | Los define el estándar AGENTS.md como markdown sin frontmatter. Agregárselo es no-estándar y puede confundir a las herramientas que los parsean. |
| **`llms.txt`** | Tiene spec propia (H1 + blockquote + H2). Frontmatter YAML **violaría** esa spec. |
| **`.claude/commands/`** | Son ejecutables de skills, no documentación del vault. |
| **`99 Archivo/`** (contenido) | Material archivado; no se mantiene. |

> **Regla:** Diátaxis es para documentación con audiencia. Los artefactos de trabajo (notas de estudio, proyectos, diario) y los archivos de convención (definidos por su propia spec) se clasifican por **otro eje** —carpeta, tags, o el estándar que los gobierna— no por `type`.

---

## Referencias

- [Blueprint de Sistemas](<Blueprint de Sistemas.md>)
- [SOP Interoperabilidad IA](<SOP Interoperabilidad IA.md>)
- [SOP Maestro](<SOP Maestro.md>)
- [Glosario de términos](<Glosario de términos.md>)
- Diátaxis — Daniele Procida (https://diataxis.fr)
- Fuente ops: Runbook vs SOP (upstat.io, 2026)

## Cómo leer este documento
Es referencia: no se lee de corrido, se consulta. Cuando dudes qué tipo de doc crear, andá a la guía de decisión (§3).
