#!/bin/sh
set -e

mkdir -p /data
if [ ! -s /data/root.key ] && [ -s /usr/share/dnssec-root/trusted-key.key ]; then
    cp /usr/share/dnssec-root/trusted-key.key /data/root.key
fi
# unbound-anchor exits 1 when it updated the key, which is not an error
unbound-anchor -a /data/root.key || true
chown -R unbound:unbound /data

unbound-checkconf /etc/unbound/unbound.conf
exec unbound -d -p -c /etc/unbound/unbound.conf
