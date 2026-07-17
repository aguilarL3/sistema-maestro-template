---
type: How-to
title: "Centinelas de Edición (@user / @generated)"
tags: [multiagente, centinelas, edicion, proteccion, hooks]
estado: 🟢 Activo
prioridad: 🔥 Alta
responsable: "{{OWNER}}"
id: "HOW-002"
timestamp: 2026-07-01T00:00:00Z
fecha_creacion: 2026-07-01
resource:
---

>[!info] Documentación relacionada
>Propiedad del contenido (centinelas) (el porqué) | [Orquestación Multi-Agente Abierta](<Orquestación Multi-Agente Abierta.md>) (§13.3) | [SOP Hooks y Automatización](<SOP Hooks y Automatización.md>) | [Catálogo de Hooks y Locks](<../04 Knowledge/Automatización/Catálogo de Hooks y Locks.md>) | [Conflicto Semántico - Enlaces y Contradicciones](<Conflicto Semántico - Enlaces y Contradicciones.md>)

# Centinelas de Edición (@user / @generated)

## 1. Para qué sirven

Un centinela es un **marcador invisible** que declara *de quién es* un fragmento de una nota, para que un agente de IA sepa qué puede reescribir y qué no. Resuelve el Gap 3 de [Orquestación Multi-Agente Abierta](<Orquestación Multi-Agente Abierta.md>) §13.3: separar **contenido humano** (intocable) de **contenido generado** (regenerable) dentro de un mismo archivo.

| Centinela | Dueño | La IA puede… |
|---|---|---|
| `@user` | Humano ({{OWNER}}) | **NO** editar ni sobrescribir. Solo leer. |
| `@generated` | Agente | Regenerar libremente (es suyo). |

Se escriben como **comentarios HTML**, así que **no se ven** en el modo lectura de Obsidian y son Markdown puro y portable.

---

## 2. La sintaxis

```markdown
<!-- @user -->
Esta reflexión es mía. La IA no la toca.
Puede ocupar varias líneas.
<!-- /@user -->

<!-- @generated -->
Este resumen lo mantiene un agente; se puede regenerar.
<!-- /@generated -->
```

Reglas:
- Todo bloque abre con `<!-- @user -->` (o `@generated`) y cierra con `<!-- /@user -->` (o `/@generated`).
- Los espacios internos son flexibles (`<!--@user-->` también vale).
- Podés tener varios bloques por nota.
- Fuera de los bloques, el texto es "libre": la IA puede editarlo.

---

## 3. El guardián (enforcement automático)

La convención no depende de que el agente "se acuerde": la **obliga** un hook.

- **`.claude/hooks/sentinels-guard.sh`** (+ `sentinels-guard.py`) corre en `PreToolUse` (antes de cada `Write`/`Edit`).
- Lógica:
  - **Edit** cuyo `old_string` cae **dentro** de un bloque `@user` → **bloqueado** (exit 2). El motivo se le muestra al agente.
  - **Write** (sobrescritura total) que **perdería o alteraría** un bloque `@user` existente → **bloqueado**.
  - Archivo sin centinelas, o edición fuera del bloque → permitido.
- **FAIL-OPEN:** ante cualquier duda o error, **permite** (nunca frena trabajo legítimo por un bug). Los bloques `@generated` **no** se protegen (son del agente).
- **Kill-switch:** crear `.vault-meta/sentinels.disabled` desactiva el guard.

> Como hoy ninguna nota tiene centinelas, el guard está activo pero **inerte**: recién actúa cuando empezás a marcar bloques `@user`.

---

## 4. Cómo usarlo (workflow)

1. **Protegé** lo que no querés que la IA toque: envolvelo en `<!-- @user --> … <!-- /@user -->`. Ej.: tus reflexiones en una nota que además tiene secciones que un agente mantiene.
2. **Marcá como regenerable** lo que un agente produce y vas a dejar que actualice: `<!-- @generated --> … <!-- /@generated -->`.
3. A partir de ahí, si un agente intenta editar dentro de tu bloque, el guardián lo frena y le explica por qué.
4. Si necesitás que la IA sí modifique algo protegido, o quitás la protección (sacás los marcadores) o desactivás el guard temporalmente con el kill-switch.

### Limitación conocida (v1)
Una edición que **cruza el borde** de un bloque (parte dentro, parte fuera) puede no detectarse (fail-open). El caso común —editar de lleno dentro de un `@user`— sí se bloquea.

## 5. Referencias
- Por qué existe → [Orquestación Multi-Agente Abierta](<Orquestación Multi-Agente Abierta.md>) §13.3 (prior art: `obsidian-second-brain`, edición con centinelas)
- Ficha de la herramienta → [Catálogo de Hooks y Locks](<../04 Knowledge/Automatización/Catálogo de Hooks y Locks.md>) (Guardianes)
- Cómo se crean/prueban hooks → [SOP Hooks y Automatización](<SOP Hooks y Automatización.md>)

## Cómo leer este documento
Para proteger contenido, §2 (sintaxis) + §4 (workflow). Para entender qué bloquea y qué no, §3. El *porqué* está en §13.3 de la Orquestación.
