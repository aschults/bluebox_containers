
lighttpd -f /etc/lighttpd/lighttpd.conf
echo "127.0.0.1 squidproxy" >>/etc/hosts

if ! [ -L /var/www/localhost/htdocs/bump.crt ] ; then
  ln -fs $vardir/ssl/bump.crt /var/www/localhost/htdocs/bump.crt
fi

