---
type: How-to
title: "Cómo trabajamos en este vault"
description: "Acuerdo de trabajo compartido: el ritual de cada sesión, las zonas de cada persona y las reglas al trabajar con agentes. En plan Free de GitHub, este documento es el control."
tags: [equipo, git, multiagente, onboarding, convivencia]
estado: 🟢 Activo
prioridad: 🔥 Alta
responsable: "{{OWNER}}"
id: "HOW-EQUIPO-001"
generated:
  by: human:{{OWNER}}
  at: 2026-08-07T00:00:00Z
fecha_creacion: 2026-08-07
resource:
---

>[!info] Documentación relacionada
>[SOP Git y Flujo de Trabajo](<SOP Git y Flujo de Trabajo.md>) §11 (el detalle técnico) | [SOP Multi-Agente](<SOP Multi-Agente.md>) §5 (varias personas con varios agentes) | [SOP de Seguridad](<SOP de Seguridad.md>)

> [!note] PLANTILLA — completala y renombrala a `Cómo trabajamos en este vault.md`
> `team-mode.sh` la copia sola la primera vez que activás el modo equipo. Después:
> **reemplazá los `<...>`, borrá lo que no aplique y borrá este bloque.**
>
> **Por qué existe y no alcanza con `AGENTS.md`:** `AGENTS.md` lo leen los agentes; esto lo lee una **persona**, en diez minutos, antes de su primer cambio. Y si el repo está en el plan **Free** de GitHub —donde no hay reglas de rama— **este documento es el control**, no un complemento. Escribilo en lenguaje llano: si hace falta saber git para entenderlo, no sirve.
>
> El archivo `.example` sigue viviendo al lado (viaja con el framework). Ignoralo: el que se lee es el que no dice `.example`.

# Cómo trabajamos en este vault

Este vault es de **`<organización>`** y lo usamos más de una persona, cada una desde su computadora y con su propio agente de IA.

Leé esto una vez antes de empezar. Son diez minutos y evitan el 90% de los problemas.

> [!important] Por qué esto importa más de lo que parece
> *(Ajustá según el plan de GitHub del repo.)*
>
> Con el plan **gratuito** y repositorios privados, GitHub **no puede bloquear nada**: no impide que alguien escriba directo en la rama principal, ni exige que otra persona revise antes de publicar. Las reglas de rama no están disponibles (`403 · "Upgrade to GitHub Pro or make this repository public"`).
>
> O sea: **este documento no es una recomendación, es el control.** Lo único que además funciona son las verificaciones instaladas en tu computadora — y para tenerlas hay que hacer el paso 1.
>
> Con plan **de pago** (o repo público) y las reglas activadas, GitHub además exige PR, revisión y checks en verde. Ahí esto es un resumen, no el control.

## 1. Una sola vez, al principio

Después de clonar el vault, parate dentro de la carpeta y corré:

```bash
bash ./setup.sh
```

Esto instala las verificaciones automáticas locales: te frena si estás por publicar una contraseña, si el formato de una nota está mal, y **si estás commiteando en la rama principal**.

**Si no lo corrés, no tenés ninguna red de seguridad.** No es un paso opcional de instalación: es el único freno automático que existe. Para confirmar que quedó:

```bash
git config core.hooksPath      # tiene que responder: .githooks
```

Configurá también tu identidad, con el mismo correo que verificaste en GitHub:

```bash
git config user.email <tu-correo>
git log -1 --format='%ae'      # confirmá qué correo quedó
```

> Si tu correo no está **verificado** en GitHub (Settings → Emails → click en el link del mail), tus cambios aparecen sin tu nombre y sin tu foto, y corregirlo después obliga a reescribir historial ya compartido. Hacelo **antes** del primer cambio, no después.

> ⚠️ **Si el proyecto tiene vault *y* repo de código**, van en carpetas **hermanas, nunca anidadas**: un repo dentro de otro se lo traga el de arriba.

> ⚠️ **Si te sumás a un vault que ya tiene dueño, NO corras `/onboarding` ni `personalize.sh`.** Piden tu identidad y re-personalizan el vault entero con tu nombre, mezclando dos identidades. Tu paso siguiente es leer este documento, no inicializar nada.

## 2. El ritual de cada sesión

Son tres momentos, siempre iguales:

| Cuándo | Qué hacés |
|---|---|
| **Al abrir** | `git pull` — traés lo que hicieron los demás. Sin esto trabajás sobre una versión vieja |
| **Antes de tocar nada** | `git switch -c <vos>/tema` — te movés a **tu rama** |
| **Al cerrar** | Publicás tu rama y abrís un **PR**. Según qué tocaste, lo mergeás vos o esperás review — ver §5 |

**Tu prefijo de rama** — dos letras, no la inicial: en cuanto dos personas comparten inicial, la inicial sola es ambigua. Fijalo por escrito **antes del primer PR**.

| Persona | Prefijo | Ejemplo |
|---|---|---|
| `<Nombre Apellido>` | `<xx>/` | `<xx>/moc-clientes` |
| `<Nombre Apellido>` | `<yy>/` | `<yy>/fotos-productos` |

```bash
git pull
git switch -c <xx>/mi-tema
git push -u origin <xx>/mi-tema
gh pr create --reviewer <la-otra-persona>    # o desde la web de GitHub
```

> [!important] Pedí el review explícitamente. **No pasa solo.**
> Ese `--reviewer` no es opcional ni cosmético: **si no lo ponés, la otra persona no se entera de que abriste el PR.**
>
> Se suele creer que `.github/CODEOWNERS` asigna revisor automáticamente. **Es falso en repos privados con plan Free** (verificado 2026-08-07: PRs con el archivo completo y todas las personas listadas quedaron sin ningún revisor pedido). Ahí ese archivo vale como **mapa documentado** de quién revisa qué, no como mecanismo.
>
> Con `--reviewer`, el PR aparece en su lista de *«te pidieron review»* — en GitHub, en `gh pr status` y en la barra lateral del editor. Desde la web es el mismo clic, en *Reviewers*.
>
> **Dos redes más, para no depender de que nadie se acuerde:**
> - **Seguí los repos** en GitHub (botón *Watch* → *All Activity*): te llega un mail con cada PR nuevo. Con **GitHub Mobile**, también al teléfono.
> - Al abrir el agente en el vault, un aviso automático te dice **qué PRs esperan tu review** (hook `pr-notice.sh`). Y con `/revisar-pr <número>` el agente te lo explica en lenguaje del vault antes de que lo leas.

### ¿Y si el PR está esperando y querés seguir con otra cosa?

**Podés, y es lo normal.** No hay que esperar la aprobación para empezar lo siguiente. Lo único que importa es **desde dónde creás la rama nueva**.

> [!danger] La trampa que hace que un PR "traiga cosas de más"
> Si terminás `<xx>/boton`, abrís el PR, y **estando parada en esa rama** hacés `git switch -c <xx>/footer`, la rama nueva **se lleva todos los commits del botón**. Tu PR del footer va a mostrar el botón también, quien revisa ve cambios que ya miró, y al mergear queda un enredo.

**La regla: toda rama nueva sale de la rama principal actualizada.**

```bash
git switch main               # volvés al tronco
git pull                      # traés lo que se mergeó mientras tanto
git switch -c <xx>/footer     # ahora sí, rama limpia
```

**Si te piden cambios en el PR anterior mientras estás en otra cosa**, no abrís un PR nuevo: volvés, corregís y pusheás — el PR se actualiza solo.

```bash
git switch <xx>/boton
# … corregís …
git add -A && git commit -m "fix(boton): lo que pidió el review"
git push
git switch <xx>/footer        # y volvés a lo que estabas
```

> Si tenés cambios sin commitear al cambiar de rama, git te frena. Commiteá antes, o `git stash` y `git stash pop` al volver.

**Dos o tres ramas abiertas a la vez, no más.** No es un límite técnico: cuanto más viven, más se alejan de la principal y peor mezclan — sobre todo en prosa, que es lo que peor mergea. **Y si se apilan cuatro o cinco esperando review, el problema no es cómo trabaja quien las abre: es que quien revisa está tardando.** Conviene decirlo, porque en un equipo chico el tiempo de review es el cuello de botella.

## 3. Nunca escribas directo en la rama principal

La rama principal es la versión que todos abren en Obsidian. Tiene que estar siempre sana, así que **todo entra por PR**.

> [!warning] Esto te va a pasar y no es un error
> Si intentás commitear sobre la rama principal, **el commit se rechaza** con un mensaje que te dice exactamente qué hacer. No se rompió nada: te falta crear tu rama.
>
> Se arregla en un segundo: `git switch -c <vos>/tema` y volvés a commitear.
>
> Con Claude Code vas a notar además que el guardado automático **se abstiene** mientras estés ahí, así que tu cambio queda sin registrar. Es la misma regla vista desde el otro lado.

> [!important] Ese freno vive en TU computadora, no en GitHub
> El freno es el `pre-commit` que instala `setup.sh`, y **solo existe si corriste el paso 1**. Dos consecuencias:
> - Si alguien clona y **no** corre `setup.sh`, no tiene ningún freno. Por eso ese paso no es higiene, es *el* paso.
> - `git commit --no-verify` lo saltea. No lo uses; si creés que lo necesitás, avisá primero — casi siempre significa que hay otro problema.

## 4. Quién escribe dónde

*(Ajustá esta sección al reparto real. Lo de abajo es el caso más común: permisos completos, una sola separación.)*

**Podés escribir en todo el vault.** No hay carpetas prohibidas ni permisos recortados.

La única separación real es el diario:

| Carpeta | Regla |
|---|---|
| `05 Diario/<tu nombre>/` | **Tuya.** Nadie más escribe ahí |
| Todo el resto | **Compartido.** Todas las personas escriben |

El diario se separa porque es el archivo que más se edita y el que menos se comparte — juntarlo garantiza choques sin ganar nada.

> **Permisos ≠ zonas.** Los permisos responden *"¿tiene derecho?"*. Las zonas responden *"¿quién escribe este archivo hoy?"* — y eso no es desconfianza: es que **git no mezcla dos ediciones del mismo párrafo en prosa**.

### Dos avisos que no son de permiso, son de coordinación

Git **no sabe mezclar dos ediciones del mismo párrafo** en un texto en prosa. La defensa no es técnica, es no editar lo mismo al mismo tiempo. De ahí estas dos costumbres:

- **`01 Index/` y `02 MOCs/`** son las páginas de navegación: las toca casi cualquier tarea, así que son donde más se choca. Si vas a reescribir algo ahí, avisá primero. No porque no puedas: porque es probable que otra persona esté en el mismo archivo.
- **`00 Sistema/`, `.claude/`, `AGENTS.md`, `CLAUDE.md` y `vault.conf`** son las reglas que obedecen *todos* los agentes del vault. Podés tocarlas — pero avisá, porque es el único lugar donde tu edición aparece como un **cambio de comportamiento en la computadora de las demás personas**. Su agente va a empezar a trabajar distinto sin que nadie se lo haya pedido.

**Ramas cortas: abrilas y cerralas el mismo día.** Cuanto más vive una rama, más se aleja del resto y peor mezcla. Si un trabajo va a llevar una semana, partilo.

## 5. Aprobar y mergear no son lo mismo

Confundirlos es lo que más cuesta al principio. **Nadie hace `git push` a `main`, nunca.**

| | Qué es | Qué mueve |
|---|---|---|
| **Aprobar** | El botón *Approve* del PR. Decís "está bien" | **Nada.** Solo deja un tilde verde |
| **Mergear** | El botón *Squash and merge* | **Esto** es lo que mete el cambio en `main` |

> **La regla: quien abre el PR es quien lo mergea, después de que el otro aprueba.**

| Quién lo escribió | Quién aprueba | Quién aprieta *merge* |
|---|---|---|
| Persona A | Persona B | **Persona A** |
| Persona B | Persona A | **Persona B** |

El autor sabe si quiere agregar algo antes de cerrarlo, y es quien responde por el cambio. Quien aprueba solo dice que sí.

> Técnicamente cualquiera de las personas puede mergear cualquier PR: no hay nada que lo impida. Es una convención, no un candado — pero evita que alguien cierre el trabajo de otra persona sin avisar.

### No todo necesita review

El PR **sirve igual aunque nadie lo mire**: corre las verificaciones antes de que el cambio entre, deja el diff guardado, junta tus registros del día en una sola línea legible, avisa a la otra persona, y deja todo revertible de una. El review se le cuelga encima; no es su razón de ser.

Por eso hay dos caminos, y **el flag es la señal** — queda escrito en el PR mismo, sin que nadie tenga que acordarse:

| Qué tocaste | Cómo abrís el PR | Quién mergea |
|---|---|---|
| Tu diario, notas nuevas tuyas | `gh pr create --fill` | **Vos, al toque.** No esperás a nadie |
| `01 Index/`, `02 MOCs/`, `00 Sistema/`, `.claude/` | `gh pr create --reviewer <la-otra>` | Vos, **después** de que apruebe |

### Recorrido A — bajo riesgo, sin espera

```bash
git switch main && git pull
git switch -c <xx>/fotos-productos
# … trabajás …
git push -u origin <xx>/fotos-productos
gh pr create --fill                      # sin --reviewer = "esto entra solo"
gh pr merge --squash --delete-branch     # lo mergeás vos, al toque
git switch main && git pull
```

### Recorrido B — necesita los ojos de la otra persona

```bash
git switch main && git pull
git switch -c <yy>/sop-nuevo-flujo
# … trabajás …
git push -u origin <yy>/sop-nuevo-flujo
gh pr create --reviewer <la-otra-persona>    # "necesito que mires esto"
```

**Y ahí parás.** La otra persona abre *Files changed* (o le pide `/revisar-pr <número>` a su agente), y hace *Review changes* → **Approve** → *Submit review*. **Recién entonces**, vos:

```bash
gh pr merge --squash --delete-branch
git switch main && git pull
```

> **Si tocás `00 Sistema/`, `.claude/`, `AGENTS.md` o `CLAUDE.md`, avisá además por mensaje.** Los avisos automáticos existen —la mención en el PR, el aviso al abrir el agente, el mail— pero un cambio que altera **cómo trabaja el agente de la otra persona** merece una frase humana.

### La rama se borra sola, pero solo en GitHub

Al mergear, la rama **desaparece de GitHub** automáticamente. La copia que quedó en tu computadora **no**: esa la borrás vos.

```bash
git switch main && git pull
git fetch --prune                                     # sincroniza qué existe en GitHub
git branch --merged main | grep -v main | xargs git branch -d
```

> El `-d` en minúscula solo borra ramas ya incorporadas, así que es seguro: si algo no se mergeó, se niega.

## 6. Trabajar con tu agente de IA

Cada persona usa su propio agente. La ley que obedecen está versionada en el vault (`AGENTS.md`, `CLAUDE.md`, `.claude/`), así que tu agente la lee solo. Cuatro reglas para vos:

1. **El autor del cambio sos vos, no el agente.** El agente queda firmado abajo como colaborador. Un cambio firmado por un robot es un cambio del que nadie responde.
2. **Tu agente trabaja donde vos podés trabajar.** Fuera de tus zonas, propone y te pregunta; no escribe.
3. **Al PR llega una rama por persona, no una por agente.** Si corriste varios agentes a la vez (cada uno en su worktree), los juntás vos en tu rama **antes** de abrir el PR. Sin esto, tres personas con tres agentes abren nueve PRs por sesión y la revisión se vuelve inviable.
4. **Nadie aprueba su propio PR — ni el que hizo su agente.** Si tu agente lo escribió y vos lo firmaste, quien revisa es otra persona. Ese es el segundo par de ojos, y es lo único que reemplaza a los controles automáticos que el plan gratuito no da.

Cuando termines una sesión larga, tu agente deja una nota en `05 Diario/Bitácora Agentes/` diciendo qué hizo y qué quedó pendiente. **Esa entrada la lee el agente de la otra persona la próxima vez.** Se agrega al final, identificando persona y agente; nunca se reescribe la de otra persona.

> Si son **exactamente dos**: cada PR lo revisa la otra, siempre, y no hay tercero de respaldo — si una no está, el PR espera. Es el costo de ser dos; conviene saberlo de entrada.

## 7. Lo que nunca va al vault

**Contraseñas, tokens, claves de API, datos de tarjetas, exportaciones con datos personales de clientes.** Nada de eso, ni siquiera "un momentito para probar".

Una vez que algo así se publica, **ya se filtró**: borrarlo después no lo borra del historial, y hay que rotar la credencial. La verificación local te va a frenar si detecta algo, pero no confíes en ella — confiá en no ponerlo.

## 8. Sobre el check `verify` del PR

Cuando abrís un PR, GitHub muestra un check llamado **`verify`**: corre el buscador de secretos y el de bloques protegidos (esos dos lo ponen en rojo), y además avisa —sin ponerlo en rojo— del formato de las notas, los enlaces rotos y los índices desactualizados.

Dos cosas que hay que saber para no malinterpretarlo:

- **Es una señal, no un bloqueo** *(en plan Free)*. No se puede exigir que un check pase antes de mergear: un PR en rojo **se puede mergear igual**. Mirarlo es responsabilidad de quien revisa.
- **El control real es el `pre-commit` de tu máquina.** El del servidor corre *después* de que ya publicaste, y no puede frenar el merge. Por eso el paso 1 no es opcional.

## 9. Si algo sale mal

- **Te aparece un conflicto al mezclar:** no lo resuelvas a las apuradas. Avisá y lo revisamos. Un conflicto mal resuelto borra el trabajo de alguien en silencio.
- **Rompiste algo y no sabés qué:** no borres nada. Git guarda todo; se recupera. Avisá.
- **Commiteaste sin querer en la rama principal** (con `--no-verify`, o antes de correr `setup.sh`): avisá antes de tocar nada más.
- **El `pre-commit` te frena y no entendés por qué:** leé el mensaje completo antes de buscar cómo saltearlo. Casi siempre dice exactamente qué falta.

Ninguna de estas situaciones es un problema si se avisa temprano. Todas lo son si se tapan.

---

**El detalle técnico completo** está en [SOP Git y Flujo de Trabajo](<SOP Git y Flujo de Trabajo.md>) §11–§12 y en [SOP Multi-Agente](<SOP Multi-Agente.md>) §5. Este documento es el resumen que hay que saber para trabajar; esos son la referencia para cuando algo no cierra.

## Cómo leer este documento
De corrido, una vez, antes de tu primer cambio. Después vuelve como referencia: §2 es el ritual de todos los días, §8 es qué hacer cuando algo se rompe.
