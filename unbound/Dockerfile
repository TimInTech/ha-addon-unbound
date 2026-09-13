FROM alpine:3.24

RUN apk add --no-cache unbound \
    && install -d -o unbound -g unbound -m 0755 /var/lib/unbound \
    && install -o unbound -g unbound -m 0644 /usr/share/dnssec-root/trusted-key.key /var/lib/unbound/root.key

COPY unbound.conf /etc/unbound/unbound.conf
COPY run.sh /run.sh
RUN chmod 0755 /run.sh

USER unbound

CMD ["/run.sh"]
