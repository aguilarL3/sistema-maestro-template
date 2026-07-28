---
type: How-to
title: "Conflicto Semántico — Enlaces y Contradicciones"
tags: [multiagente, semantico, enlaces, contradicciones, auditoria]
estado: 🟢 Activo
prioridad: 🔥 Alta
responsable: "{{OWNER}}"
id: "HOW-001"
generated:
  by: human:{{OWNER}}
  at: 2026-07-01T00:00:00Z
fecha_creacion: 2026-07-01
resource:
---

>[!info] Documentación relacionada
>Conflicto semántico entre agentes (el porqué) | [Orquestación Multi-Agente Abierta](<Orquestación Multi-Agente Abierta.md>) (§13.3) | [Catálogo de Hooks y Locks](<../04 Knowledge/Automatización/Catálogo de Hooks y Locks.md>) | [SOP Hooks y Automatización](<SOP Hooks y Automatización.md>) | [Skill - Mantenimiento Sistema](<../04 Knowledge/Skills/Skill - Mantenimiento Sistema.md>)

# Conflicto Semántico — Enlaces y Contradicciones

## 1. El problema

Worktrees + zonas resuelven el conflicto de **archivos** (dos agentes tocan el mismo `.md`). Pero el conflicto difícil de un vault es **semántico**: dos notas terminan diciendo cosas incompatibles, o un enlace apunta a algo que ya no existe. Git no ve nada raro (los archivos no chocan), pero el conocimiento queda roto. Esta guía cubre las dos caras y sus herramientas.

| Cara | Naturaleza | Herramienta |
|---|---|---|
| **Enlaces rotos** (Gap 2a) | Mecánico: un `[[link]]` apunta a un archivo inexistente | `.claude/hooks/check-links.sh` |
| **Contradicciones** (Gap 2b) | Requiere criterio: dos notas afirman lo opuesto | Convención `[!contradiction]` + `.claude/hooks/check-contradictions.sh` |

---

## 2. Enlaces rotos (Gap 2a)

### Cómo correrlo
```bash
bash .claude/hooks/check-links.sh          # reporte completo, agrupado por archivo
bash .claude/hooks/check-links.sh --quiet  # solo el resumen
```
Escanea todos los `.md`, resuelve cada `[[wikilink]]`/embed estilo Obsidian (por basename o ruta, sin distinguir mayúsculas; ignora alias `|`, secciones `#`, bloques de código y URLs) y lista los destinos que no existen. Corre en ~0.6s sobre todo el vault.

### Cómo leer el resultado — dos clases de "roto"
1. **Roto real** → el destino existía y se movió/renombró/borró. **Se arregla** (reapuntar el enlace o restaurar el destino). Ej.: `[[01 Index/Dashboard CEO]]` → `[Dashboard-CEO](<../Dashboard-CEO.md>)` tras una consolidación.
2. **Planificado** → concepto que decidiste enlazar antes de crear la nota (los `[[...]]` "sembrados" en MOCs). **No es un error**: es deuda de contenido. Se resuelve creando la nota cuando toque, o quitando el enlace si se descartó.

> El script no distingue las dos clases (no puede). El criterio lo ponés vos: mirá si el destino *debería* existir.

---

## 3. Contradicciones (Gap 2b)

### La regla de oro
Cuando un agente (o vos) detecta que dos notas afirman cosas opuestas, **NO lo "arregla" en silencio**: lo **marca** para reconciliación consciente. Silenciar una contradicción borra información; marcarla la conserva hasta decidir. (*El código posee el entorno; el agente posee el contenido* — y una contradicción es una decisión de contenido.)

### La convención — callout `[!contradiction]`
En la nota más relevante (o donde primero se topa la contradicción), insertá un callout Obsidian:

```markdown
> [!contradiction] Título corto del choque
> - **Afirma A:** <qué dice> ([[Nota A]])
> - **Afirma B:** <qué dice opuesto> ([[Nota B]])
> - **Estado:** abierta
```

- Usá `[!contradiction]-` (con guion) para que arranque **colapsado**.
- **Estado:** `abierta` (default) o `reconciliada YYYY-MM-DD` cuando se resuelve. El checker lee esta línea.
- Enlazá **ambas** notas en conflicto con `[[...]]` — así el grafo conecta el choque.

### El workflow de reconciliación
```
Detectar → Marcar ([!contradiction], Estado: abierta) → Revisar (humano/lead) →
Decidir (cuál gana, o matizar ambas) → Cerrar (Estado: reconciliada YYYY-MM-DD)
```
El lead (o {{OWNER}}) es quien **decide**; el agente solo **marca y propone**. Nunca se resuelve una contradicción borrando una de las dos notas sin registro.

### Cómo auditarlas
```bash
bash .claude/hooks/check-contradictions.sh          # lista todas, con estado
bash .claude/hooks/check-contradictions.sh --quiet  # total / abiertas
```
Es el **buzón de reconciliación**: recorre el vault, lista cada `[!contradiction]` con su archivo, línea, estado y título, y cuenta cuántas quedan **abiertas**. Objetivo sano: tender a **0 abiertas**.

---

## 4. Cuándo correr esto
- **En la revisión mensual / mantenimiento:** ambos checkers (candidatos a integrarse en [Skill - Mantenimiento Sistema](<../04 Knowledge/Skills/Skill - Mantenimiento Sistema.md>)).
- **Tras mover/renombrar/borrar notas:** `check-links.sh` (para cazar enlaces que quedaron colgados).
- **Al cerrar una sesión multi-agente:** revisar contradicciones abiertas antes del merge.

## 5. Referencias
- Por qué existe esta frontera → [Orquestación Multi-Agente Abierta](<Orquestación Multi-Agente Abierta.md>) §13.3
- Qué hace cada herramienta → [Catálogo de Hooks y Locks](<../04 Knowledge/Automatización/Catálogo de Hooks y Locks.md>) (Auditoría CLI)
- Prior art: `claude-obsidian` (callout `[!contradiction]`, `wiki-lock.sh`)

## Cómo leer este documento
Si tenés enlaces rotos, andá a §2. Si hay ideas que chocan, §3 (convención + workflow). Para el *porqué* de todo esto, el §13.3 de la Orquestación. Las herramientas viven en `.claude/hooks/`; su ficha, en el Catálogo.
