Sos un arquitecto experto del vault Sistema Maestro de {{OWNER}}. Tu tarea es generar o actualizar el **índice del cerebro digital** — una nota de navegación que permite a cualquier agente de IA encontrar información en el vault gastando el mínimo de tokens posible.

## Qué construir

Un índice jerárquico que mapea:
- Las áreas de vida (`life_areas`: profesional, salud, finanzas, relaciones, personal)
- Los dominios de conocimiento (`domains`: BI, IA, automatización, inglés, negocios, etc.)
- Los MOCs principales como puertas de entrada
- Los archivos clave por área (no todos los archivos, solo los más relevantes)
- Las rutas recomendadas para llegar a tipos de información comunes

## Pasos

1. Leé `AGENTS.md`, `Dashboard-CEO.md` y `Home.md` si existe para entender la estructura global
2. Usá `Glob` para listar todos los archivos en `02 MOCs/`, `01 Index/` y `00 Sistema/`
3. Usá `Glob` para listar subcarpetas y archivos clave en `04 Knowledge/`
4. Usá `Read` en cada MOC para extraer su título y los temas que cubre
5. Usá `Grep` con patrón `^life_areas:` y `^domains:` para mapear qué notas cubren qué áreas
6. Construí el mapa mental de rutas: para llegar a X, ir por Y → Z

## Output

Creá o actualizá la nota `01 Index/Índice del Cerebro Digital.md` con esta estructura:

```markdown
---
tags: [index, navegacion, cerebro-digital, agente]
estado: 🟢 Activo
timestamp: 2026-06-24
---

# Índice del Cerebro Digital

> Guía de navegación para agentes de IA. Lee esto antes de buscar cualquier nota.
> Última actualización: 2026-06-24

## Cómo usar este índice

1. Identificá el área de vida o dominio relevante
2. Seguí la ruta indicada hacia el MOC correspondiente
3. Desde el MOC navegá a las notas específicas
4. Solo si no encontrás lo que buscás, explorá `04 Knowledge/` directamente

## Rutas por área de vida

### Profesional / Carrera
→ [[MOC - Carrera]] → skills, portfolio, evidencia, objetivos profesionales
→ [[MOC - Aprendizaje]] → cursos activos, metodologías de estudio

### Salud
→ [[MOC - Salud]] (si existe) → hábitos, seguimiento

### Finanzas
→ [[MOC - Finanzas]] (si existe)

### Relaciones
→ [[MOC - Relaciones]] (si existe)

### Personal / Vida
→ [[Vision]] → dirección de vida a largo plazo
→ [[Objetivos]] → metas activas
→ [[Valores]] → principios inamovibles

## Rutas por dominio de conocimiento

### IA y Automatización
→ MOC - IA con Claude → skills, prompts, agentes
→ [[04 Knowledge/Prompts/]] → catálogo de prompts
→ [[04 Knowledge/Skills/]] → skills ejecutables

### Business Intelligence / Datos
→ [[MOC - BI]] (si existe)

### Inglés
→ [[MOC - Inglés]] (si existe)

### Sistemas y metodologías
→ [[04 Knowledge/Sistemas y Metodologías/]] → GTD, PARA, Zettelkasten, CE-RE-BRO

## Archivos raíz clave

| Archivo | Para qué |
|---|---|
| [[AGENTS.md]] | Onboarding de cualquier IA al vault |
| [[Dashboard-CEO.md]] | Vista operativa rápida |
| [[SOP Maestro.md]] | Entender el sistema completo |
| [[Glosario de términos]] | Vocabulario del vault |

## MOCs disponibles

[lista generada automáticamente desde 02 MOCs/]

## Proyectos activos

[lista desde 03 Proyectos/ con estado activo]

## Notas evergreen más enlazadas

[top 10 notas con más links entrantes en 04 Knowledge/]
```

## Restricciones

- Si `01 Index/Índice del Cerebro Digital.md` ya existe, actualizarlo sin borrar lo que tenía a menos que esté desactualizado
- No inventar rutas que no existen — solo mapear lo que realmente está en el vault
- Si un MOC referenciado no existe, marcarlo como `(pendiente)` en vez de omitirlo
- Mantener el índice breve y navigable — no es una nota de contenido, es una guía

$ARGUMENTS
