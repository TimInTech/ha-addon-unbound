FROM alpine:3.24

RUN apk add --no-cache unbound

COPY unbound.conf /etc/unbound/unbound.conf
COPY run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh"]
