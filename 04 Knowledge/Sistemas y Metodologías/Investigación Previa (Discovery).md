---
type: Explanation
title: "Investigación Previa (Discovery)"
tags: [discovery, investigacion, prior-art, spike, build-vs-buy, metodologia, carrera]
origen: "MOC - Master Learning System"
estado: 🟢 Activo
timestamp: 2026-06-26T00:00:00Z
fecha_creacion: 2026-06-26
id: "EXP-013"
resource:
---

>[!info] Documentación relacionada
>[SOP Discovery](<../../00 Sistema/SOP Discovery.md>) (el cómo) | [Ciclo de Vida de Capacidades IA](<Ciclo de Vida de Capacidades IA.md>) | [Blueprint de Sistemas](<../../00 Sistema/Blueprint de Sistemas.md>) | [Glosario de términos](<../../00 Sistema/Glosario de términos.md>)

# Investigación Previa (Discovery)

Nota de **estudio**: entender a fondo por qué se investiga antes de construir, los conceptos del oficio y —sobre todo— cómo hacerlo bien sin caer en sus trampas. El **cómo operativo** (checklist) vive en [SOP Discovery](<../../00 Sistema/SOP Discovery.md>); esto es el **porqué y el cómo pensarlo**.

> **La idea en una frase:** antes de construir cualquier cosa, averiguá si ya existe y si está documentada. Casi siempre alguien ya recorrió parte del camino — empezar desde ahí es más rápido que descifrarlo solo.

---

## 1. Por qué importa (el costo de saltárselo)

Construir sin investigar primero produce dos desperdicios:
- **Reinventar** algo que ya existe (gastás en construir lo comprable/adoptable).
- **Descifrar** por ingeniería inversa algo que estaba **documentado oficialmente**.

> **Caso de estudio propio — Notion.** Desciframos el modelo de datos del workspace consultando las bases una por una, en vez de arrancar por la documentación oficial del conector MCP de Notion. Avanzar "tocando datos" se *sentía* productivo, pero era el camino lento. Un `RTFM` de 30 minutos probablemente habría ahorrado el grueso del tiempo. La lección no es "leé más" — es **leé primero lo oficial, después tocá**.

---

## 2. Los conceptos del oficio

| Concepto | Qué es | Cuándo lo usás |
|---|---|---|
| **Discovery Phase** | La etapa de entender el problema y el terreno antes de diseñar/construir. Deliverable: un brief técnico + feasibility | Al inicio de cualquier proyecto/feature |
| **Spike** (Agile) | Una investigación técnica **timeboxed** (1-3 días) para responder una duda concreta y decidir el approach. A veces es construir un prototipo desechable para aprender | Cuando no sabés si algo es viable o cómo encararlo |
| **Prior Art Search** | Buscar qué **ya existe**: productos, repos, papers, soluciones | Antes de decidir construir |
| **Build vs Buy (vs Adopt)** | Decisión explícita: ¿lo construyo, lo compro, o adopto algo existente? Lente: costo total a 5 años | Cuando hay opciones en el mercado |
| **RTFM** ("read the manual") | Leer la documentación **oficial** antes de improvisar | Siempre que exista doc del vendor/estándar |

**Cómo se encadenan:** Discovery es la **fase**; dentro de ella usás Prior Art (¿qué hay?), RTFM (¿qué dice lo oficial?), Spikes (¿es viable?), y cerrás con una decisión Build/Buy/Adopt.

---

## 3. Los 3 modos de falla (y cómo evitarlos)

El Discovery mal hecho es tan dañino como no hacerlo. Tres trampas:

### a) Parálisis por análisis
Investigar para siempre y nunca construir. La investigación se vuelve una forma de procrastinar.
> **Antídoto:** el Spike es **timeboxed** (1-3 días, no "hasta estar seguro"). El objetivo es *"investigar lo suficiente para decidir"*, no *"investigar para siempre"*. Cuando se acaba el timebox, decidís con lo que hay.

### b) Tratar la doc oficial como evangelio
Irónico en este sistema: construimos todo un mantenimiento **porque la documentación envejece**. La oficial también puede estar incompleta o atrasada (el conector MCP de Notion podría no documentar todo).
> **Antídoto:** Discovery **incluye verificar**, no solo leer. La doc oficial es el punto de arranque, no la verdad final. (Misma disciplina que el N2 juez: leer + confirmar.)

### c) Reinventar por orgullo
A veces "ya existe" se ignora porque uno *quiere* hacerlo. La decisión de construir se toma por gusto, no por análisis.
> **Antídoto:** la decisión **Build vs Buy debe ser explícita**, escrita y justificada — no implícita. Si construís, que sea porque conviene, no porque sí.

---

## 4. La mentalidad correcta

```
"¿Voy a construir X?"
        ↓
Antes de tocar nada:
  ¿Ya existe?  →  ¿Doc oficial?  →  ¿Es confiable?  →  ¿Build/Buy/Adopt?
        ↓
Decidir con información SUFICIENTE (no completa)
        ↓
Recién entonces: construir (o adoptar lo que ya está)
```

Tres frases para recordar:
1. **"Lo oficial primero, después improviso."** (RTFM)
2. **"Suficiente para decidir, no para estar seguro."** (anti-parálisis)
3. **"Si construyo, que sea una decisión, no un reflejo."** (Build vs Buy explícito)

---

## 5. Dónde encaja en el sistema

- Es la **Fase 0** del [Ciclo de Vida de Capacidades IA](<Ciclo de Vida de Capacidades IA.md>) — va *antes* de Build.
- Es el **paso 0** del [Blueprint de Sistemas](<../../00 Sistema/Blueprint de Sistemas.md>) — antes de crear el AGENTS.md de un sistema nuevo.
- El protocolo ejecutable está en [SOP Discovery](<../../00 Sistema/SOP Discovery.md>).

---

## Para profundizar (fuentes)
- Discovery Phase — Softermii (softermii.com/blog/...discovery-phase-in-software-development)
- Spike en Agile — Mountain Goat Software (mountaingoatsoftware.com/blog/spikes)
- Prior Art Search — Cypris (cypris.ai/insights/...prior-art-search-software-2026)
- Build vs Buy — Product School (productschool.com/blog/leadership/build-vs-buy)

## Cómo estudiar esta nota
Leé §1 (por qué) y §3 (los modos de falla) — son el corazón. El §2 es el vocabulario. Cuando vayas a construir algo, releé el §4 (la mentalidad) y ejecutá con [SOP Discovery](<../../00 Sistema/SOP Discovery.md>).
