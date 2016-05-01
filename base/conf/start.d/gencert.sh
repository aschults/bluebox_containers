set -e
if [ -z $sslbump ] ; then
  exit
fi

if [ -z $certsubj ] ; then
  certsubj="/C=CH/ST=Zurich/L=Zurich/CN=squidproxy"
fi

dir=$vardir/ssl
if ! [ -f $dir/bump.crt ] ; then
  openssl req -nodes -newkey rsa:2048 -keyout $dir/bump.key -out $dir/bump.csr -subj "$certsubj"
  openssl x509 -req -extfile $etcdir/ssl_v3.ext -days 20000 -in $dir/bump.csr -signkey $dir/bump.key -out $dir/bump.crt 
fi
chmod a+r $dir/bump.crt


mkdir $vardir/cacerts-gen
mkdir -p $vardir/cacerts-gen


for f in /etc/ssl/certs/* ; do
 ln -fs $f $vardir/cacerts-gen/
done

# copy custom certs
if ! [ -d $dir/cacerts ] ; then
  mkdir $dir/cacerts
fi
for f in `ls $dir/cacerts` ; do
  cp -f $dir/cacerts/$f $vardir/cacerts-gen/
done

chown -R squid:squid $vardir/cacerts-gen

