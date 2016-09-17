#!/bin/sh
set -x -e

. /lib.sh

sg=/usr/local/squidGuard
b=$sg/db
c=/var/lib/squidGuard/conf.d
c2=/var/lib/squidGuard/conf_gen

cat <<EOF >$b/liveness_urls
squidproxy/liveness/test_url.txt
EOF

(
cat <<EOF
dbhome $b
logdir $sg/log

src liveness {
        user            liveness_user
}

dest liveness {
  urllist liveness_urls
}
acl {
  default {
      pass    !liveness
      redirect http://squidproxy/liveness/redirect_ok.txt
  }
}

###########################
EOF

find $b -type d | while read d ; do
  t=${d#$b/}
  r=""
  if [ -f $d/domains ] ; then r="$r"$'\n'"     domainlist $t/domains" ;fi
  if [ -f $d/urls ] ; then r="$r"$'\n'"     urllist $t/urls" ; fi
  if [ -f $d/expressions ] ; then r="$r"$'\n'"     expressionlist $t/expressions" ; fi
  if [ -n "$r" ] ; then 
    echo "dest $t {$r"$'\n'"}"
  fi
done
) >$sg/squidGuard.conf.new

if [ -d $c2 ] ; then rm -rf $c2 ; fi
mkdir $c2
expand_conf $c $c2

for i in $c2/* ; do
  if [ -f $i ] ; then
    cat $i >>$sg/squidGuard.conf.new
  fi
done

mv $sg/squidGuard.conf.new $sg/squidGuard.conf
