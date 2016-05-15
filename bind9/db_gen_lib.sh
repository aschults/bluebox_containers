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
  ls -1 $1 | while read fn ; do
    if [ -f $2/$fn ] ; then
      if grep -q "KEEP_FILE" $1/$fn ; then
        echo "KEEP_FILE for file $2/$fn"
      elif diff -q $1/$fn $2/$fn ; then
        cp $1/$fn $2/$fn
      fi
    else 
      cp $1/$fn $2/$fn
    fi
  done

  # removing files no longer existent
  ls -1 $2 | while read fn ; do
    if ! [ -f $1/$fn ] ; then
      rm $2/$fn
    fi
  done
}


update_dbs() {
  mkdir -p $vardir/db_active
  export DB_ACTIVE_DIR=$vardir/db_active
  export DB_STAGE_DIR=$vardir/db_stage
  export DB_SRC_DIR=$datadir/db

  if [ -d $DB_STAGE_DIR ] ; then
    rm -rf $DB_STAGE_DIR
  fi
  mkdir $DB_STAGE_DIR

  COMMENT_STR=";" FAILED_FILE_CONTENT="KEEP_FILE" expand_conf $DB_SRC_DIR $DB_STAGE_DIR

  sync_dirs $DB_STAGE_DIR $DB_ACTIVE_DIR

  export DB_ACTIVE_DIR=
  export DB_STAGE_DIR=
  export DB_SRC_DIR=
}

