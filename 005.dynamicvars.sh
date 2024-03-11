#!/bin/bash

#Example Hardcoding-Not the right approach
#Date="11/MARCH/2024"
#No_OF_Sessions="4"

DATE="$(date +%F)"
No_OF_Sessions="$(who|wc -l)"
Team=$1
#Comments
echo -e "Todays date is ${DATE}"

echo -e "The script name is $0"

echo -e "The team name is ${TEAM}"

echo -e "The sessions is ${No_OF_Sessions}"
