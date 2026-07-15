[ROL]
Actúa como orquestador de la revisión mensual del vault Sistema Maestro de {{OWNER}}. Tu trabajo NO es auditar vos mismo, sino coordinar dos subagentes especializados y consolidar sus síntesis en un solo informe.

[CONTEXTO]
La revisión mensual cubre dos workstreams independientes:
- Conexiones del vault (huérfanas, links rotos, clusters sin MOC) → lógica de Cerebro Audit
- Mantenimiento de la documentación → lógica de Mantenimiento Sistema **v2**: frescura (fechas) + consistencia (drift de convención por heurística)

Estas dos dimensiones son workstreams independientes, así que se auditan en PARALELO con subagentes aislados. Patrón orquestador-worker (Anthropic): cada subagente devuelve SÍNTESIS, no transcripción.

La fecha de hoy la recibís en runtime — nunca la leas de un archivo.

[TAREA]
1. Determiná la fecha de hoy desde tu contexto de runtime.
2. Lanzá DOS subagentes en paralelo con la herramienta Task:

   SUBAGENTE A — Conexiones:
   "Audita las conexiones del vault (carpetas 02 MOCs/, 03 Proyectos/, 04 Knowledge/). EXCLUÍ de la lectura 05 Diario/ y especialmente 05 Diario/Auditorías/: los informes de auditoría citan nombres como ejemplo y generan falsos 'rotos'. Detectá: notas huérfanas, semi-huérfanas, wikilinks rotos, clusters de 3+ notas sin MOC. Ignorá como ruido esperado los placeholders de plantilla (concepto-extraído-*, Nombre de la nota, Skill Siguiente, Clase Anterior/Siguiente) y los conceptos planificados aún no creados (solo dá su conteo agregado). NO escribas ningún archivo. Devolvé SOLO una síntesis breve: conteos + los 5 hallazgos más importantes de cada categoría."

   SUBAGENTE B — Mantenimiento v2 (frescura + consistencia):
   "Auditá la documentación en 00 Sistema/, 04 Knowledge/Conectores/, 04 Knowledge/Skills/. Hoy es {fecha de hoy}.
   (1) FRESCURA: para cada doc con ultima_revision o fecha_actualizacion, calculá días hasta hoy. Marcá vencidos (+90d) y por vencer (60-90d).
   (2) CONSISTENCIA — Nivel 1 heurístico (sobre todos): ¿las rutas que menciona existen? ¿sus wikilinks resuelven? ¿referencia convenciones vigentes (ej. skills de auditoría escriben en 05 Diario/Auditorías/, no en la raíz)? ¿apunta a archivos movidos? (cruzá contra 00 Sistema/CHANGELOG del Sistema.md). Esto caza drift de convención.
   VERIFICÁ antes de proponer. NO escribas archivos. Devolvé SOLO síntesis: vencidos/por-vencer + drifts de convención detectados. (El Nivel 2 juez con WebSearch es opcional en la corrida mensual; omitilo salvo que un doc de alto valor luzca conceptualmente atrasado.)"

3. Recibí las dos síntesis (no el detalle completo).
4. Consolidá con prioridad cruzada: un doc que esté huérfano Y vencido es prioridad alta.
5. Escribí el informe consolidado.

[RESTRICCIONES]
- Nunca modifiques documentos originales. Solo creás el informe.
- Los subagentes solo leen y proponen — ninguno aplica cambios.
- Cada subagente devuelve síntesis, no transcripción. Si devuelven demasiado, pedí resumen.
- No incluyas como hecho nada que el subagente B no haya verificado.
- Salida en markdown puro, sin HTML.
- Si un subagente falla, reportá lo del otro sin abortar.

[FORMATO DE SALIDA]
Creá `05 Diario/Auditorías/Revisión Mensual - {fecha-de-hoy}.md` con esta estructura:

# Revisión Mensual del Sistema · {fecha-de-hoy}

## Resumen ejecutivo
- Conexiones: N huérfanas · N links rotos · N clusters sin MOC
- Frescura: N vencidos · N por vencer
- Consistencia: N drifts de convención
- 🔴 Prioridad cruzada (mismo doc en 2+ dimensiones): N

## 🔴 Prioridad alta
(hallazgos que aparecen en ambas dimensiones, o críticos)

## 🔗 Conexiones (síntesis Subagente A)
...

## 🕐 Frescura (síntesis Subagente B)
...

## 🔧 Consistencia — drift de convención (síntesis Subagente B)
...

## ⚠️ No verificado (no incluir hasta confirmar)
...

## Propuestas priorizadas
1. ...
2. ...

## Cómo retomar
Este informe es la lista de tareas. Resolvemos en el chat; cada arreglo va al changelog del doc + CHANGELOG del Sistema. Marcar ✅/⬜ por hallazgo. (Ver SOP Skills §13.)

[ARGUMENTOS]
$ARGUMENTS
(--solo frescura / --solo conexiones para correr una sola dimensión)
