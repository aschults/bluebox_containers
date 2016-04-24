. ../lib.sh

testSimpleExpansion() {
  set -e 
  d=`mktemp -d`
  [ -n $d ]
  [ -d $d ]
  export y=67890


  expand_conf ./gen_conf $d

  grep "HELLO" $d/test1.conf >/dev/null
  assertEquals 0 $?
  grep "file.*test2.conf" $d/test2.conf >/dev/null
  assertEquals 0 $?
  grep "here testme here" $d/test3.conf >/dev/null
  assertEquals 0 $?
  grep "here2 67890 here" $d/test4.conf >/dev/null
  assertEquals 0 $?

  rm -rf $d
}

. ${SHUNIT_DIR:-shunit2-2.0.3}/src/shell/shunit2
