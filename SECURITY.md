# Security policy

## Supported versions

Only the latest release of the Unbound app receives fixes. Updated Unbound and Alpine packages are picked up by the
weekly package-update workflow and published as a new patch release; install it from Home Assistant when offered.

## Reporting a vulnerability

Please do **not** open a public issue for security problems.

- **This app** (Dockerfile, entry script, configuration, workflows): report privately via
  [GitHub private vulnerability reporting](https://github.com/TimInTech/ha-addon-unbound/security/advisories/new).
  Reports are handled on a best-effort basis; please include the app version and steps to reproduce.
- **Unbound itself**: report to NLnet Labs as described at <https://www.nlnetlabs.nl/security-report/>.
