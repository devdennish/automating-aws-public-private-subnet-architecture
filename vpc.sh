#!/bin/bash

# This script creates a VPC an

# Load the global variables
source global_variables.sh

# Load the global functions
source global_functions.sh

# Create the VPC
echo "Creating VPC: $vpc_name"
sleep_time

vpc_id=$(
    aws ec2 create-vpc \
        --cidr-block $vpc_cidr_block \
        --region $region \
        --query 'Vpc.VpcId' \
        --output text
)
check_success "VPC created with id: $vpc_id" "VPC creation failed"

# Add Name tag to the VPC

create_tags $vpc_id $vpc_name
check_success "VPC tagged with Name: $vpc_name" "VPC tagging failed"

# Enable DNS support in the VPC

enable_dns_support $vpc_id
check_success "DNS support enabled in VPC: $vpc_name" "DNS support enabling failed"

# Enable DNS hostnames in the VPC
enable_dns_hostnames $vpc_id
check_success "DNS hostnames enabled in VPC: $vpc_name" "DNS hostnames enabling failed"
