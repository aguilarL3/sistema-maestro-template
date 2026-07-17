---
type: How-to
title: "Prompt | Búsqueda Web Estructurada (Mejores Prácticas y Errores)"
tags: [prompt, prompt-engineering, ai, busqueda-web, claude]
origen: "[[MOC - Prompt Engineering]]"
fecha_creacion: 2026-06-24
fecha_actualizacion: 2026-06-24
modelo_objetivo: claude
version_modelo: claude-sonnet-4.6
categoria: Prompt Engineering
subcategoria: Búsqueda Web e Investigación
caso_uso: Investigación estructurada de mejores prácticas y errores en un dominio profesional
tecnicas: [structured-output, role-prompting, constraints]
domains: []
version: v2.0
estado: 🟦 En pruebas
performance: ⭐⭐⭐⭐
resource:
---

# Prompt | Búsqueda Web Estructurada (Mejores Prácticas y Errores)

> **TL;DR:** Pide a Claude una investigación web estructurada sobre mejores prácticas y errores comunes en un dominio profesional, devolviendo un análisis priorizado con fuentes citadas. Pensado para reemplazar 2-3 horas de búsqueda manual por una síntesis accionable en minutos.

---

## 🎯 Objetivo

Convertir información dispersa en internet en un análisis profesional estructurado que sirva para tomar decisiones — específicamente, identificar qué prácticas adoptar y qué errores evitar en un dominio concreto.

- **Input esperado:** un dominio profesional o caso de uso (ej. "propuestas comerciales para agencias de SMM").
- **Output esperado:** documento markdown estructurado con mejores prácticas priorizadas, errores comunes y fuentes citadas.
- **Usuario / Rol que lo ejecuta:** profesional que necesita investigar un dominio antes de actuar (analista, consultor, líder de equipo, emprendedor).

---

## 🧩 Contexto de uso

- **¿Cuándo usarlo?** Antes de armar una propuesta, un proceso interno, un material de venta o cualquier entregable donde haya un cuerpo de "mejores prácticas" externas que conviene revisar.
- **¿Cuándo NO usarlo?** Para datos cuantitativos críticos donde la precisión numérica es indispensable (ahí conviene ir directo a fuentes primarias). Tampoco para preguntas donde el conocimiento interno del modelo ya alcanza y no se necesita información actualizada.
- **Dependencias / Prerrequisitos:** Modo de búsqueda web activado en Claude (verificar en el ícono `+` de la caja de prompt).
- **Sistema o flujo donde se integra:** workflow de investigación → síntesis → validación humana → decisión.

---

## 🧠 Técnicas aplicadas

| Técnica | Por qué se usa aquí |
|---|---|
| Role prompting | Ancla la perspectiva del modelo en un perfil experto, mejora la especificidad de las recomendaciones |
| Structured output | Define la estructura exacta de la respuesta (TL;DR, tablas, secciones) — reduce variabilidad |
| Constraints explícitos | Limita la respuesta a fuentes recientes, exige citación, marca contradicciones |
| Criterios de priorización | Pide ordenar las prácticas por impacto, no como una lista plana |

---

## 📐 Estructura del prompt

Bloques que componen la versión mejorada y por qué cada uno:

1. **Rol / Persona** — perfil experto que ancla el tono y la perspectiva.
2. **Contexto** — quién pregunta, qué problema tiene, por qué importa.
3. **Tarea** — instrucción principal, desglosada en subobjetivos numerados.
4. **Restricciones** — fuentes, recencia, manejo de contradicciones.
5. **Formato de salida** — esquema markdown literal, con columnas de tablas definidas.

---

## 📝 Prompt

### 🟡 v1.0 — Versión original (de la clase)

````markdown
Realizá una búsqueda en internet y averiguá, de forma estructurada, cuáles son las mejores prácticas para crear propuestas comerciales para una agencia de gestión de redes sociales para empresas.

¿Qué debe incluir toda propuesta profesional para aumentar la tasa de cierre y cuáles son los errores más comunes que provocan que una propuesta sea rechazada?
````

### 🟢 v2.0 — Versión mejorada

````markdown
[ROL]
Actuá como consultor experto en ventas B2B de servicios de marketing digital, con experiencia validando y revisando propuestas comerciales para agencias de gestión de redes sociales.

[CONTEXTO]
Trabajo en una agencia de gestión de redes sociales que vende servicios mensuales (community management, paid media, contenido) a empresas medianas. Estamos perdiendo oportunidades en la etapa de propuesta y queremos profesionalizar el documento que enviamos al cliente.

[TAREA]
Realizá una búsqueda actualizada en internet (idealmente fuentes de los últimos 24 meses, de medios o autores reconocidos del sector) y entregame una investigación estructurada sobre:

1. Las mejores prácticas para crear propuestas comerciales en agencias de SMM, priorizadas por impacto esperado en la tasa de cierre.
2. Los elementos imprescindibles que toda propuesta profesional debería incluir (estructura, secciones, datos, formato).
3. Los errores más comunes que llevan al rechazo de una propuesta — con ejemplos concretos cuando sea posible.

[RESTRICCIONES]
- Citá las fuentes con link y fecha al final (mínimo 3 fuentes independientes).
- Diferenciá entre prácticas validadas por evidencia (estudios, datos, casos) y opiniones generalizadas de la industria.
- Si encontrás información contradictoria entre fuentes, marcala explícitamente.

[FORMATO DE SALIDA]
Devolveme un documento markdown con esta estructura exacta:

## TL;DR
3 bullets con los hallazgos más críticos.

## Mejores prácticas (priorizadas)
Tabla con columnas: Práctica | Impacto esperado | Por qué funciona | Fuente.

## Elementos imprescindibles de una propuesta
Lista numerada. Para cada elemento: explicación breve (2-3 líneas) y un ejemplo concreto.

## Errores comunes (qué evitar)
Tabla con columnas: Error | Por qué falla | Cómo evitarlo.

## Próximos pasos sugeridos
3-5 acciones concretas que podría implementar esta semana.

## Fuentes consultadas
Lista de links con título, autor/medio y fecha de publicación.
````

---

## 🔧 Variables / Placeholders

Las variables son las que conviene parametrizar para reutilizar el prompt en otros dominios:

| Variable | Tipo | Descripción | Ejemplo |
|---|---|---|---|
| `{rol_experto}` | string | Perfil que se le asigna al modelo | "consultor experto en ventas B2B de servicios de marketing digital" |
| `{contexto_negocio}` | string | Quién pregunta y qué problema tiene | "agencia de gestión de redes sociales que pierde oportunidades en la etapa de propuesta" |
| `{tema_investigacion}` | string | El dominio concreto a investigar | "propuestas comerciales para agencias de SMM" |
| `{ventana_temporal}` | string | Recencia exigida a las fuentes | "últimos 24 meses" |
| `{min_fuentes}` | int | Cantidad mínima de fuentes independientes | 3 |

---

## 🧪 Ejemplo de uso

### Input
Ver bloque del prompt v2.0 arriba (los valores ya están reemplazados para el caso de agencias de SMM).

### Output esperado
Documento markdown con las secciones definidas: TL;DR, tabla de prácticas priorizadas, lista numerada de elementos imprescindibles, tabla de errores comunes, próximos pasos y lista de fuentes con link y fecha.

### Output real obtenido
_Pendiente — sin pruebas formales realizadas todavía. A completar tras la primera ejecución._

---

## 🎲 Casos de prueba

| # | Input | Output esperado | Resultado | Notas |
|---|---|---|---|---|
| 1 | Caso de la clase (SMM) | Estructura completa con fuentes | ⏳ | Pendiente de probar |
| 2 | Variar dominio (ej. propuestas de servicios contables) | Misma estructura, contenido del nuevo dominio | ⏳ | Verifica reutilización |
| 3 | Dominio nicho con poca info pública | Modelo debería declarar limitaciones, no inventar | ⏳ | Test de honestidad |

---

## 📊 Métricas / Evaluación

- **Criterios de éxito:**
  - ¿Devuelve la estructura exacta solicitada?
  - ¿Cita al menos 3 fuentes independientes con link y fecha?
  - ¿Diferencia evidencia de opinión?
  - ¿Las recomendaciones son accionables (no genéricas)?
- **Métricas cualitativas:** utilidad percibida del informe, ahorro de tiempo vs. búsqueda manual.
- **Tokens estimados:** sin medir todavía (probable ~400 input / 1500-2500 output según extensión de fuentes).

> [!tip] Buenas prácticas
> - Antes de marcarlo como Productivo, probarlo en 3-5 dominios distintos para validar reutilización.
> - Si el modelo cita fuentes desactualizadas, reforzar la ventana temporal en `[RESTRICCIONES]`.
> - Para temas muy técnicos, agregar al rol una especialización ("consultor experto en X con foco en industria Y").

> [!warning] Errores comunes
> - Esperar que el modelo "sepa" el contexto del negocio si no se lo da — el bloque `[CONTEXTO]` no es opcional.
> - Olvidar pedir fuentes con fecha — sin fecha, no se puede juzgar la vigencia.
> - Dejar el formato de salida vago ("estructurado") en lugar de definir secciones y columnas exactas.

---

## 🔄 Iteraciones / Versionado

| Versión | Fecha | Cambio | Motivo | Resultado |
|---|---|---|---|---|
| v1.0 | 2026-06-24 | Versión original de la clase | Baseline | Funcional pero genérico — falta rol, contexto, formato exacto y fuentes |
| v2.0 | 2026-06-24 | Refactor completo a estructura con bloques (ROL / CONTEXTO / TAREA / RESTRICCIONES / FORMATO) | Cubrir las cuatro dimensiones de un buen prompt de búsqueda (tema, objetivo, criterio, formato) y reducir variabilidad | A validar en uso |

### Qué se mejoró de v1.0 a v2.0 y por qué

1. **Rol explícito.** La versión original no define el rol del modelo. La mejorada usa role prompting para anclar la perspectiva ("consultor experto en ventas B2B de servicios de marketing digital"), lo que mejora la especificidad de las recomendaciones y el tono profesional.

2. **Contexto del problema.** La original no aclara desde dónde se pregunta. La mejorada explica que es una agencia que está perdiendo oportunidades en la etapa de propuesta — esto permite que Claude calibre el nivel de detalle, asuma el contexto B2B y priorice prácticas accionables sobre teoría genérica.

3. **Criterio de análisis explícito.** La original pide "mejores prácticas" y "errores comunes" pero no indica cómo organizarlos. La mejorada agrega tres criterios duros: priorización por impacto, diferenciación entre evidencia y opinión, y manejo explícito de contradicciones entre fuentes.

4. **Formato de salida específico.** La original dice "de forma estructurada" — vago. La mejorada define el esquema exacto: TL;DR, tablas con columnas explícitas, lista numerada con ejemplos, próximos pasos accionables, fuentes con metadata. Esto reduce variabilidad entre ejecuciones y aumenta la utilidad del output.

5. **Recencia de fuentes.** La original no establece ventana temporal. La mejorada exige fuentes de los últimos 24 meses — relevante porque en marketing digital las prácticas cambian rápido y una recomendación de hace 5 años puede estar obsoleta.

6. **Pedido explícito de fuentes con metadata.** La original no menciona fuentes. La mejorada exige mínimo 3 independientes, con link, autor/medio y fecha. Sin esto, no se puede auditar ni validar la información.

7. **Sección "Próximos pasos sugeridos".** Se añade para transformar la investigación en algo accionable inmediatamente — el output deja de ser un informe pasivo y pasa a ser un input directo para la siguiente acción.

---

## 🧬 Variantes / Alternativas

- **Variante A — Sin sección "Próximos pasos":** útil cuando solo se quiere investigar sin compromiso de acción inmediata.
- **Variante B — Solo errores comunes:** versión recortada cuando ya se tiene un proceso y solo se quiere auditar puntos débiles.
- **Variante C — Con foco geográfico:** agregar al `[CONTEXTO]` el mercado específico (ej. "agencia con clientes en Argentina") para sesgar fuentes y prácticas a esa región.

---

## 🚫 Limitaciones conocidas

- Depende del modo de búsqueda web activado — sin eso, el modelo responde con conocimiento interno y los resultados pierden recencia.
- Para dominios muy nicho o con poca presencia en internet, la cantidad/calidad de fuentes puede ser insuficiente y el modelo puede "inventar" para completar la estructura. **Validación humana obligatoria** sobre datos críticos.
- El criterio de "impacto esperado" en la tabla de mejores prácticas es subjetivo del modelo — útil como ordenamiento sugerido, no como verdad absoluta.

---

## 🔗 Prompts relacionados

_Pendiente — a completar a medida que se incorporen más prompts del curso al vault._

---

## 📚 Conceptos extraídos → Knowledge

> [!tip] Regla de extracción
> Soberanía conceptual: solo lo que aparece 3+ veces, conecta áreas o tiene alto valor práctico merece nota atómica.

- [[Anatomía de un prompt de búsqueda]] → tema + objetivo + criterio de análisis + formato de salida
- [[Role prompting]] → técnica de anclaje de perspectiva en el modelo
- [[Structured output]] → técnica de definición de esquema exacto de respuesta
- [[Búsqueda Web con IA]] → diferencias con búsqueda tradicional, criterios de calidad

---

## 📖 Referencias

- Clase de origen: Clase 1.2 - Mecanismo de Búsqueda
- Documentación oficial de Claude sobre búsqueda web (a agregar el link cuando se confirme la URL en docs.claude.com).

---

## 🗒️ Notas Personales

---

◀ Prompt Anterior | MOC: [[MOC - Prompt Engineering]] | Prompt Siguiente ▶
