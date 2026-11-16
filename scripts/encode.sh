#!/usr/bin/env bash
# encode.sh <in.wav> <out.opus>: trim silence, -18 LUFS, Opus mono 48 kHz.
set -euo pipefail
ffmpeg -nostdin -hide_banner -loglevel error -y -i "$1" \
  -af "silenceremove=start_periods=1:start_threshold=-50dB,areverse,silenceremove=start_periods=1:start_threshold=-50dB,areverse,loudnorm=I=-18:TP=-2" \
  -ar 48000 -ac 1 -c:a libopus -b:a 32k -map_metadata -1 "$2"
