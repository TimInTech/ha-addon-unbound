# Changelog

## 1.0.1

- Entry script runs with `set -euo pipefail`.
- `unbound-anchor` results are evaluated and the trust anchor file is verified instead of ignoring every failure.

## 1.0.0

- Initial release: Unbound from Alpine 3.24 on `127.0.0.1:5335`, host network, DNSSEC trust anchor in `/data`.
