#!/bin/bash
if [ -z "$1" ]; then
  echo -e "\e[31mInput machine name is needed\e[0m"
  exit 1
fi

COMPONENT=$1
ZONE_ID="Z07840263P1VQXP880Q8W"
create_ec2() {
  PRIVATE_IP=$(aws ec2 run-instances \
      --image-id ${AMI_ID} \
      --instance-type t2.micro \
      --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]" \
      --instance-market-options "MarketType=spot,SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}" \
      --security-group-ids ${SG_ID} \
      | jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')
  sed -e "s/IPADDRESS/${PRIVATE_IP}/" -e "s/COMPONENT/${COMPONENT}/" route53.json >/tmp/record.json
  aws route53 change-resource-record-sets --hosted-zone-id ${ZONE_ID} --change-batch file:///tmp/record.json | jq
}

AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=Centos-7-DevOps-Practice" | jq '.Images[].ImageId' | sed -e 's/"//g')
SG_ID=$(aws ec2 describe-security-groups --filters "Name=group-name,Values=allow all traffic from public" | jq ".SecurityGroups[].GroupId" | sed -e 's/"//g')
if [ "$1" == "all" ]; then
  for component in frontend catalogue user mondodb redis cart rabbitmq mysql shipping payment dispatch; do
    COMPONENT=$component
    create_ec2
    done
else
  create_ec2
fi


