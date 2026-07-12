#!/bin/sh

SCRIPT="$(readlink -f "$0")"
ROOT="$(CDPATH= cd -- "$(dirname -- "$SCRIPT")/.." && pwd)"
APPIMAGE=${MARKY_APPIMAGE:-/home/kasm-user/.local/opt/marky-yuki/Marky.AppImage}

if [ ! -x "$APPIMAGE" ]; then
  APPIMAGE="$ROOT/Marky_0.1.3_ubuntu20_amd64.AppImage"
fi

if [ -d "${MARKY_ROOTFS:-/home/kasm-user/ubuntu-jammy-rootfs}" ]; then
  export MARKY_ROOTFS="${MARKY_ROOTFS:-/home/kasm-user/ubuntu-jammy-rootfs}"
fi

if [ -e /dev/fuse ]; then
  exec "$APPIMAGE" "$@"
fi

exec "$APPIMAGE" --appimage-extract-and-run "$@"
