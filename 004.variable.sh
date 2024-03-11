#!/bin/bash

#Variable is something that holds the datathat needs to be passed to the script

#Declaring the variables

a=10
b=def
CUSTDATA="scripting"

#Bash treats everything as variable

#Refer a variable to print $var

echo $a
echo ${b}

#Printing a variable where it is not declared is treated as null charater

#rm -rf /data/proc/${CUSTDATA}  ===>substitutes as /data/proc/shipping  as declared above
#rm -rf /data/proc/${APPDATA}   ===>substituutes as null /data/proc/
