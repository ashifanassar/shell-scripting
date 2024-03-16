#!/bin/bash


source components/common.sh  #Source has all the funtions

COMPONENT="mysql"
LOGFILE="/tmp/${COMPONENT}.log"
MYSQL_REPO="https://raw.githubusercontent.com/stans-robot-project/mysql/main/${COMPONENT}.repo"
SCHEMA_URL="https://github.com/stans-robot-project/mongodb/archive/main.zip"

echo -n "Disabling the $COMPONENT repo"
dnf module disable mysql -y
stat $? 

echo -n "Configuring ${COMPONENT} repo :"
curl -s -L -o /etc/yum.repos.d/mysql.repo $MYSQL_REPO
stat $?


echo -n "Installing $COMPONENT :"
dnf install $COMPONENT-community-server -y
stat $? 

echo -n "Starting ${COMPONENT}:" 
systemctl enable mysqld   &>>  ${LOGFILE}
systemctl start mysqld    &>>  ${LOGFILE}
stat $?


# echo -n "Enabling $COMPONENT visibility"
# sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
# stat $?

# echo -n "Injecting the  $COMPONENT schema"
# cd /tmp/mongodb-main 
# mongo < catalogue.js &>> $LOGFILE
# mongo < users.js &>> $LOGFILE
# stat $?