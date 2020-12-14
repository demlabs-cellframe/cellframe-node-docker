FROM debian:buster
MAINTAINER "alexander.kravchenko@demlabs.net"
COPY ./iptables_worknode_nolimits /iptables_preset
COPY ./cellframe-node.cfg /cellframe-node.cfg
RUN apt-get -y update && apt-get -y dist-upgrade &&  apt-get install -y wget procps bind9 nano net-tools gnupg2 && \
wget -c https://debian.pub.demlabs.net/public/public-key.gpg && \
apt-key add public-key.gpg && \
echo "deb https://debian.pub.demlabs.net/public buster main" >> /etc/apt/sources.list.d/demlabs.list && apt-get update && apt-get install -y cellframe-node iptables && \
update-alternatives --set iptables /usr/sbin/iptables-legacy
COPY ./launch_node.sh /launch_node.sh
COPY ./watchdog.sh /watchdog.sh
RUN chmod +x /launch_node*.sh && chmod +x /watchdog.sh && mkdir -p /dev/net && mknod /dev/net/tun c 10 200 && chmod 600 /dev/net/tun 
