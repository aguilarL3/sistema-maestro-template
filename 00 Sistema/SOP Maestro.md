---
tipo_doc: How-to
tags: [SOP, maestro, sistema, onboarding]
estado: 🟢 Activo
prioridad: 🔥 Alta
responsable: "{{OWNER}}"
id: "SOP-001"
ultima_revision: 2026-07-02
fecha_creacion: 2026-06-17
---

> [!info] Este es el archivo raíz del sistema
> Si alguien entra por primera vez al vault, este archivo debe ser de los primeros en leer.
> Antes o después también conviene leer: [[00 Inicio Rapido]], [[AGENTS]], [[SOP Index]], [[Glosario de términos]], [[Investigación y auditoría de marcos]]

# SOP Maestro

## 1. Qué es este archivo
El SOP Maestro es la explicación central del vault. Su función es hacer comprensible el sistema completo incluso para alguien que no conoce:
- Obsidian
- Zettelkasten
- PARA
- GTD
- MOCs
- Cerebro Digital
- Career OS
- Yo S.A.
- Evergreen Notes
- CE-RE-BRO

No es solo un protocolo operativo. También es la base pedagógica del vault.

## 2. Para qué sirve el sistema

El sistema existe para mover la información a través de esta cadena:

```
Información → Conocimiento → Acción → Resultados → Evidencia → Crecimiento
```

Cada capa del vault tiene una función en esa cadena.
Si algo no mueve la información hacia adelante en ella, probablemente no merece estar.

---

## 3. Qué problema resuelve
Este SOP existe para evitar tres problemas comunes:

### A. Desorden
Cuando crecen las notas, es fácil perderse y duplicar información.

### B. Dependencia de memoria
Sin una explicación central, solo entiende el vault quien lo creó.

### C. Fragmentación
Muchas notas útiles quedan aisladas si no hay una lógica clara de conexión.

## 3. Para quién está pensado
Este sistema está pensado para:
- ti
- una futura versión tuya
- otra persona que herede el vault
- una IA que necesite entender cómo opera el sistema

## 4. Cómo leer el vault
La lectura recomendada no es lineal sino por capas.

### Capa 1. Entender el sentido
Primero lee:
- [[00 Inicio Rapido]]
- [[AGENTS]]
- [[Glosario de términos]]

### Capa 2. Entender la arquitectura
Luego:
- [[SOP Index]]
- [[SOP MOCs]]
- [[SOP Diario]]
- [[SOP Revisiones]]
- [[SOP Proyectos]]
- [[SOP IA]]

### Capa 3. Entender la filosofía
Después:
- [[Valores]]
- [[Principios]]
- [[Vision]]
- [[Objetivos]]
- [[Investigación y auditoría de marcos]]

## 5. Arquitectura base
La estructura base es esta:

1. `00 Sistema`
2. `01 Index`
3. `02 MOCs`
4. `03 Proyectos`
5. `04 Knowledge`
6. `05 Diario`
7. `06 Raw`
8. `99 Archivo`

### Qué hace cada capa
#### `00 Sistema`
Reglas, SOPs, plantillas, principios del sistema, guías y documentación base.

#### `01 Index`
Navegación global. Sirve para entrar al sistema, ver prioridades y encontrar rutas.

#### `02 MOCs`
Mapas de contenido. Organizan temas y crean puertas de entrada al conocimiento.

#### `03 Proyectos`
Iniciativas con principio y fin.

#### `04 Knowledge`
Conocimiento reutilizable, notas atómicas, modelos mentales y temas procesados.

#### `05 Diario`
Registro cotidiano, seguimiento, reflexión, hábitos, predicciones y revisión del día.

#### `06 Raw`
Fuentes originales sin procesar.

#### `99 Archivo`
Material terminado, obsoleto o archivado.

## 6. Flujo general de trabajo

El ciclo completo del vault es este:

```
Capturar → Procesar → Conectar → Comprender → Aplicar → Revisar → Evolucionar
```

### Paso 1. Capturar
Todo lo nuevo entra primero por:
- `05 Diario`
- `06 Raw`
- una nota rápida

Sin fricción. Sin decidir todavía dónde va.

### Paso 2. Procesar
Luego preguntas qué es:
- ¿es idea reutilizable? → Knowledge
- ¿es fuente cruda? → Raw
- ¿es proyecto con cierre? → Proyectos
- ¿es decisión importante? → Decisiones
- ¿es hábito o seguimiento? → Diario
- ¿es un modelo mental? → Knowledge / Modelos Mentales
- ¿es un tema con varias notas? → MOC

### Paso 3. Conectar
Toda nota importante debe enlazarse con:
- MOC del tema
- notas relacionadas
- índices
- proyectos
- fuentes

### Paso 4. Comprender
Antes de dar por procesada una nota, verificar:
- ¿la podría releer en 6 meses y entenderla?
- ¿la podría reutilizar en otro contexto?
- ¿conecta con algo que ya existe?

### Paso 5. Aplicar
El conocimiento solo vale cuando genera:
- proyectos
- decisiones
- hábitos
- resultados demostrables

### Paso 6. Revisar
Revisar sirve para:
- limpiar ruido
- unir duplicados
- detectar notas huérfanas
- actualizar prioridades
- mantener el sistema vivo

### Paso 7. Evolucionar
El sistema cambia contigo:
- las notas evergreen crecen
- los MOCs se actualizan
- los SOPs se afinan
- los objetivos se revisan
- la arquitectura mejora con el uso

### Flujo de operación del sistema (Roadmap → Bitácora → CHANGELOG)

El flujo de arriba mueve **conocimiento** (notas, MOCs, proyectos). En paralelo corre un segundo flujo que mueve la **construcción y evolución del sistema mismo**, con tres documentos que responden a tres preguntas distintas en tres ejes temporales:

```
ROADMAP  →  (un agente agarra un pendiente y lo construye)  →  BITÁCORA  →  CHANGELOG
 futuro                   trabajo de la sesión                   handoff       memoria
```

| Documento | Ubicación | Pregunta | Naturaleza |
|---|---|---|---|
| [[Roadmap del Sistema]] | `01 Index/` | ¿Qué falta / qué sigue? | Backlog vivo (se vacía) |
| [[Bitácora de Agentes]] | `05 Diario/Bitácora Agentes/` | ¿Qué pasó en esta sesión y dónde quedamos? | Handoff cronológico (por mes; se llena solo vía hook `Stop`) |
| [[CHANGELOG del Sistema]] | `00 Sistema/` | ¿Qué cambió estructuralmente, para siempre? | Registro permanente y curado (append-only) |

La distinción fina es **Bitácora vs CHANGELOG**: la bitácora registra *toda* sesión significativa con tono de "dónde quedé" (bloqueos, decisiones a medias, avisos al próximo agente) y es desechable; el CHANGELOG registra *solo cambios estructurales consumados* con tono de "esto ahora es así" y es permanente. Analogía: la bitácora es el mensaje al del turno siguiente; el CHANGELOG es el acta oficial. Las **auditorías** (`05 Diario/Auditorías/`) son fotos fechadas que *alimentan* al Roadmap, no forman parte de este flujo.

> Detalle multi-agente de este flujo → [[Orquestación Multi-Agente Abierta]] §13.

## 7. Qué NO hacer
- No convertir el vault en miles de carpetas temáticas.
- No crear notas enormes sin necesidad.
- No duplicar la misma idea en distintos sitios.
- No dejar decisiones importantes solo en el diario.
- No usar IA como reemplazo de criterio.
- No obligarte a rellenar secciones que nunca usarás.

## 8. Qué SÍ hacer
- Capturar sin fricción.
- Procesar con calma.
- Conectar pronto.
- Revisar seguido.
- Archivar lo terminado.
- Mantener pocas reglas, bien entendidas.
- Escribir para volver a usar la información.

## 9. Cómo usar IA dentro del vault
La IA puede ayudarte a:
- resumir fuentes
- detectar huecos
- construir MOCs
- crear borradores
- auditar duplicados
- explicar conceptos
- proponer conexiones

### Regla de uso
La IA siempre propone.  
Tú decides.

### Buenas prácticas
- Dale contexto claro.
- Dale el archivo correcto.
- Pide una salida concreta.
- Revisa antes de aplicar.
- Guarda solo lo útil.

## 10. De dónde viene cada pieza (marcos de origen)

Cada capa del vault traduce un marco externo. El mapa mínimo:

| Marco | Qué aporta | Dónde vive en el vault |
|---|---|---|
| LLM Wiki (Karpathy) | Raw → Wiki → Schema → Index → Agents | `06 Raw` → `04 Knowledge` → `00 Sistema` → `01 Index` → `AGENTS.md` |
| Zettelkasten + Evergreen | atomicidad, conexión, notas vivas | notas atómicas, backlinks, MOCs |
| GTD + PARA | captura/revisión + proyectos/áreas/recursos/archivo | flujo completo · `03 Proyectos`/`04 Knowledge`/`06 Raw`/`99 Archivo` |
| Cerebro Digital + Yo S.A. | valores, visión, diario, gobernanza personal | `01 Index` + `05 Diario` |
| Career OS | evidencia, portfolio, carrera | `{{OWNER}} Career OS` + MOC Carrera |
| CE-RE-BRO (propio) | auditoría Conectar/Reagrupar/Optimizar | skills `cerebro-*` |

> **Una fuente de verdad por pregunta:** *¿por qué* se eligió cada marco y qué se adoptó/descartó → [[Filosofía del Sistema]] (§Los 6 pilares). *¿Qué dice* cada marco en profundidad (el estudio) → [[Investigación y auditoría de marcos]]. Este SOP solo mantiene el mapa de traducción de arriba.

## 11. Cómo mantener el sistema en el tiempo
Una vez por semana:
- revisar diario
- limpiar pendientes
- mover material importante a Knowledge
- crear o actualizar MOCs
- archivar lo que terminó

Una vez al mes:
- revisar objetivos
- revisar hábitos
- revisar visión
- revisar dirección profesional
- auditar el vault con CE-RE-BRO

## 12. Qué debe entender cualquier usuario nuevo
Cualquier persona nueva debe entender estas cinco ideas:
1. El vault no es un basurero de notas.
2. El diario es un centro operativo.
3. Knowledge es conocimiento reutilizable.
4. MOCs organizan la navegación.
5. Las revisiones mantienen el sistema vivo.

## 13. Qué se convierte el sistema con el tiempo

Con uso sostenido y revisión regular, el Sistema Maestro se convierte en:

- **Tu biblioteca personal** — todo lo que aprendiste, organizado y recuperable
- **Tu memoria externa** — todo lo que no querés olvidar, fuera de tu cabeza
- **Tu sistema de productividad** — todo lo que debés ejecutar, con claridad
- **Tu sistema de carrera** — todo lo que demuestra lo que sabés hacer
- **Tu sistema de pensamiento** — todo lo que te ayuda a tomar mejores decisiones

---

## 14. Referencias
- [[00 Inicio Rapido]]
- [[Glosario de términos]]
- [[Investigación y auditoría de marcos]]
- [[SOP Index]]
- [[SOP MOCs]]
- [[SOP Diario]]
- [[SOP Revisiones]]
- [[SOP Proyectos]]
- [[SOP IA]]
- [[SOP Evergreen Notes]]
- [[SOP Áreas]]
- [[Valores]]
- [[Principios]]
- [[Vision]]
- [[Objetivos]]
- [[MOC - Investigación del Sistema]]
- MOC - Master Learning System
