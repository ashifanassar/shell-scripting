#!/bin/bash

#Check the script is running as a root user or else break the script
ID=$(id -u)
if [ $ID -ne 0 ]; then
    echo -e "\e[33m Not the root user use the Sudo access \e[0m"
    exit 1
fi

COMPONENT="mongodb"
LOGFILE="/tmp/$1.log"
componenturl="https://github.com/stans-robot-project/mongodb/archive/main.zip"

stat(){
    if [ $1 -eq 0 ]; then
    echo -e "\e[32m success\e[0m"
else
    echo -e "\e[32m failure\e[0m"
    fi
}

echo -n "Setup the $COMPONENT"
curl -s -0 /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo
stat $?

echo -n "Install the $COMPONENT"
yum install -y $COMPONENT-org &>> $LOGFILE
stat $?

echo -n "Enable the $COMPONENT"
systemctl enable mongod &>> $LOGFILE
stat $?

echo -n "Start the $COMPONENT"
systemctl start mongod &>> $LOGFILE
stat $?

echo -n "Enabling $COMPONENT visibility"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
stat $?

echo -n "starting $COMPONENT service"
systemctl restart mongod &>> $LOGFILE
stat $?

echo -n "Downloading the $COMPONENT schema"
curl -s -L -o /tmp/$COMPONENT.zip $componenturl &>> $LOGFILE
stat $?

echo -n "Extracting the $COMPONENT file"
unzip /tmp/$COMPONENT.zip &>> $LOGFILE
stat $?

echo -n "Injecting the  $COMPONENT schema"
cd /tmp/mongodb-main &>> $LOGFILE
mongo < catalogue.js
mongo < users.js 
stat $?