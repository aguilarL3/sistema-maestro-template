---
tipo_doc: Explanation
tags: [llm, wiki, knowledge, sistema]
life_areas: [profesional]
domains: [ia, conocimiento, arquitectura]
goals: [sistema_portable]
habits: [documentar]
projects: []
sources: [Andrej Karpathy]
estado: 🟢 Activo
fecha_creacion: 2026-06-17
ultima_revision: 2026-06-26
id: "EXP-014"
---

# LLM Wiki

## Qué es
Una arquitectura de conocimiento persistente, mantenida incrementalmente por IA. Propuesta por Andrej Karpathy como alternativa a los sistemas RAG.

## Diferencia fundamental vs RAG
Los sistemas RAG redescubren la misma información en cada consulta.
LLM Wiki la compila una sola vez y la mantiene actualizada.

> "La wiki es un artefacto persistente y compuesto."

El LLM no es un buscador. Es un bibliotecario disciplinado que actualiza referencias cruzadas, revisa síntesis y señala contradicciones de forma continua.

## Conexión histórica
Relacionado con el **Memex de Vannevar Bush (1945)**: almacén personal curado con conexiones asociativas entre documentos. Bush no resolvió quién mantiene ese sistema cuando el usuario se cansa. Karpathy resolvió ese problema con IA.

> "El costo de mantenimiento es cercano a cero."

Los humanos pierden wikis por fatiga. Las IA no se aburren de actualizar referencias cruzadas.

## Las 3 capas de arquitectura

### 1. Fuentes Raw (inmutables)
- documentos, artículos, libros, papers, datos
- el LLM lee pero nunca modifica
- fuente de verdad única

### 2. Wiki (mantenida por LLM)
- archivos markdown interconectados
- páginas de entidades y conceptos
- síntesis y overviews
- índices y logs

### 3. Schema (CLAUDE.md / AGENTS.md)
- configuración de convenciones
- define flujos de ingesta, consulta y mantenimiento
- instruye al LLM sobre cómo comportarse como bibliotecario

## Flujos operacionales

**Ingest:** nuevas fuentes se integran actualizando múltiples páginas del wiki simultáneamente, no solo indexándose.

**Query:** el LLM busca páginas relevantes y sintetiza respuestas. Las buenas respuestas se archivan como nuevas páginas.

**Lint:** chequeos periódicos buscan contradicciones, claims obsoletos, páginas huérfanas y vacíos de datos.

## Qué problema resuelve
Evita tratar la IA como un buscador sin contexto. La convierte en una herramienta que trabaja sobre una base organizada y que crece con el tiempo.

## Qué adoptamos en este vault
- `06 Raw`
- `04 Knowledge`
- `00 Sistema`
- `01 Index`
- `AGENTS.md`

## Relación con otros marcos
- conecta con Cerebro Digital
- conecta con Zettelkasten
- conecta con Career OS
- conecta con CE-RE-BRO

## Uso en este vault
LLM Wiki es la arquitectura base moderna que explica cómo una IA puede trabajar con un vault vivo.
