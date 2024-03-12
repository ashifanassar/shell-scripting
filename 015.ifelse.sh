#!/bin/bash

echo -e "Demo of If else, else if condition usage"

ACTION=$1

if["$ACTION" = "start"] ; then
    echo -e "Starting the service"
    exit 0

elif["$ACTION" = "stop"] ; then
    echo -e "stopping the service"
    exit 1

elif["$ACTION" = "restart"] ; then
    echo -e "restarting the service"
    exit 2
else
    echo -e "This is not the option"
    exit 3
fi