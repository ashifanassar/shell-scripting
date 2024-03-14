#!/bin/bash

#Check the script is running as a root user or else break the script
ID=$(id -u)
if [ $ID -ne 0 ]; then
    echo -e "\e[33m Not the root user use the Sudo access \e[0m"
    exit 1
fi

COMPONENT="redis"
LOGFILE="/tmp/$COMPONENT.log"
REDIS_REPO="https://rpms.remirepo.net/enterprise/remi-release-8.rpm"

stat(){
    if [ $1 -eq 0 ]; then
    echo -e "\e[32m success\e[0m"
else
    echo -e "\e[32m failure\e[0m"
    fi
}

echo -e "Installing $COMPONENT Repo"
dnf install $REDIS_REPO -y &>> $LOGFILE
stat $?

echo -e "Enabling $COMPONENT"
dnf module enable redis:remi-6.2 -y  &>>  $LOGFILE
stat $?

echo -e "Installing $COMPONENT"
dnf install redis -y &>> $LOGFILE
stat $?


echo -e "Enabling the $COMPONENT visibility"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf
stat $?

echo -n "Start the $COMPONENT"
systemctl enable $COMPONENT &>> $LOGFILE
systemctl restart $COMPONENT &>> $LOGFILE
stat $?