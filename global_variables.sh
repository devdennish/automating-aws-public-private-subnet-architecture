#!/bin/bash

# This script contains global variables

# Global variables
vpc_name="BashVPC"
vpc_cidr_block="10.0.0.0/16"
region="ap-southeast-2"
az_1="ap-southeast-2a"
az_2="ap-southeast-2b"
public_2a_cidr_block="10.0.1.0/24"
private_2a_cidr_block="10.0.2.0/24"
public_2b_cidr_block="10.0.3.0/24"
private_2b_cidr_block="10.0.4.0/24"
main_route_table_name="Main-Route-Table"
public_route_table_name="Public-Route-Table"
private_route_table_name_2a="Private-Route-Table-2a"
private_route_table_name_2b="Private-Route-Table-2b"
igw_name="Bash-IGW"
nat_gateway_name_2a="Bash-NAT-Gateway-2a"
nat_gateway_name_2b="Bash-NAT-Gateway-2b"
security_group_name="Bash-Security-Group"
security_group_desc="Allows SSH, HTTP, HTTPS, and ICMP traffic"
