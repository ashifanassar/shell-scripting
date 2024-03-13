#!/bin/bash

#Check the script is running as a root user or else break the script
ID=$(id -u)
if [ $ID -ne 0 ]; then
    echo -e "\e[33m Not the root user use the Sudo access \e[0m"
    exit 1
fi

COMPONENT="catalogue"
LOGFILE="/tmp/$COMPONENT.log"
APPUSER="roboshop"

stat(){
    if [ $1 -eq 0 ]; then
    echo -e "\e[32m success\e[0m"
else
    echo -e "\e[32m failure\e[0m"
    fi
}

echo -n "Disable Nodejs default modules"
dnf module disable nodejs -y
stat $?

echo -n "Enable Nodejs18"
dnf module enable nodejs:18 -y
stat $?

echo -n "Install Nodejs 18"
dnf install nodejs -y
stat $?

echo -n "creating the new user $APPUSER"
id $APPUSER
if [ $? -ne 0 ]; then
    useradd r$APPUSER
    stat $?
else
    echo -e "\e[31m skipping \e[0m"
fi
stat $?

