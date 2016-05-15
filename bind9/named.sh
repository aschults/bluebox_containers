set -e
. lib.sh

vardir=$rootdir/var/bind
logdir=$rootdir/var/log/named
etcdir=$rootdir/etc/bind
bind_conf_gen=$vardir/conf_generated
datadir=$vardir/data
export vardir logdir etcdir datadir

. db_gen_lib.sh

for f in `ls $etcdir/start.d`  ; do
  fn=$etcdir/start.d/$f
  if [ -x $fn ] ; then
     eval $fn
  else
     sh $fn
  fi 
done

if [ -e $bind_conf_gen ] ; then
  rm -rf $bind_conf_gen
fi
mkdir -p $bind_conf_gen
mkdir $bind_conf_gen/options.d
mkdir $bind_conf_gen/zones.d

expand_conf $datadir/options.d $bind_conf_gen/options.d
expand_conf $datadir/zones.d $bind_conf_gen/zones.d

optfn=$bind_conf_gen/named_gen.conf.options
{
  echo "options {" 
  collect_files '  include "$fn";\n' $bind_conf_gen/options.d
  echo "};" 
} >$optfn

optfn=$bind_conf_gen/named_gen.conf.zones
{
  collect_files '  include "$fn";\n' $bind_conf_gen/zones.d
} >$optfn

mkdir -p /var/bind/cache
named -g -c $etcdir/named.conf &
while true ; to
  update_dbs
  sleep 30
done
