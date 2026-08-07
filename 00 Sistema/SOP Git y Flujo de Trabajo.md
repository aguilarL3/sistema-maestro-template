---
type: How-to
title: "SOP Git y Flujo de Trabajo"
tags: [sop, git, infraestructura, workflow]
description: "Flujo operativo diario del vault con Git: comandos, convenciones, troubleshooting y §11 para vaults compartidos."
estado: 🟢 Activo
prioridad: 🔥 Alta
responsable: "{{OWNER}}"
id: "SOP-GIT-001"
generated:
  by: human:{{OWNER}}
  at: 2026-06-24T00:00:00Z
fecha_creacion: 2026-06-24
resource:
---

>[!info] Documentación relacionada
>el histórico de migración (no incluido en el template) (decisión arquitectónica) | [SOP Maestro](<SOP Maestro.md>) | [CLAUDE](<../CLAUDE.md>)

# SOP Git y Flujo de Trabajo

## Objetivo

Documentar el flujo operativo diario para trabajar con el vault sincronizado vía Git: comandos esenciales, convenciones, troubleshooting y reglas de oro.

> Para entender **por qué** elegimos Git, ver el histórico de migración (no incluido en el template). Este SOP se centra en **cómo** usarlo en el día a día.

---

## 1. Arquitectura actual (cheat-sheet)

```
                   GitHub (origin/main)
                   {{OWNER_GITHUB}}/sistema-maestro
                          ⇅  ⇅
              git push  / git pull
                          ⇅  ⇅
   ┌──────────────────────┴──┴────────────────────────┐
   │                                                  │
   PC                                              Móvil
   C:\Users\<usuario>\Vaults\sistema-maestro\          Obsidian Mobile
   Edición principal                               Edición esporádica
   Modo: manual                                    Modo: manual
   PowerShell + Obsidian Git plugin                Plugin Git
                                                   shallow clone (depth=1)

   PC → Google Drive (sección "Computadoras")
   Backup cold unidireccional
```

### 3 capas de backup
1. **GitHub** (sync primario, versionado completo).
2. **Drive "Computadoras"** (backup automático desde PC).
3. **Disco local PC** (copia viva siempre).

---

## 2. Comandos esenciales

### Desde el plugin Obsidian Git (uso diario)

| Comando del palette (`Ctrl + P`) | Qué hace | Cuándo usarlo |
|---|---|---|
| `Obsidian Git: Commit-and-sync with specific message` | Pide mensaje custom + commit + push + pull | **El que más vas a usar.** Después de editar notas. |
| `Obsidian Git: Commit-and-sync` | Commit + push + pull con mensaje automático | Cuando tenés apuro y no querés pensar el mensaje. |
| `Obsidian Git: Pull` | Solo trae cambios de GitHub | Cuando volvés a la PC tras editar en móvil. Si tenés Pull on startup activado, es automático al abrir Obsidian. |
| `Obsidian Git: Push` | Solo sube commits pendientes | Si hiciste commits manuales por terminal y olvidaste pushear. |
| `Obsidian Git: Commit all changes with specific message` | Commit con mensaje, sin push | Si querés agrupar varios commits antes de pushear. |
| `Obsidian Git: Open source control view` | Ve qué archivos cambiaron | Para revisar antes de commitear. |

### Desde PowerShell (cambios estructurales)

```powershell
cd C:\Users\<usuario>\Vaults\sistema-maestro

git status                          # ver qué cambió
git diff                            # ver el detalle de los cambios
git add .                           # stagear todo
git add "path/to/file.md"           # stagear archivo específico
git commit -m "feat: descripcion"   # commit con mensaje
git push                            # subir a GitHub
git pull                            # traer cambios remotos
git log --oneline -10               # ver últimos 10 commits
git log -p path/to/file.md          # ver histórico de un archivo
```

### Cuándo PowerShell vs Plugin

| Situación | Herramienta |
|---|---|
| Edición normal de 1-5 notas | Plugin: `Commit-and-sync with specific message` |
| Cambio estructural grande (carpetas nuevas, mover varios archivos) | PowerShell |
| Quiero ver diff antes de commitear | PowerShell: `git diff` |
| Resolver conflicto de merge | PowerShell (mejor visibilidad) |
| Pull rápido al abrir vault | Plugin (o automático con Pull on startup) |

---

## 3. Flujos típicos

### Flujo A — Sesión normal de edición en PC

1. Abrir Obsidian (si tenés `Pull on startup ON`, ya trae cambios del móvil).
2. Editar notas.
3. Al terminar la sesión: `Ctrl+P` → `Commit-and-sync with specific message`.
4. Escribir mensaje descriptivo (ej. `feat: agrego notas atómicas extraídas de clase 1.4`).
5. Enter. El plugin commitea + push + pull.

### Flujo B — Cambio estructural grande (reorganización, migración de archivos)

1. Hacer todos los cambios primero.
2. Abrir PowerShell en el vault.
3. `git status` para revisar qué cambió.
4. `git diff` para revisar el detalle si hay edits sutiles.
5. `git add .` + `git commit -m "refactor: motivo del cambio"`.
6. `git push`.
7. Si tenés celular con cambios pendientes: `git pull` después del push.

### Flujo C — Sincronizar tras editar en móvil

1. **En móvil**: terminar de editar → command palette → `Git: Commit-and-sync` (escribir mensaje).
2. **En PC**: abrir Obsidian.
3. Si `Pull on startup` está activo: los cambios aparecen automáticamente.
4. Si no: `Ctrl+P` → `Git: Pull` manual.
5. Continuar editando normal desde PC.

### Flujo D — Trabajar offline en móvil (sin internet)

1. Editar normalmente en Obsidian Mobile.
2. Cuando vuelva la conexión: `Git: Commit-and-sync`.
3. Si hay cambios remotos que mientras tanto se hicieron en PC, Git va a hacer merge automático (si no hay conflicto en los mismos archivos).
4. Si hay conflicto: ver sección [Troubleshooting](#5-troubleshooting).

---

## 4. Convención de mensajes de commit (Conventional Commits)

Adoptamos **Conventional Commits** — prefijos cortos que indican el tipo de cambio. Útil para que `git log` cuente la historia del vault de un vistazo.

| Prefijo | Cuándo usarlo | Ejemplo |
|---|---|---|
| `feat:` | Contenido nuevo (nota, MOC, prompt, apunte) | `feat: nueva clase 1.4 IA con Claude` |
| `fix:` | Corregir error, typo, link roto | `fix: link roto en MOC Aprendizaje` |
| `refactor:` | Reorganización sin cambio de contenido | `refactor: mover apuntes Power BI a Cursos/` |
| `docs:` | Cambios en SOPs, plantillas, README del sistema | `docs: actualizar SOP Prompts con sección v3.0` |
| `chore:` | Mantenimiento (gitignore, configs, limpieza) | `chore: limpiar stubs migracion 2026-06-24` |
| `style:` | Cambios cosméticos (formato, indentación) sin afectar contenido | `style: normalizar frontmatter de notas en Temas/` |

### Estructura recomendada del mensaje

```
<tipo>: <descripcion corta en imperativo>

[opcional: cuerpo explicando el por qué del cambio]

[opcional: footer con referencias o breaking changes]
```

**Ejemplos completos:**

```
feat: nueva clase 2.4 sobre DAX agregaciones

Cubre SUM, AVERAGE, COUNT con ejemplos en el dataset de ventas.
Extraídos 2 conceptos atómicos a Knowledge/Temas/: [[DAX]] y [[Funciones agregación]].

Ref: [[MOC - BI Analytics]]
```

```
refactor: migrar apuntes y prompts a 04 Knowledge

Aplicar SOP Cursos y Apuntes + SOP Prompts. Mover 6 archivos
desde 05 Diario a sus ubicaciones correctas.
```

---

## 5. Troubleshooting

### Problema: `Pull failed (merge): Your local changes would be overwritten`

**Causa:** modificaste un archivo localmente y ese mismo archivo cambió en GitHub.

**Diagnóstico:** mirá qué archivo es. Si es de config (`.obsidian/plugins/X/data.json`), conviene ignorarlo a futuro (ver [Reglas de oro](#6-reglas-de-oro)).

**Opciones de solución:**

```powershell
# Opción A — Descartar cambios locales, traer remoto
git checkout -- ruta/al/archivo
git pull

# Opción B — Preservar cambios locales, mergear con remoto
git add ruta/al/archivo
git commit -m "chore: preservar cambios locales"
git pull
# Si hay conflicto: editar manualmente los marcadores <<<<<<<

# Opción C — Stash + pull + pop (limpia, recomendada para casos generales)
git stash
git pull
git stash pop
```

### Problema: `Authentication failed` en móvil

**Causa:** token expirado o sin permisos.

**Solución:** generar nuevo Personal Access Token en https://github.com/settings/tokens (scope `repo`) y actualizar en Settings del plugin Git móvil.

### Problema: archivos no se ignoran a pesar de estar en `.gitignore`

**Causa A:** el archivo ya está trackeado (Git no untrackea solo por agregar al gitignore).

```powershell
git rm --cached ruta/al/archivo
git commit -m "chore: untrack archivo"
```

**Causa B:** `.gitignore` con encoding incorrecto (UTF-16 con BOM en lugar de UTF-8).

```powershell
# Reescribir en UTF-8 desde PowerShell
@"
.obsidian/workspace.json
.obsidian/workspace-mobile.json
.obsidian/plugins/obsidian-git/data.json
.trash/
"@ | Out-File -FilePath .gitignore -Encoding utf8 -NoNewline
```

### Problema: commit sin querer en branch equivocado

```powershell
git log --oneline -5              # ver el hash del commit
git reset --soft HEAD~1           # deshacer último commit, conservar cambios staged
# o
git reset --hard HEAD~1           # PELIGRO: deshacer commit + descartar cambios
```

### Problema: quiero ver qué cambió en una nota específica

```powershell
git log -p "ruta/a/la/nota.md"    # diff completo de cada commit que tocó el archivo
git log --oneline "ruta/a/la/nota.md"   # solo lista de commits
git blame "ruta/a/la/nota.md"     # ver línea por línea quién y cuándo escribió cada parte
```

### Problema: el plugin móvil dice "Git is not ready"

**Causa:** no hay repo Git inicializado en el vault.

**Solución:** ejecutar `Git: Clone an existing remote repository` desde el command palette.

---

## 6. Reglas de oro

### 6.1 Antes de hacer cambios grandes
**Siempre commit + push antes de migrar/reorganizar.** Es tu red de seguridad. Si algo sale mal, podés volver al estado anterior con `git reset --hard origin/main`.

### 6.2 Pull on startup es no negociable
Tanto en PC como en móvil. Sin esto, podés editar versiones desactualizadas y crear conflictos evitables.

### 6.3 Mensajes descriptivos > genéricos
Usá `Commit-and-sync with specific message` en lugar de `Commit-and-sync` simple. Tu yo de 6 meses te lo va a agradecer cuando esté revisando `git log`.

### 6.4 Archivos device-specific al `.gitignore`
Los `.obsidian/plugins/X/data.json` son config local de cada dispositivo. Deben ignorarse para evitar conflictos PC↔móvil. Cuando aparezca un plugin nuevo que dé problemas, aplicar el patrón:

```powershell
# Agregar al .gitignore manualmente, después:
git rm --cached .obsidian/plugins/X/data.json
git commit -m "chore: ignorar config del plugin X"
git push
```

### 6.5 No fuerces resoluciones de conflicto
Si Git aborta un merge, leé el mensaje antes de actuar. La diferencia entre `git checkout -- file` (descarta local) y `git pull` con conflict markers (preserva ambos) puede ser importante.

### 6.6 Nunca `git push --force` salvo emergencia
Sobreescribe el histórico remoto. Si trabajás en multi-device, puede borrar trabajo del otro dispositivo. Si tenés que forzar (por ejemplo después de un reset), usá `--force-with-lease` que es más seguro.

> Desde 2026-07-23 esto **lo aplica un hook**, no la buena memoria: `.githooks/pre-push` bloquea todo push **no fast-forward** (que es lo que `--force` de verdad hace). Detecta el efecto y no la bandera, así que tampoco pasa un `git push origin +main`. Si el force es deliberado: `ALLOW_FORCE_PUSH=1 git push --force-with-lease`. Corre en cualquier harness y también para vos — es el equivalente agnóstico de la regla que `security-guard` solo aplicaba dentro de Claude Code.

### 6.7 Cuando agregues credenciales o secrets
**No los commits.** Si por error commiteás un token o password:
1. Cambiarlo inmediatamente en el sistema de origen.
2. Limpiar histórico con `git filter-repo` o BFG (no solo `rm` — sigue en el histórico).
3. `git push --force` para reescribir GitHub.

### 6.8 Tag versiones importantes
Cuando hagas una reestructuración mayor del vault (como esta migración), creá un tag:

```powershell
git tag -a v2.0 -m "Migracion a Git + Disco Local"
git push origin v2.0
```

Después podés volver a ese estado con `git checkout v2.0`.

---

## 7. Setup mínimo para una máquina nueva (PC o portátil adicional)

Si en el futuro querés tener el vault en otra máquina:

```powershell
# 1. Instalar Git (https://git-scm.com)
# 2. Configurar identidad global
git config --global user.name "{{OWNER}}"
git config --global user.email "{{OWNER_EMAIL}}"

# 3. Clonar el repo en el path elegido
cd C:\Users\<usuario>\Vaults     # o donde quieras
git clone https://github.com/{{OWNER_GITHUB}}/sistema-maestro.git

# 4. Abrir Obsidian → "Open folder as vault" → seleccionar la carpeta clonada
# 5. Plugin Obsidian Git debería estar instalado (viene en .obsidian/)
# 6. Configurar credenciales del plugin: Username + Personal Access Token
# 7. Activar "Pull on startup"
# 8. Listo
```

> El primer commit desde la máquina nueva va a tener tu identidad global (paso 2). Por eso es importante configurarla bien.

---

## 8. Comandos útiles avanzados

### Ver estadísticas del vault
```powershell
git log --shortstat --since="1 month ago"   # commits del último mes con estadísticas
git shortlog -sn                            # commits por autor (en multi-user)
git log --pretty=format:"%h - %an, %ar : %s" | head -20   # log custom
```

### Buscar contenido en el histórico
```powershell
git log -S "texto a buscar"                 # commits que agregaron o quitaron ese texto
git log --all --oneline | grep "feat:"      # ver solo features
```

### Recuperar un archivo borrado
```powershell
git log --diff-filter=D --summary | grep delete    # ver archivos borrados en commits
git checkout COMMIT_HASH^ -- "ruta/al/archivo.md"  # recuperar versión previa
```

### Branch para experimentar sin afectar main
```powershell
git checkout -b experimento-X       # crear y cambiar a nueva branch
# ... hacer cambios ...
git commit -m "..."
# si te gusta:
git checkout main
git merge experimento-X
# si no te gusta:
git checkout main
git branch -D experimento-X
```

---

## 9. Cuándo NO usar Git directamente

- **Para edición rápida de una nota:** mejor el plugin desde Obsidian. PowerShell es overkill.
- **Para ver una nota del histórico de hace 6 meses:** usá la interfaz de GitHub web — es más visual.
- **Cuando estás aprendiendo:** evitá `git rebase`, `git reset --hard`, `git push --force` hasta que entiendas qué hacen. Pueden destruir trabajo.

---

## 10. Recursos externos

- Pro Git book (gratis, oficial): https://git-scm.com/book
- Conventional Commits spec: https://www.conventionalcommits.org/
- Obsidian Git plugin docs: https://publish.obsidian.md/git-doc
- Atlassian Git tutorials: https://www.atlassian.com/git/tutorials

---

## 11. Vault compartido (varias personas)

> **Aplica solo si el vault tiene más de un dueño humano** — un equipo, un estudio, una organización. En un vault personal saltate esta sección entera: §1-§10 alcanzan.
>
> No confundir con [SOP Multi-Agente](<SOP Multi-Agente.md>), que resuelve **varios agentes, un dueño, una máquina** (worktrees). Acá el eje es otro: **varias personas, varias máquinas, varias cuentas**. Los dos ejes se combinan sin problema — cada persona puede correr sus propios agentes en worktrees dentro de su clon.

En los ejemplos: **Persona A** (lead), **Persona B**, **Persona C**; la empresa es `<organización>`.

### 11.1 El modelo: un repo por organización, un clon por persona

```
        GitHub — <organización>/vault   (main protegido)
                        ▲
        ┌───────────────┼───────────────┐
     clon A          clon B          clon C
   Persona A       Persona B       Persona C
   rama: a/<tema>  rama: b/<tema>  rama: c/<tema>
        │               │               │
   (worktrees de sus agentes, si los usa)
```

El aislamiento entre personas **es el clon**; el worktree sigue siendo el aislamiento entre agentes de una misma persona.

**Un repo por organización.** No metas varias organizaciones en un repo separándolas por ramas: un merge distraído filtra datos de una en otra, y los permisos de GitHub son por repo, no por rama. Repos separados = aislamiento real + control de acceso real.

### 11.2 Reglas del flujo

| Regla | Por qué |
|---|---|
| Nadie commitea directo a `main` | `main` es el vault que todos abren en Obsidian; tiene que estar siempre sano |
| Rama por persona + tema: `b/moc-clientes` | trazable y acotada |
| Ramas cortas — se abren y cierran el mismo día | el markdown en prosa mergea mal; cuanto menos vive la rama, menos diverge |
| PR → revisión → squash merge | la revisión de markdown cuesta minutos y evita drift estructural |
| `git pull` al abrir sesión, PR al cerrarla | ritual fijo; sin esto se edita sobre versiones viejas |
| Integrar de a una y **rebasear las ramas restantes** sobre el `main` nuevo | evita el conflicto tardío en cascada |

**Configuración en GitHub** (Settings → Rules, sobre `main`):

- Require a pull request before merging
- Require review from Code Owners → ver `.github/CODEOWNERS.example`
- Require status checks to pass → el workflow de verificación
- Block force pushes

> ⚠️ **Al editar `CODEOWNERS`: escapá los espacios de las rutas.** Las carpetas de este vault los tienen (`00 Sistema`), y CODEOWNERS parte cada línea por whitespace — lo primero es la ruta, lo demás son **dueños**. Sin escapar, `/00 Sistema/ @persona-a` se lee como ruta `/00` con dueño `Sistema/`: la regla no protege nada y falla en silencio. Se escribe `/00\ Sistema/`. Es la misma clase de trampa que en `.gitattributes`, con otra sintaxis (allá no hay escape y se usa el comodín `?`).

### 11.3 Regla del escritor único sobre los hotspots

El modo de falla dominante cuando varios actores trabajan en paralelo no son las notas: son los **archivos que casi toda tarea toca**. En este vault:

```
index.md · llms.txt · 01 Index/** · 02 MOCs/** · Dashboard-*.md · SOPS.md
```

Sobre esos archivos **no se paraleliza: se serializa**. Los edita el lead, o los edita una persona por vez. Es la regla que más conflictos evita por unidad de esfuerzo.

### 11.4 Registro personal: una carpeta por persona

```
05 Diario/
├── Persona A/
├── Persona B/
├── Persona C/
└── Bitácora Agentes/     ← compartida, append-only (merge=union)
```

El diario es el archivo más editado y el menos compartido: separarlo por persona elimina de raíz el grueso de los conflictos. La bitácora de agentes sí es común —es el handoff del sistema— y por eso está cubierta por `merge=union` en `.gitattributes`.

> ⚠️ **El hook de sesión inyecta la ÚLTIMA entrada de la bitácora.** Con varias personas trabajando en paralelo eso deja de ser un handoff coherente: la última entrada puede ser de otra persona en otro tema. En modo equipo, leé el handoff como *contexto del vault*, no como *continuación de tu trabajo*.

### 11.5 El gate corre también en el servidor

Los hooks de `.githooks/` (secret-scan, verifier de frontmatter) corren en el clon de cada persona, y solo si esa persona corrió `setup.sh`. **En un vault compartido eso no es una garantía, es una esperanza.**

Por eso el mismo verificador corre como status check del PR: **`.github/workflows/verify.yml`**. No es un chequeo paralelo que pueda divergir — invoca **los mismos scripts** de `.claude/hooks/`, en modo rango:

```bash
bash    .claude/hooks/secret-scan.sh      --range <base> <head>
python3 .claude/hooks/sentinels-verify.py --range <base> <head>
bash    .claude/hooks/verify-commit.sh    --range <base> <head>
```

(En un PR no hay nada staged; el modo `--range` selecciona lo que cambió entre la base y la cabeza en lugar del índice. Las reglas son idénticas en los dos modos.)

| Chequeo | En el PR | Por qué |
|---|---|---|
| **secret-scan** | 🔴 bloquea | Un secreto que llegó a una rama publicada **ya se filtró**. Rotarlo primero, limpiar el historial después. |
| **sentinels-verify** | 🔴 bloquea | Los bloques `<!-- @user -->` son propiedad humana. Que un PR los altere no se negocia, y en modo equipo el dueño del bloque puede no ser quien revisa. |
| **verify-commit** (frontmatter) | ⚠️ avisa | El sistema normaliza el frontmatter **al tocar**, no retroactivamente. Para bloquear: `VERIFIER_STRICT: "1"` en el workflow. |
| **check-links** | ℹ️ informa | Los rotos incluyen promesas `[[wikilink]]` intencionales; bloquear sería ruido. |
| **índices generados** | ℹ️ informa | Si regenerar da diff ≠ 0, alguien commiteó sin el hook. |

Con `main` protegido y "Require status checks to pass", un clon mal configurado deja de poder mergear.

> [!warning] Eso **requiere plan de pago** si el repo es privado
> "Require status checks to pass" es una regla de protección de rama, y en el plan **Free** de GitHub las reglas de rama **no existen en repos privados** (§12.1). Sin ellas el workflow sigue corriendo y sigue pintando el check, pero **es una señal, no un bloqueo**: un PR en rojo se puede mergear igual. En Free, el único control real es que cada persona haya corrido `setup.sh` en su clon.

### 11.6 Alternativa: edición simultánea real (CRDT)

Existen plugins de Obsidian para co-edición en tiempo real (Relay, Peerdraft, Team Relay — todos sobre CRDT/Yjs), con un modelo de *compartir carpetas, no vaults*: lo compartido se sincroniza y lo personal queda privado. Resuelven lo único que git no resuelve — dos personas en el mismo párrafo a la vez.

**Cuándo considerarlos:** equipo no técnico que no va a abrir una terminal nunca.

**Por qué no reemplazan a git acá:** sin commit no hay pre-commit hook, ni verifier, ni secret-scan, ni historial revisable. Este sistema está construido sobre el gate del commit. Si se adoptan, que sea **encima** de git, no en lugar de git.

---

## 12. Cuentas, organizaciones e identidad en GitHub

> §11 resuelve *cómo* trabajan varias personas sobre un repo. Esta sección resuelve la capa de abajo: **de quién es la cuenta, de quién es el repo y quién firma cada commit** — lo que hay que decidir antes de invitar a la primera persona.

### 12.1 Una cuenta personal, una Organization por negocio

**Regla:** una sola cuenta de GitHub + una **Organization** por negocio. Nunca una cuenta de GitHub "del negocio".

El malentendido que esto evita: **una organización no tiene login.** No existe "entrar como la empresa". Una org es un contenedor de repos y permisos, y siempre la administran cuentas de usuario con rol de owner. Crear "la cuenta de la empresa" significa en realidad crear una segunda cuenta personal, y eso trae tres costos sin beneficio:

- Hay que desloguearse y loguearse para administrar, con su propio 2FA.
- **Las contribuciones se parten en dos** y ningún perfil cuenta la historia completa — lo contrario de lo que busca el Career OS.
- GitHub desaconseja múltiples cuentas personales en su ToS; las orgs existen para no necesitarlas.

> **Quién creó la org no determina de quién es.** Owner es un *rol transferible*, no una marca de nacimiento. La org tiene identidad propia (nombre, logo, correo de contacto, dominio) independiente de tu cuenta. Si mañana entra un socio, lo hacés owner; si vendés el negocio, transferís la org: el repo no se mueve, las URLs no cambian, nadie reclona.

**Orden correcto de creación** (importa: transferir después arrastra issues, PRs y URLs redirigidas):

| # | Paso |
|---|---|
| 1 | Crear la Organization desde la cuenta personal (Settings → Organizations → New). El plan Free alcanza para **repos privados y colaboradores ilimitados** — pero **no** para proteger ramas: ver el aviso de abajo |
| 2 | Crear el repo **dentro** de la org (desplegable *owner* del formulario), no en el perfil personal |
| 3 | Invitar socios como **Member**; owners solo 2 (ver 12.2) |
| 4 | Cada persona **clona** (no forkea, ver 12.3) |
| 5 | Trabajar con rama + PR → §11. **Proteger `main` en el servidor exige plan de pago si el repo es privado** — ver el aviso |
| 6 | Correo de contacto de la org: una casilla del negocio, no el correo personal |

> [!warning] 🔴 El plan Free **no protege ramas en repos privados**
> Medido contra la API el **2026-08-06**, en una organización en plan Free con repos privados: tanto *branch protection* como *rulesets* devuelven **403 · "Upgrade to GitHub Pro or make this repository public"**. No es un permiso mal puesto ni un ajuste escondido: la función no está en el plan.
>
> | Pieza del diseño de §11 | ¿Funciona en Free + privado? |
> |---|---|
> | Rama por persona + PR + squash merge | ✅ sí — es convención, se hace igual |
> | `verify.yml` corriendo en el PR | ✅ sí — Actions corre en repos privados, con cuota mensual de minutos |
> | **Require a pull request before merging** | ❌ no |
> | **Require review from Code Owners** (auto-asignación por CODEOWNERS) | ❌ no |
> | **Require status checks** / **Block force pushes** | ❌ no |
> | Gate local (`pre-commit`, modo equipo) | ✅ sí — pero es local, y `--no-verify` lo saltea |
>
> **La consecuencia práctica: el control se muda a la máquina de cada persona.** Sin capa de servidor, **`setup.sh` en el clon de cada quien es el único control que existe** — si alguien no lo corre, no tiene hooks y no lo frena nada. Eso convierte a `setup.sh` de higiene en el paso crítico del onboarding: **verificalo explícitamente** (`git config core.hooksPath` debe responder `.githooks`), no lo des por hecho.
>
> Y como el resto pasa a ser convención, **hace falta un acuerdo escrito en lenguaje llano** que la gente lea de verdad — no un SOP técnico. Ese documento *es* el control. Ver §11.2 y el ejemplo `00 Sistema/Cómo trabajamos en este vault.md` que instala `team-mode.sh`.
>
> **Las tres salidas, si el control por convención no alcanza:** pasar la org a **GitHub Team** (precio por usuario/mes, verificar el vigente), hacer el repo **público** (rara vez viable en un vault), o aceptar la convención a conciencia. La tercera es una decisión legítima con dos personas que se hablan; con más gente deja de serlo — *con una persona es disciplina, con varias es estadística*.

**Un repo por organización**, ya fijado en §11.1. La org agrega la capa de arriba: varios repos del mismo negocio bajo una identidad, con permisos y facturación comunes.

### 12.2 Owners: dos, no todos — y qué hacer si estás solo

Un owner puede **borrar la organización entera**. "Nos damos todos owner" suena a igualdad entre socios y es un riesgo operativo real.

- **Con socios:** 2 owners (vos + el socio principal), el resto Members con escritura en el repo que les toca.
- **Sin socios:** vos como único owner, y **no** inventes una segunda cuenta para acompañarte.

Por qué una segunda cuenta propia no protege: comparte tus puntos de falla — mismo correo, mismo teléfono con el 2FA, mismo gestor de contraseñas. Se caen juntas. Eso es **falla correlacionada**: dos copias que se caen a la vez no son dos copias. La redundancia solo cuenta si es independiente, y para eso haría falta otra persona real.

> **Con un socio al 50%, la salvedad se asume en vez de esquivarse.** Hacerlo owner es lo coherente con la sociedad, y el riesgo irreversible es uno solo: puede borrar la org. Mitigación real y suficiente: **cada clon local es un backup completo del historial**. Lo que se perdería es el acceso, la URL y los issues — no el trabajo. Además, en plan Free (§12.1) un permiso recortado no protegería nada: sin reglas de rama, "Member con escritura" y "Owner" pueden hacer exactamente el mismo daño en `main`.

**Continuidad real para un dueño solo** (ordenado por retorno):

| Medida | Contra qué |
|---|---|
| **El clon local ya es backup completo** — git es distribuido: el `.git` del disco tiene *todo* el historial | GitHub caído, cuenta bloqueada, org borrada por accidente. Lo que está en riesgo es el acceso, la URL y los issues; el trabajo no |
| Códigos de recuperación de 2FA guardados fuera del teléfono | El 90% de las pérdidas de acceso reales: cambiar de celular sin migrar el autenticador |
| Acceso de emergencia del gestor de contraseñas a un familiar | "Si me pasa algo" — sin dar acceso hoy, y cubre todo, no solo GitHub |
| Una copia del clon fuera de casa (disco externo u otra nube) | Incendio, robo, ransomware — más probables que los escenarios extremos |

> GitHub tiene además un procedimiento para que familiares directos soliciten acceso a la cuenta de una persona fallecida, con documentación. **Verificar el detalle en su documentación si el punto importa** — no está confirmado acá.

**¿Crear la org aunque estés solo? Sí.** Es gratis, no agrega mantenimiento (administrás desde tu cuenta de siempre), y deja la estructura lista para el día que entre un socio o un freelance. Además separa la identidad: `github.com/<negocio>/…` se lee como negocio; `github.com/{{OWNER_GITHUB}}/<negocio>-cosas` se lee como proyecto personal — y eso importa para el objetivo de evidencia profesional.

### 12.3 Clonar, no forkear

**Fork es para cuando NO tenés permiso de escritura** — el modelo del open source: alguien externo copia el repo bajo su cuenta y manda PRs desde ahí.

Siendo miembro de la org con escritura, forkear es trabajo extra puro: habría que sincronizar el fork con el original constantemente y los PRs cruzarían de repo a repo sin necesidad. El modelo correcto es **shared repository**: todos clonan el mismo repo, cada uno en su rama (§11.2).

```bash
git clone https://github.com/<org>/vault.git
cd vault
bash ./setup.sh                      # ← sin esto no tenés hooks (§12.1)
git switch -c <vos>/moc-clientes
git push -u origin <vos>/moc-clientes    # → PR → revisión → squash merge
```

> ⚠️ **Dos clones del mismo negocio van en carpetas HERMANAS, nunca anidadas** — ver 12.5, riesgo 1. Y si el vault tiene un repo de código además del vault, lo mismo: hermanos.

Trabajar desde **dos máquinas propias** es el mismo mecanismo: clonás en ambas, el remoto es la fuente de verdad, `git pull` al abrir sesión (§6.2). No hay fork ni configuración especial.

> **Si el repo se creó con "Use this template"** (el camino de instalación de este template), la instancia **no tiene ancestro común** con el repo del que salió: `git merge-base` devuelve vacío y `git merge upstream/main` no sirve para actualizarse. Para eso está `update.sh`, que trae los archivos de framework por whitelist. No intentes mergear el upstream a mano.

### 12.4 Correo verificado — la condición que no se puede saltear

Un commit graba tu nombre y correo **como texto plano**, tomados de `git config user.email`. Git no los valida contra nada. GitHub, al recibir el push, busca ese string entre los correos **registrados y confirmados** de las cuentas existentes:

- **Coincide** → el commit muestra tu foto, linkea a tu perfil y **cuenta en tu contribution graph**.
- **No coincide** → nombre en gris, sin avatar, sin link, no cuenta para nada. Y arreglarlo después exige **reescribir el historial**, que en un repo compartido es un dolor serio.

> 🔴 **Por eso esto va ANTES del primer commit de cada persona nueva, no después.** Es el único paso del onboarding cuyo arreglo tardío es caro: reescribir historial ya compartido obliga a que todo el mundo reclone o resetee.

Cómo verificarlo: **Settings → Emails → Add email address** → click en el link del mail. Se pueden tener **varios correos verificados en la misma cuenta**: es exactamente lo que permite commitear con el correo del negocio en un repo y con el personal en otro **sin perder atribución en ninguno**.

```bash
git config user.email          # con qué correo estoy commiteando
git log -1 --format='%ae'      # qué correo quedó en el último commit
```

> ⚠️ **Ese correo queda visible en el historial de todo repo público.** Para repos de portfolio, usar el correo `noreply` que GitHub ofrece en esa misma pantalla (`NNNNNN+usuario@users.noreply.github.com`): sirve igual para la atribución y no expone la dirección real.

**No confundir con el badge verde "Verified"** de los commits: eso es firma criptográfica (GPG/SSH) y prueba que el commit lo hizo alguien con tu clave privada — porque como el correo es texto plano, *cualquiera puede commitear diciendo que es vos*. Son mecanismos independientes. No es necesario al arrancar.

### 12.5 Identidad por proyecto en la máquina

`git config user.email` **local** (sin `--global`) vive en el `.git/config` del repo y pisa la identidad global solo ahí. Para no depender de acordarse, `includeIf` en el `.gitconfig` global aplica una identidad a todo repo bajo una ruta:

```
[includeIf "gitdir:C:/Users/<usuario>/Negocios/"]
    path = ~/.gitconfig-negocios
```

**Esto condiciona dónde van las carpetas en disco.** Si se quiere identidad por negocio, los repos de negocio tienen que agruparse bajo una carpeta común (`Negocios\`); si da igual, van todos como hermanos.

```
C:\Users\<usuario>\Vaults\
├─ vault-personal\       ← .git propio
├─ <negocio-a>\          ← .git propio
└─ <negocio-b>\          ← .git propio
```

Dos riesgos, y el segundo es el grave:

1. **Nunca anidar** un vault dentro de otro (`vault-personal\<negocio>\`): el repo de arriba se traga al de abajo. Carpetas hermanas no se pisan — un repo solo ve desde su `.git` hacia abajo.
2. **Nunca copiar la carpeta de otro vault con el `.git` adentro** "como backup" o "para pasársela a alguien": se hereda el historial completo del vault de origen dentro del repo nuevo, que es justo lo que la frontera personal↔negocio viene a impedir. Se **clona** del remoto, siempre; y si hay que partir de contenido, se copia el **contenido** y se hace `git init` limpio.

Lo que git **sí** aísla por repo: remote, ramas e identidad. Un `git push` en un negocio no puede llegar al vault personal. Lo que **no** aísla y sí molesta con cuentas múltiples: el gestor de credenciales del sistema guarda un token **por host** (`github.com`) — otro argumento para la regla de una sola cuenta (12.1).

> **`gh` necesita su propio ajuste cuando hay dos remotos.** Un clon con `origin` (tu repo) y `upstream` (el template) deja a `gh pr create` sin saber a cuál apuntar, y suele elegir mal — abre el PR contra el template. Se fija una vez por clon: `gh repo set-default <org>/<repo>`. `setup.sh` ya lo hace; verificalo si el PR sale raro.

### 12.6 Demostrar el aporte (CV y LinkedIn)

Acá se pagan las decisiones de arriba. Cuatro capas, de menos a más útil:

| Capa | Qué muestra | Cómo |
|---|---|---|
| Contribution graph | Que trabajaste, no qué hiciste | Settings → Profile → *Include private contributions on my profile*. **Requiere 12.4**: sin correo verificado no hay nada que mostrar |
| Membresía pública de la org | Que sos parte del negocio, sin exponer código | Organization → People → membresía en *Public* |
| **Un repo público extraído** | El trabajo real, legible por un reclutador | Publicar la parte no sensible (un pipeline, un script de automatización, el propio template) sin datos ni credenciales |
| CHANGELOG + bitácora del repo | Registro fechado que respalda la métrica del CV | Ya lo genera el template |

La tercera es la que casi nadie hace y la más valiosa: un reclutador **no puede** leer tu repo privado. Es evidencia, no declaración.

LinkedIn no se sincroniza con GitHub: la org va en **Experiencia** como empresa, y el link al repo público o a la org en **Proyectos**.

> ⚠️ **Tema no técnico que muerde:** con socios, definir desde el día uno **de quién es el código** y si podés seguir mostrándolo en el portfolio después de irte. La org resuelve la propiedad técnica (transferir, agregar, sacar gente); no resuelve la legal. Evidencia que no podés mostrar no sirve.

---

## Referencias

- el histórico de migración (no incluido en el template)
- [SOP Maestro](<SOP Maestro.md>)
- [CLAUDE](<../CLAUDE.md>)
- [SOP Cursos y Apuntes](<SOP Cursos y Apuntes.md>)
- [SOP Prompts](<SOP Prompts.md>)
