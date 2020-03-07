#!/bin/bash

set -e

echo "Starting on Create script"

sudo -i -u ec2-user bash <<EOF
touch /home/ec2-user/SageMaker/.create-notebook
EOF

cat > /home/ec2-user/SageMaker/.fastai2-install.sh <<\EOF
#!/bin/bash
set -e
echo "Updating conda"
conda update -n base -c defaults conda -y
conda update --all -y
echo "Starting conda create command for fastai2 env"
conda create -mqyp /home/ec2-user/SageMaker/.env/fastai2 python=3.7
echo "Activate fastai2 conda env"
conda init bash
source ~/.bashrc
conda activate /home/ec2-user/SageMaker/.env/fastai2
echo "Installing python packages from pip"
pip install feather-format kornia pyarrow wandb nbdev fastprogress fastai2 fastcore --upgrade
pip install torch==1.3.1
pip install torchvision==0.4.2
pip install Pillow==6.2.1 --upgrade
#conda install -c rapidsai -c nvidia -c conda-forge -c defaults cudf=0.12 python=3.7 cudatoolkit=10.0 -y
conda install ipykernel -y
echo "Installing Jupyter kernel for fastai2"
python -m ipykernel install --name 'fastai2' --user
echo "Finished installing fastai2 conda env"
rm /home/ec2-user/SageMaker/.create-notebook
echo "Exiting install script"
EOF

chown ec2-user:ec2-user /home/ec2-user/SageMaker/.fastai2-install.sh
chmod 755 /home/ec2-user/SageMaker/.fastai2-install.sh

sudo -i -u ec2-user bash <<EOF
nohup /home/ec2-user/SageMaker/.fastai2-install.sh &
EOF

echo "Finishing on Create script"