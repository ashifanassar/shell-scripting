#!/bin/bash

#Check the script is running as a root user or else break the script
ID=$(id -u)
if [ $ID -ne 0 ]; then
    echo -e "\e[33m Not the root user use the Sudo access \e[0m"
    exit 1
fi

COMPONENT="mongodb"
LOGFILE="/tmp/$1.log"
MONGO_REPO="https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo"

stat(){
    if [ $1 -eq 0 ]; then
    echo -e "\e[32m success\e[0m"
else
    echo -e "\e[32m failure\e[0m"
    fi
}

echo "Setup the Mongodb"
curl -s -0 /etc/yum.repos.d/mongodb.repo $MONGO_REPO
stat $?

echo "Install the Mongodb"
dnf install -y mongodb-org &>> $LOGFILE
stat $?

echo "Enable the Mongodb"
systemctl enable mongod &>> $LOGFILE
stat $?

echo "Start the Mongodb"
systemctl start mongod &>> $LOGFILE
stat $?