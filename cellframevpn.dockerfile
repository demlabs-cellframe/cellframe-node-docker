FROM debian:buster
MAINTAINER "alexander.kravchenko@demlabs.net"
COPY ./iptables_worknode_nolimits /iptables_preset
COPY ./cellframe-node.cfg /cellframe-node.cfg
RUN apt-get -y update && apt-get -y dist-upgrade &&  apt-get install -y wget procps bind9 nano net-tools && \ 
wget -c https://pub.cellframe.net/linux/node-buster-latest && filename=$(cat node-buster-latest | sed "s/'//g" | cut -sd '/' -f2 | cut -sd ';' -f1) && \
wget -c https://pub.cellframe.net/linux/$filename && \ 
	apt-get install -y debconf-utils dconf-cli less pv psmisc libcurl3-gnutls libev4 libjson-c3 libmagic1 libpython3.7 libsqlite3-0 iptables && \
	dpkg -i $filename && update-alternatives --set iptables /usr/sbin/iptables-legacy
COPY ./launch_node.sh /launch_node.sh
COPY ./watchdog.sh /watchdog.sh
RUN chmod +x /launch_node*.sh && chmod +x /watchdog.sh && rm -r /node-buster-latest && mkdir -p /dev/net && mknod /dev/net/tun c 10 200 && chmod 600 /dev/net/tun 
