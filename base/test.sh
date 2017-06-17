docker build -t mysquid . 
docker stop testsq1 
docker rm testsq1 

pwfile=/tmp/squidtest.passwd
if ! [ -f $pwfile ] ; then
  htpasswd -bc $pwfile bla bla
fi
docker run -e proxy_auth="$(cat $pwfile)" -e secondary_port=1 -e disk_cache_size=200 -e sslbump=1 --name=testsq1 -v /var/tmp/squiddisk2:/var/spool/squid/cache -e log_ssl=1 -v /var/tmp/squidssl:/var/spool/squid/ssl -v /var/tmp/squidconf.d:/etc/squid/conf_custom.d -p 3333:3128 -p 4444:3127 -ti --entrypoint=sh  mysquid

