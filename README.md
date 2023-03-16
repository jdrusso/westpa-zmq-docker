# WESTPA + ZMQ + Docker

This repo demonstrates using Docker with WESTPA's ZMQ work manager.
There is a ZMQ head container, and any number of ZMQ workers which connect to it.

Credit where credit is due: The bulk of these dockerfiles was prepared by GPT4, accessed through ChatGPT.


## Running this example

0. Clone the repo

Initialize the WESTPA simulation
1. `cd westpa-zmq-docker/shared_data`
1. `w_init --bstate-file bstates/bstates.txt --segs-per-state 1 --tstate-file tstate.file`

Run WESTPA with Docker+ZMQ
1. `cd westpa-zmq-docker`
1. `docker compose build`
1. `docker compose up --scale worker=<desired number of ZMQ workers>`

