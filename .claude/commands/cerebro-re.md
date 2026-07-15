Sos un auditor experto del vault Sistema Maestro de {{OWNER}}. Tu tarea es analizar el **reagrupamiento de notas** aplicando la dimensión RE (Reagrupar Elementos) de la metodología CE-RE-BRO.

## Qué analizar

Carpetas objetivo: `02 MOCs/`, `03 Proyectos/`, `04 Knowledge/`, `00 Sistema/`.

Para cada archivo `.md` encontrado, analizá:

1. **Etiquetas duplicadas** — tags que significan lo mismo con nombres distintos (ej: `productividad` y `gestion-del-tiempo`)
2. **Propiedades YAML inconsistentes** — campos del frontmatter con distinto nombre pero misma función entre notas similares
3. **Etiquetas subusadas** — tags que aparecen en 1 o 2 notas solamente (probablemente sobran)
4. **Prefijos de archivo sugeridos** — grupos de notas sin prefijo que podrían beneficiarse de uno para búsqueda rápida
5. **Notas en carpeta incorrecta** — archivos cuyo contenido no corresponde a la carpeta donde están

## Pasos

1. Usá `Glob` con patrón `**/*.md` en cada carpeta objetivo
2. Usá `Grep` con patrón `^tags:` y luego `^  - ` para extraer todos los tags del frontmatter de cada archivo
3. Agrupá tags semánticamente similares (misma raíz, sinónimos, variantes con/sin tilde o guion)
4. Contá cuántas notas usan cada tag para detectar las subusadas
5. Usá `Grep` con patrón `^[a-z_]+:` en el frontmatter para listar propiedades YAML y detectar inconsistencias
6. Analizá los nombres de archivo para detectar grupos sin prefijo coherente
7. Para notas candidatas a estar en carpeta incorrecta, leé el título y primeras líneas con `Read`

## Output

Creá una nota nueva en `05 Diario/Auditorías/` con nombre `Informe RE - 2026-06-24.md` con esta estructura exacta:

```markdown
# Informe CE-RE-BRO · Dimensión RE · 2026-06-24

## Resumen ejecutivo
- Total notas analizadas: N
- Tags únicos encontrados: N
- Grupos de tags duplicados detectados: N
- Tags subusados (≤2 notas): N
- Inconsistencias YAML: N
- Notas posiblemente en carpeta incorrecta: N

## 🔴 Prioridad alta

### Tags duplicados o sinónimos
| Tag A | Tag B | Notas afectadas | Propuesta |
|---|---|---|---|
| productividad | gestion-tiempo | 5 / 3 | Unificar en `productividad` |

### Propiedades YAML inconsistentes
| Propiedad A | Propiedad B | Notas afectadas | Propuesta |
|---|---|---|---|
| ... | ... | ... | ... |

## 🟡 Prioridad media

### Tags subusados (≤2 notas)
| Tag | Notas que lo usan | Propuesta |
|---|---|---|
| ... | ... | Eliminar / fusionar con ... |

### Prefijos de archivo sugeridos
| Grupo de notas | Prefijo propuesto | Ejemplo |
|---|---|---|
| Notas sobre CE-RE-BRO | `CEREBRO-` | `CEREBRO-Conectar Elementos.md` |

## 🟢 Prioridad baja

### Notas posiblemente en carpeta incorrecta
| Archivo actual | Carpeta sugerida | Motivo |
|---|---|---|
| ... | ... | ... |

## Propuestas de acción
1. ...
2. ...
```

## Restricciones

- No modificar ningún archivo existente
- Solo crear la nota de informe
- Proponer siempre, nunca aplicar cambios directamente
- Para tags, sugerir siempre cuál conservar y cuál eliminar, con justificación
- No marcar como incorrecta una nota sin leer su contenido mínimamente

$ARGUMENTS
