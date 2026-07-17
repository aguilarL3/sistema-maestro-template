---
type: Explanation
title: "Open Knowledge Format (OKF)"
description: "Estándar abierto de Google Cloud (v0.1) para representar conocimiento en Markdown+YAML consumible por agentes; formaliza el LLM Wiki."
tags: [okf, llm-wiki, estandares, ia, interoperabilidad]
estado: 🟢 Activo
id: "EXP-022"
fecha_creacion: 2026-07-16
timestamp: 2026-07-17T00:00:00Z
life_areas: [profesional]
domains: [ia, bi]
sources: [Google Cloud]
moc_principal: "[[MOC - IA con Claude]]"
resource:
---

>[!info] Documentación relacionada
>[LLM Wiki](<LLM Wiki.md>) (el marco que OKF estandariza) | [SOP Documentación](<../../00 Sistema/SOP Documentación.md>) (cómo aplica el frontmatter OKF en este vault) | [Investigación y auditoría de marcos](<../Investigación del Sistema/Investigación y auditoría de marcos.md>)

# Open Knowledge Format (OKF)

## Qué es

Un **estándar abierto** para representar metadatos, contexto y conocimiento curado en un formato portable e interoperable, diseñado para ser consumido por sistemas y agentes de IA. Publicado por **Google Cloud** (Sam McVeety y Amir Hormati, junio 2026) como spec **v0.1**.

Es la **formalización vendor-neutral del patrón LLM Wiki** de Andrej Karpathy — el blog de lanzamiento lo cita explícitamente. Es decir: la industria estandarizó la arquitectura que este vault adoptó como pilar #1 ([LLM Wiki](<LLM Wiki.md>), EXP-014).

**Principio central:** es un *formato*, no una plataforma ni un servicio. Deliberadamente minimalista — sin SDK, sin runtime propietario, sin registro central de esquemas. La spec completa entra en una página.

## Qué problema resuelve

El **contexto fragmentado**: las organizaciones guardan conocimiento interno en sistemas incompatibles (catálogos de metadatos con APIs propietarias, wikis, docstrings, la cabeza de los ingenieros senior). Cuando un agente IA necesita responder "¿cómo calculo usuarios activos semanales desde nuestro event stream?", tiene que ensamblar contexto desde superficies dispersas y mutuamente incompatibles.

**La solución OKF:** un formato estándar que permite producir el conocimiento **una vez** y consumirlo **muchas veces**, sobreviviendo al movimiento entre sistemas y organizaciones.

**Goals declarados (§1):** (1) formato universal donde los *enrichment agents* escriben; (2) guía de cómo los *consumption agents* leen y navegan; (3) facilitar el intercambio entre sistemas y organizaciones; (4) estandarizar el mínimo de campos requeridos.

**Non-goals (igual de importantes):** NO define una taxonomía fija de tipos de concepto; NO prescribe infraestructura de almacenamiento/servicio/consulta; **NO reemplaza los esquemas de dominio (Avro, Protobuf, OpenAPI…) — los referencia**, no los subsume.

## La spec v0.1

### Bundle (§3) — estructura de carpetas

Un bundle es un **directorio de archivos Markdown**. Cada `.md` no reservado es un **concepto** (tabla, dataset, métrica, playbook, API…). Subdirectorios agrupan conceptos; la jerarquía es organizativa, el grafo real lo hacen los enlaces.

```
mi_bundle/
├── index.md          # reservado (opcional): listado del directorio
├── log.md            # reservado (opcional): historial de cambios
├── <concepto>.md     # concepto en la raíz
└── <subdirectorio>/
    ├── index.md
    ├── <concepto>.md
    └── <subdirectorio>/…
```

- **Nombres reservados:** `index.md` (listado) y `log.md` (historial). Todo otro `.md` es un concepto.
- **Identidad del concepto = su ruta** sin el sufijo `.md` (ej. `tables/users.md` → ID `tables/users`).
- **Distribución:** repo git (recomendado), tarball/zip, o subdirectorio dentro de un repo mayor.

### Concept docs (§4) — frontmatter YAML

Cada concepto = un Markdown con frontmatter delimitado por `---`:

| Campo | Estado | Semántica |
|---|---|---|
| `type` | **OBLIGATORIO (el único)** | String corto del tipo de concepto (ej. "BigQuery Table", "Playbook"). Sin registro central; los consumidores deben tolerar tipos desconocidos |
| `title` | recomendado | Nombre legible |
| `description` | recomendado | Resumen de una oración |
| `resource` | recomendado | URI que identifica el asset subyacente real |
| `tags` | recomendado | Lista YAML de categorización transversal |
| `timestamp` | recomendado | Datetime ISO 8601 de última modificación |
| *(extensiones)* | permitidas | Los productores pueden agregar campos propios; **los consumidores deben preservar los campos desconocidos** |

Cuerpo: Markdown libre, pero la spec pide **favorecer markdown estructural** (headings, listas, tablas, code fences) sobre prosa libre — "la estructura ayuda tanto a la lectura humana como a la recuperación por agentes" (§4.2). Headings convencionales (ninguno obligatorio): `# Schema` (descripción estructurada), `# Examples` (usos), `# Citations` (fuentes externas, enlaces numerados — pueden apuntar a URLs, rutas del bundle, o a un subdirectorio **`references/` que espeja material externo como conceptos OKF de primera clase**, §8).

**Ejemplo canónico (§4.3):**

```markdown
---
type: BigQuery Table
title: Customer Orders
description: One row per completed customer order across all channels.
resource: https://console.cloud.google.com/bigquery?p=acme&d=sales&t=orders
tags: [sales, orders, revenue]
timestamp: 2026-05-28T14:30:00Z
---

# Schema
| Column | Type | Description |
|---|---|---|
| `order_id` | STRING | Globally unique order identifier. |
| `customer_id` | STRING | Foreign key into [customers](/tables/customers.md). |

# Joins
Joined with [customers](/tables/customers.md) on `customer_id`.
```

Los conceptos abstractos (playbooks, guías) omiten `resource` (§4.4) — el campo aplica solo cuando hay un asset externo real detrás.

### Enlaces (§5)

- Dos formas: **absolutos bundle-relativos** (empiezan con `/`, interpretados desde la raíz del bundle — recomendados por estabilidad) y **relativos** estándar.
- Los enlaces afirman **relaciones no tipadas**; el tipo de relación emerge de la prosa que los rodea.
- **Los enlaces rotos se toleran** — pueden representar *conocimiento aún no escrito*. (Exactamente la práctica de "enlaces planificados" de este vault.)

### `index.md` (§6) — navegación progresiva

Puede existir en **cualquier directorio**. Da *progressive disclosure*: el agente navega la jerarquía leyendo índices en vez de listar archivos.

- **Sin frontmatter** (única excepción: el `index.md` de la **raíz** puede declarar `okf_version: "0.1"`).
- Cuerpo: secciones con headings + bullets `* [Título](url-relativa) - descripción corta`.
- Las entradas DEBERÍAN incluir la `description` del frontmatter del concepto enlazado.
- Pueden generarse automáticamente; si faltan, el consumidor puede sintetizarlos al vuelo.

```markdown
# Tablas

* [Orders](orders.md) - One row per completed customer order.
* [Customers](customers.md) - One row per registered customer.

# Subdirectorios

* [Metrics](metrics/index.md) - Métricas de negocio derivadas.
```

### `log.md` (§7) — historial de cambios

Opcional, en cualquier nivel de la jerarquía. Registra la evolución del conocimiento:

```markdown
# Directory Update Log

## 2026-05-22
* **Update**: Added new BigQuery table reference for [Customer Metrics](/tables/customer-metrics.md).
* **Creation**: Established the [Dataplex Playbook](/playbooks/dataplex.md).

## 2026-05-15
* **Initialization**: Created foundational directory structure.
```

- Headings de fecha **ISO 8601 `YYYY-MM-DD`** obligatorios, **más reciente arriba**.
- Entradas en prosa; las palabras en negrita al inicio (`**Update**`, `**Creation**`, `**Deprecation**`) son convención, no requisito.

### Conformance

Un bundle **conforma OKF v0.1** si:
1. Todo `.md` no reservado tiene frontmatter YAML parseable.
2. Todo frontmatter tiene un campo `type` no vacío.
3. Los nombres reservados siguen sus estructuras definidas.

Los consumidores **no deben rechazar**: campos opcionales faltantes, valores de `type` desconocidos, claves de frontmatter desconocidas, enlaces rotos, ni índices faltantes.

Este modelo de consumo permisivo es **intencional** (§9): "OKF debe seguir siendo útil mientras los bundles crecen, se refactorizan y son parcialmente generados por agentes". Nota §3.1: no hay formato de archivo para agrupar por tag — las vistas por tag se **sintetizan al consumir** escaneando frontmatter.

### Versionado

`<major>.<minor>`. Minor = agregados retrocompatibles; major = cambios breaking. Un bundle puede declarar su versión objetivo con `okf_version: "0.1"` en el frontmatter del `index.md` raíz (el único índice al que se le permite frontmatter).

## Los 3 principios de diseño

1. **Mínimamente opinado** — solo `type` es obligatorio; el productor controla su propio esquema.
2. **Independencia productor/consumidor** — el formato es el contrato; el tooling de cada punta es intercambiable.
3. **Formato, no plataforma** — sin lock-in, sin SDK propietario, estándar publicado abierto.

## La metodología que transmite

Más allá de la spec, el artículo y el README empujan una forma de trabajar:

- **Tríada de composición:** *just markdown* (legible en cualquier editor, renderizable en GitHub) · *just files* (distribuible como git/tarball, montable de cualquier filesystem) · *just YAML frontmatter* (lo mínimo estructurado para consultar/filtrar/indexar).
- **Enfoque híbrido deliberado:** frontmatter = los pocos campos consultables (`type`, `resource`, `tags`, `timestamp`); cuerpo = la prosa, esquemas y queries que humanos y LLMs *realmente leen*. Cada uno extrae valor distinto del mismo artefacto.
- **Biblioteca compartida que crece:** en vez de que los modelos re-busquen los mismos documentos en cada consulta, se les da una biblioteca markdown compartida que **los agentes mismos actualizan**. Del gist de Karpathy que OKF formaliza: *"los LLMs no se aburren, no se olvidan de actualizar una referencia cruzada, y pueden tocar 15 archivos en una pasada. El bookkeeping que hace que los humanos abandonen sus wikis personales es exactamente lo que los LLMs hacen bien."*
- **Curación de conocimiento = ingeniería de software:** los bundles viven en git — PRs, diffs línea a línea, blame y revisión "simplemente funcionan".
- **Universalidad productor/consumidor:** produce cualquiera (humanos a mano, agentes de cualquier framework — ADK, LangChain, custom —, pipelines de export desde Dataplex/Unity Catalog/Collibra, scripts sobre una DB); consume cualquiera (file server estático, **Obsidian**/Notion/MkDocs, un LLM cargando archivos a contexto, un índice de búsqueda, un visor de grafo). El formato es el contrato.

## El reference agent — la disciplina editorial

El repo trae un agente productor *proof-of-concept* cuyos **prompts** (`src/reference_agent/prompts/`) codifican la metodología editorial. Corre en **2 pasadas**: (1) **pasada de metadata** — 1 doc OKF por concepto usando solo la metadata de la fuente (BigQuery); (2) **pasada web** — el LLM es su propio crawler: parte de `seeds.txt`, fetchea, decide qué links seguir, y por página elige *enriquecer / crear referencia / saltear*. El presupuesto es duro y **vive en la herramienta, no en el juicio del LLM** (`--web-max-pages`, filtro de hosts).

Reglas editoriales clave (transferibles a cualquier sistema de conocimiento con agentes):

- **1 invocación = 1 concepto** (atomicidad operativa); leer el doc existente primero → **refinar, no reescribir**.
- **`description` = UNA oración**, usada verbatim por el generador de índices.
- **Orden canónico del cuerpo** (tablas): prosa 1-3 párrafos con el **grano** ("one row per X"), rango temporal y caveats → `# Schema` → `# Common query patterns` (SQL real) → `# Citations` (el `resource` como primera cita; **no inventar URLs**).
- **Aumentación no-negociable** (pasada web sobre doc existente): el doc en disco es la fuente de verdad; **todo heading `#` existente se preserva verbatim y en orden** — se extiende debajo, se agregan subsecciones o headings nuevos *al final*; `tags` = unión; `resource` jamás se pisa. Si no se puede honrar → no tocar el doc (crear referencia aparte o saltear).
- **Test de 4 puertas** para crear una nota de referencia: (1) tópico *referenciable por nombre* (entidad, métrica, enum, glosario); (2) NO meta — skip automático de overview/intro/getting-started/quickstart/tutorial/changelog/roadmap/faq; (3) test de citación: ¿puedo escribir "*See the [X reference] for…*" con X concreto?; (4) test de reuso: ≥2 conceptos la citarían. *"When in doubt, skip. Un bundle lleno de `references/overview` es ruido."*
- **Extracciones obligatorias** (saltean las 4 puertas por ser inherentemente concepto): **métricas** → 1 archivo por métrica en `references/metrics/` con la **expresión SQL literal** (paráfrasis no alcanza); **la referencia es DUEÑA del SQL — las tablas solo la enlazan, sin duplicar**. **Joins** → 1 archivo canónico por par (`references/joins/<a>__<b>.md`, orden alfabético) con la cláusula `ON` literal, enlazado desde *ambas* tablas. **Dimensiones** → viven en el doc de la tabla dueña de la columna.
- **Enlaces: relativos SOLAMENTE** — el prompt prohíbe empezar con `/` ("rompe el render en GitHub"), en tensión deliberada con la spec §5.1 que recomienda absolutos. Solo linkear conceptos que existen (`list_concepts` — no inventar targets); 1 link por mención por sección; sin links en headers ni código.
- **Integridad:** citar solo URLs realmente visitadas; concreto sobre genérico; cero preámbulos o narración en los cuerpos.

## Los bundles reales (ejemplos del repo)

3 bundles producidos por el agente, commiteados en `bundles/` (~90 concept docs): **GA4 e-commerce**, **Stack Overflow**, **Bitcoin**. Cada uno con su **receta reproducible** en `samples/` (`seeds.txt` + el comando `enrich` exacto) — el conocimiento se produce por pipeline repetible, no a mano.

Estructura real del GA4: `index.md` + `viz.html` + `datasets/` + `tables/` + `references/{joins/, metrics/}`.

Qué enseñan sobre la práctica (vs. la letra de la spec):
- **Index real:** la raíz usa `# Subdirectories` con entradas hacia `subdir/index.md`; los índices por directorio agrupan bajo un heading **= valor de `type`** (ej. `# Reference`), entradas **alfabéticas**, descripción verbatim del frontmatter. El generador (`bundle/index.py`) automatiza exactamente eso.
- **Doc de métrica real** (`user_count.md`): mínimo y perfecto — `type: Reference` + `tags: [metric]` + `resource` → 1 oración + bloque `sql` (`COUNT(DISTINCT user_pseudo_id)`) + citas. El `type` es **grueso** y los `tags` refinan (no `type: Metric`).
- **Doc de tabla grande** (`events_.md`): `# Overview` → `# Metrics` (bullets que enlazan a las referencias, sin duplicar SQL) → `# Schema` (jerarquía anidada `##`/`###` por RECORD) → `# Joins` → `# Citations`.
- **Ningún bundle producido tiene `log.md`** — opcional también en la práctica.
- **`viz.html` viaja dentro del bundle**: el subcomando `visualize` genera un HTML autocontenido (Cytoscape.js + marked) con grafo force-directed coloreado por type, panel de detalle con markdown renderizado, **backlinks** ("Cited by"), búsqueda y filtros. El visor es el *proof-of-concept consumidor*, espejo del agente *productor*.

## Relación con otros formatos (§10 de la spec)

La spec misma se posiciona cerca de: los **LLM-wiki repos** (markdown + frontmatter como base de conocimiento para agentes), las **herramientas de conocimiento personal — nombra a Obsidian y Notion** — y el enfoque **"metadata as code"**. La diferencia que reivindica: *"OKF difiere principalmente en estar **especificado**"* — fija las pocas reglas necesarias para interoperar sin dictar tooling. Primer consumidor productivo: el **Knowledge Catalog** de Google Cloud (ingiere OKF y lo sirve a agentes). Modelo de contribución abierto (issues/PRs; invita implementaciones alternativas).

## Relación con este vault

El vault **ya implementa la sustancia de OKF**: Markdown + frontmatter YAML (`type`/`timestamp`/`title`/`description`/`resource` — ver [SOP Documentación](<../../00 Sistema/SOP Documentación.md>) §4), enlaces como grafo, capa índice (`index.md` generados), historial, agentes que lo mantienen. OKF valida con un estándar externo la arquitectura elegida en [Filosofía del Sistema](<../../00 Sistema/Filosofía del Sistema.md>) — y abre dos usos nuevos: **formato de intercambio** hacia otros sistemas/organizaciones (portabilidad) y **catálogo de datos para proyectos BI** (ángulo Career OS: OKF nació para documentar tablas/métricas/datasets).

**Aclaración importante — no hace falta BigQuery:** el pipeline de Google (BigQuery + seeds → agente → bundle) responde a que *su* fuente de verdad es una base de datos y el markdown es un **artefacto compilado que se regenera** (nunca se edita a mano). Usar OKF no exige replicar eso: lo que exige es saber **qué es fuente y qué es generado** en tu sistema. En el vault: las notas son la fuente (por eso se escriben a mano y usan wikilinks por nombre) y los `index.md` son lo generado (por eso los fabrica `generate-index.py` y usan links por ruta). El pipeline completo estilo Google recién aplica al documentar **datos externos** — un dashboard, un dataset — donde "tu BigQuery" son tus propios datasets y el bundle se regenera cuando ellos cambian.

## Referencias

- Blog de lanzamiento: https://cloud.google.com/blog/products/data-analytics/how-the-open-knowledge-format-can-improve-data-sharing
- Spec v0.1: https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md
- Repo (agentes de referencia + samples): https://github.com/GoogleCloudPlatform/knowledge-catalog
- LLM Wiki (Karpathy): https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f
