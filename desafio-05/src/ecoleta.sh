#!/bin/bash
## Install Docker
sudo yum update -y
sudo yum install mysql -y
sudo amazon-linux-extras install docker -y
sudo systemctl enable docker.service
sudo systemctl start docker.service

## Run App Ecoleta
#sudo docker run --rm -p 80:8000 --name ecoleta -e HOSTDB="terraform-20211227210735659200000001.cx3rkqtqwnw4.us-east-1.rds.amazonaws.com" -e USERDB="db_user" -e PASSDB="Ecoleta123-2021" -e SCHEDB="nlwecoleta" -d santospedroh/ecoleta:latest
sudo docker run --rm -p 80:8000 --name ecoleta -e HOSTDB="$1" -e USERDB="db_user" -e PASSDB="Ecoleta123-2021" -e SCHEDB="nlwecoleta" -d santospedroh/ecoleta:latest
