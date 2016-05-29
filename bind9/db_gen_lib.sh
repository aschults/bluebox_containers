#. lib.sh

zone_util() {
  python ${utildir:-}/zone_util.py "$@"
}

#;| reverse_zone mytest.nowhere. 168.192.in-addr.arpa.

reverse_zone() {
  zone_util reverse "$1" "$2" <"$3"  
}

serial() {
  zone_util serial "$@"
}



sync_dirs() {
  needs_reload="${needs_reload:-$vardir/needs_reload}"
  if ! [ -d "$2" ] ; then
    mkdir -p "$2"
  fi
  ls -1 $1 | while read fn ; do
    if [ -f $2/$fn ] ; then
      if grep -q "KEEP_FILE" $1/$fn ; then
        echo "KEEP_FILE for file $2/$fn"
      elif ! diff -I " IN SOA " -q $1/$fn $2/$fn ; then
        cp $1/$fn $2/$fn
        touch "$needs_reload"
      fi
    else 
      cp $1/$fn $2/$fn
      touch "$needs_reload"
    fi

  done

  # removing files no longer existent
  ls -1 $2 | while read fn ; do
    if ! [ -f $1/$fn ] ; then
      rm $2/$fn
      touch "$needs_reload"
    fi
  done
}


update_dbs() {
  local ts="$vardir/db_active.timestamp"
  export DB_SRC_DIR="$1" 
  if [ -z "$1" ] ; then
    error_msg "update_dbs <src> <stage> <active>: no src given"
    return 1
  fi
  export DB_STAGE_DIR="$2"
  if [ -z "$2" ] ; then
    error_msg "update_dbs <src> <stage> <active>: no stage given"
    return 1
  fi
  export DB_ACTIVE_DIR="$3"
  if [ -z "$3" ] ; then
    error_msg "update_dbs <src> <stage> <active>: no active given"
    return 1
  fi
  mkdir -p $DB_ACTIVE_DIR

  if [ -d $DB_STAGE_DIR ] ; then
    rm -rf $DB_STAGE_DIR
  fi
  mkdir $DB_STAGE_DIR

  FAILED_FILE_CONTENT="KEEP_FILE" expand_conf $DB_SRC_DIR $DB_STAGE_DIR

  sync_dirs $DB_STAGE_DIR $DB_ACTIVE_DIR

  export DB_ACTIVE_DIR=
  export DB_STAGE_DIR=
  export DB_SRC_DIR=
  return $rv
}

