---
tipo_doc: How-to
tags: [skill, ia, claude-code, cerebro-digital, ce-re-bro, bloques, atomicidad]
origen: "[[Catálogo de Skills]]"
fecha_creacion: 2026-06-24
fecha_actualizacion: 2026-06-24
modelo_objetivo: claude-sonnet-4-6
version_modelo: claude-sonnet-4-6
categoria: Skill
subcategoria: CE-RE-BRO
caso_uso: Auditoría de estructura interna y atomicidad de notas
harness: claude-code
tools_usadas: [Glob, Read, Write]
scope: vault
domains: [ia, automatizacion]
version: v1.0
estado: 🟨 Borrador
---

# Skill | Cerebro BRO — Bloques Relacionados Organizados

> **TL;DR:** Analiza la estructura interna de las notas y detecta notas largas para dividir, ideas mezcladas, contenido duplicado y bloques sin cabecero. Genera un informe con propuestas de atomización.

---

## 🎯 Objetivo

Aplicar la dimensión **BRO (Bloques Relacionados Organizados)** de la metodología CE-RE-BRO al vault.

- **Input esperado:** Contenido de notas en `04 Knowledge/Temas/`, `04 Knowledge/Modelos Mentales/`, `02 MOCs/`
- **Output esperado:** Nota `05 Diario/Auditorías/Informe BRO - YYYY-MM-DD.md` con hallazgos y propuestas
- **Quién la invoca:** {{OWNER}} vía `/cerebro-bro`

---

## 🧩 Contexto de uso

- **¿Cuándo usarla?** Cuando el vault creció mucho y sospechás que las notas perdieron atomicidad. En la revisión mensual.
- **¿Cuándo NO usarla?** En notas del Diario — ahí la mezcla de ideas es intencional.
- **Dependencias:** Las notas deben usar cabeceros markdown (H1/H2/H3) para que el análisis estructural sea efectivo.
- **Flujo donde se integra:** Revisión mensual → `/cerebro-bro` → revisar informe → dividir o fusionar notas manualmente.

---

## 🔧 Scope y herramientas

| Herramienta | Para qué se usa |
|---|---|
| `Glob` | Listar todos los `.md` en carpetas objetivo |
| `Read` | Leer contenido completo para analizar estructura |
| `Write` | Crear la nota de informe |

**Carpetas que toca:**
- Lee: `04 Knowledge/Temas/`, `04 Knowledge/Modelos Mentales/`, `04 Knowledge/Sistemas y Metodologías/`, `02 MOCs/`
- Escribe: `05 Diario/Auditorías/Informe BRO - YYYY-MM-DD.md`
- No toca: `05 Diario/`, `06 Raw/`, `99 Archivo/`, `.claude/`

---

## 📝 Instrucciones

Ver archivo ejecutable: `.claude/commands/cerebro-bro.md`

**Qué detecta:**
1. Notas largas candidatas a dividir (150+ líneas o 5+ H2s)
2. Familias de notas similares con estructura interna distinta
3. Notas cuyo título no refleja el contenido real (ideas mezcladas)
4. Contenido duplicado entre notas distintas
5. Bloques extensos de texto sin cabecero H2/H3

---

## 🔀 Variables / Argumentos

| Variable | Tipo | Descripción | Ejemplo |
|---|---|---|---|
| `$ARGUMENTS` | string | Scope opcional | `--scope 04 Knowledge/Temas` |

---

## 🧪 Casos de prueba

| # | Condición | Output esperado | Resultado | Notas |
|---|---|---|---|---|
| 1 | Nota con 200 líneas y 6 H2s distintos | Aparece en "candidatas a dividir" con propuesta | 🟨 Pendiente | |
| 2 | Dos notas que explican el mismo concepto | Aparecen como posibles duplicados | 🟨 Pendiente | |
| 3 | Nota titulada "Zettelkasten" que también habla de GTD | Aparece en "ideas mezcladas" | 🟨 Pendiente | |

---

## 🔄 Iteraciones / Versionado

| Versión | Fecha | Cambio | Motivo | Resultado |
|---|---|---|---|---|
| v1.0 | 2026-06-24 | Versión inicial | Basada en metodología CE-RE-BRO de Marcos Emowe | Baseline |

---

## 🔗 Skills relacionadas

- [[Skill - Cerebro CE]] → conexiones entre notas
- [[Skill - Cerebro RE]] → reagrupamiento y metadatos
- [[Skill - Cerebro Audit]] → corre las tres dimensiones juntas

---

## 📖 Referencias

- [[SOP Skills]]
- Metodología CE-RE-BRO — Marcos Emowe (Cerebro Digital)
- Video: "Tres formas de organizar tus notas que el papel no permite"
