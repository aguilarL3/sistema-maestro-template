---
type: How-to
title: "SOP Conectores"
tags: [sop, conectores, ia, integraciones]
estado: 🟢 Activo
prioridad: 🔥 Alta
responsable: "{{OWNER}}"
id: "SOP-CONECT-001"
generated:
  by: human:{{OWNER}}
  at: 2026-06-26T00:00:00Z
fecha_creacion: 2026-06-26
resource:
---

>[!info] Documentación relacionada
>[SOP Interoperabilidad IA](<SOP Interoperabilidad IA.md>) | [SOP Compartir Archivos](<SOP Compartir Archivos.md>) | [Blueprint de Sistemas](<Blueprint de Sistemas.md>) | [AGENTS](<../AGENTS.md>) | [Glosario de términos](<Glosario de términos.md>)

# SOP Conectores

## Objetivo

Definir **cómo documentar un sistema externo** (Notion, Google Drive, OneDrive, un ERP a futuro) para que cualquier IA lo entienda y pueda operar sobre él sin explorar a ciegas.

Un **conector** es el puente entre el Sistema Maestro y una herramienta externa. Este SOP cubre **la documentación del conector** (la capa Arquitectura del [SOP Interoperabilidad IA](<SOP Interoperabilidad IA.md>)). El *cómo se conecta técnicamente* (MCP, permisos) es responsabilidad de cada herramienta.

> **Regla:** un conector no documentado es un conector que la IA tiene que adivinar. Documentar = convertir "explorar" en "consultar".

---

## 1. Qué es un conector en este sistema

| | Conector | Recurso |
|---|---|---|
| Qué es | Puente a un sistema externo vivo | Archivo o enlace estático |
| Ejemplo | Notion (vía MCP), Google Drive | Un PDF, una URL guardada |
| Cambia solo | Sí — la fuente externa muta | No — es una captura |
| Se documenta en | `04 Knowledge/Conectores/` | `06 Raw/` o nota con enlace |

**Regla:** si la IA puede *leer o escribir en vivo* sobre el sistema, es un conector. Si solo lee una copia estática, es un recurso.

---

## 2. Ubicación y naming

```
04 Knowledge/Conectores/{Sistema} - Arquitectura.md
```

Ejemplos válidos:
- `Notion - Arquitectura.md`
- `Google Drive - Arquitectura.md`
- `ERP - Arquitectura.md`

Formato: `{Nombre del Sistema} - Arquitectura.md`. Un archivo por sistema externo.

---

## 3. Estructura mínima de un doc de conector

Todo doc en `Conectores/` debe tener estas secciones (ver [Notion - Arquitectura](<../04 Knowledge/Conectores/Notion - Arquitectura.md>) como ejemplo completo):

| Sección | Qué contiene | Por qué |
|---|---|---|
| **Frontmatter** | `tags`, `estado`, `generated` | La frescura se mide contra `generated.at` |
| **Modelo / ERD** | Diagrama de entidades y relaciones | La IA entiende la estructura de un vistazo |
| **Diccionario** | Cada entidad y campo, tipo y propósito | La IA sabe qué puede leer/escribir |
| **Mapa de dependencias** | Cómo se relacionan las partes | Evita romper relaciones al operar |
| **Convenciones** | Naming, formatos, reglas del sistema | La IA respeta el estilo existente |
| **Deuda técnica** | Problemas conocidos, relaciones huérfanas | La IA no tropieza con lo ya detectado |
| **Changelog** | Fecha · qué cambió · motivo | La capa Estado: qué pasó desde la última vez |

---

## 4. Regla de oro: documentar solo lo que no se infiere

No documentes lo que la IA puede ver mirando el sistema en vivo. Documentá lo que **no es evidente**:

- Por qué un campo existe (intención, no solo tipo)
- Relaciones huérfanas o trampas conocidas
- Convenciones implícitas que no están en el schema
- Decisiones de diseño que parecen raras pero tienen razón

Un agente que lee el schema en vivo siempre tendrá los datos frescos. El doc aporta el **porqué**, no el **qué**.

---

## 5. Ciclo de vida de un conector

| Estado | Significado | Acción |
|---|---|---|
| 🟨 Borrador | Sistema relevado pero doc incompleto | Completar las 7 secciones del §3 |
| 🟩 Activo | Doc completo y en uso | Mantener changelog al día |
| 🟥 Deprecado | El sistema externo dejó de usarse | Mover a `99 Archivo/Conectores/` |

---

## 6. Cuándo actualizar el doc

Actualizá el doc del conector (y su `generated.at` + changelog) cuando:

- Cambiás la estructura del sistema externo (nuevo campo, nueva base, relación)
- Detectás una nueva trampa o deuda técnica
- El sistema cambia de credenciales, permisos o forma de acceso

El [Skill - Mantenimiento Sistema](<../04 Knowledge/Skills/Skill - Mantenimiento Sistema.md>) marca los docs cuyo `generated.at` lleva +90 días sin tocarse.

---

## 7. Errores comunes

| Error | Por qué falla | Cómo evitarlo |
|---|---|---|
| Documentar el schema campo por campo sin el porqué | La IA ya ve el schema en vivo — es ruido | Documentar intención y trampas, no datos |
| No registrar la deuda técnica | La IA tropieza con problemas ya conocidos | Sección de deuda siempre presente |
| Conector sin changelog | No hay capa Estado — se repite trabajo | Una línea por cambio, siempre |
| Mezclar conector con recurso | Confunde lo vivo con lo estático | Aplicar el test del §1 |

---

## 8. Flujo completo

```
Nuevo sistema externo a conectar (Notion / Drive / ERP)
↓
¿Es conector o recurso? (test §1)
  └─ Recurso → 06 Raw / nota con enlace. Fin.
  └─ Conector → seguir
↓
Crear 04 Knowledge/Conectores/{Sistema} - Arquitectura.md
  └─ Estado: Borrador
↓
Completar las 7 secciones (§3)
  └─ Estado: Activo
↓
Enlazar desde SOP Interoperabilidad IA y desde llms.txt
↓
Skill - Mantenimiento Sistema audita frescura periódicamente
↓
Si el sistema se abandona → 99 Archivo/Conectores/
```

---

## Referencias

- [SOP Interoperabilidad IA](<SOP Interoperabilidad IA.md>)
- [SOP Compartir Archivos](<SOP Compartir Archivos.md>)
- [Blueprint de Sistemas](<Blueprint de Sistemas.md>)
- [Notion - Arquitectura](<../04 Knowledge/Conectores/Notion - Arquitectura.md>)
- [Skill - Mantenimiento Sistema](<../04 Knowledge/Skills/Skill - Mantenimiento Sistema.md>)
- [AGENTS](<../AGENTS.md>)
- [Glosario de términos](<Glosario de términos.md>)

## Cómo leer este SOP
Primero el test conector-vs-recurso (§1). Luego la estructura mínima (§3) y la regla de oro (§4). El resto se consulta al crear o mantener un conector.
