FROM alpine
#RUN sed -i -e 's/v3\.[0-9][0-9]*/edge/g' /etc/apk/repositories
RUN apk update
RUN apk add gettext bind python py-setuptools ca-certificates diffutils
RUN easy_install-2.7 dnspython

RUN mkdir -p /var/bind/data /var/bind/db_active /var/bind/db_active_data /etc/bind/options.d /etc/bind/zones.d /etc/bind/db

EXPOSE 52/udp
EXPOSE 52
VOLUME ["/var/bind/data"]

ADD zone_util.py named.sh db_gen_lib.sh lib.sh /
ADD conf /etc/bind

ADD liveness_check.sh /

ENTRYPOINT sh named.sh
