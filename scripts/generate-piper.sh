#!/usr/bin/env bash
# Generate the clips of one language with Piper.
#
#   scripts/generate-piper.sh <lang>
#
# Needs: python3 with `piper-tts` (pip install piper-tts), ffmpeg with
# libopus, curl. Voice models are downloaded to .cache/ and verified by
# SHA-256 (scripts/piper-voices.txt). Piper itself (GPL) is only a tool
# here; the clips are licensed like the voice (see voices/<lang>/SOURCE.md).
set -euo pipefail
LANG_CODE=${1:?language code}
ROOT=$(cd "$(dirname "$0")/.." && pwd)
CACHE=$ROOT/.cache
BASE=https://huggingface.co/rhasspy/piper-voices/resolve/main
line=$(grep -E "^$LANG_CODE " "$ROOT/scripts/piper-voices.txt") || {
  echo "no Piper voice configured for $LANG_CODE" >&2; exit 1; }
read -r _ voice sha_onnx sha_json _ <<<"$line"
name=$(basename "$voice")
mkdir -p "$CACHE"
fetch() { # file sha256
  local f="$CACHE/$1"
  if [ ! -f "$f" ] || ! echo "$2  $f" | sha256sum -c --status; then
    curl -fsSL --retry 4 -o "$f.part" "$BASE/$(dirname "$voice")/$1"
    mv "$f.part" "$f"
  fi
  echo "$2  $f" | sha256sum -c --quiet
}
fetch "$name.onnx" "$sha_onnx"
fetch "$name.onnx.json" "$sha_json"

out=$ROOT/voices/$LANG_CODE
mkdir -p "$out"
python3 "$ROOT/scripts/texts.py" "$LANG_CODE" | while IFS=$'\t' read -r key text; do
  wav=$(mktemp --suffix=.wav)
  # Run in .cache: Piper's Chinese front end downloads its g2pW model into
  # the working directory.
  (cd "$CACHE" && printf '%s\n' "$text" | python3 -m piper -m "$CACHE/$name.onnx" -f "$wav" >/dev/null 2>&1)
  "$ROOT/scripts/encode.sh" "$wav" "$out/$key.opus"
  rm -f "$wav"
  echo "  $LANG_CODE/$key.opus"
done
