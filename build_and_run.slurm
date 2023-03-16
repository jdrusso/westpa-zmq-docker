#!/bin/bash
#SBATCH --job-name=westpa_simulation
#SBATCH --output=logs/westpa_simulation_%j.out
#SBATCH --error=logs/westpa_simulation_%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=24:00:00

# Load Singularity module (if needed on your cluster)
#module load singularity

#docker build -t head_node_image -f Dockerfile.head
#docker save head_node_image -o head_node_image.tar 

#docker build -t worker_image -f Dockerfile.worker
#docker save worker_image -o worker_image.tar 

module load singularity

export SINGULARITY_CACHEDIR=/home/exacloud/gscratch/ZuckermanLab/russojd/singularity_cache
# Build Singularity images from Dockerfiles
# Replace "/path/to/Dockerfile_head_node" and "/path/to/Dockerfile_worker" with actual paths to your Dockerfiles

IMAGE_NAME=head_node.sif
if [ -f "$IMAGE_NAME" ]; then
    echo "Image file '$IMAGE_NAME' already exists, skipping build."
else
    singularity build $IMAGE_NAME docker://jdrusso/head_node:latest
fi

IMAGE_NAME=worker.sif
if [ -f "$IMAGE_NAME" ]; then
    echo "Image file '$IMAGE_NAME' already exists, skipping build."
else
    singularity build $IMAGE_NAME docker://jdrusso/worker:latest
fi

SHARED_DATA=./shared_data
SHARED_CONFIG=./shared_config

# Create a directory to store shared data and configuration
mkdir -p $SHARED_DATA $SHARED_CONFIG

# Start the head_node container and write the ZMQ info to the shared directory
echo "Launching head"
singularity run \
  -B $SHARED_DATA:/data \
  -B $SHARED_CONFIG:/config \
  head_node.sif &

# Wait for the head_node to write the ZMQ info
#while [ ! -s $SHARED_DATA/west_zmq_info.json ]; do
#  echo "Waiting for ZMQ head to be ready before launching workers..."
#  sleep 5
#done

# Start the worker container(s)
# Adjust the "--ntasks" and "--cpus-per-task" options in the #SBATCH directives as needed
echo "Launching worker"
singularity run \
  -B $SHARED_DATA:/data \
  -B $SHARED_CONFIG:/config \
  worker.sif

echo "Done launching"
