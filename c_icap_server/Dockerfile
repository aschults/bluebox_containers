FROM alpine
#RUN sed -i -e 's/v3\.[0-9][0-9]*/edge/g' /etc/apk/repositories
RUN apk update
RUN apk add gettext pcre clamav-lib zlib db perl

ENV C_ICAP_VERSION=0.4.4
ENV SQUIDCLAMAV_VERSION=6.16

ADD build.sh /
RUN sh build.sh

RUN mv /etc/c-icap /etc/c-icap.orig && mkdir /etc/c-icap
ADD conf /conf
ADD lib.sh /
ADD liveness_check.sh /

ADD icap.sh /


EXPOSE 1344
ENTRYPOINT sh icap.sh
