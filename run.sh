#!/bin/bash

python3 -m pip install --upgrade pip
pip3 install --upgrade boto
pip3 install --upgrade awscli

# ECSImageId=ami-09a41e26df464c548

# ubuntu image
ECSImageId=ami-08c40ec9ead489470

DefaultSecurityGroup=$(aws ec2 describe-security-groups --query "SecurityGroups[].GroupId" --filters Name=group-name,Values=default --output text)
echo $DefaultSecurityGroup
VpcId=$(aws ec2 describe-vpcs --query 'Vpcs'[0].VpcId --output text) #default VPC
echo $VpcId
Zone=$(aws ec2 describe-subnets --filters Name=availability-zone,Values=us-east-1* --query Subnets[0].AvailabilityZone --output text)
echo $Zone
SubnetId=$(aws ec2 describe-subnets --query 'Subnets'[0].SubnetId --output text) #default Subnet
echo $SubnetId

OldInstances=$(aws ec2 describe-instances --filters Name=instance-state-name,Values=running --query "Reservations[].Instances[].[InstanceId]" --output text)
echo $OldInstances
if [ "$OldInstances" != "" ]; then
    for instance in $OldInstances
    do
        # remove dependency to sg (which means we cant delete sg), this has to be done while the instance is running or stopped (not terminating)
        aws ec2 modify-instance-attribute --instance-id $instance --groups $DefaultSecurityGroup
    done
    aws ec2 terminate-instances --instance-ids $OldInstances
fi

SecurityGroup=$(aws ec2 describe-security-groups --query "SecurityGroups[].GroupId" --filter "Name=group-name,Values=tp2-group" --output text)

if [ "$SecurityGroup" != "" ]; then
    OldGroups=$(aws ec2 describe-security-groups --query "SecurityGroups[].GroupId" --output text)
    for group in $OldGroups
    do
        if [ "$group" != "$DefaultSecurityGroup" ]; then
            aws ec2 delete-security-group --group-id $group
        fi
        sleep 10
    done
    SecurityGroup=$(aws ec2 create-security-group --description "tp2-group" --group-name tp2-group --output text)
    # enable inbound ssh to debug and vnc
    aws ec2 authorize-security-group-ingress --group-id $SecurityGroup --protocol tcp --port 22 --cidr 0.0.0.0/0
    aws ec2 authorize-security-group-ingress --group-id $SecurityGroup --protocol tcp --port 80 --cidr 0.0.0.0/0
    aws ec2 authorize-security-group-ingress --group-id $SecurityGroup --protocol tcp --port 1186 --cidr 0.0.0.0/0
    aws ec2 authorize-security-group-ingress --group-id $SecurityGroup --protocol tcp --port 2202 --cidr 0.0.0.0/0
    aws ec2 authorize-security-group-ingress --group-id $SecurityGroup --protocol tcp --port 3306 --cidr 0.0.0.0/0
    #aws ec2 authorize-security-group-ingress --group-id $SecurityGroup --protocol tcp --port (5900-5910) --cidr 0.0.0.0/0

    # for downloads, enable http/https outbound
    aws ec2 authorize-security-group-egress --group-id $SecurityGroup --protocol tcp --port 80 --cidr 0.0.0.0/0
    aws ec2 authorize-security-group-egress --group-id $SecurityGroup --protocol tcp --port (49152-65535) --cidr 0.0.0.0/0
    aws ec2 authorize-security-group-egress --group-id $SecurityGroup --protocol tcp --port 1186 --cidr 0.0.0.0/0
    aws ec2 authorize-security-group-egress --group-id $SecurityGroup --protocol tcp --port 2202 --cidr 0.0.0.0/0
    aws ec2 authorize-security-group-egress --group-id $SecurityGroup --protocol tcp --port 3306 --cidr 0.0.0.0/0
    # aws ec2 authorize-security-group-egress --group-id $SecurityGroup --protocol tcp --port 443 --cidr 0.0.0.0/0
fi

# Launching MySQL instance
t2Micro="$(aws ec2 run-instances --image-id $ECSImageId --count 1 --instance-type t2.micro --security-group-ids $SecurityGroup --key-name vockey --user-data file://install_mysql.sh --placement AvailabilityZone=$Zone --query "Instances[].[InstanceId]" --output text)"
echo $t2Micro

t2Master="$(aws ec2 run-instances --image-id $ECSImageId --count 1 --instance-type t2.small --security-group-ids $SecurityGroup --key-name vockey --user-data file://setup_master.sh --placement AvailabilityZone=$Zone --subnet-id=$SubnetId --query "Instances[].[InstanceId]" --output text)"
echo $t2Master
t2Slaves="$(aws ec2 run-instances --image-id $ECSImageId --count 3 --instance-type t2.small --security-group-ids $SecurityGroup --key-name vockey --user-data file://setup_slave.sh --placement AvailabilityZone=$Zone --subnet-id=$SubnetId --query "Instances[].[InstanceId]" --output text)"
echo $t2Slaves

masterAddrList=$(aws ec2 describe-instances --instance-id $t2Master --query "Reservations[].Instances[].PublicIpAddress[]")
slavesAddrList=$(aws ec2 describe-instances --instance-id $t2Slaves --query "Reservations[].Instances[].PublicIpAddress[]")
masterPrvAddrList=$(aws ec2 describe-instances --instance-id $t2Master --query "Reservations[].Instances[].PrivateIpAddress[]")
slavesPrvAddrList=$(aws ec2 describe-instances --instance-id $t2Slaves --query "Reservations[].Instances[].PrivateIpAddress[]")

echo $masterAddrList
echo $masterPrvAddrList
echo $slavesAddrList
echo $slavesPrvAddrList
