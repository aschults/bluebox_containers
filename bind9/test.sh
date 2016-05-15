docker build -t mybind . 
docker stop bind1
docker rm bind1
#docker run -e disk_cache_size=200 -e sslbump=1 --name=testsq1 -v /var/tmp/squiddisk2:/var/spool/squid/cache -v /var/tmp/squidssl:/var/spool/squid/ssl -p 3333:3128 mysquid
docker run -e forwarders="4.4.4.4 8.8.8.8" -v $PWD/test_data:/var/bind/data --name=bind1 -ti -p 9953:53/udp -p 9953:53 --entrypoint=sh mybind 
#docker run --name=bind1 -ti -p 9953:53/udp -p 9953:53 mybind 

