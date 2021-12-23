#!/bin/bash
## AWS Session Manager
sudo yum update -y
sudo yum install -y https://s3.us-east-1.amazonaws.com/amazon-ssm-region/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent