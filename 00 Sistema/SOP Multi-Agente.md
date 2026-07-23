---
type: SOP
title: "SOP Multi-Agente — operar varios agentes sin que se pisen"
tags: [sop, multiagente, worktrees, commits, orquestacion, agentes]
description: "Aislamiento por worktrees, zonas de propiedad, identidad de commit y el flujo por corrida; §5 para varias personas con varios agentes."
estado: 🟢 Activo
prioridad: 🔥 Alta
responsable: "{{OWNER}}"
id: "SOP-014"
timestamp: 2026-07-11T00:00:00Z
fecha_creacion: 2026-07-11
resource:
---

>[!info] Documentación relacionada
>[Orquestación Multi-Agente Abierta](<Orquestación Multi-Agente Abierta.md>) (el *porqué* — este SOP es su §4-6 promovido, según su propio plan §10) | [SOP Git y Flujo de Trabajo](<SOP Git y Flujo de Trabajo.md>) (base que se extiende) | Verifier pre-commit (self-review) | [[MOC - Agentes]]

# SOP Multi-Agente — operar varios agentes sin que se pisen

## Objetivo

El *cómo* operativo para trabajar con varios agentes (Claude Code, Codex, Antigravity…) en el vault: aislamiento por worktrees, zonas de propiedad, identidad de commit y el flujo completo por corrida. Todo validado en la práctica (ensayo 2026-06-30 + operación diaria). El *porqué* y el marco conceptual viven en [Orquestación Multi-Agente Abierta](<Orquestación Multi-Agente Abierta.md>).

---

## 1. Aislamiento: worktrees (el muro real)

Tres niveles, de menor a mayor:

```
Nivel 0 — Sin aislamiento (mismo directorio, misma rama)   → NO usar: se sobreescriben.
Nivel 1 — Zonas de propiedad (convención de carpetas)      → frágil: acuerdo, no git.
Nivel 2 — Git worktrees (checkout físico por agente)       → RECOMENDADO.
```

Un **worktree** es un directorio de trabajo separado, con sus propios archivos y su propia rama, que comparte historial y remoto con el checkout principal. Dos agentes **nunca tocan el mismo archivo en disco**; el conflicto (si lo hay) se resuelve una sola vez, al mergear.

```
                    Repo compartido (.git, historial, remoto)
                                   │
        ┌──────────────────┬───────┴───────┬──────────────────┐
   Checkout principal   worktree-claude  worktree-codex   worktree-antigravity
   (vos, en Obsidian)   rama: agent/claude  rama: agent/codex  rama: agent/antigravity
```

**Soporte por agente (2026):** Claude Code nativo (`claude --worktree <nombre>` / subagentes con `isolation: worktree`; v2.1.49) · Codex nativo (CLI y App, v0.115.0) · Antigravity: sin worktree nativo — abrir manualmente el worktree como workspace.

**Sobre "locking":** git no tiene lock de archivos real para `.md` (`git worktree lock` protege el *worktree* de la limpieza, no los archivos). El aislamiento = **worktrees (separación física) + zonas (convención) + merge al final**. Si dos agentes *deben* tocar el mismo archivo → se **serializa**, no se paraleliza.

**Estrategia de este vault:**
```
1. Rama base: main (lo que se ve en Obsidian).
2. Un worktree + rama por agente: agent/claude, agent/codex, agent/antigravity.
3. Zonas de propiedad (§2) para reducir choques.
4. Los agentes NO pushean a main: commitean en su rama.
5. El lead ({{OWNER}} o Claude) revisa y mergea cada rama a main, de a una.
6. .claude/worktrees/ va en .gitignore.
```

## 2. Zonas de propiedad (mapa por tarea — confirmado 2026-06-30)

Reparto por tipo de tarea, cobertura completa:

| Agente | Escribe en | Modo | Por qué |
|---|---|---|---|
| **Claude Code** (lead) | `00 Sistema/`, `01 Index/`, `02 MOCs/` + **integra** las ramas | escribe | Arquitecto: conoce el vault por `CLAUDE.md`; hace los merges a `main`. |
| **Codex** | `04 Knowledge/Cursos/`, `04 Knowledge/Temas/`, `04 Knowledge/Prompts/` | escribe | Extracción acotada y repetitiva. |
| **Antigravity** | Todo el vault + `06 Raw/` | **solo lectura → propuestas** | Audita sin escribir; entrega Artifacts. |
| **{{OWNER}}** (humano) | `03 Proyectos/`, `05 Diario/` | exclusivo | Registro personal e iniciativas: no se delega salvo pedido explícito. |
| — | `99 Archivo/` | **congelado** | Nadie lo toca. |

> Las zonas son **convención**, no muro — el muro es el worktree (§1). Un agente sale de su zona **solo con pedido explícito**.

> **En vault compartido la convención se puede endurecer:** `.github/CODEOWNERS` traduce esta tabla a una regla que git aplica —GitHub pide la revisión del dueño de cada ruta y, con `main` protegido, no deja mergear sin ella. Es el Nivel 1 de §1 convertido en muro. Ver `.github/CODEOWNERS.example` y [SOP Git y Flujo de Trabajo](<SOP Git y Flujo de Trabajo.md>) §11.

## 3. Identidad y mensaje de commit (quién hizo qué)

Extiende [SOP Git y Flujo de Trabajo](<SOP Git y Flujo de Trabajo.md>) §4. Dos palancas: **identidad** (autor) y **mensaje** (trailer). Usar **ambas**.

| Agente | `user.name` | `user.email` |
|---|---|---|
| {{OWNER}} (humano) | `{{OWNER}}` | `{{OWNER_EMAIL}}` (global) |
| Claude Code | `Claude (Claude Code)` | `claude@agent.local` (o trailer `Co-Authored-By`) |
| Codex | `Codex` | `codex@agent.local` (`~/.codex/config.toml`) |
| Antigravity | `Antigravity (Gemini)` | `antigravity@agent.local` (a mano) |

> **⚠️ Trampa verificada (ensayo 2026-06-30):** `cd worktree && git config user.email …` escribe en la config **compartida** del repo (contamina `main`). Métodos correctos:
> - **(a)** firmar cada commit: `git -c user.name="Claude" -c user.email="claude@agent.local" commit …` ✅ recomendado
> - **(b)** identidad persistente por worktree: `git config extensions.worktreeConfig true` → `git config --worktree user.email …`

### 3.1 En vault compartido: el autor es el humano, el agente es trailer

La tabla de arriba —agente como **autor**— funciona en un vault de un solo dueño: ahí el responsable es obvio, es el único que hay. **En un vault con varias personas deja de funcionar: un commit cuyo autor es `claude@agent.local` es un commit sin nadie que responda por él.**

Dos razones, y ninguna es teórica:

1. **La revisión se relaja sola.** Está medido en repos públicos: los PRs de autoría agéntica reciben revisión solo-humana en ~8% de los casos, contra ~25% de los humanos. Si el autor es una máquina, la gente asume que ya lo revisó otro.
2. **La responsabilidad no se delega.** El consenso legal 2026 es consistente: la autonomía **redistribuye** la responsabilidad, no la elimina — recae en el humano que despliega, autoriza o se beneficia. Un agente no puede dar garantías ni responder por un cambio.

**Regla en modo equipo:** el autor del commit es **la persona que lanzó al agente**; el agente se registra como trailer y co-autor.

```
Author: Persona B <persona-b@…>

feat(knowledge): extraer 3 notas atómicas de la fuente X

Agent: claude
Worktree: agent/claude
Co-Authored-By: Claude <claude@agent.local>
```

Así `git shortlog -sn` sigue respondiendo *quién responde*, y `git log --grep="Agent:"` sigue respondiendo *qué escribió una máquina*. No se pierde la trazabilidad del agente; se le agrega la del humano.

```powershell
git log --grep="Agent: claude" --oneline    # qué hizo el agente
git shortlog -sn                             # quién responde por cada cambio
```

> En vault personal (un solo dueño) seguí con la tabla de §3 tal cual: firmar como agente está bien y hace más legible el histórico. Esta subsección aplica desde la segunda persona.

**Mensaje** (sobre Conventional Commits):
```
<tipo>(<scope>): <descripción en imperativo>

[cuerpo: por qué]

Agent: claude | codex | antigravity
Worktree: agent/<nombre>
Ref: [[nota o MOC afectado]]
```

**Auditar después:**
```powershell
git log --author="Codex" --oneline           # todo lo que hizo Codex
git shortlog -sn                              # commits por autor
git log --grep="Agent: antigravity" --oneline # por trailer
git log --oneline agent/claude ^main          # qué trae la rama que main no tiene
```

## 4. El flujo completo por corrida

```
FASE 0 — Preparar (una vez)
  1. AGENTS.md y CLAUDE.md sincronizados.                                   ✅
  2. .claude/worktrees/ y equivalentes en .gitignore.                       ✅
  3. (Windows) git config core.longpaths true  ← rutas profundas > MAX_PATH ✅
  4. Identidad git por agente (§3) — con `git -c`, NO con `git config`.
  5. Zonas de propiedad definidas (§2).                                     ✅
  6. git config core.hooksPath .githooks  ← gate de git, 1×/clon.           ✅
     (commit: secret-scan → centinelas @user → índices → verifier;
      push: bloqueo de reescritura de historia publicada. Apunta a la
      CARPETA, así que un hook nuevo queda activo sin reconfigurar nada.)

FASE 1 — Lanzar (por corrida)
  5. Commit + push de main (red de seguridad).
  6. PAUSAR Obsidian Git auto-sync.
  7. Claude:      claude --worktree agent-claude   → tarea en su zona
     Codex:       worktree agent/codex             → tarea en su zona
     Antigravity: abrir worktree agent/antigravity → auditoría/propuestas
  8. Cada agente commitea en SU rama con SU identidad (§3). En cambios de
     conocimiento no triviales: tras `git add` y ANTES de `git commit`,
     despachar el subagente verifier (tier-2). Ver Verifier pre-commit (self-review).

FASE 2 — Integrar (el lead)
  9. Revisar cada rama:  git log --oneline agent/<x> ^main
 10. Mergear de a una:   git checkout main && git merge agent/codex
 11. Resolver conflictos (raros si se respetaron zonas).
 12. git push. Reactivar Obsidian Git auto-sync.
 13. Limpiar:  git worktree remove <path>.

FASE 3 — Verificar
 14. Abrir Obsidian, pull, revisar links y MOCs.
 15. Auditoría CE-RE-BRO si hubo cambios estructurales grandes.
```

## 5. Varias personas con varios agentes cada una

> Aplica solo en **modo equipo** (`VAULT_MODE=equipo` en `owner.env`). El flujo de git compartido —repo por organización, clon por persona, PR, branch protection, hotspots— vive en [SOP Git y Flujo de Trabajo](<SOP Git y Flujo de Trabajo.md>) §11 y **no se repite acá**. Esta sección resuelve solo lo que aparece al cruzar los dos ejes.

### 5.1 Dos ejes, dos aislamientos

Son problemas distintos y se resuelven en capas distintas:

| Eje | Qué aísla | Mecanismo |
|---|---|---|
| **Varios agentes**, una persona | que dos agentes no toquen el mismo archivo en disco | worktree (§1) |
| **Varias personas**, un vault | que dos personas no publiquen a `main` a la vez | clon + rama + PR (SOP Git §11) |

Se anidan, no compiten:

```
<organización>/vault  (main protegido, CODEOWNERS)
   │
   ├── clon de Persona A ── worktrees: agent/claude, agent/codex
   ├── clon de Persona B ── worktrees: agent/claude
   └── clon de Persona C ── sin agentes
```

Cada persona integra **sus propios** worktrees a su rama (FASE 2 del §4, localmente). Lo que llega al PR es **una rama por persona**, no una por agente. Sin esto, tres personas con tres agentes abren nueve PRs y la revisión se vuelve inviable.

### 5.2 Las zonas de propiedad se cruzan

La tabla de §2 reparte por **tipo de tarea** (qué agente escribe qué). En modo equipo hay un segundo reparto por **persona** (`CODEOWNERS`). Un agente tiene que respetar **los dos**:

> Un agente puede escribir donde su zona de §2 **y** la zona de su humano se solapan. Fuera de esa intersección, propone; no escribe.

Ejemplo: el agente de Persona B tiene a `04 Knowledge/Cursos/` en su zona de §2, y Persona B es code owner de `04 Knowledge/`. Escribe. Ese mismo agente **no** toca `00 Sistema/` aunque esté en la zona del lead — porque su humano no lo es.

### 5.3 La bitácora deja de ser un handoff lineal

El hook de sesión inyecta **la última entrada** de la bitácora. Con una persona eso es exactamente "dónde quedé". Con tres, la última entrada puede ser de otra persona en otro tema: sigue siendo contexto útil del vault, pero **ya no es la continuación de tu trabajo**.

Reglas en modo equipo:

- La entrada abre identificando a **la persona y al agente**: `## 2026-07-22 — Persona B / Claude Code`.
- El campo *"qué debe saber el próximo agente"* se escribe pensando en **cualquiera del equipo**, no en tu yo de mañana. Nada de referencias implícitas a lo que solo vos sabés.
- El archivo está cubierto por `merge=union` (`.gitattributes`), así que dos entradas simultáneas se conservan; revisá el **orden cronológico** después de un merge conflictivo — union no ordena.

### 5.4 Verificación: quién juzga el trabajo de quién

El verifier tier-2 es un subagente que se despacha antes de commitear, en el clon de quien trabaja. Sigue igual. Lo que **cambia** es que deja de ser el último control: en modo equipo hay un segundo par de ojos obligatorio —el code owner de la ruta, en el PR— y un tercero automático, el gate del servidor (SOP Git §11.5).

> Regla: **el agente no aprueba su propio PR, y su humano tampoco.** Es la contrapartida operativa de §3.1 — si el humano firma como autor, no puede ser también quien revisa.

### 5.5 Activación

```bash
# owner.env
VAULT_MODE=equipo
TEAM_MEMBERS="Persona A,Persona B,Persona C"

./team-mode.sh      # o ./setup.sh — lo corre solo
```

Crea `05 Diario/<Persona>/` por cada nombre e instala `.github/CODEOWNERS` desde el ejemplo. **No reparte las zonas por vos**: quién es dueño de qué es una decisión de gobernanza, no algo que una plantilla pueda adivinar. El script imprime lo que queda pendiente en GitHub (branch protection).

Idempotente y no destructivo: nunca pisa un archivo existente, y en modo personal no hace nada.

## Referencias
- [Orquestación Multi-Agente Abierta](<Orquestación Multi-Agente Abierta.md>) — el porqué, los riesgos (§7), portabilidad (§9), las 3 capas (§12).
- [SOP Git y Flujo de Trabajo](<SOP Git y Flujo de Trabajo.md>) — la base de git que este SOP extiende.
- [Catálogo de Hooks y Locks](<../04 Knowledge/Automatización/Catálogo de Hooks y Locks.md>) · [[MOC - Agentes]] — las piezas que participan.

## Cómo leer este SOP
Para operar: §4 (el flujo). Para configurar por primera vez: FASE 0 + §3. Si el vault tiene más de un dueño humano: además §3.1 y §5. Para entender por qué es así: [Orquestación Multi-Agente Abierta](<Orquestación Multi-Agente Abierta.md>).
