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

## Maintenance

- **CI** (`ci.yml`): app linter, ShellCheck, amd64/aarch64 builds and `tests/smoke.sh --hardened`
  (resolution, DNSSEC, restart, unprivileged start) on every push to `main` and every pull request.
- **Package updates** (`package-updates.yml`, Mondays and on demand): rebuilds the image, compares the installed
  Alpine packages with `unbound/apk-packages.txt` and, after the smoke test, commits a patch release with changelog.
- **Dependabot**: weekly pull requests for the Alpine base image and pinned GitHub Actions. A new Alpine branch
  changes the package set, so the next package-update run releases it.
- GitHub pauses scheduled workflows after 60 days without repository activity; re-enable *Package updates*
  in the Actions tab if that happens.

## License

MIT
