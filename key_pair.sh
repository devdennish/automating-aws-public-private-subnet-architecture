#!/bin/bash

# This script will create a key pair and store the private key in a file

# Create a Key Pair

key_value=$(
    aws ec2 create-key-pair \
        --key-name $key_name \
        --query 'KeyMaterial' \
        --region "ap-southeast-2" \
        --output text

)

# Check if the Key Pair was created successfully

check_success "Key Pair created with name: $key_name" "Key Pair creation failed"
sleep 2

# Store the private key in a file

echo "$key_value" >$(pwd)/$key_file

# Check if the private key was stored in the file

check_success "Private key stored in file: $key_file" "Failed to store the private key in file"
sleep 2

# Change the permissions of the private key file

chmod 400 $(pwd)/$key_file

# Display the success message

check_success "Private key file permissions changed successfully" "Failed to change the permissions of the private key file"
