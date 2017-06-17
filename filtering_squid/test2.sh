docker stop testsq2 
docker rm testsq2 
ep="-ti --entrypoint=sh"
docker run $ep -e icap_server=bigbox:9999 -e icap_req_a=/echo -e disk_cache_size=200 -e sslbump=1 --name=testsq2 -v /var/tmp/squiddisk2:/var/spool/squid/cache -v /var/tmp/squidssl:/var/spool/squid/ssl -v $PWD/tst_conf:/var/lib/squidGuard/conf.d -p 3333:3128 aschults/bluebox_squid:filtering_squid_latest


