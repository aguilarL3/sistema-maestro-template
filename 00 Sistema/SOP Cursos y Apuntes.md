---
type: How-to
title: "SOP Cursos y Apuntes"
tags: [sop, cursos, apuntes, aprendizaje]
estado: 🟢 Activo
prioridad: 🔥 Alta
responsable: "{{OWNER}}"
id: "SOP-COURSES-001"
timestamp: 2026-06-24T00:00:00Z
fecha_creacion: 2026-06-24
resource:
---

>[!info] Documentación relacionada
>[[Plantilla Apunte Curso]] | [SOP Sistema de Estudio](<SOP Sistema de Estudio.md>) | [SOP Notas Atómicas](<SOP Notas Atómicas.md>) | [SOP Prompts](<SOP Prompts.md>) | [SOP MOCs](<SOP MOCs.md>)

# SOP Cursos y Apuntes

## Objetivo

Definir dónde viven los apuntes de curso, cómo se nombran, cómo se conectan al resto del vault y cuándo se archivan.

Este SOP cubre **el envase**. El **flujo conceptual** (Curso → Nota de clase → Nota atómica → Aplicación → Evidencia) está definido en [SOP Sistema de Estudio](<SOP Sistema de Estudio.md>).

---

## 1. Ubicación

Los apuntes de curso viven en:

```
04 Knowledge/Cursos/{Nombre del Curso}/Clase N.M - Título.md
```

**Por qué `04 Knowledge` y no `05 Diario`:**
Los apuntes ya pasaron por la plantilla — son conocimiento procesado, no captura cruda. El diario es centro operativo (hábitos, reflexiones, prioridades) según [SOP Diario](<SOP Diario.md>). Mezclarlos rompe la función de cada capa.

**Por qué subcarpeta por curso y no flat:**
- Facilita archivar el curso entero cuando termina.
- Hace evidente qué cursos están activos al abrir la carpeta.
- Está acotado: una subcarpeta por curso, no se subdivide más. No viola la regla "no carpetas temáticas infinitas" porque es estructura **por origen** (curso), no **por tema**.

---

## 1.bis Raw vs Knowledge — distinción crítica

Un curso genera **dos artefactos distintos** y cada uno vive en su capa:

| Artefacto | Quién lo creó | Capa | Ejemplo |
|---|---|---|---|
| **Material original del curso** | Otro (instructor, editorial) | `06 Raw/Cursos/{Curso}/` | Video MP4, slides PDF, dataset CSV entregado, transcripción cruda |
| **Apunte de la clase** | Vos | `04 Knowledge/Cursos/{Curso}/` | Nota con `Plantilla Apunte Curso`, conceptos extraídos, ejemplos personales |

### Regla práctica

> Si lo creó otro (video, PDF, slides) → `06 Raw`.
> Si lo escribiste vos (apunte, síntesis, prompt) → `04 Knowledge`.

### Por qué importa la distinción
- El **material en Raw** no se modifica — es fuente citable, consultable, intacta.
- El **apunte en Knowledge** sí evoluciona — crece con relecturas, conecta con otras notas, se atomiza en `Temas/`.

Mezclar ambos en la misma capa rompe la cadena `Información → Conocimiento → Acción` y obliga a decidir cada vez si algo se reescribe o no.

### Convención de naming en Raw
Para que un material en `06 Raw/Cursos/{Curso}/` se enlace fácil desde el apunte:

```
06 Raw/Cursos/IA con Claude/
├─ Clase 1.2 - video.mp4         (o link a Drive)
├─ Clase 1.2 - slides.pdf
└─ Clase 1.2 - transcripcion.txt
```

Desde el apunte en `04 Knowledge/Cursos/IA con Claude/Clase 1.2 - Mecanismo de Búsqueda.md` se enlaza el material en la sección **Acceso al video** (o equivalente).

---

## 2. Naming

Formato exacto:

```
Clase N.M - Título descriptivo.md
```

Ejemplos válidos:
- `Clase 1.2 - Mecanismo de Búsqueda.md`
- `Clase 2.2.5.1 - ETL Más Frecuente.md`

Ejemplos a evitar:
- `clase1_2.md` (sin contexto)
- `Mecanismo de Búsqueda.md` (sin número de clase — rompe el orden)
- `Clase 1.2 — Mecanismo (versión final).md` (paréntesis confunden a futuros enlaces)

---

## 3. Plantilla

Plantilla obligatoria: [[Plantilla Apunte Curso]].

Secciones que SIEMPRE deben estar:
- Frontmatter completo (curso, clase, categoría, estado, domains).
- Conceptos Clave.
- Conceptos extraídos → Knowledge.
- Navegación inferior (clase anterior / MOC / clase siguiente).

Secciones opcionales (mantener solo si aplican): Fórmulas, Equivalencias Excel→SQL→Power BI, Caso Real, Preguntas de Entrevista, Acceso al video.

---

## 4. Conexiones obligatorias

Cada apunte debe enlazar:

1. **MOC del curso** — en frontmatter `origen` y en la navegación inferior.
2. **Clase anterior y siguiente** — navegación inferior.
3. **Conceptos extraídos a Knowledge** — sección "Conceptos extraídos".
4. **Prompts que aparecen en la clase** — sección "Ejemplos", enlazando a la nota del prompt en `04 Knowledge/Prompts/` (ver [SOP Prompts](<SOP Prompts.md>)).

---

## 5. Ciclo de vida

| Estado | Significado | Acción |
|---|---|---|
| 🟨 Pendiente | Apunte creado pero sin procesar todavía | Completar conceptos, ejemplos, conexiones |
| 🟩 Procesado | Apunte completo, enlaces al MOC y a conceptos | Lectura activa, extracción a Knowledge |
| 🟦 Aplicado | El conocimiento ya generó algo concreto (proyecto, prompt productivo, evidencia) | Mantener como referencia |

---

## 6. Cuándo extraer una nota atómica

Regla (heredada de [SOP Notas Atómicas](<SOP Notas Atómicas.md>) y [SOP Sistema de Estudio](<SOP Sistema de Estudio.md>)):

Una idea del apunte merece su propia nota en `04 Knowledge/Temas/` cuando:
- Aparece 3+ veces en distintas fuentes / clases / proyectos.
- Conecta dos o más áreas o dominios.
- Tiene alto valor práctico y se va a reusar.

**Soberanía conceptual:** no atomizar por atomizar. Las clases sueltas pueden contener decenas de conceptos — solo los que cumplen el criterio bajan a Knowledge.

**Formato del placeholder:** mientras la nota no existe, usar texto plano dentro del callout `[!todo]` — sin `[[]]`. Una vez creada la nota atómica en `04 Knowledge/Temas/`, reemplazar el texto plano con el wikilink real: `[[Nombre de la nota]]`.

---

## 7. Archivado del curso

Cuando un curso termina **y deja de tener movimiento por 3+ meses**, evaluar:

- **Mantener en `04 Knowledge/Cursos/{Curso}/`** si las clases siguen siendo referencia frecuente o si los conceptos no fueron del todo extraídos a Temas.
- **Mover a `99 Archivo/Cursos/{Curso}/`** si el conocimiento ya fue completamente atomizado a Knowledge y los apuntes solo tienen valor histórico.

**Regla:** no archivar por archivar. Archivar es una decisión activa, no una limpieza automática.

---

## 8. Errores comunes

| Error | Por qué falla | Cómo evitarlo |
|---|---|---|
| Apuntes en `05 Diario/` | Rompe la función del diario (centro operativo) | Crear directo en `04 Knowledge/Cursos/{Curso}/` |
| Naming inconsistente (`clase1.md`, `Clase 1 — X.md`, `clase_1.md`) | Rompe orden alfabético y enlaces | Usar formato exacto: `Clase N.M - Título.md` |
| Apunte sin enlace al MOC | El apunte queda huérfano | Frontmatter `origen` + footer de navegación obligatorios |
| Atomizar todo a Knowledge | Inflación de notas atómicas vacías | Aplicar criterio "3+ veces / cruza áreas / alto valor" |
| Mezclar prompts dentro del apunte | El prompt no es reutilizable ni versionable | Extraer a `04 Knowledge/Prompts/` con [[Plantilla Prompt]] |

---

## 9. Anotación de cambio de flujo

> **Cambio aplicado 2026-06-24:** los apuntes de curso pasan a vivir en `04 Knowledge/Cursos/{Curso}/`. Antes de esta fecha, los apuntes se acumularon en `05 Diario/` por falta de SOP específico. La migración de los apuntes existentes es manual desde Obsidian para preservar enlaces.

---

## Referencias

- [[Plantilla Apunte Curso]]
- [SOP Sistema de Estudio](<SOP Sistema de Estudio.md>)
- [SOP Notas Atómicas](<SOP Notas Atómicas.md>)
- [SOP Prompts](<SOP Prompts.md>)
- [SOP MOCs](<SOP MOCs.md>)
- [SOP Diario](<SOP Diario.md>)
- MOC - Master Learning System
