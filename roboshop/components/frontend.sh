#!/bin/bash

#Check the script is running as a root user or else break the script
ID=$(id -u)
if [ $ID -ne 0 ]; then
    echo -e "\e[33m Not the root user use the Sudo access \e[0m"
    exit 1
fi

COMPONENT="frontend"
LOGFILE="/tmp/frontend.log"

stat(){
    if [ $1 -eq 0 ]; then
    echo -e "\e[32m success\e[0m"
else
    echo -e "\e[32m failure\e[0m"
    fi
}


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


echo -n "Updating the proxy"

    for i in catalogue user ; do
sed -i -e "/$i/s/localhost/mongodb.roboshopshopping/" /etc/nginx/default.d/roboshop.conf
stat $?


echo -n "Restarting the service"
systemctl restart nginx 
stat $?


