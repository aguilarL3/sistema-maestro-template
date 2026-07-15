---
tipo_doc: How-to
tags: [sop, ia, interoperabilidad, arquitectura, conectores]
estado: 🟢 Activo
prioridad: 🔥 Alta
responsable: "{{OWNER}}"
id: "SOP-INTEROP-001"
ultima_revision: 2026-06-26
fecha_creacion: 2026-06-26
---

>[!info] Documentación relacionada
>[[AGENTS]] | [[SOP IA]] | [[SOP Skills]] | [[SOP Conectores]] | [[Blueprint de Sistemas]] | [[Glosario de términos]]

# SOP Interoperabilidad IA

## Objetivo

Definir **cómo cualquier IA (Claude, GPT, Gemini, agentes, un ERP a futuro) entiende y opera sobre cualquier sistema** —el vault, una LLM Wiki, una base documental, un ERP— siguiendo una convención común.

Este SOP es **general**. No describe solo el vault: describe el protocolo que todo sistema del ecosistema de {{OWNER}} debe seguir para ser legible por IA. El vault es el **primer ejemplo aplicado** (ver §6).

> **Principio rector:** una IA no adivina dónde está la información. La encuentra por **convención**, no por exploración. El sistema le dice qué leer, en qué orden y con qué autoridad.

---

## 1. La convención: archivos estándar legibles por IA

A 2026 existe una convención ampliamente adoptada, formalizada por OpenAI, Anthropic, Google, Cursor y Sourcegraph (ago 2025) y donada a la Agentic AI Foundation bajo la Linux Foundation (dic 2025). Los principales agentes que la soportan (Claude Code, Codex, Cursor, Gemini CLI, GitHub Copilot, entre otros) buscan estos archivos cuando están presentes:

| Archivo | Alcance | Quién lo lee | Función |
|---|---|---|---|
| `CLAUDE.md` | Específico de herramienta | Solo Claude Code | Instrucciones operativas del agente. Máxima autoridad en sesión Claude. |
| `AGENTS.md` | Universal | Agentes que soportan la convención | Ley del sistema: propósito, reglas, arquitectura. |
| `llms.txt` | Universal | IA que implemente la convención `llms.txt` | Mapa / índice: dónde está cada cosa y qué leer primero. |
| `SKILL.md` / Skills | Ejecutable | Agentes con herramientas | Capacidades: qué puede *hacer* la IA sobre el sistema. |

**Regla de autoridad (convención de ESTE ecosistema, de mayor a menor):**
```
CLAUDE.md  →  AGENTS.md  →  llms.txt  →  Skills  →  resto de la documentación
```
Esta precedencia es la convención adoptada en el Sistema Maestro, no una ley universal: no todas las herramientas implementan exactamente el mismo orden. Si hay conflicto, gana el de mayor autoridad. `CLAUDE.md` solo aplica a Claude; para otras IAs la cima es `AGENTS.md`.

---

## 2. Jerarquía de lectura (el flujo de entrada)

Cuando una IA entra a un sistema por primera vez, sigue este flujo:

```
1. ¿Existe CLAUDE.md / AGENTS.md en la raíz?
   └─ Sí → leerlo PRIMERO. Define reglas y prohibiciones.
2. ¿Existe llms.txt?
   └─ Sí → es el mapa. Dice qué documentos importan y en qué orden.
3. Identificar la tarea.
   └─ ¿Requiere ejecutar algo? → buscar Skills.
   └─ ¿Requiere entender un sistema externo? → buscar su doc en Conectores.
4. Verificar antes de actuar.
   └─ ¿Ya existe? No duplicar. ¿Hay que borrar? Proponer, no decidir.
5. Actuar según las reglas leídas en el paso 1.
```

**Por qué importa el orden:** leer las reglas *antes* de actuar evita que la IA rompa convenciones, duplique contenido o borre sin autorización. El paso 1 es innegociable.

---

## 3. Progressive disclosure (divulgación progresiva)

Principio clave 2026: **no cargar todo de golpe**. La IA lee de lo general a lo específico solo cuando lo necesita.

```
AGENTS.md (siempre)
  → llms.txt (mapa, siempre)
    → documento específico (solo si la tarea lo requiere)
      → sección específica del documento (solo lo relevante)
```

Esto mantiene el contexto limpio y evita que la IA se sature con información que no usa. Un buen `llms.txt` permite que la IA **salte** directo a lo que necesita sin leer todo.

---

## 4. Los tres tipos de documento legible por IA

Todo sistema interoperable se documenta en tres capas. No confundirlas:

| Tipo | Responde a | Ejemplo en el vault | Vive en |
|---|---|---|---|
| **Ley** | ¿Cuáles son las reglas? | `AGENTS.md` | Raíz |
| **Mapa** | ¿Dónde está cada cosa? | `llms.txt` | Raíz |
| **Estado** | ¿Qué cambió desde la última vez? | `Dashboard-CEO.md` · changelog | Raíz / por-sistema |
| **Arquitectura** | ¿Cómo está construido el sistema X? | `Conectores/Notion - Arquitectura.md` | `04 Knowledge/Conectores/` |
| **Capacidad** | ¿Qué puedo *hacer* sobre el sistema? | `Skills/Skill - ...` | `04 Knowledge/Skills/` |

**Regla:** Ley, Mapa y Estado son universales (una IA los necesita para *entender* y para *no repetir trabajo*). Arquitectura y Capacidad son por-sistema (una IA los necesita para *operar*).

> **La capa Estado (5ª)** es clave en 2026: cada vez más agentes consultan *primero* qué cambió (changelog, status, dashboard) antes de empezar, para no rehacer tareas ya hechas. En el vault ya existe como `Dashboard-CEO.md` y los changelog de cada doc de `Conectores/`.

---

## 5. Estándares de comunicación entre sistemas (2026)

Cuando un sistema se comunica con otro (no solo una IA leyendo archivos), aplican protocolos:

| Convención | Creador | Para qué |
|---|---|---|
| **MCP** (Model Context Protocol) | Anthropic | Conectar una IA con herramientas, bases de datos y APIs externas. |
| **AGENTS.md** | OpenAI → Agentic AI Foundation / Linux Foundation | Convención de instrucciones legibles por IA. |
| **SKILL.md** (Agent Skills) | Anthropic (oct 2025; estándar abierto dic 2025) | Convención de capacidades ejecutables, adoptada por múltiples frameworks. |
| **A2A** (Agent-to-Agent) | Google | Comunicación entre agentes independientes. |

> En este sistema, los **conectores** (Notion, Drive, ERP futuro) se implementan vía **MCP**. La documentación de cada uno vive en `04 Knowledge/Conectores/` (ver [[SOP Conectores]]).

---

## 6. Ejemplo aplicado: el vault Sistema Maestro

El vault es el sistema #1 que sigue esta convención:

| Capa | Archivo del vault |
|---|---|
| Ley (Claude) | `CLAUDE.md` |
| Ley (universal) | `AGENTS.md` — protocolo de inicio de 8 pasos |
| Mapa | `llms.txt` (raíz) + `Vault System Map.md` |
| Arquitectura de sistemas externos | `04 Knowledge/Conectores/Notion - Arquitectura.md` |
| Capacidades | `04 Knowledge/Skills/` |

Cuando una IA entra al vault, `AGENTS.md` le dice: lee `SOP Maestro`, `SOP Index`, `Dashboard-CEO`, verificá si ya existe, no dupliques, no borres sin proponer. Ese es el flujo del §2 aplicado.

---

## 7. Cómo aplicar este protocolo a un sistema NUEVO

Cuando armes un sistema nuevo (ERP, LLM Wiki, base documental), seguí este checklist. Ver detalle en [[Blueprint de Sistemas]].

- [ ] **¿Tiene un archivo Ley?** Crear `AGENTS.md` (o equivalente) con propósito + reglas + prohibiciones.
- [ ] **¿Tiene un Mapa?** Crear `llms.txt` que liste qué leer y en qué orden.
- [ ] **¿Se conecta vía IA?** Documentar su arquitectura en `04 Knowledge/Conectores/` ([[SOP Conectores]]).
- [ ] **¿Tiene operaciones repetitivas?** Crear Skills ([[SOP Skills]]).
- [ ] **¿Cómo se mantiene fresco?** Registrarlo en el ciclo de [[Skill - Mantenimiento Sistema]].

---

## 8. Mantenimiento: el problema de la frescura

La documentación de IA **se desactualiza rápido** (los estándares cambian cada pocos meses). Verdad técnica:

> Un archivo `.md` es estático. **No puede actualizar su propia fecha.** No existe `date.now()` dentro de un documento.

La frescura no vive en el documento, vive en el **proceso**:

- Cada documento guarda `ultima_revision: YYYY-MM-DD` (estático).
- Un **Skill de mantenimiento** corre con la fecha real de hoy (la IA siempre la recibe en runtime), compara contra `ultima_revision`, marca lo vencido (+90 días), busca buenas prácticas actuales y **propone** mejoras.

Eso *es* el `date.now()` buscado: el Skill siempre sabe qué día es. Ver [[Skill - Mantenimiento Sistema]].

### Por qué la fecha NO se escribe en el documento (prompt caching)

Hay una razón técnica más allá de "el .md es estático". Los modelos cachean un **prefijo estático** (reglas del sistema, `AGENTS.md`, definiciones de herramientas) que debe permanecer inmutable durante la sesión para no recalcular todo el contexto. Si una IA reescribiera la fecha dentro de un archivo maestro en cada turno, invalidaría esa caché y dispararía costo y latencia.

Por eso la fecha viva se **inyecta como contexto volátil en runtime**, típicamente vía una directiva `<system-reminder>` en el flujo de mensajes — no se escribe en el archivo. El agente la lee al momento y la compara contra el `ultima_revision` estático del frontmatter.

> Esto está verificado en la práctica: este mismo sistema recibe la fecha de hoy por inyección de runtime, no leyéndola de ningún archivo del vault.

---

## 9. Errores comunes

| Error | Por qué falla | Cómo evitarlo |
|---|---|---|
| Duplicar reglas en varios archivos | Se desincronizan | Una sola fuente de verdad por regla. Enlazar, no copiar. |
| Documento sin `ultima_revision` | El mantenimiento no puede medir frescura | Frontmatter con fecha siempre. |
| Hardcodear la fecha "de hoy" en un doc | Queda congelada | La fecha viva vive en el Skill, no en el texto. |
| No tener `llms.txt` (Mapa) | La IA explora a ciegas y se satura | Crear el mapa raíz. |
| Mezclar Ley con Arquitectura | La IA no sabe qué es regla y qué es descripción | Separar las 4 capas del §4. |

---

## 10. Flujo completo

```
Sistema nuevo (vault / ERP / LLM Wiki / docs)
↓
Crear capa LEY (AGENTS.md): reglas + prohibiciones
↓
Crear capa MAPA (llms.txt): qué leer y en qué orden
↓
¿Se conecta vía IA? → documentar ARQUITECTURA en Conectores/
↓
¿Operaciones repetitivas? → crear SKILLS
↓
Registrar ultima_revision en cada doc
↓
Skill - Mantenimiento Sistema audita frescura periódicamente
  └─ propone mejoras según documentación actual (nunca aplica solo)
```

---

## 11. Horizonte futuro (escala empresarial — fuera de alcance hoy)

Estos estándares de 2026 son **reales y verificados**, pero aplican cuando un sistema **expone** agentes o servidores en red para que otros los consuman (un ERP sirviendo a terceros, agentes cruzando fronteras organizacionales). Hoy el Sistema Maestro **consume** conectores (Notion vía MCP), no expone ninguno — por eso quedan registrados acá, no en el cuerpo operativo. Cuando montes el conector del ERP, esta sección es el punto de partida.

| Estándar | Qué resuelve | Cuándo te aplica |
|---|---|---|
| **MCP stateless** (RC 2026-07-28) | Servidores MCP sin sesión, escalables tras balanceador de carga | Cuando *expongas* un servidor MCP propio |
| **`.well-known/mcp.json`** (Server Cards) *(path en estabilización: SEP-1649/2127)* | Descubrimiento automático de qué capacidades expone un servidor | Cuando otros agentes deban descubrir tu sistema |
| **DNS-AID / ANS** (Linux Foundation, jun 2026) | Identidad y verificación criptográfica de agentes vía DNS | Cuando agentes crucen fronteras de confianza / organizaciones |
| **GSD / Scout pattern** | Fases de contexto limpio con sub-agentes para tareas masivas | Cuando una tarea sature el contexto de un solo agente |
| **LLM Wiki topología** (`/raw/` `/wiki/` `log.md`) | Memoria compuesta mantenida por agentes | Cuando automatices la síntesis Raw → Knowledge |

> **Nota de procedencia:** estos puntos provienen de una auditoría externa (`05 Diario/Auditorías/auditoria ia 2026.md`). Se verificaron uno por uno antes de incluirlos. Lo no aplicable a la escala actual se documenta como horizonte, no como deuda inmediata.

---

## Referencias

- [[AGENTS]]
- [[SOP IA]]
- [[SOP Skills]]
- [[SOP Conectores]]
- [[Blueprint de Sistemas]]
- [[Skill - Mantenimiento Sistema]]
- [[Glosario de términos]]
- [[LLM Wiki]]

## Cómo leer este SOP
Primero entendé la convención (§1) y el flujo de entrada (§2). El resto se consulta cuando armás o mantenés un sistema. No hace falta memorizarlo: el documento te guía.
