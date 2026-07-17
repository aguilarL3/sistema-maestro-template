---
type: Changelog
title: "CHANGELOG del Sistema"
tags: [changelog, sistema]
estado: 🟢 Activo
id: "LOG-001"
timestamp: 2026-07-17T00:00:00Z
fecha_creacion: 2026-07-04
resource:
---

# CHANGELOG del Sistema

Registro de cambios del **framework** (template). `update.sh` actualiza este archivo junto al resto del framework — **no anotes acá los cambios de tu instancia** (se pisarían en el próximo update): esos van en tu bitácora de agentes o en una nota propia.

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
