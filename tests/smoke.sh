#!/usr/bin/env bash
# Smoke test for the Unbound app image: resolution, DNSSEC, restart and optional privilege checks.
# Usage: tests/smoke.sh IMAGE [--hardened]
set -euo pipefail

image=${1:?usage: tests/smoke.sh IMAGE [--hardened]}
mode=${2:-}
port=5335
name="unbound-smoke-$$"
volume="unbound-smoke-data-$$"

cleanup() {
    docker rm -f "$name" >/dev/null 2>&1 || true
    docker volume rm -f "$volume" >/dev/null 2>&1 || true
}
trap cleanup EXIT

fail() {
    echo "FAIL: $*" >&2
    docker logs "$name" >&2 2>&1 || true
    exit 1
}

query() {
    dig @127.0.0.1 -p "$port" "$@" +time=5 +tries=2
}

wait_ready() {
    for _ in $(seq 1 30); do
        if dig @127.0.0.1 -p "$port" example.com +time=2 +tries=1 >/dev/null 2>&1; then
            return 0
        fi
        sleep 1
    done
    fail "resolver not ready on 127.0.0.1:$port"
}

check_dns() {
    local out
    out=$(query example.com A +dnssec)
    grep -q 'status: NOERROR' <<<"$out" || fail "example.com did not resolve"
    grep -qE 'flags:[a-z ]* ad[ ;]' <<<"$out" || fail "AD flag missing, DNSSEC not validated"
    out=$(query dnssec-failed.org A)
    grep -q 'status: SERVFAIL' <<<"$out" || fail "dnssec-failed.org resolved, DNSSEC validation not enforced"
}

check_unprivileged() {
    local user uid
    user=$(docker image inspect -f '{{.Config.User}}' "$image")
    case "$user" in
        "" | root | 0 | 0:*) fail "image starts as root (USER='$user')" ;;
    esac
    uid=$(docker exec "$name" awk '/^Uid:/ {print $2}' /proc/1/status)
    [ "$uid" != "0" ] || fail "resolver process runs as uid 0"
    echo "ok: image USER=$user, resolver uid=$uid"
}

if ss -lnut | grep -q ":$port "; then
    echo "FAIL: port $port is already in use on this host" >&2
    exit 1
fi

run_args=(--network host -v "$volume:/data")
if [ "$mode" = "--hardened" ]; then
    run_args+=(--cap-drop ALL --security-opt no-new-privileges)
fi

# A named volume is root-owned, like the /data folder the Supervisor mounts on a fresh install.
docker volume create "$volume" >/dev/null
docker run -d --name "$name" "${run_args[@]}" "$image" >/dev/null

wait_ready
check_dns
echo "ok: resolution and DNSSEC"

if [ "$mode" = "--hardened" ]; then
    check_unprivileged
fi

docker restart "$name" >/dev/null
wait_ready
check_dns
echo "ok: resolution and DNSSEC after restart"

echo "PASS: $image ${mode:-(functional)}"
