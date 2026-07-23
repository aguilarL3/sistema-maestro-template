---
type: Changelog
title: "CHANGELOG del Sistema"
tags: [changelog, sistema]
description: "Registro de cambios del framework (template). Los cambios de tu instancia van en tu bitácora, no acá."
estado: 🟢 Activo
id: "LOG-001"
timestamp: 2026-07-17T00:00:00Z
fecha_creacion: 2026-07-04
resource:
---

# CHANGELOG del Sistema

Registro de cambios del **framework** (template). `update.sh` actualiza este archivo junto al resto del framework — **no anotes acá los cambios de tu instancia** (se pisarían en el próximo update): esos van en tu bitácora de agentes o en una nota propia.

## [1.4.0] — 2026-07-22
**Las actualizaciones del template dejan de depender de que alguien se acuerde.**
- **Añadido `.github/workflows/template-update.yml`:** cada lunes (y a demanda) compara tu `VERSION` con la del upstream y, si hay versión nueva, corre `update.sh --force` y **abre un PR** con los archivos de framework actualizados, listando qué cambió. Nada se mergea solo. Es el patrón cruft/copier: `./update.sh --check` ya existía, pero con un vault propio uno se olvida y con varios vaults de clientes no pasa nunca.
- **Tres decisiones de diseño del workflow:** (1) **se autodesactiva en el template mismo** —compara `origin` con `UPSTREAM_URL` normalizando `.git` y credenciales embebidas—, si no intentaría actualizarse contra sí mismo cada semana; (2) **reconstruye `owner.env` desde variables del repo**, porque está gitignoreado por ser identidad de la instancia y sin él `personalize.sh` no corre y el PR llegaría con `{{OWNER}}` sin reemplazar — si falta la variable `OWNER` el workflow **falla con error explícito** en vez de abrir un PR malo; (3) **cero actions de terceros** (solo `actions/checkout` + el `gh` del runner): una action de terceros en un workflow con permiso de escritura es superficie de cadena de suministro. Los valores de las variables entran por `env:` y **no** interpolados con `${{ }}` dentro del `run:` — un `${{ }}` en un script se sustituye como texto antes de que corra el shell, así que un valor con comillas o `$(...)` se ejecutaría (hardening estándar de Actions).
- **Límite conocido, manejado explícitamente:** el token de Actions **no puede crear ni modificar archivos de `.github/workflows/`** (GitHub rechaza el push). Si una versión nueva los cambia, el bot los revierte, abre el PR con el resto y lo avisa en el cuerpo; si eran lo único que cambió, no abre PR y deja la nota en el resumen de la corrida — nunca termina en silencio. Se completa con un `./update.sh` local. Se descartó pedir un PAT con scope `workflow`: sería un secreto de larga vida en cada vault derivado.
- **Documentado** en el [Catálogo de Hooks y Locks](<../04 Knowledge/Automatización/Catálogo de Hooks y Locks.md>) (sección nueva "Workflows de GitHub Actions", con los dos workflows) y en el README (cómo activarlo: variables de repo + permisos de Actions).

## [1.3.0] — 2026-07-22
**El gate deja de depender de la máquina de quien commitea.** Los git hooks corren en el clon local y solo si esa persona corrió `./setup.sh`; ahora el mismo control corre también en el servidor.
- **Añadido `.github/workflows/verify.yml`:** status check en cada PR. **Invoca los mismos scripts de `.claude/hooks/`**, no una implementación paralela que pueda divergir. Reparto de severidad deliberado — `secret-scan` **bloquea** (un secreto en rama publicada ya se filtró), `verify-commit` **avisa** (la regla "no retroactivo": el frontmatter se normaliza al tocar; se bloquea poniendo `VERIFIER_STRICT: "1"`), y `check-links` + estado de los índices son **informativos** (los rotos incluyen promesas `[[wikilink]]` intencionales). Escribe resumen en el job summary.
- **Añadido modo `--range <BASE> <HEAD>` en `verify-commit.sh` y `secret-scan.sh`:** en un PR no hay nada staged. El flag selecciona lo que cambió entre dos refs en vez del índice; **las reglas son idénticas en ambos modos** y el comportamiento por defecto (staged) no cambia. Los mensajes de bloqueo se adaptan al contexto (commit abortado vs PR bloqueado).
- **Actualizado** [SOP Git](<SOP Git y Flujo de Trabajo.md>) §11.5 (de recomendación a descripción de lo que existe, con la tabla de severidad) y el [Catálogo de Hooks y Locks](<../04 Knowledge/Automatización/Catálogo de Hooks y Locks.md>) (sección nueva "El mismo gate, del lado del servidor").

## [1.2.0] — 2026-07-22
**El modo equipo se vuelve activable.** La v1.1.0 dejó las piezas documentadas pero inertes; esta las cablea. Sigue sin cambiar nada en un vault personal.
- **Añadido `VAULT_MODE`** (`personal` por defecto | `equipo`) + `TEAM_MEMBERS` en el archivo de identidad de la instancia.
- **Cableado en el onboarding:** paso nuevo que pregunta «¿este vault es tuyo solo o lo van a usar varias personas?» y, si son varias, escribe el modo y corre `team-mode.sh`. Sin esto el modo existía pero el camino guiado nunca lo ofrecía, y un vault de organización nunca habría recibido sus carpetas ni el CODEOWNERS.
- **Añadido `team-mode.sh`:** crea `05 Diario/<Persona>/` por cada integrante e instala `.github/CODEOWNERS` desde el ejemplo, e imprime lo que solo se puede hacer en GitHub (branch protection). Idempotente, no destructivo y **no-op en modo personal**. Lo corren solos `setup.sh` y `update.sh` (la capa sobrevive a las actualizaciones). Deliberadamente **no reparte las zonas**: quién es dueño de qué es una decisión de gobernanza, no algo que una plantilla adivine.
- **Añadido [SOP Multi-Agente](<SOP Multi-Agente.md>) §5 "Varias personas con varios agentes"** — solo el cruce de los dos ejes, sin repetir el flujo git de [SOP Git](<SOP Git y Flujo de Trabajo.md>) §11: los dos aislamientos anidados (worktree aísla agentes, clon aísla personas) y la regla de que **cada persona integra sus worktrees localmente y lleva UNA rama al PR** (tres personas × tres agentes = tres PRs, no nueve); las zonas cruzadas (un agente escribe en la intersección de su zona de §2 y la zona de su humano en CODEOWNERS); la bitácora como contexto del vault y ya no como handoff lineal; y la regla de revisión — **ni el agente ni su humano aprueban su propio PR**, contrapartida de §3.1.
- **Corregido en `update.sh`:** la whitelist lista `.github/CODEOWNERS.example`, no `.github` entero — un `CODEOWNERS` propio (presente en la instancia y ausente en el upstream) habría aparecido en el diff como borrado y roto el checkout.

## [1.1.0] — 2026-07-22
**Modo equipo: el framework deja de asumir un solo dueño humano.** Nada cambia en un vault personal — todo lo nuevo es opt-in.
- **Añadido `.github/CODEOWNERS.example`:** traduce las zonas de propiedad de [SOP Multi-Agente](<SOP Multi-Agente.md>) §2 —hasta ahora una convención, y por lo tanto frágil— a una regla que git aplica. Con `main` protegido y "Require review from Code Owners", no se mergea sin la firma del dueño de la ruta. Se activa copiándolo a `.github/CODEOWNERS` y poniendo handles reales. **Las rutas llevan los espacios escapados** (`/00\ Sistema/`): CODEOWNERS parte cada línea por whitespace, así que sin escapar `/00 Sistema/ @x` se lee como ruta `/00` con dueño `Sistema/` — la regla no protege nada y falla en silencio. Documentado en [SOP Git](<SOP Git y Flujo de Trabajo.md>) §11.2.
- **Añadido [SOP Git y Flujo de Trabajo](<SOP Git y Flujo de Trabajo.md>) §11 "Vault compartido":** un repo por organización y un clon por persona (el clon aísla personas; el worktree sigue aislando agentes), rama corta por persona+tema, PR con revisión, integración secuencial con rebase de las ramas restantes, configuración concreta de branch protection, **regla del escritor único sobre los hotspots** (`index.md`, `llms.txt`, `01 Index/`, `02 MOCs/`, dashboards), `05 Diario/<Persona>/` por persona, y la advertencia de que el gate tiene que correr en el servidor y no solo en los hooks de cada clon. Incluye la alternativa CRDT (Relay/Peerdraft) y por qué no reemplaza a git en este sistema.
- **Añadido [SOP Multi-Agente](<SOP Multi-Agente.md>) §3.1:** en vault compartido el **autor** del commit es la persona que lanzó al agente, y el agente pasa a trailer `Agent:` + `Co-Authored-By:`. Un commit cuyo autor es una máquina es un commit sin responsable — y está medido que la autoría agéntica relaja la revisión humana. En vault personal se sigue usando la tabla de §3 tal cual.
- **Cambiado `.gitattributes`:** `merge=union` para los archivos append-only (bitácora de agentes y este changelog). Dos actores que registran su handoff en paralelo chocaban siempre en la última línea; ahora git conserva ambos lados. Documentados los dos límites: union no ordena, y la UI web de GitHub no lo honra. **Los patrones usan el comodín `?` en lugar de los espacios** (`05?Diario/...`): `.gitattributes` parte la línea por whitespace y —a diferencia de CODEOWNERS— no admite escaparlos.

## [1.0.0] — 2026-07-17
**Migración OKF total — release MAJOR (cambios de esquema = breaking).** El framework adopta el vocabulario [Open Knowledge Format](<../04 Knowledge/Sistemas y Metodologías/Open Knowledge Format (OKF).md>) de forma literal por dentro.
- **Frontmatter (breaking):** `tipo_doc` → `type` · `ultima_revision` (fecha) → `timestamp` (datetime ISO `YYYY-MM-DDT00:00:00Z`) · alta de `title` (= H1) · alta de `resource` (URI del asset externo, scaffold vacío, valor al tocar). `description` ya era opcional. Ley del frontmatter reescrita en [SOP Documentación](<SOP Documentación.md>) §4 (+ orden canónico §4.6).
- **Índices:** los `README.md` de carpeta pasan a `index.md` **generados** (listado puro sin frontmatter, `okf_version: "0.1"` en el raíz) vía `generate-index.py` (cableado al pre-commit). La prosa de convenciones se movió a [SOP Maestro](<SOP Maestro.md>) §5 ("Convenciones por carpeta"). Las carpetas vacías (`03 Proyectos`, `06 Raw`, `99 Archivo`) persisten con `.gitkeep`.
- **Enlaces:** wikilinks resueltos → links markdown `[Título](<ruta.md>)`; las promesas quedan `[[...]]`; frontmatter YAML y embeds intactos. Regla en [SOP Documentación](<SOP Documentación.md>) §6.1 + CLAUDE.md/AGENTS.md. Endurecido por `harden-links`.
- **Tooling nuevo:** `.claude/hooks/` suma `migrate-keys.py`, `harden-links.py`, `generate-index.py`; `verify-commit.sh` exime `index.md` y avisa (warn-only) si falta `description`.
- **Para instancias existentes:** `./migrate-okf.sh` migra tu vault (renombra README→index preservando tu prosa en `.okf-backup/`, migra claves, convierte links, regenera índices). Idempotente. Probá con `--dry-run` primero.
- **Verificación:** `check-links` = solo promesas (semillas genéricas), 0 markdown roto; índices estables (regenerar = 0 diff); 0 claves viejas en frontmatter (salvo `Baseline de Seguridad`, excluido).

## [0.6.4] — 2026-07-14
**Revisión pre-publicación (repo → público).**
- **Corregido:** QuickAdd "capture diaria" apuntaba a `900 - 📆 DIARIO/` (estructura del vault viejo del autor, inexistente acá) → `05 Diario/` · daily-notes apuntaba la plantilla a `05 Diario/Plantilla Diario` (no existe) → `00 Sistema/001_plantillas/Plantilla Diario`.
- **Auditado:** working tree sin datos personales (solo autoría MIT en LICENSE/README, intencional); sin secretos en el árbol ni en la historia; configs de Obsidian y `.claude/settings.json` limpios.

## [0.6.3] — 2026-07-14
- **README:** sección nueva "Cómo se ve una sesión con un agente" (el flujo hook de sesión → ley/skills → guardas → handoff en bitácora), tabla framework/scaffold/contenido en la sección de updates, bullet de ejemplos incluidos y declaración de idioma (español).

## [0.6.2] — 2026-07-14
**Revisión general de cierre.**
- **Corregido:** último "Leandro" residual en `.claude/hooks/security-guard.py` (mensaje del guard → "el dueño del vault") · placeholders dobles `{{OWNER}} {{OWNER}}` en `Plantilla Skill` y `SOP Git y Flujo de Trabajo` (habrían rendido el nombre duplicado al personalizar).
- **Cambiado:** `SOPS.md` regenerado — indexaba 17 de 28 SOPs y 10 de 14 plantillas; ahora completo y agrupado (sistema / IA y agentes / estudio y carrera) · `llms.txt` con sección **Seguridad** nueva (SOP de Seguridad, Baseline, Prompt Injection, MOC - Seguridad — el "seguro por defecto" de v0.4.0 no figuraba en el mapa) · `README.md` y descripción del manifest con los números reales (28 SOPs, 14 plantillas, 10 skills, 15 hooks) + bullet de seguridad por defecto.

## [0.6.1] — 2026-07-14
**Enlaces rotos: de 137 a 38 (solo semillas intencionales).**
- **Añadido:** `00 Sistema/Baseline de Seguridad/` portado desde el vault maestro (escrubeado) — el kit de seguridad para repos de código que `SOP Proyectos de Código` §2 manda aplicar y no existía. El doc principal se llama `Baseline de Seguridad.md` (no README) para que el wikilink resuelva.
- **Cambiado:** ~85 wikilinks a conocimiento de la instancia madre (MOC - IA con Claude, Anatomía de los hooks del vault, Hooks y ciclo de vida, Discovery con fecha, Migraciones, notas de curso…) despromovidos a texto plano en 35 archivos — apuntaban a notas que un usuario nuevo jamás tendrá, no eran "deuda de contenido" sanable. En las Skills, el footer `MOC:` se reapuntó a [Catálogo de Skills](<../04 Knowledge/Skills/Catálogo de Skills.md>). Tabla de IDs de `SOP Documentación` depurada (12 filas de docs de instancia removidas).
- **Criterio de release nuevo:** los enlaces rotos que reporte `check-links` deben ser solo **semillas genéricas** (conceptos/MOCs que el usuario crearía); si un destino existe en el vault maestro, es fuga de instancia y se porta o se despromueve.

## [0.6.0] — 2026-07-14
**Auditoría de alcance: removido el contenido de instancia que viajaba como framework.**
- **Removido:** `Decisión - Frontera Personal vs Negocio` (ADR de la instancia madre; su regla operativa —doble pregunta, 3 destinos, acceso asimétrico en 3 capas— ahora vive en `SOP Proyectos de Código` §1) · `Prompt - Propuesta Comercial Personalizada` (caso del negocio del autor).
- **Cambiado:** `Notion - Arquitectura` reescrito como **EJEMPLO ficticio** de doc de conector (el original documentaba un workspace real, con UUIDs reales de bases) · `SOP Career OS` sin estados de instancia ni proyectos reales; el esqueleto se declara "a crear al activar el subsistema" · `Blueprint de Sistemas` §5: la tabla de sistemas pasa a ser registro propio del usuario · `Vault System Map` regenerado contra el contenido real del template (listaba MOCs y proyectos de la instancia madre, incluido un nombre de negocio que el scrub no había atrapado) · `llms.txt`: rutas corregidas (Principios/Valores → `01 Index/`, Investigación → `04 Knowledge/Investigación del Sistema/`) y entradas muertas removidas (Guía de Inicio, Comparativa de Metodologías) · este CHANGELOG aclarado como changelog del TEMPLATE (está en la whitelist: update lo pisa).
- **Añadido:** `MOC - Carrera` (stub scaffold — `SOP Career OS` lo prometía y no existía) · entradas de scaffold en `vault-manifest.json` para `04 Knowledge/Conectores/**` y `MOC - Carrera` (el conector era un archivo fantasma: no figuraba ni en el manifest ni en la whitelist).

## [0.5.0] — 2026-07-12
**Sync con el vault maestro (sesión 2026-07-11): proyectos de código + multi-agente operativo + consolidación fundacional.**
- **Añadido:** `SOP Proyectos de Código` (SOP-013) — frontera vault/repo: el vault piensa el producto, el repo (independiente) lo construye; checklist de kickoff + tabla de hooks portables. `SOP Multi-Agente` (SOP-014) — worktrees, zonas de propiedad, identidad de commit y flujo por corrida (promovido desde Orquestación §4-6, según su propio plan §10).
- **Cambiado:** `Orquestación Multi-Agente Abierta` 624→458 líneas (operativa promovida al SOP-014; §11 decisiones cerradas; §13 gap analysis sellado como histórico). Consolidación fundacional: `Filosofía` = el porqué · `Investigación y auditoría de marcos` = el estudio · `SOP Maestro` = el manual (§10-14 colapsadas a tabla-mapa; 369→316). `Plantilla Proyecto` con campo `repo:`. Regla de atomicidad (la unidad es la idea, no la sesión) en `SOP Aprendizaje con IA` §4 y skill `/nota-estudio`.
- **Movido (capas):** `Principios`/`Valores` → `01 Index/` (filtros personales) · `MOC - Investigación del Sistema` → `02 MOCs/` · `Investigación y auditoría de marcos` → `04 Knowledge/Investigación del Sistema/`. Whitelist de `update.sh` y `vault-manifest.json` ajustadas.
- **Scrub:** los archivos sincronizados desde el vault maestro pasaron por re-scrub (nombre → `{{OWNER}}`, email → `{{OWNER_EMAIL}}`, negocios → Empresa A/B, rutas absolutas → genéricas); corregidas además 3 rutas absolutas preexistentes en `SOP Git y Flujo de Trabajo` que el scrub de v0.1.0 no había visto.
- **Limitación conocida:** algunos docs referencian material de instancia no incluido en el template (`Discovery - Entorno de Desarrollo…`, `Baseline de Seguridad/`, `Guía - Graphify`) — mismo patrón que v0.1.1; los wikilinks quedan como punteros nominales.

## [0.3.1] — 2026-07-05
- agent-diary v2: el aviso de bitácora bloquea UNA vez por sesión (stamp por session_id, auto-limpieza 7 días) — antes costaba un turno extra del modelo por cada cierre de turno con ediciones.

## [0.3.0] — 2026-07-05
- Aviso de actualizaciones: hook `update-notice.sh` (SessionStart, máx 1 chequeo/día, fail-open sin red; kill-switch `.vault-meta/update-notice.disabled`). El agente avisa al arrancar si hay versión nueva.

## [0.2.2] — 2026-07-04
- Fix update.sh: sin `owner.env` el script abortaba por `set -e` antes del mensaje final; + aviso real de doble pasada.

## [0.2.1] — 2026-07-04
- update.sh avisa cuando se auto-actualiza (correr una segunda pasada).

## [0.2.0] — 2026-07-04
- Onboarding wizard: `FIRST_RUN.md` + skill `/onboarding` (entrevista → `owner.env` → `personalize.sh` → brújula 01 Index → borra el marker).
- `personalize.sh` + `owner.env`: patrón answers-file (Copier) — `update.sh` re-personaliza tras cada update (los placeholders del framework ya no des-personalizan instancias).
- Licencia MIT.

## [0.1.2] — 2026-07-04
- Fix update.sh: `core.quotepath=false` — los archivos con acentos fallaban al actualizar en Windows (hallado por piloto E2E).

## [0.1.1] — 2026-07-04
- Fix piloto E2E: stub del Roadmap renombrado a "Roadmap del Sistema" (sana 4 enlaces); des-wikificados enlaces a docs históricos no incluidos (Migraciones, Validación, Discovery, clases).

## [0.1.0] — 2026-07-04
- Primera versión del template: 8 capas, SOPs, plantillas, skills/hooks multi-agente, verifier pre-commit.
