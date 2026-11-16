# English (en) – origin and license

* **Method:** generated once with [Piper](https://github.com/OHF-Voice/piper1-gpl)
  1.8.0 from the texts in `texts/en.toml` (`scripts/generate-piper.sh en`).
* **Voice:** `en_US-ljspeech-high` from
  [rhasspy/piper-voices](https://huggingface.co/rhasspy/piper-voices) (MIT),
  trained from scratch on the [LJ Speech](https://keithito.com/LJ-Speech-Dataset/)
  dataset (public domain; LibriVox recordings by Linda Johnson). The voice
  model is pinned by SHA-256 in `scripts/piper-voices.txt`.
* **Post-processing:** silence trimmed, loudness normalised (-18 LUFS),
  Opus mono 48 kHz, 32 kbit/s, no metadata.
* **License of the clips:** [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/).
  Piper (GPL) is only the tool used to produce them; its license does not
  apply to its output.
