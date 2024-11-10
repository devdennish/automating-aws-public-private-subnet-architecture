#!/bin/bash

# Import global variables

source global_variables.sh

# Sleep Function

sleep_time() {
    sleep 2
}

# Create Tags Function

create_tags() {
    aws ec2 create-tags \
        --resources $1 \
        --tags Key=Name,Value=$2 \
        --region $region

}

# Exit Code Check Function

check_success() {
    if [ $? -eq 0 ]; then
        echo $1
    else
        echo $2
        exit 1
    fi
}

# DNS Support Function

enable_dns_support() {
    aws ec2 modify-vpc-attribute \
        --vpc-id $1 \
        --enable-dns-support \
        --region $region
}

# DNS Hostnames Function

enable_dns_hostnames() {
    aws ec2 modify-vpc-attribute \
        --vpc-id $1 \
        --enable-dns-hostnames \
        --region $region
}

# Create Subnet Function

create_subnet() {
    aws ec2 create-subnet \
        --vpc-id $1 \
        --cidr-block $2 \
        --availability-zone $3 \
        --query 'Subnet.SubnetId' \
        --output text \
        --region $region
}

# Enable Auto-Assign Public IP Function on Subnet

enable_auto_assign_public_ip() {
    aws ec2 modify-subnet-attribute \
        --subnet-id $1 \
        --map-public-ip-on-launch \
        --region $region
}

# Create Route Table Function

create_route_table() {
    aws ec2 create-route-table \
        --vpc-id $1 \
        --query 'RouteTable.RouteTableId' \
        --output text \
        --region $region
}

create_route() {
    aws ec2 create-route \
        --route-table-id $1 \
        --destination-cidr-block 0.0.0.0/0 \
        --gateway-id $2 \
        --region ap-southeast-2 \
        >/dev/null

}

# Associate Route Table Function

associate_route_table() {
    aws ec2 associate-route-table \
        --subnet-id $1 \
        --route-table-id $2 \
        --region $region \
        >/dev/null

}
