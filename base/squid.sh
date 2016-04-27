set -e
. lib.sh

vardir=$rootdir/var/spool/squid
logdir=$rootdir/var/log/squid
confdir=$rootdir/etc/squid/conf.d
cachedir=$vardir/cache
conf_gen=$vardir/conf_generated
export vardir logdir confdir cachedir

touch $logdir/cache.log
chown squid:squid $logdir/cache.log

for f in `ls $rootdir/etc/squid/start.d`  ; do
  fn=$rootdir/etc/squid/start.d/$f
  if [ -x $fn ] ; then
     eval $fn
  else
     sh $fn
  fi 
done

if ! [ -d $conf_gen ] ; then
  rm -rf $conf_gen
fi
mkdir -p $conf_gen

expand_conf $confdir $conf_gen

chown -R squid:squid $cachedir
squid -N -z
squid

tail -f $logdir/cache.log

