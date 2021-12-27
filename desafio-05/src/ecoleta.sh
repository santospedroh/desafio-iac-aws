#!/bin/bash
## Install Docker
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo systemctl enable docker.service
sudo systemctl start docker.service

## Run App Ecoleta
sudo docker run --rm -p 80:5000 --name ecoleta -e HOSTDB=mysql -e USERDB=db_user -e PASSDB=db_pass -e SCHEDB=nlwecoleta -d santospedroh/post-it:latest