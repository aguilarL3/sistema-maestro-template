---
tipo_doc: Indice
estado: 🟢 Activo
fecha_creacion: 2026-06-17
ultima_revision: 2026-06-26
---

# Raw

Fuentes originales sin procesar — el **input** que recibís de afuera, no lo que vos producís.

## Qué entra aquí
- libros (PDF, EPUB)
- PDFs y documentos descargados
- **material original de cursos** (videos, slides, transcripciones, ejercicios, datasets entregados por el curso)
- artículos y posts guardados
- datasets crudos
- capturas de pantalla
- notas en bruto pegadas sin procesar
- transcripciones de audio o video

## Qué NO entra aquí
- **Apuntes de clase** (los escribiste vos con [[Plantilla Apunte Curso]]) → `04 Knowledge/Cursos/{Curso}/`
- **Notas atómicas** procesadas → `04 Knowledge/Temas/`
- **Prompts versionados** → `04 Knowledge/Prompts/`
- **Daily notes** → `05 Diario/`

## Regla práctica

> Si lo creó otro (video, PDF, slides, transcripción de un curso) → vive acá.
> Si lo escribiste vos (apunte, síntesis, nota, prompt) → vive en `04 Knowledge`.

## Por qué existe esta capa separada
Karpathy / LLM Wiki distingue claramente entre **Raw Sources** (información cruda) y **Wiki** (conocimiento compilado). Mezclarlos rompe la cadena de transformación del sistema: `Información → Conocimiento → Acción`.

El material original puede ser consultado, citado y revisitado, pero **no se reescribe**. Lo que se reescribe y se mantiene vivo es el conocimiento procesado en `04 Knowledge`.

## Convención de organización
Subcarpetas opcionales por tipo o por origen:

```
06 Raw/
├─ Cursos/{Nombre del Curso}/   → videos, slides, PDFs del curso
├─ Libros/                       → PDFs/EPUBs
├─ Artículos/                    → posts y papers descargados
├─ Datasets/                     → CSVs y datos crudos
└─ Capturas/                     → screenshots para procesar después
```

No forzar la estructura — crear la subcarpeta cuando ya tengas 3+ archivos del mismo tipo.

## Referencias
- [[SOP Maestro]] (sección 5 — qué hace cada capa)
- [[SOP Cursos y Apuntes]] (distinción Raw vs Knowledge para cursos)
- [[LLM Wiki]] (origen conceptual de Raw Sources vs Wiki)
