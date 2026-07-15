---
tipo_doc: Explanation
tags: [seguridad, cadena-de-suministro, plugins, dependencias, tema]
estado: 🌱 Semilla
prioridad: 🔴 Alta
responsable: "{{OWNER}}"
id: "EXP-SEGURIDAD-002"
ultima_revision: 2026-07-08
fecha_creacion: 2026-07-08
---

>[!info] Documentación relacionada
>[[Prompt Injection y la Tríada Letal]] (el vector gemelo) | [[SOP de Seguridad]] (el cómo operarlo) | Anatomía de los hooks del vault | [[Orquestación Multi-Agente Abierta]]

# Cadena de Suministro y Código de Terceros

> El otro vector de seguridad, distinto del prompt injection. Acá **no hay ningún modelo al que engañar**: instalás código de un extraño y lo ejecutás con tus propios permisos. Es el riesgo directo de plugins de Obsidian, skills y hooks de Claude Code, paquetes npm/pip y repos que clonás.

## La idea en una frase
Instalar un plugin, una skill, un hook o un paquete = **ejecutar en tu máquina código escrito por otra persona, con tus permisos** — y ese código puede hacer todo lo que vos podés: leer tus archivos, tus tokens, y salir a la red.

## Qué problema resuelve entender esto
Es fácil confundir este riesgo con el de prompt injection, pero son **distintos y se defienden distinto**:

| | Prompt injection | Cadena de suministro |
|---|---|---|
| Qué se explota | El **juicio** del modelo (lee órdenes ocultas) | La **confianza** tuya (ejecutás su código) |
| Hace falta una IA | Sí | **No** — el código corre solo |
| Defensa central | Romper la [[Prompt Injection y la Tríada Letal|Tríada Letal]] | Minimizar y **verificar antes de instalar** |

## Los vectores en tu mundo concreto
- **Plugins de la comunidad de Obsidian.** Corren con **Node.js**: acceso total a tu sistema de archivos y a la red. Un plugin malicioso —o uno bueno cuya cuenta fue comprometida— es *malware* con permiso de leer todo el vault (y más).
- **Skills y hooks de Claude Code.** Son scripts (bash/python) que **corren automáticamente** en eventos de sesión (ver Anatomía de los hooks del vault). Copiar una skill o un hook de internet = **ejecutar su código** cada vez que dispara el evento. Un hook `SessionStart` malicioso corre apenas abrís la carpeta.
- **`npm install` / `pip install` en proyectos externos.** Muchos paquetes ejecutan **scripts post-install** (código que corre solo al instalar). Además arrastran **dependencias transitivas**: confiás no solo en el paquete, sino en las dependencias de sus dependencias (cientos).
- **Extensiones de VS Code / editores.** Mismo modelo que los plugins: código con tus permisos.
- **Repos que clonás y abrís con un agente.** Su `.claude/`, sus hooks, su `CLAUDE.md` pueden traer scripts *y* instrucciones para el agente → acá **este vector cruza con** [[Prompt Injection y la Tríada Letal]]: abrir un repo desconocido con un agente de permisos amplios es doblemente peligroso.

## Cómo suelen atacar (tipos)
- **Typosquatting:** un paquete con nombre casi idéntico al real (`reqeusts` en vez de `requests`). Te equivocás de letra y instalás el malicioso.
- **Dependency confusion:** subir a un repo público un paquete con el nombre de uno interno tuyo, para que el gestor lo prefiera.
- **Cuenta del mantenedor comprometida / update malicioso:** el paquete era legítimo, pero una **versión nueva** trae el veneno. Por eso el auto-update ciego es peligroso.
- **Protestware / sabotaje del propio autor:** el mantenedor mete código dañino a propósito en una release.
- **Confianza transitiva:** el paquete que instalás es honesto, pero una de sus 200 dependencias no.

## Por qué es difícil
El código corre con **tus** permisos, no con los suyos: no hay una caja que lo contenga por defecto. Y la confianza es **transitiva** — auditar un paquete no basta si no auditás su árbol entero, que nadie hace a mano. La superficie crece con cada cosa que instalás.

## Las defensas reales
1. **Minimizar la superficie (la más importante).** El plugin/paquete más seguro es el que **no** instalás. Antes de sumar algo, preguntá: *¿lo necesito de verdad, o hay algo nativo?* Menos piezas = menos riesgo y menos mantenimiento.
2. **Evaluar antes de instalar.** Popularidad y antigüedad, actividad reciente del repo, quién lo mantiene, issues abiertos sobre seguridad, y si es **open source revisable**. Un plugin nuevo, de autor anónimo y sin estrellas es una apuesta.
3. **Leé lo que va a correr.** Skills y hooks son **cortos**: leelos completos antes de aceptarlos (¿hace `curl` a algún lado?, ¿lee `.env`?, ¿escribe fuera de su carpeta?). Es la ventaja de que el vault use scripts simples y auditables.
4. **Fijá versiones, no updates ciegos.** Lockfiles, versiones pineadas, y leer el changelog antes de actualizar algo con acceso amplio.
5. **Aislá lo que no confiás.** Probá repos/paquetes dudosos en un entorno separado (worktree, carpeta aislada, VM), **sin** acceso a tus secretos y **sin** un agente de permisos amplios encima.
6. **Nunca abras un repo desconocido con un agente potente.** Si tenés que explorarlo con IA, hacelo con permisos mínimos y sin acceso a tu vault ni a tus conectores — por el cruce con prompt injection.

## Checklist embrión (antes de instalar cualquier cosa)
> Esto es el germen de lo que vivirá completo en [[SOP de Seguridad]].
- [ ] ¿Lo necesito, o ya tengo cómo hacerlo sin instalar nada?
- [ ] ¿Es open source y puedo ver el código?
- [ ] ¿Autor y mantenimiento creíbles (actividad, comunidad, historia)?
- [ ] Si es skill/hook: **¿leí el script entero?** ¿Hace red, lee credenciales, escribe fuera de su ámbito?
- [ ] ¿Puedo probarlo aislado antes de darle acceso a datos reales?
- [ ] ¿Fijé la versión y sé cómo lo desinstalo/desactivo?

## Modelos mentales para llevarte
- **Instalar = ejecutar.** No es "agregar una función", es "correr el código de un extraño con mis permisos".
- **El código no necesita una IA para hacer daño** — este vector existe desde antes de los agentes y es más simple que el prompt injection.
- **La confianza es transitiva y crece sola.** Cada dependencia hereda tu confianza a las suyas.
- **Lo barato de instalar es caro de auditar.** El costo real de un plugin no es instalarlo, es responder por todo lo que arrastra.

## Conexiones
- El vector gemelo (engañar al modelo, no ejecutar código) → [[Prompt Injection y la Tríada Letal]].
- Qué scripts corren solos en tu vault y cómo están hechos → Anatomía de los hooks del vault.
- El *cómo* operativo con checklists por caso → [[SOP de Seguridad]].
- Gobernanza multi-agente (por qué los hooks se aíslan al proyecto) → [[Orquestación Multi-Agente Abierta]].

## Referencias
- OWASP Top 10 for LLM Applications — LLM03: Supply Chain — https://owasp.org/www-project-top-10-for-large-language-model-applications/
- OWASP — Software Supply Chain Security — https://owasp.org/www-project-software-component-verification-standard/
- Auditoría de superficie de ataque (permisos, hooks, MCP) — ver [[SOP de Seguridad]] §2.

## Cómo leer esta nota
Es el *porqué* de un vector. Para el *cómo* (checklists concretos por tipo: plugin, skill/hook, rutina cloud, repo externo) → [[SOP de Seguridad]]. Para el vector gemelo → [[Prompt Injection y la Tríada Letal]].
