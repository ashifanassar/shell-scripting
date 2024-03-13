#!/bin/bash


echo "Installing the Nginx on the sderver"
yum install nginx -y

echo "Enabling the service"
systemctl enable nginx 

echo "starting the service"
systemctl start nginx 



