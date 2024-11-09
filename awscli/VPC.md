# Set Variables

VPC_CIDR=192.168.0.0/24

SUBNET_CIDR_PUBLIC=192.168.0.0/25

SUBNET_CIDR_PRIVATE=192.168.0.128/25

REGION=eu-central-1

KEY_NAME=my-key

AMI_ID=ami-0454f4f50998826d6

INSTANCE_TYPE=t3.micro

WEB_SG_NAME=web-sg

DB_SG_NAME=db-sg

WEB_NAME=web-instance

DB_NAME=db-instance


# Create VPC and Subnets

## Create VPC
VPC_ID=$(aws ec2 create-vpc --cidr-block $VPC_CIDR --query 'Vpc.VpcId' --output text --region $REGION)


## Add tags
aws ec2 create-tags --resources $VPC_ID --tags Key=Name,Value=my-vpc --region $REGION


## Make Internet Gateway
IGW_ID=$(aws ec2 create-internet-gateway --query 'InternetGateway.InternetGatewayId' --output text --region $REGION)


## Attach Internet Gateway to VPC
aws ec2 attach-internet-gateway --vpc-id $VPC_ID --internet-gateway-id $IGW_ID --region $REGION


## Create a routing table
ROUTE_TABLE_ID=$(aws ec2 create-route-table --vpc-id $VPC_ID --query 'RouteTable.RouteTableId' --output text --region $REGION)


## Create a route to access the Internet
aws ec2 create-route --route-table-id $ROUTE_TABLE_ID --destination-cidr-block 0.0.0.0/0 --gateway-id $IGW_ID --region $REGION
```
{
    "Return": true
}
```


## Create a public subnet
PUBLIC_SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $SUBNET_CIDR_PUBLIC --query 'Subnet.SubnetId' --output text --region $REGION)


## Add the public subnet to the routing table
aws ec2 associate-route-table --subnet-id $PUBLIC_SUBNET_ID --route-table-id $ROUTE_TABLE_ID --region $REGION
```
{
    "AssociationId": "rtbassoc-0f3b42d4883912b97",
    "AssociationState": {
        "State": "associated"
    }
}
```


## Enable automatic assignment of public IP addresses for the subnet
aws ec2 modify-subnet-attribute --subnet-id $PUBLIC_SUBNET_ID --map-public-ip-on-launch --region $REGION


## Create a private subnet
PRIVATE_SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $SUBNET_CIDR_PRIVATE --query 'Subnet.SubnetId' --output text --region $REGION)



# Security Groups configs

## Create sg-FRONT
WEB_SG_ID=$(aws ec2 create-security-group --group-name $WEB_SG_NAME --description "SG for web server" --vpc-id $VPC_ID --query 'GroupId' --output text --region $REGION)


## Allow TCP 22 (SSH) incoming traffic
aws ec2 authorize-security-group-ingress --group-id $WEB_SG_ID --protocol tcp --port 22 --cidr 0.0.0.0/0 --region $REGION
```
{
    "Return": true,
    "SecurityGroupRules": [
        {
            "SecurityGroupRuleId": "sgr-047cb4e532f08a8ae",
            "GroupId": "sg-0ec1f2cdd8f5c844b",
            "GroupOwnerId": "432293819022",
            "IsEgress": false,
            "IpProtocol": "tcp",
            "FromPort": 22,
            "ToPort": 22,
            "CidrIpv4": "0.0.0.0/0"
        }
    ]
}
```


## Create sg-BACK
DB_SG_ID=$(aws ec2 create-security-group --group-name $DB_SG_NAME --description "SG for DB" --vpc-id $VPC_ID --query 'GroupId' --output text --region $REGION)


## Allow incoming traffic only from sg-FRONT
aws ec2 authorize-security-group-ingress --group-id $DB_SG_ID --protocol tcp --port 3306 --source-group $WEB_SG_ID --region $REGION
```
{
    "Return": true,
    "SecurityGroupRules": [
        {
            "SecurityGroupRuleId": "sgr-0099a2dcf949cf79f",
            "GroupId": "sg-05bc4285e09422baa",
            "GroupOwnerId": "432293819022",
            "IsEgress": false,
            "IpProtocol": "tcp",
            "FromPort": 3306,
            "ToPort": 3306,
            "ReferencedGroupInfo": {
                "GroupId": "sg-0ec1f2cdd8f5c844b",
                "UserId": "432293819022"
            }
        }
    ]
}
```


# Create EC2 Instances

## Create key
aws ec2 create-key-pair --key-name my-key --query 'KeyMaterial' --output text --region $REGION > my-key.pem


## Create Web instance
WEB_INSTANCE_ID=$(aws ec2 run-instances --image-id $AMI_ID --count 1 --instance-type $INSTANCE_TYPE --key-name $KEY_NAME --security-group-ids $WEB_SG_ID --subnet-id $PUBLIC_SUBNET_ID --query 'Instances[0].InstanceId' --output text --region $REGION)


## Create DB Instance
DB_INSTANCE_ID=$(aws ec2 run-instances --image-id $AMI_ID --count 1 --instance-type $INSTANCE_TYPE --key-name $KEY_NAME --security-group-ids $DB_SG_ID --subnet-id $PRIVATE_SUBNET_ID --query 'Instances[0].InstanceId' --output text --region $REGION)


## Change permissions to key
chmod 400 my-key.pem


## Set variable WEB_INSTANCE_PUBLIC_IP
WEB_INSTANCE_PUBLIC_IP=$(aws ec2 describe-instances --instance-ids $WEB_INSTANCE_ID --query 'Reservations[0].Instances[0].PublicIpAddress' --output text --region $REGION)


## Create ssh config file
nano .ssh/config

Host web-host
    HostName 18.198.25.236
    User ubuntu
    IdentityFile ~/my-key.pem

Host db-host
    HostName 192.168.0.157
    User ubuntu
    IdentityFile ~/my-key.pem
    ProxyJump web-host


## Connect with ssh to DB instance
ssh db-host


## Connect with ssh to Web instance
ssh web-host



# Additional task

## Add AMI for DB instance
aws ec2 create-image --instance-id $DB_INSTANCE_ID --name "MySQL-AMI" --no-reboot --region $REGION
```
{
    "ImageId": "ami-0a30a905adb7ccb52"
}
```

## Connect to DB Instance
ssh db-host


## Create sh script dor db install

nano userdata.sh

#!/bin/bash

apt update

apt install python3-pip default-libmysqlclient-dev build-essential

pkg-config

mysql -e "CREATE USER IF NOT EXISTS 'admin'@'%' IDENTIFIED BY 'Pa55WD';"

mysql -e "CREATE DATABASE flask_db;"

mysql -e "GRANT ALL ON flask_db.* TO 'admin'@'%';"

mysql -e "FLUSH PRIVILEGES;"


## Connect to Web Instance
ssh web-host


## Install db
sudo apt install -y mysql-server

sudo systemctl start mysql

sudo mysql_secure_installation

sudo mysql

CREATE DATABASE flask_db;

CREATE USER 'admin'@'%' IDENTIFIED BY 'Pa55WDVVV

GRANT ALL PRIVILEGES ON flask_db.* TO 'admin'@'%';

FLUSH PRIVILEGES;

EXIT;


## Run Project
git clone https://github.com/saaverdo/flask-alb-app -b orm

cd flask-alb-app

sudo apt install pip

pip install virtualenv

python3 -m venv venv

source venv/bin/activate

sudo pip install -r requirements.txt

export FLASK_CONFIG=mysql

export MYSQL_USER="admin"

export MYSQL_PASSWORD="Pa55WDVVV"

export MYSQL_DB="flask_db"

export MYSQL_HOST=192.168.0.157

gunicorn -b 0.0.0.0:8000 appy:app

```
[2024-10-23 17:03:09 +0000] [9463] [INFO] Starting gunicorn 23.0.0
[2024-10-23 17:03:09 +0000] [9463] [INFO] Listening at: http://0.0.0.0:8000 (9463)
[2024-10-23 17:03:09 +0000] [9463] [INFO] Using worker: sync
[2024-10-23 17:03:09 +0000] [9464] [INFO] Booting worker with pid: 9464
config = default
creating app with config = default
```