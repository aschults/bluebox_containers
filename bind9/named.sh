set -e
. lib.sh

vardir=$rootdir/var/bind
logdir=$rootdir/var/log/named
etcdir=$rootdir/etc/bind
bind_conf_active=$vardir/conf_generated
bind_conf_stage=$vardir/conf_stage
datadir=$vardir/data
data_db=$bind_conf_active/db_active_data
etc_db=$bind_conf_active/db_active
export vardir logdir etcdir datadir data_db etc_db TTL

. db_gen_lib.sh

for f in `ls $etcdir/start.d`  ; do
  fn=$etcdir/start.d/$f
  if [ -x $fn ] ; then
     eval $fn
  else
     sh $fn
  fi 
done

if [ -e $bind_conf_active ] ; then
  rm -rf $bind_conf_stage
fi
mkdir -p $bind_conf_stage

if [ -e $bind_conf_active ] ; then
  rm -rf $bind_conf_active
fi
mkdir -p $bind_conf_active
mkdir $bind_conf_active/options.d
mkdir $bind_conf_active/zones.d
mkdir $bind_conf_active/zones_data.d

conf_failure_exit() {
  error_msg "config file failed to generate:" "$@"
}


gen_files() {
  update_dbs "$etcdir/options.d" "$bind_conf_stage/options.d" "$bind_conf_active/options.d"
  update_dbs "$etcdir/zones.d" "$bind_conf_stage/zones.d" "$bind_conf_active/zones.d"
  update_dbs "$datadir/zones.d" "$bind_conf_stage/zones_data.d" "$bind_conf_active/zones_data.d"
  COMMENT_STR=";"
  update_dbs "$datadir/db" "$bind_conf_stage/db_data" "$data_db"
  update_dbs "$etcdir/db" "$vardir/db_stage" "$etc_db"
  COMMENT_STR=

  optfn=$bind_conf_active/named_gen.conf.options
  {
    echo "options {" 
    collect_files '  include "$fn";\n' $bind_conf_active/options.d
    echo "};" 
  } >$optfn

  optfn=$bind_conf_active/named_gen.conf.zones
  {
    collect_files '  include "$fn";\n' $bind_conf_active/zones.d
    collect_files '  include "$fn";\n' $bind_conf_active/zones_data.d
  } >$optfn
} 


mkdir -p /var/bind/cache
FAILED_FILE_HANDLER=conf_failure_exit
gen_files
FAILED_FILE_HANDLER=

named-checkconf -z >/dev/null || error_msg "Config failure. Not starting named."
named -g -c $etcdir/named.conf &
named_pid=$!
while true ; do
  sleep ${RELOAD_TIME:-300}
  echo "updating DBs"
  if [ -f "$vardir/needs_reload" ] ; then
    rm "$vardir/needs_reload"
  fi

  gen_files

  if [ -f "$vardir/needs_reload" ] ; then
    rm "$vardir/needs_reload"
    if named-checkconf -z ; then
      kill -HUP $named_pid 
    else
      echo "Bad config, not reloading."
    fi
  fi
done
