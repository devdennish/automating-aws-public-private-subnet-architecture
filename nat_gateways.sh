#!/bin/bash

# This script creates a NAT gateway

# Allocate an Elastic IP address

echo "Allocating Elastic IP addresses for the NAT gateways"
sleep_time

eip_id_1=$(
    aws ec2 allocate-address \
        --domain vpc \
        --query 'AllocationId' \
        --output text \
        --region $region
)
check_success "Elastic IP address allocated with id: $eip_id_1" "Elastic IP address allocation failed"
sleep_time

eip_id_2=$(
    aws ec2 allocate-address \
        --domain vpc \
        --query 'AllocationId' \
        --output text \
        --region $region
)
check_success "Elastic IP address allocated with id: $eip_id_2" "Elastic IP address allocation failed"
sleep_time

# Create a NAT gateway
echo "Creating a NAT gateway"
sleep_time

nat_gateway_id_2a=$(
    aws ec2 create-nat-gateway \
        --subnet-id $public_subnet_2a_id \
        --allocation-id $eip_id_1 \
        --query 'NatGateway.NatGatewayId' \
        --output text \
        --region $region
)

check_success "NAT Gateway 1 created with id: $nat_gateway_id_2a" "NAT Gateway creation failed"
sleep_time

# Name the NAT gateway

create_tags $nat_gateway_id_2a $nat_gateway_name_2a
check_success "NAT Gateway tagged with Name: $nat_gateway_name_2a" "NAT Gateway tagging failed"
sleep_time

# Create a NAT gateway in the second public subnet

echo "Creating a NAT gateway in the second public subnet"

nat_gateway_id_2b=$(
    aws ec2 create-nat-gateway \
        --subnet-id $public_subnet_2b_id \
        --allocation-id $eip_id_2 \
        --query 'NatGateway.NatGatewayId' \
        --output text \
        --region $region
)
check_success "NAT Gateway 2 created with id: $nat_gateway_id_2a" "NAT Gateway creation failed"

# Name the NAT gateway
create_tags $nat_gateway_id_2b $nat_gateway_name_2b
check_success "NAT Gateway tagged with Name: $nat_gateway_name_2b" "NAT Gateway tagging failed"
sleep_time

# Check the NAT gateway status

echo "Checking the NAT gateway status:"
sleep_time

nat_gateway_status_2a=$(
    aws ec2 describe-nat-gateways \
        --nat-gateway-ids $nat_gateway_id_2a \
        --query 'NatGateways[*].State' \
        --output text \
        --region $region
)

nat_gateway_status_2b=$(
    aws ec2 describe-nat-gateways \
        --nat-gateway-ids $nat_gateway_id_2b \
        --query 'NatGateways[*].State' \
        --output text \
        --region $region
)

while [[ $nat_gateway_status_2a != "available" && $nat_gateway_status_2b != "available" ]]; do
    echo "NAT gateways are not available yet"
    sleep 30
    nat_gateway_status_2a=$(
        aws ec2 describe-nat-gateways \
            --nat-gateway-ids $nat_gateway_id_2a \
            --query 'NatGateways[*].State' \
            --output text \
            --region $region
    )

    nat_gateway_status_2b=$(
        aws ec2 describe-nat-gateways \
            --nat-gateway-ids $nat_gateway_id_2b \
            --query 'NatGateways[*].State' \
            --output text \
            --region $region
    )
done
echo "NAT gateways are available now"
sleep_time
