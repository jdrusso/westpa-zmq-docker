#!/bin/bash
#SBATCH --job-name=westpa_simulation
#SBATCH --output=logs/westpa_simulation_%j.out
#SBATCH --error=logs/westpa_simulation_%j.err
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --time=24:00:00

module load singularity

export SINGULARITY_CACHEDIR=/home/exacloud/gscratch/ZuckermanLab/russojd/singularity_cache

SHARED_DATA=./shared_data
SHARED_CONFIG=./shared_config

# Create a directory to store shared data and configuration
mkdir -p $SHARED_DATA $SHARED_CONFIG


# Start the head_node container and write the ZMQ info to the shared directory
echo "Launching head"
singularity run \
  --env 'WEST_SIM_ROOT=/data' \
  -B $SHARED_DATA:/data \
  -B $SHARED_CONFIG:/config \
  docker://jdrusso/head_node:latest &


# Start the worker container(s)
echo "Launching worker"
singularity run \
  --env 'PATH=/opt/conda/bin:${PATH},WEST_SIM_ROOT=/data' \
  -B $SHARED_DATA:/data \
  -B $SHARED_CONFIG:/config \
  docker://jdrusso/worker:latest

echo "Done launching"
