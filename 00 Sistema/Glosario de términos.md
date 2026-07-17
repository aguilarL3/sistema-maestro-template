---
type: Reference
title: "Glosario de términos"
tags: [glosario, sistema, onboarding]
estado: 🟢 Activo
fecha_creacion: 2026-06-17
timestamp: 2026-06-26T00:00:00Z
id: "REF-001"
resource:
---

# Glosario de términos

Este glosario explica los términos que aparecen en el vault y cómo se usan aquí.

## AGENTS.md
Archivo raíz de instrucciones para humanos e IA. Explica el propósito del vault, sus reglas y su arquitectura.

## Index
Capa de navegación. No guarda conocimiento profundo; orienta, conecta y permite llegar rápido a lo importante.

## MOC
Map of Content. Página de navegación y síntesis que agrupa notas relacionadas de un tema.

## Nota atómica
Nota pequeña con una sola idea principal, clara, reutilizable y enlazable.

## Evergreen note
Nota viva que se revisa y se actualiza con el tiempo para que el conocimiento no se quede congelado.

## Raw
Fuentes originales sin procesar: libros, PDFs, capturas, audios, artículos, webs, referencias o materiales crudos.

## Knowledge
Conocimiento ya procesado. Vive como notas reutilizables, conectadas y pensadas para volver a usarse.

## Diario
Registro del día. Sirve para hábitos, tareas, preocupaciones, predicciones, reflexiones, aprendizaje y revisión de vida.

## GPT / IA / LLM
Herramientas de inteligencia artificial usadas para resumir, analizar, proponer y acelerar el trabajo.

## GTD
Getting Things Done. Método de captura, clarificación, organización, revisión y ejecución.

## PARA
Projects, Areas, Resources, Archives. Sistema de clasificación práctica de la información.

## Zettelkasten
Sistema de notas enlazadas. En digital se conserva su lógica de atomicidad y conectividad.

## LLM Wiki
Arquitectura de conocimiento mantenida por IA. Se apoya en fuentes, wiki, schema, index y agentes.

## Conector
Puente entre el Sistema Maestro y una herramienta externa viva (Notion, Google Drive, ERP). A diferencia de un recurso (estático), un conector permite leer o escribir en vivo. Se documenta en `04 Knowledge/Conectores/`. Ver [SOP Conectores](<SOP Conectores.md>).

## Interoperabilidad IA
Capacidad de que cualquier IA (Claude, GPT, Gemini, agentes) entienda y opere sobre un sistema siguiendo convenciones predecibles, sin adivinar dónde está la información. Se rige por 5 capas: Ley, Mapa, Estado, Arquitectura, Capacidad. Ver [SOP Interoperabilidad IA](<SOP Interoperabilidad IA.md>).

## llms.txt
Archivo raíz que actúa como mapa para IAs: les dice qué leer y en qué orden antes de operar sobre un sistema. Equivale a un `robots.txt` pero para agentes de IA.

## Blueprint de Sistemas
Plantilla reutilizable para armar un sistema nuevo legible por IA desde cero. Es la versión accionable del [SOP Interoperabilidad IA](<SOP Interoperabilidad IA.md>). Ver [Blueprint de Sistemas](<Blueprint de Sistemas.md>).

## LLM-as-Judge
Patrón donde un modelo de IA evalúa la salida de otro según dimensiones definidas (relevancia, exactitud, consistencia). Base del Nivel 2 del [Skill - Mantenimiento Sistema](<../04 Knowledge/Skills/Skill - Mantenimiento Sistema.md>). Best practice 2026: fijar la versión del modelo-juez y validar con criterio humano.

## Agent-as-Judge
Variante del LLM-as-Judge donde el juez es un agente con herramientas que evalúa la *trayectoria* completa (no solo el resultado final), cruzando un doc contra el resto del sistema y contra buenas prácticas actuales.

## Drift de consistencia
Desalineación entre el contenido de un doc y las convenciones vigentes del sistema, sin que la fecha lo refleje. Un doc puede estar "fresco" (revisado hace poco) y aun así apuntar a una carpeta o convención que ya cambió. Lo detecta el Nivel 1 (heurístico) del [Skill - Mantenimiento Sistema](<../04 Knowledge/Skills/Skill - Mantenimiento Sistema.md>).

## Obsolescencia de criterio
Cuando el contenido de un doc queda conceptualmente atrasado respecto al estado del arte, aunque su estructura y fecha estén bien. Necesita un ojo externo (juez LLM + búsqueda web) para detectarse, no basta la fecha. La cubre el Nivel 2 del [Skill - Mantenimiento Sistema](<../04 Knowledge/Skills/Skill - Mantenimiento Sistema.md>).

## Eval
Prueba objetiva y repetible de la calidad de una capacidad de IA. A diferencia de un test de software (pasa/falla determinista), mide dimensiones difusas (relevancia, exactitud, consistencia) y suele necesitar un juez. Ver [Ciclo de Vida de Capacidades IA](<../04 Knowledge/Sistemas y Metodologías/Ciclo de Vida de Capacidades IA.md>).

## Golden dataset
Conjunto fijo de casos con su respuesta correcta, usado para evaluar cada versión nueva de una capacidad y compararla contra la actual. Es el "set de exámenes" de una skill/prompt/agente.

## SemVer
Versionado semántico: Major.Minor.Patch. Major = cambio incompatible; Minor = funcionalidad nueva compatible; Patch = arreglo menor. Estándar para versionar capacidades de IA. Ver [Ciclo de Vida de Capacidades IA](<../04 Knowledge/Sistemas y Metodologías/Ciclo de Vida de Capacidades IA.md>).

## Discovery (Investigación Previa)
Fase 0 antes de construir cualquier cosa: averiguar si ya existe, si hay doc oficial, y decidir build/buy/adopt. Evita reinventar y descifrar lo ya documentado. Ver [SOP Discovery](<SOP Discovery.md>) y [Investigación Previa (Discovery)](<../04 Knowledge/Sistemas y Metodologías/Investigación Previa (Discovery).md>).

## Spike
Investigación técnica timeboxed (1-3 días) para responder una duda concreta y decidir el approach, a veces construyendo un prototipo desechable. Antídoto contra la parálisis por análisis.

## Prior Art
Lo que ya existe sobre un tema: productos, repos, papers, soluciones. Buscarlo antes de construir es el primer paso del Discovery.

## Build vs Buy
Decisión explícita entre construir, comprar o adoptar algo existente. Lente recomendada: costo total a 5 años. Debe ser explícita, no un reflejo.

## RTFM
"Read the manual": leer la documentación oficial **antes** de improvisar. El caso Notion fue un RTFM saltado.

## Parálisis por análisis
Investigar para siempre y nunca construir. Antídoto: timebox fijo + "investigar lo suficiente para decidir, no para estar seguro". Ver [Investigación Previa (Discovery)](<../04 Knowledge/Sistemas y Metodologías/Investigación Previa (Discovery).md>) §3.

## Career OS
Sistema orientado a carrera profesional, portafolio, CV, LinkedIn, entrevistas, experiencia y evidencia.

## CE-RE-BRO
Marco de auditoría:
- Conectar
- Reagrupar
- Descomponer

## Valores
Lo que consideras importante de verdad en tu vida. Funciona como filtro de decisiones.

## Principios
Reglas prácticas que guían tu conducta para sostener tus valores.

## Visión
Dirección deseada de tu vida o de una etapa concreta.

## Objetivos
Resultados deseados en horizontes de tiempo concretos.

## Hábitos
Comportamientos repetidos que sostienen tus objetivos.

## Projects / Proyectos
Iniciativas con principio y fin.

## Sources
Origen o fuente de una idea, conocimiento o nota.

## Modelos mentales
Notas que explican cómo entiendes el mundo. Son transversales a temas concretos.

## Nota fuente
Nota que recoge el origen procesado de una lectura, charla, video, podcast o experiencia.

## Nota estructural
Nota de alto nivel que organiza y navega el conocimiento.

## Portfolio
Conjunto de pruebas, resultados y proyectos que demuestran capacidad real.

## Kardex / Tracker
Registro simple de seguimiento; se usa para ver avance, no para sobrecargar el sistema.

## Mapa / Territorio
La realidad no es la nota. El mapa es la representación de esa realidad en el sistema.

## Diario categórico
Diario con secciones fijas.

## Diario intersticial
Diario más libre, con menos estructura obligatoria.

## Loci
Técnica de memoria basada en lugares mentales o espacios de referencia.

## Plantilla
Documento base que ayuda a empezar sin construir todo desde cero.

## Auditoría
Revisión estructurada para detectar duplicados, huecos, errores y oportunidades de mejora.

## Onboarding
Proceso para que alguien nuevo entienda el sistema y pueda empezar a usarlo.

## Sistema operativo personal
Conjunto de notas, procesos, reglas y hábitos que ayudan a pensar, decidir, aprender y ejecutar mejor.


## Enlaces recomendados
- [00 Inicio Rapido](<../00 Inicio Rapido.md>)
- [Investigación y auditoría de marcos](<../04 Knowledge/Investigación del Sistema/Investigación y auditoría de marcos.md>)
- [MOC - Investigación del Sistema](<../02 MOCs/MOC - Investigación del Sistema.md>)
- [PARA](<../04 Knowledge/Sistemas y Metodologías/PARA.md>)
- [GTD](<../04 Knowledge/Sistemas y Metodologías/GTD.md>)
- [Zettelkasten](<../04 Knowledge/Sistemas y Metodologías/Zettelkasten.md>)
- [Evergreen Notes](<../04 Knowledge/Sistemas y Metodologías/Evergreen Notes.md>)
- [Career OS](<../04 Knowledge/Sistemas y Metodologías/Career OS.md>)
- [LLM Wiki](<../04 Knowledge/Sistemas y Metodologías/LLM Wiki.md>)
- [MOC](<../04 Knowledge/Sistemas y Metodologías/MOC.md>)
- [CE-RE-BRO](<../04 Knowledge/Sistemas y Metodologías/CE-RE-BRO.md>)
- [Cerebro Digital](<../04 Knowledge/Sistemas y Metodologías/Cerebro Digital.md>)
- [Yo SA](<../04 Knowledge/Sistemas y Metodologías/Yo SA.md>)
