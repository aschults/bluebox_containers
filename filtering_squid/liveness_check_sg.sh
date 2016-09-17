#!/bin/sh
echo "'http://squidproxy/liveness/test_url.txt 127.0.0.1/liveness_user liveness_user GET" | squidGuard | grep http 
if [ $? -gt 0 ] ; then
  echo "failed"
  exit 1
fi
sh /liveness_check.sh
