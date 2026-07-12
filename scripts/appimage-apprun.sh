#!/bin/sh

APPDIR=${APPDIR:-$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)}

# Ubuntu 20.04 cannot load the WebKitGTK 4.1/GLib 2.72 build with its
# system glibc. The bundled mini-root is executed through proot so the
# AppImage remains usable even when FUSE is unavailable.
if command -v proot >/dev/null 2>&1; then
  ROOTFS=${MARKY_ROOTFS:-$APPDIR/runtime-root}
  export WEBKIT_EXEC_PATH="/usr/lib/x86_64-linux-gnu/webkit2gtk-4.1"
  export GST_PLUGIN_PATH="/usr/lib/x86_64-linux-gnu/gstreamer-1.0"
  export GST_PLUGIN_SYSTEM_PATH_1_0="/usr/lib/x86_64-linux-gnu/gstreamer-1.0"
  exec proot -0 -r "$ROOTFS" \
    -b /dev -b /proc -b /sys -b /run -b /tmp -b /home:/home \
    /usr/bin/marky "$@"
fi

# Fallback for a normal Ubuntu 22.04+ host where proot is not installed.
export WEBKIT_EXEC_PATH="$APPDIR/usr/lib/webkit2gtk-4.1"
export GST_PLUGIN_PATH="$APPDIR/usr/lib/gstreamer-1.0"
export GST_PLUGIN_SYSTEM_PATH_1_0="$APPDIR/usr/lib/gstreamer-1.0"
exec "$APPDIR/lib64/ld-linux-x86-64.so.2" \
  --library-path "$APPDIR/lib64:$APPDIR/usr/lib:$APPDIR/usr/lib/gstreamer-1.0" \
  "$APPDIR/usr/bin/marky" "$@"
