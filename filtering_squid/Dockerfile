FROM aschults/bluebox_squid:base_latest
RUN apk update
RUN apk add db perl perl-uri perl-libwww libgcc
ENV SQUIDGUARD_VERSION=1.4
COPY build.sh /
RUN sh /build.sh

EXPOSE 3128
RUN mkdir -p /var/lib/squidGuard/conf.d /usr/local/squidGuard/lists
VOLUME ["/var/lib/squidGuard/conf.d"]

#ENV redirect_base=http://squidproxy/squidGuardLanding
ENV redirect_base=http://127.0.0.1/squidGuardLanding
RUN mkdir -p  /var/www/localhost/htdocs/squidGuardLanding
ADD blocked.txt /var/www/localhost/htdocs/squidGuardLanding
RUN curl -o /var/www/localhost/htdocs/squidGuardLanding/1x1.png https://upload.wikimedia.org/wikipedia/commons/c/ca/1x1.png


COPY sg_conf /usr/local/squidGuard/
COPY conf /etc/squid/
COPY liveness_check_sg.sh /
RUN mkdir -p  /var/www/localhost/htdocs/liveness
COPY liveness  /var/www/localhost/htdocs/liveness/
