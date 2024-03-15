#!/bin/bash

source components/common.sh  #Source has all the funtions

COMPONENT="redis"
LOGFILE="/tmp/$COMPONENT.log"
REDIS_REPO="https://rpms.remirepo.net/enterprise/remi-release-8.rpm"



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

START_SVC

echo -n "Status of the $COMPONENT"
systemctl status $COMPONENT -l
stat $?