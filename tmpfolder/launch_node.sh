#!/bin/bash
mkdir -p /dev/net
mknod /dev/net/tun c 10 200
chmod 600 /dev/net/tun
/etc/init.d/bind9 start
sed -i "s/8079/$1/g" /iptables_preset
sed -i "s/10\.11\.12\.0/$2/g" /iptables_preset
sed -i "s/8079/$1/g" /cellframe-node.cfg
sed -i "s/10\.11\.12\.0/$2/g" /cellframe-node.cfg
mv /cellframe-node.cfg /opt/cellframe-node/etc/cellframe-node.cfg
iptables-restore /iptables_preset
/watchdog.sh
while true; do :; done & kill -STOP $! wait $!
