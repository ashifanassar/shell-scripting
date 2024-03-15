#!/bin/bash


source components/common.sh  #Source has all the funtions

COMPONENT="cart"
LOGFILE="/tmp/$COMPONENT.log"
APPUSER="roboshop"
APP_DIR="/home/roboshop/$COMPONENT"



Nodejs() #check in the common.sh file

CREATE_USER()  #check in the common.sh file


DOWNLOAD_EXTRACT()


CONFIG_SVC()

START_SVC()

echo -n "status of the $COMPONENT"
systemctl start $COMPONENT