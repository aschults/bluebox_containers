FROM alpine
RUN sed -i -e 's/v3\.[0-9][0-9]*/edge/g' /etc/apk/repositories
RUN apk update
RUN apk add squid gettext openssl ca-certificates
RUN update-ca-certificates

EXPOSE 3128
RUN mkdir -p /var/spool/squid/cache /var/log/squid ; chown -R squid:squid /var/spool/squid/cache /var/log/squid
VOLUME ["/var/spool/squid/cache", "/var/log/squid", "/var/spool/squid/ssl"]

COPY conf /etc/squid/
ADD squid.sh /
ADD lib.sh /

ENTRYPOINT sh squid.sh
