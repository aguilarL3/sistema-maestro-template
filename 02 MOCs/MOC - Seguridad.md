---
type: Indice
title: "MOC - Seguridad"
tags: [moc, knowledge, seguridad]
eje_central: "Seguridad del vault y de proyectos externos: prompt injection, cadena de suministro, defensa en profundidad"
life_areas: [profesional, personal]
domains: [ia, automatizacion, decisiones]
ultima_auditoria_ia: 2026-07-09
estado: 🏗️ Desarrollo
id: "MOC-SEGURIDAD-001"
fecha_creacion: 2026-07-09
timestamp: 2026-07-09T00:00:00Z
resource:
---

# MOC - Seguridad

Puerta de entrada al subsistema de seguridad del Sistema Maestro: cómo protegerse de **prompt injection** (engañar al modelo) y de **cadena de suministro** (ejecutar código de terceros), en el vault y en proyectos externos. El principio que ordena todo: **la seguridad se impone en capas deterministas (permisos + hooks), nunca se delega al modelo.**

---

## 📌 Notas Críticas y Pilares

- [Prompt Injection y la Tríada Letal](<../04 Knowledge/Temas/Prompt Injection y la Tríada Letal.md>) → **vector 1**: por qué un agente con acceso a tus datos es atacable con solo hacerlo leer algo. La tríada letal es la regla de diseño.
- [Cadena de Suministro y Código de Terceros](<../04 Knowledge/Temas/Cadena de Suministro y Código de Terceros.md>) → **vector 2**: instalar = ejecutar código de un extraño con tus permisos. Plugins, skills/hooks, npm, repos.
- [SOP de Seguridad](<../00 Sistema/SOP de Seguridad.md>) → el **cómo operativo**: modelo de 5 capas + checklists "antes de instalar" por caso.

> [!info] Jerarquía para IA
> Ante cualquier duda de seguridad, empezar por estos tres. Los dos primeros dan el *porqué*; el SOP da el *qué hacer*. La regla de oro: si algo debe cumplirse siempre → capa determinista (permisos/hook); si es una decisión de instalación → checklist.

---

## 1. Conceptos Core (el porqué)
- [Prompt Injection y la Tríada Letal](<../04 Knowledge/Temas/Prompt Injection y la Tríada Letal.md>) — tríada letal, directa vs indirecta, por qué filtrar no alcanza.
- [Cadena de Suministro y Código de Terceros](<../04 Knowledge/Temas/Cadena de Suministro y Código de Terceros.md>) — typosquatting, update malicioso, confianza transitiva.
- Verificación determinista vs criterio del agente — por qué la seguridad va en lo determinista, no en una skill.

## 2. Operativa (el qué hacer)
- [SOP de Seguridad](<../00 Sistema/SOP de Seguridad.md>) — checklists §3 (plugin Obsidian · skill/hook · npm · rutina cloud · repo externo), romper la tríada, higiene, portabilidad.

## 3. Mecanismos y controles (las capas)
- **Capa 1 — Permisos:** bloque `deny` en `.claude/settings.json` (versionado; red/secretos/force-push) + `allow` personal en `settings.local.json`; ver [SOP de Seguridad](<../00 Sistema/SOP de Seguridad.md>) §6.
- **Capa 2 — Prevención determinista:** `security-guard.sh` (`PreToolUse Bash|Read`) → Anatomía de los hooks del vault · [Catálogo de Hooks y Locks](<../04 Knowledge/Automatización/Catálogo de Hooks y Locks.md>).
- **Capa 3 — Gate pre-commit:** `secret-scan.sh` (`.githooks/pre-commit`) → frena secretos antes del historial.
- **Capa 4 — Detección periódica:** `security-audit.sh` (a mano o vía [Skill - Mantenimiento Sistema](<../04 Knowledge/Skills/Skill - Mantenimiento Sistema.md>) Dimensión 3).
- **Capa 5 — Criterio a demanda:** [Skill - Revisión de Seguridad](<../04 Knowledge/Skills/Skill - Revisión de Seguridad.md>) (`/revisar-seguridad`).

## 4. Relacionado
- [Orquestación Multi-Agente Abierta](<../00 Sistema/Orquestación Multi-Agente Abierta.md>) → gobernanza y aislamiento (worktrees, zonas, identidad).
- Anatomía de los hooks del vault → qué corre solo y con qué privilegio.
- [SOP Hooks y Automatización](<../00 Sistema/SOP Hooks y Automatización.md>) → cómo se construyen/desactivan los guardianes.

---

## Navegación
[Home](<../Home.md>) | [[02 MOCs/MOC - Automatizacion IA]] | [Roadmap del Sistema](<../01 Index/Roadmap del Sistema.md>)

## Observaciones
- Pendiente: probar los casos de [Skill - Revisión de Seguridad](<../04 Knowledge/Skills/Skill - Revisión de Seguridad.md>); registrar ids SEGURIDAD en el Registro (§7.1 de [SOP Documentación](<../00 Sistema/SOP Documentación.md>)).
- Evolución natural: versión portable de los controles para proyectos externos (fila "Portabilidad" del [Roadmap del Sistema](<../01 Index/Roadmap del Sistema.md>)).
