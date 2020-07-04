#!/bin/bash
[ ! -z $1 ] && CONTAINER_NAME=$1 || echo "Usage: ./dockerini.sh <Container name template> <start_connect_port[:end_connect_port]> <containers_amount>" #cellframe-test
[ ! -z $2 ] && WORKPORTS_RANGE=$2 || { echo "No workport range specified. Using default port 8079"; WORKPORTS_RANGE=8079; } #Port forwarding
[ ! -z $3 ] && CONTAINERS_AMOUNT=$3 || { echo "No containers amount specified. Using only one"; CONTAINERS_AMOUNT=1; }
[ ! -z $4 ] && INITIAL_IP=$4 || { echo "No initial network address specified. Assuming 10.11.12.0/24"; INITIAL_IP="10.11.12.0"; }

[[ $(docker images | grep "cellframevpn.*latest") ]] || docker build -f ../cellframevpn.dockerfile -t cellframevpn:latest ../tmpfolder/

WORKPORT_BEGIN=$(echo "$WORKPORTS_RANGE" | cut -d ':' -f1)
WORKPORT_END=$(echo "$WORKPORTS_RANGE" | cut -d ':' -f2)

BUSY_COUNTER=0 # Busy ports counter
for ((CONTAINER_COUNT=1;CONTAINER_COUNT<=CONTAINERS_AMOUNT;CONTAINER_COUNT++)); do
	CURRENT_PORT=$(( $WORKPORT_BEGIN + $CONTAINER_COUNT + $BUSY_COUNTER - 1 ))
	while $(ss -tulwn | grep $CURRENT_PORT); do
		$CURRENT_PORT=$(( $CURRENT_PORT + 1 ))
		[[ $CURRENT_PORT -le $WORKPORT_END ]] || { echo "Container $CONTAINER_COUNT is out of range of available ports. Aborting execution"; exit 1; }
		$BUSY_COUNTER=$(( $BUSY_COUNTER + 1 ))
	done
	[[ $CURRENT_PORT -le $WORKPORT_END ]] || { echo "Container $CONTAINER_COUNT is out of range of available ports. Aborting execution"; exit 1; }
	OCTET3=$(( $(echo "$INITIAL_IP" | cut -d '.' -f3) + $CONTAINER_COUNT ))
	CURRENT_IP=$(echo "$INITIAL_IP" | sed "s/[0-9]\+\.\{1\}0$/$OCTET3\.0/" )
	[[ $(docker container ls -a | grep "${CONTAINER_NAME}_${CONTAINER_COUNT}") ]] || docker run --cpus 0.5 --cap-add=NET_ADMIN --name="${CONTAINER_NAME}_${CONTAINER_COUNT}" -p $CURRENT_PORT:$CURRENT_PORT/tcp -p $CURRENT_PORT:$CURRENT_PORT/udp -td cellframevpn:latest /launch_node.sh $CURRENT_PORT $CURRENT_IP 
# -c "/launch_node.sh $CURRENT_PORT"
done
