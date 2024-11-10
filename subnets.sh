#!/bin/bash

# This script creates subnets

# Create the public subnets in Availability Zone 1

echo "Creating public subnets in $az_1"
sleep_time

public_subnet_2a_id=$(
    create_subnet $vpc_id $public_2a_cidr_block $az_1
)
check_success "Public Subnet 2a created with id: $public_subnet_2a_id" "Public Subnet 2a creation failed"

# Add Name tag to the public subnet 1

create_tags $public_subnet_2a_id "Public-Subnet-2a"
check_success "Public Subnet 2a tagged with Name: Public-Subnet-2a" "Public Subnet 2a tagging failed"

# Create Private Subnet 1 in Availability Zone 1

echo "Creating private subnet in $az_1"
sleep_time

private_subnet_2a_id=$(
    create_subnet $vpc_id $private_2a_cidr_block $az_1
)
check_success "Private Subnet 2a created with id: $private_subnet_2a_id" "Private Subnet 2a creation failed"

# Add Name tag to the private subnet 1

create_tags $private_subnet_2a_id "Private-Subnet-2a"
check_success "Private Subnet 2a tagged with Name: Private-Subnet-2a" "Private Subnet 2a tagging failed"

# Create the public subnets in Availability Zone 2

echo "Creating public subnets in $az_2"
sleep_time

public_subnet_2b_id=$(
    create_subnet $vpc_id $public_2b_cidr_block $az_2
)
check_success "Public Subnet 2b created with id: $public_subnet_2b_id" "Public Subnet 2b creation failed"

# Add Name tag to the public subnet 2

create_tags $public_subnet_2b_id "Public-Subnet-2b"
check_success "Public Subnet 2b tagged with Name: Public-Subnet-2b" "Public Subnet 2b tagging failed"

# Create Private Subnet 2 in Availability Zone 2

echo "Creating private subnet in $az_2"
sleep_time

private_subnet_2b_id=$(
    create_subnet $vpc_id $private_2b_cidr_block $az_2
)
check_success "Private Subnet 2b created with id: $private_subnet_2b_id" "Private Subnet 2b creation failed"

# Add Name tag to the private subnet 2

create_tags $private_subnet_2b_id "Private-Subnet-2b"
check_success "Private Subnet 2b tagged with Name: Private-Subnet-2b" "Private Subnet 2b tagging failed"

# Enable auto-assign public IP on the public subnets

echo "Enabling auto-assign public IP on the public subnets"
sleep_time

enable_auto_assign_public_ip $public_subnet_2a_id
check_success "Auto-assign public IP enabled on Public Subnet 2a" "Auto-assign public IP enabling failed on Public Subnet 2a"

enable_auto_assign_public_ip $public_subnet_2b_id
check_success "Auto-assign public IP enabled on Public Subnet 2b" "Auto-assign public IP enabling failed on Public Subnet 2b"
