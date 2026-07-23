# .claude/hooks — Hooks del harness (Claude Code)

Scripts de automatización que **Claude Code** (y Codex, vía `.codex/hooks.json`) ejecuta en eventos del ciclo de sesión. **No** son git hooks de `.git/hooks/`: son hooks del *harness*, configurados en `../settings.json`.

> **Documentación completa:**
> - Cómo funcionan, crear, probar y desactivar → `00 Sistema/SOP Hooks y Automatización.md`
> - Qué hace cada uno (catálogo) → `04 Knowledge/Automatización/Catálogo de Hooks y Locks.md`

## Hooks actuales

| Script | Evento | Qué hace | Kill-switch |
|---|---|---|---|
| `session-context.sh` | `SessionStart` (`startup\|resume\|compact`) | **Memoria de lectura**: inyecta estado git + último handoff de la bitácora al arrancar/reanudar/tras compactar. | `.vault-meta/session-context.disabled` |
| `route-intent.sh` | `UserPromptSubmit` | **Ruteo por intención** (OPT-IN): pistas de ruteo al agente según keywords del prompt. Requiere `python`. | Apagado salvo que exista `.vault-meta/route-intent.enabled` |
| `pre-compact.sh` | `PreCompact` | **Backup de transcript**: copia la sesión a `.vault-meta/session-logs/` antes de compactar (retiene ~20). | `.vault-meta/precompact.disabled` |
| `agent-diary.sh` | `Stop` | Si hubo trabajo en el vault, hace que el agente registre la **bitácora de handoff** antes de terminar. | `.vault-meta/diary.disabled` |
| `auto-commit.sh` | `PostToolUse` (`Write\|Edit`) | Commitea **solo el archivo tocado** con identidad `Claude Code <claude@agent.local>`. **Consciente de locks**: no commitea un archivo con lock vigente de otro agente. | `.vault-meta/autocommit.disabled` |
| `wiki-lock.sh` | — (CLI manual) | **Lock advisory por-archivo** para escritura multi-agente: `acquire`/`release`/`peek`/`owner`/`list`/`clear-stale`. Sin `flock` (usa `mkdir` atómico). Se invoca alrededor de una edición en zona compartida; **no** se cablea a eventos. | — |
| `check-links.sh` | — (CLI / auditoría) | **Chequeador de enlaces**: reporta `[[wikilinks]]` rotos en todo el vault (~0.6s), honrando `aliases:`. `--quiet` = resumen; `--tsv` = machine-readable. | — |
| `heal-links.py` | — (CLI / reparación) | **Sanador de enlaces**: consume `check-links.sh --tsv` y **propone** repuntes de match único (fuzzy 0.90) + reporte de triage. `--apply --max N` los aplica solo, acotado. No borra. Requiere `python`. | — |
| `check-contradictions.sh` | — (CLI / auditoría) | **Buzón de contradicciones**: lista los callouts `[!contradiction]` y cuántas quedan abiertas. `--quiet` para solo el resumen. | — |
| `sentinels-guard.sh` + `.py` | `PreToolUse` (`Write\|Edit`) | **Guardián de centinelas**: bloquea ediciones dentro de bloques `<!-- @user -->` (contenido humano). Fail-open. Requiere `python`. | `.vault-meta/sentinels.disabled` |
| `security-guard.sh` + `.py` | `PreToolUse` (`Bash\|Read`) | **Guardián de seguridad** (capa 2): bloquea (exit 2) salida de red por shell (curl/wget/nc), lectura de secretos (`.env`/`id_rsa`/`.pem`…), `git push --force`, y escritura por shell a config (`.claude/`/`.githooks/`/`.mcp.json`). Escanea el comando entero (ataja evasiones del `deny` por-prefijo). Fail-open. Requiere `python`. Ver [[SOP de Seguridad]]. | `.vault-meta/security-guard.disabled` |
| `verify-commit.sh` | git `pre-commit` (vía `.githooks/`) | **Verifier**: valida frontmatter + tags de los archivos staged. Warn-only; estricto con `.vault-meta/verifier.strict`. También CLI. | `.vault-meta/verifier.disabled` |
| `sentinels-verify.py` | git `pre-commit` + PR (`verify.yml`) | **Verificador de centinelas — equivalente agnóstico del guard de arriba**: exige que los bloques `<!-- @user -->` de la versión anterior sigan textuales. Cubre el borrado del archivo. Ignora los marcadores que son ejemplos (fences y backticks). Bloquea; escape `SENTINELS_OK=1`. | `.vault-meta/sentinels.disabled` |

## Git hooks (aparte de los del harness)

Corren en cada operación de git —la haga un agente o un humano, desde el harness que sea—. **Son la única capa que existe fuera de Claude Code.** Activación local, una vez por clon:
```bash
git config core.hooksPath .githooks
```

| Hook | Cadena |
|---|---|
| `.githooks/pre-commit` | `secret-scan` → `sentinels-verify` → regeneración de índices → aviso de archivos de control → `verify-commit` |
| `.githooks/pre-push` | bloquea el push **no fast-forward** (el efecto de `--force`, detectado por efecto y no por bandera). Escape: `ALLOW_FORCE_PUSH=1`. Kill-switch: `.vault-meta/prepush.disabled` |

Como `core.hooksPath` apunta a la **carpeta**, un hook nuevo que llegue por `update.sh` queda activo sin reconfigurar nada.

## Requisitos

- **Git Bash** (Windows). Sin `node`, sin `jq` (los scripts están en shell puro por portabilidad).
- **`python`** para `sentinels-guard` (JSON multilínea), `sentinels-verify.py`, `route-intent.sh` (extraer el prompt del JSON) y `heal-links.py` (`difflib`). Todos fail-open si falta — incluido el pre-commit, que saltea el paso de centinelas si no hay python.
- `settings.json` fuerza `"shell": "bash"`.

## Activar cambios

Los hooks se cargan al iniciar sesión. Tras editar `settings.json` o los scripts, abrí `/hooks` en Claude Code (recarga config) o reiniciá.
