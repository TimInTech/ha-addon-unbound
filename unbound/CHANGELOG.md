# Changelog

## 1.1.0

- The container starts as the unprivileged user `unbound`; no root phase and no capabilities are needed.
- The DNSSEC trust anchor moved from `/data/root.key` into the image (`/var/lib/unbound/root.key`); `/data` is no longer used. A leftover `/data/root.key` from 1.0.x is ignored.
- CI enforces the unprivileged start (`--cap-drop ALL`, `no-new-privileges`).

## 1.0.1

- Entry script runs with `set -euo pipefail`.
- `unbound-anchor` results are evaluated and the trust anchor file is verified instead of ignoring every failure.

## 1.0.0

- Initial release: Unbound from Alpine 3.24 on `127.0.0.1:5335`, host network, DNSSEC trust anchor in `/data`.
