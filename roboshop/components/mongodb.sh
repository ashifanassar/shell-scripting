#!/bin/bash

#Check the script is running as a root user or else break the script
ID=$(id -u)
if [ $ID -ne 0 ]; then
    echo -e "\e[33m Not the root user use the Sudo access \e[0m"
    exit 1
fi

COMPONENT="mongodb"
LOGFILE="/tmp/${COMPONENT}.log"
MONGO_REPO="https://raw.githubusercontent.com/stans-robot-project/${COMPONENT}/main/mongo.repo"
SCHEMA_URL="https://github.com/stans-robot-project/mongodb/archive/main.zip"

stat(){
    if [ $1 -eq 0 ]; then
    echo -e "\e[32m success\e[0m"
else
    echo -e "\e[32m failure\e[0m"
    fi
}

echo -n "Configuring $COMPONENT repo"
curl -s -o /etc/yum.repos.d/mongodb.repo $MONGO_REPO
stat $? 

echo -n "Installing $COMPONENT :"
dnf install -y mongodb-org  &>>  $LOGFILE
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
cd /tmp
unzip ${COMPONENT}.zip &>> $LOGFILE
stat $?

echo -n "Injecting the  $COMPONENT schema"
cd mongodb-main 
mongo < catalogue.js
mongo < users.js 
stat $?