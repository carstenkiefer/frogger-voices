# Japanese (ja) – origin and license

* **Method:** generated once with [Kokoro-82M](https://huggingface.co/hexgrad/Kokoro-82M) v1.0 (Apache-2.0), ONNX export from [kokoro-onnx](https://github.com/thewh1teagle/kokoro-onnx), from `texts/ja.toml` (`scripts/generate-kokoro.py ja`). Japanese text is converted to phonemes with [misaki](https://github.com/hexgrad/misaki) (Apache-2.0).
* **Voice:** `jf_alpha`. Model files are pinned by SHA-256 in `scripts/voices.toml`.
* **Training data:** according to the model card, permissive / non-copyrighted audio.
* **Post-processing:** silence trimmed, loudness normalised (-18 LUFS), Opus mono 48 kHz, 32 kbit/s, no metadata (`scripts/encode.sh`).
* **License of the clips:** [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/).
* **Feedback welcome:** does it sound natural, is anything mispronounced? Please open an issue – native speakers especially.
