set -e

etcdir=$rootdir/etc/apache2
export etcdir 


for f in `ls $etcdir/start.d`  ; do
  fn=$etcdir/start.d/$f
  if [ -x $fn ] ; then
     eval $fn
  else
     sh $fn
  fi 
done


httpd -D FOREGROUND
