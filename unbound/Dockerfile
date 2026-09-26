FROM alpine:3.24

RUN apk add --no-cache unbound \
    && install -d -o unbound -g unbound -m 0755 /var/lib/unbound \
    && install -o unbound -g unbound -m 0644 /usr/share/dnssec-root/trusted-key.key /var/lib/unbound/root.key

COPY unbound.conf /etc/unbound/unbound.conf
COPY run.sh /run.sh
RUN chmod 0755 /run.sh

USER unbound

# Supervisor reads this to restart the app if Unbound stops accepting connections.
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
    CMD nc -z -w 2 127.0.0.1 5335 || exit 1

CMD ["/run.sh"]
