#!/bin/bash

#Check the script is running as a root user or else break the script
ID=$(id -u)
if [ $ID -ne 0] ; then
    echo -e "\e[33m Not the root user use the Sudo access \e[0m"
    exit 1
fi


echo "Installing the Nginx on the sderver"
yum install nginx -y

echo "Enabling the service"
systemctl enable nginx 

echo "starting the service"
systemctl start nginx 



