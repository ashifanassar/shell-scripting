#!/bin/bash

#This is a file which has common features

LOGFILE="/tmp/$COMPONENT.log"
APPUSER="roboshop"
APP_DIR="/home/roboshop/$COMPONENT"


#Checking on the user access
ID=$(id -u)
if [ $ID -ne 0 ]; then
    echo -e "\e[33m Not the root user use the Sudo access \e[0m"
    exit 1
fi

#To check the execution of the earlier comment
stat(){
    if [ $1 -eq 0 ]; then
    echo -e "\e[32m success\e[0m"
else
    echo -e "\e[32m failure\e[0m"
    fi
}

#Create user
CREATE_USER() {
    echo -n "creating the new user $APPUSER"
id $APPUSER
if [ $? -ne 0 ]; then
    useradd $APPUSER
    stat $?
else
    echo -e "\e[31m skipping \e[0m"
fi

}


#Downloading and extracting
DOWNLOAD_EXTRACT() {
    echo -n "Downloading the component"
    curl -s -L -o /tmp/user.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
    stat $?

    echo -n "Performing $COMPONENT cleanup"
    rm -rf ${APP_DIR} &>>$LOGFILE
    stat $?

    echo "Extracting the $COMPONENT"
    cd /home/roboshop
    unzip -o /tmp/user.zip &>>$LOGFILE
    stat $?
}

#Configure the service

CONFIG_SVC() {
    echo -n "Configuring Permissions :"
    mv /home/roboshop/${COMPONENT}-main ${APPUSER_DIR} &>>  $LOGFILE
    chown -R ${APPUSER}:${APPUSER} ${APPUSER_DIR}      &>>  $LOGFILE
    stat $? 

    echo -n "Configuring $COMPONENT Service: "
    sed -i -e 's/DBHOST/mysql.roboshopshopping/' -e 's/CARTENDPOINT/cart.roboshopshopping/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshopshopping' -e 's/MONGO_ENDPOINT/mongodb.roboshopshopping/' -e 's/REDIS_ENDPOINT/redis.roboshopshopping/' -e 's/MONGO_DNSNAME/mongodb.roboshopshopping/' ${APPUSER_DIR}/systemd.service
    mv ${APPUSER_DIR}/systemd.service   /etc/systemd/system/${COMPONENT}.service
    stat $? 
}


START_SVC() {
    echo -n "Starting $COMPONENT Service :"
    systemctl enable $COMPONENT     &>>  $LOGFILE
    systemctl restart $COMPONENT     &>>  $LOGFILE
    stat $? 
}
#Nodejs Function

Nodejs(){
    echo -n "Disable Nodejs default modules"
    dnf module disable nodejs -y &>>$LOGFILE
    stat $?

    echo -n "Enable Nodejs18"
    dnf module enable nodejs:18 -y &>>$LOGFILE
    stat $?

    echo -n "Install Nodejs 18"
    dnf install nodejs -y &>>$LOGFILE
    stat $?

    CREATE_USER    #Calling another function

    DOWNLOAD_EXTRACT

    CONFIG_SVC


    echo -n "Generating $COMPONENT Artifacts :"
    cd ${APPUSER_DIR}
    npm install  &>>  $LOGFILE
    stat $?

    START_SVC
}