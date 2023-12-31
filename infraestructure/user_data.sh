#! /bin/bash
# Install Docker and AWS CLI
sudo apt-get update -y
sudo apt-get install ca-certificates curl gnupg lsb-release
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose awscli -y
sudo systemctl start docker
sudo systemctl enable docker

cd /home/ubuntu

# Installing conda
wget https://repo.anaconda.com/miniconda/Miniconda3-py310_23.5.2-0-Linux-x86_64.sh -O /home/ubuntu/miniconda.sh
sudo bash /home/ubuntu/miniconda.sh -b -p /home/ubuntu/miniconda
/home/ubuntu/miniconda/bin/conda init bash

# Create aws credential files
sudo mkdir /home/ubuntu/.aws

echo "[default]" | sudo tee /home/ubuntu/.aws/config
echo "AWS_DEFAULT_REGION="${AWS_REGION} >> /home/ubuntu/.aws/config

echo "[default]" | sudo tee /home/ubuntu/.aws/credentials
echo "AWS_ACCESS_KEY_ID="${AWS_AKI} >> /home/ubuntu/.aws/credentials
echo "AWS_SECRET_ACCESS_KEY="${AWS_SAK} >> /home/ubuntu/.aws/credentials

sudo chown -R ubuntu:ubuntu .aws/

# Clone repository
git clone https://github.com/JorgeAbrego/mlops_zoomcamp_project /home/ubuntu/mlops-project

sudo chown -R ubuntu:ubuntu mlops-project/

# Deploying containers with services (MLflow, etc)
cd /home/ubuntu/mlops-project/services

echo "POSTGRES_USER="${DB_USER} | sudo tee .env
echo "POSTGRES_PASS="${DB_PASS} >> .env
echo "POSTGRES_HOST="${DB_HOST} >> .env
echo "POSTGRES_PORT="${DB_PORT} >> .env
echo "POSTGRES_DB="${DB_NAME} >> .env
echo "AWS_ACCESS_KEY_ID="${AWS_AKI} >> .env
echo "AWS_SECRET_ACCESS_KEY="${AWS_SAK} >> .env
echo "AWS_DEFAULT_REGION="${AWS_REGION} >> .env

sudo docker-compose up -d