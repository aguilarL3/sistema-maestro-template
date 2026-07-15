---
tipo_doc: How-to
tags: [SOP, archivos, privacidad]
estado: 🟢 Activo
prioridad: 🔥 Alta
responsable: "{{OWNER}}"
id: "SOP-COMPARTIR-ARCHIVOS-001"
ultima_revision: 2026-07-03
fecha_creacion: 2026-06-17
---

# SOP — Compartir Archivos (Drive / OneDrive en Obsidian)

## Objetivo

Embeber videos, PDFs e imágenes pesadas en Obsidian de forma segura, sin consumir espacio local y manteniendo privacidad total.

**Recomendación:** solo PDFs livianos de forma local. Todo lo demás vía iframe.

---

## Política de adjuntos (dónde va cada cosa) — decisión 2026-07-03

**Regla base:** git = **solo markdown + lógica** (skills, hooks). **Ningún binario va a git** (`.gitignore` ignora `png/jpg/pdf/mp4/…`). La **portabilidad del vault es el markdown y la lógica**, no los medios. Consecuencia asumida: un `git clone` puro (sin la carpeta sincronizada) verá los embeds de imagen rotos — está bien, el conocimiento vive en el texto.

| Tipo de adjunto | Dónde va | Cómo se sincroniza |
|---|---|---|
| **Imagen/captura chica propia de una nota** | carpeta **`ANEXOS`** local, junto a la nota (default de Obsidian, `attachmentFolderPath: ./ANEXOS`) | por **OneDrive** (el vault vive en carpeta OneDrive) — NO por git |
| **Video, PDF pesado, archivo a compartir** | **Google Drive / OneDrive** (no en el vault) | iframe embebido (resto de este SOP) |
| **Markdown, skills, hooks, `.canvas`** | el vault | **git** (fuente de verdad portable) |

> "En el ordenador" y "OneDrive" son **lo mismo**: el vault está en una carpeta sincronizada por OneDrive, así que un archivo en disco ya está en OneDrive. Git es una capa **aparte**, solo para el texto.

> **Nombre de carpeta unificado:** `ANEXOS` (el que ya crea Obsidian al pegar). Career OS todavía usa `Recursos` — alinear a `ANEXOS` cuando se toque esa área.

---

## Protocolo de seguridad (obligatorio)

Antes de insertar cualquier enlace:

1. **Google Drive:** configurar acceso como **"Restringido"**. Solo tu cuenta debe tener permisos de propietario. Eliminar cualquier permiso de "Cualquier persona con el enlace".
2. **OneDrive:** generar el código de inserción con el archivo configurado como **privado**. Solo carga si tenés sesión activa en el navegador.
3. **Auditoría:** cada domingo revisar en Drive/OneDrive qué archivos tienen permisos activos y revocarlos si ya no son necesarios.

---

## Cómo insertar — Google Drive

```markdown
[Ver en Drive](https://drive.google.com/file/d/TU_ID/view)

<iframe src="https://drive.google.com/file/d/TU_ID/preview" width="100%" height="450" frameborder="0" style="border-radius: 8px;"></iframe>
```

**Cómo obtener el ID:** abrís el archivo en Drive → la URL tiene el formato `/file/d/ESTE_ES_EL_ID/view`

---

## Cómo insertar — OneDrive

```markdown
[Ver en OneDrive](https://onedrive.live.com/)

<iframe src="PEGAR_SRC_DE_MICROSOFT_AQUI" width="100%" height="450" frameborder="0" style="border-radius: 8px;"></iframe>
```

**Cómo obtener el src:** OneDrive Web → archivo → Insertar → copiar todo el atributo `src` del iframe generado.

---

## Tips de optimización

- Si el iframe se ve desproporcionado en mobile: cambiar `height="450"` a `height="300"`
- El contenido solo carga con sesión activa en el navegador (correcto, es privado)
- NO usar links públicos tipo "Cualquier persona con el enlace"

---

## Qué NO hacer

- No compartir el vault completo
- No guardar credenciales sensibles en notas
- No generar links públicos de archivos de cursos

---

## Referencias
- [[00 Sistema/001_plantillas/Plantilla Apunte Curso]]
- [[Plantilla Nota]]
