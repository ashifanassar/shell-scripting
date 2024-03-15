#!/bin/bash



COMPONENT="catalogue"
source components/common.sh  #Source has all the funtions




Nodejs() #check in the common.sh file



echo -e "status of the $COMPONENT"
systemctl status $COMPONENT -l