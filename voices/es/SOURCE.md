# Spanish (Spain) (es) – origin and license

* **Method:** generated once with [Piper](https://github.com/OHF-Voice/piper1-gpl) 1.8.0 from `texts/es.toml` (`scripts/generate-piper.sh es`).
* **Voice:** `es_ES-davefx-medium` from [rhasspy/piper-voices](https://huggingface.co/rhasspy/piper-voices) (MIT), pinned by SHA-256 in `scripts/piper-voices.txt`.
* **Training data:** [OHF-Voice voice datasets](https://github.com/OHF-Voice/voice-datasets) (CC0); fine-tuned from the `rdh` base model (nl_BE, one Flemish speaker, CC0).
* **Post-processing:** silence trimmed, loudness normalised (-18 LUFS), Opus mono 48 kHz, 32 kbit/s, no metadata (`scripts/encode.sh`).
* **License of the clips:** [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/). Piper (GPL) is only the tool used to produce them; its license does not apply to its output.
* **Feedback welcome:** does it sound natural, is anything mispronounced? Please open an issue – native speakers especially.
