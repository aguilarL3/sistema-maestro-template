---
tipo_doc: How-to
tags: [SOP, estudio, aprendizaje]
estado: 🟢 Activo
prioridad: 🔥 Alta
domains: [bi, ia, automatizacion, ingles, negocio]
responsable: "{{OWNER}}"
id: "SOP-MASTER-STUDY-001"
ultima_revision: 2026-06-24
fecha_creacion: 2026-06-17
---

>[!info] Documentación
>Consulta la plantilla de apuntes: [[00 Sistema/001_plantillas/Plantilla Apunte Curso]] | Cronogramas: [[SOP Cronogramas de Estudio]] | Ubicación y ciclo de vida de apuntes: [[SOP Cursos y Apuntes]] | Prompts: [[SOP Prompts]]

> [!warning] Cambio de flujo aplicado 2026-06-24
> La **ubicación física** de los apuntes y prompts cambió. El flujo conceptual de las 5 fases sigue intacto; solo cambia dónde vive cada artefacto:
>
> - **Apuntes de clase:** ahora en `04 Knowledge/Cursos/{Nombre del Curso}/` (antes se acumulaban en `05 Diario/`).
> - **Prompts:** ahora en `04 Knowledge/Prompts/` (antes en `05 Diario/`).
> - **`05 Diario/`:** vuelve a su definición original — solo daily notes operativos (hábitos, prioridades, reflexiones).
>
> Detalle completo en [[SOP Cursos y Apuntes]] y [[SOP Prompts]]. Los apuntes y prompts ya creados se migran manualmente desde Obsidian (arrastrar el archivo a la nueva carpeta — Obsidian actualiza los `[[links]]` automáticamente).

# SOP — Sistema Maestro de Estudio

## Objetivo

Construir un sistema de aprendizaje conectado, acumulativo y aplicado orientado a:
- Business Intelligence
- Automatización e IA
- Product Management
- Empleabilidad y portfolio profesional

**El objetivo NO es consumir cursos.**
El objetivo es transformar conocimiento en dashboards, automatizaciones, sistemas y evidencia profesional.

---

## Sistema ideal de estudio

```
Curso
↓
Nota de clase (Plantilla Apunte Curso) → 04 Knowledge/Cursos/{Curso}/
   └─ Si la clase trae prompts → 04 Knowledge/Prompts/ (Plantilla Prompt)
↓
Nota atómica en 04 Knowledge/Temas/ (si el concepto aparece 3+ veces)
↓
Aplicación en proyecto real (03 Proyectos)
↓
Evidencia portfolio → LinkedIn / CV
```

---

## Fase 1 — Aprendizaje diario

### Inicio con IA
Usá Claude o ChatGPT como mentor técnico al inicio del día:

```
Rutina diaria:
Áreas: BI & Analytics / Automatización & IA / Ingeniería Industrial
Objetivo: mejorar empleabilidad BI + IA

Quiero:
- 3 a 5 conceptos importantes
- conexiones entre áreas
- ejemplos reales
- mini ejercicios
- preguntas tipo entrevista
- aplicaciones reales
```

### Resultado esperado
- conceptos clave con relaciones
- ejemplos y casos reales
- ejercicios prácticos
- preguntas técnicas de entrevista

---

## Fase 2 — Captura rápida

Capturar conocimiento bruto SIN intentar organizar perfecto.

**Qué crear:**
- **Daily Note** (`05 Diario/`): para conceptos rápidos, ideas, insights, dudas
- **Nota de Curso** (`04 Knowledge/Cursos/{Curso}/`, con [[Plantilla Apunte Curso]]): para clases, videos, laboratorios
- **Prompt** (`04 Knowledge/Prompts/`, con [[Plantilla Prompt]]): si la clase trae un prompt que vale la pena versionar

**Regla:** NO crear notas atómicas por todo. La captura es temporal.

---

## Fase 3 — Extracción de conocimiento

Transformar conocimiento repetido en conocimiento permanente.

**Cuándo crear nota atómica en `04 Knowledge/Temas/`:**
- aparece 3+ veces en distintas fuentes
- conecta dos o más áreas
- se usa de forma recurrente
- tiene alto valor práctico

**Ejemplo:**
```
Captura: webhooks en n8n / webhooks en APIs / webhooks en automatización
                               ↓
         Nota atómica: [[Webhook]] en 04 Knowledge/Temas/
```

---

## Fase 4 — Aplicación práctica

Todo aprendizaje importante debe terminar en:
- mini proyecto / caso práctico
- automatización funcional
- dashboard real
- documentación reutilizable

---

## Fase 5 — Conexión sistémica

Conectar siempre:
- BI ↔ IA ↔ negocio ↔ operaciones ↔ automatización

NO estudiar áreas de forma aislada.

---

## Cómo pedir tareas a la IA

```
Genera tareas para hoy:
- Power BI / SQL / Automatización
- Duración: 4 horas
```

```
Dame tareas para avanzar portfolio BI + automatización
```

```
Simula entrevista para: Business Intelligence Analyst
```

---

## Troubleshooting

| Problema | Acción |
|---|---|
| Demasiadas notas sin procesar | Consolidar, extraer conceptos, eliminar duplicados |
| Demasiados cursos simultáneos | Reducir foco, priorizar portfolio y proyectos reales |
| Estudiar sin aplicar | Crear mini proyecto inmediato con dataset real |
| Sistema demasiado complejo | Volver al MOC principal, simplificar |

---

## Referencias
- [[SOP Cursos y Apuntes]]
- [[SOP Prompts]]
- [[Dashboard-Estudio]]
- [[SOP Cronogramas de Estudio]]
- [[SOP Aprendizaje con IA]]
- MOC - Master Learning System
- [[02 MOCs/MOC - BI Analytics]]
- [[02 MOCs/MOC - Automatizacion IA]]
- MOC - IA con Claude
- [[02 MOCs/MOC - Prompt Engineering]]
