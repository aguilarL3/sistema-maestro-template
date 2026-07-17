#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""migrate-keys.py — F2 de RUN-001: completa el vocabulario OKF del frontmatter.

⛔ NO CORRER sin el GO de la migración total (Runbook - Migración OKF Total).
   Requiere: tag pre-okf-total creado, hooks en dual-key (ya están), y ejecutar
   en el MISMO bloque de trabajo la actualización de plantillas/SOP/ley.

Qué hace (determinista, idempotente) — solo en el frontmatter (entre los dos
primeros '---') de cada .md no excluido, sin tocar el cuerpo ni index.md:
  - Renombres:
      tipo_doc: X            ->  type: X
      ultima_revision: FECHA ->  timestamp: FECHA T00:00:00Z  (ISO 8601 datetime)
  - Altas (decisión de {{OWNER}} 2026-07-17: van en las 222 notas):
      title:    derivado del H1 del cuerpo (fallback = nombre de archivo),
                insertado tras 'type', entre comillas. NO se pisa si ya existe.
      resource: clave scaffoldeada VACÍA al final del frontmatter (el valor —URI
                del asset externo— se rellena al tocar). NO se pisa si ya existe.

Nota: el orden canónico final de las claves lo fija SOP Documentación §4.6 (paso
de F2); acá se usa una colocación provisional (title tras type, resource al final).

Uso:  python migrate-keys.py --dry   (reporte)  |  python migrate-keys.py --apply
"""
import io, os, re, sys

VAULT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
EXCLUDED = {".git", ".obsidian", ".claude", ".githooks", ".vault-meta", ".trash",
            "node_modules", "__pycache__", "graphify-out", "Baseline de Seguridad"}
DATE = re.compile(r"^ultima_revision:\s*(\d{4}-\d{2}-\d{2})\s*(#.*)?$")
H1 = re.compile(r"^#\s+(.+?)\s*#*\s*$")
HAS_TITLE = re.compile(r"^\s*title\s*:")
HAS_RESOURCE = re.compile(r"^\s*resource\s*:")


def yaml_quote(s):
    return '"' + s.replace("\\", "\\\\").replace('"', '\\"') + '"'


def extract_title(lines, fm_end, fallback):
    """Primer H1 del cuerpo (después del segundo '---'); si no hay, el fallback."""
    for l in lines[fm_end + 1:]:
        m = H1.match(l.rstrip("\n"))
        if m:
            return m.group(1).strip()
    return fallback


def transform_file(lines, stem):
    """Aplica la migración OKF al frontmatter. Devuelve (new_lines, changed).

    stem = nombre de archivo sin .md (fallback de title). Idempotente.
    Devuelve (None, False) si el archivo no tiene frontmatter parseable.
    """
    if not lines or lines[0].strip() != "---":
        return None, False
    fm_end = None
    for i in range(1, len(lines)):
        if lines[i].strip() == "---":
            fm_end = i
            break
    if fm_end is None:
        return None, False
    fm_lines = lines[1:fm_end]
    has_title = any(HAS_TITLE.match(x) for x in fm_lines)
    has_resource = any(HAS_RESOURCE.match(x) for x in fm_lines)

    out_fm, changed = [], False
    for l in fm_lines:
        if l.startswith("tipo_doc:"):
            out_fm.append("type:" + l[len("tipo_doc:"):])
            changed = True
            if not has_title:  # title justo después de type
                title = extract_title(lines, fm_end, stem)
                out_fm.append("title: %s\n" % yaml_quote(title))
                has_title, changed = True, True
            continue
        m = DATE.match(l.rstrip("\n"))
        if m:
            l = "timestamp: %sT00:00:00Z\n" % m.group(1)
            changed = True
        elif l.startswith("ultima_revision:"):  # valor no estándar
            l = "timestamp:" + l[len("ultima_revision:"):]
            changed = True
        out_fm.append(l)

    # top-up de title si la nota ya tenía 'type' (corrida parcial previa)
    if not has_title:
        title = extract_title(lines, fm_end, stem)
        new_fm, inserted = [], False
        for l in out_fm:
            new_fm.append(l)
            if not inserted and l.startswith("type:"):
                new_fm.append("title: %s\n" % yaml_quote(title))
                inserted = True
        if not inserted:
            new_fm.insert(0, "title: %s\n" % yaml_quote(title))
        out_fm, changed = new_fm, True

    # resource scaffoldeada vacía al final del frontmatter
    if not has_resource:
        out_fm.append("resource:\n")
        changed = True

    if not changed:
        return lines, False
    return [lines[0]] + out_fm + lines[fm_end:], True


def main():
    if "--apply" not in sys.argv and "--dry" not in sys.argv:
        print(__doc__)
        return 1
    dry = "--dry" in sys.argv
    n = 0
    for base, dirs, files in os.walk(VAULT):
        dirs[:] = [d for d in dirs if d not in EXCLUDED and not d.startswith(".")]
        for f in files:
            if not f.lower().endswith(".md") or f.lower() == "index.md":
                continue
            p = os.path.join(base, f)
            lines = io.open(p, encoding="utf-8").readlines()
            new_lines, changed = transform_file(lines, os.path.splitext(f)[0])
            if changed:
                n += 1
                print(("DRY: " if dry else "migrado: ") + os.path.relpath(p, VAULT))
                if not dry:
                    io.open(p, "w", encoding="utf-8", newline="").writelines(new_lines)
    print("total: %d notas" % n)
    return 0


if __name__ == "__main__":
    sys.exit(main())
