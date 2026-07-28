---
type: Explanation
title: "Investigación y auditoría de marcos"
description: "Qué aporta cada marco estudiado (LLM Wiki, OKF, GTD, PARA…), su fuente original, qué se adoptó y qué no."
tags: [investigacion, auditoria, sistema]
estado: 🟢 Activo
fecha_creacion: 2026-06-17
generated:
  by: human:{{OWNER}}
  at: 2026-07-17T00:00:00Z
id: "EXP-003"
resource:
---

# Investigación y auditoría de marcos

>[!info] El triángulo fundacional (una fuente de verdad por pregunta — consolidación 2026-07-11)
>**Este documento = el ESTUDIO** (qué dice cada marco, su auditoría a fondo). · La **decisión** de por qué cada uno está en el sistema y qué se adoptó/descartó → [Filosofía del Sistema](<../../00 Sistema/Filosofía del Sistema.md>). · El **manual de uso** del vault → [SOP Maestro](<../../00 Sistema/SOP Maestro.md>).

Este documento resume la investigación base que dio forma al vault y explica qué aporta cada marco, qué se adoptó y qué no.

## Cómo leer esta investigación
No es una lista de nombres.  
Es una comparación de marcos para decidir qué pieza vive en el sistema y por qué.

---

## 1. Karpathy / LLM Wiki

**Fuente original:** Andrej Karpathy — [gist "LLM Wiki"](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f). Estudio en el vault: [LLM Wiki](<../Sistemas y Metodologías/LLM Wiki.md>).

### Qué aporta
- arquitectura por capas
- separación entre fuentes crudas y wiki
- schema como reglas del sistema
- index como navegación
- agentes para mantener y auditar

### Qué adoptamos
- `06 Raw`
- `04 Knowledge`
- `00 Sistema`
- `01 Index`
- `AGENTS.md`

### Qué no adoptamos
- complejidad innecesaria
- sobreingeniería
- dependencia de una sola herramienta o interfaz

### Cómo se usa aquí
Como arquitectura base del vault.

> **2026-07-16 — el marco se volvió estándar:** Google Cloud publicó el [Open Knowledge Format (OKF)](<../Sistemas y Metodologías/Open Knowledge Format (OKF).md>) (jun 2026), la formalización vendor-neutral de este patrón LLM Wiki. **2026-07-17 — el vault lo adoptó por completo** (migración total): ver el marco 10 de esta investigación.

---

## 2. Cerebro Digital (Emowe)

**Fuente original:** Marcos Emowe — [cerebrodigital.club](https://www.cerebrodigital.club). Estudio en el vault: [Cerebro Digital](<../Sistemas y Metodologías/Cerebro Digital.md>).

### Qué aporta
- visión de sistema operativo personal
- valores, principios, visión, objetivos
- diario como centro operativo
- hábitos como seguimiento
- modelos mentales
- notas fuente
- notas estructurales
- revisión continua
- portabilidad y markdown

### Qué adoptamos
- `00 Sistema/Valores`
- `00 Sistema/Principios`
- `01 Index/Vision`
- `01 Index/Objetivos`
- `05 Diario`
- `04 Knowledge/Modelos Mentales`
- `00 Sistema/SOP Diario`
- `00 Sistema/SOP Revisiones`

### Qué no adoptamos
- exceso de secciones obligatorias
- carga de diario demasiado pesada
- copiar la estructura física literal de Zettelkasten

### Cómo se usa aquí
Como capa de operación personal, reflexión y autogestión.

---

## 3. Yo S.A. (Rubén Loan)

**Fuente original:** Rubén Loan — [curso Yo S.A.](https://rubenloan.com/cursos/yo-sa). Estudio en el vault: [Yo SA](<../Sistemas y Metodologías/Yo SA.md>).

### Qué aporta
- foco
- orden
- gobernanza personal
- vida por áreas
- revisión de objetivos
- relación entre vida y sistema

### Qué adoptamos
- `01 Index/Dashboard CEO`
- `01 Index/Mapa Personal`
- `00 Sistema/SOP Áreas`
- `life_areas`
- revisión de dirección personal

### Qué no adoptamos
- demasiadas áreas sin criterio
- capas redundantes que solo cambian de nombre

### Cómo se usa aquí
Como capa de dirección personal y profesional.

---

## 4. Career OS

**Fuente original:** curso Career OS (material del curso; sin URL pública). Estudio en el vault: [Career OS](<../Sistemas y Metodologías/Career OS.md>).

### Qué aporta
- convertir aprendizaje en evidencia profesional visible
- skills documentados y demostrables
- portfolio de proyectos reales
- historias para entrevistas
- CV actualizado con evidencia concreta
- conexión entre conocimiento y empleabilidad

### Qué adoptamos
- dashboard de carrera en `01 Index`
- notas conectadas explícitamente a experiencia real
- proyectos en `03 Proyectos` como evidencia demostrable
- objetivos profesionales diferenciados en Index

### Qué no adoptamos
- convertir todo el aprendizaje en contenido público obligatorio
- optimizar solo para empleabilidad a costa del aprendizaje real

### Cómo se usa aquí
Como capa de salida profesional: todo lo que se aprende debe poder convertirse en evidencia demostrable.

---

## 5. Zettelkasten

**Fuente original:** Niklas Luhmann — ensayo *"Kommunikation mit Zettelkästen"*; sitio de referencia [zettelkasten.de](https://zettelkasten.de). Estudio en el vault: [Zettelkasten](<../Sistemas y Metodologías/Zettelkasten.md>).

### Qué aporta
- atomicidad
- conectividad
- pensamiento emergente
- backlinks
- notas enlazadas
- diálogo entre ideas

### Qué adoptamos
- notas atómicas
- backlinks
- MOCs
- notas evergreen
- notas modelo mental

### Qué no adoptamos
- folgezettel físico literal
- rigidez histórica no compatible con digital

### Cómo se usa aquí
Como motor de conexión y de crecimiento del conocimiento.

---

## 6. PARA

**Fuente original:** Tiago Forte — [artículo original de PARA](https://fortelabs.com/blog/para/) y el libro *Building a Second Brain*. Estudio en el vault: [PARA](<../Sistemas y Metodologías/PARA.md>).

### Qué aporta
- clasificación práctica
- proyectos
- áreas
- recursos
- archivo

### Qué adoptamos
- `03 Proyectos`
- `06 Raw`
- `99 Archivo`
- idea de áreas como clasificación

### Qué no adoptamos
- convertir el vault en una taxonomía de carpetas
- depender solo de la clasificación jerárquica

### Cómo se usa aquí
Como marco de organización práctica, no como sistema dominante.

---

## 7. GTD

**Fuente original:** David Allen — libro *Getting Things Done* (2001); [gettingthingsdone.com](https://gettingthingsdone.com). Estudio en el vault: [GTD](<../Sistemas y Metodologías/GTD.md>).

### Qué aporta
- captura
- clarificación
- organización
- revisión
- ejecución

### Qué adoptamos
- captura rápida
- revisión regular
- próxima acción
- claridad operativa

### Qué no adoptamos
- convertir el sistema en una lista de tareas infinita

### Cómo se usa aquí
Como lógica de flujo y no como sistema completo aislado.

---

## 8. Evergreen Notes

**Fuente original:** Andy Matuschak — [notes.andymatuschak.org/Evergreen_notes](https://notes.andymatuschak.org/Evergreen_notes). Estudio en el vault: [Evergreen Notes](<../Sistemas y Metodologías/Evergreen Notes.md>).

### Qué aporta
- conocimiento vivo
- notas en evolución
- revisión continua
- aprendizaje acumulativo

### Qué adoptamos
- `00 Sistema/SOP Evergreen Notes`
- `00 Sistema/Plantilla Nota Evergreen`
- revisión de notas con el tiempo

### Qué no adoptamos
- notas estáticas congeladas

### Cómo se usa aquí
Como capa de maduración del conocimiento.

---

## 9. CE-RE-BRO

**Fuente original:** concepto propio del Sistema Maestro (adaptado desde Cerebro Digital durante el diseño del vault; sin fuente externa). Estudio en el vault: [CE-RE-BRO](<../Sistemas y Metodologías/CE-RE-BRO.md>).

### Qué aporta
- auditoría
- conexión
- reagrupación
- descomposición

### Qué adoptamos
- revisión del vault
- detección de huecos
- detección de duplicados
- detección de notas demasiado largas

### Qué no adoptamos
- convertirlo en burocracia

### Cómo se usa aquí
Como mecanismo de saneamiento y mejora.

---

## 10. Open Knowledge Format (OKF)

**Fuente original:** Google Cloud (jun 2026) — [Spec v0.1](https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md) · [repo `knowledge-catalog`](https://github.com/GoogleCloudPlatform/knowledge-catalog) (agentes de referencia + bundles reales) · [blog de lanzamiento](https://cloud.google.com/blog/products/data-analytics/how-the-open-knowledge-format-can-improve-data-sharing). Estudio en el vault: [Open Knowledge Format (OKF)](<../Sistemas y Metodologías/Open Knowledge Format (OKF).md>).

### Qué aporta
- la formalización vendor-neutral del patrón LLM Wiki (marco 1): conocimiento como bundle de Markdown + frontmatter YAML + grafo de enlaces
- vocabulario estándar de frontmatter: `type`, `timestamp`, `title`, `description`, `resource`
- índices por directorio (`index.md`) como artefactos generados — *progressive disclosure* para agentes
- enlaces rotos tolerados como "conocimiento aún no escrito" (validación literal de la práctica del vault)
- un contrato interoperable: el conocimiento puede viajar entre sistemas, harness y organizaciones

### Qué adoptamos (el framework es OKF-literal desde v1.0.0)
- el vocabulario de frontmatter completo en todas las notas (`tipo_doc`→`type`, `ultima_revision`→`timestamp`, + `title`, `description`, `resource`)
- `index.md` generados por script (`generate-index.py`, cableado al pre-commit) en vez de índices a mano
- convención de enlaces: markdown `[Título](<ruta.md>)` para conocimiento existente · wikilink `[[...]]` para promesas
- la disciplina editorial del reference agent (test de 4 puertas, aumentación sin reescribir) en las skills de estudio

### Qué no adoptamos
- slugs en los nombres de archivo fuente (solo aplican al export a bundle)
- `log.md` descentralizado por carpeta (el vault centraliza en CHANGELOG + bitácora)
- el pipeline BigQuery de Google (acá la fuente de verdad son las notas mismas, no una base de datos)

### Cómo se usa aquí
Como contrato de interoperabilidad: el vault es OKF-literal por dentro y exportable como bundle. El detalle operativo (frontmatter §4, enlaces §6.1, índices) vive en [SOP Documentación](<../../00 Sistema/SOP Documentación.md>); el estándar completo en [Open Knowledge Format (OKF)](<../Sistemas y Metodologías/Open Knowledge Format (OKF).md>).

---

## 11. Conclusión
El vault final debe ser:
- portable
- entendible
- navegable
- revisable
- compatible con IA
- útil para vida y carrera

Y sobre todo:
- fácil de empezar
- fácil de mantener
- fácil de volver a entender
