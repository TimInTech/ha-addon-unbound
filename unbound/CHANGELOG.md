# Changelog

## 1.1.2

- Rebuilt with updated Alpine packages:
  - `alpine-release` 3.24.1-r0 → 3.24.2-r0
  - `apk-tools` 3.0.6-r0 → 3.0.8-r0
  - `ca-certificates-bundle` 20260611-r0 → 20260909-r0
  - `libapk` 3.0.6-r0 → 3.0.8-r0
  - `libcrypto3` 3.5.7-r0 → 3.5.8-r0
  - `libssl3` 3.5.7-r0 → 3.5.8-r0
  - `unbound-libs` 1.25.2-r1 → 1.25.2-r2
  - `unbound` 1.25.2-r1 → 1.25.2-r2

## 1.1.1

- `unbound-anchor` uses IPv4 only, matching `do-ip6: no`, so a start without IPv6 does not wait for IPv6 timeouts.
- `unbound.conf` no longer restates Unbound defaults; the effective configuration is unchanged.
- Documentation: verification through Pi-hole explained, note on public names with private addresses.

## 1.1.0

- The container starts as the unprivileged user `unbound`; no root phase and no capabilities are needed.
- The DNSSEC trust anchor moved from `/data/root.key` into the image (`/var/lib/unbound/root.key`); `/data` is no longer used. A leftover `/data/root.key` from 1.0.x is ignored.
- CI enforces the unprivileged start (`--cap-drop ALL`, `no-new-privileges`).

## 1.0.1

- Entry script runs with `set -euo pipefail`.
- `unbound-anchor` results are evaluated and the trust anchor file is verified instead of ignoring every failure.

## 1.0.0

- Initial release: Unbound from Alpine 3.24 on `127.0.0.1:5335`, host network, DNSSEC trust anchor in `/data`.
