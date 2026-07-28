---
type: How-to
title: "Skill | Cerebro Index — Índice del Cerebro Digital"
tags: [skill, ia, claude-code, cerebro-digital, index, navegacion, tokens]
origen: "[[Catálogo de Skills]]"
fecha_creacion: 2026-06-24
generated:
  by: human:{{OWNER}}
  at: 2026-06-24T00:00:00Z
fecha_actualizacion: 2026-06-24
modelo_objetivo: claude-sonnet-4-6
version_modelo: claude-sonnet-4-6
categoria: Skill
subcategoria: CE-RE-BRO
caso_uso: Generar o actualizar el índice de navegación del cerebro digital
harness: claude-code
tools_usadas: [Glob, Read, Grep, Write]
scope: vault
domains: [ia, automatizacion]
version: v1.0
estado: 🟨 Borrador
resource:
---

# Skill | Cerebro Index — Índice del Cerebro Digital

> **TL;DR:** Genera o actualiza un índice de navegación del vault que permite a cualquier agente encontrar información gastando el mínimo de tokens. Es la capa de orientación para la IA.

---

## 🎯 Objetivo

Crear un mapa de rutas del vault que guíe al agente de IA hacia la información correcta sin tener que explorar carpeta por carpeta.

- **Input esperado:** Estructura actual del vault (`01 Index/`, `02 MOCs/`, `04 Knowledge/`, `AGENTS.md`, `Dashboard-CEO.md`)
- **Output esperado:** Nota `01 Index/Índice del Cerebro Digital.md` creada o actualizada
- **Quién la invoca:** {{OWNER}} vía `/cerebro-index`

---

## 🧩 Contexto de uso

- **¿Cuándo usarla?** Después de una reorganización del vault, cuando se agregan nuevos MOCs o áreas, o en la revisión mensual.
- **¿Cuándo NO usarla?** Si el vault cambió hace menos de una semana — esperá a que la estructura se estabilice.
- **Dependencias:** Los MOCs deben existir en `02 MOCs/` para que el índice tenga rutas reales.
- **Flujo donde se integra:** Reorganización → `/cerebro-index` → índice actualizado → el agente lo lee antes de buscar.

---

## 🔧 Scope y herramientas

| Herramienta | Para qué se usa |
|---|---|
| `Glob` | Listar MOCs, índices y archivos clave |
| `Read` | Leer MOCs para extraer qué temas cubren |
| `Grep` | Buscar `life_areas` y `domains` en frontmatter |
| `Write` | Crear o actualizar el índice |

**Carpetas que toca:**
- Lee: `01 Index/`, `02 MOCs/`, `04 Knowledge/`, `AGENTS.md`, `Dashboard-CEO.md`
- Escribe: `01 Index/Índice del Cerebro Digital.md`
- No toca: `05 Diario/`, `06 Raw/`, `99 Archivo/`

---

## 📝 Instrucciones

Ver archivo ejecutable: `.claude/commands/cerebro-index.md`

**Qué construye:**
1. Mapa de rutas por área de vida (profesional, salud, finanzas, relaciones, personal)
2. Mapa de rutas por dominio de conocimiento (IA, BI, inglés, negocios, etc.)
3. Lista de archivos raíz clave con su función
4. Lista de MOCs disponibles
5. Proyectos activos
6. Notas más enlazadas en Knowledge

---

## 🔀 Variables / Argumentos

| Variable | Tipo | Descripción | Ejemplo |
|---|---|---|---|
| `$ARGUMENTS` | string | Forzar actualización completa | `--rebuild` |

---

## 🧪 Casos de prueba

| # | Condición | Output esperado | Resultado | Notas |
|---|---|---|---|---|
| 1 | Vault con 5+ MOCs existentes | Índice con rutas reales para cada área | 🟨 Pendiente | |
| 2 | MOC referenciado que no existe | Aparece como `(pendiente)` en el índice | 🟨 Pendiente | |
| 3 | Índice ya existe | Se actualiza sin borrar contenido válido | 🟨 Pendiente | |

---

## 🔄 Iteraciones / Versionado

| Versión | Fecha | Cambio | Motivo | Resultado |
|---|---|---|---|---|
| v1.0 | 2026-06-24 | Versión inicial | Basada en concepto LLM Wiki de Andrej Karpathy | Baseline |

---

## 🔗 Skills relacionadas

- [Skill - Cerebro Audit](<Skill - Cerebro Audit.md>) → diagnóstico completo que usa el índice como base
- [Skill - Cerebro CE](<Skill - Cerebro CE.md>) → conexiones que el índice debe reflejar

---

## 📖 Referencias

- [SOP Skills](<../../00 Sistema/SOP Skills.md>)
- [SOP Index](<../../00 Sistema/SOP Index.md>)
- LLM Wiki — Andrej Karpathy
- Video: "¿Un Agente de IA que te acompañe toda la vida? Así se construye"
