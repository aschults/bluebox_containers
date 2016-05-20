set -e
. lib.sh

vardir=$rootdir/var/bind
logdir=$rootdir/var/log/named
etcdir=$rootdir/etc/bind
bind_conf_gen=$vardir/conf_generated
datadir=$vardir/data
data_db=$vardir/db_active_data
etc_db=$vardir/db_active
export vardir logdir etcdir datadir data_db etc_db

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
mkdir $bind_conf_gen/zones_data.d

conf_failure_exit() {
  error_msg "config file failed to generate:" "$@"
}
FAILED_FILE_HANDLER=conf_failure_exit
expand_conf $etcdir/options.d $bind_conf_gen/options.d
expand_conf $etcdir/zones.d $bind_conf_gen/zones.d
expand_conf $datadir/zones.d $bind_conf_gen/zones_data.d

optfn=$bind_conf_gen/named_gen.conf.options
{
  echo "options {" 
  collect_files '  include "$fn";\n' $bind_conf_gen/options.d
  echo "};" 
} >$optfn

optfn=$bind_conf_gen/named_gen.conf.zones
{
  collect_files '  include "$fn";\n' $bind_conf_gen/zones.d
  collect_files '  include "$fn";\n' $bind_conf_gen/zones_data.d
} >$optfn

mkdir -p /var/bind/cache
update_dbs "$datadir/db" "$vardir/db_stage_data" "$data_db"
update_dbs "$etcdir/db" "$vardir/db_stage" "$etc_db"
FAILED_FILE_HANDLER=

named-checkconf -z || error_msg "Config failure. Not starting named."
named -g -c $etcdir/named.conf &
named_pid=$!
while true ; do
  sleep 30
  echo "updating DBs"
  if [ -f "$vardir/needs_reload" ] ; then
    rm "$vardir/needs_reload"
  fi

  update_dbs "$datadir/db" "$vardir/db_stage_data" "$data_db"
  update_dbs "$etcdir/db" "$vardir/db_stage" "$etc_db"

  if [ -f "$vardir/needs_reload" ] ; then
    rm "$vardir/needs_reload"
    kill -HUP $named_pid 
  fi
done
