---
tipo_doc: How-to
tags: [skill, ia, claude-code, cerebro-digital, ce-re-bro, auditoria]
origen: "[[Catálogo de Skills]]"
fecha_creacion: 2026-06-24
fecha_actualizacion: 2026-06-24
modelo_objetivo: claude-sonnet-4-6
version_modelo: claude-sonnet-4-6
categoria: Skill
subcategoria: CE-RE-BRO
caso_uso: Diagnóstico completo y priorizado del vault
harness: claude-code
tools_usadas: [Glob, Grep, Read, Write]
scope: vault
domains: [ia, automatizacion]
version: v1.0
estado: 🟨 Borrador
---

# Skill | Cerebro Audit — Diagnóstico Completo CE-RE-BRO

> **TL;DR:** Ejecuta las tres dimensiones CE-RE-BRO en una sola pasada y genera un diagnóstico priorizado por impacto. El punto de entrada para la revisión mensual del vault.

---

## 🎯 Objetivo

Dar una visión completa del estado del vault en una sola ejecución, ordenando los problemas por impacto para que {{OWNER}} sepa exactamente por dónde empezar.

- **Input esperado:** Vault completo
- **Output esperado:** Nota `05 Diario/Auditorías/Auditoría CE-RE-BRO - YYYY-MM-DD.md` con diagnóstico y plan de acción priorizado
- **Quién la invoca:** {{OWNER}} vía `/cerebro-audit`

---

## 🧩 Contexto de uso

- **¿Cuándo usarla?** En la revisión mensual del vault. Cuando no sabés por dónde empezar a ordenar el cerebro digital.
- **¿Cuándo NO usarla?** Si ya sabés exactamente qué dimensión tiene el problema — usá la skill específica (`/cerebro-ce`, `/cerebro-re` o `/cerebro-bro`) para ir más rápido.
- **Dependencias:** Ninguna especial. Funciona mejor cuanto más notas tenga el vault.
- **Flujo donde se integra:** Revisión mensual → `/cerebro-audit` → revisar plan de acción → ejecutar skills específicas para los hallazgos prioritarios.

---

## 🔧 Scope y herramientas

| Herramienta | Para qué se usa |
|---|---|
| `Glob` | Listar todos los `.md` del vault |
| `Grep` | Extraer wikilinks, tags y propiedades YAML |
| `Read` | Leer contenido de notas para análisis BRO |
| `Write` | Crear la nota de auditoría |

**Carpetas que toca:**
- Lee: `02 MOCs/`, `03 Proyectos/`, `04 Knowledge/`, `00 Sistema/`
- Escribe: `05 Diario/Auditorías/Auditoría CE-RE-BRO - YYYY-MM-DD.md`
- No toca: `06 Raw/`, `99 Archivo/`, `.claude/`

---

## 📝 Instrucciones

Ver archivo ejecutable: `.claude/commands/cerebro-audit.md`

**Secuencia interna:**
1. **Fase CE** — conexiones (huérfanas, rotos, clusters sin MOC)
2. **Fase RE** — metadatos (tags duplicados, YAML inconsistente, carpetas incorrectas)
3. **Fase BRO** — estructura interna (notas largas, duplicados, ideas mezcladas)
4. **Fase de priorización** — ordena todos los hallazgos por impacto en un único plan

---

## 🔀 Variables / Argumentos

| Variable | Tipo | Descripción | Ejemplo |
|---|---|---|---|
| `$ARGUMENTS` | string | Limitar scope o profundidad | `--scope 04 Knowledge` |

---

## 🧪 Casos de prueba

| # | Condición | Output esperado | Resultado | Notas |
|---|---|---|---|---|
| 1 | Vault con 100+ notas sin revisar | Plan de acción con 3+ niveles de prioridad | 🟨 Pendiente | |
| 2 | Vault recién organizado | Pocos hallazgos, plan breve | 🟨 Pendiente | |
| 3 | Vault con wikilinks rotos y tags duplicados | Aparecen en "Hacer primero" | 🟨 Pendiente | |

---

## 🔄 Iteraciones / Versionado

| Versión | Fecha | Cambio | Motivo | Resultado |
|---|---|---|---|---|
| v1.0 | 2026-06-24 | Versión inicial | Basada en metodología CE-RE-BRO de Marcos Emowe | Baseline |

---

## 🔗 Skills relacionadas

- [[Skill - Cerebro CE]] → dimensión CE en detalle
- [[Skill - Cerebro RE]] → dimensión RE en detalle
- [[Skill - Cerebro BRO]] → dimensión BRO en detalle
- [[Skill - Cerebro Index]] → generar índice de navegación

---

## 📖 Referencias

- [[SOP Skills]]
- Metodología CE-RE-BRO — Marcos Emowe (Cerebro Digital)
- Video: "Tres formas de organizar tus notas que el papel no permite"
- Video: "¿Un Agente de IA que te acompañe toda la vida? Así se construye"
