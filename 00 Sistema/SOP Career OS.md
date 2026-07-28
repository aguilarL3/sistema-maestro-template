---
type: How-to
title: "SOP Career OS"
tags: [sop, carrera, career-os, empleabilidad]
estado: 🟢 Activo
prioridad: 🔥 Alta
responsable: "{{OWNER}}"
id: "SOP-CAREER-001"
generated:
  by: human:{{OWNER}}
  at: 2026-07-14T00:00:00Z
fecha_creacion: 2026-06-27
resource:
---

>[!info] Documentación relacionada
>[Career OS](<../04 Knowledge/Sistemas y Metodologías/Career OS.md>) | [MOC - Carrera](<../02 MOCs/MOC - Carrera.md>) | [SOP Proyectos](<SOP Proyectos.md>) | [SOP Notas Atómicas](<SOP Notas Atómicas.md>) | [SOP Skills](<SOP Skills.md>) | [SOP Compartir Archivos](<SOP Compartir Archivos.md>)

# SOP Career OS

## Objetivo

Definir **dónde vive, cómo se nombra, cómo se conecta y cómo evoluciona** el subsistema Career OS dentro del vault.

Este SOP cubre **el envase** (estructura, naming, integración, ciclo de vida).
El **marco conceptual** (qué es Career OS y qué problema resuelve) está en [Career OS](<../04 Knowledge/Sistemas y Metodologías/Career OS.md>).
La **navegación temática** la da [MOC - Carrera](<../02 MOCs/MOC - Carrera.md>).

---

## 1. Ubicación

El subsistema vive en:

```
04 Knowledge/{{OWNER}} Career OS/
```

**Por qué `04 Knowledge` y no `03 Proyectos`:**
Career OS es **conocimiento reutilizable sobre tu trayectoria** (experiencias, skills, evidencia, logros), no una iniciativa con inicio y fin. Las *postulaciones concretas* y los *portfolios* sí pueden generar proyectos en `03 Proyectos/` cuando tengan principio y fin definidos.

**Por qué subcarpeta propia y no disuelto en el vault:**
- Es un sistema con su propia lógica interna (importado de un marco externo).
- Facilita exportar/compartir el bloque completo de carrera sin arrastrar el resto del vault.
- Es estructura **por origen** (subsistema Career OS), no por tema → no viola "no carpetas temáticas infinitas".

---

## 2. Mapa de carpetas

> El esqueleto **no viene creado en el template**: lo creás al activar el subsistema (basta con las carpetas que vayas a usar; el resto se agrega a demanda).

| Carpeta | Qué guarda |
|---|---|
| `00_Dashboard` | Auditorías y guías concretas de carrera (CV, LinkedIn). **No** es panel de gobernanza (ver §5) |
| `01_Experiences` | Una carpeta por experiencia laboral + sus `Recursos/` (datasets, propuestas) |
| `02_Skills` | Una nota por skill, agrupadas por familia (Business Ops, Data, Dev, Ecommerce, Marketing, Soft Skills) |
| `03_Projects` | Proyectos demostrables de portfolio (BI, IA, automatización) |
| `04_Career_Stories` | Historias STAR para entrevistas (Situación–Tarea–Acción–Resultado) |
| `05_Courses_&_Certifications` | Cursos y certificaciones con valor para empleabilidad |
| `06_Tools_&_Technologies` | Una nota por herramienta/tecnología dominada |
| `07_CV_Master` | CV maestro versionado (fuente de verdad de la que salen variantes) |
| `08_Job_Applications` | Pipeline de postulaciones: `Applied / Interviewing / Offers / Rejected` + `Templates` |
| `09_Achievements` | Logros cuantificables y reconocimientos |
| `10_Research_&_Ideas` | Investigación de mercado, roles objetivo, ideas de posicionamiento |
| `Assets` | Binarios: `Certificates / CVs / Images / Logos / PDFs / Screenshots` |
| `CV.md` (raíz) | Narrativa profesional cruda (materia prima del CV) |

---

## 3. Naming

- **Carpetas del esqueleto:** se respeta el prefijo numérico `NN_Nombre` ya existente. No renombrar ni reordenar (rompería enlaces y la lógica del subsistema).
- **Experiencias:** una carpeta por puesto/empresa, con nombre legible. Dentro, la nota principal lleva el nombre del rol o de la empresa.
- **Skills / Tools / Stories:** una nota = un concepto. `Nombre claro.md`, sin numerar.
- **CV:** el maestro vive en `07_CV_Master/`. Las variantes por puesto se nombran `CV - {Rol o Empresa} - YYYY-MM.md`.

---

## 4. Integración con las convenciones del vault

> **Brecha detectada (2026-06-27):** las notas importadas NO traen frontmatter del vault (sin `tags`, `estado`, `life_areas`, etc.). Son markdown plano estilo CV.

Al **tocar o crear** una nota dentro de Career OS, se le agrega frontmatter mínimo del vault:

```yaml
---
type: Reference        # o Explanation / How-to según el caso
tags: [career-os, <familia>]
life_areas: [profesional]
domains: [carrera, <dominio>]
estado: 🟢 Activo          # o 🟨 Borrador / 🟦 Aplicado
---
```

**Regla práctica:** no migrar todo el frontmatter de golpe. Se añade cuando una nota se trabaja, no como tarea masiva (evita ruido y commits gigantes).

---

## 5. Conexiones obligatorias

Toda nota relevante de Career OS debe poder alcanzarse desde la red del vault:

1. **[MOC - Carrera](<../02 MOCs/MOC - Carrera.md>)** → puerta de entrada temática. Debe enlazar a las notas reales de Career OS (experiencias, skills, dashboard), no solo a la nota conceptual [Career OS](<../04 Knowledge/Sistemas y Metodologías/Career OS.md>).
2. **`life_areas: [profesional]`** → conecta con la gobernanza de [Yo SA](<../04 Knowledge/Sistemas y Metodologías/Yo SA.md>).
3. **Experiencia ↔ Evidencia** → cada experiencia con datasets enlaza sus `Recursos/`; cada logro en `09_Achievements` apunta a la experiencia que lo respalda.
4. **Skill ↔ Proyecto ↔ Evidencia** → una skill en `02_Skills` se respalda con un proyecto de `03_Projects` y/o una historia de `04_Career_Stories`.

### Jerarquía de dashboards (regla anti-duplicado)

> **El [Dashboard CEO](<../Dashboard-CEO.md>) (`01 Index`) es el ÚNICO panel de gobernanza.** Ya integra Career OS + Yo S.A. + Cerebro Digital + GTD.

- `00_Dashboard` de Career OS **no** replica objetivos, métricas ni visión: se limita a **auditorías y guías concretas de carrera** (auditoría de CV, optimización de LinkedIn) y **enlaza hacia arriba** al [Dashboard CEO](<../Dashboard-CEO.md>).
- Cualquier objetivo o métrica de carrera vive en [Objetivos](<../01 Index/Objetivos.md>) / [Dashboard CEO](<../Dashboard-CEO.md>), no duplicado dentro de Career OS.

### Proyectos: enlazar, no duplicar

> Los proyectos demostrables ya viven en `03 Proyectos/` (tus dashboards, automatizaciones, apps).

`03_Projects` dentro de Career OS **no copia** esos proyectos: los **enlaza** como portfolio. Career OS es la vitrina; `03 Proyectos` es la fuente de verdad.

---

## 6. Raw vs Knowledge dentro de Career OS

Los datasets crudos dentro de `01_Experiences/.../Recursos/` son **fuentes**, no conocimiento procesado:

> Si es un archivo original sin procesar (xlsx, zip, export) → es **Raw embebido**: no se modifica, se cita.
> Si es una síntesis escrita por vos (análisis, propuesta, historia) → es **Knowledge**: evoluciona.

Cuando un dataset crudo crezca o se reuse fuera de la carrera, evaluar moverlo a `06 Raw/` según [SOP Compartir Archivos](<SOP Compartir Archivos.md>).

---

## 7. Ciclo de vida de una postulación

`08_Job_Applications` funciona como pipeline (kanban en carpetas):

| Carpeta | Significado | Acción al entrar |
|---|---|---|
| `Templates` | Plantillas de carta, email, seguimiento | Reutilizar, no mover |
| `Applied` | Postulación enviada | Crear nota con puesto, empresa, fecha, link, CV usado |
| `Interviewing` | En proceso de entrevistas | Adjuntar historia STAR de `04_Career_Stories` |
| `Offers` | Oferta recibida | Registrar condiciones para decidir ([SOP Decisiones](<SOP Decisiones.md>)) |
| `Rejected` | Descartada | Anotar feedback/aprendizaje antes de archivar |

**Regla:** una postulación se mueve de carpeta, no se duplica. El historial vive en la propia nota.

---

## 8. Gestión de archivos (OneDrive / Windows)

- Los `desktop.ini` son metadata de Windows/OneDrive. **Están en `.gitignore`** (`desktop.ini`, `**/desktop.ini`) — no entran al repo pero permanecen en disco para que la sincronización funcione.
- **Política del vault: git = solo markdown.** Los binarios (xlsx, pdf, zip, imágenes, video) **no** se versionan en git: están en `.gitignore` a nivel de todo el vault. Viven en disco y se sincronizan por **OneDrive/Drive**, que es la capa de respaldo de archivos. Obsidian los renderiza desde disco igual; git se queda con texto diffeable y liviano.
- Los datasets crudos y la evidencia binaria se citan y embeben según [SOP Compartir Archivos](<SOP Compartir Archivos.md>); nunca se commitean.
- Excepción: `.canvas` **sí** entra a git (es JSON/texto, contenido del vault, no un binario opaco).

---

## 9. Errores comunes

| Error | Por qué falla | Cómo evitarlo |
|---|---|---|
| Renombrar las carpetas `NN_` | Rompe enlaces y la lógica del subsistema | Respetar el esqueleto numérico |
| Crear notas sin frontmatter del vault | Quedan invisibles a queries, MOCs y campos transversales | Añadir frontmatter mínimo al trabajar la nota (§4) |
| Duplicar una postulación al avanzar de etapa | Genera historial incoherente | Mover la nota entre carpetas del pipeline (§7) |
| Tratar Career OS como proyecto | Confunde conocimiento con iniciativa | Subsistema en `04 Knowledge`; los entregables con fin van a `03 Proyectos` |
| Atomizar cada bullet del CV a Knowledge | Inflación de notas | Solo extraer a `Temas/` lo que cruza áreas o se reusa (criterio [SOP Notas Atómicas](<SOP Notas Atómicas.md>)) |
| Commitear `desktop.ini` | Ruido en el repo | Ya cubierto por `.gitignore` |

---

## 10. Cómo leer este SOP

Primero entendé el objetivo y el mapa de carpetas (§1–§2). Cuando crees o muevas algo, mirá naming (§3), integración (§4) y conexiones (§5). El pipeline de empleo (§7) se consulta solo al postular. No hace falta memorizarlo: el documento te guía.

---

## Referencias

- [Career OS](<../04 Knowledge/Sistemas y Metodologías/Career OS.md>)
- [MOC - Carrera](<../02 MOCs/MOC - Carrera.md>)
- [SOP Proyectos](<SOP Proyectos.md>)
- [SOP Notas Atómicas](<SOP Notas Atómicas.md>)
- [SOP Skills](<SOP Skills.md>)
- [SOP Decisiones](<SOP Decisiones.md>)
- [SOP Compartir Archivos](<SOP Compartir Archivos.md>)
- [Yo SA](<../04 Knowledge/Sistemas y Metodologías/Yo SA.md>)
- [SOP Maestro](<SOP Maestro.md>)
