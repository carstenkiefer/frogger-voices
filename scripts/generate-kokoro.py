#!/usr/bin/env python3
"""Generate the clips of one language with Kokoro (Apache-2.0).

    scripts/generate-kokoro.py <lang>

Needs: pip install kokoro-onnx soundfile; for Japanese also "misaki[ja]".
Model files are downloaded to .cache/ and verified by SHA-256
(scripts/voices.toml).
"""
import hashlib, pathlib, subprocess, sys, tempfile, tomllib, urllib.request

root = pathlib.Path(__file__).resolve().parent.parent
cfg = tomllib.loads((root / "scripts" / "voices.toml").read_text())
lang = sys.argv[1]
spec = cfg["languages"][lang]
assert spec["engine"] == "kokoro", f"{lang} is not a Kokoro language"
cache = root / ".cache"
cache.mkdir(exist_ok=True)

def fetch(url, sha):
    f = cache / url.rsplit("/", 1)[1]
    if not f.exists() or hashlib.sha256(f.read_bytes()).hexdigest() != sha:
        urllib.request.urlretrieve(url, f)
    assert hashlib.sha256(f.read_bytes()).hexdigest() == sha, f"checksum mismatch {f}"
    return f

k = cfg["kokoro"]
from kokoro_onnx import Kokoro
import soundfile as sf
tts = Kokoro(str(fetch(k["model"], k["model_sha256"])), str(fetch(k["voices"], k["voices_sha256"])))
g2p = None
if spec["lang"] == "ja":
    from misaki import ja  # espeak cannot phonemise Japanese
    g2p = ja.JAG2P()

out = root / "voices" / lang
out.mkdir(parents=True, exist_ok=True)
lines = subprocess.run([sys.executable, root / "scripts" / "texts.py", lang], capture_output=True, text=True, check=True).stdout
for line in lines.splitlines():
    key, text = line.split("\t", 1)
    if g2p:
        ph = g2p(text)
        ph = ph[0] if isinstance(ph, tuple) else ph
        audio, sr = tts.create(ph, voice=spec["voice"], speed=0.95, is_phonemes=True)
    else:
        audio, sr = tts.create(text, voice=spec["voice"], speed=0.95, lang=spec["lang"])
    with tempfile.NamedTemporaryFile(suffix=".wav") as w:
        sf.write(w.name, audio, sr)
        subprocess.run([root / "scripts" / "encode.sh", w.name, out / f"{key}.opus"], check=True)
    print(f"  {lang}/{key}.opus")
