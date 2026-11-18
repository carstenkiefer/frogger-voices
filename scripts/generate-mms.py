#!/usr/bin/env python3
"""Generate the clips of one language with Meta MMS-TTS (CC BY-NC 4.0).

    scripts/generate-mms.py <lang> [key ...]   # only these keys

Needs: pip install torch transformers uroman soundfile. The model revision
is pinned in scripts/voices.toml. MMS clips are licensed CC BY-NC 4.0 like
the model (see voices/<lang>/SOURCE.md).
"""
import pathlib, subprocess, sys, tempfile, tomllib

root = pathlib.Path(__file__).resolve().parent.parent
cfg = tomllib.loads((root / "scripts" / "voices.toml").read_text())
lang = sys.argv[1]
spec = cfg["languages"][lang]
assert spec["engine"] == "mms", f"{lang} is not an MMS language"
code = spec["code"]
rev = cfg["mms"][code]

import torch, soundfile as sf, uroman
from transformers import VitsModel, AutoTokenizer
model = VitsModel.from_pretrained(f"facebook/mms-tts-{code}", revision=rev)
tok = AutoTokenizer.from_pretrained(f"facebook/mms-tts-{code}", revision=rev)
roman = uroman.Uroman() if getattr(tok, "is_uroman", False) else None
torch.manual_seed(0)  # VITS samples noise: fixed seed, reproducible clips

out = root / "voices" / lang
out.mkdir(parents=True, exist_ok=True)
lines = subprocess.run([sys.executable, root / "scripts" / "texts.py", lang, *sys.argv[2:]], capture_output=True, text=True, check=True).stdout
for line in lines.splitlines():
    key, text = line.split("\t", 1)
    if roman:
        text = roman.romanize_string(text)
    with torch.no_grad():
        wave = model(**tok(text, return_tensors="pt")).waveform[0].numpy()
    with tempfile.NamedTemporaryFile(suffix=".wav") as w:
        sf.write(w.name, wave, model.config.sampling_rate)
        subprocess.run([root / "scripts" / "encode.sh", w.name, out / f"{key}.opus"], check=True)
    print(f"  {lang}/{key}.opus")
