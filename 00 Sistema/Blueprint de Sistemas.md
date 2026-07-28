---
type: How-to
title: "Blueprint de Sistemas"
tags: [blueprint, sistema, ia, arquitectura]
estado: 🟢 Activo
prioridad: 🔥 Alta
responsable: "{{OWNER}}"
id: "BP-SISTEMAS-001"
generated:
  by: human:{{OWNER}}
  at: 2026-07-02T00:00:00Z
fecha_creacion: 2026-06-26
resource:
---

>[!info] Documentación relacionada
>[SOP Interoperabilidad IA](<SOP Interoperabilidad IA.md>) | [SOP Conectores](<SOP Conectores.md>) | [SOP Skills](<SOP Skills.md>) | [AGENTS](<../AGENTS.md>) | [Glosario de términos](<Glosario de términos.md>)

# Blueprint de Sistemas

## Objetivo

Plantilla reutilizable para **armar un sistema nuevo legible por IA** desde cero — el vault, un ERP, una LLM Wiki, una base documental. Responde la pregunta: *"voy a montar un sistema nuevo, ¿qué tengo que crear para que cualquier IA lo entienda y opere bien?"*

Este blueprint es la versión **accionable** del [SOP Interoperabilidad IA](<SOP Interoperabilidad IA.md>) (que explica la teoría). Acá está el checklist.

> **Principio:** un sistema preparado para IA no se improvisa. Se arma con 5 capas. Si falta una, la IA adivina — y adivinar es donde se rompe todo.

---

## 1. Las 5 capas de todo sistema legible por IA

Todo sistema, sin importar su tamaño, necesita estas 5 capas (ver [SOP Interoperabilidad IA](<SOP Interoperabilidad IA.md>) §4):

| # | Capa | Responde | Artefacto típico |
|---|---|---|---|
| 1 | **Ley** | ¿Cuáles son las reglas? | `AGENTS.md` |
| 2 | **Mapa** | ¿Dónde está cada cosa? | `llms.txt` |
| 3 | **Estado** | ¿Qué cambió desde la última vez? | Dashboard / changelog |
| 4 | **Arquitectura** | ¿Cómo está construido cada sistema externo? | `Conectores/{X} - Arquitectura.md` |
| 5 | **Capacidad** | ¿Qué puede *hacer* la IA? | `Skills/` |
| 6 | **Automatización** | ¿Qué se cumple *solo*, sin depender del agente? | `Hooks/` (`.claude/hooks/` + `settings.json`) |

**Las 3 primeras son universales** (para *entender*). **Las 3 últimas son por-sistema** (para *operar* y *sostener*).

> **Capacidad vs Automatización:** una *Skill* se ejecuta **a demanda** (respondés a un pedido); un *Hook* se dispara **por evento** del ciclo (convierte una convención en enforcement). Ver [SOP Hooks y Automatización](<SOP Hooks y Automatización.md>).

---

## 2. Checklist de armado

Al montar un sistema nuevo, validá en orden:

### Paso 0 — Discovery (antes de construir nada)
- [ ] **¿Ya existe?** Buscar producto/repo/solución (Prior Art)
- [ ] **¿Hay doc oficial?** Leerla primero (RTFM)
- [ ] **Decisión Build / Buy / Adopt** explícita
- [ ] Brief de discovery escrito

> Ver [SOP Discovery](<SOP Discovery.md>) (cómo) y [Investigación Previa (Discovery)](<../04 Knowledge/Sistemas y Metodologías/Investigación Previa (Discovery).md>) (por qué). Saltarse esto fue el error del caso Notion.

### Capa 1 — Ley
- [ ] Existe un `AGENTS.md` (o equivalente) en la raíz
- [ ] Declara propósito del sistema en 1-2 frases
- [ ] Lista las reglas no negociables (qué hacer / qué NO hacer)
- [ ] Define el protocolo de inicio (qué leer antes de actuar)

### Capa 2 — Mapa
- [ ] Existe un `llms.txt` que lista qué leer y en qué orden
- [ ] Cada enlace tiene una descripción de relevancia
- [ ] Lo opcional está marcado como tal (sección `## Optional`)

### Capa 3 — Estado
- [ ] Hay un punto único donde ver "qué cambió" (dashboard, changelog)
- [ ] Cada doc clave tiene `generated` en su frontmatter

### Capa 4 — Arquitectura (si conecta sistemas externos)
- [ ] Cada sistema externo tiene su doc en `Conectores/` ([SOP Conectores](<SOP Conectores.md>))
- [ ] Incluye modelo, diccionario, dependencias, deuda y changelog

### Capa 5 — Capacidad (si tiene operaciones repetitivas)
- [ ] Las tareas repetitivas están empaquetadas como Skills ([SOP Skills](<SOP Skills.md>))
- [ ] Cada Skill separa metadatos (frontmatter) de lógica

### Capa 6 — Automatización (si hay convenciones que deben cumplirse siempre)
- [ ] Las reglas que no pueden depender de la memoria del agente son **hooks** ([SOP Hooks y Automatización](<SOP Hooks y Automatización.md>))
- [ ] Cada hook tiene kill-switch, está probado (pipe-test) y documentado en el [Catálogo de Hooks y Locks](<../04 Knowledge/Automatización/Catálogo de Hooks y Locks.md>)
- [ ] Si hay escritura paralela sobre los mismos archivos, hay un plan de **lock advisory**
- [ ] **Alcance decidido a propósito:** hook en `settings.json` del **proyecto** = corre solo en ese sistema; en `~/.claude/settings.json` **global** = corre en toda carpeta (y entonces debe ser "a-prueba-de-no-vault"). Los del Sistema Maestro son **de proyecto**.

### Mantenimiento (transversal)
- [ ] El [Skill - Mantenimiento Sistema](<../04 Knowledge/Skills/Skill - Mantenimiento Sistema.md>) cubre el sistema nuevo
- [ ] Hay un criterio de frescura (cada cuánto se revisa)

---

## 3. Orden de construcción recomendado

No se arman las 5 capas a la vez. El orden que minimiza retrabajo:

```
0. Discovery             → ¿ya existe? ¿doc oficial? build/buy/adopt (ANTES de todo)
1. Ley (AGENTS.md)       → primero las reglas, todo se apoya acá
2. Arquitectura          → documentar los sistemas externos que vas a usar
3. Capacidad (Skills)    → automatizar lo repetitivo, ya con la arquitectura clara
4. Mapa (llms.txt)       → recién cuando hay algo que mapear
5. Estado                → el changelog crece solo a medida que cambiás cosas
```

> **Por qué la Ley primero:** documentar capacidades o mapas sobre un sistema sin reglas definidas obliga a reescribirlos cuando las reglas aparecen. Las reglas son el cimiento.

---

## 4. Qué tener en cuenta (lecciones del Sistema Maestro)

| Lección | De dónde salió |
|---|---|
| Separá lo vivo (conector) de lo estático (recurso) | El problema de la base Recursos de Notion haciendo 3 cosas |
| Documentá el *porqué*, no el *qué* (la IA ve el schema en vivo) | [SOP Conectores](<SOP Conectores.md>) §4 |
| La fecha viva vive en el proceso, no en el documento | [SOP Interoperabilidad IA](<SOP Interoperabilidad IA.md>) §8 |
| Verificá antes de incluir un estándar como hecho | Auditoría externa: DNS-AID resultó real, otros no se pudieron verificar |
| Una capa Estado evita repetir trabajo ya hecho | 5ª capa, agregada tras review externa |
| No sobre-construir para escala que no tenés | §11 Horizonte futuro: stateless MCP, DNS-AID quedan para cuando expongas agentes |

---

## 5. Sistemas del ecosistema (registro)

| Sistema | Tipo | Estado | Doc principal |
|---|---|---|---|
| Vault Sistema Maestro | Knowledge base | 🟩 Activo | [AGENTS](<../AGENTS.md>) |
| Notion | Conector (ejemplo ficticio) | ⬜ Ejemplo — reemplazar por tus sistemas | [Notion - Arquitectura](<../04 Knowledge/Conectores/Notion - Arquitectura.md>) |

> Esta tabla es TU registro: agregá una fila por cada sistema externo que conectes (Drive, un ERP, un CRM…) con su doc en `04 Knowledge/Conectores/`.

---

## Referencias

- [SOP Interoperabilidad IA](<SOP Interoperabilidad IA.md>)
- [SOP Conectores](<SOP Conectores.md>)
- [SOP Skills](<SOP Skills.md>)
- [Skill - Mantenimiento Sistema](<../04 Knowledge/Skills/Skill - Mantenimiento Sistema.md>)
- [AGENTS](<../AGENTS.md>)
- [Glosario de términos](<Glosario de términos.md>)

## Cómo leer este blueprint
Si vas a armar un sistema nuevo: leé el checklist (§2) y el orden de construcción (§3). Si querés entender el porqué de cada capa, andá al [SOP Interoperabilidad IA](<SOP Interoperabilidad IA.md>).
