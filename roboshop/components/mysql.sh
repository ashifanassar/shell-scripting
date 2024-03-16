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

echo -n "Extracting the default sql password"
export DEFAULT_ROOT_PASSWORD=$(grep "temporary password' /var/log/mysqld.log |awk -F " " $'{print $NF}')
stat $?

#Password should be taken for the first tme when tries to take for the next time it fails inorder to avaoid it do the following
if [ $? -ne 0 ]; then 
    echo -n "Performing default password reset of root account:"
    echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1'" | mysql  --connect-expired-password -uroot -p$DEFAULT_ROOT_PASSWORD &>>  ${LOGFILE}
    stat $?
fi 

echo "show plugins;" | mysql -uroot -p${mysql_root_password} | grep validate_password  &>>  ${LOGFILE}
if [ $? -eq 0 ]; then 
    echo -n "Uninstalling Password-validate plugin :"
    echo "uninstall plugin validate_password" | mysql -uroot -p${mysql_root_password} &>>  ${LOGFILE}
    stat $?
fi 

echo -n "Downloading the $COMPONENT schema:"
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip"
stat $? 

echo -n "Extracting the $COMPONENT"
cd /tmp
unzip -o /tmp/$COMPONENT   &>> $LOGFILE
stat $?

echo -n "Injecting the $COMPONENT schema"
cd ${$COMPONENT}-main
mysql -u root -p${mysql_root_password} <shipping.sql     &>>  ${LOGFILE}
stat $?