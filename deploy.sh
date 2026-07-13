#!/bin/bash
'''
1. Login to AWS
2. Create vpc and assign subnets
'''

################################
#          Login to AWS        #
################################

echo "Logging in to AWS..."
echo "Checking if AWS access keys are set..."
if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
  echo "AWS access keys are not set. Please set AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY environment variables."
  exit 1
fi

################################
#          Create VPC          #
################################

VPC_NAME="journal-api-vpc"
CIDR="10.16.0.0/16"
REGION="us-east-1"

echo "Checking if VPC '$VPC_NAME' exists in region '$REGION'..."
VPC_ID=$(aws ec2 describe-vpcs \
--filters "Name=tag:Name,Values=$VPC_NAME" \
--region $REGION \
--query "Vpcs[0].VpcId" \
--output text)

if ["$VPC_ID" == "None" ] || [-z "$VPC_ID" ]; then
    echo "VPC does not exist. Creating VPC..."
    VPC_ID=$(aws ec2 create-vpc \
    --cidr-block $CIDR \
    --tag-specifications "ResourceType=vpc,Tags=[{Key=Name,Value=$VPC_NAME}]" \
    --region $REGION \
    --output text) && echo "VPC $VPC_ID created successfully."
    echo "Creating subnets..."
    # Create subnets
    aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.16.0.0/16
else
    echo "VPC '$VPC_NAME' already exists with ID: $VPC_ID"
fi