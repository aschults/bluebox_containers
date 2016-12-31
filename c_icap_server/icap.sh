set -e

failall() {
  echo file failed
  exit 1
}

FAILED_FILE_HANDLER=failall

. /lib.sh

for f in `ls /start.d`  ; do
  fn=$etcdir/start.d/$f
  if [ -x $fn ] ; then
     eval $fn
  else
     sh $fn
  fi 
done

if [ -z $CLAMD_IP ] ; then
  if n=`getent hosts ${CLAMD_HOST}.` ; then
    CLAMD_IP=${n%% *}
  else
    CLAMD_IP=$CLAMD_HOST
  fi
  export CLAMD_IP
fi
expand_conf /conf /etc/c-icap

c-icap -N -D -d 2
