#!/bin/bash
## Install Nginx
sudo yum update -y
sudo amazon-linux-extras install -y nginx1.12 -y
sudo systemctl enable nginx
sudo systemctl start nginx

## Install Site
cd /tmp
wget https://github.com/santospedroh/desafio-iac-aws/raw/main/desafio/src/groovin.zip
sudo unzip groovin.zip
sudo mv Groovin/* /usr/share/nginx/html/
sudo systemctl restart nginx
