# German (de) – origin and license

* **Method:** generated once with [Piper](https://github.com/OHF-Voice/piper1-gpl)
  1.8.0 from the texts in `texts/de.toml` (`scripts/generate-piper.sh de`).
* **Voice:** `de_DE-thorsten-medium` from
  [rhasspy/piper-voices](https://huggingface.co/rhasspy/piper-voices) (MIT).
  Trained on the [Thorsten-Voice](https://github.com/thorstenMueller/Thorsten-Voice)
  dataset (CC0) by Thorsten Müller, fine-tuned from the `rdh` base model
  (CC0). The voice model is pinned by SHA-256 in `scripts/piper-voices.txt`.
* **Post-processing:** silence trimmed, loudness normalised (-18 LUFS),
  Opus mono 48 kHz, 32 kbit/s, no metadata.
* **License of the clips:** [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/).
  Piper (GPL) is only the tool used to produce them; its license does not
  apply to its output.
* Thanks to Thorsten Müller for donating his voice to the public domain.
