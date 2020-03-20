#!/bin/bash

set -e

echo "Starting on Start script"

sudo -i -u ec2-user bash << EOF
if [[ -f /home/ec2-user/SageMaker/.create-notebook ]]; then
    echo "Skipping as currently installing conda env"
else
    # create symlinks to EBS volume
    echo "Creating symlinks"
    mkdir /home/ec2-user/SageMaker/.torch && ln -s /home/ec2-user/SageMaker/.torch /home/ec2-user/.torch
    mkdir /home/ec2-user/SageMaker/.fastai && ln -s /home/ec2-user/SageMaker/.fastai /home/ec2-user/.fastai
    echo "Updating conda"
    conda update -n base -c defaults conda -y
    echo "Activate fastai2 conda env"
    conda init bash
    source ~/.bashrc
    conda activate /home/ec2-user/SageMaker/.env/fastai2
    echo "Updating fastai packages"
    pip install fastai2 fastcore --upgrade
    echo "Installing Jupyter kernel"
    python -m ipykernel install --name 'fastai2' --user
    echo "Finished setting up Jupyter kernel"
fi
EOF

echo "Finishing on Start script"