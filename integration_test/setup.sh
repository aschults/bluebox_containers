#!/bin/sh
set -e
docker build  -t squid_webtest containers/squid_webtest
docker run -d --name squid-webtest -p 9080:80 -p 9443:443 squid_webtest 

docker build -t squidtest_i ../base 

pwfile=/tmp/squidtest.passwd
if [ -f $pwfile ] ; then
  rm $pwfile
fi
htpasswd -bc $pwfile bla bla

docker run -e proxy_auth="$(cat $pwfile)" -e secondary_port=1 -e disk_cache_size=200 -e sslbump=1 --name=squidtest-c -v /var/tmp/squiddisk2:/var/spool/squid/cache -v /var/tmp/squidssl:/var/spool/squid/ssl -p 3333:3128 -p 4444:3127 --link squid-webtest:squid-webtest -d squidtest_i

