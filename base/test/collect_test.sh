. ../lib.sh

testCollect() {
  set -e 
  d=`mktemp -d`
  [ -n $d ]
  [ -d $d ]
  export y=67890

  echo "1" >$d/1.conf
  echo "a" >$d/a.conf

  v="`collect_files 'x${fn}x'  $d`" 
  exp="x$d/1.confxx$d/a.confx"
  assertEquals "$exp" "$v"

  v="`collect_files 'x${fn}x\n'  $d`" 
  exp="x$d/1.confx
x$d/a.confx"
  assertEquals "$exp" "$v"

  v="`collect_files 'x"${fn}"x'  $d`" 
  exp="x\"$d/1.conf\"xx\"$d/a.conf\"x"
  assertEquals "$exp" "$v"

  rm -rf $d
}

. ${SHUNIT_DIR:-../../shunit2-2.0.3}/src/shell/shunit2
