#!/bin/sh
set -eu

package=precision-7780-audio-fix
version=1.0.0-1
root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
stage="$root/build/$package"
output="$root/dist/${package}_${version}_all.deb"

rm -rf "$root/build"
mkdir -p "$stage" "$root/dist"
cp -a "$root/package/." "$stage/"

gzip -9n "$stage/usr/share/doc/$package/changelog.Debian"
find "$stage" -type d -exec chmod 0755 {} +
chmod 0755 "$stage/DEBIAN/postinst" "$stage/DEBIAN/postrm"
chmod 0644 \
    "$stage/DEBIAN/control" \
    "$stage/DEBIAN/conffiles" \
    "$stage/etc/modprobe.d/dell-precision-7780-audio.conf" \
    "$stage/usr/share/doc/$package/README.Debian" \
    "$stage/usr/share/doc/$package/changelog.Debian.gz"

dpkg-deb --root-owner-group --build "$stage" "$output"
sha256sum "$output"
