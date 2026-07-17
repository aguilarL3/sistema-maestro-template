---
type: How-to
title: "Skill | Cerebro RE — Reagrupar Elementos"
tags: [skill, ia, claude-code, cerebro-digital, ce-re-bro, reagrupar]
origen: "[[Catálogo de Skills]]"
fecha_creacion: 2026-06-24
fecha_actualizacion: 2026-06-24
modelo_objetivo: claude-sonnet-4-6
version_modelo: claude-sonnet-4-6
categoria: Skill
subcategoria: CE-RE-BRO
caso_uso: Auditoría de reagrupamiento y metadatos del vault
harness: claude-code
tools_usadas: [Glob, Grep, Read, Write]
scope: vault
domains: [ia, automatizacion]
version: v1.0
estado: 🟨 Borrador
resource:
---

# Skill | Cerebro RE — Reagrupar Elementos

> **TL;DR:** Analiza los metadatos del vault y detecta tags duplicados, propiedades YAML inconsistentes, etiquetas subusadas y notas en carpetas incorrectas. Genera un informe con propuestas de unificación.

---

## 🎯 Objetivo

Aplicar la dimensión **RE (Reagrupar Elementos)** de la metodología CE-RE-BRO al vault.

- **Input esperado:** Frontmatter de notas en `04 Knowledge/`, `02 MOCs/`, `00 Sistema/`
- **Output esperado:** Nota `05 Diario/Auditorías/Informe RE - YYYY-MM-DD.md` con hallazgos y propuestas
- **Quién la invoca:** {{OWNER}} vía `/cerebro-re`

---

## 🧩 Contexto de uso

- **¿Cuándo usarla?** Cuando el vault lleva tiempo creciendo y sospechás que los tags se fragmentaron. En la revisión mensual.
- **¿Cuándo NO usarla?** Justo después de una reorganización masiva — esperá a que las notas se estabilicen.
- **Dependencias:** Las notas deben tener frontmatter YAML con `tags:` para que el análisis sea efectivo.
- **Flujo donde se integra:** Revisión mensual → `/cerebro-re` → revisar informe → unificar tags manualmente en Obsidian.

---

## 🔧 Scope y herramientas

| Herramienta | Para qué se usa |
|---|---|
| `Glob` | Listar todos los `.md` en carpetas objetivo |
| `Grep` | Extraer tags y propiedades YAML del frontmatter |
| `Read` | Leer contenido de notas candidatas a carpeta incorrecta |
| `Write` | Crear la nota de informe |

**Carpetas que toca:**
- Lee: `04 Knowledge/`, `02 MOCs/`, `00 Sistema/`, `03 Proyectos/`
- Escribe: `05 Diario/Auditorías/Informe RE - YYYY-MM-DD.md`
- No toca: `05 Diario/`, `06 Raw/`, `99 Archivo/`, `.claude/`

---

## 📝 Instrucciones

Ver archivo ejecutable: `.claude/commands/cerebro-re.md`

**Qué detecta:**
1. Tags semánticamente duplicados (sinónimos, variantes)
2. Propiedades YAML con distinto nombre pero misma función
3. Tags subusados (aparecen en ≤2 notas)
4. Prefijos de archivo sugeridos para grupos de notas sin prefijo
5. Notas posiblemente en carpeta incorrecta

---

## 🔀 Variables / Argumentos

| Variable | Tipo | Descripción | Ejemplo |
|---|---|---|---|
| `$ARGUMENTS` | string | Scope opcional | `--scope 04 Knowledge/Temas` |

---

## 🧪 Casos de prueba

| # | Condición | Output esperado | Resultado | Notas |
|---|---|---|---|---|
| 1 | Vault con tags `productividad` y `gestion-tiempo` | Aparecen como duplicados con propuesta de fusión | 🟨 Pendiente | |
| 2 | Nota con tag usado solo 1 vez | Aparece en "Tags subusados" | 🟨 Pendiente | |
| 3 | Nota de IA en carpeta `Modelos Mentales/` | Aparece como posible carpeta incorrecta | 🟨 Pendiente | |

---

## 🔄 Iteraciones / Versionado

| Versión | Fecha | Cambio | Motivo | Resultado |
|---|---|---|---|---|
| v1.0 | 2026-06-24 | Versión inicial | Basada en metodología CE-RE-BRO de Marcos Emowe | Baseline |

---

## 🔗 Skills relacionadas

- [Skill - Cerebro CE](<Skill - Cerebro CE.md>) → conexiones entre notas, dimensión anterior
- [Skill - Cerebro BRO](<Skill - Cerebro BRO.md>) → estructura interna de notas
- [Skill - Cerebro Audit](<Skill - Cerebro Audit.md>) → corre las tres dimensiones juntas

---

## 📖 Referencias

- [SOP Skills](<../../00 Sistema/SOP Skills.md>)
- Metodología CE-RE-BRO — Marcos Emowe (Cerebro Digital)
- Video: "Tres formas de organizar tus notas que el papel no permite"
