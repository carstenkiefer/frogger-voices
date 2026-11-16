# French (fr) – origin and license

* **Method:** generated once with [Piper](https://github.com/OHF-Voice/piper1-gpl) 1.8.0 from `texts/fr.toml` (`scripts/generate-piper.sh fr`).
* **Voice:** `fr_FR-siwis-medium` from [rhasspy/piper-voices](https://huggingface.co/rhasspy/piper-voices) (MIT), pinned by SHA-256 in `scripts/piper-voices.txt`.
* **Training data:** [SIWIS French Speech Synthesis Database](https://datashare.is.ed.ac.uk/handle/10283/2353) (Honnet et al., CC BY 4.0); fine-tuned from the U.S. English `hifi_tts_92` base model ([Hi-Fi TTS](https://www.openslr.org/109/), Bakhturina et al., CC BY 4.0; voice of Cori Samuel).
* **Post-processing:** silence trimmed, loudness normalised (-18 LUFS), Opus mono 48 kHz, 32 kbit/s, no metadata (`scripts/encode.sh`).
* **License of the clips:** [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) – please credit the datasets named above. Piper (GPL) is only the tool used to produce them; its license does not apply to its output.
* **Feedback welcome:** does it sound natural, is anything mispronounced? Please open an issue – native speakers especially.
