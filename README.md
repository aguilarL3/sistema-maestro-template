# Sistema Maestro — Template

> ### 🚦 ¿Recién clonaste esto (vos o tu agente)?
> **No corras `setup.sh`/`personalize.sh` desde afuera ni "a mano" para inicializarlo.** La inicialización es **interactiva y desde adentro**: abrí esta carpeta como una sesión propia de tu agente (Claude Code / Codex / …) y pedí **`/onboarding`** — te entrevista y personaliza el vault correctamente. Detalle en `FIRST_RUN.md`.
>
> **Si sos un agente** y te pidieron "clonar y preparar" esta instancia: tu tarea **no** es personalizarla mecánicamente; es dejar el clon tal cual y avisarle al humano que abra la carpeta y corra `/onboarding`. `personalize.sh` está protegido con un guard que lo impide mientras exista `FIRST_RUN.md`.

Un **sistema operativo personal** en Obsidian, diseñado para trabajar con agentes de IA (Claude Code, Codex, Gemini CLI o cualquier agente que lea `AGENTS.md`) sin depender de ninguno.

No es una app de tareas ni una carpeta de notas: es una arquitectura para capturar información, convertirla en conocimiento, ejecutar proyectos, registrar tu vida y construir dirección a largo plazo. Todo el sistema está escrito en **español**.

```
Información → Conocimiento → Acción → Resultados → Evidencia → Crecimiento
```

## Qué incluye

- **8 capas** de arquitectura (`00 Sistema` → `99 Archivo`) con reglas claras de qué va dónde
- **28 SOPs**: el manual operativo completo (documentación, decisiones, revisiones, estudio, carrera, git, IA, hooks…)
- **14 plantillas** (notas atómicas, MOCs, proyectos, diario, decisiones, SOPs, skills, runbooks…)
- **Lógica de agentes lista para usar**: 10 skills, subagente verifier, 15 hooks (bitácora de agentes, contexto de sesión, auto-commit, locks, chequeo de enlaces, centinelas de edición, verifier pre-commit)
- **Seguro por defecto**: `deny` en `.claude/settings.json`, security-guard (PreToolUse), secret-scan (pre-commit) y auditoría — más el kit **Baseline de Seguridad**, portable a cualquier repo de código
- **Multi-agente y agnóstico**: diseñado sobre `AGENTS.md` + git; funciona con cualquier harness
- **Ejemplos que muestran los patrones**: un conector de sistema externo documentado (Notion, ficticio), prompts versionados de ejemplo y un MOC de muestra — los reemplazás por los tuyos
- **Plugins de Obsidian incluidos**: Templater, Dataview, Calendar, Kanban, obsidian-git y más — clonás y funciona

## Cómo se ve una sesión con un agente

1. **Abrís tu agente en la carpeta del vault.** Un hook de sesión le inyecta el último *handoff* de la bitácora de agentes (qué se hizo, qué quedó bloqueado) y le avisa si hay versión nueva del template.
2. **Trabajás.** El agente lee la ley (`AGENTS.md` / `CLAUDE.md`), navega por `llms.txt`, respeta los SOPs y ejecuta skills (`/cerebro-audit`, `/revision-mensual`, `/nota-estudio`…).
3. **Las guardas corren solas.** `security-guard` bloquea comandos peligrosos antes de ejecutarse, `secret-scan` y el verifier de frontmatter revisan cada commit, y los centinelas protegen las zonas que el agente no debe tocar.
4. **Al cerrar, el agente registra su handoff** en la bitácora — el próximo agente (aunque sea otro: Codex, Gemini CLI…) arranca con contexto, sin que le repitas nada.

La memoria compartida es el vault mismo: markdown + git. Sin bases de datos, sin servicios, sin lock-in.

## Requisitos

- [Obsidian](https://obsidian.md) (recomendado) · [Git](https://git-scm.com) · opcional: un agente de IA (ej. [Claude Code](https://claude.ai/download))

## Instalación

```bash
git clone https://github.com/aguilarL3/sistema-maestro-template.git mi-sistema
cd mi-sistema
./setup.sh        # git hooks, estado local, remote upstream
```

1. Abrí la carpeta como vault en Obsidian → **"Trust author and enable plugins"**.
2. Leé `00 Inicio Rapido.md` (el tutorial de entrada).
3. Si usás un agente de IA: abrilo en la carpeta y pedile **"Run onboarding"** — completá tu brújula (`01 Index`: visión, objetivos, mapa personal).

La personalización es automática: el onboarding escribe `owner.env` y corre `personalize.sh` (los updates re-personalizan solos). Sin agente, la vía manual es deliberada: `cp owner.env.example owner.env`, editalo y `FORCE=1 ./personalize.sh` (el `FORCE=1` saltea a propósito el guard que evita la inicialización mecánica desde afuera).

### ¿Varias personas en el mismo vault?

El sistema asume un dueño humano, pero soporta equipos como capa **opt-in**. En `owner.env`:

```bash
VAULT_MODE=equipo
TEAM_MEMBERS="Persona A,Persona B,Persona C"
```

`./team-mode.sh` —lo corren solos `setup.sh` y `update.sh`— crea una carpeta de diario por persona e instala `.github/CODEOWNERS`, que convierte las zonas de propiedad en una regla que git aplica. El flujo completo (un repo por organización, un clon por persona, ramas cortas, PR, escritor único sobre los archivos que todos tocan) está en `SOP Git y Flujo de Trabajo` §11; el cruce con los agentes, en `SOP Multi-Agente` §5. En modo `personal` —el default— nada de esto se activa.

## Cómo recibir actualizaciones

El template evoluciona. **Tu contenido nunca se toca**: `update.sh` solo reemplaza archivos de framework (whitelist explícita, espejada en `vault-manifest.json`). El repo distingue tres categorías:

| Categoría | Qué es | ¿`update.sh` lo toca? |
|---|---|---|
| **Framework** | SOPs, skills, hooks, plantillas, la ley (`AGENTS.md`, `CLAUDE.md`, `llms.txt`) | ✅ Sí — se actualiza con cada versión |
| **Scaffold** | Stubs y ejemplos que llenás vos: brújula (`01 Index`), dashboards, prompts y conector de ejemplo | Se instala una vez; **nunca se pisa** |
| **Tu contenido** | Notas, proyectos, diario, MOCs propios | **Jamás se toca** |

```bash
./update.sh --check    # ¿hay versión nueva?
./update.sh            # interactivo (o --dry-run / --force)
```

### …o que te lleguen solas

`--check` funciona, pero hay que acordarse de correrlo. El workflow **`.github/workflows/template-update.yml`** lo hace por vos: cada lunes compara tu versión con la del template y, si hay una nueva, abre un **PR** con los archivos de framework actualizados. Nada se mergea solo — lo revisás y decidís.

Para activarlo en tu repo, en Settings → Secrets and variables → Actions → Variables: `OWNER` (requerido; `owner.env` está gitignoreado, así que el workflow lo reconstruye desde ahí), y opcionalmente `OWNER_EMAIL`, `OWNER_GITHUB`, `VAULT_MODE`, `TEAM_MEMBERS`, `UPSTREAM_URL`. Además, en Settings → Actions → General: permisos de *read and write* y permitir que Actions cree PRs.

Un límite que conviene saber: el token de Actions no puede modificar archivos de `.github/workflows/`. Si una versión nueva cambia un workflow, el PR llega sin esa parte y lo dice; se completa con un `./update.sh` local.

## Estructura

```
00 Sistema      → Reglas, SOPs, plantillas — el manual
01 Index        → TU brújula: visión, objetivos, mapa personal (la llenás vos)
02 MOCs         → Mapas de contenido por tema
03 Proyectos    → Iniciativas con inicio y fin
04 Knowledge    → Conocimiento reutilizable
05 Diario       → Registro cotidiano
06 Raw          → Fuentes sin procesar
99 Archivo      → Lo que terminó
```

## Filosofía

1. Simplicidad antes que complejidad. 2. Markdown antes que herramientas propietarias. 3. Conectar antes que clasificar. 4. Aprender para aplicar. 5. Revisar para mejorar. 6. IA como copiloto, no como sustituto.

## Licencia

[MIT](LICENSE) © 2026 Leandro Aguilar.

## Créditos

Arquitectura basada en: LLM Wiki (Karpathy) · Zettelkasten (Luhmann) · Evergreen Notes (Matuschak) · GTD (Allen) · PARA (Forte) · MOCs (Milo) · Cerebro Digital (Emowe) · Yo S.A. (Loan). Prior art de mecanismos multi-agente: claude-obsidian, obsidian-mind, obsidian-second-brain, COG-second-brain.
