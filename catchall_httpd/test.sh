docker build -t myhttpd . || exit
docker stop httpd1
docker rm httpd1
docker run  --name=httpd1 -ti -p 8099:80 --entrypoint=sh myhttpd
#docker run --name=httpd1 -ti -p  8099:80 myhttpd

