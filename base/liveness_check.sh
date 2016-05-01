#!/bin/sh
export http_proxy=localhost:3128 

fn=/var/www/localhost/htdocs/test.txt

data=`dd if=/dev/urandom bs=10 count=1 | od -x`
echo "$data" >$fn

res=`curl http://squidproxy/test.txt -H "Cache-control: no-cache"`

if [ "$data" = "$res" ] ; then
  echo "matching, squid working"
  exit 0
else
  echo "no cache update, problem!"
  exit 1
fi 
