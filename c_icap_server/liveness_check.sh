#!/bin/sh

if r=$(c-icap-client -i 127.0.0.1 -s squidclamav -req http://www.blah.com) ; then
  echo "all good"
else
  echo Failed
  echo $r
  exit 1
fi
