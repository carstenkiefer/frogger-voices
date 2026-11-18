#!/usr/bin/env bash
# Build architecture-independent .deb and .rpm packages for every complete
# language (see scripts/check.py): frogger-voice-<lang>. Plus two
# metapackages without files of their own: frogger-voices-all (every
# language) and frogger-voices-free (only languages whose clips may be used
# commercially, i.e. without a "NC" license).
#
#   VERSION=1.0.0 scripts/build-packages.sh [out-dir]
#
# Needs dpkg-deb and rpmbuild. Clips go to /usr/share/frogger/voices/<lang>/.
set -euo pipefail
ROOT=$(cd "$(dirname "$0")/.." && pwd)
OUT=${1:-$ROOT/dist}
VERSION=${VERSION:-0.0.0}
PKG_VERSION=${VERSION//-/\~}
MAINTAINER=${MAINTAINER:-"FROGGER maintainers <frogger@users.noreply.github.com>"}
mkdir -p "$OUT"
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

rpm_release() { # spec file: pre-releases get Release 0.alpha (sorts before 1.0.0-1)
  if [[ $PKG_VERSION == *~* ]]; then
    sed -i "s/^Release: .*/Release: 0.${PKG_VERSION#*~}/" "$1"
  else
    sed -i "s/^Release: .*/Release: 1/" "$1"
  fi
}

ALL=() FREE=()
for lang in $(python3 "$ROOT/scripts/check.py"); do
  pkg=frogger-voice-$lang
  desc="Spoken enrollment prompts for FROGGER ($lang)"
  license=$(sed -n 's/^\* \*\*License of the clips:\*\* \[\([^]]*\)\].*/\1/p' "$ROOT/voices/$lang/SOURCE.md")
  [ -n "$license" ] || { echo "voices/$lang/SOURCE.md: license of the clips not found" >&2; exit 1; }
  ALL+=("$pkg")
  [[ $license == *NC* ]] || FREE+=("$pkg")

  # ---- staged file tree ----
  r=$WORK/$pkg/root
  install -d "$r/usr/share/frogger/voices/$lang" "$r/usr/share/doc/$pkg"
  install -m644 "$ROOT"/voices/"$lang"/*.opus "$r/usr/share/frogger/voices/$lang/"
  install -m644 "$ROOT/voices/$lang/SOURCE.md" "$r/usr/share/doc/$pkg/SOURCE.md"

  # ---- .deb ----
  d=$WORK/$pkg/deb
  cp -a "$r" "$d"
  install -d "$d/DEBIAN"
  size=$(du -sk "$d/usr" | cut -f1)
  cat >"$d/DEBIAN/control" <<CTL
Package: $pkg
Version: $PKG_VERSION
Architecture: all
Maintainer: $MAINTAINER
Installed-Size: $size
Depends: frogger
Section: misc
Priority: optional
Homepage: https://github.com/carstenkiefer/frogger-voices
Description: $desc
 Short audio clips that FROGGER plays during face enrollment, so that the
 instructions can be followed with closed eyes. Origin and license of the
 recordings: /usr/share/doc/$pkg/SOURCE.md.
CTL
  dpkg-deb --root-owner-group --build "$d" "$OUT/${pkg}_${PKG_VERSION}_all.deb" >/dev/null

  # ---- .rpm ----
  top=$WORK/$pkg/rpm
  install -d "$top"/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
  cat >"$top/SPECS/$pkg.spec" <<SPEC
Name: $pkg
Version: ${PKG_VERSION%%~*}
Release: ${PKG_VERSION#*~}%{!?_pre:1}
Summary: $desc
License: ${license:-see /usr/share/doc/$pkg/SOURCE.md}
URL: https://github.com/carstenkiefer/frogger-voices
BuildArch: noarch
Requires: frogger

%description
Short audio clips that FROGGER plays during face enrollment, so that the
instructions can be followed with closed eyes.

%install
cp -a $r/. %{buildroot}/

%files
/usr/share/frogger/voices/$lang
%doc /usr/share/doc/$pkg/SOURCE.md
SPEC
  rpm_release "$top/SPECS/$pkg.spec"
  rpmbuild --quiet --define "_topdir $top" -bb "$top/SPECS/$pkg.spec"
  cp "$top"/RPMS/noarch/*.rpm "$OUT/"
  echo "built $pkg"
done

# ---- metapackages ----
meta() { # name summary description deps...
  local pkg=$1 summary=$2 text=$3; shift 3
  local d=$WORK/$pkg/deb top=$WORK/$pkg/rpm
  install -d "$d/DEBIAN" "$top"/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
  local IFS=,
  cat >"$d/DEBIAN/control" <<CTL
Package: $pkg
Version: $PKG_VERSION
Architecture: all
Maintainer: $MAINTAINER
Depends: ${*//,/, }
Section: misc
Priority: optional
Homepage: https://github.com/carstenkiefer/frogger-voices
Description: $summary
 $text
CTL
  unset IFS
  dpkg-deb --root-owner-group --build "$d" "$OUT/${pkg}_${PKG_VERSION}_all.deb" >/dev/null
  {
    echo "Name: $pkg"
    echo "Version: ${PKG_VERSION%%~*}"
    echo "Release: 1"
    echo "Summary: $summary"
    echo "License: MIT OR Apache-2.0"
    echo "URL: https://github.com/carstenkiefer/frogger-voices"
    echo "BuildArch: noarch"
    for dep in "$@"; do echo "Requires: $dep"; done
    printf '\n%%description\n%s\n\n%%files\n' "$text"
  } >"$top/SPECS/$pkg.spec"
  rpm_release "$top/SPECS/$pkg.spec"
  rpmbuild --quiet --define "_topdir $top" -bb "$top/SPECS/$pkg.spec"
  cp "$top"/RPMS/noarch/*.rpm "$OUT/"
  echo "built $pkg (${#@} languages)"
}
meta frogger-voices-all "Spoken enrollment prompts for FROGGER – all languages" \
  "Installs the voice packages of all languages. Some of them are licensed for non-commercial use only (see their SOURCE.md); for commercial use install frogger-voices-free instead." \
  "${ALL[@]}"
meta frogger-voices-free "Spoken enrollment prompts for FROGGER – freely licensed languages" \
  "Installs the voice packages of all languages whose clips may also be used commercially (CC0 or CC BY)." \
  "${FREE[@]}"
ls "$OUT"
