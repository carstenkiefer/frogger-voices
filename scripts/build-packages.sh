#!/usr/bin/env bash
# Build architecture-independent .deb and .rpm packages for every complete
# language (see scripts/check.py): frogger-voice-<lang>.
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

for lang in $(python3 "$ROOT/scripts/check.py"); do
  pkg=frogger-voice-$lang
  desc="Spoken enrollment prompts for FROGGER ($lang)"

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
License: see /usr/share/doc/$pkg/SOURCE.md
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
  # Pre-releases: Version 1.0.0, Release 0.alpha (sorts before 1.0.0-1).
  if [[ $PKG_VERSION == *~* ]]; then
    sed -i "s/^Release: .*/Release: 0.${PKG_VERSION#*~}/" "$top/SPECS/$pkg.spec"
  else
    sed -i "s/^Release: .*/Release: 1/" "$top/SPECS/$pkg.spec"
  fi
  rpmbuild --quiet --define "_topdir $top" -bb "$top/SPECS/$pkg.spec"
  cp "$top"/RPMS/noarch/*.rpm "$OUT/"
  echo "built $pkg"
done
ls "$OUT"
