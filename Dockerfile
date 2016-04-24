FROM alpine
RUN apk update
RUN apk add squid gettext

EXPOSE 3128
RUN mkdir -p /var/spool/squid/cache /var/log/squid ; chown -R squid:squid /var/spool/squid/cache /var/log/squid
VOLUME ["/var/spool/squid/cache", "/var/log/squid"]

COPY conf /etc/squid/
ADD squid.sh /
ADD lib.sh /

ENTRYPOINT sh squid.sh
