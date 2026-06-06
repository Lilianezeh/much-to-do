#!/bin/bash
set -e
echo "Rolling back to previous version..."
ASG_NAME=$(aws autoscaling describe-auto-scaling-groups \
  --query "AutoScalingGroups[?contains(Tags[?Key=='Name'].Value, 'starttech')].AutoScalingGroupName" \
  --output text)
aws autoscaling cancel-instance-refresh \
  --auto-scaling-group-name $ASG_NAME || true
echo "Rollback initiated!"