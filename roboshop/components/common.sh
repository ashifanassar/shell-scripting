#/bin/bash

# This is a file to host all the COMMON PATTERN's or the common functions.
# This can be imported in any of the scripts with the help of source

LOGFILE="/tmp/$COMPONENT.log"
APPUSER="roboshop"
APPUSER_DIR="/home/${APPUSER}/${COMPONENT}"

ID=$(id -u)
if [ $ID -ne 0 ] ; then 
    echo -e "\e[31m This script is expected to run with sudo or as a root user \e[0m   \n\t Ex:  bash scriptName compName"
    exit 1
fi

stat() {
    if [ $1 -eq 0 ]; then 
        echo -e "\e[32m Success \e[0m"
    else 
        echo -e "\e[31m Failure \e[0m"
    fi 
}

# Declaring Create User Function
CREATE_USER() {
    echo -n "Creating $APPUSER user account: "
    id $APPUSER     &>>  $LOGFILE
    if [ $? -ne 0 ]; then 
        useradd $APPUSER
        stat $? 
    else 
        echo -e "\e[35m SKIPPING \e[0m"
    fi 
}

DOWNLOAD_AND_EXTRACT() {
    echo -n "Downloading the $COMPONENT Component: "
    curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
    stat $? 

    echo -n "Performing $COMPONENT Cleanup :"
    rm -rf /home/roboshop/${COMPONENT}  &>>  $LOGFILE
    stat $? 

    echo -n "Extracting $COMPONENT :"
    cd /home/roboshop
    unzip -o /tmp/${COMPONENT}.zip  &>>  $LOGFILE
    stat $? 
}

CONFIG_SVC() {
    echo -n "Configuring Permissions :"
    chown ${APPUSER}:${APPUSER} ${APPUSER_DIR}      &>>  $LOGFILE
    stat $? 

    echo -n "Configuring $COMPONENT Service: "
    sed -i -e 's/AMQPHOST/payment.roboshopshopping/' -e 's/AMQPHOST/rabbitmq.roboshopshopping/' -e 's/USERHOST/user.roboshopshopping/' -e 's/CARTHOST/cart.roboshopshopping/' -e 's/DBHOST/mysql.roboshopshopping/' -e 's/CARTENDPOINT/cart.roboshopshopping/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshopshopping/' -e 's/MONGO_ENDPOINT/mongodb.roboshopshopping/' -e 's/REDIS_ENDPOINT/redis.roboshopshopping/' -e 's/MONGO_DNSNAME/mongodb.roboshopshopping/' ${APPUSER_DIR}/systemd.service
    mv ${APPUSER_DIR}/systemd.service   /etc/systemd/system/${COMPONENT}.service
    stat $? 
}

START_SVC() {
    echo -n "Starting $COMPONENT Service :"
    systemctl enable $COMPONENT     &>>  $LOGFILE
    systemctl restart $COMPONENT     &>>  $LOGFILE
    stat $? 
}

# Declaring a Nodejs Function : 

NODEJS() {
    echo -n "Disabling  Default NodeJS Version :"
    dnf module disable nodejs -y      &>>  $LOGFILE
    stat $? 

    echo -n "Enabling NodeJS Version 18 :"
    dnf module enable nodejs:18 -y    &>>  $LOGFILE
    stat $?

    echo -n "Installing NodeJS :"
    dnf install nodejs -y             &>>  $LOGFILE
    stat $?    

    CREATE_USER         # Calling function from another function

    DOWNLOAD_AND_EXTRACT
     
    CONFIG_SVC

    echo -n "Generating $COMPONENT Artifacts :"
    cd /home/roboshop/${COMPONENT}
    npm install  &>>  $LOGFILE
    stat $?

    START_SVC
}

echo -n "Completing the common"

MAVEN() {
    echo -n "Installing maven :"
    dnf install maven -y   &>>  $LOGFILE
    stat $? 
    
    CREATE_USER

    DOWNLOAD_AND_EXTRACT
     
    echo -n "Generating Artifacts :"
    cd /home/${APPUSER}/${COMPONENT}/
    mvn clean package  &>> $LOGFILE
    stat $?
    echo -n "configuring the artifacts"
    mv target/${COMPONENT}-1.0.jar ${COMPONENT}.jar
    stat $?

    CONFIG_SVC
}

PYTHON(){
    echo -n "Installing Packages :"
    dnf install python36 gcc python3-devel -y &>>  $LOGFILE
    stat $? 

    CREATE_USER

    DOWNLOAD_AND_EXTRACT

    echo -n "Generating Artifacts :"
    cd /home/${APPUSER}/${COMPONENT}/
    pip3.6 install -r requirements.txt
    stat $?

    CONFIG_SVC

    START_SVC

}