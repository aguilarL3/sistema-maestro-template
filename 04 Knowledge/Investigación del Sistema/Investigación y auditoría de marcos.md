---
tipo_doc: Explanation
tags: [investigacion, auditoria, sistema]
estado: 🟢 Activo
fecha_creacion: 2026-06-17
ultima_revision: 2026-06-26
id: "EXP-003"
---

# Investigación y auditoría de marcos

Este documento resume la investigación base que dio forma al vault y explica qué aporta cada marco, qué se adoptó y qué no.

## Cómo leer esta investigación
No es una lista de nombres.  
Es una comparación de marcos para decidir qué pieza vive en el sistema y por qué.

---

## 1. Karpathy / LLM Wiki

### Qué aporta
- arquitectura por capas
- separación entre fuentes crudas y wiki
- schema como reglas del sistema
- index como navegación
- agentes para mantener y auditar

### Qué adoptamos
- `06 Raw`
- `04 Knowledge`
- `00 Sistema`
- `01 Index`
- `AGENTS.md`

### Qué no adoptamos
- complejidad innecesaria
- sobreingeniería
- dependencia de una sola herramienta o interfaz

### Cómo se usa aquí
Como arquitectura base del vault.

---

## 2. Cerebro Digital (Emowe)

### Qué aporta
- visión de sistema operativo personal
- valores, principios, visión, objetivos
- diario como centro operativo
- hábitos como seguimiento
- modelos mentales
- notas fuente
- notas estructurales
- revisión continua
- portabilidad y markdown

### Qué adoptamos
- `00 Sistema/Valores`
- `00 Sistema/Principios`
- `01 Index/Vision`
- `01 Index/Objetivos`
- `05 Diario`
- `04 Knowledge/Modelos Mentales`
- `00 Sistema/SOP Diario`
- `00 Sistema/SOP Revisiones`

### Qué no adoptamos
- exceso de secciones obligatorias
- carga de diario demasiado pesada
- copiar la estructura física literal de Zettelkasten

### Cómo se usa aquí
Como capa de operación personal, reflexión y autogestión.

---

## 3. Yo S.A. (Rubén Loan)

### Qué aporta
- foco
- orden
- gobernanza personal
- vida por áreas
- revisión de objetivos
- relación entre vida y sistema

### Qué adoptamos
- `01 Index/Dashboard CEO`
- `01 Index/Mapa Personal`
- `00 Sistema/SOP Áreas`
- `life_areas`
- revisión de dirección personal

### Qué no adoptamos
- demasiadas áreas sin criterio
- capas redundantes que solo cambian de nombre

### Cómo se usa aquí
Como capa de dirección personal y profesional.

---

## 4. Career OS

### Qué aporta
- convertir aprendizaje en evidencia profesional visible
- skills documentados y demostrables
- portfolio de proyectos reales
- historias para entrevistas
- CV actualizado con evidencia concreta
- conexión entre conocimiento y empleabilidad

### Qué adoptamos
- dashboard de carrera en `01 Index`
- notas conectadas explícitamente a experiencia real
- proyectos en `03 Proyectos` como evidencia demostrable
- objetivos profesionales diferenciados en Index

### Qué no adoptamos
- convertir todo el aprendizaje en contenido público obligatorio
- optimizar solo para empleabilidad a costa del aprendizaje real

### Cómo se usa aquí
Como capa de salida profesional: todo lo que se aprende debe poder convertirse en evidencia demostrable.

---

## 5. Zettelkasten


### Qué aporta
- atomicidad
- conectividad
- pensamiento emergente
- backlinks
- notas enlazadas
- diálogo entre ideas

### Qué adoptamos
- notas atómicas
- backlinks
- MOCs
- notas evergreen
- notas modelo mental

### Qué no adoptamos
- folgezettel físico literal
- rigidez histórica no compatible con digital

### Cómo se usa aquí
Como motor de conexión y de crecimiento del conocimiento.

---

## 6. PARA

### Qué aporta
- clasificación práctica
- proyectos
- áreas
- recursos
- archivo

### Qué adoptamos
- `03 Proyectos`
- `06 Raw`
- `99 Archivo`
- idea de áreas como clasificación

### Qué no adoptamos
- convertir el vault en una taxonomía de carpetas
- depender solo de la clasificación jerárquica

### Cómo se usa aquí
Como marco de organización práctica, no como sistema dominante.

---

## 7. GTD

### Qué aporta
- captura
- clarificación
- organización
- revisión
- ejecución

### Qué adoptamos
- captura rápida
- revisión regular
- próxima acción
- claridad operativa

### Qué no adoptamos
- convertir el sistema en una lista de tareas infinita

### Cómo se usa aquí
Como lógica de flujo y no como sistema completo aislado.

---

## 8. Evergreen Notes

### Qué aporta
- conocimiento vivo
- notas en evolución
- revisión continua
- aprendizaje acumulativo

### Qué adoptamos
- `00 Sistema/SOP Evergreen Notes`
- `00 Sistema/Plantilla Nota Evergreen`
- revisión de notas con el tiempo

### Qué no adoptamos
- notas estáticas congeladas

### Cómo se usa aquí
Como capa de maduración del conocimiento.

---

## 9. CE-RE-BRO

### Qué aporta
- auditoría
- conexión
- reagrupación
- descomposición

### Qué adoptamos
- revisión del vault
- detección de huecos
- detección de duplicados
- detección de notas demasiado largas

### Qué no adoptamos
- convertirlo en burocracia

### Cómo se usa aquí
Como mecanismo de saneamiento y mejora.

---

## 10. Conclusión
El vault final debe ser:
- portable
- entendible
- navegable
- revisable
- compatible con IA
- útil para vida y carrera

Y sobre todo:
- fácil de empezar
- fácil de mantener
- fácil de volver a entender
