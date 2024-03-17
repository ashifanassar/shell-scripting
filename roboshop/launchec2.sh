#!/bin/bash
#This is the script to create an ec2 instance

AMI_ID="ami-072983368f2a6eab5"
SGID="sg-0ea84c81ce84682ff"    
COMPONENT=$1
HOSTED_ZONE=Z0547409165EGAKUG3EH3


if [ -z $1 ] ; then
    echo -e "\e[31m   COMPONENT NAME IS NEEDED: \e[0m"
    echo -e "\e[36m \t\t Example Usage : \e[0m  bash launch-ec2 ratings"
    exit 1
fi 


#
PRIVATE_IP=$(aws ec2 run-instances --image-id $AMI_ID --instance-type t3.micro --security-group-ids $SGID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$COMPONENT}]" | jq .Instances[].PrivateIpAddress |sed -e 's/"//g')
echo "$1 Server Created and here is the IP ADDRESS $PRIVATE_IP"
echo "Creating r53 json file with component name and ip address:"

# echo -e 



# echo "Creating the DNS record"
# aws route53 change-resource-record-sets --hosted-zone-id ${HOSTED_ZONE} --change-batch file://