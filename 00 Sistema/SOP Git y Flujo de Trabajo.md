---
type: How-to
title: "SOP Git y Flujo de Trabajo"
tags: [sop, git, infraestructura, workflow]
estado: 🟢 Activo
prioridad: 🔥 Alta
responsable: "{{OWNER}}"
id: "SOP-GIT-001"
timestamp: 2026-06-24T00:00:00Z
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

## Referencias

- el histórico de migración (no incluido en el template)
- [SOP Maestro](<SOP Maestro.md>)
- [CLAUDE](<../CLAUDE.md>)
- [SOP Cursos y Apuntes](<SOP Cursos y Apuntes.md>)
- [SOP Prompts](<SOP Prompts.md>)
