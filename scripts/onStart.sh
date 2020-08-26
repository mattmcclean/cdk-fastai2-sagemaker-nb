#!/bin/bash

set -e

echo "Starting on Start script"

sudo -i -u ec2-user bash << EOF
if [[ -f /home/ec2-user/SageMaker/.create-notebook ]]; then
    echo "Skipping as currently installing conda env"
else
    # create symlinks to EBS volume
    echo "Creating symlinks"
    ln -s /home/ec2-user/SageMaker/.fastai /home/ec2-user/.fastai
    echo "Updating conda"
    conda update -n base -c defaults conda -y
    echo "Activate fastai conda env"
    conda init bash
    source ~/.bashrc
    conda activate /home/ec2-user/SageMaker/.env/fastai
    echo "Updating fastai packages"
    pip install fastai fastcore sagemaker --upgrade
    echo "Installing Jupyter kernel"
    python -m ipykernel install --name 'fastai' --user
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