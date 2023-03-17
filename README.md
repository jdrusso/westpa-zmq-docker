# WESTPA + ZMQ + Docker

This repo demonstrates using Docker with WESTPA's ZMQ work manager.
There is a ZMQ head container, and any number of ZMQ workers which connect to it.

Credit where credit is due: The bulk of these dockerfiles was prepared by GPT4, accessed through ChatGPT.


## Running this example

0. Clone the repo on your cluster (contains a pre-initialized `west.h5`)
1. Launch the ZMQ head, and one worker
    ```
    cd westpa-zmq-docker
    sbatch run.slurm
    ```
2. (Optional) Launch additional workers on new nodes
    ```
    sbatch add_workers.slurm
    ```
