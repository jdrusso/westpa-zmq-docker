#!/bin/sh

SERVER_INFO="west_zmq_info.json"

cd /data

# Wait for the head node to create the west_zmq_info.json file
while [ ! -s "$SERVER_INFO" ]; do
  echo "Waiting for west_zmq_info.json..."
  sleep 5
done

w_run --work-manager=zmq --zmq-mode=client --n-workers=1 --zmq-read-host-info=$SERVER_INFO --zmq-comm-mode=tcp

