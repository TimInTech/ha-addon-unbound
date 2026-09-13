# Unbound

Recursive, caching and DNSSEC-validating DNS resolver ([NLnet Labs Unbound](https://github.com/NLnetLabs/unbound)).
It resolves names directly from the root servers, so no third-party DNS provider is needed.

## How it works

- The app uses the host network and listens **only on `127.0.0.1:5335`** (UDP and TCP).
  It is not reachable from your LAN and does not conflict with DNS on port 53 or mDNS on port 5353.
- The DNSSEC trust anchor is stored in the app data folder (`/data/root.key`) and kept up to date automatically.
- There are no options. Start the app and point your DNS server at it.

## Use with Pi-hole

1. Install and start this app.
2. In Pi-hole go to *Settings → DNS*, disable all upstream servers and set a custom upstream: `127.0.0.1#5335`.
3. Leave *Use DNSSEC* in Pi-hole disabled — Unbound already validates.

The Pi-hole app must use the host network (e.g. [casperklein's Pi-hole app](https://github.com/casperklein/homeassistant-addons/tree/master/pi-hole)).

**Do not combine with the DNSCrypt option of that Pi-hole app:** its dnscrypt-proxy also listens on `127.0.0.1:5335`.

## Verify

From a LAN client (replace the IP with your Home Assistant host):

```bash
dig @192.168.178.56 dnssec-failed.org   # expected: status SERVFAIL (DNSSEC validation works)
dig @192.168.178.56 example.com         # expected: NOERROR with an answer
```

## Updates

The image is built on your device from `alpine:3.24`. A new app version triggers a rebuild, which also pulls
the current Unbound package of that Alpine branch.
