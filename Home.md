---
type: Indice
title: "Home"
tags: [home, dashboard]
estado: 🟢 Activo
fecha_creacion: 2026-06-17
generated:
  by: human:{{OWNER}}
  at: 2026-07-17T00:00:00Z
resource:
---

# Home

## Entrada rápida
- [00 Inicio Rapido](<00 Inicio Rapido.md>)
- [Dashboard-Estudio](<Dashboard-Estudio.md>)
- [Dashboard-CEO](<Dashboard-CEO.md>)
- [SOPS](<SOPS.md>)
- [Glosario de términos](<00 Sistema/Glosario de términos.md>)
- [MOC - Investigación del Sistema](<02 MOCs/MOC - Investigación del Sistema.md>)
- [Matriz Definitiva](<Matriz Definitiva.md>)

## Qué leer primero (orden recomendado)
1. [00 Inicio Rapido](<00 Inicio Rapido.md>) — **empezá acá**: el único tutorial de entrada (qué es el sistema, cómo se usa, dónde va cada cosa)
2. [SOP Maestro](<00 Sistema/SOP Maestro.md>) — manual completo: arquitectura, capas y flujo de trabajo
3. [Filosofía del Sistema](<00 Sistema/Filosofía del Sistema.md>) — por qué cada decisión de diseño (con las fuentes originales de cada marco)
4. [AGENTS](<AGENTS.md>) · [SOP Index](<00 Sistema/SOP Index.md>) · [Index Global](<01 Index/Index Global.md>) — para profundizar

## Capas del vault
> Cada capa tiene su `index.md` generado (convención [Open Knowledge Format (OKF)](<04 Knowledge/Sistemas y Metodologías/Open Knowledge Format (OKF).md>)) — la puerta de entrada para navegar su contenido.

- [AGENTS](<AGENTS.md>)
- [Index Global](<01 Index/Index Global.md>)
- [MOC - Ejemplo](<02 MOCs/MOC - Ejemplo.md>)
- [00 Sistema](<00 Sistema/index.md>)
- [02 MOCs](<02 MOCs/index.md>)
- [04 Knowledge](<04 Knowledge/index.md>)
- [05 Diario](<05 Diario/index.md>)

> Las capas `03 Proyectos`, `06 Raw` y `99 Archivo` empiezan vacías (placeholders): se pueblan al usar el sistema. Qué va en cada una → [SOP Maestro](<00 Sistema/SOP Maestro.md>) §5.

## Rutinas de mantenimiento del sistema

| Cada | Acción | Cómo | Deja |
|---|---|---|---|
| **Mensual** | Auditar frescura de la documentación | `/mantenimiento-sistema` | Informe en `05 Diario/Auditorías/` |
| **Mensual** | Auditar conexiones y estructura del vault | `/cerebro-audit` | Informe en `05 Diario/Auditorías/` |

**Flujo:** la skill deja un informe → resolvemos en el chat → cada arreglo va al [CHANGELOG del Sistema](<00 Sistema/CHANGELOG del Sistema.md>). Detalle en [SOP Skills](<00 Sistema/SOP Skills.md>) §13.
Registro permanente de cambios estructurales: [CHANGELOG del Sistema](<00 Sistema/CHANGELOG del Sistema.md>).
