---
type: Explanation
title: "Orquestación Multi-Agente Abierta"
tags: [multiagente, interoperabilidad, git, ia, arquitectura, estudio]
estado: 🧭 Planificación
prioridad: 🔥 Alta
responsable: "{{OWNER}}"
id: "EXP-MULTIAGENTE-001"
generated:
  by: human:{{OWNER}}
  at: 2026-07-04T00:00:00Z
fecha_creacion: 2026-06-30
resource:
---

>[!info] Documentación relacionada
>[SOP Interoperabilidad IA](<SOP Interoperabilidad IA.md>) (la convención de archivos-ley) | [SOP Git y Flujo de Trabajo](<SOP Git y Flujo de Trabajo.md>) (Conventional Commits + worktrees) | [AGENTS](<../AGENTS.md>) | [CLAUDE](<../CLAUDE.md>) | [SOP Conectores](<SOP Conectores.md>) | [Blueprint de Sistemas](<Blueprint de Sistemas.md>)

# Orquestación Multi-Agente Abierta

> **Caso aplicado hoy:** Claude Code · Codex · Antigravity. **Alcance real:** *cualquier* agente que respete `AGENTS.md` + git (ver §9). El vault define el estándar; el agente se adapta, no al revés.

> **Qué es este documento.** Un documento de **estudio** (Diátaxis = *Explanation*): existe para que **entiendas a fondo** cómo hacer que **varios agentes de código trabajen en paralelo sobre el mismo vault sin pisarse** —de forma **abierta**, sin depender de ningún proveedor. El caso aplicado usa Claude Code (Anthropic), Codex (OpenAI) y Antigravity (Google), pero el diseño sirve para **cualquier agente** que pase el test de §9.1 (Hermes, OpenCode, y los que vengan). No es un SOP (todavía). Al final propone si conviene crearlo (§10).
>
> **Metodología aplicada:** investigación profunda con documentación oficial 2026 antes de implementar (ver §14 Referencias). Todo lo verificado se marca; lo no confirmado en fuente oficial se marca como ⚠️.

---

## 0. TL;DR (leé esto primero)

1. **La base ya existe.** El vault ya tiene `AGENTS.md` (ley universal) + `CLAUDE.md` (ley específica de Claude). Ese es el estándar multi-agente. Codex y Antigravity **leen `AGENTS.md`**; Claude Code lee `CLAUDE.md`. → §2.
2. **Para no pisarse:** en un vault Markdown el riesgo es menor que en código, pero real. La respuesta 2026 es **aislamiento por git worktree** (un checkout separado por agente) + **zonas de propiedad por carpeta**. → §4.
3. **Para saber quién hizo qué:** identidad de commit por agente (autor distinto) + `scope` y *trailer* en el mensaje. Se **extiende** la convención de [SOP Git y Flujo de Trabajo](<SOP Git y Flujo de Trabajo.md>), no se reemplaza. → §5.
4. **¿Doc nuevo "reglas multi-agente"?** Recomendación: **todavía no un SOP nuevo.** Este doc de estudio + extender los dos SOPs existentes. Se promueve a `SOP Multi-Agente` cuando el flujo se estabilice. → §10.
5. **Ojo con Obsidian:** el plugin Obsidian Git (auto-commit/sync en `main`) **choca** con agentes commiteando en ramas. Hay que pausarlo durante corridas multi-agente. → §7.

---

## 1. El objetivo y por qué importa

Querés que más de un agente de IA trabaje sobre el Sistema Maestro **a la vez** —por ejemplo Claude reorganizando MOCs mientras Codex extrae notas atómicas de un curso y Antigravity audita links rotos— sin que:

- se **sobrescriban** entre ellos (dos agentes editando el mismo archivo),
- **rompan** las convenciones del vault (cada uno inventando su estructura),
- dejen un `git log` ilegible donde no sabés **quién** cambió qué.

El problema tiene tres capas, y este doc las separa a propósito:

| Capa | Pregunta | Se resuelve con | Sección |
|---|---|---|---|
| **Entendimiento** | ¿Cada agente entiende las reglas del vault igual? | Archivos-ley estándar (`AGENTS.md` / `CLAUDE.md`) | §2–§3 |
| **Aislamiento** | ¿Cómo evito que se pisen los archivos? | Worktrees + zonas de propiedad | §4 |
| **Trazabilidad** | ¿Cómo sé quién hizo qué? | Identidad + convención de commits | §5 |

> **Insight clave.** "Multi-agente" no es un problema de IA: es un problema de **control de versiones**. La IA solo edita texto; git es lo que decide si dos ediciones colisionan. Por eso el 80% de la solución es git (worktrees, ramas, commits), no prompts.

---

## 2. Cómo lee cada agente los archivos-ley (la base estándar)

### 2.1 El estándar común: AGENTS.md

`AGENTS.md` es un **formato abierto** para instruir agentes de código. Lo lanzaron conjuntamente **OpenAI, Google, Factory, Sourcegraph y Cursor** (2025) y hoy lo administra la **Agentic AI Foundation** bajo la **Linux Foundation**. Es CommonMark plano (sin frontmatter YAML). Ya es un estándar de facto: >20.000 repos en GitHub. *(Verificado — §14)*

**Regla de descubrimiento del estándar:** un agente **camina el árbol de directorios** y fusiona instrucciones. Un `AGENTS.md` más cercano al archivo en el que se trabaja **anula** al de la raíz. Los encabezados (`## Build & Test`, `## Code Style`, `## Security Notes`) funcionan como pistas semánticas.

### 2.2 Qué lee cada uno de los tres agentes

| Agente | Archivo-ley que lee | Cómo lo lee (verificado 2026) |
|---|---|---|
| **Claude Code** (Anthropic) | `CLAUDE.md` (nativo) | Sistema de memoria jerárquico: carga `CLAUDE.md` de raíz + subcarpetas al iniciar. **⚠️ `AGENTS.md` NO es nativo todavía** (hay *feature request* abierto #34235). En el vault, Claude se guía por `CLAUDE.md`. |
| **Codex** (OpenAI) | `AGENTS.md` | Construye una **cadena de instrucciones** una vez por sesión: (1) global `~/.codex/AGENTS.md`, (2) desde la raíz del repo baja hacia el directorio actual concatenando cada `AGENTS.md`, (3) los más cercanos ganan. Soporta `AGENTS.override.md` para anular. Límite 32 KiB por defecto. *(Verificado — §14)* |
| **Antigravity** (Google) | `AGENTS.md` | El **Agent Manager** lee `AGENTS.md` en la raíz del workspace antes de empezar; cada agente que se spawnea lo lee. Además usa `skills.md` en `.agents/skills/`. Si coexisten `AGENTS.md` y `GEMINI.md`, `AGENTS.md` suele tener precedencia. *(Verificado — §14)* |

### 2.3 Consecuencia para el vault: dos archivos, una sola ley

El vault **ya resuelve esto bien** y por diseño:

```
CLAUDE.md   → ley específica de Claude Code (única con máxima autoridad en sesión Claude)
AGENTS.md   → ley universal que leen Codex y Antigravity (y cualquier agente del estándar)
```

Esta separación es la que ya documenta [SOP Interoperabilidad IA](<SOP Interoperabilidad IA.md>) §1. La regla de autoridad del ecosistema (de mayor a menor):

```
CLAUDE.md  →  AGENTS.md  →  llms.txt  →  Skills  →  resto de la documentación
```

> **El riesgo real acá NO es de lectura, es de sincronización.** Si `CLAUDE.md` y `AGENTS.md` divergen (una regla actualizada en uno y no en el otro), Claude y Codex operarán con reglas distintas sobre el mismo vault. → mitigación en §3.

---

## 3. Mantener una sola fuente de verdad entre los archivos-ley

Tres archivos podrían contener reglas: `CLAUDE.md`, `AGENTS.md` y (a futuro) un `codex`/`gemini` específico. **Regla de oro del vault** (ya en [SOP Interoperabilidad IA](<SOP Interoperabilidad IA.md>) §9): *una sola fuente de verdad por regla; enlazar, no copiar.*

Estrategias posibles (a decidir — §11):

| Estrategia | Cómo | Pro | Contra |
|---|---|---|---|
| **A. Espejo manual** | `AGENTS.md` y `CLAUDE.md` repiten las reglas comunes; cada uno agrega lo suyo | Simple, hoy funciona | Divergen con el tiempo |
| **B. AGENTS.md canónico + CLAUDE.md fino** | Toda la ley común vive en `AGENTS.md`; `CLAUDE.md` es corto y dice "seguí `AGENTS.md` + estas 3 cosas Claude-específicas" | Una sola fuente; menos divergencia | Claude no lee `AGENTS.md` nativo → hay que referenciarlo explícito dentro de `CLAUDE.md` |
| **C. Generación** | Un `AGENTS.base.md` como fuente; un script genera `CLAUDE.md` y `AGENTS.md` | Cero divergencia | Complejidad; overkill para el vault hoy |

**Recomendación (propuesta, no decisión):** **Estrategia B**. Ya casi está: `CLAUDE.md` es rico; `AGENTS.md` es la ley. Bastaría con que `CLAUDE.md` diga explícitamente "las reglas base viven también en `AGENTS.md`; ante cambio, actualizá ambos" y que el [Skill - Mantenimiento Sistema](<../04 Knowledge/Skills/Skill - Mantenimiento Sistema.md>) audite que no divergieron.

---

## 4. División del trabajo sin pisarse

> **→ PROMOVIDO a [SOP Multi-Agente](<SOP Multi-Agente.md>) §1-2 (2026-07-11, ejecutando el plan de §10).** Resumen: tres niveles de aislamiento; el muro real son los **git worktrees** (checkout físico por agente, soporte nativo en Claude Code y Codex); las **zonas de propiedad** son convención complementaria — reparto por tipo de tarea con `03 Proyectos/` y `05 Diario/` solo-humano y `99 Archivo/` congelado (ex §4.6, hoy SOP §2). No existe lock de archivo real para `.md`: aislamiento = worktrees + zonas + merge al final; si dos agentes deben tocar lo mismo, se serializa.

---

## 5. Convención de commits por agente (quién hizo qué)

> **→ PROMOVIDO a [SOP Multi-Agente](<SOP Multi-Agente.md>) §3.** Resumen: cada agente commitea con **identidad git propia** (`*@agent.local`) + trailer `Agent:` en el mensaje (usar ambos). Trampa verificada: `git config` dentro del worktree escribe en la config compartida y contamina `main` — usar `git -c` por commit o `extensions.worktreeConfig`.

---

## 6. El flujo completo, paso a paso

> **→ PROMOVIDO a [SOP Multi-Agente](<SOP Multi-Agente.md>) §4.** Resumen: FASE 0 preparar (identidades, zonas, `core.longpaths`, `core.hooksPath`) → FASE 1 lanzar (pausar auto-sync de Obsidian, un worktree por agente, verifier tier-2 antes de commitear) → FASE 2 integrar (el lead mergea rama por rama a `main`) → FASE 3 verificar (links, MOCs, CE-RE-BRO si hubo cambios grandes).

---

## 7. Riesgos específicos de un vault Obsidian (no es un repo de código)

Esto **no** aparece en las guías genéricas de multi-agente porque asumen código. Acá hay trampas propias:

| Riesgo | Por qué pasa | Mitigación |
|---|---|---|
| **Obsidian Git plugin choca con las ramas** | El plugin hace *commit-and-sync* automático sobre `main`. Si corre mientras un agente commitea en su rama, se cruzan. | **Pausar** el auto-sync / *pull on startup* durante corridas multi-agente. Reactivar al integrar. |
| **`.obsidian/` genera conflictos** | `workspace.json`, `graph.json`, config de plugins cambian todo el tiempo y por dispositivo. | Ya parcialmente en `.gitignore` (regla 6.4 SOP Git). Asegurar que los worktrees no arrastren config local (`.worktreeinclude` copia solo lo necesario). |
| **Links `[[wikilink]]` rotos al mergear** | Un agente renombra/mueve una nota en su rama; otro la enlaza en la suya. | Zonas de propiedad (§4.6) + auditoría CE-RE-BRO post-merge (paso 15). |
| **Worktrees invisibles en Obsidian** | Obsidian abre **una** carpeta. Los worktrees en `.claude/worktrees/` no se ven desde el vault principal. | Es **esperado**: los agentes trabajan "fuera de vista"; vos revisás por git, no por Obsidian, hasta mergear. |
| **Sync móvil (shallow clone) + ramas de agente** | El móvil usa `depth=1` sobre `main`; ramas de agente no le llegan bien. | Multi-agente es **operación de PC**. No lanzar agentes desde el móvil. |
| **`Filename too long` (MAX_PATH 260)** ⚠️ *hallazgo del ensayo* | El worktree añade su prefijo a rutas ya profundas (`04 Knowledge/{{OWNER}} Career OS/…`) y superan el límite de Windows → falla la creación. | `git config core.longpaths true` (paso 3 de Fase 0). Alternativa: crear el worktree en un path corto fuera del vault. |
| **`Permission denied` al borrar el worktree** ⚠️ *hallazgo del ensayo* | OneDrive / indexador / Obsidian sostienen un *handle* de archivo en Windows. | Reintentar `git worktree remove --force`; si persiste, borrar el dir + `git worktree prune`, o PowerShell `Remove-Item -Recurse -Force`. |

> **Este es el aporte que ninguna guía genérica te da:** un vault Markdown sincronizado con un plugin y multi-dispositivo tiene modos de fallo que un repo de código no tiene. Por eso conviene documentarlo (§10).

---

## 8. Antigravity: honestidad sobre el estado del arte

Antigravity es la **plataforma agéntica de Google** (public preview, gratis, macOS/Windows/Linux; soporta Gemini 3 Pro, Claude Sonnet 4.5 y GPT-OSS). Su pieza central es el **Agent Manager**: una superficie para *spawn, orquestar y observar* múltiples agentes trabajando **asíncronos en distintos workspaces*, con verificación vía **Artifacts** (listas de tareas, planes, capturas, grabaciones de navegador). *(Verificado — §14)*

Lo que **sí** está confirmado para nuestro caso:
- Lee `AGENTS.md` en la raíz del workspace. ✅
- Usa `skills.md` en `.agents/skills/`. ✅
- Aísla por **directorio y artefactos**, no (documentadamente) por git worktree. ⚠️

Lo que **no** está confirmado en doc oficial (y por eso va como ⚠️ y no se implementa a ciegas):
- Que gestione ramas/worktrees por agente automáticamente.
- Su comportamiento de commit por defecto.

**Implicación práctica:** con Antigravity, el aislamiento git lo gestionás **vos** (abrís un worktree/rama como workspace y configurás su identidad de commit a mano). Encaja mejor como **auditor transversal** (aprovechando sus Artifacts) que como escritor de estructura, hasta tener más certeza. → por eso su zona en §4.6 es de solo-lectura/propuestas.

---

## 9. Portabilidad: ¿sirve para cualquier agente? (Hermes, OpenCode y los que vengan)

**Sí, y es intencional.** Todo lo de este documento **no depende de los tres productos** (Claude, Codex, Antigravity). Depende de **dos estándares abiertos** que cualquier agente puede cumplir:

```
1. AGENTS.md  → cómo el agente ENTIENDE las reglas del vault (estándar Linux Foundation)
2. git        → cómo el agente NO SE PISA con otros (worktrees, ramas, identidad de commit)
```

> **El principio.** No diseñamos "un sistema para Claude + Codex + Antigravity". Diseñamos **un sistema para agentes que respetan `AGENTS.md` y git**. Los tres productos son solo los primeros inquilinos. Esto es coherencia directa con el principio de **portabilidad** del vault: *el sistema debe seguir funcionando sin ninguna herramienta específica.*

### 9.1 El test de compatibilidad (2 preguntas)

Antes de sumar cualquier agente —Hermes, OpenCode, Aider, uno que salga en 2027— hacele estas dos preguntas:

| # | Pregunta | Si la respuesta es NO |
|---|---|---|
| 1 | ¿Lee `AGENTS.md` (o algún archivo de contexto al que pueda apuntarlo)? | No entiende las reglas del vault → **no lo dejes escribir**, solo lectura. |
| 2 | ¿Opera sobre git (commitea, respeta ramas)? | No podés aislarlo ni saber qué hizo → **serializalo** o descartalo. |

Si pasa las dos: **es compatible, sin cambios al vault.** Solo lo agregás a la tabla de zonas (§4.6) e identidades (§5.1).

### 9.2 Dónde caen los agentes que nombraste (y otros del ecosistema 2026)

| Agente | Lee `AGENTS.md` | Git nativo | Worktree nativo | Nivel |
|---|---|---|---|---|
| **Claude Code** (Anthropic) | ⚠️ vía `CLAUDE.md` | ✅ | ✅ | **Tier 1** — plug & play |
| **Codex** (OpenAI) | ✅ | ✅ | ✅ | **Tier 1** — plug & play |
| **Hermes Agent** (Nous Research, open source) | ✅ (`AGENTS.md` + `.cursorrules`) | ✅ | ⚠️ manual | **Tier 2** — worktree a mano |
| **OpenCode** (alternativa open-source a Claude Code) | ✅ | ✅ | ⚠️ manual | **Tier 2** |
| **Aider** (open source) | ✅ | ✅ **auto-commit** | ⚠️ manual (usás `git worktree` + `cd`) | **Tier 2** |
| **Cline / Roo Code** (VS Code, open source) | ✅ | ✅ | ⚠️ manual | **Tier 2** |
| **OpenHands, Goose, Continue, Gemini CLI, Copilot** | ✅ (la mayoría) | ✅ | según herramienta | **Tier 2** |
| **Antigravity** (Google) | ✅ | ✅ | ⚠️ no documentado | **Tier 2** |
| **Agente futuro X (2027…)** | *aplicá el test §9.1* | *test* | *test* | *el que resulte* |

> **Sobre "openclaw":** no encontré un producto oficial con ese nombre exacto (puede ser confusión con **OpenCode**, o un agente que todavía no salió). No importa: cuando aparezca, le pasás el **test §9.1**. Si lo pasa, entra; si no, queda como solo-lectura o afuera. **El vault no cambia por él — él se adapta al vault.**

### 9.3 Los tres niveles (Tiers)

```
Tier 1 — Plug & play:  lee la ley + git + worktree nativo.  Lo lanzás y listo. (Claude, Codex)
Tier 2 — Con andamio:  lee la ley + git, pero el worktree lo creás vos a mano
         (git worktree add ../vault-agenteX -b agent/agenteX) y configurás su
         identidad de commit. Es la mayoría de agentes open-source. (Hermes, OpenCode, Aider…)
Tier 3 — Con adaptador: no lee AGENTS.md solo → le pasás las reglas en el prompt/config
         inicial apuntando al archivo. Sigue siendo compatible, con un paso extra.
```

> **¿Qué se carga al abrir el vault con Codex/Hermes/Cursor?** La respuesta práctica —qué viaja solo (doc + `AGENTS.md`) y qué hay que portar (hooks/skills/agentes, formato Claude Code)— está aterrizada en Qué se carga al abrir el vault con otro agente. Resumen: los cuatro harnesses ya tienen los mismos mecanismos (2026), pero cada uno lee su propio formato → se **porta**, no se copia.

### 9.4 Cómo esto te protege del futuro

- **No apostás a un ganador.** Si mañana Codex desaparece o Hermes se vuelve el mejor, el vault no se toca: cambiás de inquilino, no de casa.
- **Cero lock-in.** Es el mismo motivo por el que el vault es Markdown y no Notion (Principio 2 del sistema: *Markdown antes que herramientas propietarias*).
- **La ley es una sola.** `AGENTS.md` sigue siendo la fuente de verdad para **todos** ellos; solo Claude usa además `CLAUDE.md` (§2–§3).

> **Regla de portabilidad multi-agente:** *el vault define el estándar; el agente se adapta al vault, nunca al revés.* Si un agente exige que reestructures el vault para funcionar, ese agente es el problema — no el vault.

---

## 10. ¿Conviene un doc "reglas multi-agente" en 00 Sistema? (la pregunta directa)

**Respuesta corta: sí conviene documentarlo, pero NO como un `SOP Multi-Agente` nuevo todavía.** Razones (alineadas con las reglas del vault: *no duplicar*, *conectar antes que clasificar*):

- Ya existen **dos SOPs** que cubren el 70%: [SOP Interoperabilidad IA](<SOP Interoperabilidad IA.md>) (cómo cada IA lee la ley) y [SOP Git y Flujo de Trabajo](<SOP Git y Flujo de Trabajo.md>) (commits, ramas, worktrees). Un SOP nuevo **duplicaría** secciones.
- Un SOP es un **How-to** (tarea normal, repetible). Hoy esto es **experimental**: todavía no lo ejecutaste ni una vez. Documentar como SOP algo no probado infla el how-to (anti-patrón "todo es un SOP" — [Tipos de Documentación](<Tipos de Documentación.md>) §5).

**Recomendación en capas (propuesta):**

| Ahora (fase estudio) | Cuando ejecutes 1–2 veces | Cuando sea rutina |
|---|---|---|
| **Este documento** (Explanation) + | Extender **SOP Interoperabilidad IA** con §12 "Operación multi-agente" (identidad + zonas) y **SOP Git y Flujo de Trabajo** con §11 "Worktrees por agente" | Promover a **`SOP Multi-Agente`** (How-to) con el flujo §6 ya validado, dejando este doc como el "por qué" enlazado |

Así seguís la propia doctrina del vault: primero *entender* (Explanation), después *hacer repetible* (extender SOP), y solo cuando es rutina, *SOP dedicado*.

> **✅ Promoción EJECUTADA (2026-07-11).** La condición "cuando sea rutina" se cumplió (gaps A-E cerrados, mecanismos en operación diaria) → §4-6 promovidos a **[SOP Multi-Agente](<SOP Multi-Agente.md>)** (SOP-014). Este documento queda como el *porqué* (Explanation), tal como este mismo plan lo pedía.

---

## 11. Decisiones (registro histórico — todas resueltas)

> Nació como lista de decisiones abiertas; al **2026-07-11 están todas cerradas**. Queda como registro del razonamiento; los cambios estructurales permanentes se registran en [CHANGELOG del Sistema](<CHANGELOG del Sistema.md>).

1. **Sincronización de leyes (§3)** → ✅ (2026-06-30) Estrategia B: puntero anti-divergencia en `AGENTS.md` y `CLAUDE.md` (si cambiás una regla base en una, actualizá la otra).
2. **¿Cuántos agentes en paralelo?** → ✅ de facto (jul 2026): opera **1 lead (Claude Code) + subagentes por tarea** (extracción con Sonnet, verifier, bibliotecario). Si se suman CLIs pares (Codex/Hermes), arrancar con 2–3 — el cuello de botella es la revisión humana, no la IA.
3. **Zonas de propiedad** → ✅ (2026-06-30) mapa por tipo de tarea, cobertura completa; `03 Proyectos/` y `05 Diario/` solo-humano; `99 Archivo/` congelado. Hoy en [SOP Multi-Agente](<SOP Multi-Agente.md>) §2.
4. **Rol de Antigravity** → ✅ (2026-06-30, decidido dentro del mapa de zonas): **auditor solo-lectura → propuestas**, hasta confirmar su manejo de git.
5. **¿Quién es el "lead"?** → ✅ (2026-06-30 zonas + práctica de julio): **Claude Code como lead** integra las ramas y mantiene sistema/índices; {{OWNER}} revisa y aprueba (la decisión final siempre es suya).
6. **Identidad de commit** → ✅ (2026-06-30) emails `@agent.local` (ej. `codex@agent.local`): no suplantar cuentas reales, separar humano/agente en `git log`.

---

## 12. Las 3 capas: modelo · harness · orquestación (qué pasa si no usás Claude Code)

Para pensar el sistema a escala (personal → proyectos → empresas) hay que separar tres capas que suelen confundirse. Nuestro diseño vive en la **capa 3** y es **agnóstico** de las otras dos.

```
CAPA 1 · MODELO (el cerebro)        → qué modelo piensa
   Claude · GPT · Gemini · Llama · DeepSeek …
   ← OpenRouter vive acá: 1 API → 100 modelos (un gateway, NO un agente)

CAPA 2 · HARNESS (vuelve el modelo un agente)  → memoria, permisos, tool-loop, deploy, observabilidad
   Claude Code · Codex · OpenCode · Aider · Hermes …

CAPA 3 · ORQUESTACIÓN / INTEROP (varios agentes, un vault)  → AGENTS.md + git + zonas + identidad
   ← ESTE documento
```

> **Regla:** la capa 3 no depende de qué haya en 1 y 2. Cambiás de modelo (vía OpenRouter) o de harness (Claude Code → OpenCode) **sin tocar el vault**. Por eso OpenRouter "sirve": no es un agente, es un motor de la capa 1; cualquier agente que lo use encaja igual mientras pase el test §9.1.

### 12.1 Qué es el "harness" (capa 2) y sus 5 piezas

Un **harness** es la infraestructura que convierte un modelo (que solo predice texto) en un **agente** (que recuerda, decide y actúa). Cinco piezas — tomando **Hermes** (agente open-source de Nous Research) como ejemplo de harness construido a mano:

| # | Pieza | Qué hace |
|---|---|---|
| 1 | Memoria y contexto | retener información entre sesiones |
| 2 | Permisos y control | qué puede y qué no puede hacer el agente |
| 3 | Loop de herramientas | ciclo pensar → actuar → observar → decidir |
| 4 | Deploy / always-on | correr 24/7 en un servidor, no en tu PC |
| 5 | Observabilidad y coste | ver qué hace y cuánto gasta de API |

### 12.2 Si NO usás Claude Code: ¿qué hay que construir?

Buena noticia: **por diseñar en la capa 3 (vault-céntrico), la mayoría NO se reconstruye.** Dónde vive de verdad cada pieza:

| Pieza | ¿Dónde vive? | ¿La reconstruís al cambiar de harness? |
|---|---|---|
| 1. Memoria y contexto | **En el vault** (`AGENTS.md`, SOPs, Agent Diary §12.3) — no en el harness | ❌ No. Es portable. Ese es el punto. |
| 2. Permisos y control | Mezcla: vault (zonas §4.6 + segmentación §12.4) + SO/git (sandbox, permisos de archivo) | ⚠️ Parcial. La parte de negocio vive en el vault. |
| 3. Loop de herramientas | **En el harness** (capa 2) | ✅ Sí — la única pieza atada al harness |
| 4. Deploy always-on | Infra (servidor) | ✅ Sí, si querés 24/7 (opcional) |
| 5. Observabilidad/coste | Mezcla: `git log` (qué cambió) + tooling de coste | ⚠️ Parcial |

> **La clave para no depender de Claude Code:** poné la **memoria y el contexto en el vault, nunca dentro del agente**. Así, el día que un proveedor deprecte un modelo (le pasó a mucha gente cuando retiraron modelos de un día para otro) o quieras usar OpenCode / Hermes / una LLM local, el conocimiento sigue intacto y solo cambiás el "motor". Si dejás Claude Code, la **única** pieza que necesitás reemplazar es el **loop de herramientas** — y hay opciones open-source: **OpenCode, Aider, Hermes**, o frameworks como el **Claude Agent SDK** o **LangGraph**.

### 12.3 Patrón "Agent Diary" (contexto persistente para N agentes)

Cómo logran las infraestructuras empresariales que **decenas de agentes trabajen 24/7 sin perder contexto** (ej. la arquitectura de **Albert López / Deleguía** sobre Obsidian, con 30+ agentes en paralelo): un **diario de agentes**. Al final de cada sesión significativa, cada agente registra una entrada:

- qué se avanzó / solucionó / retocó
- qué quedó bloqueado
- qué se decidió o cambió
- **qué debe saber el próximo agente que entre**

Esto convierte el vault en **memoria compartida viva**: cualquier agente (Claude, Codex, Hermes…) lee el diario y arranca con contexto, sin que vos repitas nada. Es la capa **Estado** de [SOP Interoperabilidad IA](<SOP Interoperabilidad IA.md>) aplicada a multi-agente. En el vault encaja en `05 Diario/` o un `Agent Diary/` dedicado. *Sesión significativa* = archivos creados/editados, sistemas externos tocados, o SOP nuevos/mejorados.

### 12.4 Segmentación de acceso (obligatoria a escala empresa)

No todos los agentes merecen el mismo acceso. Patrón empresarial (Deleguía): separar agentes **de confianza** (Claude, Codex — más cerrados/seguros) de los **open-source** (Hermes, OpenClaude — más fáciles de "liarla"). Dos mecanismos:

- **Vault/repo partido:** un *core* privado + un subconjunto sincronizado que ven las LLM externas. Cada agente ve solo lo que elegís.
- **Zonas por confianza:** ampliar las zonas de §4.6 con un eje de permiso (quién **escribe** vs quién solo **lee**), no solo por tarea.

Para tu escala hoy (personal) alcanza con las zonas §4.6. Cuando el vault sirva a **proyectos/empresas**, esta segmentación pasa a ser **requisito**, no opción.

> Implementación decidida (2026-07-04): el **modelo de acceso entre vaults** es asimétrico — personal→empresa sí / empresa→personal bloqueado en 3 capas (separación física, credenciales, deny de ruta en settings). La regla completa está en [SOP Proyectos de Código](<SOP Proyectos de Código.md>) (§1, *La frontera personal vs negocio*).

---

## 13. Estado del arte y gaps (auditoría 2026-07-01 — CERRADA)

> **✅ Auditoría CERRADA (2026-07-11):** todos los gaps con letra (A–E) y los mecanismos de la tabla §13.3 están **construidos**. Esta sección queda como **registro histórico** del análisis y del prior art (valioso para portabilidad y para no re-litigar). Los pendientes vivos están en el [Roadmap del Sistema](<../01 Index/Roadmap del Sistema.md>), no acá.

Auditoría contra documentación oficial **+ relevamiento de implementaciones públicas existentes**. Objetivo: verificar lo diseñado y ubicarlo frente a lo que **ya existe funcionando**, para no reinventar.

### 13.1 Verificación técnica (contra docs oficiales)

Todo lo técnico del doc se verificó y **se sostiene**:
- ✅ Fusión de `AGENTS.md` en Codex (root→cwd, `AGENTS.override.md`, 32 KiB).
- ✅ `git config` dentro del worktree contamina la config **compartida**; la identidad per-worktree requiere `extensions.worktreeConfig` + `git config --worktree` (nuestra corrección de §5.1 era correcta).
- ✅ Claude Code `--worktree`, `.claude/worktrees/`, `isolation: worktree`, `git worktree lock`.
- ✅ Git no tiene lock de archivos nativo. **Matiz:** los orquestadores y repos como `claude-obsidian` implementan **locks *advisory* a nivel de harness** (ver 13.3) — no es lock de git, es coordinación en la capa de aplicación.
- ⚠️ **Corrección:** la doc oficial de Codex **no** confirma si los *subagents* heredan la misma cadena `AGENTS.md` del padre. Asumir herencia, pero verificar antes de depender de ello para restricciones sensibles.

### 13.2 Prior art — lo que ya existe (base de comparación)

**Orquestadores por worktree (caso código):** Vibe Kanban (open source, 10+ agentes: Claude, Codex, Gemini, OpenCode, Aider…), Conductor, Nimbalyst, Superset, Claude Squad, Gastown/OpenClaw+Antfarm (autónomos overnight). Aportan capa **visual** (kanban, diff-first), **aislamiento de runtime** (puertos/DBs) y **predicción de conflictos** (Clash).

**Multi-agente sobre Obsidian (nuestro caso exacto, ya construido):**

| Repo | Qué aporta |
|---|---|
| `eugeniughelbur/obsidian-second-brain` | Cross-CLI (Claude/Codex/Gemini/OpenCode/Hermes/Pi), 44 comandos, agentes programados 24/7, **edición con centinelas** `@user`/`@generated`, hechos **bi-temporales** |
| `breferrari/obsidian-mind` | Memoria vía **hooks** (SessionStart/Stop/PostToolUse), principio "el código posee el entorno, el agente el contenido" |
| `AgriciDaniel/claude-obsidian` (8.3k★) | **Patrón LLM Wiki (Karpathy) — el mismo de tu vault**; **locks advisory** (`wiki-lock.sh`), verifier pre-commit, modos PARA/Zettelkasten, contradicciones con `[!contradiction]`; setup por `bin/*.sh` + Makefile con **tests del framework**; `.obsidian/` trackeado curado |

**Agregados 2026-07-04 — ángulo portabilidad/distribución** (verificados en código; detalle en Discovery - Portabilidad del Sistema - 2026-07-04 §6):

| Repo | Qué aporta |
|---|---|
| [`huytieu/COG-second-brain`](https://github.com/huytieu/COG-second-brain) | **Updater con whitelist** (`cog-update.sh`: remote upstream + lista `FRAMEWORK_FILES`, nunca toca contenido personal) + `COG-VERSION` (SemVer) + skill `/onboarding` + publicado como **plugin de Claude Code** (`.claude-plugin/` + `marketplace-entry.json`) |
| [`heyitsnoah/claudesidian`](https://github.com/heyitsnoah/claudesidian) | Starter kit estilo npm: marker **`FIRST_RUN`** + `/init-bootstrap` (wizard corrido por el agente, borra el marker); `check-updates` contra GitHub raw + comando `/upgrade` |
| [`coleam00/second-brain-starter`](https://github.com/coleam00/second-brain-starter) | Wizard `BOOTSTRAP.md` que entrevista al usuario, genera el sistema personalizado y **se auto-borra** |
| [`gokhanarkan/minimal-second-brain`](https://github.com/gokhanarkan/minimal-second-brain) | Contraejemplo minimalista: AGENTS.md + CLAUDE.md + 3 carpetas, clone y listo, sin updater |

(De los 3 originales, `breferrari/obsidian-mind` aporta además el **`vault-manifest.json`** — manifest declarativo `infrastructure` vs `scaffold` con regla por archivo — y `eugeniughelbur/obsidian-second-brain` el modelo **herramienta global** en `~/.claude/` con adapters por CLI, sin template de vault.)

### 13.3 Gap analysis — qué nos falta

> **Insight central:** worktrees + zonas resuelven el conflicto de **archivos** (el problema *fácil* en un vault). El problema *difícil* es el conflicto **semántico**: dos agentes escriben cosas contradictorias en notas distintas. Ahí no teníamos nada; el prior art sí.

| Mecanismo | ¿Lo tenemos? | Quién lo resuelve | Prioridad |
|---|---|---|---|
| Aislamiento worktree + identidad de commit | ✅ | validado | — |
| **Conflicto semántico** (reconciliación, contradicciones) | ✅ (2026-07-01) | second-brain · claude-obsidian (`[!contradiction]`) | — → [Conflicto Semántico - Enlaces y Contradicciones](<Conflicto Semántico - Enlaces y Contradicciones.md>) |
| ├─ *enlaces rotos* (Gap 2a) | ✅ | `check-links.sh` (honra `aliases`) | — → [Catálogo de Hooks y Locks](<../04 Knowledge/Automatización/Catálogo de Hooks y Locks.md>) |
| ├─ *sanación/triage de enlaces* (Gap B) | ✅ (2026-07-02) | second-brain (`heal_links.py`) → `heal-links.py` | — → [Catálogo de Hooks y Locks](<../04 Knowledge/Automatización/Catálogo de Hooks y Locks.md>) |
| └─ *contradicciones* (Gap 2b) | ✅ | convención `[!contradiction]` + `check-contradictions.sh` | — → [Conflicto Semántico - Enlaces y Contradicciones](<Conflicto Semántico - Enlaces y Contradicciones.md>) |
| **Locks advisory** multi-writer | ✅ (2026-07-01) | claude-obsidian (`wiki-lock.sh`) | — → ver [SOP Hooks y Automatización](<SOP Hooks y Automatización.md>) §7 |
| **Hooks de sesión** (memoria persistente) | ✅ | obsidian-mind · claude-obsidian | — → ver [SOP Hooks y Automatización](<SOP Hooks y Automatización.md>) |
| ├─ *escritura* (Agent Diary, `Stop`) | ✅ (2026-07-01) | obsidian-mind | — |
| └─ *lectura* (SessionStart carga el handoff) | ✅ (2026-07-02) | claude-obsidian (`hot.md`) · second-brain | — → `session-context.sh` |
| **Edición con centinelas** (`@user`/`@generated`) | ✅ (2026-07-01) | second-brain | — → [Centinelas de Edición](<Centinelas de Edición.md>) |
| **Verifier pre-commit** (self-review antes de commit) | ✅ tier-1 (2026-07-01) + tier-2 (2026-07-02) | claude-obsidian | — → Verifier pre-commit (self-review) |
| ├─ *tier-1 determinista* (frontmatter/tags, git hook) | ✅ (2026-07-01) | claude-obsidian | — → `verify-commit.sh` |
| └─ *tier-2 juez LLM* (calidad de conocimiento, subagente) | ✅ (2026-07-02) | claude-obsidian (`agents/verifier.md`) | — → `.claude/agents/verifier.md` |
| Auto-commit consciente de locks (+ `list`/`owner` en wiki-lock) | ✅ (2026-07-02) | claude-obsidian | — |
| Ruteo por intención (`UserPromptSubmit`) + backup de transcript (`PreCompact`) | ✅ (2026-07-02) | obsidian-mind → `route-intent.sh` (opt-in) + `pre-compact.sh` | — |
| Compilar 1 fuente → N configs de agente | ❌ (Estrategia C diferida, §3) | second-brain | media |
| Búsqueda semántica (BM25/Ollama) | ❌ | los tres | opcional |
| Orquestación visual / review diff-first | ❌ | Vibe Kanban · Conductor | opcional |
| Runtime isolation (puertos/DBs) | N/A | orquestadores de código | ❌ no aplica a Markdown |

**Lo que hacemos bien / distinto:** neutralidad de proveedor explícita (test §9.1), gobernanza fuerte (SOPs · zonas · identidad · CE-RE-BRO), separación explícita de las 3 capas (§12). El patrón LLM Wiki de tu vault está **validado** por un repo de 8.3k★.

### 13.4 Conclusión

No estamos equivocados: estamos en la línea correcta y con **mejor gobernanza** que la media. Pero **parte de lo que falta ya existe construido y open-source** → conviene **adoptar mecanismos** (locks advisory, hooks, centinelas, reconciliación) en vez de reinventarlos. La **siguiente frontera** es el conflicto **semántico**, no el de archivos.

> **Qué falta y qué sigue → [Roadmap del Sistema](<../01 Index/Roadmap del Sistema.md>)** (backlog único: gaps técnicos B–E + pendientes de producto + higiene). Esta §13.3 es el detalle técnico; el roadmap es la lista accionable.
>
> **Cómo se pasan la posta los tres documentos de operación** (`Roadmap → Bitácora → CHANGELOG`, futuro → handoff → memoria) está explicado en [SOP Maestro](<SOP Maestro.md>) §6 → "Flujo de operación del sistema". Acá basta saber que el Roadmap es de dónde sale el trabajo, la [[Bitácora de Agentes]] es el handoff entre sesiones, y el [CHANGELOG del Sistema](<CHANGELOG del Sistema.md>) es la memoria permanente de lo estructural.

---

## 14. Referencias oficiales 2026 (fuentes verificadas)

**AGENTS.md (estándar):**
- Sitio del estándar — https://agents.md/
- Repo del formato (Agentic AI Foundation / Linux Foundation) — https://github.com/agentsmd/agents.md
- InfoQ, "AGENTS.md Emerges as Open Standard" — https://www.infoq.com/news/2025/08/agents-md/

**Codex (OpenAI):**
- Custom instructions with AGENTS.md — https://developers.openai.com/codex/guides/agents-md
- Subagents — https://developers.openai.com/codex/subagents
- Worktrees (Codex App) — https://developers.openai.com/codex/app/worktrees
- Changelog — https://developers.openai.com/codex/changelog

**Antigravity (Google):**
- Agent Manager (doc oficial) — https://antigravity.google/docs/agent-manager
- Google Developers Blog, "Build with Google Antigravity" — https://developers.googleblog.com/build-with-google-antigravity-our-new-agentic-development-platform/
- Codelab: pipelines con agents.md y skills.md — https://codelabs.developers.google.com/autonomous-ai-developer-pipelines-antigravity

**Claude Code (Anthropic):**
- Run agents in parallel — https://code.claude.com/docs/en/agents
- Run parallel sessions with worktrees — https://code.claude.com/docs/en/worktrees
- How Claude remembers your project (memory) — https://code.claude.com/docs/en/memory
- Feature request AGENTS.md nativo (#34235) — https://github.com/anthropics/claude-code/issues/34235

**Agentes open-source / portabilidad (§9):**
- Hermes Agent (Nous Research) — https://github.com/NousResearch/hermes-agent · `AGENTS.md` del repo: https://github.com/NousResearch/hermes-agent/blob/main/AGENTS.md
- OpenCode — https://opencode.ai/
- Aider (auto-commit a git) — https://aider.chat/
- Awesome CLI coding agents (directorio del ecosistema) — https://github.com/bradAGI/awesome-cli-coding-agents

**Capa modelo / harness / empresa (§12):**
- OpenRouter (gateway de modelos, capa 1) — https://openrouter.ai/
- Claude Agent SDK (construir harness propio) — https://code.claude.com/docs/en/sdk
- Arquitectura multi-agente empresarial sobre Obsidian — Albert López / Deleguía (video) — https://youtu.be/Fg0NdaSSlUQ
- Concepto "agent harness" (5 piezas) — ejemplo Hermes (ver referencias de §9)

**Prior art / estado del arte (§13):**
- obsidian-second-brain (cross-CLI, incluye Hermes) — https://github.com/eugeniughelbur/obsidian-second-brain
- obsidian-mind (memoria persistente vía hooks) — https://github.com/breferrari/obsidian-mind
- claude-obsidian (LLM Wiki Karpathy, 8.3k★, locks advisory) — https://github.com/AgriciDaniel/claude-obsidian
- Comparativa de orquestadores worktree 2026 (Vibe Kanban, Conductor, Claude Squad…) — https://nimbalyst.com/blog/best-git-worktree-tools-ai-coding-2026/
- The Code Agent Orchestra — Addy Osmani — https://addyosmani.com/blog/code-agent-orchestra/
- The Agent-Native Repo (AGENTS.md ownership) — Harness — https://www.harness.io/blog/the-agent-native-repo-why-agents-md-is-the-new-standard

**Git:**
- git-worktree (doc oficial) — https://git-scm.com/docs/git-worktree
- per-worktree config (`extensions.worktreeConfig`) — https://github.com/git/git/commit/58b284a2e9123588eedc8c5ee17e8b069d9454f8
- Conventional Commits — https://www.conventionalcommits.org/

---

## Referencias internas

- [SOP Interoperabilidad IA](<SOP Interoperabilidad IA.md>) — la convención de archivos-ley (Ley/Mapa/Estado/Arquitectura/Capacidad)
- [SOP Git y Flujo de Trabajo](<SOP Git y Flujo de Trabajo.md>) — Conventional Commits y comandos git del vault
- [AGENTS](<../AGENTS.md>) · [CLAUDE](<../CLAUDE.md>) — los archivos-ley actuales del vault
- [Blueprint de Sistemas](<Blueprint de Sistemas.md>) — cómo se arma un sistema interoperable
- [Tipos de Documentación](<Tipos de Documentación.md>) — por qué esto es Explanation y no SOP
- [Skill - Mantenimiento Sistema](<../04 Knowledge/Skills/Skill - Mantenimiento Sistema.md>) — quién audita que las leyes no divergan
- Patrón Orquestador vs Patrón Asesor — los dos modelos de coordinación (jefe reparte vs. empleado consulta) explicados sin tecnicismos

## Cómo leer este documento
Es de **estudio** (Explanation): leelo de corrido una vez para entender las tres capas (§1) y el concepto de worktree (§4.2). Después usalo como referencia: cuando vayas a implementar, seguí el flujo §6 y resolvé las decisiones abiertas §11. Cuando lo hayas ejecutado 1–2 veces, promové las partes operativas a los SOPs (§10).
