#!/bin/bash

set -e

echo "Starting on Create script"

sudo -i -u ec2-user bash <<EOF
touch /home/ec2-user/SageMaker/.create-notebook
EOF

cat > /home/ec2-user/SageMaker/.fastai2-install.sh <<\EOF
#!/bin/bash
set -e
echo "Creating dirs and symlinks"
mkdir -p /home/ec2-user/SageMaker/.cache
mkdir -p /home/ec2-user/SageMaker/.fastai
[ ! -L "/home/ec2-user/.cache" ] && ln -s /home/ec2-user/SageMaker/.cache /home/ec2-user/.cache
[ ! -L "/home/ec2-user/.fastai" ] && ln -s /home/ec2-user/SageMaker/.fastai /home/ec2-user/.fastai

echo "Updating conda"
conda update -n base -c defaults conda -y
conda update --all -y
echo "Starting conda create command for fastai2 env"
conda create -mqyp /home/ec2-user/SageMaker/.env/fastai2 python=3.6
echo "Activate fastai2 conda env"
conda init bash
source ~/.bashrc
conda activate /home/ec2-user/SageMaker/.env/fastai2
echo "Install ipython kernel and widgets"
conda install ipywidgets ipykernel -y
echo "Installing fastai2 lib"
pip install fastai2
pip install nbdev graphviz azure==4.0.0 azure-cognitiveservices-search-imagesearch sagemaker
echo "Installing Jupyter kernel for fastai2"
python -m ipykernel install --name 'fastai2' --user
echo "Finished installing fastai2 conda env"
echo "Install Jupyter nbextensions"
conda activate JupyterSystemEnv
pip install jupyter_contrib_nbextensions
jupyter contrib nbextensions install --user
echo "Restarting jupyter notebook server"
pkill -f jupyter-notebook
rm /home/ec2-user/SageMaker/.create-notebook
echo "Exiting install script"
EOF

chown ec2-user:ec2-user /home/ec2-user/SageMaker/.fastai2-install.sh
chmod 755 /home/ec2-user/SageMaker/.fastai2-install.sh

sudo -i -u ec2-user bash <<EOF
nohup /home/ec2-user/SageMaker/.fastai2-install.sh &
EOF

echo "Finishing on Create script"