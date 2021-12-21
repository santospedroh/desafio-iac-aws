#!/bin/bash
## Install Nginx
sudo yum update -y
sudo amazon-linux-extras install -y nginx1.12 -y
sudo systemctl enable nginx
sudo systemctl start nginx

## Install Snake Game
cd /tmp
wget https://github.com/goncadanilo/snake-game-js/archive/refs/heads/master.zip
sudo unzip master.zip
sudo mv snake-game-js-master/* /usr/share/nginx/html/
sudo systemctl restart nginx