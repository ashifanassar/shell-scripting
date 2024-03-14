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
APP_DIR="/home/roboshop/$COMPONENT"

stat(){
    if [ $1 -eq 0 ]; then
    echo -e "\e[32m success\e[0m"
else
    echo -e "\e[32m failure\e[0m"
    fi
}

echo -n "Disable Nodejs default modules"
dnf module disable nodejs -y &>>$LOGFILE
stat $?

echo -n "Enable Nodejs18"
dnf module enable nodejs:18 -y &>>$LOGFILE
stat $?

echo -n "Install Nodejs 18"
dnf install nodejs -y &>>$LOGFILE
stat $?

echo -n "creating the new user $APPUSER"
id $APPUSER
if [ $? -ne 0 ]; then
    useradd $APPUSER
    stat $?
else
    echo -e "\e[31m skipping \e[0m"
fi
stat $?


echo -n "Downloading the component"
#sudo su roboshop
curl -s -L -o /tmp/catalogue.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
stat $?

echo -n "Performing $COMPONENT cleanup"
rm -rf ${APP_DIR} &>>$LOGFILE
stat $?

echo "Extracting the $COMPONENT"
cd /home/roboshop
unzip -o /tmp/catalogue.zip &>>$LOGFILE
stat $?

echo -n "configuring the permissions"
mv /home/roboshop/$COMPONENT-main ${APP_DIR}
chown ${APPUSER}:${APPUSER} ${APP_DIR}
stat $?

echo -n "Generating the $COMPONENT artifacts"
cd ${APP_DIR}
npm install &>>$LOGFILE
stat $?

echo -n "Configuring the  $COMPONENT code"
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshopshopping/' ${APP_DIR}/systemd.service
mv ${APP_DIR}/systemd.service /etc/systemd/system/$COMPONENT.service
stat $?

echo -n "starting the c$COMPONENT"
systemctl daemon-reload
systemctl start $COMPONENT &>>$LOGFILE
systemctl enable $COMPONENT &>>$LOGFILE