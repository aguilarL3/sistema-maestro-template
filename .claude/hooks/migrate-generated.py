#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""migrate-generated.py — OKF v0.2: timestamp -> generated{by, at}.

Migra el frontmatter de OKF v0.1 a v0.2: reemplaza el campo `timestamp` por el
bloque `generated: {by, at}` (cambio breaking de OKF v0.2). Determinista e
idempotente; solo toca el frontmatter (entre los dos primeros '---'), sin el
cuerpo ni index.md.

  timestamp: VALOR   ->   generated:
                            by: human:{{OWNER}}
                            at: VALOR

`by` de las notas legacy = human:{{OWNER}} (el actor que atesta el conocimiento
del vault). A futuro las plantillas/agentes emiten el actor real (process:<id>).

Idempotente: si la nota ya tiene `generated:`, no toca nada. Si no tiene
`timestamp:`, no cambia.

Uso:  python migrate-generated.py --dry   (reporte)  |  python migrate-generated.py --apply
"""
import io, os, re, sys

VAULT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
EXCLUDED = {".git", ".obsidian", ".claude", ".githooks", ".vault-meta", ".trash",
            "node_modules", "__pycache__", "graphify-out", "Baseline de Seguridad"}
BY_LEGACY = "human:{{OWNER}}"
# timestamp: VALOR   (VALOR sin comentario trailing)
TS = re.compile(r"^timestamp:\s*(.*?)\s*(#.*)?$")


def transform_file(lines):
    """Aplica la migración v0.2 al frontmatter. Devuelve (new_lines, changed).

    Idempotente. Devuelve (None, False) si no hay frontmatter parseable.
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

    # Idempotencia: si ya hay bloque generated, no tocar.
    if any(re.match(r"^generated:\s*$", x.rstrip("\n")) for x in fm_lines):
        return lines, False

    out_fm, changed = [], False
    for l in fm_lines:
        m = TS.match(l.rstrip("\n"))
        if m and l.startswith("timestamp:"):
            value = m.group(1).strip()
            out_fm.append("generated:\n")
            out_fm.append("  by: %s\n" % BY_LEGACY)
            out_fm.append("  at: %s\n" % value)
            changed = True
            continue
        out_fm.append(l)

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
            new_lines, changed = transform_file(lines)
            if changed:
                n += 1
                print(("DRY: " if dry else "migrado: ") + os.path.relpath(p, VAULT))
                if not dry:
                    io.open(p, "w", encoding="utf-8", newline="").writelines(new_lines)
    print("total: %d notas" % n)
    return 0


if __name__ == "__main__":
    sys.exit(main())
