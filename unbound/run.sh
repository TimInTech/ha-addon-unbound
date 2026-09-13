#!/bin/sh
# shellcheck shell=busybox
set -euo pipefail

readonly DATA_DIR=/data
readonly TRUST_ANCHOR="$DATA_DIR/root.key"
readonly PACKAGE_ANCHOR=/usr/share/dnssec-root/trusted-key.key

mkdir -p "$DATA_DIR"
if [ ! -s "$TRUST_ANCHOR" ] && [ -s "$PACKAGE_ANCHOR" ]; then
    cp "$PACKAGE_ANCHOR" "$TRUST_ANCHOR"
fi

# unbound-anchor returns 1 after creating or updating the anchor and may return 0 even on write errors,
# so the file check below is what decides.
rc=0
unbound-anchor -a "$TRUST_ANCHOR" || rc=$?
case "$rc" in
    0 | 1) ;;
    *) echo "warning: unbound-anchor exited with $rc" >&2 ;;
esac
if [ ! -s "$TRUST_ANCHOR" ]; then
    echo "error: no DNSSEC trust anchor at $TRUST_ANCHOR" >&2
    exit 1
fi

chown -R unbound:unbound "$DATA_DIR"

unbound-checkconf /etc/unbound/unbound.conf
exec unbound -d -p -c /etc/unbound/unbound.conf
