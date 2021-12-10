#!/bin/bash

## Install Docker
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo systemctl enable docker.service
sudo systemctl start docker.service

## Run App Post-it
sudo docker run --rm -p 80:5000 --name post-it -d santospedroh/post-it:latest