---
type: SOP
title: "SOP Proyectos de Código"
tags: [sop, desarrollo, codigo, proyectos, agentes, kickoff]
estado: 🟢 Activo
prioridad: 🔥 Alta
responsable: "{{OWNER}}"
id: "SOP-013"
generated:
  by: human:{{OWNER}}
  at: 2026-07-11T00:00:00Z
fecha_creacion: 2026-07-11
resource:
---

>[!info] Documentación relacionada
>[Spec-Driven Development](<../04 Knowledge/Sistemas y Metodologías/Spec-Driven Development.md>) (el porqué y el flujo) | [[Baseline de Seguridad]] | [SOP Proyectos](<SOP Proyectos.md>) | [SOP Discovery](<SOP Discovery.md>)

# SOP Proyectos de Código

## Objetivo

Definir cómo nace y se trabaja un **proyecto de código** (app, CRM, dashboard codificado) en el ecosistema: qué hace el vault, qué hace el repo, qué cruza la frontera y cómo. Validado contra la industria (Anthropic, OpenAI, Google, Cursor, spec-kit, BMAD, Harper Reed).

> **Regla base:** el vault piensa el producto; el repo lo construye. El código **nunca** vive dentro de un vault, y el repo **nunca** depende del vault para funcionar.

---

## 1. La frontera: función de cada capa

### El vault (personal o de empresa) — hasta dónde llega

| Función | Dónde |
|---|---|
| Investigación y Discovery del proyecto | `05 Diario/Auditorías/` o junto al proyecto |
| PRD, visión, MVP, reglas de negocio | vault de la esfera dueña (personal → `03 Proyectos/`; empresa → su vault) |
| Decisiones de **producto** (alcance, features, prioridades) | nota de proyecto / ADRs del vault |
| Nota de proyecto con estado, hitos y **enlace al repo** | `03 Proyectos/` (campo `repo:` del frontmatter) |
| Patrón reutilizable aprendido ("cómo se estructura un CRM") | `04 Knowledge/Temas/` |
| Evidencia de carrera (historia STAR, capturas, métricas congeladas) | `{{OWNER}} Career OS` |

**El vault NO guarda:** código, specs técnicas vivas (esquema real de DB, API), datasets vivos, credenciales, tooling de build. Todo eso se desactualiza → vive donde se mantiene (ver *La frontera personal vs negocio*, abajo).

### El repo de código — autosuficiente siempre

| Función | Dónde |
|---|---|
| La ley del proyecto: stack, comandos, convenciones | `CLAUDE.md` + `AGENTS.md` (magros — regla Anthropic: si borrar la línea no causa errores, borrala) |
| Contexto de producto (snapshot exportado del vault, con fecha) | `docs/product/` |
| Specs por feature: qué → cómo → tareas | `specs/<feature>/spec.md · plan.md · tasks.md` (patrón spec-kit, a mano) |
| Decisiones **técnicas** (por qué Postgres y no SQLite) | `docs/adr/` |
| Handoffs entre sesiones de agente | `docs/BITACORA.md` (patrón Agent Diary adaptado) |
| Seguridad determinista | [[Baseline de Seguridad]]: `.claude/settings.json` deny + guard + secret-scan + pre-commit |
| Verificación ejecutable (el "verifier" del código) | tests + build + lint en pre-commit; skills built-in `/verify` y `/code-review` |

> **La "constitución" del [Spec-Driven Development](<../04 Knowledge/Sistemas y Metodologías/Spec-Driven Development.md>) es esta fila:** en el flujo hecho a mano (Claude Code, no Spec Kit) **no hay** un archivo `constitution.md` aparte — su rol lo cumplen `CLAUDE.md` + `AGENTS.md` en la raíz. Por eso `specs/<feature>/` tiene **3** archivos (spec·plan·tasks), no 4.

### Qué necesita el repo del vault (y qué no)

- **Necesita (una vez, al kickoff):** el **pack de contexto** — PRD + MVP + decisiones de producto, copiado a `docs/product/` con fecha de snapshot. **Push consciente, nunca pull** (ver *La frontera personal vs negocio*, abajo).
- **Re-export:** cuando una decisión de producto cambia, se actualiza en el vault y se re-exporta el snapshot.
- **Opcional (solo máquina del operador):** `additionalDirectories` en `.claude/settings.local.json` (NO committeado) hacia el vault de la **misma esfera**, para consultas ad-hoc. Repo de empresa → vault personal: ⛔ prohibido (acceso asimétrico, abajo).
- **NO necesita nada más.** Si el repo no compila o el agente no puede trabajar sin el vault montado, la frontera está rota.

### La frontera personal vs negocio (regla de doble pregunta)

Cuando hay más de una esfera (tu vault personal + vaults/repos de empresa), dónde vive cada cosa lo decide una **doble pregunta**:

> ¿Es sobre **vos** o sobre el **negocio**? ¿Necesita acceso **otra persona** del negocio?

**Regla de los 3 destinos** (resuelve los casos grises):

| Qué es | Ejemplo | Dónde vive |
|---|---|---|
| La **historia/prueba** | "hice un dashboard que subió ventas" (STAR) | Career OS (vault personal) |
| El **activo vivo** | el dashboard con datos que usa el equipo | vault/repo de la empresa |
| El **patrón** reutilizable | cómo se diseña un dashboard de ventas | `04 Knowledge/Temas/` |

> Mnemónica: **lo que se desactualiza vive donde se mantiene; lo que te representa vive con vos.** Una copia "por las dudas" de un activo vivo se vuelve mentira en dos meses; el enlace no.

**Acceso asimétrico entre esferas:** agente del vault personal → esfera de empresa: ✅ (sos el operador-dueño). Agente de empresa → vault personal: ⛔ siempre (ese agente mañana lo corren socios/empleados; tu vault contiene diario, carrera y vida). Enforcement en 3 capas de defensa: (1) **física** — repos y carpetas separados, el agente de empresa no tiene la ruta ni las credenciales del vault personal; (2) **credenciales** — colaboradores por repo; (3) **harness** — el `.claude/settings.json` del repo de empresa nace con `permissions.deny` de ruta (`Read(../**)` + ruta del vault personal; los deny ganan siempre sobre cualquier allow). Si el negocio necesita algo de tu conocimiento, la dirección es **push, no pull**: vos o tu agente lo copian deliberadamente al vault de la empresa.

---

## 2. Kickoff de un proyecto nuevo (checklist, ~30-45 min)

- [ ] **0. Discovery** del proyecto si no está hecho ([SOP Discovery](<SOP Discovery.md>)).
- [ ] **1. PRD/MVP en el vault** dueño: qué, para quién, criterio de éxito, qué NO incluye. Con criterio MVP — no diseñar la DB completa en prosa (el detalle técnico se descubre construyendo).
- [ ] **2. `git init` FUERA del vault** (ej. `~/dev/<proyecto>/`). Repo privado propio.
- [ ] **3. [[Baseline de Seguridad]]** — los 5 pasos del How-to (settings deny, guard, secret-scan, pre-commit, bloque en CLAUDE.md).
- [ ] **4. `CLAUDE.md` + `AGENTS.md`** magros: stack, comandos de build/test/run, convenciones. Nada que el agente pueda inferir del código.
- [ ] **5. Export del pack de contexto** → `docs/product/PRD.md` (+ decisiones), encabezado con fecha y origen ("snapshot del vault X, 2026-07-11").
- [ ] **6. Primera spec** → `specs/001-mvp/spec.md` (qué) → `plan.md` (cómo) → `tasks.md` (pasos chicos, sin saltos de complejidad — Harper Reed).
- [ ] **7. Verificación desde el día 1:** test runner configurado + pre-commit con lint/test/secret-scan. Sin verificación ejecutable no hay sesión desatendida.
- [ ] **8. Nota de proyecto en el vault** (o actualizar la existente): estado, hitos, campo `repo:` con la ruta/URL.
- [ ] **9. (Opcional)** `docs/BITACORA.md` + hook agent-diary adaptado; graphify (`/graphify .`) cuando el repo tenga tamaño.

## 3. Ciclo de trabajo (con agente)

1. **Explore → Plan → Implement → Commit** (plan mode para cambios multi-archivo; directo para fixes de una línea).
2. Features grandes: **entrevista → spec** ("interview me… then write a complete spec") → sesión fresca ejecuta la spec.
3. Cada tarea cierra con su **verificación corriendo** (tests en verde), no con "parece que anda".
4. Antes de commits importantes: `/verify` (probar end-to-end) y `/code-review` (revisión adversarial en contexto fresco).
5. **Commits deliberados** — acá NO hay auto-commit (a diferencia del vault).
6. Decisión técnica nueva → `docs/adr/`. Decisión de producto nueva → vault → re-export.

## 4. Cierre de hito / proyecto

**Materia prima:** la bitácora del repo (`docs/BITACORA.md`) — el "qué construí y cómo". Este paso se corre con **Claude desde el vault personal** (Career OS y `Temas/` viven acá; el push es consciente, nunca la empresa entrando a tu vault). Producís dos artefactos:

1. **Historia STAR** → `{{OWNER}} Career OS/04_Career_Stories/{Logro} — {Empresa}.md`. La **S-T-A** sale de la bitácora; la **R (Resultado) es dato de negocio** (métrica, uso, feedback) — **no** está en la bitácora del código, la aportás vos o vive en el vault de la empresa. Enlaza la experiencia y el activo vivo (repo); no copia código.
2. **Patrón** → **`04 Knowledge/Temas/`** — el aprendizaje **desacoplado de la empresa** (sirve al próximo proyecto de cualquier esfera). Casi siempre **Explanation**; **How-to** solo si es una receta repetible tal cual. Es síntesis, no transcripción de la bitácora.

- Evidencia congelada (captura, métrica, versión demo con fecha) → **Career OS**, opcional.
- Nota de proyecto del vault dueño: estado actualizado + hito registrado.
- El código sigue viviendo en su repo (archivado o activo).

## 5. Qué se porta del vault a un repo de código

| Pieza | ¿Se porta? | Nota |
|---|---|---|
| [[Baseline de Seguridad]] | ✅ tal cual | Fue diseñado para esto |
| `agent-diary.sh` / `session-context.sh` | ✅ adaptado | Escribe en `docs/BITACORA.md` |
| `auto-commit.sh` | ⛔ nunca | Commits de código = deliberados, con tests en verde |
| `check-links` / `heal-links` / `wiki-lock` / `sentinels` / `verify-commit` | ⛔ | Razonan sobre wikilinks/frontmatter |
| Verifier de calidad | No se construye | Lo cubren tests + `/verify` + `/code-review` built-in |

## 6. Template de repo (dos capas, dos reglas)

**Existe un seed v0.1** (decisión {{OWNER}} 2026-07-11): `~/dev/plantilla-repo-codigo\` — repo git local, candidato a GitHub template repo. Misma distinción que el template del vault (capa sistema vs contenido):

- **Capa sistema (viene en el seed, ya probada):** [[Baseline de Seguridad]] completo, ley `AGENTS.md`/`CLAUDE.md` (CLAUDE importa a AGENTS — una sola fuente de verdad), `docs/product|adr|BITACORA`, esqueletos `specs/` (spec→plan→tasks), `.gitignore` de secretos, pre-commit con secret-scan. Auditado vs mejores prácticas 2026-07-11 (v0.1.1): + `.gitattributes` (hooks LF), + `setup.sh` (activa hooksPath por clon — sin él el secret-scan no corre), + hooks `session-touch`/`agent-diary` (bitácora determinista en `docs/BITACORA.md`, testeada), + `README.proyecto.md`.
- **Capa código (NO viene — regla de extracción):** stack, `src/`, CI, lint/test cableados. Se completa en el kickoff de cada proyecto; lo que se copie idéntico entre los pilotos 1 y 2 se sube al template.

El kickoff §2 con el seed: pasos 2-4 ya vienen resueltos (copiar la carpeta y completar placeholders).

### 6.1 Modo equipo y paralelismo

El seed nació con el mismo supuesto que el template del vault antes de la decisión de plantilla única: **un dueño, una máquina, un agente por vez** — cero menciones a ramas, PR, CODEOWNERS o worktrees, y sin `.github/`. Portada esa gobernanza, con la misma regla: **capa inerte por defecto**, un repo de un solo dueño no paga nada.

| Pieza | Qué resuelve | Estado por defecto |
|---|---|---|
| `repo.conf` con `REPO_MODE=solo\|equipo` | El equivalente de `VAULT_MODE`. **Versionado, no por-clon**: si cada uno tuviera el suyo, cualquiera podría ponerse en `solo` y desactivarse el gate | `solo` |
| Gate de rama en `.githooks/pre-commit` | En equipo nadie commitea directo a la principal: todo entra por PR | inactivo en `solo` |
| `.github/workflows/verify.yml` | El gate del lado del servidor (secret-scan `--range`) | activo, solo dispara en PR |
| `.github/CODEOWNERS.example` | El dueño revisa `AGENTS.md`, `.claude/`, hooks y CI | inactivo — se copia a `CODEOWNERS` |
| `merge=union` en `docs/BITACORA.md` | El Stop hook **obliga** a escribir al final del archivo: dos worktrees chocaban siempre en la última línea | activo (sirve igual en `solo` con varios agentes) |
| Entrada de bitácora con **agente y rama** | Con `union`, el orden del archivo ya no identifica a nadie | activo |
| `AGENTS.md` §*Git: ramas, worktrees y trabajo en paralelo* | La ley que leen los agentes | activo |

**Por qué el gate de servidor no es opcional:** `core.hooksPath` es **config local**, no viaja con el repo, y `--no-verify` lo saltea. Con una persona eso es disciplina; con varias es estadística.

**Lo que el repo NO puede garantizar por sí solo:** las reglas de rama de GitHub (require PR · review from Code Owners · status check `verify` · block force pushes) se activan a mano en *Settings → Rules*. Sin ellas, todo lo anterior es convención, no control.

> [!warning] 🔴 Y en plan Free + repo privado **no se pueden activar en absoluto**
> Medido el 2026-08-06: la API responde **403 · "Upgrade to GitHub Pro or make this repository public"** tanto para *branch protection* como para *rulesets*. La tabla completa de qué sobrevive y qué no está en [SOP Git](<SOP Git y Flujo de Trabajo.md>) §12.1.
>
> **Consecuencia para un repo de código, y acá pesa más que en un vault:** el gate de rama del `pre-commit` (`REPO_MODE=equipo`) pasa a ser **el único control automático que existe** — es lo único que frena un commit directo a la principal. Y depende enteramente de que cada persona haya corrido `setup.sh` en su clon. Verificalo: `git config core.hooksPath` debe responder `.githooks`.
>
> En ese escenario, **el `verify.yml` del PR es una señal, no un bloqueo**: un PR en rojo se mergea igual. Sirve para ver, no para impedir.
>
> ⚠️ En modo equipo `setup.sh` **imprime** esas reglas como recordatorio. Si la org está en plan Free con repos privados, ese recordatorio pide algo imposible: leelo como "lo que tendrías si pagaras", no como pendiente accionable.

> ⚠️ **El check `verify` queda verde sin correr una sola prueba** hasta cablear el stack (kickoff §2 paso 7, en `pre-commit` **y** en `verify.yml`). Es deliberado —un repo recién nacido no tiene suite— y el paso lo avisa en el resumen del PR, pero activar "require status checks" antes de cablear tests da un verde que no significa nada.
>
> **Y "el comando está declarado" no es "el comando funciona".** Antes de cablear una suite a un gate, **correla entera una vez**: es donde aparecen el orden, el estado compartido y las dependencias de entorno que no se ven corriendo un archivo por vez. Corolario, pagado en carne propia: verificar con `cmd | tail` **miente** — `$?` devuelve el estado de `tail`, no el de la suite, y un "todos los archivos pasan" puede convivir con media suite colgada.

## 7. Errores comunes

| Error | Por qué falla | Corrección |
|---|---|---|
| Meter código dentro del vault | Grafo/git/Obsidian sucios; secretos junto al diario | Repo fuera, siempre |
| Repo que depende del vault montado | Rompe CI, colaboradores y portabilidad | Export pack; repo autosuficiente |
| Spec técnica viva solo en el vault | Drift: el vault miente en 2 meses | Intención en vault; verdad en `specs/` y migraciones del repo |
| Template antes del primer proyecto | Especular estructura sin caso real | §6: extraer del proyecto 2 |
| Sesiones sin verificación ejecutable | El humano se vuelve el loop de verificación | Checklist §2 paso 7 |

## Referencias
- Fuentes del flujo: [Best practices — Claude Code](https://code.claude.com/docs/en/best-practices) · [AGENTS.md](https://agents.md/) · [github/spec-kit](https://github.com/github/spec-kit) · [Harper Reed](https://harper.blog/2025/02/16/my-llm-codegen-workflow-atm/)
- [SOP Proyectos](<SOP Proyectos.md>) — el protocolo de la *nota* de proyecto en el vault (este SOP lo complementa para proyectos con código)

## Cómo leer este documento
Para arrancar un proyecto: checklist §2. Para saber qué va dónde: §1. Para trabajar día a día: §3. La regla del template está en §6.
