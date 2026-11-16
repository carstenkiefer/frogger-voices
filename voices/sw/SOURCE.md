# Swahili (sw) – origin and license

* **Method:** generated once with [Meta MMS-TTS](https://huggingface.co/facebook/mms-tts-swh) (`facebook/mms-tts-swh`) from `texts/sw.toml` (`scripts/generate-mms.py sw`), fixed random seed. The model revision is pinned in `scripts/voices.toml`.
* **Model license:** CC BY-NC 4.0 (Meta, "Scaling Speech Technology to 1,000+ Languages", Pratap et al., 2023).
* **Post-processing:** silence trimmed, loudness normalised (-18 LUFS), Opus mono 48 kHz, 32 kbit/s, no metadata (`scripts/encode.sh`).
* **License of the clips:** [CC BY-NC 4.0](https://creativecommons.org/licenses/by-nc/4.0/) like the model – **non-commercial use only**. This package is therefore not suitable for every distribution; FROGGER works without it (system sounds).
* **Native-speaker recordings wanted:** they would replace these clips and make the package free of the non-commercial restriction (see [docs/RECORDING.md](../../docs/RECORDING.md)).
* **Feedback welcome:** does it sound natural, is anything mispronounced? Please open an issue – native speakers especially.
