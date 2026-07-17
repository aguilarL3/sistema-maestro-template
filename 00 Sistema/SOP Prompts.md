---
type: How-to
title: "SOP Prompts"
tags: [sop, prompts, prompt-engineering, ia]
estado: 🟢 Activo
prioridad: 🔥 Alta
responsable: "{{OWNER}}"
id: "SOP-PROMPTS-001"
timestamp: 2026-06-24T00:00:00Z
fecha_creacion: 2026-06-24
resource:
---

>[!info] Documentación relacionada
>[[Plantilla Prompt]] | [SOP Cursos y Apuntes](<SOP Cursos y Apuntes.md>) | [SOP Notas Atómicas](<SOP Notas Atómicas.md>) | [SOP IA](<SOP IA.md>) | [[02 MOCs/MOC - Prompt Engineering]]

# SOP Prompts

## Objetivo

Definir dónde viven los prompts, cómo se versionan, cuándo se promueven a nota atómica y cuándo se dan de baja.

Un prompt en este sistema es un **artefacto reutilizable y auditable**, no un copy-paste desechable.

---

## 1. Ubicación

Todos los prompts viven en:

```
04 Knowledge/Prompts/Prompt - {Nombre descriptivo}.md
```

**Estructura plana** — sin subcarpetas. La organización por **caso de uso** y por **técnica** vive en [[02 MOCs/MOC - Prompt Engineering]] (que cruza ambos índices).

**Por qué `04 Knowledge` y no en una carpeta separada:**
Un prompt es conocimiento reutilizable — encaja en la misma capa que las notas atómicas, los modelos mentales y los apuntes procesados. Crear `07 Prompts/` violaría la simplicidad del sistema (las 8 capas son inamovibles según [Matriz Definitiva](<../Matriz Definitiva.md>)).

---

## 2. Naming

Formato exacto:

```
Prompt - Nombre descriptivo.md
```

Ejemplos válidos:
- `Prompt - Búsqueda Web Estructurada.md`
- `Prompt - Entrevista Previa (Claude Pregunta por Vos).md`

Regla: el nombre debe describir **qué hace**, no de dónde viene. `Prompt - Clase 1.2.md` es un mal nombre.

---

## 3. Plantilla

Plantilla obligatoria: [[Plantilla Prompt]].

Bloques que SIEMPRE deben estar:
- Frontmatter completo (modelo objetivo, versión, técnicas, estado, performance).
- TL;DR.
- 🎯 Objetivo.
- 📝 Prompt (con código markdown).
- 🔄 Iteraciones / Versionado.
- 📖 Referencias (mínimo la clase / fuente de origen).

---

## 4. Versionado

### Cuando el prompt viene de una clase

Conviven **dos versiones** en la misma nota, en la sección **📝 Prompt**:

- **v1.0 — original de la clase.** Tal cual lo dictó el curso, sin retoques.
- **v2.0 (o superior) — versión mejorada.** Refactor con técnicas explícitas (role prompting, structured output, constraints, etc.).

La justificación de los cambios va en la sección **🔄 Iteraciones / Versionado**, con tabla resumen + subsección "Qué se mejoró de vX a vY y por qué" con razones numeradas.

### Cuándo subir versión mayor (vN → vN+1.0) vs menor (vN.X)

| Cambio | Subir a |
|---|---|
| Refactor estructural (cambio de bloques, formato de salida, técnica principal) | Versión mayor (v1.0 → v2.0) |
| Ajuste de ejemplos few-shot, tono, constraints menores | Versión menor (v2.0 → v2.1) |
| Migración a otro modelo (Claude → GPT) que cambia la sintaxis del prompt | Versión mayor con nota explícita |
| Fix tipográfico, mejora de redacción sin cambio de comportamiento | No subir versión, anotar en cambios sin tabla nueva |

---

## 5. Ciclo de vida

Estados posibles (campo `estado` del frontmatter):

| Estado | Significado | Acción |
|---|---|---|
| 🟨 Borrador | Versión inicial, sin ejecutar todavía | Probar con 1 input real |
| 🟦 En pruebas | Ejecutado al menos una vez, en validación | Casos de prueba 1-5, medir métricas |
| 🟩 Productivo | Probado en 5+ inputs, output consistente | Usar libremente, considerar atomizar técnicas |
| 🟥 Deprecado | Reemplazado por una versión mejor o por un patrón superior | Mover a `99 Archivo/Prompts/` con motivo |

**Regla mínima para Productivo:** 5+ ejecuciones reales documentadas en la sección "Casos de prueba".

---

## 6. Cuándo promover una técnica a nota atómica

Cuando una **técnica de prompt engineering** se aplica en 3+ prompts del catálogo, crear nota atómica en `04 Knowledge/Temas/` y enlazarla desde el índice cruzado por técnica del [[MOC - Prompt Engineering]].

Ejemplos:
- `[[Role prompting]]` — aparece en 3+ prompts → nota atómica.
- `[[Structured output]]` — idem.
- `[[Meta-prompting]]` — idem cuando se acumulen 3 casos.

Esto es la aplicación del criterio de [SOP Notas Atómicas](<SOP Notas Atómicas.md>) al dominio de prompts.

---

## 7. Archivado de prompts

Mover un prompt a `99 Archivo/Prompts/` cuando:
- Su estado es 🟥 Deprecado.
- Existe una versión superior que lo reemplaza completamente.
- El caso de uso desapareció (ej. el modelo cambió y el prompt ya no es portable).

Antes de archivar:
1. Anotar el motivo en la sección "Iteraciones / Versionado".
2. Verificar que el [[MOC - Prompt Engineering]] no lo siga referenciando como activo.
3. Si tiene reemplazo, enlazarlo desde "Prompts relacionados".

**Regla:** no borrar nunca. Archivar con motivo explícito.

---

## 8. Errores comunes

| Error | Por qué falla | Cómo evitarlo |
|---|---|---|
| Prompt embebido dentro del apunte | No es reutilizable ni versionable | Extraer a su propia nota desde el primer uso |
| Saltar v1.0 y publicar solo la "mejorada" | Se pierde el contexto pedagógico y la posibilidad de iteración comparada | Documentar siempre la original aunque parezca débil |
| Marcar como Productivo sin pruebas | Falso sentido de confianza | Mínimo 5 ejecuciones documentadas |
| No registrar el modelo exacto | Los prompts no son portables 1:1 entre modelos | Campo `version_modelo` obligatorio |
| Cambiar el prompt y no subir versión | Se pierde la trazabilidad | Aplicar criterio del punto 4 |

---

## 9. Flujo completo

```
Clase con prompt
↓
Crear nota Prompt - X en 04 Knowledge/Prompts/
  ├─ v1.0 = original de la clase
  └─ v2.0 = mejorada con técnicas
↓
Enlazar desde el apunte (sección Ejemplos)
↓
Enlazar desde MOC - Prompt Engineering (caso de uso + técnicas)
↓
Probar → casos de prueba documentados
↓
Estado: Borrador → En pruebas → Productivo
↓
Si técnica se repite 3+ veces → nota atómica en Temas/
↓
Cuando se deprecre → 99 Archivo/Prompts/ con motivo
```

---

## 10. Anotación de cambio de flujo

> **SOP creado 2026-06-24.** Antes de esta fecha, los prompts se guardaban en `05 Diario/` por falta de SOP específico. La migración de los prompts existentes es manual desde Obsidian para preservar enlaces.

---

## Referencias

- [[Plantilla Prompt]]
- [SOP Cursos y Apuntes](<SOP Cursos y Apuntes.md>)
- [SOP Notas Atómicas](<SOP Notas Atómicas.md>)
- [SOP IA](<SOP IA.md>)
- [[02 MOCs/MOC - Prompt Engineering]]
- MOC - IA con Claude
