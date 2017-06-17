FROM alpine
#RUN sed -i -e 's/v3\.[0-9][0-9]*/edge/g' /etc/apk/repositories
RUN apk update && apk add gettext apache2

RUN mkdir /run/apache2 && chown apache /run/apache2
RUN mkdir /etc/apache2/start.d

RUN rm /etc/apache2/conf.d/userdir.conf
RUN rm /var/www/localhost/htdocs/index.html
ADD conf.d /etc/apache2/conf.d/
ADD htdocs  /var/www/localhost/htdocs/


EXPOSE 80
VOLUME ["/var/bind/data"]

ADD apache.sh /

ENV RELOAD_TIME=300

ENTRYPOINT sh apache.sh
