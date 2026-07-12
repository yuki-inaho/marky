#!/bin/sh

APPDIR=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
name=$(basename "$0")
exec "$APPDIR/lib64/ld-linux-x86-64.so.2" \
  --library-path "$APPDIR/lib64:$APPDIR/usr/lib:$APPDIR/usr/lib/gstreamer-1.0" \
  "$APPDIR/usr/lib/webkit2gtk-4.1/.real-$name" "$@"
