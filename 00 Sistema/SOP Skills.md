---
type: How-to
title: "SOP Skills"
tags: [sop, skills, ia, automatizacion, claude-code]
estado: 🟢 Activo
prioridad: 🔥 Alta
responsable: "{{OWNER}}"
id: "SOP-SKILLS-001"
timestamp: 2026-06-24T00:00:00Z
fecha_creacion: 2026-06-25
resource:
---

>[!info] Documentación relacionada
>[[Plantilla Skill]] | [SOP Prompts](<SOP Prompts.md>) | [SOP IA](<SOP IA.md>) | [AGENTS](<../AGENTS.md>) | MOC - IA con Claude

# SOP Skills

## Objetivo

Definir qué es una skill, dónde vive, cómo se documenta y cuándo crear una en lugar de un prompt.

Una skill en este sistema es un **comando ejecutable de Claude Code** que automatiza una tarea sobre el vault usando herramientas (leer archivos, buscar contenido, generar informes). No es un texto para copiar y pegar — es automatización.

---

## 1. Skill vs Prompt — diferencia clave

| | Prompt | Skill |
|---|---|---|
| Qué es | Texto reutilizable para uso manual | Comando ejecutable automatizado |
| Cómo se usa | Se copia y pega en cualquier IA | Se invoca con `/nombre` en Claude Code |
| Portabilidad | Funciona en Claude, GPT, Gemini | Solo funciona en Claude Code |
| Herramientas | No usa herramientas del sistema | Usa Read, Grep, Glob, Write, Edit, Bash |
| Output | Respuesta de texto | Puede crear archivos, editar notas, generar informes |
| Ubicación doc | `04 Knowledge/Prompts/` | `04 Knowledge/Skills/` |
| Ubicación exec | No aplica | `.claude/commands/` |

**Regla:** si necesitás que la IA haga algo automáticamente sobre el vault (leer, buscar, escribir), es una skill. Si es un texto que vos pasás manualmente a la IA, es un prompt.

---

## 2. Arquitectura de dos capas

Cada skill vive en **dos lugares**:

### Capa 1 — Ejecutable
```
.claude/commands/nombre-skill.md
```
Este archivo es lo que Claude Code ejecuta cuando invocás `/nombre-skill`. Contiene solo las instrucciones operativas (rol, contexto, tarea, restricciones, formato de salida).

### Capa 2 — Documentación
```
04 Knowledge/Skills/Skill - Nombre descriptivo.md
```
Este archivo vive en el vault. Contiene la documentación completa: objetivo, scope, herramientas, versiones, casos de prueba, limitaciones.

Ambos archivos deben mantenerse sincronizados. Si cambiás las instrucciones en `.claude/commands/`, actualizás la versión en `04 Knowledge/Skills/`.

---

## 3. Ubicación

### Ejecutable
```
.claude/commands/nombre-skill.md
```

### Documentación
```
04 Knowledge/Skills/Skill - {Nombre descriptivo}.md
```

**Por qué `04 Knowledge/Skills/` y no en `Prompts/`:**
Una skill no es un prompt. Es automatización con herramientas. Mezclarlos en `Prompts/` crearía confusión a medida que crece el catálogo. `Skills/` sigue el mismo patrón de subcarpetas que ya tiene `04 Knowledge` (`Cursos/`, `Prompts/`, `Temas/`, etc.).

---

## 4. Naming

### Archivo ejecutable
```
.claude/commands/cerebro-ce.md
.claude/commands/cerebro-re.md
.claude/commands/cerebro-bro.md
```
Formato: `kebab-case`, sin prefijo, descriptivo del dominio y la función.

### Archivo de documentación
```
Skill - Cerebro CE.md
Skill - Cerebro RE.md
Skill - Cerebro Audit.md
```
Formato: `Skill - Nombre descriptivo.md`. El nombre describe **qué hace**, no de dónde viene.

---

## 5. Plantilla

Plantilla obligatoria: [[Plantilla Skill]].

Bloques que SIEMPRE deben estar:
- Frontmatter completo (harness, tools_usadas, scope, estado, version).
- TL;DR.
- 🎯 Objetivo (input, output, quién invoca).
- 📝 Instrucciones (el contenido exacto del archivo ejecutable).
- 🔀 Variables / Argumentos.
- 🧪 Casos de prueba (mínimo 3).
- 🔄 Iteraciones / Versionado.

---

## 6. Ciclo de vida

| Estado | Significado | Acción |
|---|---|---|
| 🟨 Borrador | Instrucciones escritas, sin ejecutar | Probar con vault real |
| 🟦 En pruebas | Ejecutada al menos una vez | Validar output en 3+ casos |
| 🟩 Productivo | Output consistente en 5+ ejecuciones | Usar libremente |
| 🟥 Deprecado | Reemplazada por versión mejor | Mover doc a `99 Archivo/Skills/`, eliminar ejecutable de `.claude/commands/` |

---

## 7. Principios operativos de toda skill

Toda skill del Sistema Maestro debe respetar estos principios:

1. **Proponer, nunca aplicar sin aprobación.** La skill genera un informe o una nota de propuesta. {{OWNER}} decide qué aplicar.
2. **Nunca borrar archivos originales.** Solo crear notas nuevas con propuestas.
3. **Reportar sin abortar.** Si falta un archivo o el frontmatter está incompleto, reportarlo y seguir.
4. **Salida en markdown puro.** Sin HTML, sin formato propietario.
5. **Respetar el lenguaje del vault.** Usar términos del [Glosario de términos](<Glosario de términos.md>).

---

## 8. Cuándo crear una skill

Creá una skill cuando:
- La tarea requiere leer múltiples archivos del vault automáticamente.
- El resultado es un informe o una nota nueva (no solo una respuesta de texto).
- La tarea se repite periódicamente (auditoría, indexado, revisión).
- El proceso tiene pasos definidos que no cambian entre ejecuciones.

Usá un prompt cuando:
- Es una instrucción que pasás manualmente a la IA.
- El resultado es solo una respuesta de texto.
- La tarea varía mucho entre ejecuciones según el contexto.
- Necesita funcionar en otros modelos además de Claude Code.

---

## 9. Errores comunes

| Error | Por qué falla | Cómo evitarlo |
|---|---|---|
| Skill que modifica archivos sin propuesta previa | Viola el principio "proponer, nunca decidir" | Siempre generar nota de informe primero |
| No documentar en `04 Knowledge/Skills/` | La skill queda sin contexto ni versión | Crear doc antes de escribir el ejecutable |
| Instrucciones demasiado genéricas | El agente interpreta de formas distintas cada vez | Especificar pasos, formato de salida y restricciones |
| No sincronizar ejecutable y documentación | Las versiones se desalinean | Actualizar ambos juntos siempre |
| Mezclar skills de distintos dominios | Difícil de mantener | Una skill = una responsabilidad clara |

---

## 10. Flujo completo

```
Identificar necesidad de automatización
↓
Verificar que no existe ya una skill similar
↓
Crear doc en 04 Knowledge/Skills/ (Plantilla Skill)
  └─ Estado: Borrador
↓
Escribir instrucciones en .claude/commands/nombre.md
↓
Probar con vault real → documentar casos de prueba
  └─ Estado: En pruebas
↓
5+ ejecuciones consistentes
  └─ Estado: Productivo
↓
Enlazar desde MOC - IA con Claude
↓
Si se depreca → 99 Archivo/Skills/ + eliminar ejecutable
```

---

## 11. Cómo actualizar una skill

Cuando las instrucciones de una skill cambian (nuevo paso, formato de salida distinto, scope ampliado):

1. Editá el archivo ejecutable `.claude/commands/nombre-skill.md` con los cambios
2. Abrí `04 Knowledge/Skills/Skill - Nombre.md` y:
   - Actualizá la sección **📝 Instrucciones** si el comportamiento cambió
   - Subí la versión en el frontmatter (`version: v1.1`, `v2.0`, etc.)
   - Actualizá `fecha_actualizacion`
   - Agregá una fila en la tabla **🔄 Iteraciones / Versionado** con el cambio y el motivo
3. Si el cambio es estructural (nuevo scope, herramientas distintas), subir versión mayor (v1.0 → v2.0)
4. Si es un ajuste menor (redacción, restricción nueva), subir versión menor (v1.0 → v1.1)

**Regla:** ejecutable y documentación siempre sincronizados. Si cambiás uno, cambiás el otro.

---

## 12. Cómo deprecar o eliminar una skill

Cuando una skill queda obsoleta o es reemplazada por otra mejor:

1. En `04 Knowledge/Skills/Skill - Nombre.md`:
   - Cambiá `estado: 🟥 Deprecado` en el frontmatter
   - Anotá el motivo en la sección **🔄 Iteraciones / Versionado**
   - Si tiene reemplazo, enlazarlo en **🔗 Skills relacionadas**
2. Mové la nota de documentación a `99 Archivo/Skills/` (creá la carpeta si no existe)
3. Eliminá el archivo ejecutable de `.claude/commands/`
4. Verificá que ninguna otra nota del vault la siga referenciando como activa

**Regla:** nunca borrar la documentación — archivarla con motivo explícito. El ejecutable sí se elimina porque si queda en `.claude/commands/` sigue siendo invocable.

---

## 13. Flujo de las skills de auditoría (hallazgo → resolución → registro)

Algunas skills (Cerebro CE/RE/BRO, Cerebro Audit, Mantenimiento Sistema) no cambian nada: **auditan y dejan un informe**. Su flujo tiene una separación que es fácil de confundir.

### Los dos documentos distintos

| Documento | Qué es | Dónde vive |
|---|---|---|
| **El informe** | El **hallazgo** — qué se detectó ese día (foto fechada) | `05 Diario/Auditorías/Informe ... - YYYY-MM-DD.md` |
| **El changelog** | El **arreglo** — qué se cambió como consecuencia | Changelog del doc tocado + [CHANGELOG del Sistema](<CHANGELOG del Sistema.md>) |

> El informe es la **lista de tareas**. El changelog es el **registro de lo hecho**. Son cosas distintas: no se documenta el arreglo en el informe, ni el hallazgo en el changelog.

### El flujo completo

```
1. Skill corre → deja informe en 05 Diario/Auditorías/ (hallazgos)
2. Resolvemos en el chat, en la misma sesión, mientras el contexto está fresco
3. Por cada hallazgo resuelto:
   - se aplica el cambio al doc correspondiente
   - se actualiza el changelog de ese doc + su timestamp
   - si es estructural, se anota en CHANGELOG del Sistema
   - en el informe se marca ✅ resuelto / ⬜ pendiente
4. Si la sesión se corta a medias → el informe es el punto de retoma:
   "abrí el Informe del [fecha], seguimos con los pendientes"
```

### Cómo retomar una sesión a medias

El punto de retoma **siempre es el informe en `05 Diario/Auditorías/`**, nunca el changelog. El informe tiene la lista con estado ✅/⬜ por hallazgo. El changelog solo registra lo ya hecho; no sirve para saber qué falta.

**Regla:** una skill de auditoría **propone, nunca aplica**. Por eso correrla tiene riesgo cero: en el peor caso deja un informe que se ignora.

---

## Referencias

- [[Plantilla Skill]]
- [SOP Prompts](<SOP Prompts.md>)
- [SOP IA](<SOP IA.md>)
- [AGENTS](<../AGENTS.md>)
- MOC - IA con Claude
- [Glosario de términos](<Glosario de términos.md>)
