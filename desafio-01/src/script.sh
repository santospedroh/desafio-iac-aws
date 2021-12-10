#!/bin/bash
## Install Nginx
sudo yum update -y
sudo amazon-linux-extras install -y nginx1.12 -y
sudo systemctl start nginx -y
sudo systemctl enable nginx

## Install Site
sudo unzip /tmp/groovin.zip
sudo mv /tmp/Groovin/* /usr/share/nginx/html/
sudo systemctl restart nginx
