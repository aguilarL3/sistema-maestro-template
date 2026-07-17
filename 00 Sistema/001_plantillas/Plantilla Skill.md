---
type: Plantilla
title: "Skill | [Nombre de la Skill]"
tags: [skill, ia, claude-code, automatizacion]
estado: 🟨 Borrador / 🟦 En pruebas / 🟩 Productivo / 🟥 Deprecado
fecha_creacion: YYYY-MM-DD
timestamp: 2026-06-26T00:00:00Z
origen: "[[Catálogo de Skills]]"
fecha_actualizacion: YYYY-MM-DD
modelo_objetivo: claude-sonnet-4-6 / claude-haiku-4-5 / claude-opus-4-8
version_modelo: claude-sonnet-4-6
categoria: Skill
subcategoria: ...
caso_uso: ...
harness: claude-code
tools_usadas: [Read, Grep, Glob, Edit, Write, Bash]
scope: vault / proyecto / archivo
version: v1.0
domains: []
resource:
---

# Skill | [Nombre de la Skill]

> **TL;DR:** Una línea que describa qué hace esta skill, qué analiza y qué produce.

---

## 🎯 Objetivo

¿Qué problema resuelve esta skill? ¿Qué resultado produce?

- **Input esperado:** (archivos, carpeta, argumentos del usuario)
- **Output esperado:** (nota nueva, informe en consola, edición de archivo)
- **Quién la invoca:** {{OWNER}} vía `/nombre-skill`

---

## 🧩 Contexto de uso

- **¿Cuándo usarla?** ...
- **¿Cuándo NO usarla?** ...
- **Dependencias / Prerrequisitos:** (estructura del vault, frontmatter esperado, etc.)
- **Flujo donde se integra:** ...

---

## 🔧 Scope y herramientas

| Herramienta | Para qué se usa en esta skill |
|---|---|
| `Glob` | Buscar archivos por patrón |
| `Grep` | Buscar contenido dentro de archivos |
| `Read` | Leer archivos específicos |
| `Write` | Crear nota de informe |
| `Edit` | Modificar archivos (solo si el modo es auto-apply) |
| `Bash` | Comandos de sistema si es necesario |

**Carpetas que toca:**
- Lee: `...`
- Escribe: `...`
- No toca: `...`

---

## 📝 Instrucciones (contenido del comando)

> Este bloque es lo que vive en `.claude/commands/nombre-skill.md`

```markdown
[ROL]
Actúa como un auditor experto del vault Sistema Maestro de {{OWNER}}.

[CONTEXTO]
{descripción del contexto que la skill necesita conocer}

[TAREA]
Tu tarea es {acción principal}. Para esto:
1. Paso 1
2. Paso 2
3. Paso 3

[RESTRICCIONES]
- Nunca modificar archivos originales sin aprobación explícita
- Siempre proponer, nunca decidir solo
- Salida en markdown puro, sin HTML
- Si no encontrás un archivo esperado, reportarlo sin abortar

[FORMATO DE SALIDA]
Crea una nota nueva en {ruta destino} con esta estructura:
{esquema de la nota de salida}

[ARGUMENTOS]
$ARGUMENTS
```

---

## 🔀 Variables / Argumentos

| Variable | Tipo | Descripción | Ejemplo |
|---|---|---|---|
| `$ARGUMENTS` | string | Parámetros opcionales que el usuario pasa al invocar | `--scope 02 MOCs` |

---

## 🧪 Ejemplo de invocación

```
/nombre-skill
/nombre-skill --scope 04 Knowledge/Temas
```

**Output esperado:**
```
[descripción del resultado ideal]
```

---

## 🎲 Casos de prueba

| # | Condición | Output esperado | Resultado | Notas |
|---|---|---|---|---|
| 1 | Vault con 50+ notas | Informe con hallazgos priorizados | ✅ | |
| 2 | Vault vacío / carpeta sin notas | Mensaje "sin hallazgos" claro | ⚠️ | |
| 3 | Archivo con frontmatter incompleto | Lo reporta sin abortar | ✅ | |

---

## 🔄 Iteraciones / Versionado

| Versión | Fecha | Cambio | Motivo | Resultado |
|---|---|---|---|---|
| v1.0 | YYYY-MM-DD | Versión inicial | — | Baseline |

---

## 🚫 Limitaciones conocidas

- No funciona bien cuando...
- Tiende a omitir...
- Sensible a la estructura de frontmatter

---

## 🔗 Skills relacionadas

- [[Skill - nombre relacionada]] → se ejecuta antes/después
- [[Prompt - nombre relacionado]] → versión manual equivalente

---

## 📖 Referencias

- [[SOP Skills]]
- [[AGENTS]]
- Fuente / inspiración: ...

---

◀ [[Skill Anterior]] | MOC: [[Catálogo de Skills]] | [[Skill Siguiente]] ▶
