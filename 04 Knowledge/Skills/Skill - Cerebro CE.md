---
type: How-to
title: "Skill | Cerebro CE — Conectar Elementos"
tags: [skill, ia, claude-code, cerebro-digital, ce-re-bro, conectar]
origen: "[[Catálogo de Skills]]"
fecha_creacion: 2026-06-24
timestamp: 2026-06-24T00:00:00Z
fecha_actualizacion: 2026-06-24
modelo_objetivo: claude-sonnet-4-6
version_modelo: claude-sonnet-4-6
categoria: Skill
subcategoria: CE-RE-BRO
caso_uso: Auditoría de conexiones entre notas del vault
harness: claude-code
tools_usadas: [Glob, Grep, Read, Write]
scope: vault
domains: [ia, automatizacion]
version: v1.0
estado: 🟨 Borrador
resource:
---

# Skill | Cerebro CE — Conectar Elementos

> **TL;DR:** Analiza las conexiones entre notas del vault y detecta huérfanas, wikilinks rotos, clusters sin MOC y notas obsoletas. Genera un informe con propuestas priorizadas.

---

## 🎯 Objetivo

Aplicar la dimensión **CE (Conectar Elementos)** de la metodología CE-RE-BRO al vault.

- **Input esperado:** Vault completo (carpetas `02 MOCs/`, `03 Proyectos/`, `04 Knowledge/`, `05 Diario/`)
- **Output esperado:** Nota `05 Diario/Auditorías/Informe CE - YYYY-MM-DD.md` con hallazgos y propuestas
- **Quién la invoca:** {{OWNER}} vía `/cerebro-ce`

---

## 🧩 Contexto de uso

- **¿Cuándo usarla?** En la revisión semanal o mensual del vault. Cuando sospechás que hay notas aisladas o links rotos.
- **¿Cuándo NO usarla?** Si acabás de crear muchas notas nuevas sin enlazar todavía — esperá a conectarlas primero.
- **Dependencias:** Las notas deben usar wikilinks `[[nombre]]` para que el análisis sea efectivo.
- **Flujo donde se integra:** Revisión CE-RE-BRO semanal → `/cerebro-ce` → revisar informe → aplicar propuestas manualmente.

---

## 🔧 Scope y herramientas

| Herramienta | Para qué se usa |
|---|---|
| `Glob` | Listar todos los `.md` en carpetas objetivo |
| `Grep` | Extraer wikilinks `[[...]]` de cada archivo |
| `Read` | Leer frontmatter de notas candidatas a obsoletas |
| `Write` | Crear la nota de informe |

**Carpetas que toca:**
- Lee: `02 MOCs/`, `03 Proyectos/`, `04 Knowledge/`, `05 Diario/` (últimos 30)
- Escribe: `05 Diario/Auditorías/Informe CE - YYYY-MM-DD.md`
- No toca: `00 Sistema/`, `06 Raw/`, `99 Archivo/`, `.claude/`

---

## 📝 Instrucciones

Ver archivo ejecutable: `.claude/commands/cerebro-ce.md`

**Qué detecta:**
1. Notas huérfanas (sin links entrantes ni salientes)
2. Notas semi-huérfanas (sin links entrantes)
3. Wikilinks rotos (apuntan a archivos inexistentes)
4. Clusters de 3+ notas sin MOC que las agrupe
5. Notas obsoletas en Knowledge (90+ días sin actualizar, sin links entrantes)

---

## 🔀 Variables / Argumentos

| Variable | Tipo | Descripción | Ejemplo |
|---|---|---|---|
| `$ARGUMENTS` | string | Scope opcional | `--scope 04 Knowledge/Temas` |

---

## 🧪 Casos de prueba

| # | Condición | Output esperado | Resultado | Notas |
|---|---|---|---|---|
| 1 | Vault con 50+ notas y links cruzados | Informe con hallazgos reales priorizados | 🟨 Pendiente | |
| 2 | Vault con una nota sin ningún link | Aparece en "Notas huérfanas" | 🟨 Pendiente | |
| 3 | Wikilink apuntando a archivo borrado | Aparece en "Wikilinks rotos" | 🟨 Pendiente | |

---

## 🔄 Iteraciones / Versionado

| Versión | Fecha | Cambio | Motivo | Resultado |
|---|---|---|---|---|
| v1.0 | 2026-06-24 | Versión inicial | Basada en metodología CE-RE-BRO de Marcos Emowe | Baseline |

---

## 🔗 Skills relacionadas

- [Skill - Cerebro RE](<Skill - Cerebro RE.md>) → reagrupamiento, siguiente dimensión
- [Skill - Cerebro BRO](<Skill - Cerebro BRO.md>) → estructura interna de notas
- [Skill - Cerebro Audit](<Skill - Cerebro Audit.md>) → corre las tres dimensiones juntas

---

## 📖 Referencias

- [SOP Skills](<../../00 Sistema/SOP Skills.md>)
- Metodología CE-RE-BRO — Marcos Emowe (Cerebro Digital)
- Video: "Tres formas de organizar tus notas que el papel no permite"
