#!/bin/sh

SCRIPT="$(readlink -f "$0")"
ROOT="$(CDPATH= cd -- "$(dirname -- "$SCRIPT")/.." && pwd)"
ROOTFS=${MARKY_ROOTFS:-/home/kasm-user/ubuntu-jammy-rootfs}
BINARY="$ROOT/src-tauri/target/release/marky"

if [ ! -x "$BINARY" ]; then
  echo "marky: build first with pnpm tauri build" >&2
  exit 1
fi
if [ ! -x "$ROOTFS/bin/sh" ] || [ ! -e "$ROOTFS/lib64/ld-linux-x86-64.so.2" ]; then
  echo "marky: Ubuntu 22.04 runtime rootfs is missing: $ROOTFS" >&2
  exit 1
fi

cp -f "$BINARY" "$ROOTFS/usr/bin/marky"
chmod +x "$ROOTFS/usr/bin/marky"
export WEBKIT_EXEC_PATH=/usr/lib/x86_64-linux-gnu/webkit2gtk-4.1
export GST_PLUGIN_PATH=/usr/lib/x86_64-linux-gnu/gstreamer-1.0
export GST_PLUGIN_SYSTEM_PATH_1_0="$GST_PLUGIN_PATH"

exec proot -0 -r "$ROOTFS" \
  -b /dev -b /proc -b /sys -b /run -b /tmp -b /home:/home \
  /usr/bin/marky "$@"
