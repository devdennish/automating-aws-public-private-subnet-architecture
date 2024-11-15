#!/bin/bash

# This is the main script that will call the other scripts

# Start the script
echo "Starting the script"
sleep 2

# Load the vpc script
source vpc.sh

# Load the subnets script
source subnets.sh

# Load the internet gateway script
source igw.sh

# Load the nat gateways script
source nat_gateways.sh

# Load the route tables script
source route_tables.sh

# Load the security group script
source security_group.sh

# Load the key pair script
source key_pair.sh

# Load the launch template script
source launch_template.sh

# Load the auto scaling group script
source auto_scaling_group.sh

# Load the target group script
source target_group.sh

# Load the load balancer script
source load_balancer.sh
