FROM httpd:alpine


RUN apk update && apk add openssl

RUN  perl -i -pe '(m%Include conf/extra/httpd-ssl.conf% || m%LoadModule (ssl_module|socache_shmcb_module)%) && do {s/^#//;};' /usr/local/apache2/conf/httpd.conf && echo "ServerName squid-webtest" >>/usr/local/apache2/conf/httpd.conf
RUN  perl -i -pe 'm%^ServerName% && do {$_="ServerName squid-webtest:443\n"}; m/VirtualXXHost/ && do{ s/^/#/; }' /usr/local/apache2/conf/extra/httpd-ssl.conf
ADD gencert.sh /usr/local/apache2/conf/
RUN sh /usr/local/apache2/conf/gencert.sh
RUN cp /usr/local/apache2/conf/server.crt /usr/local/apache2/htdocs/


