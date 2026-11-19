# 🐸🔊 FROGGER voices

Spoken enrollment prompts for [FROGGER](https://github.com/carstenkiefer/frogger),
the face authentication for Linux with IR cameras.

During enrollment FROGGER asks you to close your eyes – and you cannot read
the terminal with your eyes closed. FROGGER therefore signals the important
moments with system sounds; with a voice package installed it **speaks the
prompts** instead.

Each language is a separate, optional package (`frogger-voice-<lang>`).
FROGGER works without them, and distributions can leave them out or ship
them separately without touching FROGGER itself. Two metapackages install
several at once:

* `frogger-voices-free` – all languages whose clips may also be used
  commercially (CC0 or CC BY); the right choice for companies;
* `frogger-voices-all` – all languages, including those marked ⚠️ below
  (non-commercial use only).

**Installation:** from FROGGER's package repository (set up as described in
the [FROGGER README](https://github.com/carstenkiefer/frogger#package-repository-recommended)),
e.g. `sudo apt install frogger-voice-de` or `sudo dnf install
frogger-voices-free`; or download the packages from the
[releases](https://github.com/carstenkiefer/frogger-voices/releases). The
package repository picks up a new release of this repository within a day.

## Languages

| Language | Voice | License of the clips |
|---|---|---|
| Deutsch (`de`) | Piper *Thorsten* | CC0 |
| English (`en`) | Kokoro *af_heart* | CC0 |
| Español (`es`) | Piper *davefx* | CC0 |
| Français (`fr`) | Piper *SIWIS* | CC BY 4.0 |
| Português (`pt`, Brazil) | Piper *faber* | CC BY 4.0 |
| Русский (`ru`) | Piper *dmitri* | CC BY 4.0 |
| 中文 (`zh`) | Piper *chaowen* | CC BY 4.0 |
| 日本語 (`ja`) | Kokoro *jf_alpha* | CC0 |
| हिन्दी (`hi`) | Kokoro *hm_omega* | CC0 |
| 한국어 (`ko`) | Meta MMS | CC BY-NC 4.0 ⚠️ |
| العربية (`ar`) | Meta MMS | CC BY-NC 4.0 ⚠️ |
| Kiswahili (`sw`) | Meta MMS | CC BY-NC 4.0 ⚠️ |
| Bahasa Indonesia (`id`) | Meta MMS | CC BY-NC 4.0 ⚠️ |
| Bahasa Melayu (`ms`) | Meta MMS | CC BY-NC 4.0 ⚠️ |
| Ikinyarwanda (`rw`) | Meta MMS (interim) | CC BY-NC 4.0 ⚠️ |
| Runyankore (`nyn`) | Meta MMS (interim) | CC BY-NC 4.0 ⚠️ |

Voices were chosen by listening to several candidates per language with the
same sentence. Every language documents its origin, voice, training data and
license in `voices/<lang>/SOURCE.md`. ⚠️ Meta MMS is the only freely
available model for these languages and is licensed for **non-commercial use
only**; recordings by native speakers would replace these clips (see below).

## Feedback wanted 🎧

None of us speaks all 16 languages. If you are a native speaker, please
listen to the clips of your language (`voices/<lang>/*.opus`, any media
player) and tell us in an issue:

* Does it sound natural and friendly? Is anything mispronounced?
* Are the texts (`texts/<lang>.toml`) correct and idiomatic? Kinyarwanda and
  Runyankore are machine translations so far.
* Would you like to record your language yourself? See
  [docs/RECORDING.md](docs/RECORDING.md) – it takes about 20 minutes.

## Adding a language

More languages are very welcome – ideally recorded by native speakers:

1. **FROGGER itself must speak the language first:** its message catalog
   (`i18n/<lang>.toml` in the [FROGGER repository](https://github.com/carstenkiefer/frogger))
   is the source of the texts. If it is missing, start there.
2. **Texts:** copy `texts/en.toml` to `texts/<lang>.toml` and translate it
   for speech – short sentences, no brackets or placeholders, numbers and
   units spelled out.
3. **Clips**, in this order of preference:
   * **Recordings** by a native speaker – see [docs/RECORDING.md](docs/RECORDING.md)
     (18 sentences, about 20 minutes, with a short consent statement);
   * a **speech model** whose license chain (model *and* training data) allows
     redistribution – add it to `scripts/voices.toml` and generate with the
     matching `scripts/generate-*.py`/`.sh`;
   * if neither exists, the language stays without a voice package and
     FROGGER uses system sounds.
4. **`voices/<lang>/SOURCE.md`:** origin, speaker or model, training data,
   license of the clips.
5. `python3 scripts/check.py` must pass. Open a pull request.

Recordings can also replace generated clips later – especially for the
languages that currently use Meta MMS (non-commercial license).

## How it works

* `prompts.txt` lists the spoken prompts (message keys of FROGGER, e.g.
  `enroll.close_eyes`).
* `texts/<lang>.toml` holds the spoken text per key – adapted for speech:
  no placeholders, no brackets, units spelled out.
* `voices/<lang>/<key>.opus` are the clips (Opus mono 48 kHz, -18 LUFS).
  Packages install them to `/usr/share/frogger/voices/<lang>/`.
* No speech engine runs at login or enrollment time – only these
  pre-produced clips are played.

## Contributing a language

* **Recordings by native speakers** (preferred): see
  [docs/RECORDING.md](docs/RECORDING.md) – 18 short sentences, about 20
  minutes, including a short consent statement.
* **Generated with a speech model**: only with a voice whose license chain
  (model *and* training data) allows commercial use and redistribution.
  `scripts/generate-piper.sh <lang>` uses the voices pinned in
  `scripts/piper-voices.txt`.

`python3 scripts/check.py` validates texts and clips;
`scripts/build-packages.sh` builds `.deb` and `.rpm` packages for every
complete language.

## Licenses

* Scripts and texts: MIT OR Apache-2.0 (`LICENSE-MIT`, `LICENSE-APACHE`),
  like FROGGER.
* Clips: per language, see the table above and `voices/<lang>/SOURCE.md`.
