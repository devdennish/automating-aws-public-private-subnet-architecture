#!/bin/bash

# This script will create a load balancer

# Create a load balancer
lb_arn=$(
    aws elbv2 create-load-balancer \
        --name $lb_name \
        --subnets $public_subnet_2a_id $public_subnet_2b_id \
        --security-groups $security_group_id \
        --scheme internet-facing \
        --type application \
        --ip-address-type ipv4 \
        --tags Key=Name,Value=$lb_name \
        --query 'LoadBalancers[0].LoadBalancerArn' \
        --output text
)

echo "Load balancer ARN: $lb_arn"
# check_success "Load balancer created with arn: $lb_arn" "Load balancer creation failed"

# Create a listener for the load balancer

listener_arn=$(
    aws elbv2 create-listener \
        --load-balancer-arn $lb_arn \
        --protocol HTTP \
        --port 80 \
        --default-actions Type=forward,TargetGroupArn=$target_group_arn \
        --query 'Listeners[0].ListenerArn' \
        --output text
)

check_success "Listener created with arn: $listener_arn" "Listener creation failed"
sleep_time

echo "Wait while load balancer is provisioned"
sleep 10

# Attach the load balancer to auto scaling group

echo "Attaching the load balancer to the auto scaling group"
sleep 5

aws autoscaling attach-load-balancer-target-groups \
    --auto-scaling-group-name $auto_scaling_group_name \
    --target-group-arns $target_group_arn

check_success "Load balancer attached to the auto scaling group" "Load balancer attachment failed"
