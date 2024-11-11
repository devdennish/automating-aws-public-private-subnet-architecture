#!/bin/bash

target_group_arn=$(
    aws elbv2 create-target-group \
        --name $target_group_name \
        --protocol HTTP \
        --port 80 \
        --target-type instance \
        --vpc-id $vpc_id \
        --query 'TargetGroups[0].TargetGroupArn' \
        --output text
)

check_success "Target group created with arn: $target_group_arn" "Target group creation failed"

# Register the targets with the target group
echo "Wait for the target group to be fully provisioned"
sleep 20

echo "Registering the targets with the target group"
sleep 5
for instance_id in $instance_ids; do
    aws elbv2 register-targets \
        --target-group-arn $target_group_arn \
        --targets Id=$instance_id
done

check_success "Targets registered with the target group" "Target registration failed"
