#!/bin/bash

# This script creates an internet gateway

# Create an internet gateway
echo "Creating an internet gateway"
sleep_time

igw_id=$(
    aws ec2 create-internet-gateway \
        --query 'InternetGateway.InternetGatewayId' \
        --output text \
        --region $region
)

check_success "Internet Gateway created with id: $igw_id" "Internet Gateway creation failed"

# Add Name tag to the internet gateway

create_tags $igw_id $igw_name
check_success "Internet Gateway tagged with Name: $igw_name" "Internet Gateway tagging failed"

# Attach the internet gateway to the VPC

echo "Attaching the internet gateway to the VPC"
sleep_time

aws ec2 attach-internet-gateway \
    --vpc-id $vpc_id \
    --internet-gateway-id $igw_id \
    --region $region \
    --output text

check_success "Internet Gateway attached to VPC" "Internet Gateway attachment failed"
