docker build -t aschults/bluebox_squid:bind_latest ../bind9
docker build -t mybind . 
docker stop bind1
docker rm bind1
docker run -e RELOAD_TIME=60 -e forwarders="4.4.4.4 8.8.8.8" -v $PWD../bind9/test/test_data:/var/bind/data --name=bind1 -ti -p 9953:53/udp -p 9953:53 --entrypoint=sh mybind 

