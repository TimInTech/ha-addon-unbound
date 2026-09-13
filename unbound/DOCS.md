# Unbound

Recursive, caching and DNSSEC-validating DNS resolver ([NLnet Labs Unbound](https://github.com/NLnetLabs/unbound)).
It resolves names directly from the root servers, so no third-party DNS provider is needed.

## How it works

- The app uses the host network and listens **only on `127.0.0.1:5335`** (UDP and TCP).
  It is not reachable from your LAN and does not conflict with DNS on port 53 or mDNS on port 5353.
- The container runs as the unprivileged user `unbound` from the first command on and needs no capabilities.
  Because of that it cannot listen on ports below 1024.
- The DNSSEC trust anchor ships with the image (`/var/lib/unbound/root.key`), is refreshed with `unbound-anchor`
  on every start and follows key rollovers (RFC 5011) while running. The app data folder is not used; after an
  update or reinstall the anchor is bootstrapped again from the image.
- There are no options, by design: the Supervisor writes `options.json` readable for root only, and this app
  never runs as root. Start the app and point your DNS server at it.

## Use with Pi-hole

1. Install and start this app.
2. In Pi-hole go to *Settings → DNS*, disable all upstream servers and set a custom upstream: `127.0.0.1#5335`.
3. Leave *Use DNSSEC* in Pi-hole disabled — Unbound already validates.

The Pi-hole app must use the host network (e.g. [casperklein's Pi-hole app](https://github.com/casperklein/homeassistant-addons/tree/master/pi-hole)).

**Do not combine with the DNSCrypt option of that Pi-hole app:** its dnscrypt-proxy also listens on `127.0.0.1:5335`.

## Private addresses in public DNS

Unbound drops answers from public DNS that point to private address ranges, which protects against DNS rebinding.
Public names that deliberately resolve to a private IP (for example `*.plex.direct`) therefore do not resolve.
The app has no option for exceptions; if you need such a name, add it as a local DNS record in Pi-hole.

## Verify

From a LAN client, query Pi-hole on port 53 (replace `192.0.2.10` with the IP address of your Home Assistant host):

```bash
dig @192.0.2.10 dnssec-failed.org   # expected: status SERVFAIL
dig @192.0.2.10 example.com         # expected: NOERROR with an answer
```

These queries go through Pi-hole. The SERVFAIL shows that Unbound validates DNSSEC only while `127.0.0.1#5335`
is Pi-hole's only upstream server.

## Updates

The image is built on your device from the Alpine base image pinned in the `Dockerfile`. A new app version
triggers a rebuild, which also pulls the current Unbound package of that Alpine branch.

A weekly job rebuilds the image; when any Alpine package in it changed (for example `unbound` or `libssl3`),
it publishes a patch version after the amd64 smoke test and the aarch64 build passed, so Home Assistant offers
the update.
`apk-packages.txt` lists the package versions of the latest release.
