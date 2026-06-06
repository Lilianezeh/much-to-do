#!/bin/bash
set -e
echo "Deploying backend..."
ASG_NAME=$(aws autoscaling describe-auto-scaling-groups \
  --query "AutoScalingGroups[?contains(Tags[?Key=='Name'].Value, 'starttech')].AutoScalingGroupName" \
  --output text)
aws autoscaling start-instance-refresh \
  --auto-scaling-group-name $ASG_NAME \
  --preferences MinHealthyPercentage=50
echo "Backend deployment started!"