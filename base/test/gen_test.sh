. ../lib.sh

testSimpleExpansion() {
  set -e 
  d=`mktemp -d`
  [ -n $d ]
  [ -d $d ]
  export y=67890


  expand_conf ./gen_conf $d
  set +e

  grep "HELLO" $d/test1.conf >/dev/null
  assertEquals 0 $?
  grep "file.*test2.conf" $d/test2.conf >/dev/null
  assertEquals 0 $?
  grep "here testme here" $d/test3.conf >/dev/null
  assertEquals 0 $?
  grep "here2 67890 here" $d/test4.conf >/dev/null
  assertEquals 0 $?
  grep "partial_content" $d/test5.conf >/dev/null
  assertEquals 0 $?

  rm -rf $d
}

t_func() {
   echo SUCESS
}

testCommentStr() {
  set -e 

  d=`mktemp -d`
  d2=`mktemp -d`
  [ -n $d ]
  [ -d $d ]
  [ -n $d2 ]
  [ -d $d2 ]

  echo ";! t_func" >$d2/test.conf
  
  COMMENT_STR=\; expand_conf $d2 $d 
  
  set +e

  val=`cat $d/test.conf`
  
  assertEquals SUCESS "$val" 

  rm -rf $d $d2
}

mytest_hdl() {
   echo "handler_cmd $2" >$3
}

testFail2() {
  set -e 

  d=`mktemp -d`
  d2=`mktemp -d`
  [ -n $d ]
  [ -d $d ]
  [ -n $d2 ]
  [ -d $d2 ]

  cp gen_conf/test5.conf $d2/test5.conf
  
  FAILED_FILE_CONTENT=subst_content expand_conf $d2 $d 
  
  set +e

  grep "subst_content" $d/test5.conf >/dev/null
  assertEquals 0 $?
  

  FAILED_FILE_HANDLER=mytest_hdl expand_conf $d2 $d 
  grep "handler_cmd $d2/test5.conf" $d/test5.conf >/dev/null
  assertEquals 0 $?

  rm -rf $d $d2
}

. ${SHUNIT_DIR:-../../shunit2-2.0.3}/src/shell/shunit2
