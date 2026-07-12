#!/usr/bin/env bash

rootfs="${MARKY_ROOTFS:-/home/kasm-user/ubuntu-jammy-rootfs}"
args=" $* "

case "$args" in
  *" -lwebkit2gtk-4.1 "*|*" -lsoup-3.0 "*|*" -ljavascriptcoregtk-4.1 "*)
    rewritten=()
    for arg in "$@"; do
      case "$arg" in
        -lc)
          rewritten+=("$rootfs/usr/lib/x86_64-linux-gnu/libc.so.6")
          rewritten+=("$rootfs/usr/lib/x86_64-linux-gnu/libc_nonshared.a")
          ;;
        -lpthread|-ldl|-lrt|-lutil)
          # Jammy's glibc keeps these compatibility DSOs free of most
          # symbols; libc.so.6 contains the merged implementations.
          ;;
        -lm)
          rewritten+=("$rootfs/usr/lib/x86_64-linux-gnu/libm.so.6")
          ;;
        -lgcc_s)
          rewritten+=("$rootfs/usr/lib/x86_64-linux-gnu/libgcc_s.so.1")
          ;;
        *)
          rewritten+=("$arg")
          ;;
      esac
    done
    exec /usr/bin/cc \
      -nostartfiles \
      "$rootfs/usr/lib/x86_64-linux-gnu/Scrt1.o" \
      "$rootfs/usr/lib/x86_64-linux-gnu/crti.o" \
      "$rootfs/usr/lib/gcc/x86_64-linux-gnu/11/crtbeginS.o" \
      -L"$rootfs/usr/lib/x86_64-linux-gnu" \
      -L"$rootfs/lib/x86_64-linux-gnu" \
      "${rewritten[@]}" \
      "$rootfs/usr/lib/gcc/x86_64-linux-gnu/11/crtendS.o" \
      "$rootfs/usr/lib/x86_64-linux-gnu/crtn.o"
    ;;
  *)
    exec /usr/bin/cc "$@"
    ;;
esac
