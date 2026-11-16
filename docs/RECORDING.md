# Recording a language

Native-speaker recordings sound better than any speech model and are the
only option for many languages (e.g. Kinyarwanda, Runyankore). Recording one
language takes about 20 minutes: 15 short sentences.

## 1. Check the texts first

Open `texts/<lang>.toml`. For some languages the sentences are machine
translations – please correct them so they sound natural when spoken. Keep
the meaning and the key names (the part before `=`). Changed texts go into
the same pull request as the recordings.

## 2. Setup

* A quiet room without echo (a room with curtains, a sofa or a wardrobe is
  better than a kitchen or bathroom).
* Any headset or USB microphone, or a phone held at 20–30 cm. Do not use
  the laptop's built-in microphone if you have an alternative.
* Speak calmly and clearly, a little slower than in conversation – the
  listener has their eyes closed and follows the instructions.
* Leave about half a second of silence before and after each sentence.

## 3. Record

One file per sentence, named after its key, e.g. `enroll.close_eyes.wav`
(WAV or FLAC, mono, 44.1 or 48 kHz). With a phone, any common format is
fine; it will be converted.

Put the files into a folder `recordings/<lang>/` (it is ignored by git) and
convert them:

```bash
scripts/import-recordings.sh <lang>
```

This trims silence, normalises the loudness and writes
`voices/<lang>/<key>.opus`. `python3 scripts/check.py` verifies that every
sentence is there. Listen to all clips once before submitting.

## 4. Consent and license

Your voice is personal data. Please add the following to
`voices/<lang>/SOURCE.md` and submit it together with the recordings (or
send it to the maintainer):

> I, *name or "anonymous"*, recorded the clips in `voices/<lang>/` myself
> on *date*. I agree that they are published in this repository and
> distributed with FROGGER, and I release them under
> **CC0 1.0** / **CC BY 4.0** (*choose one*; with CC BY 4.0 you are named
> as the speaker). I can ask for their removal from future releases at any
> time; copies already distributed cannot be recalled.

## 5. Privacy

Recordings of a voice can be misused (e.g. for voice cloning). Only record
yourself, only these sentences, and only if you are comfortable with them
being public. Removing a voice later is always possible for future
releases.
