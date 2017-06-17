host=192.168.2.253
intf=enp2s0:1
common="-m comment --comment squid_transparent"

for p in 80 8080 8081 88 8777 8182 ; do
  iptables -t nat -A PREROUTING -i $intf ! -d $host -p tcp --dport $p -j REDIRECT --to-port 3129 $common
done

iptables -t nat -A PREROUTING -i $intf ! -d $host -p tcp --dport 443 -j REDIRECT --to-port 3130 $common
