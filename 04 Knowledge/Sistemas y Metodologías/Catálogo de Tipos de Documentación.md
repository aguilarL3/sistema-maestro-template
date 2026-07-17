---
type: Explanation
title: "Catálogo de Tipos de Documentación"
tags: [metodologia, documentacion, diataxis, knowledge, sistema]
life_areas: [profesional, personal]
domains: [comunicacion, conocimiento, carrera]
goals: [aprendizaje_profundo, portabilidad_sistema]
habits: [documentar, conectar]
projects: []
sources: [Daniele Procida (Diátaxis), Michael Nygard (ADR), Google SRE, Keep a Changelog, ISO 9001, The Good Docs Project]
estado: 🟢 Activo
id: "EXP-001"
timestamp: 2026-06-28T00:00:00Z
fecha_creacion: 2026-06-28
resource:
---

>[!info] Documentación relacionada
>[Tipos de Documentación](<../../00 Sistema/Tipos de Documentación.md>) (referencia corta para *decidir* rápido) | [Blueprint de Sistemas](<../../00 Sistema/Blueprint de Sistemas.md>) | [SOP Maestro](<../../00 Sistema/SOP Maestro.md>) | [Glosario de términos](<../../00 Sistema/Glosario de términos.md>)

# Catálogo de Tipos de Documentación

Nota de estudio (curso) sobre **todos los tipos de documentación que existen por convención**. Mientras que [Tipos de Documentación](<../../00 Sistema/Tipos de Documentación.md>) es una referencia corta para *consultar* qué crear, esta nota es para **entender a fondo** cada tipo: qué es, cuándo usarlo, su spec canónica y cómo se aplica (o no) en este vault.

> **Insight central:** la documentación no se organiza por *tema* sino por **intención de quien lee**. Antes de escribir, preguntá: ¿esta persona quiere **aprender**, **hacer una tarea**, **consultar un dato**, **entender un porqué**, **decidir**, o **saber qué pasó**? Cada intención pide un tipo distinto. Mezclar intenciones en un mismo documento es el error más común.

---

## Parte 1 — Marcos que organizan TODO el corpus

Antes de los tipos sueltos, conviene conocer los marcos que los ordenan. No son tipos de documento: son formas de clasificar el conjunto.

### 1.1 Diátaxis ⭐ (el estándar de facto)
Creado por **Daniele Procida (2020)**. Usado por Django, Cloudflare, Canonical, Gatsby. Clasifica según dos ejes: **acción ↔ conocimiento** y **estudiar ↔ trabajar**. De ahí salen cuatro cuadrantes:

```
                  ACCIÓN
                    │
     Tutorial  ─────┼─────  How-to
                    │
  ESTUDIAR ─────────┼───────── TRABAJAR
                    │
   Explanation ─────┼─────  Reference
                    │
                CONOCIMIENTO
```

| Cuadrante | Intención | Eje |
|---|---|---|
| Tutorial | Aprender haciendo | estudiar + acción |
| How-to | Resolver una tarea | trabajar + acción |
| Reference | Consultar un dato | trabajar + conocimiento |
| Explanation | Entender el porqué | estudiar + conocimiento |

> La gran lección de Diátaxis: **un buen tutorial es un mal how-to**, y viceversa. No intentes que un documento sirva para las cuatro intenciones.

### 1.2 DITA (Darwin Information Typing Architecture)
Estándar de *structured authoring* (IBM, OASIS). Clasifica en **Concept · Task · Reference**. Es XML, modular, pensado para reutilizar fragmentos entre manuales. **Sobre-ingeniería** para un sistema personal — útil saber que existe, no adoptarlo.

### 1.3 The Good Docs Project
Implementación práctica de Diátaxis: ofrece **plantillas listas** por tipo de documento (open source). Es la fuente más práctica si querés andamios ya hechos.

### 1.4 Information Mapping
Método propietario que clasifica en seis tipos de información: **Procedure · Process · Principle · Concept · Structure · Fact**. Corporativo, riguroso, poco usado fuera de empresas grandes.

### 1.5 Jerarquía de calidad (ISO 9001) — la que más te conviene mirar
No clasifica por intención sino por **nivel de autoridad**:

```
Policy (Política)         → QUÉ se debe hacer y POR QUÉ   (alto nivel, rara vez cambia)
   └─ Procedure (SOP)     → CÓMO se hace, a alto nivel
        └─ Work Instruction → el detalle PASO A PASO exacto
```

> Esta jerarquía resuelve un problema real del vault: hoy mezclás *policy*, *procedure* y *work instruction* dentro de un mismo "SOP". Saber distinguirlas evita inflar los SOP.

---

## Parte 2 — El catálogo completo (por intención del lector)

Cada tipo con: **qué es · cuándo usarlo · ejemplo · spec canónica (si tiene)**.

### 🎓 Grupo A — Para APRENDER

**Tutorial** — *aprender haciendo*
- Lleva al principiante de la mano por una experiencia completa de principio a fin.
- Cuándo: alguien nuevo necesita su primera victoria. Prioriza que funcione, no que sea exhaustivo.
- Ejemplo: [00 Inicio Rapido](<../../00 Inicio Rapido.md>).
- Spec: Diátaxis.

**Getting Started / Quickstart** — *poner a andar rápido*
- Versión mínima del tutorial: lo justo para arrancar en minutos.
- Cuándo: el lector ya tiene contexto y solo quiere empezar.

**Curso / Training** — *aprendizaje estructurado y secuencial*
- Conjunto ordenado de lecciones con progresión pedagógica.
- En el vault: `04 Knowledge/Cursos/` (rige Zettelkasten/Evergreen, no `type`).

### 🔧 Grupo B — Para HACER UNA TAREA

**How-to guide** — *resolver una tarea concreta*
- Receta para un objetivo específico, asume conocimiento previo.
- Cuándo: "¿cómo hago X?". A diferencia del tutorial, no enseña: resuelve.
- Spec: Diátaxis.

**SOP (Standard Operating Procedure / Procedure)** — *tarea normal y repetible*
- Cómo ejecutar una operación esperada, de forma consistente y reproducible.
- Cuándo: una tarea se repite y querés que salga igual siempre (o que otro la haga).
- Ejemplo: todos tus `00 Sistema/SOP *.md`.

**Work Instruction** — *el detalle paso a paso exacto*
- El nivel más granular: clics, comandos, capturas. Vive "debajo" de un SOP.
- Cuándo: un paso del SOP es tan delicado que necesita su propio detalle.

**Runbook** — *qué hacer cuando algo FALLA (un escenario)*
- Procedimiento de respuesta a una condición anormal concreta.
- Cuándo: un proceso tiene modos de fallo conocidos. Hoy vive implícito en tu sección "Troubleshooting"; conviene separarlo cuando hay muchos fallos.
- Spec: tradición SRE/ops. **SOP = operación normal · Runbook = el fallo.**

**Playbook** — *estrategia para MÚLTIPLES escenarios*
- Más amplio que el runbook: agrupa varias respuestas y criterios de decisión.
- Cuándo: situaciones complejas con ramificaciones (incidentes, lanzamientos).

**Checklist** — *no olvidar pasos*
- Lista de verificación accionable. Simple y poderosa (ver *The Checklist Manifesto*).
- Cuándo: un proceso crítico donde el olvido cuesta caro.

### 📖 Grupo C — Para CONSULTAR UN DATO

**Reference** — *consultar un dato preciso*
- Descripción técnica, ordenada y completa, hecha para buscar, no para leer de corrido.
- Cuándo: el lector ya sabe qué busca y quiere el dato exacto.
- Ejemplo: [Tipos de Documentación](<../../00 Sistema/Tipos de Documentación.md>), [Glosario de términos](<../../00 Sistema/Glosario de términos.md>).
- Spec: Diátaxis.

**Glosario** — *definir el vocabulario*
- Subtipo de reference: términos y sus significados dentro del sistema.
- Ejemplo: [Glosario de términos](<../../00 Sistema/Glosario de términos.md>).

**API / Spec técnica** — *contrato exacto de una interfaz*
- Define entradas, salidas, parámetros, errores. Relevante en software.

**Índice / Mapa (MOC)** — *dónde está cada cosa*
- Puerta de entrada que conecta y orienta, no guarda conocimiento profundo.
- Ejemplo: tus `02 MOCs/`, `llms.txt`, `01 Index/`.

**FAQ** — *preguntas frecuentes resueltas*
- Atajo a las dudas recurrentes. Útil pero tiende a desordenarse: si crece, conviene migrar a how-to o reference.

### 💡 Grupo D — Para ENTENDER EL PORQUÉ

**Explanation (Discussion)** — *entender el contexto y el porqué*
- Aclara, da contexto, discute alternativas. Se lee para comprender, no para hacer.
- Cuándo: el lector quiere el "por qué" detrás de las decisiones.
- Ejemplo: [Filosofía del Sistema](<../../00 Sistema/Filosofía del Sistema.md>), [Principios](<../../01 Index/Principios.md>), esta misma nota.
- Spec: Diátaxis.

**Policy (Política)** — *qué se debe hacer y por qué (alto nivel)*
- Regla de gobernanza que rara vez cambia. Está por encima de los SOP.
- Ejemplo en el vault: [Valores](<../../01 Index/Valores.md>), [Principios](<../../01 Index/Principios.md>).

**Principios / Filosofía** — *las creencias que guían el diseño*
- Subtipo de explanation/policy: el marco mental que justifica todo lo demás.

### 🧭 Grupo E — Para DECIDIR Y REGISTRAR DECISIONES

**ADR (Architecture Decision Record)** — *por qué se decidió esto*
- Captura una decisión, su contexto, alternativas y consecuencias. Inmutable: si cambia, se crea otro ADR que lo supera.
- Cuándo: una decisión estructural que tu yo futuro va a cuestionar.
- Ejemplo: [[Plantilla Decisiones]].
- Spec: **Michael Nygard / MADR**.

**RFC / Design Doc** — *propuesta antes de construir*
- Documento que se circula para discutir un diseño *antes* de implementarlo.
- Spec: estilo Google Design Docs / IETF RFC.

**PRD / Spec de producto** — *qué debe hacer un producto/feature*
- Define requisitos y alcance de algo a construir. Mundo de producto.

### 📜 Grupo F — Para RASTREAR QUÉ PASÓ

**Changelog** — *qué cambió y cuándo*
- Lista cronológica de cambios, orientada a humanos.
- Ejemplo: [CHANGELOG del Sistema](<../../00 Sistema/CHANGELOG del Sistema.md>).
- Spec: **Keep a Changelog** + **Semantic Versioning (SemVer)**.

**Bitácora / Log** — *registro cronológico de un proceso*
- Diario de trabajo de una iniciativa concreta.
- Ejemplo: tus notas `Migracion 2026-06-24...`.

**Postmortem / Incident Report** — *qué falló y qué aprendimos*
- Análisis tras un incidente, enfocado en aprendizaje, no en culpa.
- Spec: **Blameless Postmortem (Google SRE)**.

**Release Notes** — *novedades de una versión para el usuario final*
- Como el changelog pero redactado para quien usa, no para quien desarrolla.

### 🧩 Grupo G — ANDAMIOS

**Plantilla / Template** — *estructura base reutilizable*
- Sirve para crear cualquiera de los tipos anteriores con formato consistente.
- Ejemplo: `00 Sistema/001_plantillas/`.

---

## Parte 3 — Convenciones de la era moderna (docs-as-code + IA)

Tipos/archivos que tienen **spec canónica** y por eso "dictan" buenas prácticas:

| Convención | Qué estandariza |
|---|---|
| **Keep a Changelog** | Formato del changelog |
| **Semantic Versioning (SemVer)** | Numeración de versiones (MAJOR.MINOR.PATCH) |
| **Conventional Commits** | Mensajes de commit (ya lo usás) |
| **Standard Readme** | Estructura del `README` |
| `README` · `CONTRIBUTING` · `SECURITY.md` · `LICENSE` | Archivos canónicos de repositorio |
| **`AGENTS.md`** · **`llms.txt`** · **`CLAUDE.md`** | Era IA: instrucciones para agentes (ya los tenés) |

---

## Parte 4 — Mapa: qué aplica a ESTE vault

✅ **Ya tenés (con ejemplo):**
- Tutorial → [00 Inicio Rapido](<../../00 Inicio Rapido.md>)
- How-to → SOPs
- Reference → [Glosario de términos](<../../00 Sistema/Glosario de términos.md>), [Tipos de Documentación](<../../00 Sistema/Tipos de Documentación.md>)
- Explanation → [Principios](<../../01 Index/Principios.md>), [Filosofía del Sistema](<../../00 Sistema/Filosofía del Sistema.md>), esta nota
- ADR → [[Plantilla Decisiones]]
- Changelog / Bitácora → [CHANGELOG del Sistema](<../../00 Sistema/CHANGELOG del Sistema.md>), `Migracion...`
- Índice/MOC → `02 MOCs/`, `llms.txt`
- Plantilla → `001_plantillas/`
- Policy → [Valores](<../../01 Index/Valores.md>), [Principios](<../../01 Index/Principios.md>)

⚠️ **Te faltan nombrar formalmente (candidatos para el [SOP Documentación](<../../00 Sistema/SOP Documentación.md>)):**
- **Runbook** — hoy disuelto en "Troubleshooting"
- **Postmortem** — para cuando el sistema falla (distinto del changelog)
- **Checklist** — como tipo reconocido
- **Policy vs Procedure** — distinción, no tipo nuevo

🚫 **No te hacen falta (sobre-ingeniería para un sistema personal):**
- DITA, Information Mapping, Work Instruction separado, API/Spec, RFC, PRD, Playbook

---

## Cómo estudiar este catálogo
No lo leas de corrido de una vez. Recorrido sugerido:
1. Internalizá el **insight central** (intención, no tema) y los 4 cuadrantes de **Diátaxis** (Parte 1.1).
2. Aprendé la **jerarquía Policy → Procedure → Work Instruction** (Parte 1.5): es la que más ordena tus SOP.
3. Usá la **Parte 2** como diccionario: cuando vayas a crear un doc, buscá su grupo por intención.
4. Cuando audites el vault, contrastá con la **Parte 4** para detectar tipos faltantes o mal clasificados.

## Relación con otros marcos
- Complementa a [Tipos de Documentación](<../../00 Sistema/Tipos de Documentación.md>) (referencia operativa corta).
- El [Blueprint de Sistemas](<../../00 Sistema/Blueprint de Sistemas.md>) dice *qué capas* crear; este catálogo dice *qué tipo de documento* es cada pieza.
- Alimenta directamente al futuro **SOP Documentación** (estándar de *cómo* documentar).

## Referencias
- Diátaxis — Daniele Procida → https://diataxis.fr
- The Good Docs Project → https://thegooddocsproject.dev
- ADR — Michael Nygard / MADR → https://adr.github.io
- Keep a Changelog → https://keepachangelog.com
- Semantic Versioning → https://semver.org
- Google SRE (Postmortems) → https://sre.google/sre-book/postmortem-culture
- ISO 9001 (jerarquía documental de calidad)
