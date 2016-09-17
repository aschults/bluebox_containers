
sh /usr/local/squidGuard/update_db.sh
sh /usr/local/squidGuard/gen_conf.sh
/usr/local/bin/squidGuard -d -C all
chown -R squid /usr/local/squidGuard
