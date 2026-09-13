# TimInTech Home Assistant Apps

Home Assistant app repository.

## Apps

### [Unbound](./unbound)

Recursive, DNSSEC-validating DNS resolver on `127.0.0.1:5335` — a local upstream for Pi-hole running on Home Assistant.
Supports `amd64` and `aarch64`. See the [documentation](./unbound/DOCS.md).

## Installation

1. *Settings → Apps → App store → ⋮ → Repositories*
2. Add `https://github.com/TimInTech/ha-addon-unbound`
3. Install **Unbound**, start it, then set `127.0.0.1#5335` as the only upstream DNS server in Pi-hole.

## License

MIT
