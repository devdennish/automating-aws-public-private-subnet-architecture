#!/bin/bash

# This script will launch the template

# Create a launch template for EC2 Auto Scaling

lt_id=$(
    aws ec2 create-launch-template \
        --launch-template-name BashTemplateForAutoScaling \
        --version-description "Version 1" \
        --launch-template-data '
    {
  "ImageId": "ami-001f2488b35ca8aad",
  "InstanceType": "t2.micro",
  "UserData":"'$(cat user_data.sh | base64)'",
  "KeyName": "'$key_name'",
  "TagSpecifications": [
    {
      "ResourceType": "instance",
      "Tags": [
        {
          "Key": "environment",
          "Value": "production"
        },
        {
          "Key": "purpose",
          "Value": "webserver"
        }
      ]
    },
    {
      "ResourceType": "volume",
      "Tags": [
        {
          "Key": "environment",
          "Value": "production"
        },
        {
          "Key": "cost-center",
          "Value": "cc123"
        }
      ]
    }
  ],
  "BlockDeviceMappings": [
    {
      "DeviceName": "/dev/sda1",
      "Ebs": {
        "VolumeSize": 100
      }
    }
  ],
  "NetworkInterfaces": [
    {
      "DeviceIndex": 0,
      "AssociatePublicIpAddress": true,
      "Groups": ["'$security_group_id'", "'$security_group_id'"],
      "DeleteOnTermination": true
    }
  ]
}' \
        --region ap-southeast-2 \
        --query 'LaunchTemplate.LaunchTemplateId' \
        --output text
)
check_success "Launch template created with id: $lt_id" "Failed to create launch template"
