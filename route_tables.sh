#!/bin/bash

# This scripts contains route table configurations

main_route_table_id=$(
    aws ec2 describe-route-tables \
        --filters Name=vpc-id,Values=$vpc_id \
        --query 'RouteTables[*].RouteTableId' \
        --output text \
        --region $region
)

echo "Fetch Main Route Table With ID: $main_route_table_id"
sleep_time

# Name the Main Route Table
create_tags $main_route_table_id $main_route_table_name
check_success "Main Route Table tagged with Name: $main_route_table_name" "Main Route Table tagging failed"
sleep_time

# Create public route tables

public_route_table_id=$(create_route_table $vpc_id)
check_success "Public Route Table created with id: $public_route_table_id" "Public Route Table creation failed"
sleep_time

# Name the Public Route Table
create_tags $public_route_table_id $public_route_table_name
check_success "Public Route Table tagged with Name: $public_route_table_name" "Public Route Table tagging failed"
sleep_time

# Edit the public route table to add a route to the internet gateway

echo "Adding route to the internet gateway in the public route table"
create_route $public_route_table_id $igw_id
check_success "Route to the internet gateway added to the public route table" "Route addition to the public route table failed"
sleep_time

# Create private route tables

private_route_table_id_2a=$(create_route_table $vpc_id)
check_success "Private Route Table created with id: $private_route_table_id_2a" "Private Route Table 2a creation failed"
sleep_time

# Name the Private Route Table
create_tags $private_route_table_id_2a $private_route_table_name_2a
check_success "Private Route Table 2a tagged with Name: $private_route_table_name_2a" "Private Route Table 2a tagging failed"
sleep_time

# Edit the private route table to add a route to the NAT gateway

echo "Adding route to the NAT gateway in the private route table 2a"
create_route $private_route_table_id_2a $nat_gateway_id_2a
check_success "Route to the NAT gateway added to the private route table 2a" "Route addition to the private route table 2a failed"
sleep_time

# Create a second private route table

private_route_table_id_2b=$(create_route_table $vpc_id)
check_success "Private Route Table created with id: $private_route_table_id_2b" "Private Route Table 2b creation failed"

# Name the Private Route Table

create_tags $private_route_table_id_2b $private_route_table_name_2b
check_success "Private Route Table 2b tagged with Name: $private_route_table_name_2b" "Private Route Table 2b tagging failed"
sleep_time

# Edit the private route table to add a route to the NAT gateway

echo "Adding route to the NAT gateway in the private route table 2b"
create_route $private_route_table_id_2b $nat_gateway_id_2b
check_success "Route to the NAT gateway added to the private route table 2b" "Route addition to the private route table 2 failed"
sleep_time

# Associate the public route table with the public subnet

echo "Associating the public route table with the public subnet"
associate_route_table $public_subnet_2a_id $public_route_table_id
associate_route_table $public_subnet_2b_id $public_route_table_id
check_success "Public Route Table associated with the public subnet" "Public Route Table association with the public subnet failed"
sleep_time

# Associate the private route tables with the private subnets

echo "Associating the private route tables with the private subnets"
associate_route_table $private_subnet_2a_id $private_route_table_id_2a
associate_route_table $private_subnet_2b_id $private_route_table_id_2b
check_success "Private Route Tables associated with the private subnets" "Private Route Tables association with the private subnets failed"
sleep_time
