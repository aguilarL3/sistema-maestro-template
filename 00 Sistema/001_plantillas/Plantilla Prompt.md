---
type: Plantilla
title: "Prompt | [Nombre del Prompt]"
tags: [prompt, prompt-engineering, ai]
estado: 🟨 Borrador / 🟦 En pruebas / 🟩 Productivo / 🟥 Deprecado
fecha_creacion: YYYY-MM-DD
generated:
  by: human:{{OWNER}}
  at: 2026-06-26T00:00:00Z
origen: "[[MOC - Prompt Engineering]]"
fecha_actualizacion: YYYY-MM-DD
modelo_objetivo: claude / gpt / gemini / otro
version_modelo: claude-sonnet-4.6
categoria: Prompt Engineering
subcategoria: ...
caso_uso: ...
tecnicas: [zero-shot, few-shot, chain-of-thought, role-prompting, structured-output]
version: v1.0
performance: ⭐⭐⭐⭐⭐
domains: []
resource:
---

# Prompt | [Nombre del Prompt]

> **TL;DR:** Una línea que describa qué hace este prompt y para quién.

---

## 🎯 Objetivo

¿Qué problema resuelve este prompt? ¿Cuál es el resultado esperado?

- **Input esperado:** ...
- **Output esperado:** ...
- **Usuario / Rol que lo ejecuta:** ...

---

## 🧩 Contexto de uso

- **¿Cuándo usarlo?** ...
- **¿Cuándo NO usarlo?** ...
- **Dependencias / Prerrequisitos:** (datos, formatos, archivos, etc.)
- **Sistema o flujo donde se integra:** ...

---

## 🧠 Técnicas aplicadas

| Técnica | Por qué se usa aquí |
|---|---|
| Role prompting | Establece tono/expertise del modelo |
| Few-shot | Muestra ejemplos para reducir ambigüedad |
| Chain-of-thought | Fuerza razonamiento paso a paso |
| Structured output (XML/JSON) | Facilita parseo automatizado |
| Constraints explícitos | Limita longitud, estilo o alcance |

---

## 📐 Estructura del prompt

Desglose por componentes (orden y función de cada bloque):

1. **Rol / Persona** — quién es el modelo
2. **Contexto** — información de fondo necesaria
3. **Tarea** — instrucción principal
4. **Restricciones** — límites de formato, tono, longitud
5. **Ejemplos** (few-shot) — pares input/output de referencia
6. **Formato de salida** — esquema esperado
7. **Variables dinámicas** — lo que se reemplaza en cada ejecución

---

## 📝 Prompt

````markdown
[ROL]
Actúa como un {experto en X} con experiencia en {Y}.

[CONTEXTO]
{contexto_dinamico}

[TAREA]
Tu tarea es {accion_principal}, considerando:
- Criterio 1
- Criterio 2
- Criterio 3

[RESTRICCIONES]
- No incluyas {X}
- Usa un tono {Y}
- Máximo {N} palabras

[EJEMPLOS]
Input: {ejemplo_input_1}
Output: {ejemplo_output_1}

[INPUT REAL]
{input_usuario}

[FORMATO DE SALIDA]
Responde en {markdown/json/xml} con esta estructura:
{esquema}
````

---

## 🔧 Variables / Placeholders

| Variable | Tipo | Descripción | Ejemplo |
|---|---|---|---|
| `{contexto_dinamico}` | string | Información de fondo del caso | "El usuario es un analista BI..." |
| `{accion_principal}` | string | Verbo + objeto de la tarea | "resumir el documento" |
| `{input_usuario}` | string/file | Lo que el usuario aporta en cada uso | "..." |
| `{N}` | int | Límite de longitud | 300 |

---

## 🧪 Ejemplo de uso

### Input
```
[ejemplo completo de input con variables reemplazadas]
```

### Output esperado
```
[respuesta ideal del modelo]
```

### Output real obtenido
```
[respuesta real en la última prueba]
```

---

## 🎲 Casos de prueba

| # | Input | Output esperado | Resultado | Notas |
|---|---|---|---|---|
| 1 | Caso típico | ... | ✅ | Funciona bien |
| 2 | Caso límite (input vacío) | Mensaje de error claro | ⚠️ | Devuelve respuesta genérica |
| 3 | Caso adversarial | Negativa cortés | ✅ | OK |

---

## 📊 Métricas / Evaluación

- **Criterios de éxito:** ¿cómo sé que funciona?
- **Métricas cuantitativas:** precisión, longitud, tiempo de respuesta, costo en tokens
- **Métricas cualitativas:** claridad, tono, utilidad percibida
- **Tokens estimados:** input ~`X` / output ~`Y`
- **Costo estimado por ejecución:** $`Z`

> [!tip] Buenas prácticas
> - Probar con al menos 5 inputs reales antes de marcarlo como Productivo
> - Versionar cada cambio relevante (ver sección de Iteraciones)
> - Documentar el modelo exacto con el que se validó (los prompts no son portables 1:1 entre modelos)

> [!warning] Errores comunes
> - Sobrecargar el prompt con instrucciones contradictorias
> - Mezclar formato en el ejemplo y formato esperado de salida
> - Olvidar especificar qué hacer cuando falta una variable
> - Asumir que el modelo "ya sabe" contexto que no se le dio

---

## 🔄 Iteraciones / Versionado

| Versión | Fecha | Cambio | Motivo | Resultado |
|---|---|---|---|---|
| v1.0 | YYYY-MM-DD | Versión inicial | — | Baseline |
| v1.1 | YYYY-MM-DD | Se agregaron 2 ejemplos few-shot | Output inconsistente en tono | Mejoró consistencia |
| v2.0 | YYYY-MM-DD | Refactor a formato XML | Necesidad de parseo automático | ✅ Productivo |

---

## 🧬 Variantes / Alternativas

- **Variante A — Sin few-shot:** más corta, útil cuando hay límite de tokens
- **Variante B — Con CoT explícito:** mejor para razonamiento complejo, mayor costo
- **Variante C — Para otro modelo:** ajustes necesarios si se migra a GPT/Gemini

---

## 🚫 Limitaciones conocidas

- No funciona bien con `{tipo de input}` porque...
- Tiende a `{comportamiento no deseado}` cuando...
- Sensible al orden de los ejemplos

---

## 🔗 Prompts relacionados

- [[Prompt - nombre relacionado 1]] → se usa antes/después en el pipeline
- [[Prompt - nombre relacionado 2]] → variante para otro caso

---

## 📚 Conceptos extraídos → Knowledge

> [!tip] Regla de extracción
> Soberanía conceptual: solo lo que aparece 3+ veces, conecta áreas o tiene alto valor práctico merece nota atómica.

- [[concepto-1]] → qué se pasó a limpio
- [[técnica-X]] → ...

---

## 📖 Referencias

- Documentación oficial: [enlace]
- Paper / artículo: [enlace]
- Inspirado en: [[otro prompt o fuente]]

---

## 🗒️ Notas Personales



---

◀ [[Prompt Anterior]] | MOC: [[MOC - Prompt Engineering]] | [[Prompt Siguiente]] ▶
