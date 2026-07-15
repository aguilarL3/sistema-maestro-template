---
tipo_doc: Indice
tags: [skills, catalogo, registro, ia, claude-code]
origen: "MOC - IA con Claude"
estado: 🟢 Activo
ultima_revision: 2026-07-09
fecha_creacion: 2026-06-26
---

>[!info] Documentación relacionada
>[[SOP Skills]] | [[Ciclo de Vida de Capacidades IA]] | MOC - IA con Claude

# Catálogo de Skills

Registro único de todas las skills ejecutables del vault. **Fuente de verdad** del inventario: cuándo se crea, versiona o depreca una skill, se actualiza acá.

> Cada skill vive en dos capas (ver [[SOP Skills]] §2): ejecutable en `.claude/commands/` + doc en `04 Knowledge/Skills/`. Este catálogo indexa ambas.

## Inventario

| Comando | Doc | Versión | Estado | Tipo | Qué hace |
|---|---|---|---|---|---|
| `/cerebro-ce` | [[Skill - Cerebro CE]] | v1.0 | 🟨 Borrador | Auditor | Conexiones: huérfanas, wikilinks rotos, clusters sin MOC |
| `/cerebro-re` | [[Skill - Cerebro RE]] | v1.0 | 🟨 Borrador | Auditor | Reagrupamiento: tags duplicados, YAML inconsistente, carpetas |
| `/cerebro-bro` | [[Skill - Cerebro BRO]] | v1.0 | 🟨 Borrador | Auditor | Estructura interna: notas largas, ideas mezcladas, atomicidad |
| `/cerebro-index` | [[Skill - Cerebro Index]] | v1.0 | 🟨 Borrador | Generador | Genera el índice de navegación del vault |
| `/cerebro-audit` | [[Skill - Cerebro Audit]] | v1.0 | 🟨 Borrador | Orquestador | Corre las 3 dimensiones CE-RE-BRO en un diagnóstico priorizado |
| `/mantenimiento-sistema` | [[Skill - Mantenimiento Sistema]] | v2.0 | 🟦 En pruebas | Auditor | Frescura (fechas) + consistencia (N1 heurístico + N2 juez) |
| `/revision-mensual` | [[Skill - Revisión Mensual]] | v1.1 | 🟦 En pruebas | Orquestador | Orquesta Cerebro Audit + Mantenimiento en paralelo → 1 informe |
| `/nota-estudio` | [[Skill - Nota de Estudio]] | v1.0 | 🟦 En pruebas | Generador | Nota Explanation a demanda: concepto + lenguaje + walkthrough del código + alternativas |
| `/revisar-seguridad` | [[Skill - Revisión de Seguridad]] | v1.0 | 🟦 En pruebas | Auditor | Decidir antes de instalar/abrir (plugin/hook/npm/repo/contenido): recorre checklist SOP §3 → veredicto 🟢/🟡/🔴/⚠️ (capa 5, nunca ejecuta el target) |

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

1. **Skill nueva** → agregar fila aquí + crear doc + ejecutable ([[SOP Skills]] §10).
2. **Skill versionada** (v1→v2) → actualizar versión en la fila ([[SOP Skills]] §11).
3. **Skill deprecada** → mover a una sección "Archivadas" + estado 🟥 ([[SOP Skills]] §12).

> Para entender el ciclo completo (build → test → eval → versionar → deploy → monitorear) y su equivalente profesional/empresarial, ver [[Ciclo de Vida de Capacidades IA]].

## Referencias
- [[SOP Skills]]
- [[Ciclo de Vida de Capacidades IA]]
- MOC - IA con Claude
- [[Plantilla Skill]]
