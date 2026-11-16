# 🐸🔊 FROGGER voices

Spoken enrollment prompts for [FROGGER](https://github.com/carstenkiefer/frogger),
the face authentication for Linux with IR cameras.

During enrollment FROGGER asks you to close your eyes – and you cannot read
the terminal with your eyes closed. FROGGER therefore signals the important
moments with system sounds; with a voice package installed it **speaks the
prompts** instead.

Each language is a separate, optional package (`frogger-voice-<lang>`).
FROGGER works without them, and distributions can leave them out or ship
them separately without touching FROGGER itself.

## Languages

| Language | Status | Source |
|---|---|---|
| Deutsch (`de`) | ✅ complete | Piper voice *Thorsten* (CC0) |
| English (`en`) | ✅ complete | Piper voice *LJ Speech* (public domain) |
| Ikinyarwanda (`rw`) | 🎙️ recordings wanted | native speakers |
| Runyankore (`nyn`) | 🎙️ recordings wanted | native speakers |

Every language documents its origin, voice and license in
`voices/<lang>/SOURCE.md`. A language only gets a package when it sounds
good – otherwise FROGGER keeps using system sounds for it.

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
  [docs/RECORDING.md](docs/RECORDING.md) – 15 short sentences, about 20
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
* Clips: per language, see `voices/<lang>/SOURCE.md` (currently CC0 1.0).
