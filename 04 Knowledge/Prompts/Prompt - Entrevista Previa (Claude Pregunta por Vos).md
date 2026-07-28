---
type: How-to
title: "Prompt | Entrevista Previa (Claude Pregunta por Vos)"
tags: [prompt, prompt-engineering, ai, patron-reutilizable, claude]
origen: "[[MOC - Prompt Engineering]]"
fecha_creacion: 2026-06-24
generated:
  by: human:{{OWNER}}
  at: 2026-06-24T00:00:00Z
fecha_actualizacion: 2026-06-24
modelo_objetivo: claude
version_modelo: claude-sonnet-4.6
categoria: Prompt Engineering
subcategoria: Patrones Reutilizables
caso_uso: Pedirle a Claude que entreviste al usuario antes de generar un entregable, cuando no se tiene claro qué contexto incluir
tecnicas: [meta-prompting, structured-output, role-prompting]
domains: []
version: v2.0
estado: 🟦 En pruebas
performance: ⭐⭐⭐⭐
resource:
---

# Prompt | Entrevista Previa (Claude Pregunta por Vos)

> **TL;DR:** Patrón reutilizable para invertir el flujo de la conversación: en vez de que el usuario escriba un prompt completo, Claude entrevista al usuario primero, identifica los huecos de contexto y solo después genera el entregable. Útil cuando no se sabe qué información incluir.

---

## 🎯 Objetivo

Transformar una idea vaga en un pedido preciso, dejando que el modelo descubra qué información necesita en lugar de obligar al usuario a anticiparla.

- **Input esperado:** un objetivo de alto nivel ("quiero hacer X") sin contexto detallado.
- **Output esperado:** un set de preguntas estructuradas que el usuario responde antes de que Claude empiece a generar el entregable.
- **Usuario / Rol que lo ejecuta:** cualquiera que necesite generar un entregable complejo y no tenga claro qué contexto darle al modelo.

---

## 🧩 Contexto de uso

- **¿Cuándo usarlo?** Entregables que dependen mucho del contexto (propuestas, planes, estrategias, análisis personalizados) cuando el usuario tiene la idea general pero no sabe qué detalles importan.
- **¿Cuándo NO usarlo?** Tareas mecánicas donde no hay duda de qué información incluir (resumir un texto que ya se pegó, traducir, formatear). Acá agrega fricción sin valor.
- **Dependencias / Prerrequisitos:** ninguno especial — funciona en cualquier conversación.
- **Sistema o flujo donde se integra:** workflow general de uso de IA — entrevista previa → respuestas del usuario → generación del entregable → iteración.

---

## 🧠 Técnicas aplicadas

| Técnica | Por qué se usa aquí |
|---|---|
| Meta-prompting | El prompt no pide el entregable directo, pide preparación para el entregable |
| Role prompting | Define la perspectiva desde la que el modelo va a preguntar |
| Structured output | Pide preguntas agrupadas y priorizadas, no una lista desordenada |
| Constraint de pausa | Bloquea al modelo de empezar a generar antes de tener las respuestas |

---

## 📐 Estructura del prompt

Bloques de la versión optimizada y función de cada uno:

1. **Rol / Persona** — qué tipo de experto está haciendo las preguntas.
2. **Contexto** — qué entregable se va a producir y por qué se necesita la entrevista.
3. **Tarea** — pedir las preguntas necesarias antes de generar.
4. **Restricciones** — agrupación, priorización, cantidad máxima, prohibición de avanzar sin respuestas.

---

## 📝 Prompt

### 🟡 v1.0 — Versión original (de la clase)

````markdown
Antes de comenzar, haceme las preguntas necesarias para que puedas elaborar una propuesta comercial personalizada y de alta calidad.
````

### 🟢 v2.0 — Versión optimizada (patrón reutilizable)

````markdown
[ROL]
Actuá como {rol_experto}. Tu trabajo no es generar el entregable todavía — es asegurarte de tener toda la información necesaria para que el resultado sea de alta calidad.

[CONTEXTO]
Necesito producir {entregable} y todavía no tengo claro qué información debería darte para que el resultado sea bueno. Quiero que tomes vos la iniciativa de averiguar lo que falta.

[TAREA]
Antes de empezar a generar la respuesta, hacéme las preguntas necesarias para tener un entendimiento profundo del caso. Quiero que pienses como un consultor que recibe un brief incompleto y necesita aclararlo antes de empezar a trabajar.

[RESTRICCIONES]
- **Agrupá las preguntas por categoría** (ej. información sobre mí o mi empresa, sobre el cliente o la audiencia, sobre el objetivo, sobre restricciones técnicas o de formato).
- **Priorizá** marcando cuáles son críticas (sin esto no se puede avanzar) y cuáles son nice-to-have.
- **Máximo 8-10 preguntas en total** para no sobrecargar la conversación. Si necesitás más, dividilas en rondas.
- **No empieces a generar el entregable** hasta que yo te haya respondido las preguntas críticas.
- Si algo del contexto se puede inferir con cierta seguridad, decímelo en lugar de preguntarlo (ej. "asumo que el cliente es B2B, corregime si no").

[FORMATO DE SALIDA]
## Preguntas críticas
1. [pregunta] — _categoría: [...]_
2. ...

## Preguntas nice-to-have
1. ...

## Supuestos que voy a asumir si no me corregís
- ...
````

---

## 🔧 Variables / Placeholders

| Variable | Tipo | Descripción | Ejemplo |
|---|---|---|---|
| `{rol_experto}` | string | Perfil del experto que pregunta | "consultor en ventas B2B" |
| `{entregable}` | string | Qué se va a producir después de la entrevista | "una propuesta comercial para un cliente nuevo" |

---

## 🧪 Ejemplo de uso

### Input
````
[ROL]
Actuá como consultor en ventas B2B de servicios de marketing digital.

[CONTEXTO]
Necesito producir una propuesta comercial para un cliente nuevo y todavía no tengo claro qué información debería darte para que el resultado sea bueno.

[TAREA]
Antes de empezar a generar la propuesta, hacéme las preguntas necesarias...
[el resto del prompt v2.0]
````

### Output esperado
Lista estructurada de preguntas agrupadas por categoría (sobre la agencia, sobre el cliente, sobre la decisora, sobre alcance, sobre presupuesto) y priorizadas en críticas vs. nice-to-have, sin haber empezado a redactar la propuesta.

### Output real obtenido
_Pendiente — sin pruebas formales realizadas todavía._

---

## 🎲 Casos de prueba

| # | Input | Output esperado | Resultado | Notas |
|---|---|---|---|---|
| 1 | "Quiero hacer una propuesta comercial" | 8-10 preguntas agrupadas y priorizadas, sin propuesta | ⏳ | Pendiente |
| 2 | "Quiero hacer un plan de contenidos para Instagram" | Mismas categorías adaptadas al dominio | ⏳ | Verifica reutilización |
| 3 | "Quiero un análisis de competencia" | Preguntas sobre alcance, criterios, fuentes | ⏳ | Test de adaptación a dominio analítico |

---

## 📊 Métricas / Evaluación

- **Criterios de éxito:**
  - ¿El modelo se contiene de generar el entregable antes de tener respuestas?
  - ¿Las preguntas están realmente agrupadas y priorizadas?
  - ¿Las preguntas críticas son verdaderamente bloqueantes (no podrías generar sin esa info)?
  - ¿El modelo declara supuestos en lugar de preguntar todo?
- **Métricas cualitativas:** calidad final del entregable comparado con un prompt directo sin entrevista previa.

> [!tip] Buenas prácticas
> - Usalo cuando empezás un dominio nuevo y no sabés qué contexto importa.
> - Combinalo con otros prompts: la salida de la entrevista alimenta el bloque `[CONTEXTO]` del prompt del entregable real.
> - Si el modelo igual empieza a generar antes de las respuestas, reforzá: "Pará. No quiero el entregable todavía, quiero las preguntas".

> [!warning] Errores comunes
> - Aplicarlo a tareas simples (resúmenes, traducciones) — agrega fricción sin valor.
> - Responder las preguntas con respuestas vagas — el resultado de la entrevista es tan bueno como las respuestas que se dan.
> - Olvidar el constraint de "no empieces a generar todavía" — algunos modelos arrancan igual con la respuesta esperada.

---

## 🔄 Iteraciones / Versionado

| Versión | Fecha | Cambio | Motivo | Resultado |
|---|---|---|---|---|
| v1.0 | 2026-06-24 | Versión original de la clase (una línea) | Baseline | Funcional pero el modelo puede hacer pocas preguntas, en orden arbitrario, o saltar directo al entregable |
| v2.0 | 2026-06-24 | Refactor con rol, agrupación, priorización, tope de cantidad, prohibición explícita de avanzar y pedido de declarar supuestos | Aumentar la calidad y orden de las preguntas, hacer el patrón reutilizable | A validar |

### Qué se mejoró de v1.0 a v2.0 y por qué

1. **Rol explícito.** La v1.0 no define desde qué perspectiva pregunta el modelo. La v2.0 lo encuadra como "experto en X que recibe un brief incompleto" — esto ancla el tipo de preguntas que hace (un consultor pregunta diferente a un community manager).

2. **Agrupación por categoría.** La v1.0 deja libre la organización. La v2.0 exige agrupar las preguntas (sobre el usuario, sobre el cliente/audiencia, sobre el objetivo, sobre restricciones). Esto hace el output más navegable y evita preguntas redundantes.

3. **Priorización crítica vs. nice-to-have.** La v1.0 trata todas las preguntas como iguales. La v2.0 las separa en críticas (bloqueantes) y nice-to-have, permitiendo al usuario responder solo lo necesario y arrancar antes.

4. **Tope de cantidad.** La v1.0 no limita — el modelo puede hacer 3 preguntas o 20. La v2.0 fija 8-10 máximo, con la opción de dividir en rondas si hace falta. Evita sobrecarga cognitiva.

5. **Prohibición explícita de avanzar.** Algunos modelos, ante un pedido como "hacéme preguntas para hacer X", devuelven preguntas Y a la vez una primera versión del entregable. La v2.0 lo prohíbe explícitamente.

6. **Declaración de supuestos.** La v1.0 no contempla esto. La v2.0 le pide al modelo que diga qué va a asumir si no se le corrige — esto reduce el ida y vuelta y le da al usuario la chance de objetar solo lo que importa.

7. **Formato de salida estructurado.** La v1.0 deja el formato libre. La v2.0 define secciones (críticas, nice-to-have, supuestos) — más fácil de procesar y de copiar en el siguiente prompt.

---

## 🧬 Variantes / Alternativas

- **Variante A — Una sola ronda fija de 5 preguntas:** versión más liviana para casos donde el usuario ya tiene cierta claridad y solo necesita un check.
- **Variante B — Modo conversacional (1 pregunta por turno):** el modelo va preguntando de a una en lugar de mandar el bloque entero — útil cuando se quiere descubrir el caso progresivamente.

---

## 🚫 Limitaciones conocidas

- El modelo puede preguntar cosas que el usuario "no sabe responder" — en esos casos hay que iterar pidiendo que asuma o investigue.
- En dominios muy nicho, las categorías de preguntas pueden no cubrir todo lo relevante — vale la pena revisar si falta alguna área importante.
- No reemplaza la conversación humana con un cliente real — sirve para preparar el entregable, no para entender al cliente.

---

## 🔗 Prompts relacionados

- [Prompt - Búsqueda Web Estructurada](<Prompt - Búsqueda Web Estructurada.md>) → otro patrón reutilizable del catálogo; combinable con este para investigar antes de generar.

---

## 📚 Conceptos extraídos → Knowledge

> [!tip] Regla de extracción
> Soberanía conceptual: solo lo que aparece 3+ veces, conecta áreas o tiene alto valor práctico merece nota atómica.

- [[Meta-prompting]] → pedir preparación en lugar de entregable directo
- [[Patrón Entrevista Previa]] → técnica de inversión del flujo conversacional
- [[Priorización crítica vs nice-to-have en prompts]] → mecanismo para escalar la calidad del input

---

## 📖 Referencias

- Clase de origen: la clase de origen (curso del autor)

---

## 🗒️ Notas Personales

---

◀ [Prompt - Búsqueda Web Estructurada](<Prompt - Búsqueda Web Estructurada.md>) | MOC: [[MOC - Prompt Engineering]] | Prompt Siguiente ▶
