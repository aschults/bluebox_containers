docker build -t mysquid . 
docker stop testsq1 
docker rm testsq1 
docker run -e transparent=1 -e disk_cache_size=200 -e sslbump=1 --name=testsq1 -v /var/tmp/squiddisk2:/var/spool/squid/cache -v /var/tmp/squidssl:/var/spool/squid/ssl -p 3333:3128 mysquid

