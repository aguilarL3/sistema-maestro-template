---
type: Changelog
title: "CHANGELOG del Sistema"
tags: [changelog, sistema]
description: "Registro de cambios del framework (template). Los cambios de tu instancia van en tu bitácora, no acá."
estado: 🟢 Activo
id: "LOG-001"
generated:
  by: human:{{OWNER}}
  at: 2026-07-17T00:00:00Z
fecha_creacion: 2026-07-04
resource:
---

# CHANGELOG del Sistema

Registro de cambios del **framework** (template). `update.sh` actualiza este archivo junto al resto del framework — **no anotes acá los cambios de tu instancia** (se pisarían en el próximo update): esos van en tu bitácora de agentes o en una nota propia.

## [1.10.0] — 2026-08-06
**Los dos SOPs que el onboarding de una segunda persona necesita dejan de estar incompletos.**

- **Nuevo: [SOP Git](<SOP Git y Flujo de Trabajo.md>) §12 "Cuentas, organizaciones e identidad en GitHub"** (12.1 a 12.6). §11 ya resolvía *cómo* trabajan varias personas sobre un repo; faltaba la capa de abajo — **de quién es la cuenta, de quién es el repo y quién firma cada commit**, que es lo que hay que decidir *antes* de invitar a la primera persona. Cubre: una cuenta personal + una Organization por negocio (y por qué "la cuenta de la empresa" no existe), cuántos owners, clonar en vez de forkear, **correo verificado antes del primer commit**, identidad por proyecto con `includeIf`, y cómo se demuestra el aporte cuando el repo es privado. Se escribió al descubrir que un runbook de onboarding citaba esta sección seis veces y **ninguna instancia la tenía**: vivía solo en el vault de origen.
- **Nuevo: [SOP Proyectos de Código](<SOP Proyectos de Código.md>) §6.1 "Modo equipo y paralelismo"** — la tabla de qué pieza del seed resuelve qué (`repo.conf`, gate de rama, `verify.yml`, `CODEOWNERS.example`, `merge=union` en la bitácora) y cuál es su estado por defecto. Mismo motivo: citada por el runbook, ausente de las instancias.
- 🔴 **Corregido un reclamo falso que estaba en los tres documentos: el plan Free de GitHub NO protege ramas en repos privados.** Medido contra la API: *branch protection* **y** *rulesets* devuelven **403 · "Upgrade to GitHub Pro or make this repository public"**. Era falso decir "Plan Free alcanza" sin más, y era falso listar "Proteger `main`" como un paso ejecutable. Se corrigió en §12.1 (con la tabla de qué sobrevive y qué no), en §11.5 (el status check del PR pasa a ser **señal, no bloqueo**) y en §6.1 del SOP de código.
- **La consecuencia se documenta donde se toma la decisión, no como nota al pie:** sin capa de servidor, **`setup.sh` en el clon de cada persona es el único control que existe** — deja de ser higiene de instalación y pasa a ser el paso crítico del onboarding, con verificación explícita (`git config core.hooksPath` → `.githooks`). Y como el resto pasa a ser convención, hace falta un **acuerdo escrito en lenguaje llano** que la gente lea de verdad: ese documento *es* el control.
- **Aviso nuevo en §6.1:** en modo equipo `setup.sh` imprime las reglas de *Settings → Rules* como recordatorio. En plan Free con repos privados ese recordatorio **pide algo imposible** — se lee como "lo que tendrías si pagaras", no como pendiente accionable.
- **Aprendizaje de método incorporado a §6.1:** un comando declarado no es una verificación. Antes de cablear una suite a un gate, **correla entera una vez**. Y verificar con `cmd | tail` miente: `$?` devuelve el estado de `tail`, no el de la suite.
- 🔴 **Corregido: 6 frases del framework se autodestruían en cada `personalize.sh`.** El script sustituye con `sed` literal sobre **todos** los `.md` y `.txt`, así que cualquier documento que *hablara* del token lo perdía: *"placeholders `{{ OWNER }}` sin resolver"* quedaba como *"placeholders `Ana Pérez` sin resolver"*. Estaba pasando en `.claude/commands/onboarding.md`, en 4 entradas de este CHANGELOG y en `Catálogo de Hooks y Locks` — y como `update.sh` re-corre `personalize.sh`, el daño se repetía en cada actualización. Los 6 pasaron a la forma escapada.
- **Nuevo: [SOP Documentación](<SOP Documentación.md>) §6.2 "Escribir *sobre* los placeholders del template".** La convención que evita que vuelva a pasar: en prosa, el token va **con un espacio interno**; en frontmatter y plantillas, sin él. El espacio es **funcional** — un agente que lo "corrija" por prolijidad rompe la frase en la próxima corrida, y el síntoma aparece después, en otro archivo, sin relación aparente con el arreglo. Incluye el alcance real del script (`.md` y `.txt`, **no** `.py` ni `.sh`) y qué placeholders no corren riesgo (`{{date}}` de Templater, `${{ }}` de Actions).

## [1.11.1] — 2026-08-07
**El PR ahora te menciona solo, y te dice qué mirar primero.**

- **Nuevo workflow `.github/workflows/aviso-de-pr.yml`.** Al abrirse un PR, comenta mencionando a quien tiene que revisar. Una **@mención notifica SIEMPRE**: no depende del plan de GitHub, ni de que la persona siga el repo, ni de que quien abre el PR se acuerde de pedir el review. Es el rodeo exacto a la limitación del `CODEOWNERS` documentada en la 1.11.0.
- **Pero un ping pelado no agrega nada sobre el mail del *watching*, así que el comentario hace algo más:** marca **si el PR toca las rutas que cambian el comportamiento del agente de la otra persona** (`00 Sistema/`, `.claude/`, `.githooks/`, `AGENTS.md`, `CLAUDE.md`, scripts raíz…). Eso es lo que más fácil se pasa por alto en un diff y lo único que hay que revisar sí o sí.
- **Tres decisiones de diseño que conviene no "simplificar":**
  - **Sin `synchronize` en el `on:`** — solo `opened`, `reopened` y `ready_for_review`. Con `synchronize`, cada push a la rama volvería a comentar.
  - **A quién mencionar se resuelve por API** (colaboradores con permiso de escritura, menos el autor), **no con handles hardcodeados**: si entra o sale gente del equipo, sigue estando bien solo.
  - **Nunca falla el check** (`|| true` y `exit 0`): un aviso roto no debe bloquear un PR. Y no comenta desde forks ni en borradores.
- **Hardening:** los valores entran por `env:` y **nunca interpolados con `${{ }}` dentro del `run:`** — un `${{ }}` se sustituye como texto antes de que corra el shell, así que un título de PR con comillas o `$(...)` se ejecutaría. Cero actions de terceros: solo el `gh` del runner.

## [1.11.0] — 2026-08-07
**En modo equipo, nada te avisaba que había un PR esperando tu review.**

- 🔴 **Hallazgo que motiva la versión: `CODEOWNERS` NO auto-asigna revisor en repos privados con plan Free.** Verificado contra la API: PRs abiertos con el archivo ya correcto y con la otra persona listada como code owner en todas las rutas quedaron con **`requested_reviewers` vacío**. Consecuencia: la vista *"te pidieron review"* de GitHub y de `gh pr status` **queda muerta**, y un PR puede esperar días sin que nadie se entere. La documentación del template que sugería lo contrario estaba equivocada.
- **Nuevo hook `.claude/hooks/pr-notice.sh` (`SessionStart`).** Al abrir la sesión te dice qué PRs abiertos **esperan tu review** y cuáles son tuyos esperando el review del otro. **No se apoya en review requests** —justamente porque no funcionan— sino en listar los PR abiertos y separar por autor, que es la única señal confiable en ese escenario.
  - **Inerte fuera de modo equipo:** sale antes de hacer nada si `VAULT_MODE` no es `equipo`. Un vault de un solo dueño no paga nada.
  - **Fail-open completo:** sin `gh`, sin autenticación, sin python, sin red o con timeout → silencio y `exit 0`. Un hook de sesión no puede impedir abrir una sesión.
  - Cachea tu usuario de GitHub en `.vault-meta/gh-login` (una llamada de red cuyo resultado no cambia). Kill-switch: `.vault-meta/pr-notice.disabled`.
- **Nueva skill `/revisar-pr`** (`.claude/commands/revisar-pr.md` + [nota](<../04 Knowledge/Skills/Skill - Revisar PR.md>)). Traduce un PR al lenguaje del vault y clasifica lo que cambió **por peso real**: ley y comportamiento primero, contradicciones después, conocimiento nuevo, y el ruido de `index.md` regenerados **nombrado y no detallado**. Devuelve veredicto 🟢/🟡/🔴/⚠️ y preguntas listas para pegar en el PR.
  - **El hallazgo que solo esta capa puede ver:** que el PR afirme algo que el vault **ya afirmaba distinto** en otra nota. Ningún verificador determinista lo detecta, y quien escribió el PR es el menos probable de notarlo.
  - **No aprueba, no mergea, no comenta** — ni con veredicto 🟢. [SOP Multi-Agente](<SOP Multi-Agente.md>) §5.4: si el agente aprueba, el único control que quedaba desaparece.
- **Nota de método:** el aviso por sesión no reemplaza al de GitHub. Seguir el repo (*Watch → All Activity*) es lo que te avisa cuando **no** estás en una sesión; este hook es lo que te avisa cuando sí. Y que la otra persona abra el PR con `--reviewer <tu-usuario>` es lo que enciende la vista de GitHub que el `CODEOWNERS` no puede encender.

## [1.10.1] — 2026-08-06
**`setup.sh` dejaba de mandar a la segunda persona a re-personalizar el vault con su nombre.**

- 🔴 **Corregido: `setup.sh` sugería "pedile a un agente «Run onboarding»" en TODO clon**, incluido el de alguien que se suma a un vault **que ya tiene dueño**. Ese onboarding pide la identidad de quien lo corre, escribe el archivo de identidad y corre `personalize.sh`: el vault entero queda re-personalizado con el nombre de la persona nueva, con **dos identidades mezcladas**. Detectado clonando el vault como lo haría la segunda persona y leyendo la salida real del script — no en el código.
- **El paso 3 ahora es condicional a `FIRST_RUN.md`** (la marca de "sin inicializar"). En un vault ya inicializado imprime lo contrario: **no corras `/onboarding` ni `personalize.sh`**, con el motivo, y redirige al **acuerdo de trabajo del equipo** más la configuración de la identidad de git con el correo **verificado**.
- El comando `/onboarding` ya tenía el guard correcto en su `[CUÁNDO CORRER]`, pero era **instrucción, no mecanismo**: `setup.sh` empujaba en la dirección opuesta. Ahora los dos dicen lo mismo.
- **`/onboarding` paso 2 (modo equipo) corregido y ampliado a tres tareas del dueño:** CODEOWNERS con **las dos personas en todas las rutas** cuando el equipo es de dos (GitHub no deja aprobar el propio PR, así que una ruta de dueño único se traba); **escribir el acuerdo en lenguaje llano** —que en plan Free *es* el control, con su regla de desempate—; y proteger `main` **con el aviso de que en Free + privado no se puede** y por lo tanto no es un pendiente accionable. Además el prefijo de rama pasó de `<inicial>` a **dos letras**.

## [1.9.2] — 2026-08-06
**El filtro de la 1.9.1 fallaba en Windows y se comía archivos de framework.**

- **Corregido: `git cat-file -e "$REMOTE/$BRANCH:$f"` es inseguro en Git Bash.** MSYS2 ve un argumento con dos puntos cuyas partes parecen rutas POSIX, lo toma por una **lista de rutas** y la traduce a formato Windows: `upstream/main:.claude/x.md` → `upstream\main;.claude\x.md`. `cat-file` devuelve `Not a valid object name` y el filtro de la 1.9.1 concluía "este archivo no está upstream, es tuyo".
- **El fallo era silencioso y asimétrico**, que es lo que lo hacía difícil de ver: MSYS **no** convierte argumentos con espacios, así que `00 Sistema/SOP Maestro.md` se clasificaba bien y `.claude/commands/cerebro-audit.md` no. En una instancia real quedaron fuera del update `.claude/agents/verifier.md` y los diez `.claude/commands/*.md` — archivos de framework que el updater declaraba "tuyos" y **dejaba de actualizar para siempre**, sin un solo mensaje de error.
- **La pertenencia pasa a resolverse con `git ls-tree -r --name-only` + `grep -Fxq`.** `ls-tree` recibe revisión y ruta como argumentos separados: sin dos puntos no hay nada que MSYS pueda convertir. De paso es **una** llamada a git en vez de una por archivo.
- **Nota para quien toque este script:** cualquier `<rev>:<ruta>` en una línea de comandos es sospechoso en Windows. Si hace falta, se desactiva con `MSYS_NO_PATHCONV=1`, pero es preferible la forma que no usa dos puntos.

## [1.9.1] — 2026-08-06
**`update.sh` deja de romperse cuando agregás un archivo propio a una carpeta de framework.**

- **Corregido: un archivo tuyo dentro de una ruta de `FRAMEWORK_PATHS` rompía el update.** Un SOP propio en `00 Sistema/`, una skill propia en `04 Knowledge/Skills/` — cualquier archivo que exista en tu vault y no en el upstream — aparece en `git diff HEAD upstream/main` (como borrado, en esa dirección) y el `git checkout upstream/main -- <ruta>` siguiente falla con `pathspec ... did not match any file(s) known to 'upstream/main'`. Ahora el diff se **filtra contra `git cat-file -e upstream/main:<ruta>`**: lo que no existe upstream no es framework, es tu contenido, y se informa aparte sin tocarlo. La whitelist listaba `00 Sistema` entera, así que a cualquier instancia le alcanzaba con escribir **un** SOP propio para pisar esto.
- **Dos síntomas que desaparecen:** (1) el archivo propio quedaba listado en **todos** los updates, así que `"Nada que actualizar."` dejaba de ser alcanzable aunque el framework estuviera al día; (2) si caía **último** en la lista, el `while` devolvía 1 y con `set -euo pipefail` el script **abortaba antes de `personalize.sh` y `team-mode.sh`** — update a medio aplicar y placeholders `{{ OWNER }}` sin resolver.
- **El loop de checkout dejó de correr en una subshell.** Era `echo "$CHANGED" | while …`; pasa a herestring (`done <<< "$CHANGED"`), que además permite juntar los fallos y reportarlos al final en vez de perderlos entre los `✓`. Un checkout que falle ya no puede abortar el script: se acumula en `FALLIDOS` y se lista.
- **El comentario de `FRAMEWORK_PATHS` sobre `.github/CODEOWNERS` se actualizó:** describía esta misma trampa, pero esquivada ruta por ruta. Ahora está resuelta de raíz; la lista explícita se mantiene porque listar solo lo que es framework sigue siendo lo correcto.

## [1.9.0] — 2026-07-28
**OKF v0.1 → v0.2.** El framework adopta la versión 0.2 del Open Knowledge Format.

- **Cambio breaking de OKF v0.2: `timestamp` → `generated: {by, at}`** en el frontmatter (101 notas del template migradas con `.claude/hooks/migrate-generated.py`, determinista e idempotente). `generated.at` hereda la semántica de `timestamp` (última edición de fondo); `generated.by` suma el actor. Las notas escritas a mano llevan `by: human:{{OWNER}}`; las de un agente, `process:<id>`.
- **`verify-commit.sh` triple-key:** acepta `generated`/`timestamp`/`ultima_revision` durante la transición. El campo de fecha obligatorio pasa a ser `generated`.
- **Convención de actor (SOP Documentación §4.7, nueva):** `human:<id>` · `process:<id>` · `<producer>/<version>`.
- **Añadido opt-in (documentado):** `verified` (eventos `{by, at}`), `stale_after`, y el tipo `Attested Computation`.
- **Alcance:** 14 plantillas, commands (incl. `onboarding`), SOP Documentación §4, nota OKF (§ Novedades de v0.2), `okf_version` "0.1"→"0.2" (generador + índice raíz), prosa de frescura en SOPs/skills. `migrate-okf.sh` encadena la migración v0.2 (paso 2b) para instancias que vengan de v0.1.

## [1.5.0] — 2026-07-23
**Las guardas dejan de ser un privilegio de Claude Code.** La v1.4.1 documentó el hueco; esta lo cierra donde se puede cerrar, y declara con precisión lo que queda abierto.

- **Añadido `.claude/hooks/sentinels-verify.py`** — equivalente **agnóstico** del guardián de centinelas. El guard `PreToolUse` solo protege a Claude Code; este corre en `git commit` (vía `.githooks/pre-commit`) y en el PR (`verify.yml`, **bloqueante**), así que cubre a cualquier agente y a cualquier humano. Toma los bloques `<!-- @user -->` de la versión anterior de cada `.md` que cambió y exige que sigan textuales; cubre también **el borrado del archivo** con contenido protegido adentro. Compara **blob contra blob**, nunca contra el working tree, así que CRLF/LF no puede producir falsos positivos. Escapes: `SENTINELS_OK=1` y el kill-switch `.vault-meta/sentinels.disabled`.
- **Añadido `.githooks/pre-push`** — equivalente agnóstico de la regla `FORCE_PUSH` de `security-guard`. Bloquea el push **no fast-forward**, que es lo que `--force` de verdad hace: detecta el **efecto**, no la bandera, así que tampoco pasa un `git push origin +main` (el guard viejo, que matchea el texto del comando, sí lo dejaba pasar). Avisa sin bloquear al borrar una rama remota. Escape: `ALLOW_FORCE_PUSH=1`. Como `core.hooksPath` apunta a la carpeta, queda activo en los clones existentes sin reconfigurar nada.
- **Corregido un bug real de regiones fantasma en `sentinels-guard.py`** (y evitado por diseño en el verificador nuevo). Los marcadores que viven dentro de código —bloques ``` y spans entre backticks— ahora se ignoran. Sin ese filtro, un marcador de apertura suelto en un ejemplo inline empareja con el primer cierre real que aparezca más abajo y crea una región "protegida" fantasma: en `Centinelas de Edición.md` abarcaba 24 líneas y **bloqueaba ediciones legítimas de su propia documentación**. Medido en los dos vaults: la corrección no pierde ninguna protección real (todos los marcadores existentes son ejemplos), solo elimina falsos positivos.
- **Aviso nuevo en `pre-commit` (no bloquea):** lista los archivos de control o de ley que toca el commit (`.claude/`, `.githooks/`, `.github/`, `.mcp.json`, `AGENTS.md`, `CLAUDE.md`, `llms.txt`). Un cambio ahí altera cómo se comporta todo agente del vault; se hace visible al commitear en vez de descubrirse en el diff.
- **Añadida a `AGENTS.md` la subsección "Si el vault tiene más de un dueño humano".** La ley describía el eje de los agentes pero no el de las personas: un agente que solo leía `AGENTS.md` firmaba como autor —justo lo que [SOP Multi-Agente](<SOP Multi-Agente.md>) §3.1 prohíbe en modo equipo. Ahora la ley dice las tres reglas que cambian: el autor del commit es la persona (el agente baja a trailer), la zona del agente es la **intersección** de su zona por tarea y la zona de su humano en `CODEOWNERS`, y al PR llega **una rama por persona, no una por agente**.
- **Declarado el hueco que queda:** la salida de red por shell y la lectura de archivos de credenciales **no son observables en un commit**, así que no tienen equivalente agnóstico. `AGENTS.md` ahora se lo dice explícitamente al agente y le asigna la obligación a cambio, en vez de dejar que asuma una red que no existe.
- **Corregido:** `vault-manifest.json` declaraba `1.4.0` mientras `VERSION` decía `1.4.1` — el manifiesto no se había bumpeado en la versión anterior.

## [1.4.1] — 2026-07-23
**La ley ahora le explica a un agente que no es Claude Code cómo aislarse.**
- **Añadida la sección "Trabajo en paralelo con otros agentes" a `AGENTS.md`:** worktree por agente (`git worktree add -b agent/<nombre> ../vault-<nombre>` — el `-b` no es opcional: sin él git aborta con `invalid reference` si la rama no existe), identidad propia por commit con `git -c` + trailer `Agent:`, y pausar el auto-sync de Obsidian. Remite a [SOP Multi-Agente](<SOP Multi-Agente.md>) §4 para el flujo completo.
- **El motivo:** los hooks declarados en `.claude/settings.json` (contexto de sesión, `security-guard`, centinelas de edición, bitácora automática) son específicos de Claude Code y **no corren** en Codex ni en ningún otro harness. Ese agente sí queda cubierto por el gate de `git commit` (`core.hooksPath=.githooks`), pero recién al final. `AGENTS.md` describía el sistema como si todos los agentes tuvieran esas guardas; ahora dice explícitamente que fuera de Claude Code se trabaja sin red hasta el commit, y qué obligaciones asume ese agente a cambio: quedarse en su zona, no tocar los archivos-ley, y registrar su handoff a mano.

## [1.4.0] — 2026-07-22
**Las actualizaciones del template dejan de depender de que alguien se acuerde.**
- **Añadido `.github/workflows/template-update.yml`:** cada lunes (y a demanda) compara tu `VERSION` con la del upstream y, si hay versión nueva, corre `update.sh --force` y **abre un PR** con los archivos de framework actualizados, listando qué cambió. Nada se mergea solo. Es el patrón cruft/copier: `./update.sh --check` ya existía, pero con un vault propio uno se olvida y con varios vaults de clientes no pasa nunca.
- **Tres decisiones de diseño del workflow:** (1) **se autodesactiva en el template mismo** —compara `origin` con `UPSTREAM_URL` normalizando `.git` y credenciales embebidas—, si no intentaría actualizarse contra sí mismo cada semana; (2) **reconstruye `owner.env` desde variables del repo**, porque está gitignoreado por ser identidad de la instancia y sin él `personalize.sh` no corre y el PR llegaría con `{{ OWNER }}` sin reemplazar — si falta la variable `OWNER` el workflow **falla con error explícito** en vez de abrir un PR malo; (3) **cero actions de terceros** (solo `actions/checkout` + el `gh` del runner): una action de terceros en un workflow con permiso de escritura es superficie de cadena de suministro. Los valores de las variables entran por `env:` y **no** interpolados con `${{ }}` dentro del `run:` — un `${{ }}` en un script se sustituye como texto antes de que corra el shell, así que un valor con comillas o `$(...)` se ejecutaría (hardening estándar de Actions).
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
- **Corregido:** último "Leandro" residual en `.claude/hooks/security-guard.py` (mensaje del guard → "el dueño del vault") · placeholders dobles `{{ OWNER }} {{ OWNER }}` en `Plantilla Skill` y `SOP Git y Flujo de Trabajo` (habrían rendido el nombre duplicado al personalizar).
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
- **Scrub:** los archivos sincronizados desde el vault maestro pasaron por re-scrub (nombre → `{{ OWNER }}`, email → `{{ OWNER_EMAIL }}`, negocios → Empresa A/B, rutas absolutas → genéricas); corregidas además 3 rutas absolutas preexistentes en `SOP Git y Flujo de Trabajo` que el scrub de v0.1.0 no había visto.
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
