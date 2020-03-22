#!/bin/bash

set -e

echo "Starting on Start script"

sudo -i -u ec2-user bash << EOF
if [[ -f /home/ec2-user/SageMaker/.create-notebook ]]; then
    echo "Skipping as currently installing conda env"
else
    # create symlinks to EBS volume
    echo "Creating symlinks"
    mkdir /home/ec2-user/SageMaker/.cache && ln -s /home/ec2-user/SageMaker/.cache /home/ec2-user/.cache
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
    echo "Install Jupyter nbextensions"
    conda activate JupyterSystemEnv
    pip install jupyter_contrib_nbextensions
    jupyter contrib nbextensions install --user
    echo "Restarting jupyter notebook server"
    pkill -f jupyter-notebook
    echo "Finished setting up Jupyter kernel"
fi
EOF

echo "Finishing on Start script"