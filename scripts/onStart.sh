#!/bin/bash

set -e

echo "Starting on Start script"

sudo -i -u ec2-user bash << EOF
if [[ -f /home/ec2-user/SageMaker/.create-notebook ]]; then
    echo "Skipping as currently installing conda env"
else
    echo "Activate fastai2 conda env"
    conda activate /home/ec2-user/SageMaker/.env/fastai2
    echo "Updating python packages from pip"
    pip install feather-format kornia pyarrow wandb nbdev fastprogress fastai2 fastcore --upgrade
    echo "Installing Jupyter kernel"
    python -m ipykernel install --name 'fastai2' --user
    echo "Finished setting up Jupyter kernel"
fi
EOF

echo "Finishing on Start script"