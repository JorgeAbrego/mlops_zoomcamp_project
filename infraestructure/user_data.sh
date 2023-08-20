#! /bin/bash
# Install Docker
sudo apt-get update -y
sudo apt-get install ca-certificates curl gnupg lsb-release
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin awscli -y
sudo systemctl start docker
sudo systemctl enable docker

git clone https://github.com/JorgeAbrego/mlops_zoomcamp_project /home/ubuntu/mlops-project

cd /home/ubuntu/mlops-project/services

echo "POSTGRES_USER="${DB_USER} | sudo tee .env
echo "POSTGRES_PASS="${DB_PASS} >> .env
echo "POSTGRES_HOST="${DB_HOST} >> .env
echo "POSTGRES_PORT="${DB_PORT} >> .env
echo "POSTGRES_DB="${DB_NAME} >> .env