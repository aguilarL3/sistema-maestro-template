---
tipo_doc: SOP
tags: [sop, multiagente, worktrees, commits, orquestacion, agentes]
estado: 🟢 Activo
prioridad: 🔥 Alta
responsable: "{{OWNER}}"
id: "SOP-014"
ultima_revision: 2026-07-11
fecha_creacion: 2026-07-11
---

>[!info] Documentación relacionada
>[[Orquestación Multi-Agente Abierta]] (el *porqué* — este SOP es su §4-6 promovido, según su propio plan §10) | [[SOP Git y Flujo de Trabajo]] (base que se extiende) | Verifier pre-commit (self-review) | [[MOC - Agentes]]

# SOP Multi-Agente — operar varios agentes sin que se pisen

## Objetivo

El *cómo* operativo para trabajar con varios agentes (Claude Code, Codex, Antigravity…) en el vault: aislamiento por worktrees, zonas de propiedad, identidad de commit y el flujo completo por corrida. Todo validado en la práctica (ensayo 2026-06-30 + operación diaria). El *porqué* y el marco conceptual viven en [[Orquestación Multi-Agente Abierta]].

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

## 3. Identidad y mensaje de commit (quién hizo qué)

Extiende [[SOP Git y Flujo de Trabajo]] §4. Dos palancas: **identidad** (autor) y **mensaje** (trailer). Usar **ambas**.

| Agente | `user.name` | `user.email` |
|---|---|---|
| {{OWNER}} (humano) | `{{OWNER}}` | `{{OWNER_EMAIL}}` (global) |
| Claude Code | `Claude (Claude Code)` | `claude@agent.local` (o trailer `Co-Authored-By`) |
| Codex | `Codex` | `codex@agent.local` (`~/.codex/config.toml`) |
| Antigravity | `Antigravity (Gemini)` | `antigravity@agent.local` (a mano) |

> **⚠️ Trampa verificada (ensayo 2026-06-30):** `cd worktree && git config user.email …` escribe en la config **compartida** del repo (contamina `main`). Métodos correctos:
> - **(a)** firmar cada commit: `git -c user.name="Claude" -c user.email="claude@agent.local" commit …` ✅ recomendado
> - **(b)** identidad persistente por worktree: `git config extensions.worktreeConfig true` → `git config --worktree user.email …`

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
  6. git config core.hooksPath .githooks  ← verifier pre-commit, 1×/clon.   ✅

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

## Referencias
- [[Orquestación Multi-Agente Abierta]] — el porqué, los riesgos (§7), portabilidad (§9), las 3 capas (§12).
- [[SOP Git y Flujo de Trabajo]] — la base de git que este SOP extiende.
- [[Catálogo de Hooks y Locks]] · [[MOC - Agentes]] — las piezas que participan.

## Cómo leer este SOP
Para operar: §4 (el flujo). Para configurar por primera vez: FASE 0 + §3. Para entender por qué es así: [[Orquestación Multi-Agente Abierta]].
