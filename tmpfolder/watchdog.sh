#!/bin/bash

#/launch_node.sh $@ | tee -a /launch_node.log
while true; do
	is_running=$(ps aux | grep "bin\/cellframe-node")
	if [ ! -z $is_running ]
	then
		echo "ok" 
        else
		mkdir -p /errlogs/$( date +%d-%m-%Y )
		cp /opt/cellframe-node/var/log/cellframe-node.log /errlogs/$( date +%d-%m-%Y )/ 
		/opt/cellframe-node/bin/cellframe-node
	fi
sleep 10
done
