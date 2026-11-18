#!/usr/bin/env python3
"""Print "key<TAB>text" for every prompt of a language, in prompts.txt order.

    scripts/texts.py <lang> [key ...]   # only these keys
"""
import pathlib
import sys
import tomllib

root = pathlib.Path(__file__).resolve().parent.parent
keys = [l.strip() for l in (root / "prompts.txt").read_text().splitlines() if l.strip() and not l.startswith("#")]
texts = tomllib.loads((root / "texts" / f"{sys.argv[1]}.toml").read_text())
only = set(sys.argv[2:])
for k in keys:
    if only and k not in only:
        continue
    print(f"{k}\t{texts[k]}")
