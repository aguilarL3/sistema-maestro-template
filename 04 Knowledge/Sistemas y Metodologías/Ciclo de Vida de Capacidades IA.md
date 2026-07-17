---
type: Reference
title: "Ciclo de Vida de Capacidades IA"
tags: [metodologia, ia, skills, prompts, agentes, evals, carrera]
origen: "MOC - Master Learning System"
estado: 🟢 Activo
timestamp: 2026-06-26T00:00:00Z
fecha_creacion: 2026-06-26
id: "REF-005"
resource:
---

>[!info] Documentación relacionada
>[SOP Skills](<../../00 Sistema/SOP Skills.md>) | [Catálogo de Skills](<../Skills/Catálogo de Skills.md>) | [SOP Prompts](<../../00 Sistema/SOP Prompts.md>) | [Glosario de términos](<../../00 Sistema/Glosario de términos.md>)

# Ciclo de Vida de Capacidades IA

Marco profesional para construir, probar, evaluar, versionar y mantener **capacidades de IA** — skills, prompts, agentes y orquestadores. Sirve como referencia transferible: lo que se practica en este vault es la versión liviana de lo que una empresa hace en producción.

> **Tesis:** una capacidad de IA es **software desplegable**. Se versiona, se evalúa con métricas, se despliega con guardas y se monitorea. No es "un texto que escribís una vez".

---

## 1. Las 8 fases

```
[Fase 0: Discovery] → Build → Test → Eval → Document → Version → Deploy → Monitor → Iterate
                         └──────────────────────────────────────────────────────────┘
                                          (vuelve a empezar)
```

| Fase | Qué se hace | Concepto clave |
|---|---|---|
| **0 · Discovery** | Investigar si ya existe **antes** de construir | Prior Art, RTFM, Build vs Buy → ver [SOP Discovery](<../../00 Sistema/SOP Discovery.md>) / [Investigación Previa (Discovery)](<Investigación Previa (Discovery).md>) |
| **Build** | Escribir la capacidad (instrucciones + herramientas) | Single responsibility: una skill = una tarea |
| **Test** | Probar con casos reales | Casos de prueba / smoke tests |
| **Eval** | Medir calidad con métricas objetivas | **Evals**, **golden dataset**, **LLM-as-Judge** |
| **Document** | Doc + versión + decisiones | Observabilidad, trazabilidad |
| **Version** | Numerar el cambio | **SemVer** (Major/Minor/Patch) |
| **Deploy** | Poner en uso | **CI/CD eval gates** (bloquean si empeora) |
| **Monitor** | Vigilar en producción | Tracing; capturar fallos reales |
| **Iterate** | Reinyectar fallos y mejorar | Los fallos alimentan el golden dataset |

---

## 2. Vault ↔ Empresa (lo que ya practicaste)

| Fase | En este vault (liviano) | En una empresa (producción) |
|---|---|---|
| Build | Ejecutable + doc | Igual, con Agent SDK / framework |
| Test | Casos de prueba, marcar ✅ a mano | **Evals automatizados** en CI |
| Eval | El **N2 juez** (LLM-as-Judge) | LLM-as-Judge sobre **golden dataset** fijo |
| Document | Doc + tabla de iteraciones | Igual + dashboards de observabilidad |
| Version | `version: v2.0` + git | **SemVer** + git, igual |
| Deploy | Sobreescribir + push | **CI/CD con eval gates** que bloquean regresiones |
| Monitor | Revisión mensual | **Tracing** en vivo; alertas por drift |
| Iterate | Reinyectar hallazgos del informe | Fallos de prod → golden dataset automáticamente |

> **Lo que ya hacés sin saberlo:** versionado, casos de prueba, LLM-as-Judge (tu N2), documentación con iteraciones. **Lo que falta para escala empresa:** golden dataset, eval gates en CI, tracing.

---

## 3. Conceptos clave

- **Eval** — prueba objetiva y repetible de la calidad de una capacidad. A diferencia de un test de software (pasa/falla determinista), mide dimensiones difusas (relevancia, exactitud) y suele necesitar un juez. Ver [Glosario de términos](<../../00 Sistema/Glosario de términos.md>).
- **Golden dataset** — conjunto fijo de casos con su respuesta correcta. Cada versión nueva se corre contra él y se compara con la versión actual. Es el "set de exámenes" de la capacidad.
- **LLM-as-Judge / Agent-as-Judge** — un modelo (o agente con herramientas) evalúa la salida de otro. Base de los evals difusos. Ver [Glosario de términos](<../../00 Sistema/Glosario de términos.md>).
- **CI/CD eval gate** — los evals corren solos en cada commit; si una métrica baja del umbral, **bloquean el deploy** (como un test que falla frena el merge).
- **SemVer** — Major.Minor.Patch. Major = cambio incompatible; Minor = funcionalidad nueva compatible; Patch = arreglo menor. Ver [Glosario de términos](<../../00 Sistema/Glosario de términos.md>).
- **Tracing / observabilidad** — registrar qué versión corrió, con qué entrada, qué salida y los fallos. Permite mejorar con datos reales, no suposiciones.
- **Deprecation policy** — cómo se retira una versión vieja sin romper a quien la usa (ventana de migración, avisos). Solo aplica si hay consumidores externos.

---

## 4. Versionado: una sola capacidad que evoluciona

No se crean capacidades nuevas por cada versión; **se versiona la misma**:

```
UNA skill/prompt/agente → version: v1.0 → v1.1 → v2.0
   El archivo se sobreescribe. Las versiones viejas viven en git.
   Versiones en paralelo SOLO si hay consumidores externos con ventana de migración.
```

Aplica igual a los cuatro tipos:

| Tipo | Qué es | Se versiona por |
|---|---|---|
| **Prompt** | Texto reutilizable, sin herramientas | Cambio de redacción/estructura |
| **Skill** | Capacidad ejecutable con herramientas | Cambio de lógica/scope |
| **Agente** | Skill autónoma con criterio propio | Cambio de instrucciones/herramientas |
| **Orquestador** | Coordina sub-agentes en paralelo | Cambio de coordinación/sub-agentes |

---

## 5. Aplicación a este vault

- El **ciclo de las skills** está en [SOP Skills](<../../00 Sistema/SOP Skills.md>) (build → test → productivo → deprecar).
- El **inventario** vivo está en [Catálogo de Skills](<../Skills/Catálogo de Skills.md>).
- El **eval** ya existe en forma de LLM-as-Judge dentro de [Skill - Mantenimiento Sistema](<../Skills/Skill - Mantenimiento Sistema.md>) (Nivel 2).
- **Lo próximo para madurar:** un golden dataset de casos de auditoría para medir si una versión nueva de una skill mejora o empeora respecto a la anterior.

---

## Referencias

**Internas:**
- [SOP Skills](<../../00 Sistema/SOP Skills.md>) · [Catálogo de Skills](<../Skills/Catálogo de Skills.md>) · [SOP Prompts](<../../00 Sistema/SOP Prompts.md>) · [Glosario de términos](<../../00 Sistema/Glosario de términos.md>)

**Externas (best practices 2026):**
- Anthropic — *Demystifying evals for AI agents* (anthropic.com/engineering/demystifying-evals-for-ai-agents)
- Anthropic — *2026 Agentic Coding Trends Report* (resources.anthropic.com)
- Anthropic — *Create Skill Version* API (docs.claude.com/en/api/skills/create-skill-version)
- Braintrust — *What is prompt versioning* (braintrust.dev/articles/what-is-prompt-versioning)
- Confident AI — *AI evaluation tools 2026* (confident-ai.com)
- Adaline — *Complete Guide to LLM & AI Agent Evaluation 2026* (adaline.ai)

## Cómo leer este documento
Es referencia/chuleta: consultala cuando vayas a construir o versionar una capacidad de IA. Las fases (§1) y el mapeo vault↔empresa (§2) son el núcleo.
