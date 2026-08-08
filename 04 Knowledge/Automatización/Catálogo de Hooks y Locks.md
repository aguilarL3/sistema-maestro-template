---
type: Reference
title: "Catálogo de Hooks y Locks"
tags: [hooks, automatizacion, catalogo, multiagente]
estado: 🟢 Activo
prioridad: ⏳ Media
responsable: "{{OWNER}}"
id: "REF-HOOKS-CAT-001"
generated:
  by: human:{{OWNER}}
  at: 2026-07-09T00:00:00Z
fecha_creacion: 2026-07-01
resource:
---

>[!info] Documentación relacionada
>[SOP Hooks y Automatización](<../../00 Sistema/SOP Hooks y Automatización.md>) (cómo trabajar con ellos) | [Orquestación Multi-Agente Abierta](<../../00 Sistema/Orquestación Multi-Agente Abierta.md>) | Hooks y ciclo de vida del agente

# Catálogo de Hooks y Locks

Referencia de consulta: qué automatizaciones existen, qué hacen y cómo se controlan. Para el **cómo** (crear/probar/desactivar), ver [SOP Hooks y Automatización](<../../00 Sistema/SOP Hooks y Automatización.md>).

> Es el equivalente, para la automatización, de lo que el `Catálogo de Skills` es para las skills: la carpeta `04 Knowledge/Automatización/` documenta; los ejecutables viven en `.claude/hooks/`.

---

## Hooks activos

| Hook | Evento | Matcher | Qué hace | Identidad | Kill-switch | Estado |
|---|---|---|---|---|---|---|
| **Memoria de sesión** (`session-context.sh`) | `SessionStart` | `startup\|resume\|compact` | **Cara de lectura** del Agent Diary: al arrancar/reanudar/tras compactar, inyecta al contexto el estado git + la **última entrada** de handoff de la bitácora. **Señal de frescura:** si hubo commits después del último toque a la bitácora, avisa `⚠ N commit(s) después de este handoff` (posible desfase → confirmar contra Roadmap). Cierra el círculo escritura→lectura de la memoria persistente. | — | `.vault-meta/session-context.disabled` | 🟢 Activo |
| **Agent Diary** (`agent-diary.sh`) | `Stop` | — | **Cara de escritura:** si hubo trabajo en el vault (marca `session-touched`), bloquea una vez (guard `stop_hook_active`) y hace que el agente registre una entrada de handoff en `05 Diario/Bitácora Agentes/YYYY-MM.md`. El recordatorio impone las **dos reglas de orden**: append al final (la más reciente abajo, así el hook de lectura la toma bien) + el siguiente paso apunta al Roadmap, no lo congela. **Tope de consolidación:** consulta `check-diary-size.sh --level` y, si el mes vigente pasó el techo, suma al aviso la instrucción de **proponer** una consolidación (`SOFT` = sé breve · `HARD` = proponé consolidar). Ver [_Acerca de esta bitácora](<../../05 Diario/Bitácora Agentes/_Acerca de esta bitácora.md>). | — | `.vault-meta/diary.disabled` (tope aparte: `.vault-meta/diary-cap.disabled`) | 🟢 Activo |
| **Monitor de rutinas** (`check-routines.sh`) | `SessionStart` | `startup\|resume\|compact` | Avisa al abrir sesión si una **rutina programada** (agente cloud con cron) se venció. Tapa un hueco propio de las rutinas: escriben su informe y lo commitean, pero **nada avisa cuando NO corren** — y el panel puede seguir mostrándolas "activa" mientras están rotas. Como no hay forma de empujar una notificación, hace que la ausencia sea **imposible de no ver en el momento de contacto**. Mide el **resultado** (fecha del informe más reciente en `05 Diario/Auditorías/`), no el mecanismo → sin credenciales, un informe manual cuenta como mantenimiento hecho, y la fecha sale del **nombre** del archivo (no del mtime, que en un clon fresco sería la hora del checkout y mentiría). **Calla si todo está al día** (un aviso permanente se vuelve paisaje). **OPT-IN por `vault.conf` → `ROUTINES_EXPECTED`; vacío = mudo:** vigilar exige declarar, porque un vault nuevo no tiene ningún informe y si viniera encendido gritaría «NUNCA corrió» desde el día uno. Se **parsea, nunca se sourcea**. CLI: `bash .claude/hooks/check-routines.sh --status`. | — | `.vault-meta/routines-monitor.disabled` | 🟢 Activo (**mudo hasta declarar rutinas**) |
| **Auto-commit** (`auto-commit.sh`) | `PostToolUse` | `Write\|Edit` | Deja la marca de sesión y commitea **solo el archivo tocado** (nunca `-A`). **Consciente de locks:** si otro agente tiene un lock vigente sobre ese archivo (`wiki-lock owner`), no lo commitea (trabajo en curso ajeno); camino común sin locks intacto. | `Claude Code <claude@agent.local>` | `.vault-meta/autocommit.disabled` | 🟡 Activo pero **desactivado en interactivo** (kill-switch puesto para no ensuciar historial; reactivar en corridas autónomas) |
| **Guardián de centinelas** (`sentinels-guard.sh` + `.py`) | `PreToolUse` | `Write\|Edit` | Bloquea (exit 2) toda edición/sobrescritura que caiga dentro de un bloque `<!-- @user -->` (contenido humano). **Fail-open** (ante duda, permite). Usa `python` para parsear el JSON. Ver [Centinelas de Edición](<../../00 Sistema/Centinelas de Edición.md>). | — | `.vault-meta/sentinels.disabled` | 🟢 Activo (inerte hasta que existan centinelas) |
| **Guardián de seguridad** (`security-guard.sh` + `.py`) | `PreToolUse` | `Bash\|Read` | **Capa 2 de seguridad** (ver [SOP de Seguridad](<../../00 Sistema/SOP de Seguridad.md>) §2). Bloquea (exit 2): salida de red por shell (`curl`/`wget`/`nc`/`telnet`), lectura de secretos (`.env`/`id_rsa`/`.pem`/`credentials.json`/`.ssh`/`.aws`), `git push --force/-f`, y escritura por shell a config (`.claude/`/`.githooks/`/`.mcp.json`). Escanea el comando **entero** → ataja evasiones que el `deny` por-prefijo de `settings.local.json` no ve. **Fail-open** (la capa 1/permisos sigue vigente si el hook falla). A propósito NO cubre `rm -rf` ni salida de red por PowerShell (decisión documentada en el `.py`). Usa `python`. | — | `.vault-meta/security-guard.disabled` | 🟢 Activo |
| **Ruteo por intención** (`route-intent.sh`) | `UserPromptSubmit` | — | Mira palabras clave del prompt del usuario e inyecta **pistas de ruteo** al agente (a qué capa/plantilla/SOP va lo pedido). Sin LLM (regex); extrae el prompt con `python`. Falsos positivos cuestan ~0. Ver Ruteo por intención y backup de sesión. | — | **OPT-IN**: nace apagado. Encender = crear `.vault-meta/route-intent.enabled`; apagar = borrarlo. | 🟡 Cableado, **apagado por defecto** (ruido en sesiones de build; prenderlo al capturar/procesar notas) |
| **Backup de transcript** (`pre-compact.sh`) | `PreCompact` | — | Antes de que el harness compacte el contexto, copia la conversación completa a `.vault-meta/session-logs/` (gitignored). Conserva los ~20 más recientes (`PRECOMPACT_RETAIN`). Invisible. Ver Ruteo por intención y backup de sesión. | — | `.vault-meta/precompact.disabled` | 🟢 Activo |

## Marcas y archivos de control (`.vault-meta/`, gitignored)

| Archivo | Rol |
|---|---|
| `session-touched` | Marca que hubo escritura de contenido del vault esta sesión (la deja `auto-commit.sh`; la consume `agent-diary.sh`). |
| `diary.disabled` | Kill-switch de la bitácora. |
| `autocommit.disabled` | Kill-switch del auto-commit. |
| `route-intent.enabled` | **Flag opt-in** del ruteo por intención: si existe, el router se activa. Ausente = apagado (default). |
| `precompact.disabled` | Kill-switch del backup de transcript. |
| `security-guard.disabled` | Kill-switch del guardián de seguridad (capa 2). |
| `routines-monitor.disabled` | Kill-switch del monitor de rutinas. (Para no vigilar nada alcanza con dejar `ROUTINES_EXPECTED` vacío en `vault.conf`; esto es el corte de emergencia.) |
| `diary-cap.disabled` | Kill-switch **solo del tope** de la bitácora (la bitácora sigue funcionando). |
| `session-logs/` | Backups de transcript por sesión (`session_<trigger>_<ts>.jsonl`) que deja `pre-compact.sh`. Gitignored, retención ~20. **Se consultan con `search-sessions.py`.** ⚠️ Cobertura parcial por diseño: `pre-compact.sh` solo dispara **al compactar**, así que una sesión que nunca compactó no deja rastro. |
| `locks/` | Locks advisory por-archivo (`<slug>.lock/` con `meta`). Los gestiona `wiki-lock.sh`. |

---

## Locks

| Lock | Qué hace | Estado |
|---|---|---|
| **Advisory por-archivo** (`wiki-lock.sh`, ref. `claude-obsidian`) | `acquire`/`release`/`peek`/`owner`/`list`/`clear-stale` por-archivo. Posesión atómica vía `mkdir` (dir-lock); robo de vencidos vía `mv` (rename) atómico; propiedad por identidad de agente (`WIKI_LOCK_AGENT`, fallback `$USER`); staleness por edad (TTL 120s, configurable). Un writer toma el lock, el otro reintenta o falla `busy`. `owner` = dueño si el lock está vigente (machine-friendly, lo consume el auto-commit); `list` = inventario de locks. | 🟢 **Implementado y probado** en Windows/Git Bash. Se eliminó el meta-lock `flock` del original (innecesario para lock por-archivo). Herramienta CLI: se invoca alrededor de una edición; **no** se cablea a eventos. Ver uso en [SOP Hooks y Automatización](<../../00 Sistema/SOP Hooks y Automatización.md>) §7. |

---

## Herramientas de auditoría (CLI)

Scripts en `.claude/hooks/` que **no** se cablean a eventos: se corren a mano (o desde una skill de mantenimiento) para auditar el estado del vault.

| Herramienta | Qué hace | Estado |
|---|---|---|
| **Chequeador de enlaces** (`check-links.sh`) | Detección de **conflicto semántico — parte de enlaces** (Gap 2a §13.3): escanea todos los `.md`, resuelve cada `[[wikilink]]`/embed estilo Obsidian (basename o ruta, case-insensitive; **honra los `aliases:` del frontmatter**; ignora secciones, bloques de código y URLs) y reporta destinos inexistentes, agrupados por archivo. `--quiet` = solo el resumen; `--tsv` = `archivo⇥línea⇥link` machine-readable (la consume `heal-links.py`). | 🟢 **Implementado y probado.** Un solo pase de awk (~0.6s todo el vault) + pase liviano de aliases. Ya integrado en [Skill - Mantenimiento Sistema](<../Skills/Skill - Mantenimiento Sistema.md>) (Nivel 0). Nota: los enlaces a conceptos planificados sin crear también aparecen (esperado). |
| **Sanador de enlaces** (`heal-links.py`, Gap B §13.3, ref. `obsidian-second-brain`) | Evolución de *detectar* → *sugerir/arreglar*. Consume `check-links.sh --tsv` (una sola fuente de detección) y clasifica sin IA cada roto por parecido de nombre (`difflib`, cutoff 0.90): **repunte seguro** (una nota muy parecida → lo sugiere), **ambiguo** (2+ → decide un humano), **sin destino** (0 → crear la nota o quitar el enlace). **Propone por defecto** (no toca nada); `--apply --max N` aplica solo los repuntes seguros, acotado, recontando cada pase (bucle cerrado) y frenando si el conteo no baja. Nunca toca placeholders (`{}*<>`) ni plantillas; preserva alias/sección al repuntar. | 🟢 **Implementado y probado** (E2E en vault de juguete). Requiere `python` (fail-hard con mensaje si falta; es CLI, no bloquea sesión). Adaptado a la ley del vault: **propone, no decide; nunca borra** (el `triage --apply` del prior art que auto-borra/crea se descartó). En el vault hoy: 0 repuntes (no hay typos/renames), 144 sin-destino = worklist de triage de contenido. |
| **Buzón de contradicciones** (`check-contradictions.sh`) | Lado determinista del **conflicto semántico — contradicciones** (Gap 2b §13.3): recorre el vault y lista todos los callouts `> [!contradiction]` con archivo/línea/estado/título, contando cuántas quedan **abiertas**. La detección la hace un humano/agente con criterio; el script solo inventaría lo marcado. `--quiet` = solo el resumen. Convención y workflow en [Conflicto Semántico - Enlaces y Contradicciones](<../../00 Sistema/Conflicto Semántico - Enlaces y Contradicciones.md>). | 🟢 **Implementado y probado.** Un pase de awk. Candidato a integrarse en [Skill - Mantenimiento Sistema](<../Skills/Skill - Mantenimiento Sistema.md>). |
| **Auditor de seguridad** (`security-audit.sh`) | **Capa 4 (detectivo)** del [SOP de Seguridad](<../../00 Sistema/SOP de Seguridad.md>) §2: audita la superficie de ataque que vive en git → (1) secretos committeados (nombre + contenido con formato conocido: claves privadas, `AKIA`, `ghp_`, etc.), (2) integridad del `.gitignore` (que siga protegiendo `.vault-meta/` y `settings.local.json`), (3) inventario de hooks + banderas de red/exfil, (4) plugins de Obsidian (para revisión humana), (5) wiring de los guardianes. Solo LEE; reporta por stdout; `--quiet` = solo resumen. **No ve** estado local/cuenta (allowlist gitignoreada, MCP de rutinas) → deja recordatorio de revisión manual. | 🟢 **Implementado y probado.** Integrado en [Skill - Mantenimiento Sistema](<../Skills/Skill - Mantenimiento Sistema.md>) (Dimensión 3) → lo corre la **rutina semanal** (Rutinas Programadas). Bash puro. |
| **Buscador de sesiones** (`search-sessions.py`) | Consulta los transcripts que `pre-compact.sh` guarda en `.vault-meta/session-logs/`. Es *grep con estructura*: sabe qué es un turno, de quién y cuándo, e ignora los `tool_result` (volcados de archivos = ruido). **Dedupe por `sessionId`**: dos snapshots de una misma sesión larga son un hilo, no dos. Búsqueda **sin acentos ni mayúsculas** (`revision` encuentra `Revisión`). `--list` = inventario · `--role user` = solo lo que pidió el humano · `--regex` · `--full`. | 🟢 **Implementado y probado.** Escaneo directo en vez de índice invertido: el corpus son pocos MB y mantener un índice costaría más que escanear (si algún día crece a cientos de sesiones, ahí entra SQLite FTS5). Es búsqueda **por palabra**, no semántica. ⚠️ Solo ve sesiones que **compactaron** — usá `--list` antes de concluir que algo "no existe". |
| **Tope del Agent Diary** (`check-diary-size.sh`) | Mide las bitácoras mensuales y marca las que pasaron el techo (soft 120k chars / 25 entradas · hard 200k / 40; configurable por env). Mide **caracteres, no líneas**: las entradas son párrafos largos y contar líneas subestimaría el costo de contexto varias veces. `--level` devuelve `OK\|SOFT\|HARD` del mes vigente y es la interfaz que consume el hook `Stop`. | 🟢 **Implementado y probado.** La bitácora está acotada *al leer* (el hook inyecta solo la última entrada) pero sería infinita *al escribir*; esto le pone el techo que faltaba. **No borra ni bloquea:** hace que el agente *proponga* la consolidación, porque la ley del vault es "nunca borrar" y "siempre proponer, nunca decidir solo". |

---

## Git hooks (versionados en `.githooks/`)

A diferencia de los hooks del harness (§ Hooks activos, disparados por Claude Code), estos corren en **cada `git commit`** — lo haga un agente o un humano. Se versionan en `.githooks/` y se activan con `git config core.hooksPath .githooks` (setup local, una vez por clon, como `core.longpaths`). Como `core.hooksPath` apunta a la **carpeta**, un hook nuevo que llegue por `update.sh` queda activo sin volver a configurar nada.

| Hook | Qué hace | Modo | Kill-switch | Estado |
|---|---|---|---|---|
| **Verifier pre-commit — tier-1 determinista** (`.githooks/pre-commit` → `.claude/hooks/verify-commit.sh`) | Self-review determinista: relee los archivos **staged** y valida frontmatter obligatorio (4 campos) + formato de tags en docs de zonas obligatorias (§13.3 gap "verifier"). También corre a mano: `bash .claude/hooks/verify-commit.sh`. Lo mecánico. | **Warn-only** por defecto (reporta, no frena); **estricto** con `.vault-meta/verifier.strict` o `VERIFIER_STRICT=1` (bloquea si hay errores). Fail-open. | `.vault-meta/verifier.disabled` | 🟢 Activo |
| **Verificador de centinelas** (`.githooks/pre-commit` → `.claude/hooks/sentinels-verify.py`) | Equivalente **agnóstico** del guardián `PreToolUse`: toma los bloques `<!-- @user -->` de la versión anterior de cada `.md` que cambió y exige que sigan textuales en la nueva. Cubre alteración **y borrado del archivo**. Ignora los marcadores que viven dentro de bloques de código (las guías del vault los usan como ejemplo). Corre también en el PR (`verify.yml`). | **Bloquea** (exit 1). Escapes: `SENTINELS_OK=1`. Fail-open ante error. | `.vault-meta/sentinels.disabled` (compartido con el guard) | 🟢 Activo |
| **Guardia de push** (`.githooks/pre-push`) | Equivalente **agnóstico** de la regla `FORCE_PUSH` de `security-guard`: bloquea el push **no fast-forward**, que es lo que `--force` de verdad hace. Detecta el **efecto**, no la bandera → tampoco pasa un `git push origin +main`. Avisa (sin bloquear) al borrar una rama remota. | **Bloquea** (exit 1). Escape: `ALLOW_FORCE_PUSH=1`. Fail-open si no puede determinar la relación entre los commits. | `.vault-meta/prepush.disabled` | 🟢 Activo |

> **Por qué existen los dos de abajo.** El guardián `PreToolUse` es temprano y preciso, pero **solo protege a Claude Code**: los hooks de `.claude/settings.json` no corren en Codex ni en ningún otro harness. Estos corren en el gate de git, que sí es universal. Tarde, pero para todos. El reparto es deliberado: el guard evita que el agente **escriba**; el verificador evita que lo escrito **entre a la historia**. Ver `AGENTS.md` §Trabajo en paralelo con otros agentes.
>
> Lo que **no** tiene equivalente agnóstico —y sigue siendo un hueco declarado— es la salida de red por shell y la lectura de archivos de credenciales: ninguna de las dos es observable en un commit.

### El mismo gate, del lado del servidor

Los git hooks corren en el clon de quien commitea, y solo si esa persona corrió `./setup.sh`. Para que eso no dependa de la máquina de nadie, **`.github/workflows/verify.yml`** invoca **los mismos scripts** en cada PR — no es una implementación paralela que pueda divergir:

```bash
bash    .claude/hooks/secret-scan.sh      --range <base> <head>
python3 .claude/hooks/sentinels-verify.py --range <base> <head>
bash    .claude/hooks/verify-commit.sh    --range <base> <head>
```

El flag `--range` existe porque en un PR no hay nada staged: selecciona lo que cambió entre dos refs en lugar del índice. Las reglas son idénticas en los dos modos. Reparto de severidad y configuración: [SOP Git y Flujo de Trabajo](<../../00 Sistema/SOP Git y Flujo de Trabajo.md>) §11.5.

## Workflows de GitHub Actions (`.github/workflows/`)

Corren en el servidor, no en tu máquina. Son la capa que no depende de que cada clon esté bien configurado.

| Workflow | Cuándo | Qué hace | Bloquea |
|---|---|---|---|
| **`verify.yml`** | cada PR + manual (`gh workflow run verify.yml`) | Invoca `secret-scan.sh`, `sentinels-verify.py` y `verify-commit.sh` en modo `--range`, más enlaces e índices como informativos. Ver arriba. Sin payload de PR verifica el último commit. | `secret-scan` y `sentinels-verify` (y frontmatter si `VERIFIER_STRICT: "1"`) |
| **`template-update.yml`** | lunes 09:00 UTC + manual | Compara tu `VERSION` con la del template upstream y, si hay versión nueva, corre `update.sh --force` y **abre un PR** con los archivos de framework actualizados. | No mergea nada solo |

### Sobre `template-update.yml`

`./update.sh --check` ya existía, pero alguien tiene que acordarse de correrlo — con un vault propio eso se olvida, con varios vaults de clientes no pasa nunca. El workflow convierte la actualización en algo que **llega solo, como PR revisable** (el patrón que usan cruft/copier para plantillas de proyecto).

Tres detalles de diseño que importan:

- **Se autodesactiva en el template mismo.** Compara `origin` con `UPSTREAM_URL` normalizando (con/sin `.git`, con/sin credenciales); si son el mismo repo, no hace nada. Sin esto el template intentaría actualizarse contra sí mismo cada lunes.
- **Reconstruye `owner.env` desde variables del repo** (`OWNER`, `OWNER_EMAIL`, `OWNER_GITHUB`, `VAULT_MODE`, `TEAM_MEMBERS`). `owner.env` está gitignoreado por ser identidad de la instancia; sin él, `personalize.sh` no correría y el PR llegaría con `{{ OWNER }}` sin reemplazar. Si falta la variable `OWNER`, el workflow **falla con un error explícito** en vez de abrir un PR malo.
- **Cero actions de terceros.** Solo `actions/checkout` y el `gh` que ya trae el runner. Una action de terceros dentro de un workflow con permiso de escritura es superficie de cadena de suministro. Ver [SOP de Seguridad](<../../00 Sistema/SOP de Seguridad.md>).

**Límite conocido — los workflows se actualizan a mano.** El token de Actions **no puede crear ni modificar archivos de `.github/workflows/`** (GitHub rechaza el push). Si una versión nueva cambia un workflow, el bot lo revierte, abre el PR con el resto y lo avisa en el cuerpo; si lo único que cambió eran workflows, no abre PR y deja la nota en el resumen de la corrida. En ambos casos se resuelve con un `./update.sh` local. La alternativa —un PAT con scope `workflow` guardado como secreto en cada vault derivado— sería un secreto de larga vida por repo: peor negocio que un paso manual ocasional.

Configuración en el repo derivado: variables en Settings → Secrets and variables → Actions, y "Read and write" + "Allow GitHub Actions to create and approve pull requests" en Settings → Actions → General.

## Subagentes (`.claude/agents/`)

Agentes que el agente principal **despacha** (vía Task) en **contexto fresco**, para tareas que necesitan una segunda opinión independiente. No se disparan por evento: los invoca el owner cuando corresponde.

| Subagente | Qué hace | Cuándo | Estado |
|---|---|---|---|
| **verifier — tier-2 juez LLM** (`.claude/agents/verifier.md`, ref. `claude-obsidian`) | Complemento de criterio del verifier: lee el diff **staged** y juzga la **calidad de conocimiento** que el tier-1 no puede — atomicidad (una nota = una idea), `type` correcto (Diátaxis), duplicación probable, notas huérfanas, coherencia con SOPs/glosario/Matriz Definitiva. Devuelve hallazgos en 4 tiers (BLOQUEANTE/ALTO/MEDIO/BAJO) + veredicto. **Advisory** (no modifica; propone). | Tras `git add`, antes de `git commit`, en cambios de conocimiento no triviales. | 🟢 Implementado (activa al recargar sesión). Kernel adaptado de código → conocimiento. |

---

## Wiring (dónde se conectan)

- **Claude Code:** `.claude/settings.json` → `hooks.PostToolUse`, `hooks.Stop`.
- **Codex (cross-CLI, futuro):** `.codex/hooks.json` apuntando a los mismos `.claude/hooks/*.sh` (patrón de `obsidian-mind`).

## Cómo leer este catálogo
Es referencia: se consulta, no se lee de corrido. Cuando quieras saber **qué** hace una automatización o **cómo desactivarla**, mirá su fila. Para crear una nueva, andá a [SOP Hooks y Automatización](<../../00 Sistema/SOP Hooks y Automatización.md>) §5.
