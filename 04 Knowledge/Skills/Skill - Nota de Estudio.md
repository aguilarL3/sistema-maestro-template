---
type: How-to
title: "Skill | Nota de Estudio — aprender lo que se construyó"
tags: [skill, ia, claude-code, aprendizaje, explanation, divulgacion]
origen: "[[Catálogo de Skills]]"
fecha_creacion: 2026-07-02
generated:
  by: human:{{OWNER}}
  at: 2026-07-02T00:00:00Z
fecha_actualizacion: 2026-07-02
modelo_objetivo: claude-opus-4-8
version_modelo: claude-opus-4-8
categoria: Skill
subcategoria: Generador de aprendizaje
caso_uso: Convertir algo recién construido (hook, script, mecanismo, decisión) en una nota de estudio (Explanation) con concepto, lenguaje, código explicado y alternativas
harness: claude-code
tools_usadas: [Read, Grep, Glob, Task, WebSearch, Write, Edit]
scope: vault
domains: [ia, automatizacion]
version: v1.0
estado: 🟦 En pruebas
resource:
---

>[!info] Documentación relacionada
>[SOP Skills](<../../00 Sistema/SOP Skills.md>) | [Catálogo de Skills](<Catálogo de Skills.md>) | [Tipos de Documentación](<../../00 Sistema/Tipos de Documentación.md>) | [SOP Documentación](<../../00 Sistema/SOP Documentación.md>) | Hooks y ciclo de vida del agente

# Skill | Nota de Estudio — aprender lo que se construyó

> **TL;DR:** A demanda (`/nota-estudio <tema>`), genera una nota *Explanation* que enseña **cómo se construyó** algo: concepto, lenguaje y por qué, walkthrough del código y alternativas. Enseña, no documenta operativamente.

---

## 🎯 Objetivo

{{OWNER}} pide de forma recurrente notas para **aprender** lo que la IA construye (cómo, con qué, los conceptos, el código y las alternativas). En vez de hacerlas a mano cada vez, esta skill lo sistematiza.

- **Input esperado:** un tema/artefacto (`$ARGUMENTS`), ej. "el hook session-context.sh".
- **Output esperado:** una nota *Explanation* nueva en `04 Knowledge/Temas/` + su `id` registrado.
- **Quién la invoca:** {{OWNER}} vía `/nota-estudio` — **a demanda** (no en cada trabajo).

> **Por qué skill y no hook:** las notas de estudio se quieren *cuando {{OWNER}} decide*, no siempre. Hook = automático por evento; Skill = capacidad a demanda (ver Hooks y ciclo de vida del agente). Por eso NO es un `SessionStart`.

---

## 🧩 Contexto de uso

- **¿Cuándo usarla?** Después de construir/decidir algo que valga la pena aprender.
- **¿Cuándo NO usarla?** Para documentación *operativa* (cómo usar algo) → eso es una guía **How-to**, no esta skill.
- **Dependencias:** el artefacto a explicar debe existir (código/archivos legibles); [SOP Documentación](<../../00 Sistema/SOP Documentación.md>) para el frontmatter e IDs.
- **Flujo:** construir algo → `/nota-estudio <eso>` → nota Explanation → enlazada al resto.

---

## 🔧 Scope y herramientas

| Herramienta | Para qué se usa |
|---|---|
| `Read` / `Grep` / `Glob` | Leer el código/artefacto real (no de memoria) |
| `Task` | **Un** subagente que investiga alternativas/prior-art (aislado) |
| `WebSearch` | El subagente compara con cómo lo hacen otros |
| `Write` | Crear la nota Explanation |
| `Edit` | Registrar el `id` en [SOP Documentación](<../../00 Sistema/SOP Documentación.md>) §7.1 |

**Carpetas que toca:** Lee cualquiera; escribe en `04 Knowledge/Temas/` (o la que pida el tema) + edita el registro de IDs. No toca el código original.

---

## 🏗️ Arquitectura: skill simple + subagente opcional

```
La skill (agente principal) hace lo que YA tiene en contexto:
  concepto · lenguaje y por qué · walkthrough del código · conexiones
        │
        └─ (opcional) 1 subagente Task → investiga ALTERNATIVAS con WebSearch
              (contexto aislado; el principal no se ensucia)
              → verificar antes de incluir
```

**Regla:** si la investigación de alternativas ya está en el contexto (ej. una auditoría previa), usarla y **saltar** el subagente (`--sin-subagente`). El subagente es para cuando falta esa investigación. Escalar a *varios* subagentes (uno por dimensión) solo si un tema lo justifica — empezar simple.

---

## 📝 Instrucciones

Ver ejecutable: `.claude/commands/nota-estudio.md` (estructura ROL/CONTEXTO/TAREA/RESTRICCIONES/FORMATO/ARGUMENTOS).

**Pasos:** ubicar artefacto (Read) → concepto → lenguaje y por qué → walkthrough del código → alternativas (contexto o subagente, verificadas) → conexiones → escribir nota Explanation → registrar `id`.

---

## 🔀 Variables / Argumentos

| Variable | Tipo | Descripción | Ejemplo |
|---|---|---|---|
| `$ARGUMENTS` | string | Tema + opcionales | `los 4 eventos de hooks` · `el lock advisory --sin-subagente` · `check-links --ubicacion 04 Knowledge/Temas` |

---

## 🧪 Casos de prueba

| # | Condición | Output esperado | Resultado | Notas |
|---|---|---|---|---|
| 1 | Tema con código en el vault + investigación ya en contexto | Nota Explanation con walkthrough + alternativas, sin subagente | ✅ 2026-07-02 | Generó Anatomía de los hooks del vault (4 eventos) usando la auditoría previa |
| 2 | Tema sin investigación previa | Lanza 1 subagente para alternativas y verifica | ⬜ | Pendiente de probar |
| 3 | Tema que ya tiene nota | Propone ampliar, no duplica | ⬜ | Pendiente |

---

## 🔄 Iteraciones / Versionado

| Versión | Fecha | Cambio | Motivo | Resultado |
|---|---|---|---|---|
| v1.0 | 2026-07-02 | Versión inicial (Generador; subagente opcional para alternativas) | Sistematizar las notas de aprendizaje que {{OWNER}} pedía a mano | Baseline |

---

## 🚫 Limitaciones conocidas

- La calidad del walkthrough depende de que el código sea legible/esté en el contexto.
- El subagente hereda los sesgos del LLM y la calidad variable de WebSearch → el paso de verificación es obligatorio.
- No reemplaza la guía **How-to**: si el usuario quiere pasos operativos, es otra cosa.

---

## 🔗 Skills relacionadas

- [Skill - Mantenimiento Sistema](<Skill - Mantenimiento Sistema.md>) → también usa un subagente `Task` (juez) — mismo patrón de orquestación mínima.
- [Skill - Cerebro Audit](<Skill - Cerebro Audit.md>) / [Skill - Revisión Mensual](<Skill - Revisión Mensual.md>) → orquestadores de referencia.

---

## 📖 Referencias

- [SOP Skills](<../../00 Sistema/SOP Skills.md>) · [SOP Documentación](<../../00 Sistema/SOP Documentación.md>) · [Tipos de Documentación](<../../00 Sistema/Tipos de Documentación.md>) (Diátaxis)
- Hooks y ciclo de vida del agente (skill vs hook)
- Inspiración: el pedido recurrente de {{OWNER}} de notas de aprendizaje por cada build.

---

◀ [Skill - Mantenimiento Sistema](<Skill - Mantenimiento Sistema.md>) | MOC: [Catálogo de Skills](<Catálogo de Skills.md>) | [Skill - Revisión Mensual](<Skill - Revisión Mensual.md>) ▶
