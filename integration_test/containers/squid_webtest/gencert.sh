#!/bin/sh

set -x -e

cd /usr/local/apache2/conf 

openssl genrsa  -out server.key 2048
openssl req -batch -subj "/CN=squid-webtest/O=blah/OU=blah" -new -key server.key > cert.csr
openssl x509 -in cert.csr -out server.crt -req -signkey server.key -days 1001
