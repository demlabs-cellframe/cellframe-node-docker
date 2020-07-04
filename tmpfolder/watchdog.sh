#!/bin/bash

#/launch_node.sh $@ | tee -a /launch_node.log
while true; do
	oh=$(ps aux | grep cellframe-node | wc -l)
	if [ "$oh" -ge "2" ]
	then
		echo "ok" 
        else
		mkdir -p /errlogs/$( date +%d-%m-%Y )
		cp /opt/cellframe-nod/var/log/cellframe-node.log /errlogs/$( date +%d-%m-%Y )/ 
		/opt/cellframe-node/bin/cellframe-node
	fi
sleep 10
done
