FROM alpine
#RUN sed -i -e 's/v3\.[0-9][0-9]*/edge/g' /etc/apk/repositories
RUN apk update
RUN apk add bind python py-setuptools ca-certificates
RUN easy_install-2.7 dnspython

RUN mkdir /var/bind/data /var/bind/db_stage /var/bind/db_active

EXPOSE 52/udp
EXPOSE 52
VOLUME ["/var/bind/db_src"]

ADD zone_util.py named.sh db_gen_lib.sh lib.sh /
ADD conf /etc/bind

ADD liveness_check.sh /

ENTRYPOINT sh named.sh
