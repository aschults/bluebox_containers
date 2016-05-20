. ../lib.sh
utildir=..
. ../db_gen_lib.sh

testSerial() {
  export ZONE_UTIL_SERIAL_FILE=`mktemp`
  echo "1111" >$ZONE_UTIL_SERIAL_FILE
  serial mytest.nowhere. <test_data/db/db.mystuff | grep -q "1112"
  assertTrue 0 $?
  serial mytest.nowhere. <test_data/db/db.mystuff | grep -q "another"
  assertTrue 0 $?
}

testReverse() {
  export ZONE_UTIL_SERIAL_FILE=`mktemp`
  echo "1111" >$ZONE_UTIL_SERIAL_FILE
  res="`reverse_zone mytest.nowhere. 168.192.in-addr.arpa test_data/db/db.mystuff`"
  echo "$res"| grep -E "1\\.2 .* bluebox.*"
  assertTrue 0 $?

  echo "$res"| grep -E " NS "
  assertTrue 0 $?
}

testx() {
  set -e 

  d=`mktemp -d`
  d2=`mktemp -d`
  [ -n $d ]
  [ -d $d ]
  [ -n $d2 ]
  [ -d $d2 ]

  #cp gen_conf/test5.conf $d2/test5.conf
  
  #FAILED_FILE_CONTENT=subst_content expand_conf $d2 $d 
  
  set +e

  #assertEquals 0 $?
  

  rm -rf $d $d2
}

. ${SHUNIT_DIR:-../../shunit2-2.0.3}/src/shell/shunit2
