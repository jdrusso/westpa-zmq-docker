# WESTPA + ZMQ + Docker

This repo demonstrates using Docker with WESTPA's ZMQ work manager.
There is a ZMQ head container, and any number of ZMQ workers which connect to it.

Credit where credit is due: The bulk of these dockerfiles was prepared by GPT4, accessed through ChatGPT.


## Running this example

1. Clone the repo
1. `cd westpa_zmq_docker_example`
1. `docker compose build`
1. `docker compose up --scale worker=<desired number of ZMQ workers>`

## Structure

The `shared_data` directory is mounted in both the head and the workers, so they all have access to `west.h5` and `west.cfg`, as well as the SynD model.

## Notes

Dynamics are run using SynD for simplicity -- however, SynD was not originally written to be run across separate workers (because it's so fast, that's not really useful in general). Therefore, there are a few things you need to do manually to run this from scratch.

Basically, SynD propagator expects to have access to the WESTPA `data_manager` and `sim_manager`. However, when it's running on a ZMQ worker, it doesn't. So, some things break as a result, mostly just regarding interacting with basis states.



This is also why we disable file locking in the `docker-compose.yml`. Usually, the SynD worker just grabs the data_manager's reference to the H5 file for some reading it does. It can't do that here, but we know it's only reading, so we play it fast and loose by disable locks.

1. `cd shared_data`
1. `w_init --bstate 'basis,.000000000000001,1871' --tstate 'target,10'`
1. Before running with Docker, manually run one iteration. You can set west.cfg max_iterations to 2, or you can just cancel it after it runs an iteration or so.
1. Continue with the `docker compose up` from above.

This repo has a `west.h5` with a single iteration iteration run, so you don't have to do this on a fresh clone.

Note that it will probably crash as soon as something gets recycled for the same reason.

Also, note that all of this is just because of running SynD in another worker. If you use another propagator, none of this should apply.
