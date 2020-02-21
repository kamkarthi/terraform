#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install nginx1.12
sudo echo -e "INSTANCE_PRIVATE_IP: $(curl http://169.254.169.254/latest/meta-data/local-ipv4)" > /usr/share/nginx/html/index.html
sudo echo -e "INSTANCE_PUBLIC_IP: $(curl http://169.254.169.254/latest/meta-data/public-ipv4)" >> /usr/share/nginx/html/index.html
sudo systemctl start nginx
sudo systemctl enable nginx