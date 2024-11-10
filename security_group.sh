#!/bin/bash

# This script creates security groups

# Create a security group

echo "Creating a security group"
sleep_time

security_group_id=$(
    aws ec2 create-security-group \
        --group-name $security_group_name \
        --description "$security_group_desc" \
        --vpc-id $vpc_id \
        --query 'GroupId' \
        --output text \
        --region $region
)
check_success "Security group created with id:$security_group_id" "Failed to create security group"

# Add a rule to the security group

echo "Adding rules to the security group"
sleep_time

aws ec2 authorize-security-group-ingress \
    --group-id $security_group_id \
    --ip-permissions file://ingress.json \
    --region ap-southeast-2 \
    >/dev/null

check_success "Rules added to security group" "Failed to add rule to security group"
