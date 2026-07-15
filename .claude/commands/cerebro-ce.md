Sos un auditor experto del vault Sistema Maestro de {{OWNER}}. Tu tarea es analizar las **conexiones entre notas** aplicando la dimensión CE (Conectar Elementos) de la metodología CE-RE-BRO.

## Qué analizar

Carpetas objetivo: `02 MOCs/`, `03 Proyectos/`, `04 Knowledge/`, `05 Diario/` (solo los últimos 30 archivos por fecha de modificación en Diario).

Para cada archivo `.md` encontrado, identificá:

1. **Notas huérfanas** — sin ningún wikilink entrante ni saliente
2. **Notas semi-huérfanas** — tienen links salientes pero nadie las enlaza desde otras notas
3. **Wikilinks rotos** — referencias `[[nombre]]` a archivos que no existen en el vault
4. **Clusters sin MOC** — grupos de 3+ notas interconectadas sin una nota MOC que las agrupe y resuma
5. **Notas obsoletas** — archivos en `04 Knowledge/` sin links entrantes y con `fecha_actualizacion` anterior a 90 días desde hoy

## Pasos

1. Usá `Glob` con patrón `**/*.md` en cada carpeta objetivo para obtener la lista completa de archivos
2. Usá `Grep` con patrón `\[\[([^\]\|]+)` para extraer todos los wikilinks de cada archivo
3. Construí mentalmente el grafo: qué archivos enlazan a qué otros
4. Cruzá los links extraídos contra la lista real de archivos para detectar los rotos
5. Contá links entrantes por archivo para detectar huérfanas y semi-huérfanas
6. Para candidatas a obsoletas, leé el frontmatter con `Read` para verificar `fecha_actualizacion`

## Output

Creá una nota nueva en `05 Diario/Auditorías/` con nombre `Informe CE - 2026-06-24.md` con esta estructura exacta:

```markdown
# Informe CE-RE-BRO · Dimensión CE · 2026-06-24

## Resumen ejecutivo
- Total notas analizadas: N
- Notas huérfanas: N
- Notas semi-huérfanas: N
- Wikilinks rotos: N
- Clusters sin MOC: N
- Notas obsoletas: N

## 🔴 Prioridad alta

### Wikilinks rotos
| Archivo origen | Link roto |
|---|---|
| ... | ... |

### Notas huérfanas
- ruta/del/archivo.md

## 🟡 Prioridad media

### Notas semi-huérfanas
| Archivo | Links salientes | Links entrantes |
|---|---|---|
| ... | N | 0 |

### Clusters sin MOC
- **Cluster 1:** [notas que lo forman] — tema probable: ...

## 🟢 Prioridad baja

### Notas obsoletas
| Archivo | Última actualización |
|---|---|
| ... | YYYY-MM-DD |

## Propuestas de acción
1. ...
2. ...
```

## Restricciones

- No modificar ningún archivo existente
- Solo crear la nota de informe
- Si una carpeta no existe, reportarlo y continuar
- Proponer siempre, nunca aplicar cambios directamente
- Si el análisis es muy extenso, priorizar wikilinks rotos y huérfanas primero

$ARGUMENTS
