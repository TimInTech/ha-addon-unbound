#!/bin/sh
# shellcheck shell=busybox
set -euo pipefail

readonly TRUST_ANCHOR=/var/lib/unbound/root.key

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

unbound-checkconf /etc/unbound/unbound.conf
exec unbound -d -p -c /etc/unbound/unbound.conf
