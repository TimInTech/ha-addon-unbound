# Contributing

This is a small, single-maintainer app. Contributions are welcome, but please open an issue before
starting non-trivial work so effort isn't wasted on something that doesn't fit the project's scope
(a minimal, zero-configuration DNS resolver app).

## Reporting a bug

Use the [bug report template](.github/ISSUE_TEMPLATE/bug_report.yml) and include:

- App version (`unbound/config.yaml` → `version`, or the version shown in the Supervisor)
- Home Assistant OS/Supervisor version and architecture (amd64/aarch64)
- Relevant log output from the app's *Log* tab
- Steps to reproduce

Please do **not** open a public issue for security vulnerabilities — see [SECURITY.md](SECURITY.md).

## Proposing a change

1. Open an issue first for anything beyond a small fix (typo, docs, obvious bug), describing the problem
   and your proposed approach.
2. Fork the repository and create a branch from `main`.
3. Keep changes focused; unrelated cleanups belong in a separate PR.
4. Run the checks locally where possible before opening a PR:
   ```bash
   shellcheck unbound/run.sh tests/smoke.sh .github/scripts/package-update.sh
   docker build -t unbound-test:ci unbound
   tests/smoke.sh unbound-test:ci --hardened
   ```
5. Open the pull request against `main`. CI (app linter, ShellCheck, multi-arch build, smoke test) runs
   automatically; please fix any failures it reports.

## Scope

Changes that add configuration options, a web UI, or additional services are unlikely to be accepted —
the app is intentionally zero-configuration. Changes that improve reliability, security, documentation,
or CI/build robustness are welcome.
