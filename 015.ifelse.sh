#!/bin/bash 

echo -e "Demo on if, if else, else if conditions Usage"

ACTION=$1

if [ "$ACTION" = "start" ] ; then

    echo "start the service"
    exit 0

elif [ "$ACTION" = "stop"] ; then
 
    echo "Stop the service"
    exit 1

elif [ "$ACTION" = "restart" ] ; then

    echo "Restart the service"
    exit 2

else
    echo "None of the option"
    exit 3

fi