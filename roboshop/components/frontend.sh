#!/bin/bash

#Check the script is running as a root user or else break the script

source components/common.sh  #Source has all the funtions

COMPONENT="frontend"
LOGFILE="/tmp/$1.log"



echo -n "Installing the Nginx on the server"
yum install nginx -y  &>> $LOGFILE
stat $?

echo -n "Enabling the service"
systemctl enable nginx &>> $LOGFILE
stat $?

echo -n "starting the service"
systemctl start nginx &>> $LOGFILE
stat $?


echo -n "Downloading the $COMPONENT component"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
stat $?

echo -n "Cleaning the $COMPONENT cleanup :"
cd /usr/share/nginx/html
rm -rf * &>> LOGFILE
stat $?

echo -n "Extrating $COMPONENT "
unzip /tmp/frontend.zip &>> $LOGFILE
stat $?

echo -n "configuring $COMPONENT "
mv ${COMPONENT}-main/* . &>> $LOGFILE
mv static/* . &>> $LOGFILE
rm -rf f${COMPONENT}-master README.md &>> $LOGFILE
mv localhost.conf /etc/nginx/default.d/roboshop.conf
stat $?


echo -n "Updating Reverse Proxy File: "
    for i in catalogue user cart ; do 
        sed -i -e "/$i/s/localhost/$i.roboshop.internal/" /etc/nginx/default.d/roboshop.conf
    done
stat $?


echo -n "Restarting the service"
systemctl restart nginx 
stat $?


