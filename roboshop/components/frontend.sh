#!/bin/bash

#Check the script is running as a root user or else break the script
ID=$(id -u)
if [ $ID -ne 0]; then
    echo -e "\e[33m Not the root user use the Sudo access \e[0m"
    exit 1
fi

LOGFILE="/tmp/frontend.log"

stat(){
    if [ $1 -eq 0 ]; then
    echo -e "\e[32m success\e[0m"
else
    echo -e "\e[32m failure\e[0m"
}


echo -n "Installing the Nginx on the server"
yum install nginx -y  &>> $LOGFILE
stat $?

echo -n"Enabling the service"
systemctl enable nginx &>> LOGFILE
stat $?

echo -n "starting the service"
systemctl start nginx &>> LOGFILE
stat $?


