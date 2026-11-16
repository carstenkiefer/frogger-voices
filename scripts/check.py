#!/usr/bin/env python3
"""Consistency checks, run in CI.

* every texts/<lang>.toml has exactly the keys of prompts.txt;
* every voices/<lang>/ with clips has a SOURCE.md and one clip per key
  (a language is either complete or has no clips at all);
* clips are Ogg Opus files of reasonable size.

Prints the complete languages (one per line) on stdout.
"""
import pathlib
import sys
import tomllib

root = pathlib.Path(__file__).resolve().parent.parent
keys = [l.strip() for l in (root / "prompts.txt").read_text().splitlines() if l.strip() and not l.startswith("#")]
errors = []
for t in sorted((root / "texts").glob("*.toml")):
    have = set(tomllib.loads(t.read_text()))
    if missing := set(keys) - have:
        errors.append(f"{t.name}: missing {sorted(missing)}")
    if extra := have - set(keys):
        errors.append(f"{t.name}: unknown keys {sorted(extra)}")
complete = []
for d in sorted(p for p in (root / "voices").iterdir() if p.is_dir()):
    clips = {c.stem: c for c in d.glob("*.opus")}
    if not clips:
        continue
    if not (d / "SOURCE.md").is_file():
        errors.append(f"voices/{d.name}: SOURCE.md missing")
    if missing := set(keys) - set(clips):
        errors.append(f"voices/{d.name}: missing clips {sorted(missing)}")
    if extra := set(clips) - set(keys):
        errors.append(f"voices/{d.name}: unknown clips {sorted(extra)}")
    for c in clips.values():
        head = c.read_bytes()[:64]
        if not (head.startswith(b"OggS") and b"OpusHead" in head):
            errors.append(f"{c.relative_to(root)}: not Ogg Opus")
        if not 1_000 <= c.stat().st_size <= 200_000:
            errors.append(f"{c.relative_to(root)}: unexpected size {c.stat().st_size}")
    if not (root / "texts" / f"{d.name}.toml").is_file():
        errors.append(f"voices/{d.name}: texts/{d.name}.toml missing")
    complete.append(d.name)
for e in errors:
    print(f"error: {e}", file=sys.stderr)
print("\n".join(complete))
sys.exit(1 if errors else 0)
