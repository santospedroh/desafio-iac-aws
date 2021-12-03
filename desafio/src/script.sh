#!/bin/bash
## Install Nginx
sudo yum update -y
sudo amazon-linux-extras install -y nginx1.12 -y
sudo systemctl start nginx -y

## Install Site
sudo unzip /tmp/groovin.zip -d /usr/share/nginx/html/
sudo mv /usr/share/nginx/html/Groovin/* /usr/share/nginx/html/
sudo systemctl restart nginx
