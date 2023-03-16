#!/bin/sh

#source /opt/conda/etc/profile.d/conda.sh
#conda activate base

SERVER_INFO="west_zmq_info.json"

#echo "I am $(whoami)"
#echo "Activating mamba"
#micromamba activate base

#python -c "import simtk"

cd /data

# Wait for the head node to create the west_zmq_info.json file
while [ ! -s "$SERVER_INFO" ]; do
  echo "Waiting for west_zmq_info.json..."
  sleep 5
done

w_run --work-manager=zmq --zmq-mode=client --n-workers=1 --zmq-read-host-info=$SERVER_INFO --zmq-comm-mode=tcp

