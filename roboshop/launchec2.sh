#!/bin/bash
#This is the script to create an ec2 instance

AMI_ID="ami-072983368f2a6eab5"
SGID="sg-0ea84c81ce84682ff"    
COMPONENT=$1
HOSTED_ZONE="Z0547409165EGAKUG3EH3"
COLOR="\e[37m]"
NOCOLOUR="\e[0m"
ENV=$2


if [ -z $1 ] || [ -z $2] ; then
    echo -e "\e[31m   COMPONENT NAME IS NEEDED: \e[0m"
    echo -e "\e[36m \t\t Example Usage : \e[0m  bash launch-ec2 ratings"
    exit 1
fi 


if [ -x $1 ] ; then
    echo -e "\e[31m component name is needed \e[0m"
    echo -e "\e[36m \t example usage \e[0m"
    exit 1
fi




EC2_FUN()
{
PRIVATE_IP=$(aws ec2 run-instances --image-id $AMI_ID --instance-type t3.micro --security-group-ids $SGID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}-${ENV}}]" | jq .Instances[].PrivateIpAddress |sed -e 's/"//g')
echo "$COLOR $1-$2 Server Created and here is the IP ADDRESS $PRIVATE_IP $NOCOLOR"

echo "Creating r53 json file with component name and ip address:"
sed -e "s/IPADDRESS/${PRIVATE_IP}/g" -e "s/COMPONENT/${COMPONENT}-${ENV}/g" route53.json > /tmp/dns.json

echo "Creating DNS Record for $COMPONENT :"
aws route53 change-resource-record-sets --hosted-zone-id ${HOSTED_ZONE} --change-batch file:///tmp/dns.json 
}

#To create the components
if [ $1 = all ] ; then
    for x in frontend mongodb catalogue user redis cart mysql shipping rabbitmq payment; do
    COMPONENT=$x
    EC2_FUN
    done
else
    EC2_FUN
fi