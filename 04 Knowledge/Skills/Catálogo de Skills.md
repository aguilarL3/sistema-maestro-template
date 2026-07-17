---
type: Indice
title: "Catálogo de Skills"
tags: [skills, catalogo, registro, ia, claude-code]
origen: "MOC - IA con Claude"
estado: 🟢 Activo
timestamp: 2026-07-09T00:00:00Z
fecha_creacion: 2026-06-26
resource:
---

>[!info] Documentación relacionada
>[SOP Skills](<../../00 Sistema/SOP Skills.md>) | [Ciclo de Vida de Capacidades IA](<../Sistemas y Metodologías/Ciclo de Vida de Capacidades IA.md>) | MOC - IA con Claude

# Catálogo de Skills

Registro único de todas las skills ejecutables del vault. **Fuente de verdad** del inventario: cuándo se crea, versiona o depreca una skill, se actualiza acá.

> Cada skill vive en dos capas (ver [SOP Skills](<../../00 Sistema/SOP Skills.md>) §2): ejecutable en `.claude/commands/` + doc en `04 Knowledge/Skills/`. Este catálogo indexa ambas.

## Inventario

| Comando | Doc | Versión | Estado | Tipo | Qué hace |
|---|---|---|---|---|---|
| `/cerebro-ce` | [Skill - Cerebro CE](<Skill - Cerebro CE.md>) | v1.0 | 🟨 Borrador | Auditor | Conexiones: huérfanas, wikilinks rotos, clusters sin MOC |
| `/cerebro-re` | [Skill - Cerebro RE](<Skill - Cerebro RE.md>) | v1.0 | 🟨 Borrador | Auditor | Reagrupamiento: tags duplicados, YAML inconsistente, carpetas |
| `/cerebro-bro` | [Skill - Cerebro BRO](<Skill - Cerebro BRO.md>) | v1.0 | 🟨 Borrador | Auditor | Estructura interna: notas largas, ideas mezcladas, atomicidad |
| `/cerebro-index` | [Skill - Cerebro Index](<Skill - Cerebro Index.md>) | v1.0 | 🟨 Borrador | Generador | Genera el índice de navegación del vault |
| `/cerebro-audit` | [Skill - Cerebro Audit](<Skill - Cerebro Audit.md>) | v1.0 | 🟨 Borrador | Orquestador | Corre las 3 dimensiones CE-RE-BRO en un diagnóstico priorizado |
| `/mantenimiento-sistema` | [Skill - Mantenimiento Sistema](<Skill - Mantenimiento Sistema.md>) | v2.0 | 🟦 En pruebas | Auditor | Frescura (fechas) + consistencia (N1 heurístico + N2 juez) |
| `/revision-mensual` | [Skill - Revisión Mensual](<Skill - Revisión Mensual.md>) | v1.1 | 🟦 En pruebas | Orquestador | Orquesta Cerebro Audit + Mantenimiento en paralelo → 1 informe |
| `/nota-estudio` | [Skill - Nota de Estudio](<Skill - Nota de Estudio.md>) | v1.0 | 🟦 En pruebas | Generador | Nota Explanation a demanda: concepto + lenguaje + walkthrough del código + alternativas |
| `/revisar-seguridad` | [Skill - Revisión de Seguridad](<Skill - Revisión de Seguridad.md>) | v1.0 | 🟦 En pruebas | Auditor | Decidir antes de instalar/abrir (plugin/hook/npm/repo/contenido): recorre checklist SOP §3 → veredicto 🟢/🟡/🔴/⚠️ (capa 5, nunca ejecuta el target) |

## Estados (ciclo de vida)

| Estado | Significado |
|---|---|
| 🟨 Borrador | Escrita, sin probar |
| 🟦 En pruebas | Ejecutada ≥1 vez; validando casos |
| 🟩 Productivo | Output consistente en 5+ corridas |
| 🟥 Deprecado | Reemplazada; doc en `99 Archivo/Skills/`, ejecutable eliminado |

## Tipos

- **Auditor** — lee y detecta problemas, propone (no aplica).
- **Generador** — produce un artefacto (índice, informe).
- **Orquestador** — coordina sub-agentes/skills en paralelo y consolida.

## Cómo se mantiene este catálogo

1. **Skill nueva** → agregar fila aquí + crear doc + ejecutable ([SOP Skills](<../../00 Sistema/SOP Skills.md>) §10).
2. **Skill versionada** (v1→v2) → actualizar versión en la fila ([SOP Skills](<../../00 Sistema/SOP Skills.md>) §11).
3. **Skill deprecada** → mover a una sección "Archivadas" + estado 🟥 ([SOP Skills](<../../00 Sistema/SOP Skills.md>) §12).

> Para entender el ciclo completo (build → test → eval → versionar → deploy → monitorear) y su equivalente profesional/empresarial, ver [Ciclo de Vida de Capacidades IA](<../Sistemas y Metodologías/Ciclo de Vida de Capacidades IA.md>).

## Referencias
- [SOP Skills](<../../00 Sistema/SOP Skills.md>)
- [Ciclo de Vida de Capacidades IA](<../Sistemas y Metodologías/Ciclo de Vida de Capacidades IA.md>)
- MOC - IA con Claude
- [[Plantilla Skill]]
