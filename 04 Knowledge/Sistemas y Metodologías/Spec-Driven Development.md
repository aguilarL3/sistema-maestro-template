---
type: Explanation
title: "Spec-Driven Development"
description: "Del vibe coding a la ingeniería agéntica: por qué en 2026 se construye software a partir de una especificación viva, y cómo los 6 documentos clásicos se absorbieron en el spec."
tags: [spec-driven, vibe-coding, sdd, agentes, desarrollo, metodologia, prd]
estado: 🟢 Activo
id: "EXP-023"
fecha_creacion: 2026-07-21
timestamp: 2026-07-21T00:00:00Z
life_areas: [profesional]
domains: [ia, automatizacion, carrera]
sources: [Andrej Karpathy, GitHub Spec Kit, AWS Kiro, Harper Reed, Jose Andonaire]
moc_principal: "[[MOC - Agentes]]"
resource:
---

>[!info] Documentación relacionada
>[SOP Proyectos de Código](<../../00 Sistema/SOP Proyectos de Código.md>) (el *cómo* ejecutable) | [Investigación Previa (Discovery)](<Investigación Previa (Discovery).md>) (la Fase 0, va antes) | [Catálogo de Tipos de Documentación](<Catálogo de Tipos de Documentación.md>) | [Glosario de términos](<../../00 Sistema/Glosario de términos.md>)

# Spec-Driven Development

Nota de **estudio**: entender la disciplina con la que se construye software con agentes de IA en 2026 — qué es una *especificación*, por qué reemplazó al "vibe coding", y cómo pensar el flujo antes de codear. El **cómo operativo** (kickoff, frontera vault↔repo, hooks) vive en [SOP Proyectos de Código](<../../00 Sistema/SOP Proyectos de Código.md>); esto es el **porqué y el cómo pensarlo**.

> **La idea en una frase:** antes de que el agente escriba código, escribís *qué* querés y *por qué* en una especificación que vive en el repo, evoluciona con el proyecto, y se vuelve la fuente de verdad que el agente lee en cada sesión. La spec no es un documento que redactás y guardás — es un artefacto vivo que dirige la construcción.

---

## 1. De dónde viene: el vibe coding y por qué terminó

**Vibe coding** (término acuñado por **Andrej Karpathy**, feb-2025): describir lo que querés en lenguaje natural y dejar que el modelo improvise el código, iterando por "vibra" sin planificar. Genial para prototipos, scripts y exploración.

Su límite apareció rápido en producción: sin un plan explícito, el agente llena los huecos con suposiciones, construye pantallas que funcionan sueltas pero no se conectan, y arrastra decisiones arquitectónicas malas que son caras de deshacer. Surgió hasta un nicho de mercado — los *"vibe-coding cleanup specialists"*, gente contratada para estabilizar proyectos vibe-codeados que reventaron.

El giro es que **el propio Karpathy declaró, un año después (2026), que la era del vibe coding se está terminando** y que entramos en la **"ingeniería agéntica"**: orquestar agentes contra **especificaciones detalladas** con supervisión humana. No es volver a la burocracia del waterfall — es recuperar el plan sin perder la velocidad del agente.

---

## 2. Qué es Spec-Driven Development (SDD)

SDD invierte la relación entre plan y código: **primero la especificación estructurada, después el código que la satisface**. La spec deja de ser documentación que se escribe *después* y se vuelve el centro del proceso — el agente genera, testea y valida contra ella.

El flujo estándar 2026 (formalizado por **GitHub Spec Kit**) tiene **4 fases + 1 constitución**:

| Fase | Comando (Spec Kit) | Produce | Responde |
|---|---|---|---|
| **Constitution** | `/constitution` | Principios del proyecto (el `AGENTS.md`/`CLAUDE.md` del producto) | Las reglas inamovibles |
| **Specify** | `/specify` | La spec: user journeys, éxito, alcance | *Qué* y *por qué* (sin tocar el stack) |
| **Plan** | `/plan` | Plan técnico: stack, arquitectura, datos | *Cómo*, a alto nivel |
| **Tasks** | `/tasks` | Lista granular, cada tarea testeable en aislamiento | El backlog ejecutable |
| **Implement** | `/implement` | Código por cambios chicos y revisables | La construcción |

La variante de **AWS Kiro** es casi idéntica: `requirements.md` (en notación EARS) → `design.md` → `tasks.md`. La diferencia entre herramientas es de empaque; **el flujo qué → cómo → tareas es el mismo en todas**.

> Conexión con tu sistema: el **modo plan de Claude Code** es la versión nativa de *Specify + Plan* dentro del harness — *Explore → Plan → Implement → Commit*. No necesitás instalar Spec Kit para hacer SDD; el patrón se hace **a mano** (estilo Harper Reed, más liviano para solo-dev). Ver [SOP Proyectos de Código](<../../00 Sistema/SOP Proyectos de Código.md>) §3.

---

## 3. Anatomía del spec (qué es exactamente)

El **spec** es el artefacto central de todo el flujo — del que todo lo demás deriva. Precisión importante: en la práctica "el spec" son **cuatro piezas**, no un solo documento. Una constitución por proyecto, y una trinidad **qué → cómo → tareas** por feature, en `specs/<feature>/`:

| Pieza | Alcance | Es | Regla de oro |
|---|---|---|---|
| **`constitution.md`** | Todo el proyecto | Los principios inamovibles | Se escribe una vez; rara vez cambia. |
| **`spec.md`** | Una feature | El *qué* y el *por qué* | **No menciona el stack.** Si nombra React o Postgres, es plan disfrazado de spec. |
| **`plan.md`** | Una feature | El *cómo* técnico | Deriva del spec, no lo reemplaza. |
| **`tasks.md`** | Una feature | Los *pasos* | Cada tarea implementable y testeable en aislamiento. Es el backlog ejecutable. |

Toda esta sección sigue **la misma feature de punta a punta** — "Recordatorios de reunión" de una app para un club de lectura (ejemplo inventado) — para que veas cómo una pieza deriva de la anterior.

---

### 3.1 · `spec.md` — el *qué* y el *por qué*

Es el PRD absorbido, ahora vivo. Su trabajo es que cualquiera (humano o agente) sepa **qué construir y por qué**, sin que nadie tenga que preguntarte. Secciones canónicas, con qué hace buena a cada una y su anti-patrón:

| Sección | Qué buscar | Anti-patrón (la mata) |
|---|---|---|
| **Problema** | El dolor concreto y quién lo siente, en términos de negocio | "Falta un sistema de recordatorios" (eso es una solución, no un problema) |
| **Usuario objetivo** | Una persona real, 2-3 frases, con su contexto | "Los usuarios" (genérico → el agente inventa) |
| **User journeys** | Los 2-3 recorridos clave, paso a paso, en lenguaje de usuario | Pantallas sueltas sin secuencia |
| **Criterios de éxito** | Medibles, atados al problema | "Que funcione bien" (no verificable) |
| **Alcance** | Qué entra en *esta* versión | Una lista de deseos sin corte |
| **Fuera de alcance** | Qué explícitamente *no* hace | Omitirla — es la sección más subestimada: sin ella el agente rellena con suposiciones |

> **Por qué "fuera de alcance" es la sección más importante:** el agente, ante un hueco, no pregunta — inventa. Escribir "v1 solo avisa de la reunión, no gestiona las lecturas" ahorra que te construya un módulo de lecturas que no pediste. Cada línea de *fuera de alcance* es una alucinación que no va a pasar.

**El `spec.md` completo — nótese: cero tecnología.**

```markdown
# Spec — Recordatorios de reunión

## Problema
Los miembros del club de lectura olvidan la reunión mensual. Hoy el
organizador los va avisando a mano por mensajería: pierde tiempo y
aun así varios faltan porque el aviso les llega tarde o no les llega.

## Usuario objetivo
El organizador del club (una persona) coordina ~15 miembros. No es
técnico. Quiere dejar de avisar a mano y decidir a quién y cuándo se
le manda el recordatorio.

## User journey principal — "avisar antes de la reunión"
1. El sistema detecta que la próxima reunión es en 3 días.
2. Genera un recordatorio en estado "pendiente" con fecha, hora y libro.
3. El organizador ve la lista de pendientes y aprueba (o descarta) cada uno.
4. Al aprobar, cada miembro recibe el aviso por su canal.
5. El recordatorio pasa a "enviado" y queda registrado.

## User journey secundario — "ya confirmó, no insistir"
1. Un miembro confirma que asiste.
2. El sistema no le genera recordatorios extra para esa reunión.

## Criterios de éxito
- El organizador deja de avisar manualmente (0 min/semana en eso).
- La ausencia por olvido baja a casi cero.
- Ningún aviso se envía sin que el organizador lo apruebe.

## Fuera de alcance (v1)
- Gestión de las lecturas o del libro en sí (solo avisa de la reunión).
- Multi-idioma: solo español.
- Panel de métricas de asistencia.
- Más de un club a la vez.
```

**Notación EARS (opcional, para los requisitos que no toleran ambigüedad).** AWS Kiro usa **EARS** (*Easy Approach to Requirements Syntax*): una sola forma gramatical por requisito, para que no haya dos lecturas. La plantilla más común:

> **CUANDO** [disparador], **EL SISTEMA DEBE** [respuesta].

Aplicada a esta feature:
- *Cuando la próxima reunión es en 3 días y el miembro no confirmó asistencia, el sistema debe generar un recordatorio en estado pendiente.*
- *Cuando el organizador aprueba un recordatorio pendiente, el sistema debe enviarlo por el canal del miembro y marcarlo como enviado.*
- *Mientras un miembro tenga la asistencia confirmada, el sistema no debe generarle recordatorios extra para esa reunión.*

No escribas todo el spec en EARS — usalo solo donde la ambigüedad cuesta caro (dinero, permisos, estados, seguridad).

---

### 3.2 · `plan.md` — el *cómo* técnico

Recién acá entra la tecnología. El `plan.md` **deriva del spec**: toma cada requisito del *qué* y responde con *cómo* se implementa, dado tu stack y tus restricciones. Es el TRD + el Esquema de Backend + el Brief UI/UX, fusionados. Secciones típicas:

1. **Stack** — lenguaje, framework, DB, hosting, servicios de terceros.
2. **Arquitectura** — cómo se conectan las piezas (qué corre dónde, qué dispara qué).
3. **Modelo de datos** — tablas, columnas, relaciones, índices.
4. **Integraciones** — APIs externas, con su modo de fallo.
5. **Restricciones** — lo inamovible (presupuesto, "solo nivel gratuito", "debe correr en móvil").
6. **Riesgos / decisiones abiertas** — lo que todavía no está resuelto.

**El `plan.md` de la misma feature:**

```markdown
# Plan — Recordatorios de reunión

## Stack
- App existente: Next.js 14 + Supabase (Postgres) — ya en producción.
- Programación: Supabase cron (pg_cron), corrida diaria 09:00.
- Canal de aviso: API de mensajería ya integrada para el onboarding.

## Arquitectura
1. Job diario (cron) busca reuniones que caen en 3 días.
2. Inserta filas en `meeting_reminders` con estado 'pending' (una por
   miembro sin asistencia confirmada).
3. El organizador ve los 'pending' en el dashboard; aprueba → llama a la
   API de mensajería → estado 'sent'. Nada se envía sin ese paso humano.

## Modelo de datos
Tabla nueva: meeting_reminders
- id (uuid, pk)
- member_id (uuid, fk → members.id)
- meeting_date (date)
- status (text: 'pending' | 'sent' | 'discarded')
- created_at (timestamp), sent_at (timestamp, null)
Índice: (status, meeting_date) para listar pendientes rápido.
RLS: solo el rol organizador lee/escribe.

## Integraciones
- API de mensajería: si falla el envío, el recordatorio queda 'pending'
  (no se pierde) y se muestra el error al organizador. Reintento manual.

## Restricciones
- No agregar dependencias nuevas: usar lo que ya está (Supabase + API de mensajería).
- Costo cero adicional (cron de Supabase, no un servicio aparte).

## Decisiones abiertas
- ¿El canal del miembro es siempre el mismo o algunos prefieren email?
  → confirmar con el organizador antes de la tarea de envío.
```

> Fijate la trazabilidad: cada línea del plan responde a algo del spec. "Nada se envía sin aprobación humana" (plan) ↔ "ningún aviso se envía sin que el organizador lo apruebe" (criterio de éxito del spec). Si el plan contradice el spec, **gana el spec** — o se corrige el spec a conciencia.

---

### 3.3 · `tasks.md` — los *pasos*

Es el Plan de Implementación absorbido, y **es tu backlog de producto** (la respuesta a "dónde viven las tareas"). Regla de Harper Reed: cada tarea debe ser **implementable y testeable en aislamiento**, y no debe haber saltos de complejidad — si una tarea es "construir todo el envío", está mal cortada. El orden respeta dependencias: cimiento → lógica → interfaz → pulido.

**El `tasks.md` de la misma feature:**

```markdown
# Tasks — Recordatorios de reunión

## Fase 1 — Datos
- [ ] 1.1 Migración: crear tabla `meeting_reminders` + índice (status, meeting_date).
      Test: la migración corre y revierte limpia.
- [ ] 1.2 Política RLS: solo rol organizador. Test: un no-organizador no puede leer la tabla.

## Fase 2 — Generación (el cron)
- [ ] 2.1 Query: reuniones que caen en 3 días + miembros sin asistencia confirmada.
      Test: con datos sembrados, devuelve exactamente los esperados (borde: reunión en 4 días → no).
- [ ] 2.2 Job cron que inserta 'pending' sin duplicar. Test: correrlo dos veces
      no crea el mismo recordatorio dos veces.

## Fase 3 — Aprobación (interfaz del organizador)
- [ ] 3.1 Vista de pendientes (miembro, fecha, libro). Test: muestra solo 'pending'.
- [ ] 3.2 Acción aprobar → llama la API de mensajería → 'sent'. Test: mockeando la API,
      el estado pasa a 'sent' y se setea sent_at.
- [ ] 3.3 Acción descartar → 'discarded'. Test: no vuelve a aparecer en pendientes.

## Fase 4 — Bordes y cierre
- [ ] 4.1 Fallo de envío deja 'pending' + muestra error. Test: API que devuelve 500.
- [ ] 4.2 Miembro con asistencia confirmada no genera recordatorio. Test: cubre el journey secundario.
```

> Cada tarea trae su **verificación** (el "Test:"). Ese es el corazón del SDD moderno: sin una verificación que el agente pueda correr, no hay sesión que puedas soltar — te volvés vos el loop de control. Ver [[Verificación determinista vs criterio del agente]].

---

### 3.4 · `constitution.md` — la ley del proyecto

Lo que el PDF de los 6 documentos **no tenía**. Vale para *todas* las features, no para una: son los principios que el agente no debe violar nunca, aunque una tarea suelta lo tiente. Es el `AGENTS.md`/`CLAUDE.md` del producto (mismo rol que en tu vault). Se escribe una vez al kickoff y rara vez cambia.

```markdown
# Constitución — App del club de lectura (ejemplo)

## Principios
- Ninguna acción con efecto externo (enviar un aviso, borrar datos de un miembro)
  se ejecuta sin aprobación humana explícita.
- Los datos de los miembros son privados. Nunca se exponen fuera
  del rol organizador (RLS siempre).
- Sin dependencias nuevas sin justificación escrita en un ADR.
- Todo cambio entra con su test en verde. Sin test, no se mergea.

## Convenciones
- Commits: Conventional Commits. Migraciones: una por cambio, reversible.
- Stack fijo: Next.js + Supabase. No introducir otro framework.
```

> Diferencia clave con el spec: el **spec cambia por feature**; la **constitución es transversal y estable**. Cuando el agente duda entre dos caminos, la constitución desempata.

---

### 3.5 · Cómo se encadenan y el ciclo de vida (artefacto vivo)

Las cuatro piezas no son documentos que se archivan — **evolucionan con el proyecto**. La cadena de derivación y qué pasa cuando algo cambia:

```
constitution.md   (estable, transversal)
        │  enmarca a todas las features
        ▼
   spec.md  ──deriva──▶  plan.md  ──deriva──▶  tasks.md  ──▶  código
   (qué/porqué)          (cómo)               (pasos+tests)
        ▲                                                        │
        └──────────  si cambia el requisito, se edita ACÁ  ◀─────┘
                     y la corrección baja spec → plan → tasks
```

La regla que lo hace "vivo": **cuando un requisito cambia, se edita el spec primero**, y desde ahí se propaga al plan y a las tasks — no se parchea el código y se deja el spec mintiendo. Si el código y el spec discrepan, el spec es la fuente de verdad (o se corrige a conciencia). Es la misma disciplina anti-drift del vault: la intención vive donde se mantiene, no dispersa en el resultado.

---

## 4. Los 6 documentos clásicos y cómo se absorbieron en el spec

La guía popular de **Jose Andonaire** ("Los 6 documentos que necesitás antes de escribir código") es la versión **manual y estática** de SDD: 6 documentos sueltos que pegabas al inicio del chat. En 2026 esos 6 no desaparecieron — **se fusionaron en menos artefactos y se volvieron vivos**:

| Los 6 docs (2024-25) | Qué contenía | Dónde vive ahora |
|---|---|---|
| **01 · PRD** | Qué construir y para quién | dentro del **Spec** (*Specify*) |
| **02 · TRD** | Qué stack, framework, DB, APIs | dentro del **Plan** |
| **03 · Flujo de App** | Cada pantalla, cada ruta | dentro del **Spec** (se fusionó con el PRD) |
| **04 · Brief UI/UX** | Colores, tipografía, estética | dentro del **Plan** |
| **05 · Esquema de Backend** | Tablas, relaciones, auth, RLS | dentro del **Plan** |
| **06 · Plan de Implementación** | Fases numeradas de construcción | se volvió **Tasks** |
| *(no existía)* | Principios del proyecto | la **Constitution** — lo que el PDF *no tenía* |

Dos cambios de fondo respecto del PDF:

1. **Agrupación:** de 6 documentos a ~3-4 artefactos (Spec / Plan / Tasks + Constitución). El PRD dejó de ser un documento aparte y pasó a ser *la primera mitad del spec*.
2. **Artefacto vivo, no estático:** el PDF proponía escribir los 6, pegarlos al chat una vez, y que quedaran ahí envejeciendo. SDD los pone **dentro del repo** (`specs/<feature>/spec.md · plan.md · tasks.md`), el agente los lee en cada sesión, y **se actualizan cuando cambian los requisitos**. Es el mismo espíritu que el `AGENTS.md`/`CLAUDE.md` del vault: contexto que persiste y manda, no un brief que se lee una vez.

> Analogía con el vault: es como cuando la Plantilla Nota **absorbió** la evergreen (una nota viva = la misma plantilla con `estado: 🌱`). El PRD no murió — se volvió una *sección viva del spec*, igual que la evergreen se volvió un *estado de la nota*.

---

## 5. Cuándo vibear y cuándo especificar

No todo merece una spec. La regla operativa 2026:

> **Vibe-codeá cuando el costo de equivocarte es mínimo** (prototipos, scripts, exploración, pruebas desechables). **Pasá a spec en el momento en que una feature toca dinero, autenticación o datos compartidos.**

El punto dulce para un solo-dev suele ser **empezar vibeando para explorar y aterrizar la idea, y cambiar a SDD cuando la idea se solidifica y hay que construirla en serio.** El error es quedarse en vibe coding después de ese umbral — ahí es donde nacen los proyectos que hay que "limpiar" después.

---

## 6. El cambio de mentalidad (por qué esto importa)

SDD no es "más documentación". Es mover el trabajo de pensar **antes** de codear, cuando corregir es barato (editar una frase del spec) en vez de **después**, cuando corregir es caro (reescribir migraciones con datos adentro). Es la misma disciplina de [Investigación Previa (Discovery)](<Investigación Previa (Discovery).md>) llevada a la construcción: *decidir con información suficiente antes de tocar nada.*

Tres frases para recordar:
1. **"El spec es la fuente de verdad, no el código."** (el código satisface el spec, no al revés)
2. **"Vivo, no estático."** (vive en el repo y evoluciona; no es un brief que se lee una vez)
3. **"Vibear para explorar, especificar para construir."** (el umbral: dinero, auth, datos compartidos)

---

## 7. Dónde encaja en el sistema

```
Discovery (¿ya existe? ¿build/buy?)   → Investigación Previa (Discovery) — Fase 0
        ↓
Constitution + Spec + Plan + Tasks    → esta disciplina (SDD)
        ↓
Kickoff + frontera vault↔repo         → SOP Proyectos de Código (el cómo)
        ↓
Explore → Plan → Implement → Commit    → plan mode de Claude Code (el loop diario)
```

- El **cómo ejecutable** (dónde nace el repo, qué guarda el vault, qué hooks se portan) está en [SOP Proyectos de Código](<../../00 Sistema/SOP Proyectos de Código.md>).
- El **prior art que validó el flujo** contra la industria (Anthropic, GitHub Spec Kit, AWS Kiro, BMAD, Harper Reed) está resumido en §1-§2 de esta nota.

### 7.1 · De Discovery a Spec (el handoff)
[Investigación Previa (Discovery)](<Investigación Previa (Discovery).md>) es la **Fase 0**: responde *¿ya existe?, ¿qué dice la doc oficial?, ¿lo construyo, compro o adopto?* Es **timeboxed** y **por proyecto** (una vez, al arranque). El spec es lo que sigue, y **hereda las salidas del discovery**:

| Sale del Discovery | Entra en… |
|---|---|
| Decisión Build/Buy/Adopt (ej. "adoptar Supabase, no construir auth") | una **restricción** del `plan.md` |
| Prior art / cómo lo resuelven otros | los **user journeys** del `spec.md` |
| Feasibility (¿es viable en el timebox?) | el **alcance** y el **fuera de alcance** del `spec.md` |

> La frontera limpia: **Discovery decide *si* y *con qué approach*; el spec decide *qué exactamente*.** Sin discovery, el spec parte de supuestos no verificados; sin spec, el discovery no aterriza en nada construible. Van encadenados, no son lo mismo.

### 7.2 · El loop diario: plan mode
Los cuatro artefactos (`constitution`/`spec`/`plan`/`tasks`) son **durables** — viven en el repo y sobreviven a las sesiones. El **[plan mode de Claude Code](<../Temas/Plan mode - explorar y planificar antes de tocar nada.md>)** es lo **efímero**: la planificación *dentro de una sesión*, para ejecutar un ítem del `tasks.md`. El ciclo (SOP-013 §3):

```
Explore  → el agente lee spec/plan/tasks y el código relevante
Plan     → propone cómo hará ESTA tarea (plan mode: lo revisás antes de que toque nada)
Implement→ escribe el código
Commit   → con su test en verde
```

Regla práctica: **plan mode para cambios multi-archivo; directo para fixes de una línea.** Para una feature grande: entrevistá al agente → que escriba el `spec.md` → **sesión fresca** ejecuta la spec (contexto limpio). El plan mode es, en miniatura y en vivo, el mismo *Specify + Plan* que los artefactos hacen en grande y en durable.

### 7.3 · Backlog y roadmap: los tres niveles
Tu pregunta de "dónde viven las tareas" tiene **tres capas**, y conviene no mezclarlas:

| Nivel | Qué es | Dónde vive | Horizonte |
|---|---|---|---|
| **Roadmap del producto** | Qué features y en qué orden | Nota de proyecto en `03 Proyectos/` (vault) | Estratégico (meses) |
| **Backlog de feature** | Los pasos de *una* feature | `specs/<feature>/tasks.md` (repo) | Táctico (días) |
| *(no confundir)* Roadmap del Sistema | Evolución del *vault*, no de un producto | [Roadmap del Sistema](<../../01 Index/Roadmap del Sistema.md>) | — |

Cómo se encadenan: el **roadmap del producto** elige la próxima feature → esa feature recibe su **`spec.md`** → el spec deriva su **`tasks.md`**, que *es* el backlog ejecutable. Roadmap → spec → backlog. El roadmap dice *qué sigue*; el backlog dice *cómo se hace lo que sigue*.

### 7.4 · Cómo evoluciona una spec (versionado)
"Artefacto vivo" en concreto:
- **Por feature, no monolítico:** cada feature es su carpeta numerada — `specs/001-recordatorios/`, `specs/002-.../`. No hay un spec gigante que se reescribe; hay specs chicas que se acumulan.
- **Feature entregada ≠ spec archivada:** el `spec.md` de algo ya en producción sigue reflejando la intención vigente. Si mañana cambiás el comportamiento, **editás ese spec primero** y la corrección baja a plan → tasks → código (§3.5).
- **Historial:** el versionado real lo da **git** (el repo guarda cada cambio del spec). Para cambios de fondo, un ADR técnico en `docs/adr/` registra el *por qué*; una decisión de producto vuelve al vault y se re-exporta (SOP-013 §1).

### Herramientas 2026 (para referencia, no para adoptar por defecto)
- **GitHub Spec Kit** (MIT, oficial) — el patrón se lleva a tu stack, funciona con 30+ agentes.
- **AWS Kiro** — IDE propio spec-driven; potente pero atado a su entorno.
- **Claude Code** — plan mode nativo; el patrón `specs/` se hace a mano (recomendado para solo-dev).

---

## Para profundizar (fuentes)
- Karpathy — vibe coding y el giro a ingeniería agéntica (2025-2026)
- GitHub Spec Kit → https://github.com/github/spec-kit · [blog](https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/)
- Harper Reed — My LLM codegen workflow → https://harper.blog/2025/02/16/my-llm-codegen-workflow-atm/
- Jose Andonaire — "Los 6 documentos" (fuente cruda procesada en esta nota)
- Vibe Coding vs Spec-Driven Development (2026) — Augment Code

## Cómo estudiar esta nota
El corazón es **§3 (anatomía del spec)** — recorré las cuatro piezas (constitución → spec → plan → tasks) siguiendo la feature de ejemplo, hasta que puedas escribir un `spec.md` solo y derivar el resto. Alrededor: §1 (por qué terminó el vibe coding) y §6 (el cambio de mentalidad) dan el porqué; §2 es el flujo; §4 el mapeo de los 6 docs; §5 cuándo usarlo. Cuando vayas a construir un producto real, la secuencia es: §7 (dónde encaja) → [Investigación Previa (Discovery)](<Investigación Previa (Discovery).md>) para la Fase 0 → [SOP Proyectos de Código](<../../00 Sistema/SOP Proyectos de Código.md>) para ejecutar.
