#!/bin/bash

RESULTS_PATH="/cluster/data/baoc/sandbox/results"
PACKAGES_PATH="/cluster/home/baoc/sandbox"

# replace path with path to medicaldiffusion, username, and results path in submit script
sed  -e "s|#USERNAME#|$USER|g" -e "s|#RESULTS_PATH#|$RESULTS_PATH|g" -e "s|#PACKAGES_PATH#|$PACKAGES_PATH|g" meddiff.submit.template > meddiff.submit

submit_job() {
    job_name=$(basename "$1" .json)

    echo "-"
    echo "sbatch --job-name=$job_name /cluster/home/baoc/dev/medicaldiffusion/meddiff.submit $1 $2 $3"
    sbatch --job-name=$job_name /cluster/home/baoc/dev/medicaldiffusion/meddiff.submit $1 $2 $3

    # prevent race conditions
    sleep $((RANDOM % 21 + 5))
}

submit_job_allnodes() {
    job_name=$(basename "$1" .json)

    echo "-"
    echo "sbatch --verbose --job-name=$job_name --partition=p_gpu_all /cluster/home/baoc/dev/medicaldiffusion/meddiff.submit $1 $2 $3"
    sbatch --job-name=$job_name --partition=p_gpu_all /cluster/home/baoc/dev/medicaldiffusion/meddiff.submit $1 $2 $3

    # prevent race conditions
    sleep $((RANDOM % 21 + 5))
}


submit_job_allnodes '/cluster/data/baoc/sandbox/BraTS2020_TrainingData'

