docker build -t mysquid . 
docker stop testsq1 
docker rm testsq1 
#ep="-ti --entrypoint=sh"
docker run -e icap_req_a=icap://10.0.10.20:1344/squidclamav -e disk_cache_size=200 -e sslbump=1 --name=testsq1 -v /var/tmp/squiddisk2:/var/spool/squid/cache -v /var/tmp/squidssl:/var/spool/squid/ssl -v $PWD/tst_conf:/var/lib/squidGuard/conf.d -p 3333:3128 mysquid 


