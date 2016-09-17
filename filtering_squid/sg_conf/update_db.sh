#|/bin/sh
set -x -e
sg=/usr/local/squidGuard
b=$sg/db
c=/var/lib/squidGuard/conf.d

cd $b
if [ -d BL ] ; then rm -rf BL ; fi
curl http://www.shallalist.de/Downloads/shallalist.tar.gz | tar -xvzf -
chown -R squid /usr/local/squidGuard
chmod -R a+rX /usr/local/squidGuard
