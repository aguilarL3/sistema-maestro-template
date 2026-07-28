---
type: Tutorial
title: "Inicio Rápido — Sistema Maestro V6"
tags: [sistema, onboarding, tutorial]
estado: 🟢 Activo
prioridad: 🔥 Alta
responsable: "{{OWNER}}"
id: "TUT-002"
generated:
  by: human:{{OWNER}}
  at: 2026-07-17T00:00:00Z
fecha_creacion: 2026-06-17
resource:
---

> [!info] Este es EL tutorial de entrada del sistema (único, per Diátaxis).
> Para el manual completo: [SOP Maestro](<00 Sistema/SOP Maestro.md>). Para navegar: [Home](<Home.md>).

# Inicio Rápido — Sistema Maestro V6

El Sistema Maestro es un **sistema operativo personal**.

No es una app de tareas. No es una carpeta de notas. No es un segundo cerebro genérico.

Es la infraestructura completa desde donde dirigís tu vida: qué valorás, hacia dónde vas, qué ejecutás, qué aprendés, qué recordás y qué demostrás.

Todo pasa por esta cadena:
```
Información → Conocimiento → Acción → Resultados → Evidencia → Crecimiento
```

---

## Antes de empezar — Plugins

Los plugins de comunidad (**Templater**, Dataview, Calendar, Kanban, obsidian-git…) **ya vienen incluidos en el vault**. Al abrirlo por primera vez, Obsidian pregunta si confiás en el autor: elegí **"Trust author and enable plugins"** y listo.

Solo si Templater faltara (las plantillas lo usan para las fechas automáticas): `Configuración → Plugins de comunidad → buscar "Templater" → Instalar → Activar`.

---

## Las 8 capas del vault

| Capa | Para qué |
|---|---|
| `00 Sistema` | Reglas, SOPs, plantillas — el manual del sistema |
| `01 Index` | Tu brújula: valores, visión, objetivos, áreas de vida, dashboard personal |
| `02 MOCs` | Mapas de contenido por tema — puertas de entrada al conocimiento |
| `03 Proyectos` | Todo lo que tiene inicio y fin: trabajo, portfolio, iniciativas personales |
| `04 Knowledge` | Conocimiento reutilizable: notas atómicas, modelos mentales, conceptos |
| `05 Diario` | Registro cotidiano: hábitos, reflexión, prioridades, seguimiento |
| `06 Raw` | Fuentes sin procesar: artículos, videos, libros, ideas brutas |
| `99 Archivo` | Todo lo que terminó o ya no está activo |

> **El vault habla un estándar abierto.** El sistema implementa el [Open Knowledge Format (OKF)](<04 Knowledge/Sistemas y Metodologías/Open Knowledge Format (OKF).md>) de Google Cloud: cada nota lleva frontmatter estándar (`type`, `timestamp`, `title`, `description`), cada carpeta tiene un `index.md` **generado automáticamente** (no lo edites a mano — se regenera al commitear), y los enlaces siguen una regla simple: **markdown `[Título](<ruta.md>)` para notas que existen, wikilink `[[...]]` para conocimiento aún no escrito**. No tenés que memorizar nada de esto: las plantillas y los hooks lo hacen por vos. Detalle en [SOP Documentación](<00 Sistema/SOP Documentación.md>) §4 y §6.1.

---

## Un día común en el sistema

El sistema no impone una rutina. Se adapta a lo que el día trae.
Lo que sí tiene son **gestos mínimos** que lo mantienen vivo.

### Mañana — orientar el día (5–10 min)
1. Abrís `Home.md` como punto de entrada
2. Revisás el diario de ayer o abrís uno nuevo con `Plantilla Diario`
3. Escribís las prioridades del día — no tareas, prioridades
4. Si algo urgente aparece en tu cabeza → lo capturás ahora, sin organizar

### Durante el día — según lo que toque
El sistema tiene una respuesta para cada tipo de actividad:

| Si estás... | Usás... | Va a... |
|---|---|---|
| Estudiando un curso | `Plantilla Apunte Curso` | `04 Knowledge` |
| Trabajando en un proyecto | archivo del proyecto | `03 Proyectos` |
| Tomando una decisión importante | `Plantilla Decisiones` | `01 Index` o `04 Knowledge` |
| Leyendo un artículo o viendo un video | nota rápida | `06 Raw` |
| Pensando en un hábito o área de vida | entrada en el diario | `05 Diario` |
| Teniendo una idea | nota rápida sin organizar | `06 Raw` o `05 Diario` |
| Revisando tus objetivos | `01 Index/Objetivos` | `01 Index` |

**Regla universal:** capturar primero, organizar después. Nunca pierdas algo por no saber dónde va.
**¿No sabés dónde vive algo?** Consultá `01 Index` (la capa de orientación) o dejalo en `06 Raw` y decidilo en la revisión semanal.

### Cierre del día (5 min)
1. Completás la entrada del diario: resultado del día, reflexión, qué queda pendiente
2. Si algo que capturaste merece ser procesado → lo movés o lo dejás para mañana
3. Revisás si avanzaste algo en algún proyecto → actualizás el estado

---

## Los 6 usos centrales del sistema

### 1. Dirigir tu vida
El núcleo del sistema vive en `01 Index`.
Ahí están tus valores, tu visión, tus objetivos por área de vida y tu dashboard personal.
Se revisa mensualmente, no a diario.

```
01 Index → Valores → Visión → Objetivos → Áreas de vida → Dashboard CEO
```

### 2. Ejecutar proyectos
Cualquier iniciativa con inicio y fin vive en `03 Proyectos`.
Puede ser un proyecto de trabajo, un proyecto personal, algo del portfolio o una iniciativa de salud.

```
03 Proyectos → archivo del proyecto → roadmap → bitácora → entregables
```

### 3. Aprender y construir conocimiento
Lo que aprendés de cursos, libros, conversaciones o experiencia pasa por este flujo:

```
06 Raw (fuente cruda) → 04 Knowledge (nota atómica) → 02 MOCs (mapa del tema)
```

No todo lo que capturás se convierte en Knowledge. Solo lo que aparece 3+ veces o tiene alto valor práctico.

### 4. Registrar y reflexionar
El diario no es solo para el estudio. Es para cualquier área de vida.

```
05 Diario → hábitos / prioridades / problemas / predicción / reflexión
```

### 5. Tomar decisiones
Las decisiones importantes se documentan, no se dejan solo en la memoria.

```
Plantilla Decisiones → contexto + opciones + criterios + decisión tomada → revisión futura
```

### 6. Mantener el sistema vivo
Una vez por semana aplicás CE-RE-BRO para que el sistema no se degrade:

```
CE → conectar notas aisladas que quedaron sueltas
RE → reagrupar lo que quedó mal clasificado
BRO → optimizar o archivar lo que ya cumplió su función
```

---

## Primer día en 5 pasos

**Paso 1 — Activá los plugins de comunidad** (ya explicado arriba — vienen con el vault)

**Paso 2 — Leé los archivos base del sistema**
- `00 Sistema/SOP Maestro.md` — qué es y cómo funciona todo
- `00 Sistema/Filosofía del Sistema.md` — por qué está construido así

**Paso 3 — Establecé tu brújula personal**
Abrí `01 Index/` y verificá que existan (o crealos si no están):
- Valores — qué es innegociable para vos
- Visión — hacia dónde va tu vida en 3–5 años
- Objetivos — qué estás persiguiendo ahora
- Áreas de vida — cómo dividís tu vida (profesional, salud, finanzas, relaciones, personal)

Sin esto, el sistema ejecuta tareas pero no tiene dirección.

**Paso 4 — Abrí tu primer diario**
Creá una nota desde `Plantilla Diario` → renombrá con la fecha de hoy.
Llenalo: ¿cuáles son tus prioridades de hoy? ¿qué querés lograr? ¿cómo estás?

**Paso 5 — Identificá qué tenés activo ahora**
Revisá si ya hay proyectos que debería estar en `03 Proyectos`.
Revisá si hay conocimiento que debería estar en `04 Knowledge`.
No muevas todo de golpe. Solo lo más importante.

---

## Flujo mínimo viable

Si no tenés tiempo para nada más, con solo esto el sistema sigue funcionando:

```
Mañana   → abrís el diario, escribís 3 prioridades
Durante  → capturás lo que aparezca, sin organizar
Noche    → cerrás el diario con el resultado del día
Domingo  → 15 min de revisión CE-RE-BRO
```

---

## Referencias clave

- [Home](<Home.md>) — punto de entrada principal
- [SOP Maestro](<00 Sistema/SOP Maestro.md>) — manual completo del sistema
- [Filosofía del Sistema](<00 Sistema/Filosofía del Sistema.md>) — por qué cada decisión de diseño (con las fuentes originales de cada marco)
- [Dashboard-CEO](<Dashboard-CEO.md>) — vista de vida completa
- [Dashboard-Estudio](<Dashboard-Estudio.md>) — hub operativo de estudio
- [SOP Revisiones](<00 Sistema/SOP Revisiones.md>) — auditoría semanal y mensual CE-RE-BRO
- [CLAUDE](<CLAUDE.md>) — contexto del sistema para trabajar con IA
