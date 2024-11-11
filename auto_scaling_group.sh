#!/bin/bash

# This script will create an auto scaling group

#--target-group-arns "$target_group_arn"

# Create an auto scaling group

aws autoscaling create-auto-scaling-group \
    --auto-scaling-group-name $auto_scaling_group_name \
    --launch-template "LaunchTemplateName=BashTemplateForAutoScaling, Version=1" \
    --min-size 1 \
    --max-size 3 \
    --desired-capacity 2 \
    --vpc-zone-identifier "$private_subnet_2a_id,$private_subnet_2b_id"

check_success "Auto scaling group created" "Auto scaling group creation failed"
sleep_time

# Query the instances in the auto scaling group
echo "Querying the instances in the auto scaling group"
sleep 10

instance_ids=$(
    aws autoscaling describe-auto-scaling-groups \
        --auto-scaling-group-names $auto_scaling_group_name \
        --query 'AutoScalingGroups[0].Instances[*].InstanceId' \
        --output text
)
check_success "Instances in the auto scaling group queried: $instance_ids" "Failed to query instances in the auto scaling group"
