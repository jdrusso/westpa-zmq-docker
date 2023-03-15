#!/bin/sh

SERVER_INFO="/data/west_zmq_info.json"

cd /data
w_run --work-manager=zmq --n-workers=0 --zmq-mode=master --zmq-write-host-info=$SERVER_INFO --zmq-comm-mode=tcp &> west.log 

wait
