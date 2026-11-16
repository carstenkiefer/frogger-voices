#!/usr/bin/env bash
# Convert native-speaker recordings into clips.
#
#   scripts/import-recordings.sh <lang>
#
# Reads recordings/<lang>/<key>.<any audio format> and writes
# voices/<lang>/<key>.opus (silence trimmed, -18 LUFS, Opus mono 48 kHz).
# Needs ffmpeg with libopus.
set -euo pipefail
LANG_CODE=${1:?language code}
ROOT=$(cd "$(dirname "$0")/.." && pwd)
IN=$ROOT/recordings/$LANG_CODE
OUT=$ROOT/voices/$LANG_CODE
[ -d "$IN" ] || { echo "no recordings in $IN" >&2; exit 1; }
mkdir -p "$OUT"
shopt -s nullglob
for f in "$IN"/*; do
  key=$(basename "${f%.*}")
  grep -qxF "$key" "$ROOT/prompts.txt" || { echo "skipping $f: unknown key $key" >&2; continue; }
  ffmpeg -nostdin -hide_banner -loglevel error -y -i "$f" \
    -af "highpass=f=80,silenceremove=start_periods=1:start_threshold=-45dB,areverse,silenceremove=start_periods=1:start_threshold=-45dB,areverse,loudnorm=I=-18:TP=-2" \
    -ar 48000 -ac 1 -c:a libopus -b:a 32k -map_metadata -1 "$OUT/$key.opus"
  echo "  $LANG_CODE/$key.opus"
done
